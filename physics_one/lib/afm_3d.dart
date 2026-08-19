import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: AFM3DViewerScreen()));

class AFM3DViewerScreen extends StatefulWidget {
  const AFM3DViewerScreen({super.key});

  @override
  State<AFM3DViewerScreen> createState() => _AFM3DViewerScreenState();
}

class _AFM3DViewerScreenState extends State<AFM3DViewerScreen> {
  final int gridSize =
      60; // Slightly lower density for crisp wireframe aesthetics
  late List<List<double>> heightMap;

  // Interactive view angles managed by local sliders
  double elevationAngle = 35.0; // Angle looking down at the surface (degrees)
  double azimuthAngle = 45.0; // Rotation angle around the Z axis (degrees)
  double heightScale = 40.0; // Z-axis exaggeration factor

  @override
  void initState() {
    super.initState();
    _generateMockAFMData();
  }

  // Quick mathematical mock of 3 nanoparticle peaks for testing
  void _generateMockAFMData() {
    heightMap = List.generate(gridSize, (y) {
      return List.generate(gridSize, (x) {
        double nx = x / gridSize;
        double ny = y / gridSize;
        double h = 0.0;

        // 3 Gaussian features
        h +=
            1.0 *
            math.exp(
              -((nx - 0.3) * (nx - 0.3) + (ny - 0.4) * (ny - 0.4)) / 0.015,
            );
        h +=
            1.3 *
            math.exp(
              -((nx - 0.65) * (nx - 0.65) + (ny - 0.6) * (ny - 0.6)) / 0.02,
            );
        h +=
            0.7 *
            math.exp(
              -((nx - 0.6) * (nx - 0.6) + (ny - 0.2) * (ny - 0.2)) / 0.01,
            );

        // Background baseline noise
        h += math.Random().nextDouble() * 0.04;
        return h.clamp(0.0, 1.5);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: const Text(
          'AFM 3D Surface Mesh',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(color: Colors.white10),
                child: CustomPaint(
                  painter: AFM3DPainter(
                    heightMap: heightMap,
                    gridSize: gridSize,
                    elevation: elevationAngle,
                    azimuth: azimuthAngle,
                    zScale: heightScale,
                  ),
                ),
              ),
            ),
          ),

          // Viewport Angle Controls
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Column(
              children: [
                _buildSlider(
                  "Rotation (Azimuth)",
                  azimuthAngle,
                  0,
                  360,
                  (v) => setState(() => azimuthAngle = v),
                ),
                _buildSlider(
                  "Pitch (Elevation)",
                  elevationAngle,
                  10,
                  80,
                  (v) => setState(() => elevationAngle = v),
                ),
                _buildSlider(
                  "Z-Exaggeration",
                  heightScale,
                  10,
                  100,
                  (v) => setState(() => heightScale = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double val,
    double min,
    double max,
    ValueChanged<double> cb,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
        Expanded(
          child: Slider(
            value: val,
            min: min,
            max: max,
            activeColor: Colors.orangeAccent,
            onChanged: cb,
          ),
        ),
      ],
    );
  }
}

// 3D Matrix Isometric Coordinate Projector
class AFM3DPainter extends CustomPainter {
  final List<List<double>> heightMap;
  final int gridSize;
  final double elevation; // Pitch
  final double azimuth; // Yaw
  final double zScale; // Height magnification

  AFM3DPainter({
    required this.heightMap,
    required this.gridSize,
    required this.elevation,
    required this.azimuth,
    required this.zScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (heightMap.isEmpty) return;

    final double radElev = elevation * math.pi / 180;
    final double radAzim = azimuth * math.pi / 180;

    final double cosElev = math.cos(radElev);
    final double sinElev = math.sin(radElev);
    final double cosAzim = math.cos(radAzim);
    final double sinAzim = math.sin(radAzim);

    // Dynamic grid spacing scaling factors
    final double sideLength = size.width * 0.6;
    final double spacing = sideLength / gridSize;
    final Offset center = Offset(
      size.width / 2,
      size.height / 2 + (sideLength * 0.15),
    );

    // Nested function helper to transform a 3D grid coordinate into 2D pixel space
    Offset project(int x, int y, double zValue) {
      // 1. Shift origin to the matrix center
      double cx = (x - gridSize / 2) * spacing;
      double cy = (y - gridSize / 2) * spacing;
      double cz =
          zValue *
          zScale; // Exaggerate nanoscale features into visible viewport pixels

      // 2. 3D Rotation Transform Matrix calculations (Yaw and Pitch combo)
      double rotX = cx * cosAzim - cy * sinAzim;
      double rotY = cx * sinAzim + cy * cosAzim;

      // Final screen projection maps
      double screenX = center.dx + rotX;
      double screenY = center.dy + (rotY * sinElev) - (cz * cosElev);

      return Offset(screenX, screenY);
    }

    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw lines back-to-front (Painter's Algorithm) to naturally handle occlusions
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        double h = heightMap[y][x];
        Offset currentPoint = project(x, y, h);

        // Normalize color map base strictly against the Z height scale
        double norm = (h / 1.5).clamp(0.0, 1.0);
        linePaint.color = Color.fromARGB(
          255,
          (norm * 255).toInt(),
          (100 + norm * 155).toInt(),
          (norm * 30).toInt(),
        );

        // Connect along rows (X axis wirelines)
        if (x < gridSize - 1) {
          Offset nextX = project(x + 1, y, heightMap[y][x + 1]);
          canvas.drawLine(currentPoint, nextX, linePaint);
        }

        // Connect along columns (Y axis wirelines)
        if (y < gridSize - 1) {
          Offset nextY = project(x, y + 1, heightMap[y + 1][x]);
          canvas.drawLine(currentPoint, nextY, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant AFM3DPainter oldDelegate) {
    return oldDelegate.elevation != elevation ||
        oldDelegate.azimuth != azimuth ||
        oldDelegate.zScale != zScale ||
        oldDelegate.heightMap != heightMap;
  }
}
