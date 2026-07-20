# Hardware Engineering Education Hub

A website that teaches hardware engineering fundamentals: electricity & electronics basics,
digital logic design, PCB design, robotics, and hardware description/embedded languages
(Verilog, VHDL, Arduino/C++).

- **Frontend:** static HTML, CSS, and vanilla JavaScript (`/frontend`)
- **Backend:** Python (Flask) REST API (`/backend`)
- **Database:** MySQL

## Project structure

```
frontend/
  index.html            Landing page
  pages/
    courses.html         Course catalog (fetched from API)
    course.html          Single course + lesson list/viewer (?slug=...)
    login.html
    register.html
    dashboard.html        Logged-in user's progress
  css/style.css
  js/
    api.js               Small fetch wrapper + auth token helper
    main.js              Shared nav/auth-state logic
    courses.js           Course catalog + course detail page logic
    auth.js              Login/register form handling
    dashboard.js         Progress dashboard logic

backend/
  app.py                 Flask app factory / entry point
  config.py              Config from environment variables
  db.py                  MySQL connection helper
  routes/
    auth_routes.py       /api/auth/*  (register, login, me)
    course_routes.py     /api/courses/*, /api/lessons/*
    progress_routes.py   /api/progress/*
  database/
    schema.sql           Table definitions
    seed.sql             Sample courses/lessons
  requirements.txt
  .env.example
```

## Backend setup

1. Create and activate a virtual environment:
   ```
   cd backend
   python -m venv venv
   venv\Scripts\activate
   ```
2. Install dependencies:
   ```
   pip install -r requirements.txt
   ```
3. Copy `.env.example` to `.env` and fill in your MySQL credentials and a secret key.
4. Create the database and tables, then load sample data:
   ```
   mysql -u root -p < database/schema.sql
   mysql -u root -p < database/seed.sql
   ```
5. Run the API:
   ```
   python app.py
   ```
   The API listens on `http://127.0.0.1:5000`.

## Frontend setup

The frontend is plain static files — no build step. Open `frontend/index.html` directly,
or serve the folder with any static server, e.g.:
```
cd frontend
python -m http.server 5500
```
Then visit `http://127.0.0.1:5500`. The frontend calls the API at `http://127.0.0.1:5000/api`
(see `API_BASE` in `js/api.js`) — update that if your backend runs elsewhere.

## Topics covered

- Basics of Electricity & Electronics
- Digital Logic Design
- PCB Design
- Robotics
- Verilog
- VHDL
- Arduino / Embedded C++
