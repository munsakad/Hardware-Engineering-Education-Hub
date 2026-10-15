"""Quizzes, attempt history, and administrator content editing."""
import json
import os
import re
from functools import wraps
from html import escape
from pathlib import Path

from flask import Blueprint, jsonify, request
from auth import require_auth
from db import execute, query_all, query_one

learning_bp = Blueprint("learning", __name__, url_prefix="/api")
BANK = json.loads((Path(__file__).resolve().parents[2] / "frontend/data/quizzes.json").read_text(encoding="utf-8"))


def require_admin(view):
    @wraps(view)
    @require_auth
    def wrapped(*args, **kwargs):
        user = query_one("SELECT email FROM users WHERE id = %s", (request.user_id,))
        admins = {e.strip().lower() for e in os.getenv("ADMIN_EMAILS", "").split(",") if e.strip()}
        if not user or user["email"].lower() not in admins:
            return jsonify({"error": "Administrator access required"}), 403
        return view(*args, **kwargs)
    return wrapped


def valid_text(body, key, maximum, required=True):
    value = body.get(key, "")
    if not isinstance(value, str) or len(value.strip()) > maximum or (required and not value.strip()):
        raise ValueError(f"{key} must contain {'1' if required else '0'}–{maximum} characters")
    return value.strip()


@learning_bp.get("/quizzes/<slug>")
def get_quiz(slug):
    questions = BANK.get(slug)
    if not questions:
        return jsonify({"error": "No quiz available for this course"}), 404
    return jsonify({"questions": [{"prompt": q["prompt"], "options": q["options"]} for q in questions]})


@learning_bp.post("/quizzes/<slug>/attempts")
@require_auth
def submit_quiz(slug):
    questions = BANK.get(slug)
    if not questions:
        return jsonify({"error": "Quiz not found"}), 404
    answers = (request.get_json(silent=True) or {}).get("answers")
    if not isinstance(answers, list) or len(answers) != len(questions) or any(
        type(a) is not int or not 0 <= a < len(q["options"]) for a, q in zip(answers, questions)
    ):
        return jsonify({"error": "Answer every question with a valid option"}), 400
    score = sum(a == q["answer"] for a, q in zip(answers, questions))
    execute("INSERT INTO quiz_attempts (user_id, course_slug, score, total) VALUES (%s, %s, %s, %s)",
            (request.user_id, slug, score, len(questions)))
    return jsonify({"score": score, "total": len(questions), "review": questions})


@learning_bp.get("/quiz-attempts")
@require_auth
def attempts():
    return jsonify(query_all("SELECT course_slug, score, total, completed_at FROM quiz_attempts WHERE user_id = %s ORDER BY id DESC", (request.user_id,)))


@learning_bp.get("/cms")
@require_admin
def cms_access():
    return jsonify({"mode": "shared", "message": "Administrator access. Changes are saved to MySQL and visible to all learners."})


@learning_bp.post("/cms/courses")
@require_admin
def create_course():
    return save_course(None)


@learning_bp.put("/cms/courses/<slug>")
@require_admin
def update_course(slug):
    return save_course(slug)


def save_course(slug):
    body = request.get_json(silent=True) or {}
    try:
        title = valid_text(body, "title", 150)
        category = valid_text(body, "category", 60)
        description = valid_text(body, "description", 5000, False)
        if slug:
            if not query_one("SELECT id FROM courses WHERE slug = %s", (slug,)):
                return jsonify({"error": "Course not found"}), 404
            execute("UPDATE courses SET title=%s, category=%s, description=%s WHERE slug=%s", (title, category, description, slug))
        else:
            slug = valid_text(body, "slug", 80)
            if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", slug):
                raise ValueError("Use lowercase letters, numbers and hyphens for the slug")
            if query_one("SELECT id FROM courses WHERE slug=%s", (slug,)):
                return jsonify({"error": "That course slug already exists"}), 409
            execute("INSERT INTO courses (slug,title,category,description,sort_order) VALUES (%s,%s,%s,%s,999)", (slug,title,category,description))
    except ValueError as e:
        return jsonify({"error": str(e)}), 400
    return jsonify({"slug": slug}), 200


@learning_bp.post("/cms/courses/<slug>/lessons")
@require_admin
def create_lesson(slug):
    return save_lesson(slug, None)


@learning_bp.put("/cms/courses/<slug>/lessons/<lesson_slug>")
@require_admin
def update_lesson(slug, lesson_slug):
    return save_lesson(slug, lesson_slug)


def save_lesson(slug, lesson_slug):
    course = query_one("SELECT id FROM courses WHERE slug=%s", (slug,))
    if not course:
        return jsonify({"error": "Course not found"}), 404
    body = request.get_json(silent=True) or {}
    try:
        title = valid_text(body, "title", 150)
        text = valid_text(body, "text", 100000)
        content = "<p>" + escape(text).replace("\n", "<br>") + "</p>"
        if lesson_slug:
            if not query_one("SELECT id FROM lessons WHERE course_id=%s AND slug=%s", (course["id"], lesson_slug)):
                return jsonify({"error": "Lesson not found"}), 404
            execute("UPDATE lessons SET title=%s, content=%s WHERE course_id=%s AND slug=%s", (title,content,course["id"],lesson_slug))
        else:
            lesson_slug = valid_text(body, "slug", 80)
            if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", lesson_slug):
                raise ValueError("Use lowercase letters, numbers and hyphens for the slug")
            if query_one("SELECT id FROM lessons WHERE course_id=%s AND slug=%s", (course["id"],lesson_slug)):
                return jsonify({"error": "That lesson slug already exists"}), 409
            execute("INSERT INTO lessons (course_id,slug,title,content,sort_order) VALUES (%s,%s,%s,%s,999)", (course["id"],lesson_slug,title,content))
    except ValueError as e:
        return jsonify({"error": str(e)}), 400
    return jsonify({"slug": lesson_slug}), 200
