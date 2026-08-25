import 'package:flutter/material.dart';

void main() {
  runApp(const LambdaDecayApp());
}

class LambdaDecayApp extends StatelessWidget {
  const LambdaDecayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lambda Decay Simulator',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
      ),
      home: const DecaySimulatorHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DecaySimulatorHome extends StatefulWidget {
  const DecaySimulatorHome({super.key});

  @override
  State<DecaySimulatorHome> createState() => _DecaySimulatorHomeState();
}

class _DecaySimulatorHomeState extends State<DecaySimulatorHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Simulation Variables
  bool _isConservedMode = true; // true = (b) Conserved, false = (a) Violated
  bool _protonSpinUp = true; // Track spin configuration of product
  double _particleProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addListener(() {
            setState(() {
              _particleProgress = _controller.value;
            });
          });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleConfiguration(bool mode) {
    setState(() {
      _isConservedMode = mode;
      // In (b) conserved mode, proton must be spin DOWN because Jz must balance.
      // In (a) violated mode, proton is spin UP, making final Jz = +1/2 + 0 = +1/2 (but orbital Lz is missing).
      _protonSpinUp = !mode;
      _controller.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Λ⁰ Particle Decay Simulator (Fig. 17-7)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Informational Summary Banner
            Card(
              color: _isConservedMode
                  ? Colors.green.shade900.withOpacity(0.3)
                  : Colors.red.shade900.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _isConservedMode
                          ? 'Configuration (b): CONSERVED'
                          : 'Configuration (a): FORBIDDEN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isConservedMode
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isConservedMode
                          ? 'Initial Jz (+1/2) = Proton Spin (-1/2) + Orbital Angular Momentum (+1) = +1/2.'
                          : 'Initial Jz (+1/2) ≠ Proton Spin (+1/2) + Orbital Angular Momentum (+1) = +3/2.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Mode Selector Toggle Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleConfiguration(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_isConservedMode
                        ? Colors.red.shade800
                        : Colors.grey.shade800,
                  ),
                  child: const Text('Possibility (a)'),
                ),
                ElevatedButton(
                  onPressed: () => _toggleConfiguration(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isConservedMode
                        ? Colors.green.shade800
                        : Colors.grey.shade800,
                  ),
                  child: const Text('Possibility (b)'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Visual Tracking Canvas Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: CustomPaint(
                  painter: DecayCanvasPainter(
                    progress: _particleProgress,
                    isConserved: _isConservedMode,
                    protonSpinUp: _protonSpinUp,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bottom Real-time Quantum State Readout Matrix
            Table(
              border: TableBorder.all(color: Colors.white24),
              children: [
                TableRow(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        'System Property',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        'Value',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(6),
                      child: Text('Initial Λ⁰ Spin Vector'),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        '↑ Up (+1/2 ℏ)',
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(6),
                      child: Text('Resulting Proton Spin'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        _protonSpinUp ? '↑ Up (+1/2 ℏ)' : '↓ Down (-1/2 ℏ)',
                        style: TextStyle(
                          color: _protonSpinUp
                              ? Colors.cyanAccent
                              : Colors.amberAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(6),
                      child: Text('Orbital Angular Momentum (Lz)'),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        '+1 ℏ (Right-handed Helix Ring)',
                        style: TextStyle(color: Colors.purpleAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DecayCanvasPainter extends CustomPainter {
  final double progress;
  final bool isConserved;
  final bool protonSpinUp;

  DecayCanvasPainter({
    required this.progress,
    required this.isConserved,
    required this.protonSpinUp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // FIX: Changed 'axis(axisPaint)' to 'axisPaint(axisPaint)' to match your method definition
    final axisPaintConfig = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(center.dx, 20),
      Offset(center.dx, size.height - 20),
      axisPaint(axisPaintConfig),
    );

    // Axis label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '+z axis (Flight Path)',
        style: TextStyle(color: Colors.white30, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + 10, 20));

    // Phase 1: Pre-Decay parent state
    if (progress < 0.4) {
      // Draw Lambda Baryon at center moving slightly
      final lambdaPos = Offset(center.dx, center.dy + (40 * (0.4 - progress)));
      canvas.drawCircle(lambdaPos, 14, Paint()..color = Colors.orange.shade700);
      _drawSpinArrow(canvas, lambdaPos, true, 'Λ⁰');
    }
    // Phase 2: Post-Decay daughter streams
    else {
      double t = (progress - 0.4) / 0.6; // normalized decay timeline sequence

      // Proton heading upwards along +z axis
      final protonY = center.dy - (t * (size.height / 2 - 40));
      final protonPos = Offset(center.dx, protonY);
      canvas.drawCircle(protonPos, 10, Paint()..color = Colors.cyan.shade600);
      _drawSpinArrow(canvas, protonPos, protonSpinUp, 'p⁺');

      // Negative Pion heading downwards along -z axis
      final pionY = center.dy + (t * (size.height / 2 - 40));
      final pionPos = Offset(center.dx, pionY);
      canvas.drawCircle(pionPos, 7, Paint()..color = Colors.purple.shade600);

      // Pion label
      _drawText(canvas, Offset(pionPos.dx + 14, pionPos.dy - 6), 'π⁻ (Spin 0)');

      // Visualizing Orbital Angular Momentum Ring (Lz = +1)
      final ringPaint = Paint()
        ..color = Colors.purpleAccent.withOpacity((1.0 - t).clamp(0.0, 0.6))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawOval(
        Rect.fromCenter(center: center, width: 80 * t, height: 30 * t),
        ringPaint,
      );
    }
  }

  void _drawSpinArrow(Canvas canvas, Offset origin, bool isUp, String label) {
    final arrowPaint = Paint()
      ..color = isUp ? Colors.greenAccent : Colors.redAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    double length = 24;
    double dy = isUp ? -length : length;
    Offset endPoint = Offset(origin.dx, origin.dy + dy);

    // Draw vector line arrow stems
    canvas.drawLine(origin, endPoint, arrowPaint);

    // Draw arrowhead pointer tips
    double tipSize = 5;
    if (isUp) {
      canvas.drawLine(
        endPoint,
        Offset(endPoint.dx - tipSize, endPoint.dy + tipSize),
        arrowPaint,
      );
      canvas.drawLine(
        endPoint,
        Offset(endPoint.dx + tipSize, endPoint.dy + tipSize),
        arrowPaint,
      );
    } else {
      canvas.drawLine(
        endPoint,
        Offset(endPoint.dx - tipSize, endPoint.dy - tipSize),
        arrowPaint,
      );
      canvas.drawLine(
        endPoint,
        Offset(endPoint.dx + tipSize, endPoint.dy - tipSize),
        arrowPaint,
      );
    }
    _drawText(
      canvas,
      Offset(origin.dx + 14, origin.dy - 6),
      '$label (${isUp ? "+½" : "-½"})',
    );
  }

  void _drawText(Canvas canvas, Offset position, String text) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, position);
  }

  Paint axisPaint(Paint p) => p..strokeWidth = 1;

  @override
  bool shouldRepaint(covariant DecayCanvasPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
