import os
import unittest
from unittest.mock import patch

from app import app
from auth import create_token
from routes.learning_routes import BANK


class LearningTests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()
        with app.app_context():
            self.headers = {"Authorization": "Bearer " + create_token(1)}

    def test_questions_hide_answers(self):
        for slug in BANK:
            result = self.client.get("/api/quizzes/" + slug)
            self.assertEqual(result.status_code, 200)
            self.assertNotIn("answer", result.json["questions"][0])

    @patch("routes.learning_routes.execute")
    def test_server_grades_and_saves(self, execute):
        result = self.client.post("/api/quizzes/arduino/attempts", headers=self.headers, json={"answers": [1, 2, 0], "score": 0})
        self.assertEqual(result.status_code, 200)
        self.assertEqual(result.json["score"], 3)
        self.assertEqual(execute.call_args.args[1], (1, "arduino", 3, 3))
        for answers in [[True, 2, 0], [1], [-1, 2, 0], [1, 2, 99]]:
            self.assertEqual(self.client.post("/api/quizzes/arduino/attempts", headers=self.headers, json={"answers": answers}).status_code, 400)

    def test_auth_required(self):
        self.assertEqual(self.client.get("/api/cms").status_code, 401)
        self.assertEqual(self.client.get("/api/quiz-attempts").status_code, 401)
        self.assertEqual(self.client.post("/api/quizzes/arduino/attempts", json={"answers": [1, 2, 0]}).status_code, 401)

    @patch.dict(os.environ, {"ADMIN_EMAILS": "admin@example.test"})
    @patch("routes.learning_routes.query_one", return_value={"email": "learner@example.test"})
    def test_nonadmin_cannot_edit(self, query):
        self.assertEqual(self.client.get("/api/cms", headers=self.headers).status_code, 403)
        self.assertEqual(self.client.post("/api/cms/courses", headers=self.headers, json={}).status_code, 403)

    @patch.dict(os.environ, {"ADMIN_EMAILS": "admin@example.test"})
    @patch("routes.learning_routes.execute")
    @patch("routes.learning_routes.query_one")
    def test_admin_lesson_update_escapes_html(self, query, execute):
        query.side_effect = [{"email": "admin@example.test"}, {"id": 1}, {"id": 5}]
        result = self.client.put("/api/cms/courses/arduino/lessons/intro", headers=self.headers, json={"title": "New title", "text": "<script>bad()</script>\nLine two"})
        self.assertEqual(result.status_code, 200)
        self.assertNotIn("<script>", execute.call_args.args[1][1])
        self.assertIn("&lt;script&gt;", execute.call_args.args[1][1])

    @patch("routes.learning_routes.query_all", return_value=[])
    def test_history_scoped_to_user(self, query):
        self.assertEqual(self.client.get("/api/quiz-attempts", headers=self.headers).status_code, 200)
        self.assertEqual(query.call_args.args[1], (1,))


if __name__ == "__main__":
    unittest.main()
