import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: WaterAnimationScreen()));

class WaterAnimationScreen extends StatefulWidget {
  const WaterAnimationScreen({super.key});

  @override
  State<WaterAnimationScreen> createState() => _WaterAnimationScreenState();
}

class _WaterAnimationScreenState extends State<WaterAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Controls the speed of the wave loop (4 seconds per full loop)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(); // Loops continuously
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Stack(
        children: [
          // Centered circular liquid progress indicator
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: WaterPainter(
                        animationValue: _controller.value,
                        waterLevel: 0.6, // Fill level (0.0 to 1.0)
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaterPainter extends CustomPainter {
  final double animationValue;
  final double waterLevel;

  WaterPainter({required this.animationValue, required this.waterLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Base Y coordinate determined by the requested water fill level
    final baseHeight = height * (1.0 - waterLevel);

    // 1. Paint configuration for the back wave
    final backPaint = Paint()
      ..color = Colors.blue.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // 2. Paint configuration for the front wave
    final frontPaint = Paint()
      ..color = Colors.blue[400]!
      ..style = PaintingStyle.fill;

    final backPath = Path();
    final frontPath = Path();

    backPath.moveTo(0, baseHeight);
    frontPath.moveTo(0, baseHeight);

    // Calculate wave positions horizontally across the canvas width
    for (double x = 0; x <= width; x++) {
      // Back wave formula
      final backY =
          baseHeight +
          math.sin((x / width * 2 * math.pi) + (animationValue * 2 * math.pi)) *
              10;
      backPath.lineTo(x, backY);

      // Front wave formula (shifted horizontally by Pi/2 for parallax depth)
      final frontY =
          baseHeight +
          math.sin(
                (x / width * 2 * math.pi) -
                    (animationValue * 2 * math.pi) +
                    (math.pi / 2),
              ) *
              12;
      frontPath.lineTo(x, frontY);
    }

    // Complete the path bounding box to fill the bottom area with color
    backPath.lineTo(width, height);
    backPath.lineTo(0, height);
    backPath.close();

    frontPath.lineTo(width, height);
    frontPath.lineTo(0, height);
    frontPath.close();

    // Draw both paths onto the screen canvas
    canvas.drawPath(backPath, backPaint);
    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(covariant WaterPainter oldDelegate) {
    // Repaint whenever the animation loops or properties update
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.waterLevel != waterLevel;
  }
}
