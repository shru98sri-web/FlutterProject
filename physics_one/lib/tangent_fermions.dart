import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const TangentFermionApp());

class TangentFermionApp extends StatelessWidget {
  const TangentFermionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tangent Fermions Sim',
      theme: ThemeData.dark(),
      home: const FermionLatticeVisualizer(),
    );
  }
}

class FermionLatticeVisualizer extends StatefulWidget {
  const FermionLatticeVisualizer({Key? key}) : super(key: key);

  @override
  State<FermionLatticeVisualizer> createState() =>
      _FermionLatticeVisualizerState();
}

class _FermionLatticeVisualizerState extends State<FermionLatticeVisualizer> {
  double currentKy = 0.0; // Slice value for ky momentum

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tangent Fermions Lattice Simulation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              color: Colors.black45,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Dispersion: tan²(ε/2) = tan²(kx/2) + tan²(ky/2)\n'
                  'Unlike standard sine schemes, the tangent dispersion maps the '
                  'spurious edge doublers to infinite Cayley energy, isolating a single Dirac cone.',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
            ),
            //https://nationalmaglab.org/media/jr4jest2/jan2025-dc-field-semi-dirac-fermions-item.jpg'
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: CustomPaint(
                    painter: TangentDispersionPainter(ky: currentKy),
                    child: Container(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Momentum Slice (aky): ${currentKy.toStringAsFixed(2)} π',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: currentKy,
              min: -0.95, // avoid exact boundaries where tangent asymptotes
              max: 0.95,
              divisions: 40,
              label: "${currentKy.toStringAsFixed(2)}π",
              onChanged: (value) {
                setState(() {
                  currentKy = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TangentDispersionPainter extends CustomPainter {
  final double ky; // Value as a fraction of pi (-1 to 1)

  TangentDispersionPainter({required this.ky});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scaleX = size.width / 2.5;
    final scaleY = size.height / 2.5;

    // Draw coordinate axes
    final axisPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      axisPaint,
    );

    final upperBandPath = Path();
    final lowerBandPath = Path();
    bool firstPoint = true;

    final double kyRad = ky * math.pi;
    final double tanKy2 = math.tan(kyRad / 2.0);
    final double tanKy2Sq = tanKy2 * tanKy2;

    // Evaluate cross-section across kx space from -pi to +pi
    for (int i = 0; i <= 200; i++) {
      double pct = (i / 200.0) * 2.0 - 1.0; // -1.0 to 1.0
      double kxRad = pct * math.pi * 0.95; // bounded slightly below asymptote

      double tanKx2 = math.tan(kxRad / 2.0);
      double tanE2Sq = (tanKx2 * tanKx2) + tanKy2Sq;
      double tanE2 = math.sqrt(tanE2Sq);

      // Compute energy via inverse Cayley transform: ε = 2 * atan(tan(ε/2))
      double energyUpper = 2.0 * math.atan(tanE2);
      double energyLower = -energyUpper;

      // Map to screen canvas spaces
      double screenX = center.dx + pct * scaleX;
      double screenYUpper = center.dy - (energyUpper / math.pi) * scaleY;
      double screenYLower = center.dy - (energyLower / math.pi) * scaleY;

      if (firstPoint) {
        upperBandPath.moveTo(screenX, screenYUpper);
        lowerBandPath.moveTo(screenX, screenYLower);
        firstPoint = false;
      } else {
        upperBandPath.lineTo(screenX, screenYUpper);
        lowerBandPath.lineTo(screenX, screenYLower);
      }
    }

    // Paint configuration matching standard band diagrams
    final upperPaint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final lowerPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(upperBandPath, upperPaint);
    canvas.drawPath(lowerBandPath, lowerPaint);

    // Label markings
    const textStyle = TextStyle(color: Colors.white70, fontSize: 12);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // X-Axis Title
    textPainter.text = const TextSpan(text: 'ak_x', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 35, center.dy + 5));

    // Y-Axis Title
    textPainter.text = const TextSpan(text: 'ε δt', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + 8, 10));
  }

  @override
  bool shouldRepaint(covariant TangentDispersionPainter oldDelegate) {
    return oldDelegate.ky != ky;
  }
}
