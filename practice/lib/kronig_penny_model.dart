import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const KronigPenneyApp());
}

class KronigPenneyApp extends StatelessWidget {
  const KronigPenneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kronig-Penney Simulator',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: const SimulationPage(),
    );
  }
}

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  // P represents the barrier strength (dimensionless parameter)
  double _barrierStrengthP = 3.0;
  // 'a' represents the width of the potential well/lattice spacing
  double _latticeSpacingA = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kronig-Penney Model Visualizer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Controls Panel
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Barrier Strength (P): ${_barrierStrengthP.toStringAsFixed(1)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _barrierStrengthP,
                      min: 0.1,
                      max: 20.0,
                      divisions: 199,
                      label: _barrierStrengthP.toStringAsFixed(1),
                      onChanged: (val) =>
                          setState(() => _barrierStrengthP = val),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lattice Spacing (a): ${_latticeSpacingA.toStringAsFixed(1)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _latticeSpacingA,
                      min: 0.5,
                      max: 5.0,
                      divisions: 45,
                      label: _latticeSpacingA.toStringAsFixed(1),
                      onChanged: (val) =>
                          setState(() => _latticeSpacingA = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // The Graph Display Canvas
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomPaint(
                    painter: KronigPenneyPainter(
                      P: _barrierStrengthP,
                      a: _latticeSpacingA,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Legend Informational Flags
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.greenAccent, 'Allowed Band (-1 to 1)'),
                const SizedBox(width: 20),
                _buildLegendItem(Colors.redAccent, 'Forbidden Band (Gap)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class KronigPenneyPainter extends CustomPainter {
  final double P;
  final double a;

  KronigPenneyPainter({required this.P, required this.a});

  @override
  void paint(Canvas canvas, Size size) {
    final double midY = size.height / 2;
    // scaleX maps screen pixels to the wave vector variable 'alpha'
    final double scaleX = size.width / 15.0;
    final double scaleY = size.height / 6.0;

    // 1. Draw Background Grid and Boundaries
    final Paint boundPaint = Paint()
      ..color = Colors.blueGrey.withAlpha(150)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, midY - scaleY),
      Offset(size.width, midY - scaleY),
      boundPaint,
    );
    canvas.drawLine(
      Offset(0, midY + scaleY),
      Offset(size.width, midY + scaleY),
      boundPaint,
    );
    canvas.drawLine(
      Offset(0, midY),
      Offset(size.width, midY),
      Paint()..color = Colors.white30,
    );

    // 2. Compute and color map the function path segments
    for (double i = 0; i < size.width; i++) {
      // Step 1: Map the screen pixel position to the wave vector 'alpha'
      double alpha1 = i / scaleX;
      double alpha2 = (i + 1) / scaleX;

      // Step 2: Incorporate the slider's lattice spacing 'a' dynamically
      double alphaA1 = alpha1 * a;
      double alphaA2 = alpha2 * a;

      // Avoid divide by zero exception if alpha*a is 0
      if (alphaA1 == 0) alphaA1 = 0.0001;
      if (alphaA2 == 0) alphaA2 = 0.0001;

      // Evaluate the LHS equation using the updated alpha*a values
      double yVal1 = P * (math.sin(alphaA1) / alphaA1) + math.cos(alphaA1);
      double yVal2 = P * (math.sin(alphaA2) / alphaA2) + math.cos(alphaA2);

      // Map mathematical coordinates to canvas space dimensions
      double screenY1 = midY - (yVal1 * scaleY);
      double screenY2 = midY - (yVal2 * scaleY);

      // Determine segment colors based on the band filter criteria (-1 <= y <= 1)
      bool isAllowed1 = yVal1.abs() <= 1.0;
      bool isAllowed2 = yVal2.abs() <= 1.0;

      final Paint linePaint = Paint()
        ..color = (isAllowed1 && isAllowed2)
            ? Colors.greenAccent
            : Colors.redAccent
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      // Render line segment safely
      if (screenY1.isFinite && screenY2.isFinite) {
        canvas.drawLine(
          Offset(i, screenY1),
          Offset(i + 1, screenY2),
          linePaint,
        );
      }
    }

    // 3. Render Axis Labels text metadata
    const textStyle = TextStyle(color: Colors.white70, fontSize: 12);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = const TextSpan(text: '+1 Boundary', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, midY - scaleY - 18));

    textPainter.text = const TextSpan(text: '-1 Boundary', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, midY + scaleY + 4));

    textPainter.text = const TextSpan(
      text: 'α (Wave Vector Energy Parameter) ➔',
      style: textStyle,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 240, midY + 10));
  }

  @override
  bool shouldRepaint(covariant KronigPenneyPainter oldDelegate) {
    return oldDelegate.P != P || oldDelegate.a != a;
  }
}
