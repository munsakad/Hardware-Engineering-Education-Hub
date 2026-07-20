from flask import Blueprint, jsonify

from db import query_all, query_one

course_bp = Blueprint("courses", __name__, url_prefix="/api/courses")


@course_bp.get("")
def list_courses():
    courses = query_all(
        "SELECT id, slug, title, description, category FROM courses ORDER BY sort_order"
    )
    return jsonify(courses)


@course_bp.get("/<slug>")
def get_course(slug):
    course = query_one(
        "SELECT id, slug, title, description, category FROM courses WHERE slug = %s", (slug,)
    )
    if not course:
        return jsonify({"error": "Course not found"}), 404

    lessons = query_all(
        "SELECT id, slug, title, sort_order FROM lessons WHERE course_id = %s ORDER BY sort_order",
        (course["id"],),
    )
    course["lessons"] = lessons
    return jsonify(course)


@course_bp.get("/<course_slug>/lessons/<lesson_slug>")
def get_lesson(course_slug, lesson_slug):
    lesson = query_one(
        """
        SELECT lessons.id, lessons.slug, lessons.title, lessons.content, lessons.sort_order,
               courses.id AS course_id, courses.slug AS course_slug, courses.title AS course_title
        FROM lessons
        JOIN courses ON courses.id = lessons.course_id
        WHERE courses.slug = %s AND lessons.slug = %s
        """,
        (course_slug, lesson_slug),
    )
    if not lesson:
        return jsonify({"error": "Lesson not found"}), 404
    return jsonify(lesson)
