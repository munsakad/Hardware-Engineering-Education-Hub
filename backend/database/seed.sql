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
  'electric-power-and-energy',
  'Electric Power & Energy',
  '<h3>Power in a circuit</h3>
  <p>Electrical power is the rate at which energy is delivered to or drawn from a circuit, measured in watts (W). Since voltage is energy per unit charge and current is charge per unit time, multiplying them gives energy per unit time -- power:</p>
  <pre><code>P = V &times; I</code></pre>
  <p>Combining this with Ohm&prime;s Law (V = IR) gives two more useful forms, handy when resistance is known but not both V and I:</p>
  <pre><code>P = I&sup2;R
P = V&sup2;/R</code></pre>

  <h3>Worked example</h3>
  <p>A 60 W light bulb is connected to a 120 V supply. How much current does it draw, and what is its resistance?</p>
  <pre><code>I = P / V = 60 / 120 = 0.5 A
R = V / I = 120 / 0.5 = 240 &Omega;</code></pre>

  <h3>Energy and electricity bills</h3>
  <p>Power is the rate of energy use; multiplying power by time gives total energy. Utility bills use the kilowatt-hour (kWh) -- the energy used by a 1000 W load running for one hour -- rather than the joule, since it is a more convenient size for household consumption.</p>
  <pre><code>Energy (kWh) = Power (kW) &times; Time (hours)</code></pre>
  <p>Example: a 100 W lamp left on for 10 hours uses 0.1 kW &times; 10 h = 1 kWh.</p>

  <h3>Efficiency</h3>
  <p>Real devices convert some input energy into a form other than the intended useful output -- almost always heat. Efficiency is the ratio of useful output power to total input power:</p>
  <pre><code>Efficiency (%) = (Useful output power / Input power) &times; 100</code></pre>
  <table class="data-table">
    <caption>Typical efficiency ranges</caption>
    <thead><tr><th>Device</th><th>Typical efficiency</th></tr></thead>
    <tbody>
      <tr><td>Incandescent light bulb</td><td>&asymp; 5% (most energy becomes heat, not light)</td></tr>
      <tr><td>LED light bulb</td><td>&asymp; 80-90%</td></tr>
      <tr><td>Switching power supply</td><td>&asymp; 85-95%</td></tr>
      <tr><td>Linear voltage regulator</td><td>Can be well under 50%, depending on the voltage it has to drop</td></tr>
    </tbody>
  </table>',
  2
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
  3
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'kirchhoffs-laws',
  'Kirchhoff&prime;s Laws',
  '<h3>Kirchhoff&prime;s Current Law (KCL)</h3>
  <p>KCL states that the total current flowing into any node (junction) must equal the total current flowing out of it -- charge cannot pile up or vanish at a point in a circuit.</p>
  <pre><code>&Sigma; I(in) = &Sigma; I(out)</code></pre>
  <p>Equivalently, if current flowing into a node is treated as positive and current flowing out as negative, the sum of all currents at a node is zero.</p>

  <h3>Kirchhoff&prime;s Voltage Law (KVL)</h3>
  <p>KVL states that the sum of all voltage rises and drops around any closed loop in a circuit must equal zero -- energy gained from sources around a loop must exactly equal energy given up across the loop&prime;s resistances and other elements.</p>
  <pre><code>&Sigma; V(rises) = &Sigma; V(drops)</code></pre>

  <h3>Worked example: a two-resistor loop</h3>
  <p>A 9 V battery drives two resistors, R1 = 100 &Omega; and R2 = 200 &Omega;, in series.</p>
  <pre><code>KVL: 9V = I &middot; R1 + I &middot; R2 = I(100 + 200)
I = 9 / 300 = 0.03 A = 30 mA

Voltage across R1: V1 = I &times; R1 = 0.03 &times; 100 = 3 V
Voltage across R2: V2 = I &times; R2 = 0.03 &times; 200 = 6 V
Check: V1 + V2 = 3 + 6 = 9 V = battery voltage &check;</code></pre>

  <h3>Why these laws matter</h3>
  <p>KCL and KVL are the two fundamental rules that every other circuit analysis technique -- series/parallel reduction, voltage/current dividers, Thevenin/Norton equivalents, mesh and nodal analysis -- is ultimately built from. Any circuit, no matter how complex, must satisfy both laws at every node and around every loop.</p>',
  4
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'circuit-analysis-techniques',
  'Circuit Analysis Techniques',
  '<h3>Voltage divider</h3>
  <p>Two resistors in series split an input voltage in proportion to their resistance -- the larger resistor gets the larger share of the voltage.</p>
  <pre><code>Vout = Vin &times; R2 / (R1 + R2)</code></pre>
  <p>Example: Vin = 12 V, R1 = 1 k&Omega;, R2 = 2 k&Omega; gives Vout = 12 &times; 2000/3000 = 8 V.</p>
  <p>Voltage dividers are simple, but "loading" (connecting anything else to Vout that draws current) changes the ratio -- they work best when whatever reads Vout draws very little current compared to what flows through R1 and R2.</p>

  <h3>Current divider</h3>
  <p>Two resistors in parallel split an input current inversely to their resistance -- the smaller resistor carries the larger share of the current.</p>
  <pre><code>I1 = Iin &times; R2 / (R1 + R2)
I2 = Iin &times; R1 / (R1 + R2)</code></pre>

  <h3>Thevenin&prime;s theorem</h3>
  <p>Any network of resistors and sources, viewed from just two terminals, behaves exactly like one ideal voltage source (V_TH) in series with one resistor (R_TH):</p>
  <ul>
    <li><strong>V_TH</strong> is the open-circuit voltage measured across the two terminals, with nothing else connected.</li>
    <li><strong>R_TH</strong> is the resistance measured across the terminals with all independent sources turned off (voltage sources replaced by short circuits, current sources replaced by open circuits).</li>
  </ul>
  <p>Reducing a complicated network to its Thevenin equivalent makes it easy to see how it will respond to whatever load is eventually connected, without re-analyzing the whole original circuit every time the load changes.</p>

  <h3>Norton&prime;s theorem</h3>
  <p>Norton&prime;s theorem is the dual of Thevenin&prime;s: the same two-terminal network can equally be modeled as one ideal current source (I_N) in parallel with one resistor (R_N = R_TH).</p>
  <pre><code>I_N = V_TH / R_TH</code></pre>
  <p>Thevenin and Norton equivalents of the same network are always interchangeable using this relationship.</p>

  <h3>Superposition</h3>
  <p>In any linear circuit with multiple independent sources, the voltage or current anywhere in the circuit is the sum of the contributions from each source acting alone, with every other independent source turned off (voltage sources shorted, current sources opened) one at a time.</p>',
  5
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'capacitors-and-capacitance',
  'Capacitors & Capacitance',
  '<h3>What a capacitor does</h3>
  <p>A capacitor stores electrical energy in an electric field between two conductive plates separated by an insulator (a dielectric). Capacitance C, measured in farads (F), describes how much charge a capacitor stores per volt across it:</p>
  <pre><code>C = Q / V</code></pre>
  <p>A farad is a very large unit for most electronics -- practical capacitors are usually specified in microfarads (&micro;F), nanofarads (nF), or picofarads (pF).</p>

  <h3>Capacitors in series and parallel</h3>
  <table class="data-table">
    <caption>Capacitor combination rules (the opposite pattern from resistors)</caption>
    <thead><tr><th>Arrangement</th><th>Formula</th></tr></thead>
    <tbody>
      <tr><td>Parallel</td><td>C_total = C1 + C2 + ...</td></tr>
      <tr><td>Series</td><td>1/C_total = 1/C1 + 1/C2 + ...</td></tr>
    </tbody>
  </table>
  <p>Capacitors combine the opposite way resistors do: parallel capacitors add directly (more plate area, more stored charge for the same voltage), while series capacitors combine like parallel resistors.</p>

  <h3>Charging and discharging: the RC time constant</h3>
  <p>Charging a capacitor through a resistor does not happen instantly -- the voltage across the capacitor rises (or falls) exponentially, characterized by the time constant &tau; (tau):</p>
  <pre><code>&tau; = R &times; C</code></pre>
  <p>&tau; is the time it takes the capacitor voltage to reach about 63% of its final value when charging (or fall to about 37% of its starting value when discharging). After roughly 5&tau;, a capacitor is considered fully charged or discharged for most practical purposes.</p>
  <table class="data-table">
    <caption>Capacitor voltage during charging (through a resistor from a fixed supply)</caption>
    <thead><tr><th>Time elapsed</th><th>% of final voltage reached</th></tr></thead>
    <tbody>
      <tr><td>1&tau;</td><td>&asymp; 63%</td></tr>
      <tr><td>2&tau;</td><td>&asymp; 86%</td></tr>
      <tr><td>3&tau;</td><td>&asymp; 95%</td></tr>
      <tr><td>5&tau;</td><td>&asymp; 99% (considered "fully charged")</td></tr>
    </tbody>
  </table>

  <h3>Energy stored in a capacitor</h3>
  <pre><code>E = &frac12; C V&sup2;</code></pre>

  <h3>Common uses</h3>
  <table class="data-table">
    <caption>Common capacitor applications</caption>
    <thead><tr><th>Application</th><th>Why a capacitor helps</th></tr></thead>
    <tbody>
      <tr><td>Decoupling / bulk supply filtering</td><td>Supplies quick bursts of current and smooths voltage dips near a chip</td></tr>
      <tr><td>Timing circuits</td><td>The RC time constant sets a predictable delay</td></tr>
      <tr><td>Blocking DC / passing AC</td><td>A charged capacitor blocks steady DC but still lets a changing AC signal through</td></tr>
    </tbody>
  </table>',
  6
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'inductors-and-inductance',
  'Inductors & Inductance',
  '<h3>What an inductor does</h3>
  <p>An inductor stores energy in a magnetic field created by current flowing through a coil of wire. Inductance L, measured in henries (H), describes how strongly a changing current induces an opposing voltage:</p>
  <pre><code>V = L &times; (dI/dt)</code></pre>
  <p>In words: the voltage across an inductor is proportional to how fast its current is changing, not to the current itself. An inductor carrying a perfectly steady current (dI/dt = 0) has zero voltage across it, no matter how large that current is.</p>

  <h3>Inductors in series and parallel</h3>
  <table class="data-table">
    <caption>Inductor combination rules (the same pattern as resistors)</caption>
    <thead><tr><th>Arrangement</th><th>Formula</th></tr></thead>
    <tbody>
      <tr><td>Series</td><td>L_total = L1 + L2 + ...</td></tr>
      <tr><td>Parallel</td><td>1/L_total = 1/L1 + 1/L2 + ...</td></tr>
    </tbody>
  </table>

  <h3>RL circuits and the time constant</h3>
  <p>Just as an RC circuit has a time constant &tau; = RC, an RL circuit (a resistor and inductor in series) has:</p>
  <pre><code>&tau; = L / R</code></pre>
  <p>Current through an inductor rises (or falls) exponentially toward its final value with this same time constant, following the same 63%/86%/95%/99% pattern as capacitor voltage.</p>

  <h3>Energy stored in an inductor</h3>
  <pre><code>E = &frac12; L I&sup2;</code></pre>

  <h3>An inductor resists sudden current changes</h3>
  <p>Because V = L(dI/dt), forcing an inductor&prime;s current to change instantly would require infinite voltage -- in practice, an inductor resists sudden current changes, the opposite behavior from a capacitor (which resists sudden voltage changes). This is why abruptly switching off current through an inductor (e.g. a relay coil) can produce a large voltage spike, usually suppressed with a flyback diode.</p>',
  7
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'ac-signals-and-rms',
  'AC Signals & RMS Values',
  '<h3>AC vs. DC</h3>
  <p>Direct current (DC) flows in one constant direction, like a battery. Alternating current (AC) periodically reverses direction, most commonly following a sine wave -- the form electricity is generated and distributed in worldwide.</p>

  <h3>Describing a sine wave</h3>
  <pre><code>v(t) = V_peak &middot; sin(2&pi;ft + &phi;)</code></pre>
  <table class="data-table">
    <caption>Sine wave parameters</caption>
    <thead><tr><th>Symbol</th><th>Meaning</th><th>Unit</th></tr></thead>
    <tbody>
      <tr><td>V_peak</td><td>Maximum instantaneous voltage</td><td>volts</td></tr>
      <tr><td>f</td><td>Frequency -- cycles per second</td><td>hertz (Hz)</td></tr>
      <tr><td>T</td><td>Period -- time for one full cycle, T = 1/f</td><td>seconds</td></tr>
      <tr><td>&phi;</td><td>Phase -- how far the wave is shifted in time relative to a reference</td><td>degrees or radians</td></tr>
    </tbody>
  </table>
  <table class="data-table">
    <caption>Standard mains AC power</caption>
    <thead><tr><th>Region</th><th>Frequency</th><th>Typical voltage (RMS)</th></tr></thead>
    <tbody>
      <tr><td>North America</td><td>60 Hz</td><td>120 V</td></tr>
      <tr><td>Europe / most of the world</td><td>50 Hz</td><td>230 V</td></tr>
    </tbody>
  </table>

  <h3>RMS: why AC voltage is not quoted as its peak value</h3>
  <p>Root-mean-square (RMS) voltage is the equivalent DC voltage that would deliver the same average power to a resistive load. For a pure sine wave:</p>
  <pre><code>V_RMS = V_peak / &radic;2  &asymp; 0.707 &times; V_peak</code></pre>
  <p>"120 V mains" means 120 V RMS -- the actual peak voltage on a North American outlet is about 120 &times; 1.414 &asymp; 170 V.</p>

  <h3>Average power in an AC resistive circuit</h3>
  <p>Once RMS values are used, the familiar DC power formulas apply directly:</p>
  <pre><code>P_avg = V_RMS &times; I_RMS = I_RMS&sup2; &times; R = V_RMS&sup2; / R</code></pre>',
  8
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'ac-circuit-analysis-impedance',
  'AC Circuit Analysis: Reactance & Impedance',
  '<h3>Why AC needs more than resistance</h3>
  <p>Capacitors and inductors oppose AC current in a way that depends on frequency, and -- unlike a resistor -- they also shift the timing (phase) between voltage and current. <strong>Reactance</strong> is the AC equivalent of resistance for these frequency-dependent components, measured in ohms.</p>

  <h3>Capacitive and inductive reactance</h3>
  <table class="data-table">
    <caption>Reactance formulas</caption>
    <thead><tr><th>Component</th><th>Reactance</th><th>Behavior as frequency rises</th></tr></thead>
    <tbody>
      <tr><td>Capacitor</td><td>X_C = 1 / (2&pi;fC)</td><td>Reactance falls -- a capacitor increasingly looks like a short circuit at high frequency</td></tr>
      <tr><td>Inductor</td><td>X_L = 2&pi;fL</td><td>Reactance rises -- an inductor increasingly looks like an open circuit at high frequency</td></tr>
    </tbody>
  </table>
  <p>This opposite frequency behavior is exactly why RC and RL circuits make useful filters, covered later in this course.</p>

  <h3>Impedance</h3>
  <p>Impedance Z generalizes resistance to AC circuits by combining resistance and reactance. Because reactance also shifts phase, impedance is naturally described as a complex number, with resistance as the real part and reactance as the imaginary part:</p>
  <pre><code>Z = R + jX</code></pre>
  <p>For a resistor and capacitor in series: Z = R - jX_C. For a resistor and inductor in series: Z = R + jX_L. Ohm&prime;s Law generalizes directly: V = I &times; Z, using complex (phasor) values for V, I, and Z.</p>

  <h3>Series RLC resonance</h3>
  <p>In a series RLC circuit, X_L and X_C work against each other because of their opposite signs. At one specific frequency, called the resonant frequency, they cancel exactly (X_L = X_C), leaving only R to oppose current -- current is at its maximum at resonance.</p>
  <pre><code>f_resonant = 1 / (2&pi;&radic;(LC))</code></pre>
  <p>Resonance is the underlying principle behind radio tuning circuits, which use an RLC-like network to select one desired frequency out of many.</p>',
  9
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
  10
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'power-supplies-and-voltage-regulation',
  'Power Supplies: Rectifiers & Regulation',
  '<h3>From AC mains to usable DC</h3>
  <p>Most electronics need a steady DC voltage, but wall power is AC. A power supply converts AC to DC in stages: rectification, filtering, and regulation.</p>

  <h3>Rectifiers</h3>
  <table class="data-table">
    <caption>Half-wave vs. full-wave rectification</caption>
    <thead><tr><th>Type</th><th>Diodes needed</th><th>Output</th></tr></thead>
    <tbody>
      <tr><td>Half-wave</td><td>1</td><td>Passes only the positive half of each AC cycle; the negative half is simply blocked, wasting half the input power</td></tr>
      <tr><td>Full-wave (bridge)</td><td>4 (in a bridge arrangement)</td><td>Flips the negative half of each cycle positive instead of discarding it, so both halves of every cycle contribute to the output</td></tr>
    </tbody>
  </table>
  <p>A full-wave bridge rectifier is by far the more common choice in real power supplies, since it uses the input power far more efficiently and produces a smoother, more easily filtered output.</p>

  <h3>Filtering</h3>
  <p>A rectifier alone produces a bumpy, pulsing DC output, not a flat one. A large filter capacitor placed across the output smooths this out: it charges toward the peak voltage on each pulse and then discharges slowly through the load between pulses, filling in the gaps. The remaining up-and-down wobble is called <strong>ripple</strong>, and it shrinks as the filter capacitor gets larger or the load current gets smaller.</p>

  <h3>Regulation</h3>
  <p>Even a well-filtered supply still sags under changing load and still has some ripple -- a voltage regulator holds the output at a fixed voltage despite both.</p>
  <table class="data-table">
    <caption>Linear vs. switching regulators</caption>
    <thead><tr><th>Aspect</th><th>Linear regulator</th><th>Switching regulator</th></tr></thead>
    <tbody>
      <tr><td>How it works</td><td>Acts like a variable resistor, dropping the excess voltage as heat</td><td>Rapidly switches a transistor on/off and filters the result with an inductor and capacitor</td></tr>
      <tr><td>Efficiency</td><td>Lower -- wastes power proportional to the voltage it drops</td><td>Higher -- typically 85-95%</td></tr>
      <tr><td>Noise / complexity</td><td>Very clean output, simple to use</td><td>Some switching noise, more complex, but far less wasted heat</td></tr>
      <tr><td>Typical use</td><td>Low-power, noise-sensitive analog circuits</td><td>Battery-powered devices, anywhere efficiency matters</td></tr>
    </tbody>
  </table>',
  11
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'operational-amplifiers',
  'Operational Amplifiers',
  '<h3>The ideal op-amp</h3>
  <p>An operational amplifier ("op-amp") is a high-gain amplifier with two inputs (inverting, marked "-", and non-inverting, marked "+") and one output. Circuit analysis is made simple by two ideal assumptions:</p>
  <ul>
    <li>The two input terminals draw no current (infinite input impedance).</li>
    <li>In a stable circuit with feedback, the op-amp drives its output so that the voltage difference between its two inputs is zero (infinite open-loop gain).</li>
  </ul>

  <h3>Inverting amplifier</h3>
  <pre><code>Vout = -(Rf / Rin) &times; Vin</code></pre>
  <p>The negative sign means the output is an inverted (flipped) and scaled copy of the input. The gain magnitude is set purely by the ratio of two resistors, Rf and Rin -- not by anything intrinsic to the op-amp itself, which is what makes op-amp circuits so predictable and easy to design.</p>

  <h3>Non-inverting amplifier</h3>
  <pre><code>Vout = (1 + Rf / Rin) &times; Vin</code></pre>
  <p>Here the output is in phase with the input, and the gain is always at least 1 (setting Rf = 0 gives a gain of exactly 1 -- a unity-gain buffer).</p>

  <h3>Comparator</h3>
  <p>Used without feedback, an op-amp simply drives its output fully to one supply rail or the other, depending on which input is higher -- a comparator, useful for detecting when a signal crosses a threshold.</p>
  <table class="truth-table">
    <caption>Op-amp used as a comparator</caption>
    <thead><tr><th>Condition</th><th>Output</th></tr></thead>
    <tbody>
      <tr><td>V+ &gt; V-</td><td>Output swings to the positive supply rail</td></tr>
      <tr><td>V+ &lt; V-</td><td>Output swings to the negative supply rail (or ground)</td></tr>
    </tbody>
  </table>',
  12
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'passive-filters',
  'Passive Filters',
  '<h3>Filtering by frequency</h3>
  <p>A filter passes some frequencies while attenuating (weakening) others. The simplest filters combine just one resistor and one capacitor.</p>

  <h3>Low-pass RC filter</h3>
  <p>Taking the output across the capacitor in a series RC circuit passes low frequencies (where the capacitor&prime;s reactance is large, so little signal is dropped across it) and attenuates high frequencies (where reactance is small, so most of the signal is dropped across the resistor instead).</p>
  <pre><code>f_cutoff = 1 / (2&pi;RC)</code></pre>

  <h3>High-pass RC filter</h3>
  <p>Taking the output across the resistor instead gives the opposite behavior: high frequencies pass through relatively unattenuated, while low frequencies are blocked (the capacitor&prime;s large reactance at low frequency drops most of the signal there instead).</p>
  <pre><code>f_cutoff = 1 / (2&pi;RC)   (same formula, same components, different output node)</code></pre>

  <h3>The cutoff frequency</h3>
  <p>At f_cutoff, the output power is reduced to half of its input value (the voltage drops to about 70.7% of the input, or -3 dB) -- this is the conventional dividing line between a filter&prime;s "passband" and its "stopband," even though the roll-off beyond that point is gradual rather than a hard cutoff.</p>

  <h3>RL filters</h3>
  <p>Resistor-inductor pairs form filters the same way, just with the roles reversed compared to RC, since inductive reactance rises with frequency instead of falling: a resistor-inductor low-pass filter takes its output across the resistor, and a high-pass filter takes its output across the inductor.</p>',
  13
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'electromagnetism-and-induction',
  'Electromagnetism & Induction',
  '<h3>Current creates a magnetic field</h3>
  <p>Any current-carrying wire produces a magnetic field around it; coiling the wire concentrates and strengthens that field, which is exactly what an inductor is. Wrapping the coil around an iron core concentrates it further still -- the basis of electromagnets, relays, and motor windings.</p>

  <h3>Faraday&prime;s law of induction</h3>
  <p>A changing magnetic field through a coil induces a voltage in that coil, proportional to how fast the magnetic flux is changing:</p>
  <pre><code>V_induced = -N &times; (d&Phi;/dt)</code></pre>
  <p>where N is the number of turns in the coil and &Phi; is the magnetic flux through it. This is the principle behind generators (a changing magnetic field, produced by moving a magnet or coil, creates electricity) and transformers (a changing current in one coil induces a voltage in a nearby coil).</p>

  <h3>Transformers</h3>
  <p>A transformer uses two coils sharing a common magnetic core to step voltage up or down between its primary and secondary windings, with essentially no direct electrical connection between the two sides.</p>
  <pre><code>V_secondary / V_primary = N_secondary / N_primary</code></pre>
  <p>An ideal transformer conserves power, so as voltage steps up, current steps down by the same ratio (and vice versa) -- it cannot deliver more power out than is put in.</p>

  <h3>Motors and generators: the same principle, run in opposite directions</h3>
  <p>A current-carrying conductor in a magnetic field experiences a force -- the basis of every electric motor. Running that same physical arrangement in reverse, mechanically spinning a conductor through a magnetic field, induces a current instead -- the basis of every generator. This connects directly to the Motor Control lesson in the Robotics course: a spinning DC motor is always also acting a little like a generator, producing a "back-EMF" that opposes the current driving it.</p>',
  14
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'measurement-instruments',
  'Measurement Instruments',
  '<h3>The multimeter</h3>
  <p>A multimeter is the single most useful tool in electronics, typically able to measure voltage, current, resistance, and continuity.</p>
  <table class="data-table">
    <caption>How to connect a multimeter</caption>
    <thead><tr><th>Measurement</th><th>Connection</th><th>Common mistake</th></tr></thead>
    <tbody>
      <tr><td>Voltage (V)</td><td>In parallel across the two points being measured</td><td>None major -- a voltmeter has very high input resistance, so it barely disturbs the circuit</td></tr>
      <tr><td>Current (A)</td><td>In series, breaking the circuit so current flows through the meter</td><td>Leaving the meter in current mode while measuring voltage can short the circuit through the meter&prime;s very low resistance, often blowing its internal fuse</td></tr>
      <tr><td>Resistance (&Omega;)</td><td>Across an isolated component, with power removed from the circuit</td><td>Measuring resistance in a live, powered circuit gives a wrong reading and can damage the meter</td></tr>
    </tbody>
  </table>

  <h3>The oscilloscope</h3>
  <p>An oscilloscope plots voltage on the vertical axis against time on the horizontal axis, which a multimeter cannot show -- it is the tool for seeing waveform shape, frequency, timing relationships between signals, and glitches that a single numeric reading would completely miss.</p>
  <table class="data-table">
    <caption>Key oscilloscope controls</caption>
    <thead><tr><th>Control</th><th>What it sets</th></tr></thead>
    <tbody>
      <tr><td>Volts/division</td><td>Vertical scale -- how many volts each grid square represents</td></tr>
      <tr><td>Time/division</td><td>Horizontal scale -- how much time each grid square represents</td></tr>
      <tr><td>Trigger</td><td>The condition (e.g. a rising edge crossing a set voltage) that tells the scope when to start each new sweep, so a repeating waveform appears stable on screen instead of scrolling</td></tr>
    </tbody>
  </table>',
  15
),
(
  (SELECT id FROM courses WHERE slug = 'electricity-electronics-basics'),
  'circuit-protection-and-safety',
  'Circuit Protection & Safety',
  '<h3>Fuses and circuit breakers</h3>
  <p>Both protect a circuit from excessive current, which can overheat wires and start fires, by breaking the circuit before that happens.</p>
  <table class="data-table">
    <caption>Fuses vs. circuit breakers</caption>
    <thead><tr><th>Aspect</th><th>Fuse</th><th>Circuit breaker</th></tr></thead>
    <tbody>
      <tr><td>How it works</td><td>A thin metal element melts and breaks the circuit when current exceeds its rating</td><td>A mechanical (or electronic) switch trips open when current exceeds its rating</td></tr>
      <tr><td>After tripping</td><td>Must be replaced</td><td>Can simply be reset and reused</td></tr>
      <tr><td>Typical use</td><td>Individual devices and circuit boards</td><td>Household electrical panels</td></tr>
    </tbody>
  </table>

  <h3>Grounding</h3>
  <p>"Ground" (or "earth") is a common reference point that circuit voltages are measured relative to, and, in mains wiring, a dedicated safety conductor. A properly grounded metal appliance chassis gives a fault current (e.g. a wire touching the case) a low-resistance path back to the source, tripping a breaker or fuse quickly instead of leaving the case dangerously energized and waiting for a person to complete the circuit instead.</p>

  <h3>Electric shock and safe practice</h3>
  <table class="data-table">
    <caption>Approximate effects of AC current through the body (illustrative only -- actual thresholds vary by person and current path)</caption>
    <thead><tr><th>Current</th><th>Typical effect</th></tr></thead>
    <tbody>
      <tr><td>&asymp; 1 mA</td><td>Threshold of perception (a slight tingle)</td></tr>
      <tr><td>&asymp; 10-20 mA</td><td>Painful shock; muscles may not be able to let go ("let-go threshold")</td></tr>
      <tr><td>&asymp; 100-200 mA</td><td>Can cause ventricular fibrillation and be fatal</td></tr>
    </tbody>
  </table>
  <p>A few practical habits matter far more than memorizing thresholds: always assume a circuit is live until it has been verified otherwise with a meter, discharge capacitors before touching a circuit (they can hold a dangerous charge long after power is removed), work with one hand where practical to avoid a current path across the chest, and never work alone on anything connected to mains voltage.</p>

  <h3>Electrostatic discharge (ESD)</h3>
  <p>Static electricity built up on a person or surface can silently destroy sensitive semiconductors (especially MOSFETs) with a discharge far too small to feel. Anti-static wrist straps, ESD-safe mats, and grounded soldering equipment are standard precautions when handling bare ICs and other sensitive components.</p>',
  16
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
  'binary-arithmetic-signed-numbers',
  'Binary Arithmetic & Signed Numbers',
  '<h3>Binary addition</h3>
  <p>Binary addition follows the same place-value rules as decimal addition, but with only two digits. There are four possible single-bit cases:</p>
  <table class="truth-table">
    <caption>Single-bit binary addition</caption>
    <thead><tr><th>A</th><th>B</th><th>Sum</th><th>Carry</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>0</td><td>1</td></tr>
    </tbody>
  </table>
  <p>Multi-bit numbers are added column by column, carrying into the next column just like decimal addition:</p>
  <pre><code>  1011   (11)
+ 0110   ( 6)
------
  10001  (17)</code></pre>

  <h3>Representing negative numbers: complements</h3>
  <p>Digital systems have no separate minus-sign wire, so negative numbers are encoded using complements.</p>
  <table class="data-table">
    <caption>Complement systems for an n-bit number N</caption>
    <thead><tr><th>System</th><th>Rule</th><th>Example (4-bit, N = 0110)</th></tr></thead>
    <tbody>
      <tr><td>1&prime;s complement</td><td>Flip every bit</td><td>0110 &rarr; 1001</td></tr>
      <tr><td>2&prime;s complement</td><td>Flip every bit, then add 1</td><td>0110 &rarr; 1001 + 1 = 1010</td></tr>
    </tbody>
  </table>
  <p>Two&prime;s complement is what almost all real hardware uses, because it has a single representation for zero and turns subtraction into addition.</p>

  <h3>Two&prime;s complement representation</h3>
  <p>In an n-bit two&prime;s complement number, the most significant bit (MSB) is a sign bit: 0 means positive, 1 means negative. To negate a number, take its two&prime;s complement.</p>
  <table class="data-table">
    <caption>4-bit two&prime;s complement range</caption>
    <thead><tr><th>Bits</th><th>Value</th></tr></thead>
    <tbody>
      <tr><td>0111</td><td>+7 (largest positive)</td></tr>
      <tr><td>0000</td><td>0</td></tr>
      <tr><td>1111</td><td>-1</td></tr>
      <tr><td>1000</td><td>-8 (largest negative)</td></tr>
    </tbody>
  </table>
  <p>An n-bit two&prime;s complement number ranges from -2^(n-1) to +2^(n-1)-1.</p>

  <h3>Subtraction using two&prime;s complement</h3>
  <p>A - B is computed as A + (two&prime;s complement of B), discarding any carry out of the MSB:</p>
  <pre><code>A = 0110 (6)
B = 0011 (3)
two''s complement of B = 1101

  0110
+ 1101
------
 10011  -&gt; discard the leading carry -&gt; 0011 (3) = 6 - 3</code></pre>

  <h3>Overflow</h3>
  <p>Overflow occurs when adding two numbers with the same sign produces a result with the opposite sign -- meaning the true result did not fit in the available bits. Hardware detects this by comparing the carry into the sign bit with the carry out of the sign bit: if they differ, overflow occurred.</p>

  <h3>Binary-coded decimal (BCD)</h3>
  <p>BCD encodes each decimal digit (0-9) separately in 4 bits, rather than converting the whole number to pure binary. It wastes some bit patterns (1010-1111 are unused) but makes conversion to and from human-readable decimal trivial -- useful for displays and calculators.</p>
  <table class="data-table">
    <caption>BCD examples</caption>
    <thead><tr><th>Decimal</th><th>BCD</th></tr></thead>
    <tbody>
      <tr><td>9</td><td>1001</td></tr>
      <tr><td>23</td><td>0010 0011</td></tr>
      <tr><td>99</td><td>1001 1001</td></tr>
    </tbody>
  </table>

  <h3>Gray code</h3>
  <p>Gray code orders binary patterns so that only one bit changes between consecutive values, which avoids glitches when a counter or sensor value is read while it is changing. It is widely used in rotary encoders and in Karnaugh map layouts.</p>
  <table class="data-table">
    <caption>3-bit binary vs. Gray code</caption>
    <thead><tr><th>Decimal</th><th>Binary</th><th>Gray code</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>000</td><td>000</td></tr>
      <tr><td>1</td><td>001</td><td>001</td></tr>
      <tr><td>2</td><td>010</td><td>011</td></tr>
      <tr><td>3</td><td>011</td><td>010</td></tr>
      <tr><td>4</td><td>100</td><td>110</td></tr>
      <tr><td>5</td><td>101</td><td>111</td></tr>
      <tr><td>6</td><td>110</td><td>101</td></tr>
      <tr><td>7</td><td>111</td><td>100</td></tr>
    </tbody>
  </table>',
  2
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'boolean-algebra-basics',
  'Boolean Algebra Basics',
  '<h3>What Boolean algebra is</h3>
  <p>Boolean algebra is a mathematical system, introduced by George Boole and later applied to switching circuits by Claude Shannon, that works with variables which can only take one of two values: 0 (false) and 1 (true). It gives a formal way to write, manipulate, and simplify the same logic that a truth table or a gate diagram describes.</p>

  <h3>The three basic operations</h3>
  <table class="data-table">
    <caption>Boolean operations and their notations</caption>
    <thead><tr><th>Operation</th><th>Also called</th><th>Common notations</th><th>Gate equivalent</th></tr></thead>
    <tbody>
      <tr><td>Complement</td><td>NOT, inversion</td><td>A&prime;, &not;A, an overbar over A</td><td>NOT gate</td></tr>
      <tr><td>Logical product</td><td>AND, conjunction</td><td>A &middot; B, AB, A &and; B</td><td>AND gate</td></tr>
      <tr><td>Logical sum</td><td>OR, disjunction</td><td>A + B, A &or; B</td><td>OR gate</td></tr>
    </tbody>
  </table>
  <p>Despite the "+" and "&middot;" symbols borrowed from ordinary algebra, Boolean addition and multiplication do <strong>not</strong> behave exactly like arithmetic -- most importantly, 1 + 1 = 1, not 2, because the result can only ever be 0 or 1.</p>

  <h3>Operator precedence</h3>
  <p>Just like arithmetic, Boolean expressions have an order of operations: complement first, then AND, then OR (parentheses override this order). For example:</p>
  <pre><code>F = A + B &middot; C&prime;</code></pre>
  <p>is evaluated as A OR (B AND (NOT C)), not (A OR B) AND (NOT C).</p>

  <h3>Three equivalent descriptions of the same logic</h3>
  <p>Any Boolean function can be described in three completely equivalent ways -- a truth table, a Boolean expression, and a gate-level logic diagram -- and a good digital designer moves freely between all three.</p>
  <table class="truth-table">
    <caption>Example function F = A&prime;B + AB&prime; (this is exclusive OR)</caption>
    <thead><tr><th>A</th><th>B</th><th>F</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>1</td></tr>
      <tr><td>1</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>1</td><td>0</td></tr>
    </tbody>
  </table>
  <p>A literal is a single variable or its complement (e.g. A or A&prime;). A product term (like A&prime;B) is a set of literals ANDed together, and a sum-of-products expression is several product terms ORed together.</p>',
  3
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'laws-of-boolean-algebra',
  'Laws of Boolean Algebra',
  '<h3>Why the laws matter</h3>
  <p>The laws of Boolean algebra let a designer rewrite an expression into an equivalent -- but simpler, or more convenient -- form without building a truth table every time. They are the algebraic toolkit used to minimize a circuit before laying out gates.</p>

  <h3>Basic identities</h3>
  <table class="data-table">
    <caption>Identity, null, idempotent, and complement laws</caption>
    <thead><tr><th>Law</th><th>AND form</th><th>OR form</th></tr></thead>
    <tbody>
      <tr><td>Identity</td><td>A &middot; 1 = A</td><td>A + 0 = A</td></tr>
      <tr><td>Null / Dominance</td><td>A &middot; 0 = 0</td><td>A + 1 = 1</td></tr>
      <tr><td>Idempotent</td><td>A &middot; A = A</td><td>A + A = A</td></tr>
      <tr><td>Complement</td><td>A &middot; A&prime; = 0</td><td>A + A&prime; = 1</td></tr>
    </tbody>
  </table>
  <p><strong>Involution (double complement):</strong> (A&prime;)&prime; = A -- inverting twice returns the original value.</p>

  <h3>Commutative and associative laws</h3>
  <table class="data-table">
    <caption>Commutative and associative laws</caption>
    <thead><tr><th>Law</th><th>AND form</th><th>OR form</th></tr></thead>
    <tbody>
      <tr><td>Commutative</td><td>AB = BA</td><td>A + B = B + A</td></tr>
      <tr><td>Associative</td><td>(AB)C = A(BC)</td><td>(A + B) + C = A + (B + C)</td></tr>
    </tbody>
  </table>

  <h3>Distributive and absorption laws</h3>
  <table class="data-table">
    <caption>Distributive and absorption laws</caption>
    <thead><tr><th>Law</th><th>Statement</th></tr></thead>
    <tbody>
      <tr><td>Distributive</td><td>A(B + C) = AB + AC</td></tr>
      <tr><td>Distributive (dual)</td><td>A + BC = (A + B)(A + C)</td></tr>
      <tr><td>Absorption</td><td>A + AB = A</td></tr>
      <tr><td>Absorption (variant)</td><td>A(A + B) = A</td></tr>
      <tr><td>Absorption (variant 2)</td><td>A + A&prime;B = A + B</td></tr>
    </tbody>
  </table>
  <p>Absorption is one of the most useful simplification tools -- it lets you eliminate a redundant term that is already covered by a simpler one.</p>

  <h3>Consensus (redundancy) theorem</h3>
  <pre><code>AB + A&prime;C + BC = AB + A&prime;C</code></pre>
  <p>The term BC is the "consensus" of AB and A&prime;C (formed by combining the non-complementary variables of two terms that contain a variable and its complement). It is always redundant algebraically and can be dropped -- though, as the timing lesson later in this course shows, that exact redundant term is sometimes deliberately kept in real hardware to prevent a glitch.</p>

  <h3>De Morgan&prime;s theorems</h3>
  <table class="data-table">
    <caption>De Morgan&prime;s theorems</caption>
    <thead><tr><th>Form</th><th>Statement</th><th>In words</th></tr></thead>
    <tbody>
      <tr><td>1</td><td>(A + B)&prime; = A&prime; &middot; B&prime;</td><td>NOT of an OR = AND of the NOTs</td></tr>
      <tr><td>2</td><td>(A &middot; B)&prime; = A&prime; + B&prime;</td><td>NOT of an AND = OR of the NOTs</td></tr>
    </tbody>
  </table>
  <p>De Morgan&prime;s theorems are the reason NAND and NOR gates are "universal" -- they let you convert freely between AND/OR/NOT combinations, which is essential for implementing a design using only NAND gates or only NOR gates.</p>

  <h3>The principle of duality</h3>
  <p>Every Boolean identity has a "dual," formed by swapping AND &harr; OR and 0 &harr; 1 everywhere. For example, the dual of A + A&prime;B = A + B is A(A&prime; + B) = AB. This is why the laws above are almost always listed in AND/OR pairs.</p>

  <h3>Worked simplification example</h3>
  <pre><code>F = AB + AB&prime; + A&prime;B
  = A(B + B&prime;) + A&prime;B      (distributive)
  = A &middot; 1 + A&prime;B          (complement law)
  = A + A&prime;B                 (identity law)
  = A + B                     (absorption variant 2)</code></pre>',
  4
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

  <p>NAND and NOR are called "universal gates" because either one, alone, can be wired together to build any other gate -- which is why they are so common inside real chips.</p>

  <h3>Buffers and tri-state buffers</h3>
  <p>A buffer is a one-input, one-output gate whose truth table is simply OUT = A -- it does not change the logic value at all. Its purpose is entirely practical: it restores signal strength and drive current on a long wire or a wire feeding many other gates (a "high fan-out" wire).</p>
  <p>A tri-state buffer adds a third possible output state, high-impedance (<strong>Z</strong>), controlled by an enable input. When disabled, the output floats and does not affect the wire it is connected to -- essential for building shared buses where several devices take turns driving the same line.</p>
  <table class="truth-table">
    <caption>Tri-state buffer</caption>
    <thead><tr><th>EN</th><th>A</th><th>OUT</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>X</td><td>Z (high-impedance / disconnected)</td></tr>
      <tr><td>1</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>

  <h3>Building any gate from NAND only</h3>
  <table class="data-table">
    <caption>Gate constructions using only NAND gates</caption>
    <thead><tr><th>Gate wanted</th><th>NAND-only construction</th></tr></thead>
    <tbody>
      <tr><td>NOT A</td><td>NAND(A, A)</td></tr>
      <tr><td>A AND B</td><td>NAND(X, X), where X = NAND(A, B)</td></tr>
      <tr><td>A OR B</td><td>NAND(NAND(A,A), NAND(B,B))</td></tr>
      <tr><td>A NOR B</td><td>NAND(Y, Y), where Y = NAND(NAND(A,A), NAND(B,B)) is A OR B</td></tr>
    </tbody>
  </table>

  <h3>Building any gate from NOR only</h3>
  <table class="data-table">
    <caption>Gate constructions using only NOR gates</caption>
    <thead><tr><th>Gate wanted</th><th>NOR-only construction</th></tr></thead>
    <tbody>
      <tr><td>NOT A</td><td>NOR(A, A)</td></tr>
      <tr><td>A OR B</td><td>NOR(X, X), where X = NOR(A, B)</td></tr>
      <tr><td>A AND B</td><td>NOR(NOR(A,A), NOR(B,B))</td></tr>
    </tbody>
  </table>
  <p>This substitution matters in real chip fabrication: NAND and NOR gates built from CMOS transistors are simpler and faster than AND/OR gates (an AND gate is actually a NAND gate followed by an internal inverter), so digital designs are usually mapped internally onto NAND/NOR networks.</p>

  <h3>Fan-in and multiple-input gates</h3>
  <p>AND, OR, NAND, NOR, XOR, and XNOR all generalize naturally to more than two inputs -- for example, a 4-input AND gate outputs 1 only when all four inputs are 1. The number of inputs a gate accepts is called its <strong>fan-in</strong>. XOR and XNOR generalize as odd/even parity functions rather than "exactly one input is 1": a multi-input XOR outputs 1 when an odd number of its inputs are 1.</p>',
  5
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'canonical-forms-sop-pos',
  'Canonical Forms: SOP & POS',
  '<h3>Minterms and maxterms</h3>
  <p>For a function of n variables, a <strong>minterm</strong> is a product (AND) term that includes every variable exactly once, either true or complemented, so that it equals 1 for exactly one row of the truth table. A <strong>maxterm</strong> is the dual: a sum (OR) term that includes every variable exactly once, and equals 0 for exactly one row.</p>
  <table class="truth-table">
    <caption>Minterms and maxterms for two variables A, B</caption>
    <thead><tr><th>A</th><th>B</th><th>Minterm</th><th>Notation</th><th>Maxterm</th><th>Notation</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>A&prime;B&prime;</td><td>m0</td><td>A + B</td><td>M0</td></tr>
      <tr><td>0</td><td>1</td><td>A&prime;B</td><td>m1</td><td>A + B&prime;</td><td>M1</td></tr>
      <tr><td>1</td><td>0</td><td>AB&prime;</td><td>m2</td><td>A&prime; + B</td><td>M2</td></tr>
      <tr><td>1</td><td>1</td><td>AB</td><td>m3</td><td>A&prime; + B&prime;</td><td>M3</td></tr>
    </tbody>
  </table>
  <p>The minterm/maxterm index is simply the input combination for that row, read as a binary number.</p>

  <h3>Canonical sum-of-products (SOP)</h3>
  <p>Any Boolean function can be written as the OR of the minterms for every row where the output is 1. This is the <strong>canonical SOP</strong> (or "standard SOP") form.</p>
  <table class="truth-table">
    <caption>Example function F(A,B,C)</caption>
    <thead><tr><th>A</th><th>B</th><th>C</th><th>F</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>0</td><td>1</td><td>1</td></tr>
      <tr><td>0</td><td>1</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>1</td><td>1</td></tr>
      <tr><td>1</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>
  <pre><code>F(A,B,C) = A&prime;B&prime;C + A&prime;BC + ABC&prime; + ABC
         = m1 + m3 + m6 + m7
         = &Sigma;m(1, 3, 6, 7)</code></pre>

  <h3>Canonical product-of-sums (POS)</h3>
  <p>The same function can equally be written as the AND of the maxterms for every row where the output is 0 -- the <strong>canonical POS</strong> form.</p>
  <pre><code>F(A,B,C) = (A + B + C)(A + B&prime; + C)(A&prime; + B + C)(A&prime; + B + C&prime;)
         = M0 &middot; M2 &middot; M4 &middot; M5
         = &prod;M(0, 2, 4, 5)</code></pre>
  <p>Notice SOP uses the rows where F = 1 and POS uses the rows where F = 0 -- the two forms are complementary views of the exact same truth table.</p>

  <h3>Converting between SOP and POS</h3>
  <p>Given the canonical SOP as &Sigma;m(...), the maxterm indices for the POS form are simply all the indices <em>not</em> in that list, with De Morgan&prime;s theorem justifying the switch between AND and OR. Canonical forms are rarely the most efficient circuit to actually build -- the next lesson covers how to minimize them.</p>',
  6
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'karnaugh-maps',
  'Karnaugh Maps & Minimization',
  '<h3>Why Karnaugh maps</h3>
  <p>Algebraic simplification works, but it is easy to miss a possible simplification by hand. A Karnaugh map (K-map) rearranges a truth table into a grid where physically adjacent cells differ by exactly one bit, so the groups you can simplify are visually obvious as rectangular blocks of 1s.</p>

  <h3>2-variable K-map</h3>
  <pre><code>        B=0   B=1
A=0      m0    m1
A=1      m2    m3</code></pre>

  <h3>3-variable K-map</h3>
  <p>The column headings are ordered in Gray code (00, 01, 11, 10) rather than plain binary, specifically so that adjacent columns -- including the wraparound from the last column back to the first -- differ by only one bit.</p>
  <pre><code>          BC=00  BC=01  BC=11  BC=10
A=0        m0     m1     m3     m2
A=1        m4     m5     m7     m6</code></pre>

  <h3>4-variable K-map</h3>
  <pre><code>            CD=00  CD=01  CD=11  CD=10
AB=00        m0     m1     m3     m2
AB=01        m4     m5     m7     m6
AB=11        m12    m13    m15    m14
AB=10        m8     m9     m11    m10</code></pre>

  <h3>Grouping rules</h3>
  <ul>
    <li>Place a 1 in every cell whose minterm belongs to the function.</li>
    <li>Circle groups of 1s whose size is a power of 2 (1, 2, 4, 8, 16 cells) -- never groups of 3, 5, 6, or 7.</li>
    <li>Groups may wrap around the top/bottom edges and the left/right edges of the map (the grid behaves like a torus).</li>
    <li>Make each group as large as possible, and use as few groups as possible while still covering every 1 at least once.</li>
    <li>Each group becomes one product term in the minimized SOP: any variable that takes both 0 and 1 within the group drops out; any variable that stays constant across the group appears (true if it stayed 1, complemented if it stayed 0).</li>
  </ul>

  <h3>Worked example (4 variables)</h3>
  <p>Minimize F(A,B,C,D) = &Sigma;m(0, 1, 2, 3, 8, 9, 10, 11) -- that is, F = 1 whenever the pair (A,B) equals 00 or 10, for any C, D.</p>
  <pre><code>            CD=00  CD=01  CD=11  CD=10
AB=00         1      1      1      1
AB=01         0      0      0      0
AB=11         0      0      0      0
AB=10         1      1      1      1</code></pre>
  <p>Rows AB=00 and AB=10 are both entirely 1, and (thanks to wraparound) they are adjacent to each other, forming one group of 8 cells in which only B stays constant, at 0:</p>
  <pre><code>F = B&prime;</code></pre>

  <h3>Do not care conditions</h3>
  <p>Some input combinations may never actually occur (e.g. BCD digit codes 1010-1111), or their output may not matter for a given application. These are marked "X" (don&prime;t care) on the map. You are free to treat each X as a 0 or a 1, whichever helps form a larger group -- but you are never required to cover an X.</p>

  <h3>Beyond four variables</h3>
  <p>K-maps become hard to draw and read past five or six variables. For larger functions, the tabular <strong>Quine-McCluskey method</strong> performs the same "combine terms that differ by one bit" process algorithmically (and is the basis of automated logic minimization tools), followed by a prime-implicant selection step that picks the smallest covering set of terms.</p>',
  7
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'combinational-circuit-design',
  'Combinational Circuit Design',
  '<h3>What makes a circuit "combinational"</h3>
  <p>A combinational circuit&prime;s outputs depend only on its current inputs, with no memory of the past. Every circuit covered in the next several lessons -- adders, multiplexers, decoders, comparators -- is combinational; sequential circuits (with memory) are covered later in this course.</p>

  <h3>The standard design process</h3>
  <ol>
    <li><strong>Specify the problem</strong> in words, then translate it into a truth table listing every input combination and the required output(s).</li>
    <li><strong>Derive a Boolean expression</strong> for each output, typically starting from the canonical SOP (or POS) form read directly off the truth table.</li>
    <li><strong>Minimize</strong> the expression algebraically or with a Karnaugh map to reduce the gate count and the number of levels of logic.</li>
    <li><strong>Draw the logic diagram</strong>, choosing gates that are actually available (e.g. only 2-input gates, or only NAND gates for a particular chip family).</li>
    <li><strong>Verify</strong> the circuit against the original truth table, by hand or in simulation, before building or fabricating it.</li>
  </ol>

  <h3>Design trade-offs</h3>
  <table class="data-table">
    <caption>Common trade-offs in combinational design</caption>
    <thead><tr><th>Trade-off</th><th>Why it matters</th></tr></thead>
    <tbody>
      <tr><td>Gate count vs. speed</td><td>Fewer levels of logic between input and output means shorter propagation delay, even at the cost of more gates</td></tr>
      <tr><td>Fan-in limits</td><td>Real gates only accept a limited number of inputs; a 6-input AND may need to be built from smaller gates</td></tr>
      <tr><td>Fan-out limits</td><td>A single gate output can only reliably drive a limited number of downstream gate inputs before needing a buffer</td></tr>
      <tr><td>Reusability</td><td>Building from standard blocks (muxes, decoders, adders) is easier to design, verify, and reuse than one giant minimized expression</td></tr>
    </tbody>
  </table>

  <h3>Standard combinational building blocks</h3>
  <p>In practice, digital designers rarely minimize truth tables by hand for anything but small examples -- most real designs are assembled from a toolbox of standard combinational blocks, each covered in its own lesson next:</p>
  <table class="data-table">
    <caption>Standard combinational blocks covered in this course</caption>
    <thead><tr><th>Block</th><th>Purpose</th></tr></thead>
    <tbody>
      <tr><td>Adder / subtractor</td><td>Binary arithmetic</td></tr>
      <tr><td>Multiplexer / demultiplexer</td><td>Route one of several signals; implement any truth table directly</td></tr>
      <tr><td>Decoder / encoder</td><td>Convert between a binary code and a one-of-many activation signal</td></tr>
      <tr><td>Comparator</td><td>Determine equality or ordering of two binary numbers</td></tr>
      <tr><td>Parity generator/checker</td><td>Add simple error detection to transmitted or stored data</td></tr>
    </tbody>
  </table>',
  8
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'adders-and-subtractors',
  'Adders & Subtractors',
  '<h3>Half adder</h3>
  <p>A half adder adds two single bits, producing a sum and a carry-out, but has no input for a carry from a previous stage.</p>
  <table class="truth-table">
    <caption>Half adder</caption>
    <thead><tr><th>A</th><th>B</th><th>Sum</th><th>Cout</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>0</td><td>1</td></tr>
    </tbody>
  </table>
  <pre><code>Sum  = A &oplus; B
Cout = A &middot; B</code></pre>
  <p>A half adder is just one XOR gate and one AND gate.</p>

  <h3>Full adder</h3>
  <p>A full adder also accepts a carry-in, so full adders can be chained together to add numbers of any width.</p>
  <table class="truth-table">
    <caption>Full adder</caption>
    <thead><tr><th>A</th><th>B</th><th>Cin</th><th>Sum</th><th>Cout</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>0</td><td>1</td><td>1</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>1</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>0</td><td>1</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>1</td><td>0</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>
  <pre><code>Sum  = A &oplus; B &oplus; Cin
Cout = AB + ACin + BCin</code></pre>
  <p>A full adder can be built from two half adders: the first adds A and B, the second adds that result to Cin, and the two carry-outs are ORed together.</p>

  <h3>Ripple-carry adder</h3>
  <p>Chaining n full adders, with each stage&prime;s Cout feeding the next stage&prime;s Cin, builds an n-bit adder. It is called "ripple carry" because a carry generated at the least significant bit may have to propagate ("ripple") all the way to the most significant bit, making the worst-case delay grow with the number of bits -- the main drawback of this simple design.</p>

  <h3>Carry-look-ahead adder</h3>
  <p>A carry-look-ahead adder computes all the carries in parallel ahead of time instead of waiting for them to ripple through, trading extra gates for much lower delay on wide adders. For each bit position i, define:</p>
  <pre><code>Pi = Ai &oplus; Bi          (carry "propagate")
Gi = Ai &middot; Bi           (carry "generate")
C(i+1) = Gi + Pi &middot; Ci     (carry out of stage i)</code></pre>
  <p>Because each C(i+1) depends only on the original inputs (through the Gi, Pi, and lower carry terms) rather than on a chain of full adders, these expressions can be expanded and computed with only a few levels of logic.</p>

  <h3>Half subtractor</h3>
  <table class="truth-table">
    <caption>Half subtractor (computes A - B)</caption>
    <thead><tr><th>A</th><th>B</th><th>Diff</th><th>Borrow</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>1</td><td>1</td></tr>
      <tr><td>1</td><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>0</td><td>0</td></tr>
    </tbody>
  </table>
  <pre><code>Diff   = A &oplus; B
Borrow = A&prime; &middot; B</code></pre>

  <h3>Full subtractor</h3>
  <p>Like a full adder, a full subtractor accepts a borrow-in (Bin) so subtractors can be chained across multiple bits.</p>
  <pre><code>Diff = A &oplus; B &oplus; Bin
Bout = A&prime;B + A&prime;Bin + BBin</code></pre>

  <h3>Combined adder/subtractor circuit</h3>
  <p>Rather than building separate adder and subtractor hardware, real ALUs use one ripple-carry adder plus a control line M: each B input is first XORed with M, and M also feeds the first carry-in. When M = 0, B passes through unchanged and the circuit adds; when M = 1, B is bitwise complemented and 1 is added via the carry-in, which is exactly the two&prime;s complement of B -- so the same adder now computes A - B.</p>

  <h3>BCD adder</h3>
  <p>Adding two BCD digits with a plain 4-bit binary adder can produce an invalid result (greater than 9) whenever there is a carry, since BCD only uses codes 0000-1001. A BCD adder detects this (a sum greater than 9, or a carry-out having occurred) and corrects it by adding 6 (0110) to force the result back into valid BCD and to generate the correct carry into the next decimal digit.</p>',
  9
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'multiplexers-demultiplexers',
  'Multiplexers & Demultiplexers',
  '<h3>Multiplexer (mux)</h3>
  <p>A multiplexer selects one of several data inputs and routes it to a single output, based on the value of one or more select lines. A mux with n select lines can choose among 2^n data inputs.</p>
  <table class="truth-table">
    <caption>2-to-1 multiplexer</caption>
    <thead><tr><th>S</th><th>Output Y</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>Y = A</td></tr>
      <tr><td>1</td><td>Y = B</td></tr>
    </tbody>
  </table>
  <pre><code>Y = S&prime;A + SB</code></pre>

  <h3>4-to-1 multiplexer</h3>
  <table class="truth-table">
    <caption>4-to-1 multiplexer</caption>
    <thead><tr><th>S1</th><th>S0</th><th>Output Y</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>Y = D0</td></tr>
      <tr><td>0</td><td>1</td><td>Y = D1</td></tr>
      <tr><td>1</td><td>0</td><td>Y = D2</td></tr>
      <tr><td>1</td><td>1</td><td>Y = D3</td></tr>
    </tbody>
  </table>
  <pre><code>Y = S1&prime;S0&prime;D0 + S1&prime;S0D1 + S1S0&prime;D2 + S1S0D3</code></pre>
  <p>Larger muxes are usually built as a tree of smaller ones -- for example, an 8-to-1 mux from two 4-to-1 muxes feeding a 2-to-1 mux.</p>

  <h3>Multiplexers as universal function generators</h3>
  <p>Feeding a function&prime;s input variables into the select lines of a mux, and hard-wiring each data input to 0 or 1 according to the truth table, lets a mux directly implement <em>any</em> truth table with no minimization needed at all -- a technique used inside programmable logic devices, covered later in this course.</p>

  <h3>Demultiplexer (demux)</h3>
  <p>A demultiplexer is the mirror image of a mux: it routes a single data input to one of several outputs, chosen by the select lines. All non-selected outputs are held at 0.</p>
  <table class="truth-table">
    <caption>1-to-4 demultiplexer</caption>
    <thead><tr><th>S1</th><th>S0</th><th>Y0</th><th>Y1</th><th>Y2</th><th>Y3</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>D</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>0</td><td>D</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>0</td><td>0</td><td>0</td><td>D</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>D</td></tr>
    </tbody>
  </table>

  <h3>Common applications</h3>
  <table class="data-table">
    <caption>Mux/demux applications</caption>
    <thead><tr><th>Application</th><th>How it uses mux/demux</th></tr></thead>
    <tbody>
      <tr><td>Parallel-to-serial conversion</td><td>A mux with select lines driven by a counter samples each parallel bit in turn</td></tr>
      <tr><td>Serial-to-parallel conversion</td><td>A demux with select lines driven by a counter distributes an incoming serial bit to the correct output latch</td></tr>
      <tr><td>ALU operation select</td><td>A mux chooses which arithmetic/logic result becomes the ALU output based on the opcode</td></tr>
      <tr><td>Memory addressing</td><td>A demux (in decoder form) activates exactly one memory row/word line for a given address</td></tr>
    </tbody>
  </table>',
  10
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'decoders-and-encoders',
  'Decoders & Encoders',
  '<h3>Binary decoder</h3>
  <p>A decoder converts an n-bit binary code into one active output out of 2^n -- exactly one output line is asserted for each unique input combination.</p>
  <table class="truth-table">
    <caption>2-to-4 line decoder</caption>
    <thead><tr><th>A1</th><th>A0</th><th>D0</th><th>D1</th><th>D2</th><th>D3</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>1</td></tr>
    </tbody>
  </table>
  <pre><code>D0 = A1&prime;A0&prime;   D1 = A1&prime;A0   D2 = A1A0&prime;   D3 = A1A0</code></pre>
  <p>Each output is simply one minterm of the inputs -- a decoder is really just a bank of AND gates, one per possible input combination. Larger decoders (3-to-8, 4-to-16, and so on) follow the same pattern and often add an enable input that gates all outputs at once, letting several decoders be chained to build a bigger one.</p>

  <h3>Decoders and demultiplexers are the same circuit</h3>
  <p>Add a single data input D that gates every AND term (so D0 = A1&prime;A0&prime;D, and so on), and a decoder becomes a demultiplexer. Commercial "decoder/demultiplexer" chips are usually sold as one part that can be used either way.</p>

  <h3>BCD-to-seven-segment decoder</h3>
  <p>A seven-segment display shows one decimal digit using seven LED segments labeled a-g. A BCD-to-seven-segment decoder converts a 4-bit BCD digit into the pattern of segments needed to display it.</p>
  <table class="data-table">
    <caption>BCD-to-seven-segment decoder (sample rows, 1 = segment on)</caption>
    <thead><tr><th>Digit</th><th>BCD</th><th>a</th><th>b</th><th>c</th><th>d</th><th>e</th><th>f</th><th>g</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0000</td><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>0001</td><td>0</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>2</td><td>0010</td><td>1</td><td>1</td><td>0</td><td>1</td><td>1</td><td>0</td><td>1</td></tr>
      <tr><td>8</td><td>1000</td><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>
  <p>Each segment (a through g) is its own combinational output, derived and minimized from the truth table the same way any other combinational output would be -- typically treating the six unused BCD codes (1010-1111) as don&prime;t cares.</p>

  <h3>Encoder</h3>
  <p>An encoder is the inverse of a decoder: it compresses one active input line, out of 2^n, back down into an n-bit binary code.</p>
  <table class="truth-table">
    <caption>4-to-2 line encoder</caption>
    <thead><tr><th>D0</th><th>D1</th><th>D2</th><th>D3</th><th>A1</th><th>A0</th></tr></thead>
    <tbody>
      <tr><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td><td>1</td></tr>
      <tr><td>0</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>0</td><td>0</td><td>0</td><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>
  <p>A basic encoder like this is only well-defined when exactly one input is active at a time -- if two inputs are 1 simultaneously, the output is ambiguous.</p>

  <h3>Priority encoder</h3>
  <p>A priority encoder resolves that ambiguity by defining, for every input combination, which single active input "wins" -- typically the highest-numbered one -- and ignoring the rest.</p>
  <table class="truth-table">
    <caption>4-input priority encoder (D3 has highest priority; X = do not care)</caption>
    <thead><tr><th>D3</th><th>D2</th><th>D1</th><th>D0</th><th>A1</th><th>A0</th><th>V (valid)</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>0</td><td>X</td><td>X</td><td>0</td></tr>
      <tr><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td>0</td><td>1</td></tr>
      <tr><td>0</td><td>0</td><td>1</td><td>X</td><td>0</td><td>1</td><td>1</td></tr>
      <tr><td>0</td><td>1</td><td>X</td><td>X</td><td>1</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>X</td><td>X</td><td>X</td><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>
  <p>Priority encoders are the core of interrupt controllers (choosing which of several simultaneous interrupt requests to service first) and of keypad scanners.</p>',
  11
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'comparators-and-parity',
  'Comparators & Parity Circuits',
  '<h3>1-bit magnitude comparator</h3>
  <table class="truth-table">
    <caption>1-bit comparator</caption>
    <thead><tr><th>A</th><th>B</th><th>A&gt;B</th><th>A=B</th><th>A&lt;B</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>0</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>0</td><td>1</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>0</td><td>1</td><td>0</td></tr>
    </tbody>
  </table>
  <pre><code>(A&gt;B) = AB&prime;
(A=B) = AB + A&prime;B&prime;  =  (A XNOR B)
(A&lt;B) = A&prime;B</code></pre>

  <h3>Multi-bit magnitude comparator</h3>
  <p>Comparing two n-bit numbers is done from the most significant bit down: the first bit position where A and B differ decides which number is larger, and if every bit position matches, the numbers are equal. Cascadable comparator chips implement this by taking the equality result of the higher-order bits as an enable for comparing the next lower-order bits, letting several comparator chips be chained to compare wider numbers.</p>
  <p>Equality alone is often built more simply as a bitwise XNOR of every corresponding bit pair, ANDed together:</p>
  <pre><code>(A = B) = (A3 XNOR B3) &middot; (A2 XNOR B2) &middot; (A1 XNOR B1) &middot; (A0 XNOR B0)</code></pre>

  <h3>Parity generator</h3>
  <p>Parity adds one extra bit to a group of data bits so that the total number of 1s (including the parity bit) is always even (even parity) or always odd (odd parity). It is the simplest possible error-detecting code.</p>
  <table class="truth-table">
    <caption>Even-parity generator for 3 data bits (sample rows)</caption>
    <thead><tr><th>D2</th><th>D1</th><th>D0</th><th>P (parity bit)</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>0</td><td>1</td><td>1</td></tr>
      <tr><td>0</td><td>1</td><td>1</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>
  <pre><code>P = D2 &oplus; D1 &oplus; D0</code></pre>
  <p>An XOR tree naturally computes even parity (the output is 1 when an odd number of inputs are 1, which is exactly the bit needed to make the total even); inverting it with one more XNOR gives odd parity instead.</p>

  <h3>Parity checker</h3>
  <p>At the receiving end, a parity checker XORs all the received bits, including the parity bit itself. For even parity, the result should always be 0; a 1 means at least one bit was corrupted in transmission or storage.</p>
  <table class="truth-table">
    <caption>Even-parity checker for the transmitted group (D2, D1, D0, P)</caption>
    <thead><tr><th>D2 &oplus; D1 &oplus; D0 &oplus; P</th><th>Meaning</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>No error detected</td></tr>
      <tr><td>1</td><td>Error detected (an odd number of bits flipped)</td></tr>
    </tbody>
  </table>
  <p>Simple parity can only detect an <em>odd</em> number of bit errors -- if exactly two bits flip, the parity still checks out, which is why more robust systems use stronger codes such as checksums, CRCs, or Hamming codes to detect and even correct more error patterns.</p>',
  12
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'flip-flops-sequential-logic',
  'Latches & Flip-Flops',
  '<h3>Combinational vs. sequential logic</h3>
  <p>Combinational logic (like the gates and circuits from the previous lessons) has outputs that depend only on the current inputs. Sequential logic has <strong>memory</strong> -- its outputs depend on current inputs and on past state. Flip-flops and latches are the basic 1-bit memory elements used to build registers, counters, and state machines.</p>

  <h3>SR latch</h3>
  <p>The simplest memory element, built from two cross-coupled NOR gates: each gate&prime;s output feeds back into the other gate&prime;s input. With both S and R held at 0, the feedback loop holds whichever state (Q = 0 or Q = 1) the latch was already in -- that feedback is exactly what gives the circuit memory. S (Set) and R (Reset) control the stored bit Q.</p>
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

  <h3>Gated D latch</h3>
  <p>An SR latch is awkward to control directly because S = R = 1 is forbidden. A gated D latch fixes this by combining a single data input D with an enable input EN: whenever EN is 1, Q follows D; whenever EN is 0, Q holds its last value regardless of D. This removes the invalid state entirely and is the basis for how real flip-flops are built internally.</p>
  <table class="truth-table">
    <caption>Gated D latch</caption>
    <thead><tr><th>EN</th><th>D</th><th>Q (next)</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>X</td><td>Q (hold)</td></tr>
      <tr><td>1</td><td>0</td><td>0</td></tr>
      <tr><td>1</td><td>1</td><td>1</td></tr>
    </tbody>
  </table>

  <h3>Latches vs. flip-flops</h3>
  <p>A latch is <strong>level-triggered</strong>: its output can change any time its enable input is active. A flip-flop is <strong>edge-triggered</strong>: its output only changes at the instant of a clock edge (rising or falling), and is immune to input changes at every other time. Flip-flops are what almost all real synchronous digital systems use, because they let every part of a circuit change state at the same well-defined moment.</p>

  <h3>Master-slave construction</h3>
  <p>A common way to build an edge-triggered flip-flop is to chain two gated latches -- a "master" and a "slave" -- driven by opposite phases of the clock. While the clock is low, the master latch captures the input (the slave is frozen); when the clock goes high, the master freezes and the slave copies the master&prime;s value to the output. Because the master and slave are never both open at the same time, the output changes cleanly on one clock edge and cannot race with an input that is changing at the same time.</p>

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
  <p>A more flexible flip-flop that fixes the SR latch&prime;s invalid state by making both inputs high toggle the output.</p>
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
  </table>

  <h3>Characteristic equations</h3>
  <p>Each flip-flop type has a characteristic equation describing its next state Q(next) as a function of its inputs and its current state Q:</p>
  <table class="data-table">
    <caption>Characteristic equations</caption>
    <thead><tr><th>Flip-flop</th><th>Characteristic equation</th></tr></thead>
    <tbody>
      <tr><td>SR</td><td>Q(next) = S + R&prime;Q, with the restriction S &middot; R = 0</td></tr>
      <tr><td>D</td><td>Q(next) = D</td></tr>
      <tr><td>JK</td><td>Q(next) = JQ&prime; + K&prime;Q</td></tr>
      <tr><td>T</td><td>Q(next) = T &oplus; Q</td></tr>
    </tbody>
  </table>

  <h3>Excitation tables</h3>
  <p>When designing a sequential circuit, the current state Q and the required next state Q(next) are usually known, and the task is to work out what inputs will produce that transition -- the reverse direction from a characteristic table. An excitation table lists exactly that.</p>
  <table class="truth-table">
    <caption>JK flip-flop excitation table</caption>
    <thead><tr><th>Q</th><th>Q(next)</th><th>J</th><th>K</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>X</td></tr>
      <tr><td>0</td><td>1</td><td>1</td><td>X</td></tr>
      <tr><td>1</td><td>0</td><td>X</td><td>1</td></tr>
      <tr><td>1</td><td>1</td><td>X</td><td>0</td></tr>
    </tbody>
  </table>
  <table class="truth-table">
    <caption>D and T flip-flop excitation tables</caption>
    <thead><tr><th>Q</th><th>Q(next)</th><th>D</th><th>T</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
      <tr><td>0</td><td>1</td><td>1</td><td>1</td></tr>
      <tr><td>1</td><td>0</td><td>0</td><td>1</td></tr>
      <tr><td>1</td><td>1</td><td>1</td><td>0</td></tr>
    </tbody>
  </table>
  <p>Excitation tables are the key tool used later in this course to design counters and other state machines from flip-flops.</p>

  <h3>Asynchronous preset and clear</h3>
  <p>Most real flip-flop chips add two extra control inputs, Preset (or Set) and Clear (or Reset), which force Q to 1 or 0 immediately, independent of the clock -- used to force a circuit into a known starting state on power-up.</p>

  <h3>Timing parameters</h3>
  <table class="data-table">
    <caption>Key flip-flop timing parameters</caption>
    <thead><tr><th>Parameter</th><th>Meaning</th></tr></thead>
    <tbody>
      <tr><td>Setup time (t_su)</td><td>How long the input must be stable <em>before</em> the clock edge for it to be reliably captured</td></tr>
      <tr><td>Hold time (t_h)</td><td>How long the input must remain stable <em>after</em> the clock edge</td></tr>
      <tr><td>Propagation delay (t_pd / clock-to-Q)</td><td>How long after the clock edge it takes for Q to reflect the new value</td></tr>
    </tbody>
  </table>
  <p>Violating setup or hold time can cause metastability -- the flip-flop output hovers between 0 and 1 for an unpredictable time before settling -- which is why real designs always leave timing margin, verified by static timing analysis, between when data arrives and when the next clock edge samples it.</p>',
  13
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'registers-and-shift-registers',
  'Registers & Shift Registers',
  '<h3>Registers</h3>
  <p>A register is simply a group of flip-flops (commonly D flip-flops) sharing a common clock, used to store a multi-bit binary word. A basic parallel-load register loads all its bits simultaneously from a parallel data bus on one clock edge and holds that value until the next load.</p>

  <h3>Shift registers</h3>
  <p>A shift register is a chain of flip-flops where each stage&prime;s output feeds the next stage&prime;s input, so that on every clock edge the stored bits all shift one position, and a new bit enters at one end. Shift registers are classified by how data enters and leaves:</p>
  <table class="data-table">
    <caption>Shift register types</caption>
    <thead><tr><th>Type</th><th>Data in</th><th>Data out</th><th>Typical use</th></tr></thead>
    <tbody>
      <tr><td>SISO (Serial-In, Serial-Out)</td><td>Serial</td><td>Serial</td><td>Fixed-length delay line</td></tr>
      <tr><td>SIPO (Serial-In, Parallel-Out)</td><td>Serial</td><td>Parallel (all bits at once)</td><td>Serial-to-parallel conversion (e.g. receiving UART data)</td></tr>
      <tr><td>PISO (Parallel-In, Serial-Out)</td><td>Parallel (loaded at once)</td><td>Serial</td><td>Parallel-to-serial conversion (e.g. transmitting UART data)</td></tr>
      <tr><td>PIPO (Parallel-In, Parallel-Out)</td><td>Parallel</td><td>Parallel</td><td>Behaves as a simple buffer register</td></tr>
    </tbody>
  </table>

  <h3>Universal shift register</h3>
  <p>A universal shift register combines all these modes into one chip, using a mode-select input to choose the operation performed on each clock edge.</p>
  <table class="truth-table">
    <caption>Universal shift register mode control (typical 2-bit mode select)</caption>
    <thead><tr><th>S1</th><th>S0</th><th>Operation</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0</td><td>Hold (no change)</td></tr>
      <tr><td>0</td><td>1</td><td>Shift right, new bit enters from the left</td></tr>
      <tr><td>1</td><td>0</td><td>Shift left, new bit enters from the right</td></tr>
      <tr><td>1</td><td>1</td><td>Parallel load</td></tr>
    </tbody>
  </table>

  <h3>Ring counter</h3>
  <p>A ring counter is a shift register whose serial output is fed straight back into its serial input, so a single 1 (or a short pattern) circulates endlessly. An n-bit ring counter cycles through n unique states.</p>
  <table class="data-table">
    <caption>4-bit ring counter sequence (single 1 circulating)</caption>
    <thead><tr><th>Clock</th><th>Q3 Q2 Q1 Q0</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>1 0 0 0</td></tr>
      <tr><td>1</td><td>0 1 0 0</td></tr>
      <tr><td>2</td><td>0 0 1 0</td></tr>
      <tr><td>3</td><td>0 0 0 1</td></tr>
      <tr><td>4</td><td>1 0 0 0 (repeats)</td></tr>
    </tbody>
  </table>

  <h3>Johnson counter (twisted-ring counter)</h3>
  <p>A Johnson counter is a ring counter with a twist: the <em>complement</em> of the last stage&prime;s output is fed back to the first stage, instead of the value directly. This doubles the number of unique states to 2n for an n-bit register, at the cost of the sequence being slightly less obviously "one bit at a time."</p>
  <table class="data-table">
    <caption>4-bit Johnson counter sequence</caption>
    <thead><tr><th>Clock</th><th>Q3 Q2 Q1 Q0</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0 0 0 0</td></tr>
      <tr><td>1</td><td>1 0 0 0</td></tr>
      <tr><td>2</td><td>1 1 0 0</td></tr>
      <tr><td>3</td><td>1 1 1 0</td></tr>
      <tr><td>4</td><td>1 1 1 1</td></tr>
      <tr><td>5</td><td>0 1 1 1</td></tr>
      <tr><td>6</td><td>0 0 1 1</td></tr>
      <tr><td>7</td><td>0 0 0 1</td></tr>
      <tr><td>8</td><td>0 0 0 0 (repeats)</td></tr>
    </tbody>
  </table>
  <p>Ring and Johnson counters are popular for building simple sequencers (e.g. traffic-light controllers, LED chasers) because decoding "which state am I in" needs no extra logic -- the state <em>is</em> the flip-flop outputs.</p>',
  14
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'counters',
  'Counters',
  '<h3>Asynchronous (ripple) counters</h3>
  <p>A ripple counter chains T flip-flops (or JK flip-flops wired as toggle, with J = K = 1) so that each stage toggles on the clock edge produced by the <em>previous</em> stage&prime;s output, rather than all being driven by the same clock. This is simple to build, but the toggle "ripples" through the stages one at a time, so propagation delay accumulates with every added bit -- limiting how fast a wide ripple counter can run.</p>
  <table class="data-table">
    <caption>3-bit asynchronous up counter sequence (mod-8)</caption>
    <thead><tr><th>Clock pulses</th><th>Q2 Q1 Q0</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0 0 0</td></tr>
      <tr><td>1</td><td>0 0 1</td></tr>
      <tr><td>2</td><td>0 1 0</td></tr>
      <tr><td>3</td><td>0 1 1</td></tr>
      <tr><td>4</td><td>1 0 0</td></tr>
      <tr><td>5</td><td>1 0 1</td></tr>
      <tr><td>6</td><td>1 1 0</td></tr>
      <tr><td>7</td><td>1 1 1</td></tr>
      <tr><td>8</td><td>0 0 0 (repeats)</td></tr>
    </tbody>
  </table>

  <h3>Synchronous counters</h3>
  <p>A synchronous counter clocks every flip-flop from the same clock signal at the same time, and uses combinational logic (typically AND gates) to decide which flip-flops should toggle on the next edge, based on the current state. This removes the ripple delay and lets the whole counter change state in about one flip-flop&prime;s worth of delay, regardless of width.</p>
  <table class="data-table">
    <caption>Synchronous 3-bit up counter toggle logic (T flip-flops)</caption>
    <thead><tr><th>Stage</th><th>Toggles when</th></tr></thead>
    <tbody>
      <tr><td>T0 (LSB)</td><td>Always (T0 = 1)</td></tr>
      <tr><td>T1</td><td>Q0 = 1</td></tr>
      <tr><td>T2</td><td>Q1 &middot; Q0 = 1</td></tr>
    </tbody>
  </table>
  <p>In general, for a synchronous binary up counter, stage n toggles exactly when every less-significant bit is currently 1 -- the same carry pattern as ordinary binary addition of 1.</p>

  <h3>Up/down counters</h3>
  <p>An up/down counter adds a direction control input. For an up count, each T input is the AND of all lower bits (as above); for a down count, each T input is instead the AND of the <em>complements</em> of all lower bits. A mux selects which toggle logic is used, based on the direction input.</p>

  <h3>Designing a mod-N counter</h3>
  <p>A counter that must count through only N states (rather than a full power of two) is designed with the standard sequential design process from the next lesson: write the state table for the N desired states, use flip-flop excitation tables to work out the required J/K (or D, or T) input equations for each transition, minimize those equations, and add a reset path for any unused states so the counter cannot get stuck outside its intended cycle.</p>

  <h3>BCD (decade) counter</h3>
  <p>A decade counter counts 0000 through 1001 (0-9 in BCD) and then resets to 0000 on the next clock, instead of continuing to 1010-1111. It is commonly built either by adding reset-on-1010 detection logic to a 4-bit binary counter, or by designing the toggle equations directly for exactly those 10 states, using the excitation-table method above.</p>',
  15
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'sequential-circuit-design-fsm',
  'Finite State Machines',
  '<h3>Finite state machines</h3>
  <p>A finite state machine (FSM) is the general model behind every sequential circuit: a system that is always in exactly one of a finite number of states, and moves between states based on its current state and current inputs, on each clock edge.</p>

  <h3>Moore vs. Mealy machines</h3>
  <table class="data-table">
    <caption>Moore vs. Mealy machines</caption>
    <thead><tr><th>Aspect</th><th>Moore machine</th><th>Mealy machine</th></tr></thead>
    <tbody>
      <tr><td>Output depends on</td><td>Current state only</td><td>Current state <em>and</em> current input</td></tr>
      <tr><td>Output changes</td><td>Only on a clock edge, synchronized with the state</td><td>Can change as soon as the input changes, between clock edges</td></tr>
      <tr><td>State diagram notation</td><td>Output labeled inside each state circle</td><td>Output labeled on each transition arrow, alongside the input</td></tr>
      <tr><td>States needed</td><td>Often needs more states to separate outputs</td><td>Often needs fewer states</td></tr>
      <tr><td>Timing behavior</td><td>Glitch-free, easier to reason about</td><td>Can react one clock cycle sooner, but outputs can glitch</td></tr>
    </tbody>
  </table>

  <h3>State diagrams and state tables</h3>
  <p>A state diagram is a graph: circles are states, and arrows are transitions labeled with the input value(s) that cause them (and, for a Mealy machine, the output produced). A state table lists the same information as rows -- current state, input, next state, and output -- and is simply the truth table for a sequential circuit.</p>

  <h3>Sequential circuit design steps</h3>
  <ol>
    <li><strong>Draw the state diagram</strong> from the word description of the required behavior.</li>
    <li><strong>Write the state table</strong> from the diagram.</li>
    <li><strong>Assign binary codes to each state</strong> (state encoding) -- m states require at least ceil(log2 m) flip-flops.</li>
    <li><strong>Build the transition table</strong>, substituting the binary state codes into the state table.</li>
    <li><strong>Derive excitation equations</strong> for each flip-flop input, using the flip-flop&prime;s excitation table to work out what input values cause each required state transition.</li>
    <li><strong>Minimize</strong> each excitation equation (algebraically or with a K-map) and derive the output equation(s).</li>
    <li><strong>Draw the final circuit</strong>: flip-flops plus the combinational logic that implements the excitation and output equations.</li>
  </ol>

  <h3>Worked example outline: detecting the sequence "101"</h3>
  <p>To design a circuit whose output goes to 1 for one clock cycle whenever the last three bits received on a serial input were 1, 0, 1 (with overlapping sequences allowed):</p>
  <ul>
    <li>Define states for "no useful bits seen yet," "last bit was 1," and "last two bits were 10," and use the output to flag when a third bit of 1 arrives right after state "10."</li>
    <li>A Moore version needs an extra state whose sole job is to output 1 (since Moore outputs depend only on state), typically 4 states total.</li>
    <li>A Mealy version can produce the same output on the transition itself without a dedicated state, typically needing only 3 states.</li>
    <li>From there, the design steps above -- encode the states, build the transition table, derive the flip-flop equations -- apply exactly as with any other sequential circuit.</li>
  </ul>

  <h3>State minimization</h3>
  <p>Two states are <strong>equivalent</strong> if, for every possible input, they produce the same output and transition to equivalent next states. Removing redundant equivalent states (state minimization) reduces the flip-flop count needed to implement a machine without changing its input/output behavior -- important because unnecessary states cost real silicon area and power.</p>',
  16
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'memory-and-programmable-logic',
  'Memory & Programmable Logic',
  '<h3>Read-only memory (ROM)</h3>
  <p>A ROM stores a fixed table of data as a combinational circuit: internally, it is a full decoder (one AND-gate output, or "word line," per address -- a fixed, unprogrammable array) feeding a programmable OR array that connects each word line to the output bits that should be 1 for that address.</p>
  <table class="data-table">
    <caption>ROM variants</caption>
    <thead><tr><th>Type</th><th>How it is programmed</th><th>Reprogrammable?</th></tr></thead>
    <tbody>
      <tr><td>Mask ROM</td><td>Programmed into the silicon at the factory</td><td>No</td></tr>
      <tr><td>PROM</td><td>Programmed once by the user, by blowing internal fuses</td><td>No</td></tr>
      <tr><td>EPROM</td><td>Programmed electrically, erased with UV light</td><td>Yes (with a UV eraser)</td></tr>
      <tr><td>EEPROM</td><td>Programmed and erased electrically, byte by byte</td><td>Yes</td></tr>
      <tr><td>Flash memory</td><td>Programmed and erased electrically, in blocks</td><td>Yes</td></tr>
    </tbody>
  </table>

  <h3>Random-access memory (RAM)</h3>
  <table class="data-table">
    <caption>SRAM vs. DRAM</caption>
    <thead><tr><th>Aspect</th><th>SRAM (static RAM)</th><th>DRAM (dynamic RAM)</th></tr></thead>
    <tbody>
      <tr><td>Storage element</td><td>A latch (typically six transistors)</td><td>A single capacitor plus one transistor</td></tr>
      <tr><td>Needs refreshing?</td><td>No -- holds data as long as powered</td><td>Yes -- the capacitor leaks charge and must be periodically rewritten</td></tr>
      <tr><td>Speed</td><td>Faster</td><td>Slower</td></tr>
      <tr><td>Density / cost per bit</td><td>Lower density, more expensive</td><td>Higher density, cheaper</td></tr>
      <tr><td>Typical use</td><td>CPU caches</td><td>Main system memory</td></tr>
    </tbody>
  </table>
  <p>Both SRAM and DRAM are volatile: unlike ROM, they lose their contents when power is removed.</p>

  <h3>Programmable logic: PLA and PAL</h3>
  <p>A PLA (Programmable Logic Array) and a PAL (Programmable Array Logic) both implement arbitrary sum-of-products expressions directly in hardware, without needing to hand-design gate networks, but they differ in how flexible they are:</p>
  <table class="data-table">
    <caption>ROM vs. PLA vs. PAL</caption>
    <thead><tr><th>Device</th><th>AND array</th><th>OR array</th></tr></thead>
    <tbody>
      <tr><td>ROM</td><td>Fixed (every possible minterm)</td><td>Programmable</td></tr>
      <tr><td>PLA</td><td>Programmable</td><td>Programmable</td></tr>
      <tr><td>PAL</td><td>Programmable</td><td>Fixed</td></tr>
    </tbody>
  </table>
  <p>A PLA is the most flexible (any product terms, summed in any combination) but also the most expensive to fabricate; a PAL is cheaper and faster because only the AND array needs to be programmable, at the cost of some of that flexibility.</p>

  <h3>From PALs to FPGAs</h3>
  <p>Modern designs mostly use FPGAs (Field-Programmable Gate Arrays) instead of PLAs and PALs. An FPGA is built from thousands of small look-up tables (LUTs, each able to implement any small truth table) plus flip-flops and a programmable interconnect fabric, all configured after fabrication -- typically by compiling a Verilog or VHDL design (see the Verilog and VHDL courses) down to a bitstream that programs the LUTs and interconnect.</p>',
  17
),
(
  (SELECT id FROM courses WHERE slug = 'digital-logic-design'),
  'timing-and-hazards',
  'Timing & Hazards',
  '<h3>Propagation delay</h3>
  <p>No real gate switches instantly -- there is always some propagation delay (t_pd) between an input changing and the output settling to its new correct value. In a multi-level circuit, delays add up along the longest input-to-output path, called the <strong>critical path</strong>, which sets the maximum speed the circuit can be clocked at.</p>
  <pre><code>Max clock frequency &asymp; 1 / (t_pd(critical path) + t_setup)</code></pre>

  <h3>Setup and hold time revisited</h3>
  <p>As covered in the latches and flip-flops lesson, every flip-flop needs its input to be stable for a setup time before the clock edge and a hold time after it. If the combinational logic feeding a flip-flop is too slow (a "setup violation") or switches too fast relative to a shared clock (a "hold violation"), the flip-flop can sample the wrong value or become metastable. Static timing analysis tools check every path in a design against these constraints before it is trusted to work in real hardware.</p>

  <h3>Static hazards (glitches)</h3>
  <p>A static hazard is a momentary, unwanted glitch on an output that should stay logically constant while a single input changes -- caused by two different paths through the circuit switching at slightly different times because of gate delays.</p>
  <pre><code>F = AB + A&prime;C</code></pre>
  <p>Hold B = 1 and C = 1, and let A transition from 1 to 0. Algebraically, F = 1 both before (F = AB = 1) and after (F = A&prime;C = 1) the transition -- the output should never change. But the AB term switches off only after A falls and propagates through its AND gate, while the A&prime;C term switches on only after A is inverted <em>and</em> propagates through its own AND gate. For a brief moment, both terms can be 0 at once, and F glitches to 0 even though it should have stayed at 1 the whole time. This is exactly the consensus-term situation from the laws of Boolean algebra: BC is the consensus of AB and A&prime;C, and although the consensus theorem says BC is algebraically redundant (AB + A&prime;C + BC = AB + A&prime;C), adding it back as an extra, "redundant" gate removes the hazard, because BC stays 1 throughout the transition and holds F at 1 while the other two terms switch:</p>
  <pre><code>F = AB + A&prime;C + BC   (hazard-free)</code></pre>

  <h3>Dynamic hazards and races</h3>
  <p>A dynamic hazard occurs when an output that is supposed to change once (0-to-1 or 1-to-0) instead glitches back and forth several times before settling -- typically caused by more than two paths with different delays feeding the same output. A <strong>race condition</strong> is the more general problem in asynchronous circuits (with no common clock) where the final settled state actually depends on which of two changing signals happens to arrive first, rather than being uniquely determined by the logic -- one major reason most digital systems are designed to be synchronous, using a single global clock and edge-triggered flip-flops to sidestep this entire class of problem.</p>',
  18
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
  '<p><span class="tag">Beginner</span></p>
  <h3>Modules</h3>
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
  '<p><span class="tag">Beginner</span></p>
  <h3>Continuous assignment</h3>
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
  '<p><span class="tag">Beginner</span></p>
  <h3>Describing a clocked flip-flop</h3>
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
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-half-full-adders',
  'Half & Full Adders in Verilog',
  '<p><span class="tag">Beginner</span></p>
  <h3>Half adder: dataflow style</h3>
  <p>The half adder from the Digital Logic Design course (Sum = A XOR B, Cout = A AND B) translates directly into one <code>assign</code> statement per output.</p>
  <pre><code>module half_adder (
    input  a,
    input  b,
    output sum,
    output cout
);
    assign sum  = a ^ b;
    assign cout = a &amp; b;
endmodule</code></pre>

  <h3>Full adder: dataflow style</h3>
  <p>The full adder equations (Sum = A &oplus; B &oplus; Cin, Cout = AB + ACin + BCin) map just as directly:</p>
  <pre><code>module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a &amp; b) | (a &amp; cin) | (b &amp; cin);
endmodule</code></pre>

  <h3>Full adder: structural style, built from two half adders</h3>
  <p>Verilog also lets a module be built purely by wiring up instances of other modules -- exactly like the DLD lesson describes constructing a full adder from two half adders.</p>
  <pre><code>module full_adder_structural (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire s1, c1, c2;

    half_adder ha1 (.a(a),  .b(b),   .sum(s1),  .cout(c1));
    half_adder ha2 (.a(s1), .b(cin), .sum(sum), .cout(c2));

    assign cout = c1 | c2;
endmodule</code></pre>
  <p>The <code>.port_name(signal)</code> syntax is called named port connection -- it wires a signal to a specific port of the instantiated module regardless of the order the ports were declared in, which makes the connections self-documenting and less error-prone than positional connection.</p>',
  4
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-decoders-encoders',
  'Decoders & Encoders in Verilog',
  '<p><span class="tag">Beginner</span></p>
  <h3>2-to-4 decoder</h3>
  <p>A decoder is naturally described with one <code>assign</code> per output line, each one a single minterm, exactly matching the DLD truth table.</p>
  <pre><code>module decoder_2to4 (
    input  [1:0] a,
    output       d0,
    output       d1,
    output       d2,
    output       d3
);
    assign d0 = (~a[1]) &amp; (~a[0]);
    assign d1 = (~a[1]) &amp;   a[0];
    assign d2 =   a[1]  &amp; (~a[0]);
    assign d3 =   a[1]  &amp;   a[0];
endmodule</code></pre>

  <h3>A cleaner decoder using a bus and a case statement</h3>
  <p>Rather than one equation per output, real designs usually pack the outputs into a single bus and let a <code>case</code> statement inside an <code>always</code> block pick the pattern -- easier to read and easier to extend to more outputs.</p>
  <pre><code>module decoder_2to4_case (
    input  [1:0]      a,
    output reg [3:0]  d
);
    always @(*) begin
        case (a)
            2''b00: d = 4''b0001;
            2''b01: d = 4''b0010;
            2''b10: d = 4''b0100;
            2''b11: d = 4''b1000;
        endcase
    end
endmodule</code></pre>
  <p><code>always @(*)</code> means "re-evaluate this block whenever any signal it reads changes" -- the standard way to describe combinational logic with a <code>case</code> or <code>if</code> statement instead of a plain <code>assign</code>.</p>

  <h3>4-to-2 encoder</h3>
  <pre><code>module encoder_4to2 (
    input  [3:0]      d,
    output reg [1:0]  a
);
    always @(*) begin
        case (d)
            4''b0001: a = 2''b00;
            4''b0010: a = 2''b01;
            4''b0100: a = 2''b10;
            4''b1000: a = 2''b11;
            default:  a = 2''b00;
        endcase
    end
endmodule</code></pre>
  <p>The <code>default</code> case matters here: without it, an unexpected input pattern (e.g. two bits set at once) would leave <code>a</code> unassigned in simulation, which can create an accidental latch instead of the combinational logic that was intended.</p>',
  5
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-comparators-parity',
  'Comparators & Parity Circuits in Verilog',
  '<p><span class="tag">Beginner</span></p>
  <h3>Multi-bit comparators</h3>
  <p>Verilog&prime;s built-in comparison operators (<code>==</code>, <code>&gt;</code>, <code>&lt;</code>) do exactly what the DLD comparator lesson built from gates, but in one line, for any bus width.</p>
  <pre><code>module comparator #(parameter WIDTH = 4) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output gt,
    output eq,
    output lt
);
    assign gt = (a &gt;  b);
    assign eq = (a == b);
    assign lt = (a &lt;  b);
endmodule</code></pre>
  <p>The <code>#(parameter WIDTH = 4)</code> syntax makes this comparator reusable at any width -- instantiate it with <code>comparator #(.WIDTH(8)) cmp8 (...)</code> for an 8-bit version, with no changes to the module body.</p>

  <h3>Parity generator and checker</h3>
  <p>The reduction XOR operator (a single <code>^</code> applied to a whole bus) XORs every bit of the bus together, which is exactly the XOR tree the DLD parity lesson describes.</p>
  <pre><code>module parity_gen #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] data,
    output             even_parity_bit
);
    assign even_parity_bit = ^data;   // XOR of every bit in data
endmodule

module parity_check #(parameter WIDTH = 9) (
    input  [WIDTH-1:0] received,      // data bits + parity bit together
    output             error
);
    assign error = ^received;         // 0 = no error, 1 = error detected
endmodule</code></pre>',
  6
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-multiplexers-demultiplexers',
  'Multiplexers & Demultiplexers in Verilog',
  '<p><span class="tag">Intermediate</span></p>
  <h3>2-to-1 and 4-to-1 multiplexers</h3>
  <p>A small mux is often clearest as a ternary expression; the DLD 4-to-1 mux truth table maps directly onto a <code>case</code> statement once there are more than two choices.</p>
  <pre><code>module mux2to1 (
    input  sel,
    input  a,
    input  b,
    output y
);
    assign y = sel ? b : a;
endmodule

module mux4to1 (
    input  [1:0]  sel,
    input  [3:0]  d,
    output reg    y
);
    always @(*) begin
        case (sel)
            2''b00: y = d[0];
            2''b01: y = d[1];
            2''b10: y = d[2];
            2''b11: y = d[3];
        endcase
    end
endmodule</code></pre>

  <h3>Parameterized N-to-1 multiplexer</h3>
  <p>A common plain-Verilog pattern packs all the data inputs into one wide bus and uses the select value to slice out the right piece:</p>
  <pre><code>module mux_n #(parameter WIDTH = 4, parameter N = 8) (
    input  [$clog2(N)-1:0] sel,
    input  [N*WIDTH-1:0]   data_in,   // N inputs of WIDTH bits, concatenated
    output [WIDTH-1:0]     y
);
    assign y = data_in[sel*WIDTH +: WIDTH];
endmodule</code></pre>
  <p><code>+:</code> is an indexed part-select: <code>data_in[sel*WIDTH +: WIDTH]</code> means "WIDTH bits, starting at bit position <code>sel*WIDTH</code>" -- a variable-position slice that an ordinary <code>[hi:lo]</code> range cannot express, since <code>sel</code> is not a constant.</p>

  <h3>1-to-4 demultiplexer</h3>
  <pre><code>module demux1to4 (
    input  [1:0]      sel,
    input             d,
    output reg [3:0]  y
);
    always @(*) begin
        y = 4''b0000;
        y[sel] = d;
    end
endmodule</code></pre>
  <p>Initializing <code>y</code> to all zeros before the conditional assignment is a common Verilog idiom: it guarantees every output bit has a defined value in every branch, which avoids accidentally inferring a latch for the bits that are not selected.</p>',
  7
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-ripple-carry-adder-alu',
  'Ripple-Carry Adders & a Simple ALU',
  '<p><span class="tag">Intermediate</span></p>
  <h3>Ripple-carry adder from a generate loop</h3>
  <p>Instantiating N full adders by hand for a wide adder is tedious and error-prone. A <code>generate for</code> loop with a <code>genvar</code> lets Verilog create the instances for you at compile time.</p>
  <pre><code>module ripple_adder #(parameter WIDTH = 4) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout
);
    wire [WIDTH:0] carry;
    assign carry[0] = cin;
    assign cout = carry[WIDTH];

    genvar i;
    generate
        for (i = 0; i &lt; WIDTH; i = i + 1) begin : fa_stage
            full_adder fa (
                .a    (a[i]),
                .b    (b[i]),
                .cin  (carry[i]),
                .sum  (sum[i]),
                .cout (carry[i+1])
            );
        end
    endgenerate
endmodule</code></pre>
  <p>This is structurally identical to the ripple-carry adder from the Digital Logic Design course: each stage&prime;s carry-out wire feeds the next stage&prime;s carry-in, and the delay still ripples from the least significant bit to the most significant bit.</p>

  <h3>A simple mode-controlled adder/subtractor</h3>
  <p>Following the same adder/subtractor trick from the DLD course -- XOR every B bit with a mode line M, and feed M into the carry-in -- turns the same adder into a subtractor:</p>
  <pre><code>module addsub #(parameter WIDTH = 4) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              mode,     // 0 = add, 1 = subtract (a - b)
    output [WIDTH-1:0] result,
    output             cout
);
    wire [WIDTH-1:0] b_xored = b ^ {WIDTH{mode}};

    ripple_adder #(.WIDTH(WIDTH)) core (
        .a    (a),
        .b    (b_xored),
        .cin  (mode),
        .sum  (result),
        .cout (cout)
    );
endmodule</code></pre>
  <p><code>{WIDTH{mode}}</code> is a replication operator: it repeats the single bit <code>mode</code> WIDTH times, producing a bus of all 0s (mode = 0, B passes through unchanged) or all 1s (mode = 1, B is bitwise complemented before adding, matching two&prime;s complement negation).</p>',
  8
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-latches-flip-flop-types',
  'Latches & Flip-Flop Types in Verilog',
  '<p><span class="tag">Intermediate</span></p>
  <h3>Why you rarely write a latch on purpose</h3>
  <p>An SR or D latch can be described behaviorally, but most synthesis tools flag inferred latches as a likely bug, since an incompletely specified combinational <code>always</code> block infers one by accident. Real designs almost always use the clocked, edge-triggered styles below instead.</p>
  <pre><code>// A gated D latch -- shown for completeness, rarely used directly
module d_latch (
    input  en,
    input  d,
    output reg q
);
    always @(en or d)
        if (en)
            q = d;
        // no else: when en = 0, q intentionally holds its value
        // (this is what makes it a latch, and what a linter will flag)
endmodule</code></pre>

  <h3>JK flip-flop</h3>
  <p>The DLD course gives the JK characteristic equation Q(next) = JQ&prime; + K&prime;Q. Implemented directly:</p>
  <pre><code>module jk_flip_flop (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q &lt;= 1''b0;
        else
            case ({j, k})
                2''b00: q &lt;= q;       // hold
                2''b01: q &lt;= 1''b0;   // reset
                2''b10: q &lt;= 1''b1;   // set
                2''b11: q &lt;= ~q;      // toggle
            endcase
    end
endmodule</code></pre>

  <h3>T flip-flop</h3>
  <pre><code>module t_flip_flop (
    input  clk,
    input  reset,
    input  t,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q &lt;= 1''b0;
        else if (t)
            q &lt;= ~q;
    end
endmodule</code></pre>
  <p>Both flip-flops use the same skeleton as the D flip-flop from the beginner lessons: a clocked <code>always</code> block with non-blocking assignment. Only the equation deciding the next value of <code>q</code> changes -- exactly matching the characteristic-equation table from the Digital Logic Design course.</p>',
  9
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-registers-shift-registers',
  'Registers & Shift Registers in Verilog',
  '<p><span class="tag">Intermediate</span></p>
  <h3>A parallel-load register</h3>
  <pre><code>module register #(parameter WIDTH = 8) (
    input                   clk,
    input                   load,
    input      [WIDTH-1:0]  d,
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk)
        if (load)
            q &lt;= d;
endmodule</code></pre>

  <h3>SIPO shift register (serial-in, parallel-out)</h3>
  <pre><code>module sipo #(parameter WIDTH = 8) (
    input                   clk,
    input                   serial_in,
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk)
        q &lt;= {q[WIDTH-2:0], serial_in};
endmodule</code></pre>
  <p>Each clock edge shifts every bit one position left and drops the new serial bit into the bottom -- the concatenation <code>{q[WIDTH-2:0], serial_in}</code> builds exactly that new value in one expression.</p>

  <h3>Universal shift register</h3>
  <p>Combining hold, shift-left, shift-right, and parallel load into one module, selected by a 2-bit mode input, matches the universal shift register from the DLD course:</p>
  <pre><code>module universal_shift_reg #(parameter WIDTH = 8) (
    input                   clk,
    input      [1:0]        mode,   // 00=hold, 01=shift right, 10=shift left, 11=load
    input                   sin_r,  // serial in for shift-right
    input                   sin_l,  // serial in for shift-left
    input      [WIDTH-1:0]  d,      // parallel load data
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk) begin
        case (mode)
            2''b00: q &lt;= q;
            2''b01: q &lt;= {sin_r, q[WIDTH-1:1]};
            2''b10: q &lt;= {q[WIDTH-2:0], sin_l};
            2''b11: q &lt;= d;
        endcase
    end
endmodule</code></pre>',
  10
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-counters',
  'Counters in Verilog',
  '<p><span class="tag">Intermediate</span></p>
  <h3>Free-running binary up counter</h3>
  <pre><code>module up_counter #(parameter WIDTH = 4) (
    input                   clk,
    input                   reset,
    output reg [WIDTH-1:0]  count
);
    always @(posedge clk or posedge reset)
        if (reset)
            count &lt;= 0;
        else
            count &lt;= count + 1&apos;b1;
endmodule</code></pre>
  <p>This single line, <code>count &lt;= count + 1</code>, is what a synchronous counter&prime;s per-bit toggle logic (from the DLD counters lesson) compiles down to -- the synthesis tool works out the individual AND-gate toggle equations for you.</p>

  <h3>Up/down counter</h3>
  <pre><code>module updown_counter #(parameter WIDTH = 4) (
    input                   clk,
    input                   reset,
    input                   up_down,   // 1 = count up, 0 = count down
    output reg [WIDTH-1:0]  count
);
    always @(posedge clk or posedge reset)
        if (reset)
            count &lt;= 0;
        else if (up_down)
            count &lt;= count + 1&apos;b1;
        else
            count &lt;= count - 1&apos;b1;
endmodule</code></pre>

  <h3>Mod-N (e.g. BCD/decade) counter</h3>
  <pre><code>module mod_n_counter #(parameter WIDTH = 4, parameter N = 10) (
    input                   clk,
    input                   reset,
    output reg [WIDTH-1:0]  count
);
    always @(posedge clk or posedge reset)
        if (reset)
            count &lt;= 0;
        else if (count == N - 1)
            count &lt;= 0;
        else
            count &lt;= count + 1&apos;b1;
endmodule</code></pre>
  <p>Setting <code>N = 10</code> gives exactly the BCD decade counter from the Digital Logic Design course: it counts 0 through 9 and then wraps back to 0, instead of continuing into the unused 1010-1111 codes.</p>',
  11
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-carry-lookahead-generate',
  'Carry-Lookahead Adders & Generate Blocks',
  '<p><span class="tag">Advanced</span></p>
  <h3>Computing carries in parallel</h3>
  <p>The DLD course defines, for each bit position i: Pi = Ai &oplus; Bi (propagate) and Gi = Ai &middot; Bi (generate), with C(i+1) = Gi + Pi &middot; Ci. Verilog can compute every carry from these equations directly, without waiting for a chain of full adders:</p>
  <pre><code>module cla_adder #(parameter WIDTH = 4) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout
);
    wire [WIDTH-1:0] p = a ^ b;         // propagate
    wire [WIDTH-1:0] g = a &amp; b;         // generate
    wire [WIDTH:0]   c;

    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i &lt; WIDTH; i = i + 1) begin : carry_stage
            assign c[i+1] = g[i] | (p[i] &amp; c[i]);
        end
    endgenerate

    assign sum  = p ^ c[WIDTH-1:0];
    assign cout = c[WIDTH];
endmodule</code></pre>
  <p>Because every <code>c[i+1]</code> is an independent <code>assign</code> statement rather than a signal threaded through instantiated full-adder modules, a synthesis tool is free to expand and optimize the whole carry chain into a shallow tree of gates -- which is exactly the "compute carries ahead of time" idea the name describes.</p>

  <h3>generate blocks beyond adders</h3>
  <p>The same <code>generate</code>/<code>genvar</code> pattern used here and in the ripple-carry adder lesson scales to building any regular, repeated structure parametrically -- an N-bit ring counter, an array of registers, or a tree of comparators -- without writing out each stage by hand.</p>',
  12
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-fsm-design',
  'Finite State Machines in Verilog',
  '<p><span class="tag">Advanced</span></p>
  <h3>Encoding states</h3>
  <p>Following the DLD design steps, an FSM in Verilog starts by naming and encoding its states, usually with <code>localparam</code> constants instead of hard-coded numbers scattered through the code:</p>
  <pre><code>localparam S_IDLE  = 2&apos;b00;
localparam S_GOT1  = 2&apos;b01;
localparam S_GOT10 = 2&apos;b10;
localparam S_MATCH = 2&apos;b11;</code></pre>

  <h3>Moore sequence detector for "101"</h3>
  <p>This is the Moore version outlined in the DLD FSM lesson: it needs a dedicated state (<code>S_MATCH</code>) whose output is 1, since a Moore machine&prime;s output can only depend on the current state.</p>
  <pre><code>module seq_detector_101_moore (
    input  clk,
    input  reset,
    input  bit_in,
    output y
);
    localparam S_IDLE  = 2&apos;b00;
    localparam S_GOT1  = 2&apos;b01;
    localparam S_GOT10 = 2&apos;b10;
    localparam S_MATCH = 2&apos;b11;

    reg [1:0] state, next_state;

    // next-state logic (combinational)
    always @(*) begin
        case (state)
            S_IDLE:  next_state = bit_in ? S_GOT1  : S_IDLE;
            S_GOT1:  next_state = bit_in ? S_GOT1  : S_GOT10;
            S_GOT10: next_state = bit_in ? S_MATCH : S_IDLE;
            S_MATCH: next_state = bit_in ? S_GOT1  : S_GOT10;
            default: next_state = S_IDLE;
        endcase
    end

    // state register (sequential)
    always @(posedge clk or posedge reset)
        if (reset)
            state &lt;= S_IDLE;
        else
            state &lt;= next_state;

    // Moore output: depends only on state
    assign y = (state == S_MATCH);
endmodule</code></pre>
  <p>This three-block structure -- combinational next-state logic, a clocked state register, and a combinational output equation -- is the standard template for describing any FSM in Verilog, and it maps directly onto the DLD design steps: the <code>case</code> statement in the first block <em>is</em> the state table, and keeping it in its own <code>always @(*)</code> block, separate from the clocked block, keeps the combinational and sequential parts of the design cleanly separated.</p>

  <h3>Mealy version</h3>
  <p>A Mealy machine produces its output on the transition, which in Verilog means the output equation reads the current state <em>and</em> the current input, instead of state alone:</p>
  <pre><code>assign y = (state == S_GOT10) &amp;&amp; bit_in;</code></pre>
  <p>With this change, S_MATCH is no longer needed as a separate state at all -- exactly the "typically needing only 3 states" difference the DLD FSM lesson describes between the Moore and Mealy versions of the same detector.</p>',
  13
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-memory-modeling',
  'Modeling Memory in Verilog',
  '<p><span class="tag">Advanced</span></p>
  <h3>Modeling a ROM</h3>
  <p>The DLD memory lesson describes a ROM as a fixed decoder feeding a programmable OR array. In Verilog, the simplest behavioral model of that same idea is just an array of registers, initialized once, and read combinationally by address:</p>
  <pre><code>module rom_16x8 (
    input  [3:0] addr,
    output [7:0] data
);
    reg [7:0] mem [0:15];

    initial begin
        mem[0] = 8&apos;h00;
        mem[1] = 8&apos;h01;
        mem[2] = 8&apos;h04;
        // ... remaining entries would be filled in the same way,
        // or loaded from a file with $readmemh in simulation
    end

    assign data = mem[addr];
endmodule</code></pre>

  <h3>Modeling a RAM</h3>
  <p>A RAM adds a write port: on a write-enabled clock edge the addressed word is updated, exactly like the SRAM described in the DLD lesson (a latch per storage cell, holding its value until explicitly rewritten).</p>
  <pre><code>module ram_16x8 (
    input        clk,
    input        write_enable,
    input  [3:0] addr,
    input  [7:0] data_in,
    output [7:0] data_out
);
    reg [7:0] mem [0:15];

    always @(posedge clk)
        if (write_enable)
            mem[addr] &lt;= data_in;

    assign data_out = mem[addr];   // combinational read
endmodule</code></pre>
  <p>This combinational-read, synchronous-write style is the most common simple RAM model. Real on-chip RAM blocks are usually synchronous on both read and write (registering <code>data_out</code> as well) to match how physical memory macros actually behave, and to keep timing predictable.</p>',
  14
),
(
  (SELECT id FROM courses WHERE slug = 'verilog'),
  'verilog-testbenches-verification',
  'Testbenches & Verification',
  '<p><span class="tag">Advanced</span></p>
  <h3>Why testbenches</h3>
  <p>Every circuit in this course, from a half adder to an FSM, needs to be checked against its truth table or state diagram before anyone trusts it in real hardware. A testbench is a separate Verilog module, never synthesized, that instantiates the design and drives it with test inputs in simulation.</p>

  <h3>A simple testbench for the full adder</h3>
  <pre><code>module full_adder_tb;
    reg  a, b, cin;
    wire sum, cout;

    full_adder dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        $monitor("t=%0t a=%b b=%b cin=%b -&gt; sum=%b cout=%b", $time, a, b, cin, sum, cout);

        a = 0; b = 0; cin = 0; #10;
        a = 0; b = 1; cin = 0; #10;
        a = 1; b = 1; cin = 0; #10;
        a = 1; b = 1; cin = 1; #10;

        $finish;
    end
endmodule</code></pre>
  <p><code>dut</code> ("device under test") is just a conventional instance name. <code>$monitor</code> prints a new line automatically whenever any of its listed signals changes, so the whole simulation timeline shows up without needing a <code>$display</code> after every input change. <code>#10</code> advances simulation time by 10 time units, letting the combinational logic settle before the next input change.</p>

  <h3>Clock generation and a self-checking testbench</h3>
  <p>Sequential designs additionally need a clock generator, and a well-written testbench compares the design&prime;s output against an expected value automatically instead of requiring a human to read through a log. Rather than hard-coding the exact cycle reset releases on, this testbench captures whatever count value appears right after reset is lifted as its baseline, then checks that every following edge increments from there by exactly one -- a pattern that does not depend on precisely hand-tracking simulation timing:</p>
  <pre><code>module up_counter_tb;
    reg clk = 0;
    reg reset = 1;
    wire [3:0] count;

    up_counter #(.WIDTH(4)) dut (.clk(clk), .reset(reset), .count(count));

    always #5 clk = ~clk;   // 10-time-unit clock period

    reg [3:0] expected;
    integer i;

    initial begin
        #12 reset = 0;
        @(posedge clk);
        expected = count;   // capture the count right after reset releases

        for (i = 0; i &lt; 20; i = i + 1) begin
            @(posedge clk);
            expected = expected + 1&apos;b1;
            if (count !== expected)
                $display("MISMATCH at i=%0d: expected %0d, got %0d", i, expected, count);
        end

        $display("Test complete.");
        $finish;
    end
endmodule</code></pre>
  <p>Writing testbenches like this for every module in this course -- checking each one against the exact truth table, characteristic equation, or state diagram it was designed from in the Digital Logic Design course -- is one of the most valuable habits for catching bugs before a design ever reaches real hardware.</p>',
  15
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
  'arduino-cpp-basics',
  'Arduino C++ Basics',
  '<h3>Arduino programs are C++</h3>
  <p>An Arduino "sketch" is a C++ program with two required functions (<code>setup()</code> and <code>loop()</code>) and access to a large set of built-in functions for talking to pins, timers, and peripherals. Everything else about the C++ language -- variables, types, operators, control flow -- works exactly the same as it does off a microcontroller.</p>

  <h3>Variables and data types</h3>
  <p>A variable must be declared with a type before it is used. Common types on Arduino, and how many bytes of memory each one uses on a typical 8-bit board (like the Uno):</p>
  <table class="data-table">
    <caption>Common Arduino data types (on AVR-based boards such as the Uno)</caption>
    <thead><tr><th>Type</th><th>Size</th><th>Range</th><th>Typical use</th></tr></thead>
    <tbody>
      <tr><td>bool</td><td>1 byte</td><td>true / false</td><td>Flags, on/off states</td></tr>
      <tr><td>byte</td><td>1 byte</td><td>0 to 255</td><td>Raw pin values, small counters</td></tr>
      <tr><td>int</td><td>2 bytes</td><td>-32,768 to 32,767</td><td>General-purpose whole numbers</td></tr>
      <tr><td>unsigned int</td><td>2 bytes</td><td>0 to 65,535</td><td>Counters that never go negative</td></tr>
      <tr><td>long</td><td>4 bytes</td><td>&asymp; &plusmn;2.1 billion</td><td>Larger counters, e.g. milliseconds since startup</td></tr>
      <tr><td>float</td><td>4 bytes</td><td>&asymp; &plusmn;3.4&times;10^38 (about 6-7 significant digits)</td><td>Sensor readings, calculations needing decimals</td></tr>
      <tr><td>char</td><td>1 byte</td><td>-128 to 127, or one character</td><td>Single characters, small numbers</td></tr>
    </tbody>
  </table>
  <p>On 32-bit boards (many newer Arduino-compatible boards), <code>int</code> is often 4 bytes instead of 2 -- always check the specific board&prime;s documentation rather than assuming.</p>

  <h3>Constants</h3>
  <pre><code>const int LED_PIN = 13;        // will not change; the compiler enforces this
#define BUZZER_PIN 8            // a preprocessor text substitution, an older style</code></pre>
  <p><code>const</code> is generally preferred over <code>#define</code> in modern code, since it is type-checked and scoped like a normal variable rather than being a blind text substitution performed before compilation even starts.</p>

  <h3>Operators</h3>
  <table class="data-table">
    <caption>Common operators</caption>
    <thead><tr><th>Category</th><th>Operators</th></tr></thead>
    <tbody>
      <tr><td>Arithmetic</td><td>+  -  *  /  % (modulo/remainder)</td></tr>
      <tr><td>Comparison</td><td>==  !=  &lt;  &gt;  &lt;=  &gt;=</td></tr>
      <tr><td>Logical</td><td>&amp;&amp; (and)  || (or)  ! (not)</td></tr>
      <tr><td>Bitwise</td><td>&amp; (and)  | (or)  ^ (xor)  ~ (not)  &lt;&lt; (shift left)  &gt;&gt; (shift right)</td></tr>
      <tr><td>Compound assignment</td><td>+=  -=  *=  /=  ++  --</td></tr>
    </tbody>
  </table>
  <p>Bitwise operators come up constantly in embedded code -- for example, reading or setting one bit of a hardware register without disturbing the others.</p>',
  2
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'control-structures-in-arduino',
  'Control Structures',
  '<h3>Conditional branching</h3>
  <pre><code>if (temperature &gt; 30) {
    digitalWrite(FAN_PIN, HIGH);
} else if (temperature &gt; 20) {
    digitalWrite(FAN_PIN, LOW);
} else {
    digitalWrite(HEATER_PIN, HIGH);
}</code></pre>

  <h3>switch statements</h3>
  <p>A <code>switch</code> is often clearer than a long chain of <code>if/else if</code> when comparing one variable against several fixed values.</p>
  <pre><code>switch (mode) {
    case 0:
        // idle
        break;
    case 1:
        // running
        break;
    default:
        // unknown mode
        break;
}</code></pre>
  <p>Forgetting <code>break</code> is a classic bug: without it, execution "falls through" into the next case instead of exiting the switch.</p>

  <h3>for loops</h3>
  <pre><code>for (int i = 0; i &lt; 10; i++) {
    digitalWrite(LED_PIN, HIGH);
    delay(100);
    digitalWrite(LED_PIN, LOW);
    delay(100);
}</code></pre>
  <p>This blinks an LED 10 times, spending 2 seconds total inside the loop before continuing to whatever comes next -- an important detail, since <code>delay()</code> blocks the whole program while it runs (the Timers & Non-Blocking Timing lesson later in this course covers how to avoid that).</p>

  <h3>while and do-while loops</h3>
  <pre><code>while (digitalRead(BUTTON_PIN) == HIGH) {
    // wait here until the button is pressed
}</code></pre>
  <p>A <code>while</code> loop like this is a simple (if blocking) way to wait for an event. <code>do { ... } while (condition);</code> works the same way but always runs its body at least once, checking the condition only after the first pass.</p>

  <h3>break and continue</h3>
  <p><code>break</code> exits a loop (or switch) immediately; <code>continue</code> skips the rest of the current loop iteration and jumps straight to the next one.</p>',
  3
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'functions-and-scope',
  'Functions & Scope',
  '<h3>Defining a function</h3>
  <pre><code>int addTwoNumbers(int a, int b) {
    return a + b;
}

void blinkLed(int pin, int times) {
    for (int i = 0; i &lt; times; i++) {
        digitalWrite(pin, HIGH);
        delay(200);
        digitalWrite(pin, LOW);
        delay(200);
    }
}</code></pre>
  <p>A function&prime;s return type comes first (<code>void</code> if it returns nothing), followed by its name and a parenthesized parameter list. <code>setup()</code> and <code>loop()</code> are simply two functions that the Arduino core calls automatically -- <code>setup()</code> once at startup, <code>loop()</code> repeatedly forever afterward.</p>

  <h3>Local vs. global variables and scope</h3>
  <table class="data-table">
    <caption>Local vs. global variables</caption>
    <thead><tr><th>Kind</th><th>Declared</th><th>Visible from</th><th>Lifetime</th></tr></thead>
    <tbody>
      <tr><td>Local</td><td>Inside a function or block</td><td>Only within that function or block</td><td>Created when the block starts, destroyed when it ends</td></tr>
      <tr><td>Global</td><td>Outside any function, at the top of the sketch</td><td>Every function in the file</td><td>Exists for the entire time the program runs</td></tr>
    </tbody>
  </table>
  <p>Values that must survive between calls to <code>loop()</code> -- like a running counter, or the last time an event happened -- need to be global (or, equivalently, declared <code>static</code> inside the function).</p>

  <h3>Passing parameters by value vs. by reference</h3>
  <pre><code>void doubleIt(int x) {
    x = x * 2;            // only changes the local copy
}

void doubleItByReference(int &amp;x) {
    x = x * 2;             // changes the caller''s original variable
}</code></pre>
  <p>By default, arguments are passed by value -- the function receives its own copy, and changes inside the function do not affect the caller&prime;s variable. Adding <code>&amp;</code> after the type makes the parameter a reference, letting the function modify the caller&prime;s original variable directly -- useful for functions that need to report back more than one result.</p>',
  4
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
  5
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'pwm-and-analog-output',
  'PWM & Analog Output',
  '<h3>Why analogWrite() is not really analog</h3>
  <p>Most Arduino pins cannot output a true, continuously variable voltage -- <code>analogWrite()</code> instead uses Pulse Width Modulation (PWM), rapidly switching the pin fully on and off so the <em>average</em> voltage approximates the value requested.</p>
  <pre><code>analogWrite(9, 128);   // roughly 50% duty cycle on a PWM-capable pin</code></pre>
  <p>On most AVR-based boards, <code>analogWrite()</code> accepts values from 0 (always off) to 255 (always on), and only works on pins marked with a <code>~</code> on the board silkscreen -- those are the pins physically wired to a hardware PWM timer.</p>

  <h3>Duty cycle and effective voltage</h3>
  <table class="data-table">
    <caption>PWM value vs. approximate effective voltage (5 V board)</caption>
    <thead><tr><th>analogWrite() value</th><th>Duty cycle</th><th>Effective voltage</th></tr></thead>
    <tbody>
      <tr><td>0</td><td>0%</td><td>0 V</td></tr>
      <tr><td>64</td><td>25%</td><td>1.25 V</td></tr>
      <tr><td>128</td><td>50%</td><td>2.5 V</td></tr>
      <tr><td>255</td><td>100%</td><td>5 V</td></tr>
    </tbody>
  </table>
  <p>This is the same duty-cycle idea covered for DC motor speed control in the Robotics course -- <code>analogWrite()</code> is simply the Arduino API for generating that PWM signal.</p>

  <h3>PWM frequency</h3>
  <p>Most Arduino PWM pins switch around 490 Hz or 980 Hz by default (a few specific pins run faster) -- fast enough that an LED&prime;s brightness or a motor&prime;s speed appears smooth to the eye and to mechanical inertia, but potentially audible as a faint whine on some motors or speakers.</p>

  <h3>Generating a specific tone</h3>
  <pre><code>tone(BUZZER_PIN, 440, 1000);   // play 440 Hz (concert A) for 1000 ms
noTone(BUZZER_PIN);              // stop immediately</code></pre>
  <p><code>tone()</code> is a separate function from <code>analogWrite()</code> -- rather than a fixed-frequency PWM signal with variable duty cycle, it generates a square wave at whatever frequency is requested, which is what makes it useful for musical notes and beeps rather than dimming or speed control.</p>

  <h3>Driving a servo motor</h3>
  <p>Standard hobby servos are controlled with a different kind of pulse entirely: not a duty-cycle percentage, but a pulse of a specific width (typically 1-2 ms) repeated about every 20 ms, where the pulse width -- not the duty cycle -- encodes the desired angle. The Servo library (covered in the next lesson) handles generating this timing automatically:</p>
  <pre><code>#include &lt;Servo.h&gt;

Servo myServo;

void setup() {
    myServo.attach(9);
}

void loop() {
    myServo.write(90);   // move to 90 degrees
    delay(1000);
}</code></pre>',
  6
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'arrays-strings-and-data-structures',
  'Arrays, Strings & Data Structures',
  '<h3>Arrays</h3>
  <pre><code>int sensorReadings[5];               // an array of 5 ints, initially undefined values
int ledPins[3] = {2, 3, 4};           // an array initialized with values

for (int i = 0; i &lt; 3; i++) {
    pinMode(ledPins[i], OUTPUT);
}</code></pre>
  <p>Arrays in C++ have a fixed size decided at compile time and are not automatically bounds-checked -- reading or writing past the end of an array silently corrupts whatever memory happens to be next to it, rather than raising an error. Always size loops using the array&prime;s known length (or a named constant) rather than a hard-coded number that might drift out of sync.</p>

  <h3>char arrays (C-strings) vs. the String class</h3>
  <table class="data-table">
    <caption>char array vs. String</caption>
    <thead><tr><th>Aspect</th><th><code>char</code> array</th><th><code>String</code> class</th></tr></thead>
    <tbody>
      <tr><td>Storage</td><td>Fixed-size buffer, chosen up front</td><td>Grows and shrinks dynamically on the heap</td></tr>
      <tr><td>Ease of use</td><td>More manual (needs functions like <code>strcpy</code>, <code>strcat</code>)</td><td>Convenient operators (<code>+</code>, <code>==</code>) and methods</td></tr>
      <tr><td>Memory risk</td><td>Fixed and predictable</td><td>Repeated concatenation can fragment the tiny heap on small boards, eventually causing crashes</td></tr>
    </tbody>
  </table>
  <pre><code>char greeting[] = "hello";           // a C-string: characters plus a hidden trailing ''\0''
String greeting2 = "hello";           // a String object</code></pre>
  <p>On memory-constrained boards like the Uno (2 KB of SRAM total), many experienced Arduino programmers avoid the <code>String</code> class in code that runs for a long time, preferring <code>char</code> arrays specifically to avoid heap fragmentation.</p>

  <h3>structs: grouping related data</h3>
  <pre><code>struct SensorReading {
    int pin;
    float value;
    unsigned long timestamp;
};

SensorReading temp = {A0, 23.5, 0};</code></pre>
  <p>A <code>struct</code> bundles several related pieces of data into one named type, which is often clearer than tracking several separate parallel arrays (one array of pins, another of values, another of timestamps) that all have to stay in sync by hand.</p>',
  7
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'libraries-and-the-arduino-ecosystem',
  'Libraries & the Arduino Ecosystem',
  '<h3>What a library is</h3>
  <p>A library is a pre-written, reusable package of functions (and often a class) that handles something so common it would be wasteful to rewrite from scratch -- driving a specific sensor, generating servo pulses, talking over a communication bus, and so on.</p>
  <pre><code>#include &lt;Servo.h&gt;   // a library already bundled with the Arduino IDE
#include &lt;DHT.h&gt;       // a third-party library, installed separately</code></pre>

  <h3>Installing libraries</h3>
  <table class="data-table">
    <caption>Ways to add a library</caption>
    <thead><tr><th>Method</th><th>How</th></tr></thead>
    <tbody>
      <tr><td>Library Manager</td><td>Sketch &gt; Include Library &gt; Manage Libraries, then search and install</td></tr>
      <tr><td>ZIP install</td><td>Sketch &gt; Include Library &gt; Add .ZIP Library, for libraries downloaded manually</td></tr>
      <tr><td>Manual copy</td><td>Place the library folder directly inside the sketchbook&prime;s <code>libraries</code> folder</td></tr>
    </tbody>
  </table>

  <h3>Commonly used built-in libraries</h3>
  <table class="data-table">
    <caption>Libraries bundled with the Arduino IDE</caption>
    <thead><tr><th>Library</th><th>Purpose</th></tr></thead>
    <tbody>
      <tr><td>Servo.h</td><td>Generates the precise pulse timing hobby servos need</td></tr>
      <tr><td>Wire.h</td><td>I2C communication (see the Communication Protocols lesson)</td></tr>
      <tr><td>SPI.h</td><td>SPI communication (see the Communication Protocols lesson)</td></tr>
      <tr><td>EEPROM.h</td><td>Reading and writing the microcontroller&prime;s non-volatile EEPROM memory</td></tr>
    </tbody>
  </table>

  <h3>Classes and objects, briefly</h3>
  <p>Most libraries expose a class -- <code>Servo</code>, for example -- rather than a plain function. Creating a variable of that type (<code>Servo myServo;</code>) makes an <strong>object</strong>, and calling methods on it (<code>myServo.attach(9)</code>, <code>myServo.write(90)</code>) is how the library is actually used. It is entirely possible to use Arduino productively while treating this as "the syntax the library documentation shows me," without first learning object-oriented programming from scratch.</p>',
  8
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
  9
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'interrupts-in-arduino',
  'Interrupts',
  '<h3>Why interrupts</h3>
  <p>Polling a pin inside <code>loop()</code> only checks it whenever <code>loop()</code> happens to reach that line -- a fast or brief event (a button press, an encoder pulse, an incoming signal edge) can be missed entirely if the rest of <code>loop()</code> is busy doing something else at that moment. An interrupt instead pauses whatever the processor is doing and immediately runs a dedicated function the moment a specified event occurs.</p>

  <h3>attachInterrupt()</h3>
  <pre><code>volatile bool buttonPressed = false;

void setup() {
    pinMode(2, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(2), onButtonPress, FALLING);
}

void onButtonPress() {
    buttonPressed = true;
}

void loop() {
    if (buttonPressed) {
        buttonPressed = false;
        // handle the button press here, outside the interrupt itself
    }
}</code></pre>
  <p>Only certain pins support external interrupts (commonly just two on smaller AVR boards), and the trigger condition -- <code>RISING</code>, <code>FALLING</code>, or <code>CHANGE</code> -- determines which edge of the signal fires the interrupt.</p>

  <h3>Rules for writing an interrupt service routine (ISR)</h3>
  <ul>
    <li>Keep it as short as possible -- normal program execution, and any other interrupts, are paused while it runs.</li>
    <li>Never call <code>delay()</code> inside an ISR, and avoid <code>Serial.print()</code> there too.</li>
    <li>Any variable shared between an ISR and the rest of the program must be declared <code>volatile</code>, so the compiler does not wrongly assume it never changes and optimize away a check of its value.</li>
    <li>The usual pattern is to have the ISR do the absolute minimum -- typically just setting a flag or a variable -- and let <code>loop()</code> do the real work once it next checks that flag.</li>
  </ul>

  <h3>Debouncing a mechanical button</h3>
  <p>A mechanical switch does not transition cleanly -- it "bounces," producing several rapid, spurious transitions over a few milliseconds as the contacts physically settle. Both interrupt-driven and polled button code typically need debouncing: ignoring further changes for a short window (often 10-50 ms) after the first detected transition.</p>',
  10
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'timers-and-non-blocking-timing',
  'Timers & Non-Blocking Timing',
  '<h3>The problem with delay()</h3>
  <p><code>delay()</code> is easy to use but blocks everything -- no other code runs, no pins are read, no other timed events can happen, for the entire duration of the delay. A sketch that needs to blink an LED, read a sensor, and check a button all at their own independent rates cannot do all three with <code>delay()</code> alone.</p>

  <h3>millis() and the standard non-blocking pattern</h3>
  <p><code>millis()</code> returns the number of milliseconds since the board was last reset, and keeps counting in the background regardless of what <code>loop()</code> is doing. Comparing it against a saved timestamp lets a sketch check "has enough time passed yet?" without ever blocking:</p>
  <pre><code>unsigned long lastBlinkTime = 0;
const unsigned long blinkInterval = 500;   // ms
bool ledState = false;

void loop() {
    unsigned long now = millis();
    if (now - lastBlinkTime &gt;= blinkInterval) {
        lastBlinkTime = now;
        ledState = !ledState;
        digitalWrite(LED_PIN, ledState);
    }

    // ... other code runs every loop() iteration, completely unaffected ...
}</code></pre>
  <p>Using subtraction (<code>now - lastBlinkTime</code>) rather than comparing absolute times directly is a deliberate habit: <code>millis()</code> eventually overflows and wraps back to 0 after about 49.7 days, and unsigned subtraction still produces the correct elapsed time across that wraparound, while comparing absolute timestamps directly would not.</p>

  <h3>micros() for finer resolution</h3>
  <p><code>micros()</code> works the same way but returns microseconds instead of milliseconds, useful for timing that needs finer resolution than a millisecond -- at the cost of overflowing much sooner, after about 70 minutes.</p>

  <h3>State machines: scaling up the same idea</h3>
  <p>The same "check the time, act, remember the new timestamp" pattern generalizes into a state machine, where a variable tracks which phase of a multi-step timed sequence the program is currently in (e.g. a traffic light cycling through red, green, and yellow) -- the same concept, and often the same state-diagram design process, as the Finite State Machines lesson in the Digital Logic Design course, just implemented in software with <code>millis()</code> in place of a hardware clock signal.</p>',
  11
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'reading-sensors',
  'Reading Sensors',
  '<h3>Digital sensors and pull-up/pull-down resistors</h3>
  <p>A simple digital sensor (a button, a magnetic door switch, many PIR motion sensors) just needs to present a clean HIGH or LOW to a digital input pin. An unconnected ("floating") digital input reads unpredictably, picking up electrical noise -- a pull-up or pull-down resistor guarantees a known default state when the sensor is not actively driving the pin.</p>
  <pre><code>pinMode(BUTTON_PIN, INPUT_PULLUP);   // most AVR boards have this built in -- no external resistor needed

void loop() {
    if (digitalRead(BUTTON_PIN) == LOW) {   // note: pressed reads LOW with a pull-up
        // button is pressed
    }
}</code></pre>
  <p><code>INPUT_PULLUP</code> enables an internal resistor that pulls the pin HIGH by default; wiring a button between the pin and ground then pulls it LOW only while pressed -- which is why the pressed condition reads LOW rather than HIGH with this common wiring style.</p>

  <h3>Analog sensors</h3>
  <p><code>analogRead()</code> reads a voltage between 0 and the board&prime;s reference voltage (5 V or 3.3 V, depending on the board) and returns a number from 0 to 1023 (a 10-bit reading on most AVR boards).</p>
  <table class="data-table">
    <caption>Common analog sensors</caption>
    <thead><tr><th>Sensor</th><th>What it varies</th><th>Typical wiring</th></tr></thead>
    <tbody>
      <tr><td>Potentiometer</td><td>Resistance, mechanically, as a knob turns</td><td>A simple voltage divider between power and ground, with the wiper going to an analog pin</td></tr>
      <tr><td>LDR (light-dependent resistor)</td><td>Resistance, based on light level</td><td>Voltage divider with a fixed resistor</td></tr>
      <tr><td>Thermistor</td><td>Resistance, based on temperature</td><td>Voltage divider with a fixed resistor</td></tr>
    </tbody>
  </table>

  <h3>Scaling raw readings with map()</h3>
  <pre><code>int raw = analogRead(A0);                     // 0-1023
int angle = map(raw, 0, 1023, 0, 180);          // rescale to 0-180 for a servo</code></pre>
  <p><code>map()</code> linearly rescales a value from one range to another -- useful anywhere a raw sensor reading needs to be converted into a more meaningful unit (degrees, percent, millivolts) before being used.</p>

  <h3>Filtering noisy readings</h3>
  <p>Raw analog readings are rarely perfectly stable. A simple moving average -- averaging several consecutive readings together -- smooths out noise at the cost of reacting slightly more slowly to real changes:</p>
  <pre><code>const int numSamples = 10;
int total = 0;
for (int i = 0; i &lt; numSamples; i++) {
    total += analogRead(A0);
    delay(2);
}
int average = total / numSamples;</code></pre>',
  12
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'driving-actuators-with-arduino',
  'Driving Actuators',
  '<h3>Why a microcontroller pin usually cannot drive a motor directly</h3>
  <p>An Arduino pin can typically supply only about 20-40 mA safely, and the whole board&prime;s regulator has limits too -- nowhere near enough for a DC motor, solenoid, or anything but the smallest LED. Anything that draws significant current needs to be switched by a separate device that the microcontroller merely controls, not powers directly.</p>

  <h3>LEDs: current limiting</h3>
  <pre><code>int ledPin = 9;
pinMode(ledPin, OUTPUT);
digitalWrite(ledPin, HIGH);</code></pre>
  <p>An LED without a series resistor will draw far more current than it or the driving pin can safely handle. A resistor sized with Ohm&prime;s Law (from the Electricity & Electronics course), using the LED&prime;s forward voltage and a safe target current (often 10-20 mA), protects both the LED and the pin.</p>

  <h3>Switching higher-current loads: transistors and MOSFETs</h3>
  <p>A small signal transistor or MOSFET, driven by a digital pin, can switch a much larger current than the pin itself could -- the pin only needs to supply the small base/gate current (or, for a MOSFET, essentially no steady current at all) needed to turn the switch fully on.</p>
  <pre><code>digitalWrite(motorControlPin, HIGH);   // turns the transistor/MOSFET fully on,
                                         // which switches the actual motor current</code></pre>
  <p>A flyback diode across any motor, relay coil, or solenoid is essential: switching off a suddenly de-energized inductive load (see the Inductors & Inductance lesson in the Electricity & Electronics course) generates a voltage spike that can destroy the switching transistor without one.</p>

  <h3>DC motors and H-bridges</h3>
  <p>Controlling a DC motor&prime;s direction, not just its on/off state, needs an H-bridge -- a circuit of four switches described in detail in the Robotics course&prime;s Motor Control lesson. Motor driver modules and ICs (like the L298N or DRV8833) package an H-bridge behind a simple two- or three-pin interface that <code>digitalWrite()</code> and <code>analogWrite()</code> can drive directly.</p>

  <h3>Servo motors</h3>
  <p>As covered in the PWM lesson, hobby servos are controlled with the Servo library rather than plain PWM duty cycle:</p>
  <pre><code>#include &lt;Servo.h&gt;
Servo armServo;

void setup() {
    armServo.attach(9);
}

void loop() {
    armServo.write(45);   // move to 45 degrees
}</code></pre>

  <h3>Relays</h3>
  <p>A relay uses a small electromagnet to physically open or close a separate, electrically isolated switch contact -- useful for controlling AC mains-powered devices (lamps, appliances) from a low-voltage microcontroller pin, since the microcontroller side never directly touches the higher, more dangerous voltage.</p>',
  13
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'eeprom-and-persistent-storage',
  'EEPROM & Persistent Storage',
  '<h3>Why EEPROM</h3>
  <p>SRAM (where regular variables live) loses its contents the instant power is removed. EEPROM (Electrically Erasable Programmable Read-Only Memory) is a small block of memory that keeps its contents even with no power at all -- useful for settings, calibration values, or counters that need to survive a reset or power loss.</p>

  <h3>Reading and writing EEPROM</h3>
  <pre><code>#include &lt;EEPROM.h&gt;

void setup() {
    EEPROM.write(0, 42);           // write the byte 42 to EEPROM address 0
    byte value = EEPROM.read(0);   // read it back
}</code></pre>
  <p>For anything larger than a single byte -- an <code>int</code>, a <code>float</code>, or a whole struct -- the library also provides <code>EEPROM.put()</code> and <code>EEPROM.get()</code>, which handle the multi-byte layout automatically.</p>

  <h3>EEPROM has a limited lifespan</h3>
  <p>A typical AVR EEPROM cell is rated for roughly 100,000 write cycles before it becomes unreliable -- reads are unlimited, but repeatedly writing the same address (for example, every single time through <code>loop()</code>) can wear it out surprisingly quickly. <code>EEPROM.update()</code> writes a value only if it is actually different from what is already stored, avoiding wasted write cycles when the value has not changed.</p>

  <h3>Other options for larger or more frequent storage</h3>
  <table class="data-table">
    <caption>Storage options beyond built-in EEPROM</caption>
    <thead><tr><th>Option</th><th>When to reach for it</th></tr></thead>
    <tbody>
      <tr><td>SD card module</td><td>Logging large amounts of data, or data that changes frequently</td></tr>
      <tr><td>External I2C/SPI EEPROM or FRAM chip</td><td>Need more storage than the built-in EEPROM, or (FRAM) far more write cycles</td></tr>
      <tr><td>Flash-based storage (e.g. via a filesystem library)</td><td>Boards without a traditional EEPROM peripheral</td></tr>
    </tbody>
  </table>',
  14
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'power-management-and-sleep-modes',
  'Power Management & Sleep Modes',
  '<h3>Why power matters</h3>
  <p>A board plugged into a wall adapter can ignore power consumption almost entirely. A battery-powered project cannot: a sensor node that draws a few milliamps continuously might run for days, while the same node put to sleep between readings and waking only briefly can often run for months or years on the same battery.</p>

  <h3>Where the power goes</h3>
  <table class="data-table">
    <caption>Typical current draw by activity (illustrative, board- and code-dependent)</caption>
    <thead><tr><th>State</th><th>Typical current</th></tr></thead>
    <tbody>
      <tr><td>Actively running, radio/peripherals on</td><td>Tens of milliamps</td></tr>
      <tr><td>Actively running, idle CPU</td><td>Several milliamps to tens of milliamps</td></tr>
      <tr><td>Deep sleep mode</td><td>Microamps or less, depending on the board</td></tr>
    </tbody>
  </table>

  <h3>Sleep modes</h3>
  <p>Most microcontrollers support several sleep modes that trade wake-up latency and which peripherals stay active against how little power is drawn. On AVR boards, the <code>avr/sleep.h</code> header provides several modes, from a light "idle" sleep (CPU stopped, timers and interrupts still running) down to "power down" (almost everything stopped, woken only by specific external events like a pin-change interrupt or the watchdog timer).</p>
  <pre><code>#include &lt;avr/sleep.h&gt;

void enterSleep() {
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    sleep_enable();
    sleep_mode();     // execution pauses here until an interrupt wakes the board
    sleep_disable();
}</code></pre>

  <h3>The watchdog timer</h3>
  <p>A watchdog timer can do two different jobs: waking a sleeping board on a schedule (since deep sleep otherwise stops even the normal <code>millis()</code> timer), and acting as a safety net that resets the board automatically if the main program ever hangs and fails to "check in" (reset the watchdog) within an expected interval.</p>

  <h3>Practical low-power habits</h3>
  <ul>
    <li>Turn off peripherals (sensors, radios, displays) when they are not actively needed, rather than leaving them powered continuously.</li>
    <li>Sleep between readings instead of polling in a tight loop.</li>
    <li>Reduce clock speed if the application does not need full processing speed, since power draw generally scales with clock frequency.</li>
    <li>Choose components (sensors, voltage regulators) rated for low quiescent current when battery life matters.</li>
  </ul>',
  15
),
(
  (SELECT id FROM courses WHERE slug = 'arduino'),
  'debugging-and-best-practices',
  'Debugging & Best Practices',
  '<h3>Serial.print() as a debugging tool</h3>
  <pre><code>void setup() {
    Serial.begin(9600);
}

void loop() {
    int reading = analogRead(A0);
    Serial.print("Sensor reading: ");
    Serial.println(reading);
    delay(500);
}</code></pre>
  <p>Without a debugger attached (which most Arduino setups do not have), printing values to the Serial Monitor is the primary way to see what a sketch is actually doing -- confirm a variable&prime;s value, confirm a function was actually called, or confirm the timing between two events.</p>

  <h3>Common Arduino bugs</h3>
  <table class="data-table">
    <caption>Frequent beginner mistakes</caption>
    <thead><tr><th>Symptom</th><th>Likely cause</th></tr></thead>
    <tbody>
      <tr><td>Whole sketch appears frozen or unresponsive</td><td>A blocking <code>delay()</code>, or a <code>while</code> loop waiting on a condition that never becomes true</td></tr>
      <tr><td>A variable shared with an interrupt seems to update itself randomly, or a flag set inside an interrupt never seems to be noticed</td><td>The variable was not declared <code>volatile</code></td></tr>
      <tr><td>Sketch runs fine briefly, then crashes or behaves erratically</td><td>Running out of SRAM, often from excessive <code>String</code> concatenation</td></tr>
      <tr><td>Digital input reads randomly HIGH and LOW with nothing connected</td><td>A floating input pin with no pull-up/pull-down resistor</td></tr>
      <tr><td>analogWrite() has no visible effect</td><td>Using a pin that does not support PWM (missing the <code>~</code> marking)</td></tr>
    </tbody>
  </table>

  <h3>Checking memory usage</h3>
  <p>The Arduino IDE reports program storage (Flash) and dynamic memory (SRAM) usage after every compile. An Uno has only 2 KB of SRAM total, shared between global variables, the call stack, and anything the <code>String</code> class or other dynamic allocation needs -- a sketch that is close to that limit is at real risk of unpredictable crashes as available memory shrinks further at runtime.</p>

  <h3>Code organization habits that scale</h3>
  <ul>
    <li>Give pins and constants meaningful names with <code>const int</code>, rather than scattering unexplained numbers ("magic numbers") through the code.</li>
    <li>Break repeated logic out into functions instead of copy-pasting the same block repeatedly.</li>
    <li>Keep <code>loop()</code> non-blocking (see the Timers & Non-Blocking Timing lesson) so the sketch stays responsive as more features are added.</li>
    <li>Comment the <em>why</em> behind a non-obvious choice, not the <em>what</em> a line already makes clear from its own code.</li>
  </ul>',
  16
)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  content = VALUES(content),
  sort_order = VALUES(sort_order);
