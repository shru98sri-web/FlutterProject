import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const DosSimulationApp());
}

class DosSimulationApp extends StatelessWidget {
  const DosSimulationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solid State Physics: DOS Sim',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF11121C),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.amberAccent,
        ),
      ),
      home: const DosSimulationPage(),
    );
  }
}

class DosSimulationPage extends StatefulWidget {
  const DosSimulationPage({super.key});

  @override
  State<DosSimulationPage> createState() => _DosSimulationPageState();
}

class _DosSimulationPageState extends State<DosSimulationPage> {
  double _fermiEnergy = 2.5; // eV
  double _temperature = 300.0; // Kelvin
  String _dimension = '3D'; // 3D, 2D, or 1D

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Density of States (DOS) Simulator'),
        elevation: 0,
        backgroundColor: const Color(0xFF1A1C29),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final content = [
            // Controls Panel
            Expanded(flex: isWide ? 1 : 0, child: _buildControlsCard()),
            if (!isWide) const SizedBox(height: 16),
            // Graphic Visualization Viewport
            Expanded(
              flex: isWide ? 2 : 0,
              child: AspectRatio(
                aspectRatio: isWide ? 1.3 : 1.0,
                child: Card(
                  color: const Color(0xFF1A1C29),
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomPaint(
                      painter: DosChartPainter(
                        dimension: _dimension,
                        fermiEnergy: _fermiEnergy,
                        temperature: _temperature,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];

          return isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: content,
                )
              : SingleChildScrollView(child: Column(children: content));
        },
      ),
    );
  }

  Widget _buildControlsCard() {
    return Card(
      color: const Color(0xFF1A1C29),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Lattice Topology',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: '3D', label: Text('3D Bulk')),
                ButtonSegment(value: '2D', label: Text('2D Well')),
                ButtonSegment(value: '1D', label: Text('1D Wire')),
              ],
              selected: {_dimension},
              onSelectionChanged: (set) =>
                  setState(() => _dimension = set.first),
            ),
            const SizedBox(height: 24),
            Text(
              'Fermi Energy (Ef): ${_fermiEnergy.toStringAsFixed(2)} eV',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Slider(
              value: _fermiEnergy,
              min: 0.5,
              max: 4.5,
              onChanged: (val) => setState(() => _fermiEnergy = val),
            ),
            const SizedBox(height: 16),
            Text(
              'Temperature (T): ${_temperature.toStringAsFixed(0)} K',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Slider(
              value: _temperature,
              min: 5.0,
              max: 1200.0,
              onChanged: (val) => setState(() => _temperature = val),
            ),
            const Divider(height: 32, color: Colors.white24),
            _buildLegendRow(
              Colors.cyanAccent,
              'Available Energy States (g(E))',
            ),
            const SizedBox(height: 8),
            _buildLegendRow(
              Colors.amberAccent,
              'Occupied Electron Density (n(E))',
            ),
            const SizedBox(height: 8),
            _buildLegendRow(
              Colors.redAccent,
              'Fermi Level (Ef)',
              isDashed: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendRow(Color color, String label, {bool isDashed = false}) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 4,
          decoration: BoxDecoration(
            color: isDashed ? null : color,
            border: isDashed
                ? Border(
                    bottom: BorderSide(
                      color: color,
                      width: 2,
                      style: BorderStyle.none,
                    ),
                  )
                : null,
          ),
          child: isDashed
              ? Center(
                  child: Text(
                    '- -',
                    style: TextStyle(
                      color: color,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.white70),
        ),
      ],
    );
  }
}

class DosChartPainter extends CustomPainter {
  final String dimension;
  final double fermiEnergy;
  final double temperature;

  DosChartPainter({
    required this.dimension,
    required this.fermiEnergy,
    required this.temperature,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double paddingLeft = 50.0;
    final double paddingBottom = 40.0;
    final double chartWidth = size.width - paddingLeft - 20;
    final double chartHeight = size.height - paddingBottom - 20;

    final axisPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw Graph Framework Axis Paths
    canvas.drawLine(
      Offset(paddingLeft, 20),
      Offset(paddingLeft, chartHeight + 20),
      axisPaint,
    );
    canvas.drawLine(
      Offset(paddingLeft, chartHeight + 20),
      Offset(paddingLeft + chartWidth, chartHeight + 20),
      axisPaint,
    );

    // Dynamic scale mappings
    const double maxEnergy = 5.0; // Max horizontal eV
    double maxDosY = 4.0;
    if (dimension == '1D')
      maxDosY = 8.0; // Extra headroom for singular vertical asymptotic spikes

    // Compute Boltzmann factor for dynamic structural calculation
    final double kb = 8.61733e-5; // eV/K
    final double kbt = kb * temperature;

    final Path dosPath = Path();
    final Path occupiedPath = Path();
    bool firstPoint = true;

    // Run structural iteration across step elements on the energy continuum axis
    for (double px = 0; px <= chartWidth; px += 1.0) {
      double energy = (px / chartWidth) * maxEnergy;
      double gE = 0.0;

      // Analytical calculations matching system dimensionality models
      if (dimension == '3D') {
        gE = (energy >= 0) ? 1.8 * math.sqrt(energy) : 0.0;
      } else if (dimension == '2D') {
        gE = 0.0;
        if (energy >= 1.0) gE += 1.5;
        if (energy >= 2.5) gE += 1.5;
        if (energy >= 4.0) gE += 1.5;
      } else if (dimension == '1D') {
        gE = 0.0;
        // Step accumulation incorporating discrete Van Hove analytical components
        final steps = [0.8, 2.2, 3.8];
        for (var step in steps) {
          if (energy > step) {
            gE += 0.45 / math.max(math.sqrt(energy - step), 0.08);
          }
        }
      }

      // Evaluate Quantum Occupancy Statistics via the Fermi-Dirac Distribution
      double fE = 1.0 / (math.exp((energy - fermiEnergy) / kbt) + 1.0);
      double nE = gE * fE;

      double cx = paddingLeft + px;
      double cyDos = (chartHeight + 20) - (gE / maxDosY) * chartHeight;
      double cyOccupied = (chartHeight + 20) - (nE / maxDosY) * chartHeight;

      // Bound clamp outputs cleanly onto canvas
      cyDos = cyDos.clamp(20, chartHeight + 20);
      cyOccupied = cyOccupied.clamp(20, chartHeight + 20);

      if (firstPoint) {
        dosPath.moveTo(cx, cyDos);
        occupiedPath.moveTo(cx, cyOccupied);
        firstPoint = false;
      } else {
        dosPath.lineTo(cx, cyDos);
        occupiedPath.lineTo(cx, cyOccupied);
      }
    }

    // Paint Quantum Distributions
    canvas.drawPath(
      dosPath,
      Paint()
        ..color = Colors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawPath(
      occupiedPath,
      Paint()
        ..color = Colors.amberAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Render Fermi Level Boundary Threshold Line
    final double fermiX = paddingLeft + (fermiEnergy / maxEnergy) * chartWidth;
    final fermiPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Custom structural execution for cleanly rendering dashed reference arrays
    for (double y = 20; y < chartHeight + 20; y += 8) {
      canvas.drawLine(Offset(fermiX, y), Offset(fermiX, y + 4), fermiPaint);
    }

    // Render Text Label Typography Strings
    _drawText(
      canvas,
      Offset(paddingLeft + chartWidth / 2 - 20, chartHeight + 25),
      "Energy (E) [eV]",
    );
    _drawText(canvas, const Offset(10, 15), "g(E) / n(E)");
  }

  void _drawText(Canvas canvas, Offset offset, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.white70, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant DosChartPainter oldDelegate) {
    return oldDelegate.dimension != dimension ||
        oldDelegate.fermiEnergy != fermiEnergy ||
        oldDelegate.temperature != temperature;
  }
}
