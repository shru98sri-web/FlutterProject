import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ComptonAnimationPage(),
    );
  }
}

class ComptonAnimationPage extends StatefulWidget {
  const ComptonAnimationPage({super.key});

  @override
  State<ComptonAnimationPage> createState() => _ComptonAnimationPageState();
}

class _ComptonAnimationPageState extends State<ComptonAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compton Effect Animation'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The Animation Canvas
            Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.grey.shade800, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ComptonPainter(progress: _controller.value),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _controller.forward(from: 0.0),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  onPressed: () => _controller.reset(),
                  icon: const Icon(Icons.replay),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ComptonPainter extends CustomPainter {
  final double progress;
  ComptonPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Physics constants/angles for display
    const double photonTheta = -math.pi / 6; // Scattered photon angle (-30 deg)
    const double electronPhi = math.pi / 4;   // Recoil electron angle (45 deg)

    // Paint Definitions
    final electronPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final photonPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final axisPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw reference axes
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axisPaint);

    // Collision timeline segments (0.0 to 1.0)
    // 0.0 -> 0.4: Incoming photon
    // 0.4: Impact point
    // 0.4 -> 1.0: Scattering phase

    if (progress <= 0.4) {
      // 1. PHASE 1: Incoming Photon
      double incomingProgress = progress / 0.4; // normalized 0 to 1
      double currentX = incomingProgress * center.dx;

      // Draw stationary target electron
      canvas.drawCircle(center, 10, electronPaint);

      // Draw incoming short-wavelength photon (high frequency)
      Path photonPath = _generateWavePath(
        startX: 0,
        endX: currentX,
        centerY: center.dy,
        amplitude: 12,
        wavelength: 15,
      );
      canvas.drawPath(photonPath, photonPaint);

    } else {
      // 2. PHASE 2: Post-Collision Scattering
      double outboundProgress = (progress - 0.4) / 0.6; // normalized 0 to 1
      double travelDistance = outboundProgress * (size.width / 2);

      // --- RECOIL ELECTRON ---
      double eX = center.dx + travelDistance * math.cos(electronPhi);
      double eY = center.dy + travelDistance * math.sin(electronPhi);
      canvas.drawCircle(Offset(eX, eY), 10, electronPaint);

      // --- SCATTERED PHOTON ---
      // The scattered photon path moves along the photonTheta angle
      Path scatteredPhotonPath = Path();

      // Generate the wave layout linearly, then rotate/translate it
      int samplePoints = (travelDistance).toInt();
      bool firstPoint = true;

      // Compton shift: Longer wavelength (28) and lower amplitude (8)
      const double scatterWavelength = 28.0;
      const double scatterAmplitude = 8.0;

      for (int i = 0; i <= samplePoints; i++) {
        // Calculate point in local wave coordinates
        double localX = i.toDouble();
        double localY = scatterAmplitude * math.sin((localX * 2 * math.pi) / scatterWavelength);

        // Rotate by photonTheta and translate to center impact origin
        double rotatedX = center.dx + (localX * math.cos(photonTheta) - localY * math.sin(photonTheta));
        double rotatedY = center.dy + (localX * math.sin(photonTheta) + localY * math.cos(photonTheta));

        if (firstPoint) {
          scatteredPhotonPath.moveTo(rotatedX, rotatedY);
          firstPoint = false;
        } else {
          scatteredPhotonPath.lineTo(rotatedX, rotatedY);
        }
      }
      canvas.drawPath(scatteredPhotonPath, photonPaint);
    }
  }

  // Helper to generate a straight horizontal sine wave path
  Path _generateWavePath({
    required double startX,
    required double endX,
    required double centerY,
    required double amplitude,
    required double wavelength,
  }) {
    Path path = Path();
    if (startX >= endX) return path;

    path.moveTo(startX, centerY);
    for (double x = startX; x <= endX; x += 1.0) {
      double y = centerY + amplitude * math.sin((x * 2 * math.pi) / wavelength);
      path.lineTo(x, y);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant ComptonPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
