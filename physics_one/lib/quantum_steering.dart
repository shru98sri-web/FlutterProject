import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(
  const MaterialApp(
    home: QuantumSteeringSimulator(),
    debugShowCheckedModeBanner: false,
  ),
);

class QuantumSteeringSimulator extends StatefulWidget {
  const QuantumSteeringSimulator({super.key});

  @override
  State<QuantumSteeringSimulator> createState() =>
      _QuantumSteeringSimulatorState();
}

class _QuantumSteeringSimulatorState extends State<QuantumSteeringSimulator>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _rotationAngle = 0.0;

  // Alice's measurement angle (theta) controlled by user slider
  double _aliceTheta = 0.0;
  double _alicePhi = 0.0;

  @override
  void initState() {
    super.initState();
    // High-performance render loop for continuous sphere rotation animation
    _ticker = createTicker((Duration elapsed) {
      setState(() {
        _rotationAngle = (elapsed.inMilliseconds / 2000.0) % (2 * math.pi);
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text('Quantum Steering Simulator'),
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: BlochSpherePainter(
                rotationAngle: _rotationAngle,
                aliceTheta: _aliceTheta,
                alicePhi: _alicePhi,
              ),
            ),
          ),
          _buildControlPanel(),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: const Color(0xFF161B22),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alice\'s Measurement Angle-Polar theta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _aliceTheta,
              min: 0.0,
              max: math.pi,
              activeColor: Colors.deepPurpleAccent,
              onChanged: (val) => setState(() => _aliceTheta = val),
            ),
            const SizedBox(height: 10),
            const Text(
              'Alice\'s Measurement Angle (Azimuthal phi)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _alicePhi,
              min: 0.0,
              max: 2 * math.pi,
              activeColor: Colors.cyanAccent,
              onChanged: (val) => setState(() => _alicePhi = val),
            ),
            const SizedBox(height: 8),
            Text(
              'Bob\'s Steered State Matrix Vector: [${(-math.sin(_aliceTheta) * math.cos(_alicePhi)).toStringAsFixed(2)}, ${(-math.sin(_aliceTheta) * math.sin(_alicePhi)).toStringAsFixed(2)}, ${(-math.cos(_aliceTheta)).toStringAsFixed(2)}]',
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlochSpherePainter extends CustomPainter {
  final double rotationAngle;
  final double aliceTheta;
  final double alicePhi;

  BlochSpherePainter({
    required this.rotationAngle,
    required this.aliceTheta,
    required this.alicePhi,
  });

  // Orthographic 3D projection mathematical matrix helper
  Offset project(double x, double y, double z, Size size) {
    double cx = size.width / 2;
    double cy = size.height / 2;

    // Rotate around Y axis over time
    double cosRY = math.cos(rotationAngle);
    double sinRY = math.sin(rotationAngle);
    double xRot = x * cosRY - z * sinRY;
    double zRot = x * sinRY + z * cosRY;

    // Rotate slightly around X axis for perspective tilt
    double cosRX = math.cos(0.4);
    double sinRX = math.sin(0.4);
    double yRot = y * cosRX - zRot * sinRX;

    double scale = 150.0; // Bloch sphere radius pixels
    return Offset(cx + xRot * scale, cy - yRot * scale);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final wireframePaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = Colors.white30
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 1. Draw Bloch Sphere Wireframe Bounds
    canvas.drawCircle(center, 150.0, wireframePaint);

    // Draw Equator Line Envelope
    final equatorPath = Path();
    for (int i = 0; i <= 360; i += 10) {
      double rad = i * math.pi / 180;
      Offset pt = project(math.cos(rad), 0, math.sin(rad), size);
      if (i == 0)
        equatorPath.moveTo(pt.dx, pt.dy);
      else
        equatorPath.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(equatorPath, wireframePaint);

    // 2. Draw Quantum Coordinate Axes (X, Y, Z Basis States)
    Offset xNeg = project(-1.1, 0, 0, size);
    Offset xPos = project(1.1, 0, 0, size);
    Offset yNeg = project(0, -1.1, 0, size);
    Offset yPos = project(0, 1.1, 0, size);
    Offset zNeg = project(0, 0, -1.1, size);
    Offset zPos = project(0, 0, 1.1, size);

    canvas.drawLine(xNeg, xPos, axisPaint);
    canvas.drawLine(yNeg, yPos, axisPaint);
    canvas.drawLine(zNeg, zPos, axisPaint);

    // Text descriptions for standard computational basis states
    _drawText(canvas, zPos + const Offset(-5, -20), '|0⟩', Colors.white70);
    _drawText(canvas, zNeg + const Offset(-5, 5), '|1⟩', Colors.white70);

    // 3. Compute Alice's Steering projection mapping
    // For singlet state, Bob's density matrix state collapses strictly opposite to Alice's choice
    double ax = math.sin(aliceTheta) * math.cos(alicePhi);
    double ay = math.sin(aliceTheta) * math.sin(alicePhi);
    double az = math.cos(aliceTheta);

    // Bob's Anti-correlated steered vector projection point
    double bx = -ax;
    double by = -ay;
    double bz = -az;

    Offset aliceProjected = project(ax, ay, az, size);
    Offset bobProjected = project(bx, by, bz, size);

    // 4. Render the Quantum Steering Correlation Vectors
    final aliceVectorPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final bobVectorPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Draw Alice Measurement Path Pointer
    canvas.drawLine(center, aliceProjected, aliceVectorPaint);
    canvas.drawCircle(aliceProjected, 5.0, Paint()..color = Colors.redAccent);
    _drawText(
      canvas,
      aliceProjected + const Offset(8, -8),
      'Alice (Vector vec{n})',
      Colors.redAccent,
    );

    // Draw Bob's Collapsed Vector State (The steered state)
    canvas.drawLine(center, bobProjected, bobVectorPaint);
    canvas.drawCircle(bobProjected, 6.0, Paint()..color = Colors.greenAccent);
    _drawText(
      canvas,
      bobProjected + const Offset(8, 8),
      'Bob State rho_B',
      Colors.greenAccent,
    );

    // Draw EPR Non-local connection line dashboard effect
    final eprPaint = Paint()
      ..color = Colors.amberAccent.withOpacity(0.4)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(aliceProjected, bobProjected, eprPaint);
  }

  void _drawText(Canvas canvas, Offset offset, String text, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant BlochSpherePainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.aliceTheta != aliceTheta ||
        oldDelegate.alicePhi != alicePhi;
  }
}
