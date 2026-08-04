import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: QSwitchLaserSimulation()));

class QSwitchLaserSimulation extends StatefulWidget {
  const QSwitchLaserSimulation({Key? key}) : super(key: key);

  @override
  _QSwitchLaserSimulationState createState() => _QSwitchLaserSimulationState();
}

class _QSwitchLaserSimulationState extends State<QSwitchLaserSimulation> {
  bool isPumping = false;
  bool isHighQ = false;

  double populationInversion = 0.0;
  double laserOutputIntensity = 0.0;
  double internalCavityIntensity =
      0.0; // Track energy bouncing inside the mirrors

  Timer? _simulationTimer;

  @override
  void initState() {
    super.initState();
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 16), (
      timer,
    ) {
      setState(() {
        _updatePhysics();
      });
    });
  }

  void _updatePhysics() {
    // 1. Energy Pumping Phase
    if (isPumping) {
      if (populationInversion < 100.0) populationInversion += 1.0;
    } else {
      if (populationInversion > 0) populationInversion -= 0.3;
    }

    // 2. Intracavity Ray Dynamics
    if (isHighQ) {
      if (populationInversion > 15.0) {
        // High Q allows light to complete roundtrips and extract stored energy
        double stimulatedEmission = populationInversion * 0.35;
        internalCavityIntensity += stimulatedEmission;
        populationInversion -= stimulatedEmission;

        // Output beam leaks out through the partially reflective mirror
        laserOutputIntensity = internalCavityIntensity * 0.8;
      } else {
        // Cavity runs out of stored energy
        internalCavityIntensity *= 0.5;
        laserOutputIntensity *= 0.5;
      }
    } else {
      // Low Q: Shutter blocks the optical path.
      // Only weak spontaneous emissions survive, unable to make full cavity roundtrips.
      if (populationInversion > 10.0) {
        internalCavityIntensity = populationInversion * 0.05;
      } else {
        internalCavityIntensity *= 0.4;
      }
      laserOutputIntensity *= 0.3; // No external beam can leak out
    }

    // Cleanup bounds
    populationInversion = populationInversion.clamp(0.0, 100.0);
    if (internalCavityIntensity < 0.1) internalCavityIntensity = 0.0;
    if (laserOutputIntensity < 0.1) laserOutputIntensity = 0.0;
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Q-Switch Laser (Intracavity Ray)'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricCard(
                  "Stored Energy",
                  "${populationInversion.toStringAsFixed(1)}%",
                  Colors.amber,
                ),
                _buildMetricCard(
                  "Cavity Core Glow",
                  "${internalCavityIntensity.toStringAsFixed(0)} kW",
                  Colors.pinkAccent,
                ),
                _buildMetricCard(
                  "External Giant Pulse",
                  "${laserOutputIntensity.toStringAsFixed(0)} MW",
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 30),

            Expanded(
              child: CustomPaint(
                painter: LaserCavityPainter(
                  populationInversion: populationInversion,
                  internalIntensity: internalCavityIntensity,
                  laserOutput: laserOutputIntensity,
                  isHighQ: isHighQ,
                ),
                child: Container(),
              ),
            ),

            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "OPTICAL CONTROL SYSTEM",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPumping
                                ? Colors.amber.shade700
                                : Colors.grey.shade800,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () =>
                              setState(() => isPumping = !isPumping),
                          icon: Icon(isPumping ? Icons.bolt : Icons.power_off),
                          label: Text(isPumping ? "PUMP ACTIVE" : "PUMP IDLE"),
                        ),

                        GestureDetector(
                          onTapDown: (_) => setState(() => isHighQ = true),
                          onTapUp: (_) => setState(() => isHighQ = false),
                          onTapCancel: () => setState(() => isHighQ = false),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isHighQ
                                  ? Colors.green.shade700
                                  : Colors.red.shade900,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {},
                            icon: Icon(isHighQ ? Icons.lock_open : Icons.lock),
                            label: Text(
                              isHighQ ? "HIGH Q (OPEN)" : "LOW Q (BLOCKED)",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class LaserCavityPainter extends CustomPainter {
  final double populationInversion;
  final double internalIntensity;
  final double laserOutput;
  final bool isHighQ;

  LaserCavityPainter({
    required this.populationInversion,
    required this.internalIntensity,
    required this.laserOutput,
    required this.isHighQ,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double midY = size.height / 2;
    final double mirrorRearX = 25.0;
    final double shutterX = size.width * 0.55;
    final double mirrorOutputX = size.width * 0.75;

    // 1. Draw Intracavity Laser Ray (Internal beam path)
    if (internalIntensity > 0) {
      // Glow Aura Ray
      final Paint rayAuraPaint = Paint()
        ..color = Colors.redAccent.withOpacity(
          (internalIntensity / 120).clamp(0.1, 0.6),
        )
        ..strokeWidth = (internalIntensity / 6).clamp(3.0, 18.0)
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

      // Core Hot Ray
      final Paint rayCorePaint = Paint()
        ..color = Colors.white.withOpacity(
          (internalIntensity / 100).clamp(0.3, 1.0),
        )
        ..strokeWidth = (internalIntensity / 20).clamp(1.0, 4.0)
        ..style = PaintingStyle.stroke;

      if (isHighQ) {
        // Complete path: Rear Mirror -> Crystal -> Shutter Space -> Output Mirror
        canvas.drawLine(
          Offset(mirrorRearX, midY),
          Offset(mirrorOutputX, midY),
          rayAuraPaint,
        );
        canvas.drawLine(
          Offset(mirrorRearX, midY),
          Offset(mirrorOutputX, midY),
          rayCorePaint,
        );
      } else {
        // Blocked path: Ray hits shutter and scatters (Cannot pass to output mirror)
        canvas.drawLine(
          Offset(mirrorRearX, midY),
          Offset(shutterX, midY),
          rayAuraPaint,
        );
        canvas.drawLine(
          Offset(mirrorRearX, midY),
          Offset(shutterX, midY),
          rayCorePaint,
        );
      }
    }

    // 2. Draw Rear Mirror
    final Paint mirrorPaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(mirrorRearX - 15, midY - 40, 15, 80),
        const Radius.circular(4),
      ),
      mirrorPaint,
    );

    // 3. Draw Crystal Gain Medium
    final Paint crystalPaint = Paint()
      ..color = Colors.purple.withOpacity(
        0.2 + (populationInversion / 100 * 0.6),
      )
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(60, midY - 25, size.width * 0.35, 50),
      crystalPaint,
    );

    final Paint borderPaint = Paint()
      ..color = Colors.purple.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(
      Rect.fromLTWH(60, midY - 25, size.width * 0.35, 50),
      borderPaint,
    );

    // 4. Draw Q-Switch Optical Shutter
    final Paint shutterPaint = Paint()
      ..color = isHighQ ? Colors.green : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    if (isHighQ) {
      canvas.drawLine(
        Offset(shutterX, midY - 50),
        Offset(shutterX, midY - 20),
        shutterPaint,
      ); // Lifted
    } else {
      canvas.drawLine(
        Offset(shutterX, midY - 25),
        Offset(shutterX, midY + 25),
        shutterPaint,
      ); // Blocking
    }

    // 5. Draw Output Coupler Mirror
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(mirrorOutputX, midY - 40, 15, 80),
        const Radius.circular(4),
      ),
      mirrorPaint,
    );

    // 6. Draw External Giant Laser Beam Burst
    if (laserOutput > 0) {
      final Paint externalBeamPaint = Paint()
        ..color = Colors.red.withOpacity((laserOutput / 120).clamp(0.3, 1.0))
        ..strokeWidth = (laserOutput / 6).clamp(4.0, 24.0)
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      final Paint externalCorePaint = Paint()
        ..color = Colors.white
        ..strokeWidth = (laserOutput / 18).clamp(1.5, 5.0)
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(mirrorOutputX + 15, midY),
        Offset(size.width, midY),
        externalBeamPaint,
      );
      canvas.drawLine(
        Offset(mirrorOutputX + 15, midY),
        Offset(size.width, midY),
        externalCorePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LaserCavityPainter oldDelegate) {
    return oldDelegate.populationInversion != populationInversion ||
        oldDelegate.internalIntensity != internalIntensity ||
        oldDelegate.laserOutput != laserOutput ||
        oldDelegate.isHighQ != isHighQ;
  }
}
