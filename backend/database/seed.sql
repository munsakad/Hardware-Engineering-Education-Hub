USE hardware_edu_hub;

INSERT INTO courses (slug, title, description, category, sort_order) VALUES
('electricity-electronics-basics', 'Basics of Electricity & Electronics', 'Voltage, current, resistance, circuits, and the fundamental components every hardware engineer needs to know.', 'Fundamentals', 1),
('digital-logic-design', 'Digital Logic Design', 'Boolean algebra, logic gates, combinational and sequential circuits, and number systems.', 'Fundamentals', 2),
('pcb-design', 'PCB Design', 'Schematic capture, layout, routing, and manufacturing considerations for printed circuit boards.', 'Design', 3),
('robotics', 'Robotics', 'Sensors, actuators, motor control, and control loops for building robots.', 'Design', 4),
('verilog', 'Verilog', 'Hardware description language fundamentals for describing and simulating digital circuits.', 'HDL & Embedded', 5),
('vhdl', 'VHDL', 'An alternative hardware description language widely used in FPGA and ASIC design.', 'HDL & Embedded', 6),
('arduino', 'Arduino', 'Programming microcontrollers with Arduino C++ to interact with the physical world.', 'HDL & Embedded', 7)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  description = VALUES(description),
  category = VALUES(category),
  sort_order = VALUES(sort_order);

-- =========================================================================
-- Basics of Electricity & Electronics
-- =========================================================================

INSERT INTO lessons (course_id, slug, title, content, sort_order) VALUES
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'intro-to-voltage-current-resistance',
  'Voltage, Current & Resistance',
  '<h3>The three basics</h3>
  <p><strong>Voltage (V)</strong>, measured in volts, is the electrical "pressure" that pushes charge through a circuit -- the difference in electric potential between two points.</p>
  <p><strong>Current (I)</strong>, measured in amperes (amps, A), is the rate at which charge flows past a point in a circuit.</p>
  <p><strong>Resistance (R)</strong>, measured in ohms (symbol &Omega;), is how much a component opposes the flow of current.</p>
  <h3>The water analogy</h3>
  <ul>
    <li>Voltage is like water pressure in a pipe.</li>
    <li>Current is like the rate of water flow.</li>
    <li>Resistance is like the narrowness of the pipe restricting flow.</li>
  </ul>
  <h3>Ohm''s Law</h3>
  <p>These three quantities are related by Ohm''s Law:</p>
  <pre><code>V = I &times; R</code></pre>
  <p>Rearranged for the other two unknowns:</p>
  <pre><code>I = V / R
R = V / I</code></pre>
  <table class="data-table">
    <caption>Common unit prefixes used with V, I, and R</caption>
    <thead><tr><th>Prefix</th><th>Symbol</th><th>Multiplier</th><th>Example</th></tr></thead>
    <tbody>
      <tr><td>kilo</td><td>k</td><td>&times;1,000</td><td>4.7 k&Omega;</td></tr>
      <tr><td>milli</td><td>m</td><td>&times;0.001</td><td>250 mA</td></tr>
      <tr><td>micro</td><td>&micro;</td><td>&times;0.000001</td><td>10 &micro;F (capacitance)</td></tr>
    </tbody>
  </table>
  <h3>Worked example</h3>
  <p>A 9 V battery is connected across a 470 &Omega; resistor. What current flows?</p>
  <pre><code>I = V / R = 9 / 470 &asymp; 0.019 A = 19 mA</code></pre>',
  1
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'series-parallel-circuits',
  'Series & Parallel Circuits',
  '<h3>Series circuits</h3>
  <p>In a series circuit, components are connected end-to-end so there is only one path for current. The same current flows through every component, while the total voltage splits across them.</p>
  <pre><code>R_total = R1 + R2 + R3 + ...</code></pre>
  <h3>Parallel circuits</h3>
  <p>In a parallel circuit, components share the same two nodes, so the same voltage appears across every branch, while the total current splits between the branches.</p>
  <pre><code>1 / R_total = 1/R1 + 1/R2 + 1/R3 + ...</code></pre>
  <p>For exactly two resistors in parallel, this simplifies to:</p>
  <pre><code>R_total = (R1 &times; R2) / (R1 + R2)</code></pre>
  <table class="data-table">
    <caption>Series vs. parallel at a glance</caption>
    <thead><tr><th>Property</th><th>Series</th><th>Parallel</th></tr></thead>
    <tbody>
      <tr><td>Current</td><td>Same through all components</td><td>Splits between branches</td></tr>
      <tr><td>Voltage</td><td>Splits across components</td><td>Same across all branches</td></tr>
      <tr><td>Equivalent resistance</td><td>Always larger than any single resistor</td><td>Always smaller than the smallest resistor</td></tr>
      <tr><td>If one component fails open</td><td>Whole circuit stops</td><td>Other branches keep working</td></tr>
    </tbody>
  </table>
  <h3>Worked example</h3>
  <p>Two 100 &Omega; resistors in parallel:</p>
  <pre><code>R_total = (100 &times; 100) / (100 + 100) = 50 &Omega;</code></pre>',
  2
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'diodes-transistors',
  'Diodes & Transistors',
  '<h3>Diodes</h3>
  <p>A diode is a two-terminal component that lets current flow easily in one direction (forward bias) and blocks it in the other (reverse bias). A silicon diode typically needs about 0.7 V across it before it conducts; an LED needs roughly 1.8-3.3 V depending on its color.</p>
  <table class="data-table">
    <caption>Diode behavior by bias direction</caption>
    <thead><tr><th>Bias direction</th><th>Behavior</th></tr></thead>
    <tbody>
      <tr><td>Forward bias</td><td>Conducts current once the forward voltage threshold is reached</td></tr>
      <tr><td>Reverse bias</td><td>Blocks current (until its reverse breakdown voltage is exceeded)</td></tr>
    </tbody>
  </table>
  <h3>Transistors</h3>
  <p>A transistor is a three-terminal device used as an electronic switch or amplifier. The most common types are the Bipolar Junction Transistor (BJT), with terminals Base, Collector, and Emitter, and the MOSFET, with terminals Gate, Drain, and Source.</p>
  <table class="data-table">
    <caption>BJT operating regions (NPN transistor)</caption>
    <thead><tr><th>Region</th><th>Condition</th><th>Behavior</th></tr></thead>
    <tbody>
      <tr><td>Cutoff</td><td>V_BE below ~0.7 V</td><td>Acts like an open switch, no current flows</td></tr>
      <tr><td>Active</td><td>V_BE &asymp; 0.7 V, V_CE above saturation</td><td>Acts as an amplifier, I_C proportional to I_B</td></tr>
      <tr><td>Saturation</td><td>V_CE very low (~0.2 V)</td><td>Acts like a closed switch, fully "on"</td></tr>
    </tbody>
  </table>
  <p>In digital circuits, transistors are almost always used as switches: fully off (cutoff) represents a logic 0, and fully on (saturation) represents a logic 1. This is the foundation that logic gates are built from.</p>',
  3
)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  content = VALUES(content),
  sort_order = VALUES(sort_order);

-- =========================================================================
-- Digital Logic Design
-- =========================================================================

INSERT INTO lessons (course_id, slug, title, content, sort_order) VALUES
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'number-systems',
  'Number Systems',
  '<h3>Why digital systems use binary</h3>
  <p>Digital circuits represent information using only two voltage levels: "high" and "low", corresponding to the digits 1 and 0. This is called the binary (base-2) number system. Because raw binary is hard for humans to read, engineers also use octal (base-8) and hexadecimal (base-16) as compact shorthand for groups of bits.</p>
  <table class="data-table">
    <caption>Decimal 0-15 across the common number systems</caption>
    <thead><tr><th>Decimal</th><th>Binary</th><th>Octal</th><th>Hexadecimal</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0000</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>0001</td><td>1</td><td>1</td></tr>
      <tr><td>2</td><td>0010</td><td>2</td><td>2</td></tr>
      <tr><td>3</td><td>0011</td><td>3</td><td>3</td></tr>
      <tr><td>4</td><td>0100</td><td>4</td><td>4</td></tr>
      <tr><td>5</td><td>0101</td><td>5</td><td>5</td></tr>
      <tr><td>6</td><td>0110</td><td>6</td><td>6</td></tr>
      <tr><td>7</td><td>0111</td><td>7</td><td>7</td></tr>
      <tr><td>8</td><td>1000</td><td>10</td><td>8</td></tr>
      <tr><td>9</td><td>1001</td><td>11</td><td>9</td></tr>
      <tr><td>10</td><td>1010</td><td>12</td><td>A</td></tr>
      <tr><td>11</td><td>1011</td><td>13</td><td>B</td></tr>
      <tr><td>12</td><td>1100</td><td>14</td><td>C</td></tr>
      <tr><td>13</td><td>1101</td><td>15</td><td>D</td></tr>
      <tr><td>14</td><td>1110</td><td>16</td><td>E</td></tr>
      <tr><td>15</td><td>1111</td><td>17</td><td>F</td></tr>
    </tbody>
  </table>
  <h3>Converting binary to decimal</h3>
  <p>Each bit represents a power of two. To convert, add up the powers of two where the bit is 1:</p>
  <pre><code>1011 = (1 &times; 2^3) + (0 &times; 2^2) + (1 &times; 2^1) + (1 &times; 2^0)
     = 8 + 0 + 2 + 1 = 11</code></pre>
  <h3>Converting decimal to binary</h3>
  <p>Repeatedly divide by 2 and record the remainders from last to first, or subtract the largest power of two that fits until nothing remains.</p>',
  1
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'logic-gates',
  'Logic Gates',
  '<h3>The basic gates</h3>
  <p>Logic gates are the building blocks of all digital circuits. Each gate takes one or more binary inputs and produces a binary output based on a fixed rule, which we describe with a <strong>truth table</strong> -- a table listing every possible input combination and its resulting output.</p>

  <h3>NOT (inverter)</h3>
  <table class="truth-table">
    <caption>NOT gate: output is the opposite of the input</caption>
    <thead><tr><th>A</th><th>OUT = NOT A</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>0</td></tr>
    </tbody>
  </table>

  <h3>AND</h3>
  <table class="truth-table">
    <caption>AND gate: output is 1 only when both inputs are 1</caption>
    <thead><tr><th>A</th><th>B</th><th>OUT = A AND B</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>

  <h3>OR</h3>
  <table class="truth-table">
    <caption>OR gate: output is 1 when at least one input is 1</caption>
    <thead><tr><th>A</th><th>B</th><th>OUT = A OR B</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>1</td></tr>
      <tr><td>1</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>

  <h3>NAND (NOT AND)</h3>
  <table class="truth-table">
    <caption>NAND gate: output is the inverse of AND</caption>
    <thead><tr><th>A</th><th>B</th><th>OUT = A NAND B</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>1</td></tr>
      <tr><td>0</td><td>1</td><td>1</td></tr>
      <tr><td>1</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>1</td><td>0</td></tr>
    </tbody>
  </table>

  <h3>NOR (NOT OR)</h3>
  <table class="truth-table">
    <caption>NOR gate: output is the inverse of OR</caption>
    <thead><tr><th>A</th><th>B</th><th>OUT = A NOR B</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>1</td></tr>
      <tr><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>0</td></tr>
    </tbody>
  </table>

  <h3>XOR (exclusive OR)</h3>
  <table class="truth-table">
    <caption>XOR gate: output is 1 when inputs differ</caption>
    <thead><tr><th>A</th><th>B</th><th>OUT = A XOR B</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>1</td></tr>
      <tr><td>1</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>1</td><td>0</td></tr>
    </tbody>
  </table>

  <h3>XNOR (exclusive NOR)</h3>
  <table class="truth-table">
    <caption>XNOR gate: output is 1 when inputs match</caption>
    <thead><tr><th>A</th><th>B</th><th>OUT = A XNOR B</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>1</td></tr>
      <tr><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>

  <p>NAND and NOR are called "universal gates" because either one, alone, can be wired together to build any other gate -- which is why they are so common inside real chips.</p>',
  2
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'flip-flops-sequential-logic',
  'Flip-Flops & Sequential Logic',
  '<h3>Combinational vs. sequential logic</h3>
  <p>Combinational logic (like the gates from the previous lesson) has outputs that depend only on the current inputs. Sequential logic has <strong>memory</strong> -- its outputs depend on current inputs and on past state. Flip-flops are the basic 1-bit memory elements used to build registers, counters, and state machines.</p>

  <h3>SR latch</h3>
  <p>The simplest memory element. S (Set) and R (Reset) control the stored bit Q.</p>
  <table class="truth-table">
    <caption>SR latch behavior</caption>
    <thead><tr><th>S</th><th>R</th><th>Q (next)</th><th>Meaning</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>Q (no change)</td><td>Hold previous value</td></tr>
      <tr><td>0</td><td>1</td><td>0</td><td>Reset</td></tr>
      <tr><td>1</td><td>0</td><td>1</td><td>Set</td></tr>
      <tr><td>1</td><td>1</td><td>invalid</td><td>Not allowed</td></tr>
    </tbody>
  </table>

  <h3>D flip-flop</h3>
  <p>The most widely used flip-flop. On every rising clock edge, it simply copies input D to output Q.</p>
  <table class="truth-table">
    <caption>D flip-flop behavior (on rising clock edge)</caption>
    <thead><tr><th>D</th><th>Q (next)</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>1</td></tr>
    </tbody>
  </table>

  <h3>JK flip-flop</h3>
  <p>A more flexible flip-flop that fixes the SR latch''s invalid state by making both inputs high toggle the output.</p>
  <table class="truth-table">
    <caption>JK flip-flop behavior (on rising clock edge)</caption>
    <thead><tr><th>J</th><th>K</th><th>Q (next)</th><th>Meaning</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>Q (no change)</td><td>Hold</td></tr>
      <tr><td>0</td><td>1</td><td>0</td><td>Reset</td></tr>
      <tr><td>1</td><td>0</td><td>1</td><td>Set</td></tr>
      <tr><td>1</td><td>1</td><td>NOT Q (toggle)</td><td>Toggle</td></tr>
    </tbody>
  </table>

  <h3>T flip-flop</h3>
  <p>A "toggle" flip-flop, often built from a JK flip-flop with J and K tied together, commonly used in counters.</p>
  <table class="truth-table">
    <caption>T flip-flop behavior (on rising clock edge)</caption>
    <thead><tr><th>T</th><th>Q (next)</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>Q (no change)</td></tr>
      <tr><td>1</td><td>NOT Q (toggle)</td></tr>
    </tbody>
  </table>',
  3
)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  content = VALUES(content),
  sort_order = VALUES(sort_order);

-- =========================================================================
-- PCB Design
-- =========================================================================

INSERT INTO lessons (course_id, slug, title, content, sort_order) VALUES
(
  (SELECT id FROM courses WHERE slug = 'pcb-design'),
  'schematic-capture',
  'Schematic Capture',
  '<h3>What a schematic is</h3>
  <p>A schematic is a diagram of a circuit using standardized symbols for components (resistors, capacitors, ICs, connectors) connected by lines called <strong>nets</strong>. It describes electrical connectivity, not physical layout.</p>
  <h3>Typical schematic capture workflow</h3>
  <ol>
    <li>Place component symbols from a library (or create custom symbols for parts that are not in the library).</li>
    <li>Wire the symbols together to define nets, and label important nets (e.g. <code>VCC</code>, <code>GND</code>, <code>SDA</code>).</li>
    <li>Assign each component a reference designator (e.g. <code>R1</code>, <code>C4</code>, <code>U2</code>) and a footprint that matches its physical package.</li>
    <li>Run an Electrical Rule Check (ERC) to catch unconnected pins, conflicting outputs, and missing power connections.</li>
    <li>Generate a netlist, which is the file the PCB layout tool uses to know which pads must be connected together.</li>
  </ol>
  <table class="data-table">
    <caption>Common schematic reference designator prefixes</caption>
    <thead><tr><th>Prefix</th><th>Component type</th></tr></thead>
    <tbody>
      <tr><td>R</td><td>Resistor</td></tr>
      <tr><td>C</td><td>Capacitor</td></tr>
      <tr><td>L</td><td>Inductor</td></tr>
      <tr><td>U / IC</td><td>Integrated circuit</td></tr>
      <tr><td>Q</td><td>Transistor</td></tr>
      <tr><td>D</td><td>Diode / LED</td></tr>
      <tr><td>J / P</td><td>Connector</td></tr>
    </tbody>
  </table>',
  1
),
(
  (SELECT id FROM courses WHERE slug = 'pcb-design'),
  'pcb-layout-routing',
  'PCB Layout & Routing',
  '<h3>From schematic to physical board</h3>
  <p>Layout takes the netlist from schematic capture and turns it into a physical arrangement of copper on a board. Good layout balances electrical performance, manufacturability, and cost.</p>
  <h3>Placement</h3>
  <ul>
    <li>Group related components together (e.g. decoupling capacitors right next to the IC power pins they support).</li>
    <li>Keep high-speed or sensitive signal paths short.</li>
    <li>Leave room for mounting holes, connectors, and mechanical clearance.</li>
  </ul>
  <h3>Routing</h3>
  <p>Routing draws the copper traces that implement each net. Trace width matters: wider traces carry more current and have lower resistance.</p>
  <table class="data-table">
    <caption>Rough external-layer trace width vs. current capacity (1 oz copper, ~10&deg;C rise)</caption>
    <thead><tr><th>Trace width</th><th>Approx. current capacity</th></tr></thead>
    <tbody>
      <tr><td>0.25 mm (10 mil)</td><td>&asymp; 0.5 A</td></tr>
      <tr><td>0.5 mm (20 mil)</td><td>&asymp; 1 A</td></tr>
      <tr><td>1.0 mm (40 mil)</td><td>&asymp; 2 A</td></tr>
    </tbody>
  </table>
  <p>These are rough estimates only -- always check a trace-width calculator against your board''s copper weight and required temperature rise.</p>
  <h3>Layer stack-up</h3>
  <table class="data-table">
    <caption>Typical layer stack-ups</caption>
    <thead><tr><th>Layers</th><th>Typical use</th></tr></thead>
    <tbody>
      <tr><td>2-layer</td><td>Simple, low-speed, low-cost boards</td></tr>
      <tr><td>4-layer</td><td>Adds dedicated ground and power planes for better signal integrity</td></tr>
      <tr><td>6+ layer</td><td>Complex or high-speed boards needing controlled impedance and extra routing room</td></tr>
    </tbody>
  </table>',
  2
),
(
  (SELECT id FROM courses WHERE slug = 'pcb-design'),
  'design-for-manufacturing',
  'Design for Manufacturing (DFM)',
  '<h3>Why DFM matters</h3>
  <p>A design that looks correct in your PCB tool can still be difficult, expensive, or impossible for a factory to build reliably. Design for Manufacturing (DFM) means designing with the fabrication and assembly process in mind from the start.</p>
  <h3>Common DFM checklist items</h3>
  <table class="data-table">
    <caption>Frequent DFM issues and how to avoid them</caption>
    <thead><tr><th>Issue</th><th>Why it matters</th></tr></thead>
    <tbody>
      <tr><td>Trace/space too small for the chosen fabricator</td><td>Can cause shorts or opens during etching</td></tr>
      <tr><td>Drill holes too small or too close to copper</td><td>Increases drill breakage and reduces reliability</td></tr>
      <tr><td>Silkscreen text over pads</td><td>Interferes with soldering and readability</td></tr>
      <tr><td>Missing solder mask clearance around pads</td><td>Can cause solder bridging between pins</td></tr>
      <tr><td>No fiducial markers for fine-pitch parts</td><td>Reduces pick-and-place placement accuracy</td></tr>
    </tbody>
  </table>
  <h3>Output files</h3>
  <p>Once layout is complete, the design is exported as a set of manufacturing files, most commonly <strong>Gerber files</strong> (one per copper/mask/silkscreen layer) plus an <strong>NC drill file</strong> and a <strong>bill of materials (BOM)</strong> and <strong>pick-and-place file</strong> for assembly.</p>
  <p>Panelization -- arranging multiple copies of a board together with breakaway tabs -- is also commonly done at this stage to make assembly more efficient.</p>',
  3
)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  content = VALUES(content),
  sort_order = VALUES(sort_order);

-- =========================================================================
-- Robotics
-- =========================================================================

INSERT INTO lessons (course_id, slug, title, content, sort_order) VALUES
(
  (SELECT id FROM courses WHERE slug = 'robotics'),
  'sensors-actuators',
  'Sensors & Actuators',
  '<h3>Sensors: how a robot perceives the world</h3>
  <table class="data-table">
    <caption>Common robotics sensors</caption>
    <thead><tr><th>Sensor</th><th>Measures</th><th>Typical use</th></tr></thead>
    <tbody>
      <tr><td>Ultrasonic (e.g. HC-SR04)</td><td>Distance via sound echo time</td><td>Obstacle detection</td></tr>
      <tr><td>Infrared (IR)</td><td>Reflected light / proximity</td><td>Line following, short-range proximity</td></tr>
      <tr><td>IMU (accelerometer + gyroscope)</td><td>Acceleration and rotation rate</td><td>Balance, orientation tracking</td></tr>
      <tr><td>Rotary encoder</td><td>Shaft rotation / position</td><td>Measuring wheel speed and distance traveled</td></tr>
    </tbody>
  </table>
  <h3>Actuators: how a robot acts on the world</h3>
  <table class="data-table">
    <caption>Common actuator types</caption>
    <thead><tr><th>Actuator</th><th>Control method</th><th>Precision</th><th>Typical use</th></tr></thead>
    <tbody>
      <tr><td>DC motor</td><td>Applied voltage / PWM</td><td>Low (needs encoder feedback for precision)</td><td>Wheels, simple continuous motion</td></tr>
      <tr><td>Servo motor</td><td>PWM pulse width sets angle</td><td>Medium-high</td><td>Steering, robotic arm joints</td></tr>
      <tr><td>Stepper motor</td><td>Sequenced pulses per step</td><td>High (open-loop)</td><td>3D printers, precise positioning</td></tr>
    </tbody>
  </table>',
  1
),
(
  (SELECT id FROM courses WHERE slug = 'robotics'),
  'motor-control',
  'Motor Control',
  '<h3>PWM: controlling speed</h3>
  <p>Pulse Width Modulation (PWM) switches power to a motor on and off very quickly. The <strong>duty cycle</strong> -- the percentage of time the signal is "on" -- controls the average voltage the motor sees, and therefore its speed.</p>
  <table class="data-table">
    <caption>Duty cycle vs. approximate motor speed</caption>
    <thead><tr><th>Duty cycle</th><th>Effective voltage (from 12V supply)</th><th>Speed</th></tr></thead>
    <tbody>
      <tr><td>25%</td><td>3 V</td><td>Slow</td></tr>
      <tr><td>50%</td><td>6 V</td><td>Medium</td></tr>
      <tr><td>100%</td><td>12 V</td><td>Full speed</td></tr>
    </tbody>
  </table>
  <h3>H-bridges: controlling direction</h3>
  <p>An H-bridge is a circuit of four switches (often built from transistors) arranged so a DC motor can be driven forward, in reverse, braked, or left to coast, using just two control inputs.</p>
  <table class="truth-table">
    <caption>H-bridge control truth table</caption>
    <thead><tr><th>IN1</th><th>IN2</th><th>Motor behavior</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>Coast (no drive)</td></tr>
      <tr><td>0</td><td>1</td><td>Reverse</td></tr>
      <tr><td>1</td><td>0</td><td>Forward</td></tr>
      <tr><td>1</td><td>1</td><td>Brake</td></tr>
    </tbody>
  </table>
  <p>Combine this truth table with PWM on the enable pin and you get full speed and direction control from just three signals: IN1, IN2, and PWM enable.</p>',
  2
),
(
  (SELECT id FROM courses WHERE slug = 'robotics'),
  'control-loops',
  'Control Loops',
  '<h3>Open-loop vs. closed-loop control</h3>
  <p>Open-loop control sends a command and hopes for the best, with no feedback (e.g. running a motor at a fixed PWM value). Closed-loop control measures the actual result with a sensor and continuously adjusts the command to reduce the error between the desired and actual state.</p>
  <h3>PID control</h3>
  <p>A PID controller computes its output from three terms based on the error (desired value minus measured value):</p>
  <ul>
    <li><strong>P (Proportional)</strong> -- reacts to the current error. Larger error, larger correction.</li>
    <li><strong>I (Integral)</strong> -- reacts to accumulated past error, eliminating steady-state offset.</li>
    <li><strong>D (Derivative)</strong> -- reacts to how fast the error is changing, damping overshoot.</li>
  </ul>
  <table class="data-table">
    <caption>Effect of increasing each PID gain</caption>
    <thead><tr><th>Gain increased</th><th>Typical effect</th></tr></thead>
    <tbody>
      <tr><td>P (Kp)</td><td>Faster response, but too high causes oscillation</td></tr>
      <tr><td>I (Ki)</td><td>Removes steady-state error, but too high causes overshoot/instability</td></tr>
      <tr><td>D (Kd)</td><td>Reduces overshoot and damps oscillation, but too high amplifies sensor noise</td></tr>
    </tbody>
  </table>
  <p>A common tuning approach is to start with only P, increase it until the system oscillates, then back it off and add I to remove offset, and finally add D to smooth out overshoot.</p>',
  3
)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  content = VALUES(content),
  sort_order = VALUES(sort_order);

-- =========================================================================
-- Verilog
-- =========================================================================

INSERT INTO lessons (course_id, slug, title, content, sort_order) VALUES
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-syntax-basics',
  'Verilog Syntax Basics',
  '<h3>Modules</h3>
  <p>Every piece of hardware in Verilog is described inside a <code>module</code>, with a list of input/output ports.</p>
  <pre><code>module and_gate (
    input  a,
    input  b,
    output y
);
    assign y = a &amp; b;
endmodule</code></pre>
  <h3>wire vs. reg</h3>
  <table class="data-table">
    <caption>wire vs. reg</caption>
    <thead><tr><th>Type</th><th>Used for</th><th>Assigned with</th></tr></thead>
    <tbody>
      <tr><td><code>wire</code></td><td>Combinational connections between components</td><td><code>assign</code> statements</td></tr>
      <tr><td><code>reg</code></td><td>Values that hold state inside procedural blocks</td><td><code>always</code> blocks</td></tr>
    </tbody>
  </table>
  <p>Note that <code>reg</code> does not necessarily mean a physical register -- it just means "assigned inside an always block". Whether real flip-flops are created depends on how the always block is written.</p>',
  1
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'combinational-logic-in-verilog',
  'Combinational Logic in Verilog',
  '<h3>Continuous assignment</h3>
  <p>Combinational logic (logic with no memory) is usually written with <code>assign</code> statements describing what a wire is always equal to.</p>
  <pre><code>module mux2to1 (
    input  sel,
    input  a,
    input  b,
    output y
);
    assign y = sel ? b : a;
endmodule</code></pre>
  <p>This describes a 2-to-1 multiplexer: when <code>sel</code> is 0, output <code>y</code> follows input <code>a</code>; when <code>sel</code> is 1, it follows <code>b</code>.</p>
  <table class="truth-table">
    <caption>2-to-1 multiplexer truth table</caption>
    <thead><tr><th>sel</th><th>a</th><th>b</th><th>y</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>X</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>X</td><td>1</td></tr>
      <tr><td>1</td><td>X</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>X</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>
  <p>(X means "does not matter" -- the output does not depend on that input for that row.)</p>',
  2
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'always-blocks-sequential-logic',
  'Always Blocks & Sequential Logic',
  '<h3>Describing a clocked flip-flop</h3>
  <p>Sequential logic depends on a clock edge, described in Verilog with an <code>always @(posedge clk)</code> block.</p>
  <pre><code>module d_flip_flop (
    input  clk,
    input  reset,
    input  d,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q &lt;= 1''b0;
        else
            q &lt;= d;
    end
endmodule</code></pre>
  <p>This matches the D flip-flop truth table from the Digital Logic Design course: on every rising clock edge, <code>q</code> takes on the value of <code>d</code> (unless reset is asserted, which forces <code>q</code> to 0).</p>
  <h3>Blocking (=) vs. non-blocking (&lt;=) assignment</h3>
  <table class="data-table">
    <caption>Blocking vs. non-blocking assignment</caption>
    <thead><tr><th>Operator</th><th>Executes</th><th>Use inside</th></tr></thead>
    <tbody>
      <tr><td><code>=</code> (blocking)</td><td>Immediately, in order, like normal software statements</td><td><code>always @(*)</code> blocks for combinational logic</td></tr>
      <tr><td><code>&lt;=</code> (non-blocking)</td><td>All right-hand sides evaluated first, then all assignments happen together</td><td><code>always @(posedge clk)</code> blocks for sequential logic</td></tr>
    </tbody>
  </table>
  <p>Mixing them up is one of the most common Verilog bugs -- as a rule of thumb, use non-blocking (<code>&lt;=</code>) for clocked logic and blocking (<code>=</code>) for combinational logic.</p>',
  3
)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  content = VALUES(content),
  sort_order = VALUES(sort_order);

-- =========================================================================
-- VHDL
-- =========================================================================

INSERT INTO lessons (course_id, slug, title, content, sort_order) VALUES
(
  (SELECT id FROM courses WHERE slug = 'vhdl'),
  'vhdl-entity-architecture',
  'Entities & Architectures',
  '<h3>Entity: the interface</h3>
  <p>An <code>entity</code> declares a component''s name and its ports (inputs and outputs), similar to a Verilog module''s port list.</p>
  <pre><code>entity and_gate is
    port (
        a : in  std_logic;
        b : in  std_logic;
        y : out std_logic
    );
end entity and_gate;</code></pre>
  <h3>Architecture: the behavior</h3>
  <p>An <code>architecture</code> describes what the entity actually does.</p>
  <pre><code>architecture behavior of and_gate is
begin
    y &lt;= a and b;
end architecture behavior;</code></pre>
  <p>A single entity can have multiple architectures (for example, one for simulation behavior and one for a gate-level implementation), and you choose which one to use at compile/simulation time.</p>',
  1
),
(
  (SELECT id FROM courses WHERE slug = 'vhdl'),
  'vhdl-signals-processes',
  'Signals & Processes',
  '<h3>Signals</h3>
  <p>A <code>signal</code> represents a wire or piece of state inside an architecture, declared with a type such as <code>std_logic</code> (a single bit) or <code>std_logic_vector</code> (a bus of bits).</p>
  <h3>Processes</h3>
  <p>A <code>process</code> block groups sequential statements that execute whenever something in its sensitivity list changes -- most commonly a clock.</p>
  <pre><code>architecture behavior of d_flip_flop is
begin
    process (clk, reset)
    begin
        if reset = ''1'' then
            q &lt;= ''0'';
        elsif rising_edge(clk) then
            q &lt;= d;
        end if;
    end process;
end architecture behavior;</code></pre>
  <h3>Signal vs. variable</h3>
  <table class="data-table">
    <caption>signal vs. variable</caption>
    <thead><tr><th>Kind</th><th>Update timing</th><th>Scope</th></tr></thead>
    <tbody>
      <tr><td><code>signal</code></td><td>Updated at the end of the current simulation cycle</td><td>Visible across the whole architecture</td></tr>
      <tr><td><code>variable</code></td><td>Updated immediately, in program order</td><td>Local to the process it is declared in</td></tr>
    </tbody>
  </table>',
  2
),
(
  (SELECT id FROM courses WHERE slug = 'vhdl'),
  'vhdl-vs-verilog',
  'VHDL vs. Verilog',
  '<h3>Two ways to describe the same hardware</h3>
  <p>VHDL and Verilog both describe digital hardware and both compile down to the same kinds of gates and flip-flops -- the differences are mostly about syntax style, strictness, and heritage.</p>
  <table class="data-table">
    <caption>VHDL vs. Verilog comparison</caption>
    <thead><tr><th>Aspect</th><th>VHDL</th><th>Verilog</th></tr></thead>
    <tbody>
      <tr><td>Heritage</td><td>Based on Ada, originally a US DoD standard</td><td>Based on C syntax style</td></tr>
      <tr><td>Typing</td><td>Strongly typed, more verbose</td><td>Weakly typed, more compact</td></tr>
      <tr><td>Case sensitivity</td><td>Case-insensitive</td><td>Case-sensitive</td></tr>
      <tr><td>Common industry use</td><td>Popular in defense/aerospace and some FPGA shops</td><td>Popular in commercial ASIC/FPGA design, especially US chip companies</td></tr>
      <tr><td>Learning curve</td><td>More boilerplate, but catches more mistakes at compile time</td><td>Faster to write, easier to make subtle mistakes</td></tr>
    </tbody>
  </table>
  <p>Both languages are widely used and most FPGA/ASIC tools support both -- some teams even mix them in the same project. Learning the concepts (entities/modules, signals/wires, processes/always blocks) transfers directly between the two.</p>',
  3
)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  content = VALUES(content),
  sort_order = VALUES(sort_order);

-- =========================================================================
-- Arduino
-- =========================================================================

INSERT INTO lessons (course_id, slug, title, content, sort_order) VALUES
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'arduino-ide-setup',
  'Arduino IDE & Board Setup',
  '<h3>Getting set up</h3>
  <ol>
    <li>Install the Arduino IDE from the official Arduino website.</li>
    <li>Connect your board (e.g. an Arduino Uno) via USB.</li>
    <li>In the IDE, select your board under <strong>Tools &gt; Board</strong> and your USB port under <strong>Tools &gt; Port</strong>.</li>
    <li>Open a sketch (an Arduino program file) and click <strong>Upload</strong> to compile and flash it to the board.</li>
  </ol>
  <h3>Sketch structure</h3>
  <p>Every Arduino sketch has exactly two required functions:</p>
  <pre><code>void setup() {
    // Runs once, when the board powers on or resets
    pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
    // Runs over and over, forever
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);
}</code></pre>
  <p>This particular sketch is the classic "Blink" example: it turns the onboard LED on and off every half second.</p>',
  1
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'digital-analog-io',
  'Digital & Analog I/O',
  '<h3>Digital I/O</h3>
  <pre><code>pinMode(7, OUTPUT);
digitalWrite(7, HIGH);   // set pin 7 to 5V (or 3.3V on some boards)

pinMode(2, INPUT);
int value = digitalRead(2);  // reads HIGH or LOW</code></pre>
  <h3>Analog input</h3>
  <p>Analog pins (labeled A0-A5 on an Uno) read a continuous voltage and convert it to a number from 0 to 1023 using a 10-bit analog-to-digital converter (ADC).</p>
  <pre><code>int sensorValue = analogRead(A0);       // 0 - 1023
float voltage = sensorValue * (5.0 / 1023.0);</code></pre>
  <h3>Analog-style output (PWM)</h3>
  <p>Most microcontrollers cannot output a true analog voltage directly, so <code>analogWrite()</code> uses PWM on specific pins (marked with a <code>~</code> on the board) to approximate one.</p>
  <pre><code>analogWrite(9, 128);  // ~50% duty cycle on PWM-capable pin 9</code></pre>
  <table class="data-table">
    <caption>Arduino Uno pin reference (summary)</caption>
    <thead><tr><th>Pins</th><th>Type</th><th>Notes</th></tr></thead>
    <tbody>
      <tr><td>0-13</td><td>Digital I/O</td><td>Pins marked ~ (e.g. 3, 5, 6, 9, 10, 11) support PWM</td></tr>
      <tr><td>A0-A5</td><td>Analog input</td><td>Can also be used as extra digital I/O pins</td></tr>
    </tbody>
  </table>',
  2
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'arduino-communication-protocols',
  'Communication Protocols',
  '<h3>Talking to other devices</h3>
  <p>Microcontrollers rarely work alone -- they need to talk to sensors, displays, and other boards. The three most common protocols on Arduino are Serial (UART), I2C, and SPI.</p>
  <table class="data-table">
    <caption>Serial vs. I2C vs. SPI</caption>
    <thead><tr><th>Protocol</th><th>Wires</th><th>Typical speed</th><th>Devices per bus</th><th>Typical use</th></tr></thead>
    <tbody>
      <tr><td>Serial (UART)</td><td>2 (TX, RX)</td><td>Up to ~1 Mbps</td><td>1-to-1</td><td>USB debugging, GPS modules, Bluetooth modules</td></tr>
      <tr><td>I2C</td><td>2 (SDA, SCL)</td><td>100 kHz-400 kHz typical</td><td>Many (addressed)</td><td>Sensors, small displays, low-speed peripherals</td></tr>
      <tr><td>SPI</td><td>4 (MOSI, MISO, SCK, CS)</td><td>Several MHz+</td><td>Many (one CS pin each)</td><td>SD cards, fast displays, high-speed sensors</td></tr>
    </tbody>
  </table>
  <h3>Example: reading an I2C sensor</h3>
  <pre><code>#include &lt;Wire.h&gt;

void setup() {
    Wire.begin();
    Serial.begin(9600);
}

void loop() {
    Wire.requestFrom(0x68, 1);   // request 1 byte from device at address 0x68
    if (Wire.available()) {
        byte data = Wire.read();
        Serial.println(data);
    }
    delay(100);
}</code></pre>',
  3
)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  content = VALUES(content),
  sort_order = VALUES(sort_order);
