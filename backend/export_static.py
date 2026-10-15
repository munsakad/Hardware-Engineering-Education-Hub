"""
Builds the static GitHub Pages version of the site.

1. Reads the course catalog from MySQL (loaded from database/schema.sql and
   database/seed.sql) with the same queries the Flask routes use, and writes
   it to <out>/data/courses.json.
2. Copies frontend/ to <out>/ and adds js/demo-backend.js ahead of js/api.js
   on every page, so API calls are answered in the browser.

Usage (from backend/, with MySQL env vars set as in .env.example):
    python export_static.py ../_site
"""

import json
import re
import shutil
import sys
from pathlib import Path

from db import query_all

FRONTEND = Path(__file__).resolve().parent.parent / "frontend"


def export_courses():
    courses = query_all("SELECT id, slug, title, description, category FROM courses ORDER BY sort_order")
    for course in courses:
        course["lessons"] = query_all(
            "SELECT id, slug, title, content, sort_order FROM lessons WHERE course_id = %s ORDER BY sort_order",
            (course["id"],),
        )
    return courses


def main(out_dir):
    out = Path(out_dir).resolve()
    if out.exists():
        shutil.rmtree(out)
    shutil.copytree(FRONTEND, out, ignore=shutil.ignore_patterns("*.test.cjs"))

    courses = export_courses()
    (out / "data").mkdir(exist_ok=True)
    (out / "data" / "courses.json").write_text(json.dumps(courses, default=str), encoding="utf-8")
    n_lessons = sum(len(c["lessons"]) for c in courses)
    print(f"Exported {len(courses)} courses / {n_lessons} lessons")

    api_tag = re.compile(r'(\s*)<script src="((?:\.\./)?)js/api\.js"></script>')
    for page in out.rglob("*.html"):
        html = page.read_text(encoding="utf-8")
        patched, n = api_tag.subn(
            lambda m: f'{m.group(1)}<script src="{m.group(2)}js/demo-backend.js"></script>{m.group(0)}', html
        )
        if n:
            page.write_text(patched, encoding="utf-8")
            print(f"  patched {page.relative_to(out)}")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "../_site")
