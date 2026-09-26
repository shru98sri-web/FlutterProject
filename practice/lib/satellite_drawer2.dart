import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(ScientificDiagramApp());
}

class ScientificDiagramApp extends StatelessWidget {
  const ScientificDiagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: BlueprintViewerScreen(),
    );
  }
}

class BlueprintViewerScreen extends StatelessWidget {
  const BlueprintViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0A1128,
      ), // Deep technical navy blueprint background
      appBar: AppBar(
        backgroundColor: const Color(0xFF101F42),
        title: const Text(
          'ORBITAL STATION BLUEPRINT V1.0',
          style: TextStyle(
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 16,
            color: Color(0xFF00E5FF),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF00E5FF)),
            onPressed: () {}, // Reset view hook if needed
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Interactive Technical Canvas Layer
          Positioned.fill(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(500),
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Container(
                  width: 900,
                  height: 800,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF00E5FF).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: CustomPaint(
                    painter: ScientificBlueprintPainter(),
                    child: Container(),
                  ),
                ),
              ),
            ),
          ),

          // 2. HUD Overlay Controls for Scientific Realism
          Positioned(
            left: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF101F42).withOpacity(0.85),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFF00E5FF).withOpacity(0.4),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "SCALE: 1:2500",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: Color(0xFF00E5FF),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "SYSTEM: RADIATOR & DISH RE-ENTRY FLAPS",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "NAV: PINCH TO ZOOM / DRAG TO PAN",
                    style: TextStyle(
                      fontFamily: 'Courier',
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

class ScientificBlueprintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Technical Vector Paints
    final blueprintGridPaint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.07)
      ..strokeWidth = 0.8;

    final primaryLinePaint = Paint()
      ..color =
          const Color(0xFF00E5FF) // Crisp neon Cyan vectors
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    final hiddenFillPaint = Paint()
      ..color =
          const Color(0xFF0A1128) // Opaque matching the dark sky background
      ..style = PaintingStyle.fill;

    // --- STEP 1: BACKGROUND GRID PATTERN ---
    const double gridSize = 40.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), blueprintGridPaint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), blueprintGridPaint);
    }

    // --- STEP 2: LEFT DIAGRAM VARIANT ---
    canvas.save();
    canvas.translate(size.width * 0.15, size.height * 0.22);
    _drawLeftStructure(canvas, primaryLinePaint, hiddenFillPaint);
    canvas.restore();

    // --- STEP 3: MAIN EXPANDED RIGHT ASSEMBLY ---
    canvas.save();
    canvas.translate(size.width * 0.52, size.height * 0.48);
    _drawRightStructure(canvas, primaryLinePaint, hiddenFillPaint);
    canvas.restore();
  }

  void _drawLeftStructure(Canvas canvas, Paint paint, Paint fillPaint) {
    // Top protective cap
    final capPath = Path()
      ..moveTo(40, 20)
      ..lineTo(60, 20)
      ..lineTo(70, 45)
      ..lineTo(30, 45)
      ..close();
    canvas.drawPath(capPath, fillPaint);
    canvas.drawPath(capPath, paint);

    // Support pillars
    canvas.drawLine(const Offset(45, 45), const Offset(42, 100), paint);
    canvas.drawLine(const Offset(55, 45), const Offset(58, 100), paint);

    // Rigid structural module frame
    canvas.drawRect(const Rect.fromLTWH(35, 100, 30, 110), paint);
    for (double y = 100; y < 200; y += 22) {
      canvas.drawLine(Offset(35, y), Offset(65, y + 22), paint);
      canvas.drawLine(Offset(65, y), Offset(35, y + 22), paint);
    }

    // Concentric hinge array
    final center = const Offset(80, 160);
    canvas.drawCircle(center, 8, paint);
    canvas.drawLine(center, const Offset(120, 160), paint);

    // Folding radiator segment profiles
    for (int i = 0; i < 6; i++) {
      double angleStart = math.pi * 0.6 + (i * 0.18);
      double angleEnd = angleStart + 0.15;

      final segment = Path()
        ..moveTo(
          center.dx + 15 * math.cos(angleStart),
          center.dy + 15 * math.sin(angleStart),
        )
        ..lineTo(
          center.dx + 65 * math.cos(angleStart),
          center.dy + 65 * math.sin(angleStart),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: 65),
          angleStart,
          angleEnd - angleStart,
          false,
        )
        ..lineTo(
          center.dx + 15 * math.cos(angleEnd),
          center.dy + 15 * math.sin(angleEnd),
        )
        ..close();

      canvas.drawPath(segment, fillPaint);
      canvas.drawPath(segment, paint);
    }

    // Linear sensor arrays
    for (int i = -3; i <= 3; i++) {
      double angle = (i * 0.25);
      canvas.drawLine(
        Offset(
          center.dx + 10 * math.cos(angle),
          center.dy + 10 * math.sin(angle),
        ),
        Offset(
          center.dx + 55 * math.cos(angle),
          center.dy + 55 * math.sin(angle),
        ),
        paint,
      );
    }

    // Interface docking shoe base
    final base = Path()
      ..moveTo(5, 235)
      ..lineTo(95, 235)
      ..lineTo(85, 245)
      ..lineTo(15, 245)
      ..close();
    canvas.drawPath(base, fillPaint);
    canvas.drawPath(base, paint);
    canvas.drawRect(const Rect.fromLTWH(20, 230, 55, 5), paint);
  }

  void _drawRightStructure(Canvas canvas, Paint paint, Paint fillPaint) {
    // 1. Central Axle Hub & Calibration Rings
    canvas.drawOval(const Rect.fromLTWH(-35, -15, 8, 30), fillPaint);
    canvas.drawOval(const Rect.fromLTWH(-35, -15, 8, 30), paint);
    canvas.drawOval(const Rect.fromLTWH(-25, -28, 12, 56), fillPaint);
    canvas.drawOval(const Rect.fromLTWH(-25, -28, 12, 56), paint);
    canvas.drawLine(const Offset(-35, 0), const Offset(20, 0), paint);

    // 2. High Aspect Radiator Fin Spikes (Upper Group)
    final List<Offset> upperTops = [
      const Offset(5, -220),
      const Offset(22, -215),
      const Offset(38, -210),
      const Offset(52, -202),
    ];
    for (var top in upperTops) {
      final spike = Path()
        ..moveTo(-3, -25)
        ..lineTo(top.dx, top.dy)
        ..lineTo(top.dx + 4, top.dy + 5)
        ..lineTo(2, -22)
        ..close();
      canvas.drawPath(spike, paint);
      canvas.drawLine(const Offset(0, -22), top, paint);
    }

    // Lower Cooling Spikes Group
    final List<Offset> lowerTops = [
      const Offset(2, 230),
      const Offset(12, 225),
      const Offset(22, 218),
      const Offset(32, 210),
    ];
    for (var bottom in lowerTops) {
      canvas.drawLine(const Offset(0, 20), bottom, paint);
      canvas.drawLine(
        const Offset(3, 20),
        Offset(bottom.dx + 2, bottom.dy - 3),
        paint,
      );
    }

    // 3. Central Core Structural Lattice Boom
    final truss = Path()
      ..moveTo(10, -18)
      ..lineTo(150, -5)
      ..lineTo(145, 25)
      ..lineTo(5, 12)
      ..close();
    canvas.drawPath(truss, fillPaint);
    canvas.drawPath(truss, paint);

    // Internal cross-brace girder segments
    double startX = 10;
    double endX = 148;
    int divisions = 7;
    for (int i = 0; i <= divisions; i++) {
      double t = i / divisions;
      double xTop = startX + (endX - startX) * t;
      double yTop = -18 + (-5 - (-18)) * t;
      double xBot = 5 + (145 - 5) * t;
      double yBot = 12 + (25 - 12) * t;

      canvas.drawLine(Offset(xTop, yTop), Offset(xBot, yBot), paint);
      if (i < divisions) {
        double nextT = (i + 1) / divisions;
        double nextXBot = 5 + (145 - 5) * nextT;
        double nextYBot = 12 + (25 - 12) * nextT;
        canvas.drawLine(Offset(xTop, yTop), Offset(nextXBot, nextYBot), paint);
      }
    }

    // 4. Parabolic Telemetry Dish Module
    canvas.save();
    canvas.translate(200, 0);

    // Inter-modular adapter collar
    canvas.drawRect(const Rect.fromLTWH(-55, 0, 15, 10), paint);

    // Conical propulsion/stabilizer shroud
    final podPath = Path()
      ..moveTo(-30, 10)
      ..lineTo(30, 15)
      ..lineTo(10, 48)
      ..lineTo(-12, 45)
      ..close();
    canvas.drawPath(podPath, fillPaint);
    canvas.drawPath(podPath, paint);

    // High-gain parabolic elliptical dish
    canvas.save();
    canvas.rotate(-0.08);
    final dishBounds = Rect.fromCenter(
      center: Offset(0, -5),
      width: 120,
      height: 38,
    );
    canvas.drawOval(dishBounds, fillPaint);
    canvas.drawOval(
      dishBounds,
      paint,
    ); // Deep-space wave-guide matrix sub-reflectors
    for (int i = 0; i < 16; i++) {
      double angle = (i * math.pi / 8);
      canvas.drawLine(
        const Offset(0, -5),
        Offset(60 * math.cos(angle), -5 + 19 * math.sin(angle)),
        paint,
      );
    }
    canvas.restore(); // Antenna feed assembly struts
    canvas.drawLine(const Offset(-5, -15), const Offset(-15, -115), paint);
    canvas.drawLine(
      const Offset(5, -15),
      const Offset(-5, -115),
      paint,
    ); // Sub-reflector transceiver cone cap
    final topCone = Path()
      ..moveTo(-25, -115)
      ..lineTo(5, -122)
      ..lineTo(0, -142)
      ..lineTo(-22, -135)
      ..close();
    canvas.drawPath(topCone, fillPaint);
    canvas.drawPath(topCone, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
