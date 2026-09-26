import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const Dirac3DApp());

class Dirac3DApp extends StatelessWidget {
  const Dirac3DApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Dirac Dispersion',
      theme: ThemeData.dark(),
      home: const Dirac3DVisualizer(),
    );
  }
}

class Dirac3DVisualizer extends StatefulWidget {
  const Dirac3DVisualizer({Key? key}) : super(key: key);

  @override
  State<Dirac3DVisualizer> createState() => _Dirac3DVisualizerState();
}

class _Dirac3DVisualizerState extends State<Dirac3DVisualizer> {
  double rotationAngle = 0.6; // Interactive viewing angle theta
  double tiltAngle = 0.5; // Interactive viewing height/phi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3D Tangent Dirac Cone Drawing')),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  rotationAngle += details.delta.dx * 0.01;
                  tiltAngle = (tiltAngle + details.delta.dy * 0.01).clamp(
                    0.1,
                    1.4,
                  );
                });
              },
              child: Container(
                color: Colors.black87,
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: Dirac3DFramePainter(
                    theta: rotationAngle,
                    phi: tiltAngle,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[900],
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Interactive Canvas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Drag across the dark screen to rotate the 3D grid and observe how the lattice tangent limits map toward infinity near the Brillouin zone boundaries (±π).',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Dirac3DFramePainter extends CustomPainter {
  final double theta; // Azimuthal angle
  final double phi; // Elevation angle

  Dirac3DFramePainter({required this.theta, required this.phi});

  // Projects a 3D coordinate (X, Y, Z) onto a 2D screen coordinate (Offset)
  Offset project(double x, double y, double z, Size size) {
    final double cosTheta = math.cos(theta);
    final double sinTheta = math.sin(theta);
    final double cosPhi = math.cos(phi);
    final double sinPhi = math.sin(phi);

    // Isometric/perspective transformation matrix step
    double xRot = x * cosTheta - y * sinTheta;
    double yRot = x * sinTheta + y * cosTheta;

    double xProj = xRot;
    double yProj = yRot * cosPhi - z * sinPhi;

    // Apply scale multiplier and shift to canvas origin center
    double scale = size.width / 4.5;
    return Offset(
      (size.width / 2) + xProj * scale,
      (size.height / 2) - yProj * scale,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const int gridResolution = 21; // Number of wireframe lines
    final List<List<Offset>> upperGrid = List.generate(
      gridResolution,
      (_) => List.filled(gridResolution, Offset.zero),
    );
    final List<List<Offset>> lowerGrid = List.generate(
      gridResolution,
      (_) => List.filled(gridResolution, Offset.zero),
    );

    // 1. Calculate and map the dispersion grid vertex elements
    for (int i = 0; i < gridResolution; i++) {
      double pctX = (i / (gridResolution - 1)) * 2.0 - 1.0; // -1 to 1
      double kx =
          pctX *
          math.pi *
          0.90; // Clip slightly below absolute boundary asymptote

      for (int j = 0; j < gridResolution; j++) {
        double pctY = (j / (gridResolution - 1)) * 2.0 - 1.0;
        double ky = pctY * math.pi * 0.90;

        // Tangent formulation dispersion evaluation
        double tanKx2 = math.tan(kx / 2.0);
        double tanKy2 = math.tan(ky / 2.0);
        double tanE2Sq = (tanKx2 * tanKx2) + tanKy2 * tanKy2;
        double energy = 2.0 * math.atan(math.sqrt(tanE2Sq));

        // Assign positions scaled to match visual bounds
        upperGrid[i][j] = project(pctX * 1.5, pctY * 1.5, energy * 0.8, size);
        lowerGrid[i][j] = project(pctX * 1.5, pctY * 1.5, -energy * 0.8, size);
      }
    }

    // 2. Render the wireframe mesh layers on canvas
    for (int i = 0; i < gridResolution; i++) {
      for (int j = 0; j < gridResolution; j++) {
        // Draw grid lines along X direction
        if (i < gridResolution - 1) {
          linePaint.color = Colors.deepOrangeAccent.withOpacity(0.4);
          canvas.drawLine(upperGrid[i][j], upperGrid[i + 1][j], linePaint);

          linePaint.color = Colors.tealAccent.withOpacity(0.4);
          canvas.drawLine(lowerGrid[i][j], lowerGrid[i + 1][j], linePaint);
        }
        // Draw grid lines along Y direction
        if (j < gridResolution - 1) {
          linePaint.color = Colors.deepOrangeAccent.withOpacity(0.4);
          canvas.drawLine(upperGrid[i][j], upperGrid[i][j + 1], linePaint);

          linePaint.color = Colors.tealAccent.withOpacity(0.4);
          canvas.drawLine(lowerGrid[i][j], lowerGrid[i][j + 1], linePaint);
        }
      }
    }

    // 3. Draw a bounding cage frame around the system limits
    final borderPaint = Paint()
      ..color = Colors.white30
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final corners = [
      project(-1.5, -1.5, -1.5, size),
      project(1.5, -1.5, -1.5, size),
      project(1.5, 1.5, -1.5, size),
      project(-1.5, 1.5, -1.5, size),
      project(-1.5, -1.5, 1.5, size),
      project(1.5, -1.5, 1.5, size),
      project(1.5, 1.5, 1.5, size),
      project(-1.5, 1.5, 1.5, size),
    ];

    // Base loop lines
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(corners[i], corners[(i + 1) % 4], borderPaint);
      canvas.drawLine(corners[i + 4], corners[((i + 1) % 4) + 4], borderPaint);
      canvas.drawLine(corners[i], corners[i + 4], borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant Dirac3DFramePainter oldDelegate) {
    return oldDelegate.theta != theta || oldDelegate.phi != phi;
  }
}
