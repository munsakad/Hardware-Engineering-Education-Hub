# Hardware Engineering Education Hub

A website that teaches hardware engineering fundamentals in depth: electricity & electronics
basics, digital logic design, PCB design, robotics, and hardware description/embedded languages
(Verilog, VHDL, Arduino/C++). The course content spans over 100 lessons, from first principles
(Ohm's Law, logic gates) through to applied, code-heavy material (PID controllers, FSM design,
full carry-lookahead adders in both Verilog and VHDL).

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
    seed.sql             Course/lesson content (120 lessons across 7 courses)
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

Each course below links a real lesson count — content ranges from core theory and truth tables
to full working code (C++/Arduino, Verilog, and VHDL implementations of the same circuits).

- **Basics of Electricity & Electronics** (16 lessons) — Ohm's Law, power/energy, Kirchhoff's
  laws, circuit analysis techniques (dividers, Thevenin/Norton, superposition), capacitors and
  inductors, AC signals/RMS/impedance, diodes/transistors, power supplies, op-amps, passive
  filters, electromagnetism, measurement instruments, and circuit safety.
- **Digital Logic Design** (18 lessons) — number systems, boolean algebra and its laws, logic
  gates and variations, canonical forms and Karnaugh maps, every standard combinational circuit
  (adders/subtractors, multiplexers/demultiplexers, decoders/encoders, comparators, parity),
  every standard sequential circuit (latches, flip-flop types, registers, shift registers,
  counters, finite state machines), memory/programmable logic, and timing/hazards.
- **PCB Design** (18 lessons) — PCB fundamentals, schematic capture, component footprints and
  packages, layout and routing, layer stack-ups, design rules/DRC, vias, power distribution and
  decoupling, grounding/EMI, signal integrity, high-speed design, thermal management, component
  placement, design for manufacturing/assembly, BOM/sourcing, testing/bring-up, and tool workflow.
- **Robotics** (21 lessons) — locomotion types, kinematics/odometry, DC/stepper/servo motor
  control, encoders, ultrasonic/IR/IMU sensing, line following, obstacle avoidance, PID control
  (with a full C++ class), path planning, localization, power systems, wireless control,
  mechanical design, FSM-based behavior, and safety/testing — all with real C++/Arduino code.
- **Verilog** (15 lessons, beginner → advanced) — syntax basics through combinational and
  sequential circuits, up to carry-lookahead adders, Moore/Mealy FSM design, memory modeling,
  and testbenches/verification.
- **VHDL** (16 lessons, beginner → advanced) — entities/architectures and data types through the
  same combinational/sequential circuit set as the Verilog course, so every circuit has a
  side-by-side implementation in both HDLs.
- **Arduino** (16 lessons) — IDE/board setup, C++ language basics, control structures,
  functions/scope, digital/analog I/O and PWM, arrays/strings/structs, libraries, communication
  protocols, interrupts, non-blocking timing with `millis()`, reading sensors, driving actuators,
  EEPROM/persistent storage, power management/sleep modes, and debugging/best practices.
