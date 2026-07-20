from flask import Blueprint, jsonify, request

from auth import require_auth
from db import execute, query_all, query_one

progress_bp = Blueprint("progress", __name__, url_prefix="/api/progress")


@progress_bp.get("")
@require_auth
def list_progress():
    rows = query_all(
        """
        SELECT courses.slug AS course_slug, courses.title AS course_title,
               lessons.slug AS lesson_slug, lessons.title AS lesson_title,
               user_progress.completed_at
        FROM user_progress
        JOIN lessons ON lessons.id = user_progress.lesson_id
        JOIN courses ON courses.id = lessons.course_id
        WHERE user_progress.user_id = %s
        ORDER BY user_progress.completed_at DESC
        """,
        (request.user_id,),
    )
    return jsonify(rows)


@progress_bp.post("/<course_slug>/<lesson_slug>/complete")
@require_auth
def mark_complete(course_slug, lesson_slug):
    lesson = query_one(
        """
        SELECT lessons.id FROM lessons
        JOIN courses ON courses.id = lessons.course_id
        WHERE courses.slug = %s AND lessons.slug = %s
        """,
        (course_slug, lesson_slug),
    )
    if not lesson:
        return jsonify({"error": "Lesson not found"}), 404

    execute(
        """
        INSERT INTO user_progress (user_id, lesson_id) VALUES (%s, %s)
        ON DUPLICATE KEY UPDATE completed_at = CURRENT_TIMESTAMP
        """,
        (request.user_id, lesson["id"]),
    )
    return jsonify({"status": "completed"})
