import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
              aspectRatio:
                  1.1, // Aspect ratio matching the original image layout
              child: CustomPaint(
                painter: SatellitePainter(),
                child: Container(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SatellitePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // --- LEFT STRUCTURE (Folded / Alternative View) ---
    canvas.save();
    canvas.translate(size.width * 0.1, size.height * 0.2);
    _drawLeftStructure(canvas, paint, fillPaint);
    canvas.restore();

    // --- RIGHT STRUCTURE (Main Expanded Assembly) ---
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.48);
    _drawRightStructure(canvas, paint, fillPaint);
    canvas.restore();
  }

  void _drawLeftStructure(Canvas canvas, Paint paint, Paint fillPaint) {
    // Top Cone/Cap
    final capPath = Path()
      ..moveTo(40, 20)
      ..lineTo(60, 20)
      ..lineTo(70, 45)
      ..lineTo(30, 45)
      ..close();
    canvas.drawPath(capPath, fillPaint);
    canvas.drawPath(capPath, paint);

    // Support Rods for Cap
    canvas.drawLine(const Offset(45, 45), const Offset(42, 100), paint);
    canvas.drawLine(const Offset(55, 45), const Offset(58, 100), paint);

    // Vertical Truss Frame
    canvas.drawRect(const Rect.fromLTWH(35, 100, 30, 110), paint);
    for (double y = 100; y < 200; y += 22) {
      canvas.drawLine(Offset(35, y), Offset(65, y + 22), paint);
      canvas.drawLine(Offset(65, y), Offset(35, y + 22), paint);
    }

    // Folded Curved Panels / Wheel Structure
    final center = const Offset(80, 160);
    canvas.drawCircle(center, 8, paint);
    canvas.drawLine(center, const Offset(120, 160), paint);

    // Draw fan-like segments on the left
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

    // Right radiating spokes
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

    // Bottom Base platform
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
    // 1. Central Core Hub & Small Left Disc
    canvas.drawOval(const Rect.fromLTWH(-35, -15, 8, 30), fillPaint);
    canvas.drawOval(const Rect.fromLTWH(-35, -15, 8, 30), paint);
    canvas.drawOval(const Rect.fromLTWH(-25, -28, 12, 56), fillPaint);
    canvas.drawOval(const Rect.fromLTWH(-25, -28, 12, 56), paint);
    canvas.drawLine(const Offset(-35, 0), const Offset(20, 0), paint);

    // 2. Large Extended Thin Spikes / Radiator Fins
    // Upper vertical group (slightly fanned out)
    final List<Offset> upperTops = [
      const Offset(5, -200),
      const Offset(22, -195),
      const Offset(38, -190),
      const Offset(52, -182),
    ];
    for (var top in upperTops) {
      final spike = Path()
        ..moveTo(-3, -25)
        ..lineTo(top.dx, top.dy) // Using raw coordinates
        ..lineTo(top.dx + 4, top.dy + 5)
        ..lineTo(2, -22)
        ..close();
      canvas.drawPath(spike, paint);
      canvas.drawLine(const Offset(0, -22), top, paint);
    }

    // Lower vertical group (pointing down)
    final List<Offset> lowerTops = [
      const Offset(2, 210),
      const Offset(12, 205),
      const Offset(22, 198),
      const Offset(32, 190),
    ];
    for (var bottom in lowerTops) {
      canvas.drawLine(const Offset(0, 20), bottom, paint);
      canvas.drawLine(
        const Offset(3, 20),
        Offset(bottom.dx + 2, bottom.dy - 3),
        paint,
      );
    }

    // 3. Central Horizontal Lattice Truss Boom
    final truss = Path()
      ..moveTo(10, -18)
      ..lineTo(140, -5)
      ..lineTo(135, 25)
      ..lineTo(5, 12)
      ..close();
    canvas.drawPath(truss, fillPaint);
    canvas.drawPath(truss, paint);

    // Internal zigzag pattern inside the boom
    double startX = 10;
    double endX = 138;
    int divisions = 6;
    for (int i = 0; i <= divisions; i++) {
      double t = i / divisions;
      double xTop = startX + (endX - startX) * t;
      double yTop = -18 + (-5 - (-18)) * t;
      double xBot = 5 + (135 - 5) * t;
      double yBot = 12 + (25 - 12) * t;

      canvas.drawLine(Offset(xTop, yTop), Offset(xBot, yBot), paint);
      if (i < divisions) {
        double nextT = (i + 1) / divisions;
        double nextXBot = 5 + (135 - 5) * nextT;
        double nextYBot = 12 + (25 - 12) * nextT;
        canvas.drawLine(Offset(xTop, yTop), Offset(nextXBot, nextYBot), paint);
      }
    }

    // 4. Right Side Antenna/Dish Assembly
    canvas.save();
    canvas.translate(190, 0); // Position at the end of the truss boom

    // Connector link
    canvas.drawRect(const Rect.fromLTWH(-55, 0, 15, 10), paint);

    // Lower Conical Pod
    final podPath = Path()
      ..moveTo(-30, 10)
      ..lineTo(30, 15)
      ..lineTo(10, 48)
      ..lineTo(-12, 45)
      ..close();
    canvas.drawPath(podPath, fillPaint);
    canvas.drawPath(podPath, paint);

    // Large Elliptical Main Dish Panel
    canvas.save();
    canvas.rotate(-0.1); // Slight perspective tilt
    final dishBounds = Rect.fromCenter(
      center: Offset(0, -5),
      width: 110,
      height: 35,
    );
    canvas.drawOval(dishBounds, fillPaint);
    canvas.drawOval(dishBounds, paint);

    // Radiating segments inside the dish
    for (int i = 0; i < 16; i++) {
      double angle = (i * math.pi / 8);
      canvas.drawLine(
        const Offset(0, -5),
        Offset(55 * math.cos(angle), -5 + 17.5 * math.sin(angle)),
        paint,
      );
    }
    canvas.restore();

    // Secondary Top Feed Tower and Feed Horn Cap
    canvas.drawLine(const Offset(-5, -15), const Offset(-15, -105), paint);
    canvas.drawLine(const Offset(5, -15), const Offset(-5, -105), paint);

    // Top Feed Horn Small Cone
    final topCone = Path()
      ..moveTo(-25, -105)
      ..lineTo(5, -112)
      ..lineTo(0, -132)
      ..lineTo(-22, -125)
      ..close();
    canvas.drawPath(topCone, fillPaint);
    canvas.drawPath(topCone, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
