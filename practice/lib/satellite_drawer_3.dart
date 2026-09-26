import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(TelescopeBlueprintApp());
}

class TelescopeBlueprintApp extends StatelessWidget {
  const TelescopeBlueprintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: BlueprintScreen(),
    );
  }
}

class BlueprintScreen extends StatelessWidget {
  const BlueprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F141D), // Scientific dark slate grey
      appBar: AppBar(
        backgroundColor: const Color(0xFF171E2D),
        title: const Text(
          'SPACE TELESCOPE OBSERVATORY SCHEMATIC',
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 14,
            color: Color(0xFF4AF2A1), // Precision tactical green
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Technical Grid Overlay
          const Positioned.fill(child: BlueprintGridBackground()),

          // 2. Interactive Zoom / Pan Vector Canvas
          Positioned.fill(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(400),
              minScale: 0.4,
              maxScale: 5.0,
              child: Center(
                child: SizedBox(
                  width: 900,
                  height: 500,
                  child: CustomPaint(painter: TelescopeSchematicPainter()),
                ),
              ),
            ),
          ),

          // 3. Technical Telemetry HUD
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF171E2D).withOpacity(0.85),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFF4AF2A1).withOpacity(0.3),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "REF: JWST-DEPLOYED-A2",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Color(0xFF4AF2A1),
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "SEGMENTS: 18 HEXAGONAL MIRRORS",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    "SHIELD: multi-layered sunshield",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white38,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlueprintGridBackground extends StatelessWidget {
  const BlueprintGridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: GridPainter());
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF4AF2A1).withOpacity(0.04)
      ..strokeWidth = 0.5;

    const double step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TelescopeSchematicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color =
          const Color(0xFF4AF2A1) // Blueprint line color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color =
          const Color(0xFF0F141D) // Masking background fill
      ..style = PaintingStyle.fill;

    // --- LEFT VIEW: STOWED FAIRING PROFILE ---
    canvas.save();
    canvas.translate(size.width * 0.05, size.height * 0.15);
    _drawStowedFairingView(canvas, linePaint, fillPaint);
    canvas.restore();

    // --- RIGHT VIEW: FULLY DEPLOYED OBSERVATORY ---
    canvas.save();
    canvas.translate(size.width * 0.55, size.height * 0.45);
    _drawDeployedObservatoryView(canvas, linePaint, fillPaint);
    canvas.restore();
  }

  void _drawStowedFairingView(Canvas canvas, Paint paint, Paint fillPaint) {
    // Fairing Rocket Nose Cone Envelope
    final fairingPath = Path()
      ..moveTo(10, 300)
      ..lineTo(10, 120)
      ..cubicTo(10, 60, 40, 10, 60, 10)
      ..cubicTo(80, 10, 110, 60, 110, 120)
      ..lineTo(110, 300)
      ..close();
    canvas.drawPath(fairingPath, paint);

    // Internal folded equipment modules
    canvas.drawRect(const Rect.fromLTWH(20, 140, 80, 110), fillPaint);
    canvas.drawRect(const Rect.fromLTWH(20, 140, 80, 110), paint);
    canvas.drawRect(const Rect.fromLTWH(25, 250, 70, 40), paint);

    // Folded deployment hinges and structural frames
    canvas.drawLine(const Offset(60, 10), const Offset(60, 140), paint);
    canvas.drawLine(const Offset(35, 45), const Offset(60, 140), paint);
    canvas.drawLine(const Offset(85, 45), const Offset(60, 140), paint);
    canvas.drawLine(const Offset(35, 45), const Offset(35, 140), paint);
    canvas.drawLine(const Offset(85, 45), const Offset(85, 140), paint);

    // Stowed side micro-ribs
    for (double y = 150; y < 240; y += 12) {
      canvas.drawLine(Offset(20, y), Offset(15, y + 4), paint);
      canvas.drawLine(Offset(100, y), Offset(105, y + 4), paint);
    }
  }

  void _drawDeployedObservatoryView(
    Canvas canvas,
    Paint paint,
    Paint fillPaint,
  ) {
    // 1. Multi-Layer Sunshield Platform (Perspective base)
    final shieldPath = Path()
      ..moveTo(-280, -120)
      ..lineTo(-140, -170)
      ..lineTo(240, 90)
      ..lineTo(380, 120)
      ..lineTo(110, 210)
      ..lineTo(-180, 50)
      ..close();

    canvas.drawPath(shieldPath, fillPaint);
    canvas.drawPath(shieldPath, paint);

    // Layered separator lines along the shield rim edge
    for (int i = 1; i <= 4; i++) {
      double offset = i * 8.0;
      canvas.drawLine(
        Offset(-180, 50 + offset),
        Offset(110, 210 + offset),
        paint,
      );
      canvas.drawLine(
        Offset(110, 210 + offset),
        Offset(380, 120 + offset),
        paint,
      );
      canvas.drawLine(
        Offset(-280, -120 + offset),
        Offset(-180, 50 + offset),
        paint,
      );

      // Vertical corner structural struts linking the layers
      if (i == 4) {
        canvas.drawLine(
          const Offset(-180, 50),
          const Offset(-180, 50 + 32),
          paint,
        );
        canvas.drawLine(
          const Offset(110, 210),
          const Offset(110, 210 + 32),
          paint,
        );
        canvas.drawLine(
          const Offset(380, 120),
          const Offset(380, 120 + 32),
          paint,
        );
      }
    }

    // 2. Central Core Circular Tower Support Hinge
    final centerTower = const Offset(100, 20);
    canvas.drawOval(
      Rect.fromCenter(center: centerTower, width: 70, height: 45),
      fillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: centerTower, width: 70, height: 45),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: centerTower, width: 50, height: 30),
      paint,
    );

    // Inner structural cylindrical springs/coils inside base ring
    for (double i = 0; i < 24; i += 4) {
      canvas.drawLine(Offset(85 + i, 28), Offset(90 + i, 10), paint);
    }

    // 3. Hexagonal Primary Mirror Array (Honeycomb Structure)
    canvas.save();
    canvas.translate(centerTower.dx + 20, centerTower.dy - 110);
    _drawHexagonalMirrorMatrix(canvas, paint, fillPaint);

    // Secondary Mirror Support Struts & Boom
    // Bottom mounting structures
    canvas.drawLine(const Offset(-40, 30), const Offset(140, -10), paint);
    canvas.drawLine(const Offset(10, -70), const Offset(140, -10), paint);
    canvas.drawLine(const Offset(-10, 60), const Offset(140, -10), paint);

    // High gain secondary transceiver tip housing
    canvas.drawCircle(const Offset(140, -10), 12, fillPaint);
    canvas.drawCircle(const Offset(140, -10), 12, paint);

    // Center focal path light cone cylinder projection
    final conePath = Path()
      ..moveTo(0, 0)
      ..lineTo(80, -5)
      ..lineTo(82, -18)
      ..lineTo(0, -15)
      ..close();
    canvas.drawPath(conePath, fillPaint);
    canvas.drawPath(conePath, paint);

    canvas.restore();
  }

  void _drawHexagonalMirrorMatrix(Canvas canvas, Paint paint, Paint fillPaint) {
    // Generate honeycomb cluster offsets manually to replicate a isometric matrix layout
    final List<Offset> mirrorCenters = [
      const Offset(0, 0),
      const Offset(0, -42),
      const Offset(0, 42),
      const Offset(34, -21),
      const Offset(34, 21),
      const Offset(-34, -21),
      const Offset(-34, 21),
      const Offset(34, -63),
      const Offset(34, 63),
      const Offset(-34, -63),
      const Offset(-34, 63),
      const Offset(68, 0),
      const Offset(-68, 0),
    ];

    for (var position in mirrorCenters) {
      // Skew hexagonal mirror path logic into perspective
      _drawSingleHexagon(canvas, position, 24, paint, fillPaint);
    }
  }

  void _drawSingleHexagon(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
    Paint fillPaint,
  ) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      double angle = (i * math.pi / 3) + (math.pi / 6);
      // Compress the Y axis coordinates slightly to generate realistic angled perspective
      double x = center.dx + radius * math.cos(angle) * 1.0;
      double y = center.dy + radius * math.sin(angle) * 0.85;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
