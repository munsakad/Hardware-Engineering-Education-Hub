from flask import Blueprint, jsonify, request
from mysql.connector import IntegrityError
from werkzeug.security import check_password_hash, generate_password_hash

from auth import create_token, require_auth
from db import execute, query_one

auth_bp = Blueprint("auth", __name__, url_prefix="/api/auth")


@auth_bp.post("/register")
def register():
    data = request.get_json(silent=True) or {}
    username = (data.get("username") or "").strip()
    email = (data.get("email") or "").strip().lower()
    password = data.get("password") or ""

    if not username or not email or len(password) < 8:
        return jsonify({"error": "username, email, and a password of at least 8 characters are required"}), 400

    password_hash = generate_password_hash(password)
    try:
        user_id = execute(
            "INSERT INTO users (username, email, password_hash) VALUES (%s, %s, %s)",
            (username, email, password_hash),
        )
    except IntegrityError:
        return jsonify({"error": "A user with that username or email already exists"}), 409

    token = create_token(user_id)
    return jsonify({"token": token, "user": {"id": user_id, "username": username, "email": email}}), 201


@auth_bp.post("/login")
def login():
    data = request.get_json(silent=True) or {}
    email = (data.get("email") or "").strip().lower()
    password = data.get("password") or ""

    user = query_one("SELECT id, username, email, password_hash FROM users WHERE email = %s", (email,))
    if not user or not check_password_hash(user["password_hash"], password):
        return jsonify({"error": "Invalid email or password"}), 401

    token = create_token(user["id"])
    return jsonify({
        "token": token,
        "user": {"id": user["id"], "username": user["username"], "email": user["email"]},
    })


@auth_bp.get("/me")
@require_auth
def me():
    user = query_one("SELECT id, username, email, created_at FROM users WHERE id = %s", (request.user_id,))
    if not user:
        return jsonify({"error": "User not found"}), 404
    return jsonify(user)
