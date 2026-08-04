import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const OamLaserSimulator(),
    );
  }
}

class OamLaserSimulator extends StatefulWidget {
  const OamLaserSimulator({Key? key}) : super(key: key);

  @override
  State<OamLaserSimulator> createState() => _OamLaserSimulatorState();
}

class _OamLaserSimulatorState extends State<OamLaserSimulator> {
  // Simulation parameters
  double l1 = 6; // Azimuthal order / Topological charge of Ring 1
  double l2 = 5; // Azimuthal order / Topological charge of Ring 2
  double theta1 = 0; // Orientation angle of Ring 1 (degrees)
  double theta2 = 0; // Orientation angle of Ring 2 (degrees)
  double alpha = 45; // Coupling alignment angle (degrees)
  double couplingStrength = 0.3; // Coupling strength factor (0.0 to 1.0)
  bool showPhase = false; // Toggle between Intensity Profile and Phase Map

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupled OAM Micro-laser Simulator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Interactive Canvas
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: LaserOamPainter(
                    l1: l1.toInt(),
                    l2: l2.toInt(),
                    theta1: theta1 * math.pi / 180,
                    theta2: theta2 * math.pi / 180,
                    alpha: alpha * math.pi / 180,
                    couplingStrength: couplingStrength,
                    showPhase: showPhase,
                  ),
                ),
              ),
            ),
          ),

          // Mode Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Visualization Mode:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text("Intensity")),
                    ButtonSegment(value: true, label: Text("Phase")),
                  ],
                  selected: {showPhase},
                  onSelectionChanged: (set) =>
                      setState(() => showPhase = set.first),
                ),
              ],
            ),
          ),

          const Divider(height: 16),

          // Control Dashboard
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildSliderRow(
                    label: "Coupling Strength (κ)",
                    value: couplingStrength,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    isDecimal: true,
                    activeColor: Colors.cyanAccent,
                    onChanged: (val) => setState(() => couplingStrength = val),
                  ),
                  _buildSliderRow(
                    label: "Azimuthal Order l₁ (Ring 1)",
                    value: l1,
                    min: 2,
                    max: 12,
                    divisions: 10,
                    onChanged: (val) => setState(() => l1 = val),
                  ),
                  _buildSliderRow(
                    label: "Azimuthal Order l₂ (Ring 2)",
                    value: l2,
                    min: 2,
                    max: 12,
                    divisions: 10,
                    onChanged: (val) => setState(() => l2 = val),
                  ),
                  _buildSliderRow(
                    label: "Long-axis Direction θ₁ (°)",
                    value: theta1,
                    min: 0,
                    max: 360,
                    divisions: 360,
                    onChanged: (val) => setState(() => theta1 = val),
                  ),
                  _buildSliderRow(
                    label: "Long-axis Direction θ₂ (°)",
                    value: theta2,
                    min: 0,
                    max: 360,
                    divisions: 360,
                    onChanged: (val) => setState(() => theta2 = val),
                  ),
                  _buildSliderRow(
                    label: "Coupling Direction α (°)",
                    value: alpha,
                    min: 0,
                    max: 360,
                    divisions: 360,
                    onChanged: (val) => setState(() => alpha = val),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    bool isDecimal = false,
    Color activeColor = Colors.amber,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
            Text(
              isDecimal ? value.toStringAsFixed(2) : value.toStringAsFixed(0),
              style: TextStyle(fontWeight: FontWeight.bold, color: activeColor),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: activeColor,
          inactiveColor: Colors.grey.shade700,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class LaserOamPainter extends CustomPainter {
  final int l1;
  final int l2;
  final double theta1;
  final double theta2;
  final double alpha;
  final double couplingStrength;
  final bool showPhase;

  LaserOamPainter({
    required this.l1,
    required this.l2,
    required this.theta1,
    required this.theta2,
    required this.alpha,
    required this.couplingStrength,
    required this.showPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final double r1 = math.min(size.width, size.height) * 0.16;
    final double r2 = r1 * 0.85;

    // Stronger coupling physically decreases cavity center separation distance
    final double baseSeparation = r1 + r2;
    final double separation = baseSeparation - (couplingStrength * 25);

    final offset1 = Offset(
      -math.cos(alpha) * (separation / 2),
      -math.sin(alpha) * (separation / 2),
    );
    final offset2 = Offset(
      math.cos(alpha) * (separation / 2),
      math.sin(alpha) * (separation / 2),
    );

    final center1 = center + offset1;
    final center2 = center + offset2;

    if (showPhase) {
      _drawPhaseFringes(canvas, size, center1, center2, r1, r2);
    } else {
      // Draw Intensity Profiles with simulated junction mode-coupling effects
      _drawIntensityRing(
        canvas,
        center1,
        r1,
        l1,
        theta1,
        Colors.orangeAccent,
        center2,
        r2,
      );
      _drawIntensityRing(
        canvas,
        center2,
        r2,
        l2,
        theta2,
        Colors.redAccent,
        center1,
        r1,
      );

      _drawReferenceLines(canvas, center1, center2);
    }
  }

  void _drawIntensityRing(
    Canvas canvas,
    Offset center,
    double radius,
    int order,
    double rotation,
    Color color,
    Offset coupledCenter,
    double coupledRadius,
  ) {
    final boundaryPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, boundaryPaint);

    final int totalSpots = order * 2;
    final double angularStep = (2 * math.pi) / totalSpots;

    for (int i = 0; i < totalSpots; i++) {
      double angle = rotation + (i * angularStep);
      Offset spotPos =
          center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);

      // Check distance to the neighboring cavity center to calculate local coupling factor
      double distanceToCoupledCavity = (spotPos - coupledCenter).distance;
      double proximityToJunction = math.max(
        0,
        1 - (distanceToCoupledCavity / (coupledRadius * 1.5)),
      );

      // Stronger coupling scales spot intensity and introduces spatial interference distortions near the junction
      double intensityBoost =
          1.0 + (couplingStrength * proximityToJunction * 1.5);
      double dynamicSize = 7.0 + (couplingStrength * proximityToJunction * 5.0);

      final glowPaint = Paint()
        ..color = color.withOpacity(math.min(1.0, 0.8 * intensityBoost))
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          4 + (couplingStrength * proximityToJunction * 4),
        );
      canvas.drawCircle(spotPos, dynamicSize, glowPaint);

      final corePaint = Paint()
        ..color = Colors.white.withOpacity(
          math.min(1.0, 0.5 + (intensityBoost * 0.2)),
        );
      canvas.drawCircle(spotPos, 2.5, corePaint);
    }
  }

  void _drawPhaseFringes(
    Canvas canvas,
    Size size,
    Offset c1,
    Offset c2,
    double r1,
    double r2,
  ) {
    final paint = Paint();
    final double step = 3.5;

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        double dx1 = x - c1.dx;
        double dy1 = y - c1.dy;
        double dist1 = math.sqrt(dx1 * dx1 + dy1 * dy1);
        double phi1 = math.atan2(dy1, dx1);
        double dx2 = x - c2.dx;
        double dy2 = y - c2.dy;
        double dist2 = math.sqrt(dx2 * dx2 + dy2 * dy2);
        double phi2 = math.atan2(dy2, dx2);
        double phase1 = (l1 * phi1 + theta1) % (2 * math.pi);
        double phase2 = (l2 * phi2 + theta2) % (2 * math.pi);
        // As coupling strength increases, field interaction extends radially outwards
        double interactionRange = 300 + (couplingStrength * 200);
        double w1 = math.exp(-math.pow(dist1 - r1, 2) / interactionRange);
        double w2 = math.exp(-math.pow(dist2 - r2, 2) / interactionRange);
        // Superimpose fields
        double complexReal = w1 * math.cos(phase1) + w2 * math.cos(phase2);
        double complexImag = w1 * math.sin(phase1) + w2 * math.sin(phase2);
        double totalPhase = math.atan2(complexImag, complexReal);
        double normalized = (totalPhase + math.pi) / (2 * math.pi);
        paint.color = Color.lerp(
          Colors.purple.shade900,
          Colors.deepOrangeAccent,
          normalized,
        )!;
        canvas.drawRect(Rect.fromLTWH(x, y, step, step), paint);
      }
    }
  }

  void _drawReferenceLines(Canvas canvas, Offset c1, Offset c2) {
    final linePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(c1, c2, linePaint);
  }

  @override
  bool shouldRepaint(covariant LaserOamPainter oldDelegate) {
    return oldDelegate.l1 != l1 ||
        oldDelegate.l2 != l2 ||
        oldDelegate.theta1 != theta1 ||
        oldDelegate.theta2 != theta2 ||
        oldDelegate.alpha != alpha ||
        oldDelegate.couplingStrength != couplingStrength ||
        oldDelegate.showPhase != showPhase;
  }
}

//https://www.spiedigitallibrary.org/journals/advanced-photonics-nexus/volume-5/issue-05/056001/Coupled-orbital-angular-momentum-modes-for-an-ultra-high-dimensional/10.1117/1.APN.5.5.056001.full
