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
      home: const SzInteractiveDashboard(),
    );
  }
}

class SzInteractiveDashboard extends StatefulWidget {
  const SzInteractiveDashboard({super.key});

  @override
  State<SzInteractiveDashboard> createState() => _SzInteractiveDashboardState();
}

class _SzInteractiveDashboardState extends State<SzInteractiveDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Interactive Parameters
  double _electronDensity = 25.0; // Corresponds to number of particles
  double _clusterTemperature =
      5.0; // Affects velocity/frequency of jitter and wavelength shift

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
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
        title: const Text('SZ Effect Simulator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Simulation Viewport
              Card(
                elevation: 4,
                color: Colors.grey.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Text(
                        "Inverse-Compton Scattering Simulation",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: SzDynamicPainter(
                                progress: _controller.value,
                                density: _electronDensity,
                                temperature: _clusterTemperature,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Control Panel Box
              Card(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade800, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tune, color: Colors.cyanAccent),
                          SizedBox(width: 8),
                          Text(
                            "Intracluster Medium (ICM) Controls",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, color: Colors.white24),

                      // Electron Density Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            r"Electron Density (\$n_e$):",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${_electronDensity.toInt()} particles",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _electronDensity,
                        min: 5.0,
                        max: 60.0,
                        divisions: 11,
                        activeColor: Colors.amber,
                        inactiveColor: Colors.grey.shade800,
                        onChanged: (val) =>
                            setState(() => _electronDensity = val),
                      ),
                      const SizedBox(height: 8),

                      // Temperature Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            r"Gas Temperature (\$T_e$):",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${_clusterTemperature.toStringAsFixed(1)} keV",
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _clusterTemperature,
                        min: 1.0,
                        max: 15.0,
                        divisions: 14,
                        activeColor: Colors.cyanAccent,
                        inactiveColor: Colors.grey.shade800,
                        onChanged: (val) =>
                            setState(() => _clusterTemperature = val),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SzDynamicPainter extends CustomPainter {
  final double progress;
  final double density;
  final double temperature;

  SzDynamicPainter({
    required this.progress,
    required this.density,
    required this.temperature,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double clusterRadius = math.min(size.width, size.height) * 0.32;

    // --- 1. DRAW HOT INTERGALACTIC PLASMA CLUSTER ---
    // The opacity scales softly based on density input to create visual depth
    final double alphaScale = (0.2 + (density / 60.0) * 0.3).clamp(0.0, 1.0);
    final clusterPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.orangeAccent.withOpacity(alphaScale),
          Colors.redAccent.withOpacity(alphaScale * 0.4),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: clusterRadius));
    canvas.drawCircle(center, clusterRadius, clusterPaint);

    // Draw cluster boundary guide
    final boundaryPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, clusterRadius, boundaryPaint);

    // --- 2. DRAW THERMAL ELECTRONS ---
    // Total count governed directly by density slider
    final int particleCount = density.toInt();
    final electronPaint = Paint()..color = Colors.cyanAccent.withOpacity(0.8);
    final math.Random random = math.Random(
      1337,
    ); // Fixed seed prevents layout re-shuffling

    for (int i = 0; i < particleCount; i++) {
      double angle = random.nextDouble() * 2 * math.pi;
      double radiusOffset = random.nextDouble() * (clusterRadius * 0.85);

      // Jitter speed escalates exponentially with higher temperature values
      double dynamicSpeed = 2.0 + (temperature * 1.5);
      double jitterX = 5 * math.sin(progress * 2 * math.pi * dynamicSpeed + i);
      double jitterY =
          5 * math.cos(progress * 2 * math.pi * (dynamicSpeed * 0.8) + i);

      Offset ePos = Offset(
        center.dx + radiusOffset * math.cos(angle) + jitterX,
        center.dy + radiusOffset * math.sin(angle) + jitterY,
      );
      canvas.drawCircle(ePos, 2.5, electronPaint);
    }

    // --- 3. DRAW CONTINUOUS PHOTON STREAMS ---
    final List<double> lanes = [center.dy - 50, center.dy, center.dy + 50];

    for (int l = 0; l < lanes.length; l++) {
      final double laneY = lanes[l];
      double photonX = progress * size.width;

      // Geometry intersection limits
      double dy = laneY - center.dy;
      double underRadical = (clusterRadius * clusterRadius) - (dy * dy);
      double entryX = 0;
      double exitX = size.width;

      if (underRadical > 0) {
        double halfChord = math.sqrt(underRadical);
        entryX = center.dx - halfChord;
        exitX = center.dx + halfChord;
      }

      Path wavePath = Path();
      bool firstPoint = true;

      // Baseline unshifted CMB specs
      const double preWavelength = 24.0;
      const double preAmplitude = 8.0;

      // Post-collision compressed configurations
      // Temperature & Density parameters interact to scale the level of energy boost
      double wavelengthCompressionFactor =
          4.0 + (temperature * 0.5) + (density * 0.1);
      double postWavelength = (preWavelength - wavelengthCompressionFactor)
          .clamp(6.0, 22.0);
      double postAmplitude = preAmplitude + (temperature * 0.3);

      final photonPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      for (double x = 0; x <= photonX; x += 2.0) {
        double currentWavelength = preWavelength;
        double currentAmplitude = preAmplitude;
        Color currentColor = Colors.redAccent;
        if (x > entryX && x <= exitX) {
          // Dynamic interpolation within collision landscape
          double factor = (x - entryX) / (exitX - entryX);
          currentWavelength =
              preWavelength - (factor * (preWavelength - postWavelength));
          currentAmplitude =
              preAmplitude + (factor * (postAmplitude - preAmplitude));
          currentColor = Color.lerp(
            Colors.redAccent,
            Colors.blueAccent,
            factor,
          )!;
        } else if (x > exitX) {
          // Scattered outcome state
          currentWavelength = postWavelength;
          currentAmplitude = postAmplitude;
          currentColor = Colors.blueAccent;
        }
        photonPaint.color = currentColor;
        // The dynamic wave speed increments based on global progress loop ticking
        double wavePhase =
            (x * 2 * math.pi) / currentWavelength - (progress * 45);
        double y = laneY + currentAmplitude * math.sin(wavePhase);
        if (firstPoint) {
          wavePath.moveTo(x, y);
          firstPoint = false;
        } else {
          wavePath.lineTo(x, y);
        }
      }
      canvas.drawPath(wavePath, photonPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SzDynamicPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.density != density ||
        oldDelegate.temperature != temperature;
  }
}
