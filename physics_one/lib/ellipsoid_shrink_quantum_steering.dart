import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(
  const MaterialApp(
    home: AdvancedQuantumSteering(),
    debugShowCheckedModeBanner: false,
  ),
);

class AdvancedQuantumSteering extends StatefulWidget {
  const AdvancedQuantumSteering({super.key});

  @override
  State<AdvancedQuantumSteering> createState() =>
      _AdvancedQuantumSteeringState();
}

class _AdvancedQuantumSteeringState extends State<AdvancedQuantumSteering>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _rotationAngle = 0.0;

  // Controls
  double _purity = 0.75; // Werner state parameter 'p'
  double _aliceTheta = 0.6;
  double _alicePhi = 0.4;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration elapsed) {
      setState(() {
        _rotationAngle = (elapsed.inMilliseconds / 2500.0) % (2 * math.pi);
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
    // Dynamic physics calculations
    final double cavalcantiValue = _purity * math.sqrt(3);
    final bool isSteerable = _purity > 0.5;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text('Quantum Steering & LHS Breakdown'),
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Live Analytics Top Banner
          _buildMetricsBanner(cavalcantiValue, isSteerable),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: AdvancedBlochPainter(
                rotationAngle: _rotationAngle,
                purity: _purity,
                aliceTheta: _aliceTheta,
                alicePhi: _alicePhi,
                isSteerable: isSteerable,
              ),
            ),
          ),
          _buildControlDashboard(isSteerable),
        ],
      ),
    );
  }

  Widget _buildMetricsBanner(double cavalcantiValue, bool isSteerable) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1F242C),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                'CAVALCANTI METRIC (S)',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              Text(
                cavalcantiValue.toStringAsFixed(3),
                style: TextStyle(
                  color: isSteerable ? Colors.greenAccent : Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                isSteerable ? 'S > 1 : LHS Violated' : 'S ≤ 1 : LHS Valid',
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
            ],
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          Column(
            children: [
              const Text(
                'REGIME STATUS',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              Text(
                isSteerable ? 'QUANTUM STEERABLE' : 'CLASSICAL LHS MODEL',
                style: TextStyle(
                  color: isSteerable ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isSteerable
                    ? 'Non-local correlations active'
                    : 'Simulable by Local Hidden States',
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlDashboard(bool isSteerable) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: const Color(0xFF161B22),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Werner State Purity (p)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'p = ${_purity.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            Slider(
              value: _purity,
              min: 0.0,
              max: 1.0,
              activeColor: isSteerable ? Colors.greenAccent : Colors.redAccent,
              inactiveColor: Colors.white10,
              onChanged: (val) => setState(() => _purity = val),
            ),
            const SizedBox(height: 5),
            const Text(
              'Alice Measurement Polar Vector (Theta)',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Slider(
              value: _aliceTheta,
              min: 0.0,
              max: math.pi,
              activeColor: Colors.deepPurpleAccent,
              onChanged: (val) => setState(() => _aliceTheta = val),
            ),
            const SizedBox(height: 5),
            const Text(
              'Alice Measurement Azimuthal Vector (Phi)',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Slider(
              value: _alicePhi,
              min: 0.0,
              max: 2 * math.pi,
              activeColor: Colors.indigoAccent,
              onChanged: (val) => setState(() => _alicePhi = val),
            ),
          ],
        ),
      ),
    );
  }
}

class AdvancedBlochPainter extends CustomPainter {
  final double rotationAngle;
  final double purity;
  final double aliceTheta;
  final double alicePhi;
  final bool isSteerable;

  AdvancedBlochPainter({
    required this.rotationAngle,
    required this.purity,
    required this.aliceTheta,
    required this.alicePhi,
    required this.isSteerable,
  });

  // Orthographic 3D projection matrix helper
  Offset project(double x, double y, double z, Size size) {
    double cx = size.width / 2;
    double cy = size.height / 2;

    // Y-Axis continuous matrix spin
    double cosRY = math.cos(rotationAngle);
    double sinRY = math.sin(rotationAngle);
    double xRot = x * cosRY - z * sinRY;
    double zRot = x * sinRY + z * cosRY;

    // Fixed X-Axis structural tilt for perspective
    double cosRX = math.cos(0.35);
    double sinRX = math.sin(0.35);
    double yRot = y * cosRX - zRot * sinRX;

    double scale = 140.0;
    return Offset(cx + xRot * scale, cy - yRot * scale);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerSpherePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke;

    // 1. Draw Absolute Pure Bloch Limit Boundary
    canvas.drawCircle(center, 140.0, outerSpherePaint);

    // 2. Draw Quantum Coordinate Reference Framing
    final axisPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;
    canvas.drawLine(
      project(-1.1, 0, 0, size),
      project(1.1, 0, 0, size),
      axisPaint,
    );
    canvas.drawLine(
      project(0, -1.1, 0, size),
      project(0, 1.1, 0, size),
      axisPaint,
    );
    canvas.drawLine(
      project(0, 0, -1.1, size),
      project(0, 0, 1.1, size),
      axisPaint,
    );

    _drawText(canvas, project(0, 0, 1.15, size), '+Z', Colors.white38);
    _drawText(canvas, project(1.15, 0, 0, size), '+X', Colors.white38);

    // 3. Render Shrunken Werner State Steering Ellipsoid Envelope
    // Under all possible measurements, Bob's states form an ellipsoid scaled exactly by 'purity'
    final steeringEllipsoidPaint = Paint()
      ..color = isSteerable
          ? Colors.greenAccent.withOpacity(0.15)
          : Colors.redAccent.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    final ellipsoidWireframe = Paint()
      ..color = isSteerable
          ? Colors.greenAccent.withOpacity(0.4)
          : Colors.redAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Ellipsoid Equator Profile Trace Loop (Dynamic Ellipsoid Shrinking)
    final Path ellipsoidEquator = Path();
    for (int i = 0; i <= 360; i += 8) {
      double rad = i * math.pi / 180;
      // Coordinates mapped explicitly within the Werner scaling factor 'purity'
      Offset pt = project(
        math.cos(rad) * purity,
        0,
        math.sin(rad) * purity,
        size,
      );
      if (i == 0)
        ellipsoidEquator.moveTo(pt.dx, pt.dy);
      else
        ellipsoidEquator.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(ellipsoidEquator, steeringEllipsoidPaint);
    canvas.drawPath(ellipsoidEquator, ellipsoidWireframe);

    // Ellipsoid Longitudinal Profile Trace Loop
    final Path ellipsoidLong = Path();
    for (int i = 0; i <= 360; i += 8) {
      double rad = i * math.pi / 180;
      Offset pt = project(
        0,
        math.cos(rad) * purity,
        math.sin(rad) * purity,
        size,
      );
      if (i == 0)
        ellipsoidLong.moveTo(pt.dx, pt.dy);
      else
        ellipsoidLong.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(ellipsoidLong, ellipsoidWireframe);

    // 4. Project Single Live Measurement Vector
    double ax = math.sin(aliceTheta) * math.cos(alicePhi);
    double ay = math.sin(aliceTheta) * math.sin(alicePhi);
    double az = math.cos(aliceTheta);

    // Bob's mixed state outcome shrinks directly inward by factor 'purity'
    double bx = -ax * purity;
    double by = -ay * purity;
    double bz = -az * purity;

    Offset alicePt = project(ax, ay, az, size);
    Offset bobPt = project(bx, by, bz, size);

    // Draw Vector Paths
    canvas.drawLine(
      center,
      alicePt,
      Paint()
        ..color = Colors.deepPurpleAccent
        ..strokeWidth = 2,
    );
    canvas.drawCircle(alicePt, 4.0, Paint()..color = Colors.deepPurpleAccent);
    _drawText(
      canvas,
      alicePt + const Offset(5, -5),
      'Alice Unit ⟨A⟩',
      Colors.deepPurpleAccent,
    );

    canvas.drawLine(
      center,
      bobPt,
      Paint()
        ..color = isSteerable ? Colors.greenAccent : Colors.orangeAccent
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      bobPt,
      5.0,
      Paint()..color = isSteerable ? Colors.greenAccent : Colors.orangeAccent,
    );
    _drawText(
      canvas,
      bobPt + const Offset(5, 5),
      'Bob State ⟨B⟩',
      isSteerable ? Colors.greenAccent : Colors.orangeAccent,
    );

    // EPR connection line showing interaction
    canvas.drawLine(
      alicePt,
      bobPt,
      Paint()
        ..color = Colors.white10
        ..strokeWidth = 1,
    );
  }

  void _drawText(Canvas canvas, Offset offset, String text, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant AdvancedBlochPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.purity != purity ||
        oldDelegate.aliceTheta != aliceTheta ||
        oldDelegate.alicePhi != alicePhi;
  }
}

//### Visual & Architecture Improvements Breakdown
//* **Dynamic Ellipsoid Shrinking**: Implemented two separate 3D geometric loop traces rendering cross-sectional profiles of Bob's collapsed density configurations. This visually demonstrates the state shifting from a pure steerable sphere to a compressed, unsteerable dot at the center of coordinates.
//* **Dynamic Cavalcanti Evaluation**: Real-time evaluation of the \(S = p\sqrt{3}\) parameter occurs within the widget tree, updating the application's top display panel on every tick framework update.
//* **LHS Phase Visualizer Indicator**: Leverages the mathematical boundary condition \(p=0.5\). The application switches color matrix accents across both sliders and custom painting spaces instantly when passing the local realistic boundary line.
