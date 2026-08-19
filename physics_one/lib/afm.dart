import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: AFMSimulatorScreen()));

enum ScanMode { topography, phase }

class AFMSimulatorScreen extends StatefulWidget {
  const AFMSimulatorScreen({super.key});

  @override
  State<AFMSimulatorScreen> createState() => _AFMSimulatorScreenState();
}

class _AFMSimulatorScreenState extends State<AFMSimulatorScreen> {
  // --- Microscope Configurable Parameters ---
  int gridSize = 150; // Scan Resolution Matrix
  double tipRadiusMultiplier = 1.0; // Probe Tip Radius Factor
  double noiseAmplitude = 0.05; // Instrument Thermal/Electrical Noise
  ScanMode currentMode = ScanMode.topography;

  // Storing matrix arrays for height and material properties
  List<List<double>> heightMap = [];
  List<List<double>> phaseMap = [];

  // Base atomic coordinates normalized from 0.0 to 1.0 to preserve positions during resolution rescaling
  final List<Map<String, double>> normalizedParticles = [
    {'x': 0.25, 'y': 0.30, 'r': 0.09, 'h': 0.9, 'stiffness': 0.8},
    {'x': 0.60, 'y': 0.65, 'r': 0.12, 'h': 1.2, 'stiffness': 0.3},
    {'x': 0.70, 'y': 0.35, 'r': 0.06, 'h': 0.7, 'stiffness': 0.9},
  ];

  @override
  void initState() {
    super.initState();
    _processAFMScan();
  }

  // Generates maps based on the physical sliders and coordinates
  void _processAFMScan() {
    final random = math.Random();

    List<List<double>> hGrid = List.generate(
      gridSize,
      (_) => List.filled(gridSize, 0.0),
    );
    List<List<double>> pGrid = List.generate(
      gridSize,
      (_) => List.filled(gridSize, 0.0),
    );

    const double substrateStiffness = 1.0;

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        double totalHeight = 0.0;
        double dominantStiffness = substrateStiffness;
        double maxWeight = 0.0;

        // Convert matrix coordinates back to normalized space to evaluate features
        double nx = x / gridSize;
        double ny = y / gridSize;

        for (var p in normalizedParticles) {
          double dx = nx - p['x']!;
          double dy = ny - p['y']!;
          double distanceSq = (dx * dx) + (dy * dy);

          // Slider Effect: Modifying effective radius simulates tip convolution (blunting)
          double effectiveRadius = p['r']! * tipRadiusMultiplier;
          double radiusSq = effectiveRadius * effectiveRadius;

          double weight = math.exp(-distanceSq / radiusSq);
          totalHeight += p['h']! * weight;

          if (weight > maxWeight && weight > 0.1) {
            maxWeight = weight;
            dominantStiffness = p['stiffness']!;
          }
        }

        // Apply adjustable instrument noise
        double hNoise = (random.nextDouble() - 0.5) * noiseAmplitude * 2.0;
        hGrid[y][x] = (totalHeight + hNoise).clamp(0.0, 1.5);

        // Edge detection phase contrast simulation
        double edgeEffect = maxWeight * (1.0 - maxWeight) * 4.0;
        double materialLoss = (1.0 - dominantStiffness);
        double pNoise = (random.nextDouble() - 0.5) * noiseAmplitude * 1.5;

        pGrid[y][x] = (materialLoss * 0.6 + edgeEffect * 0.4 + pNoise).clamp(
          0.0,
          1.0,
        );
      }
    }

    setState(() {
      heightMap = hGrid;
      phaseMap = pGrid;
    });
  }

  // Translates viewport click down into normalized spatial physics arrays
  void _handleSurfaceTap(TapUpDetails details, BoxConstraints constraints) {
    final double pixelX = details.localPosition.dx;
    final double pixelY = details.localPosition.dy;

    final double normX = (pixelX / constraints.maxWidth).clamp(0.0, 1.0);
    final double normY = (pixelY / constraints.maxHeight).clamp(0.0, 1.0);

    final random = math.Random();

    setState(() {
      normalizedParticles.add({
        'x': normX,
        'y': normY,
        'r': 0.05 + random.nextDouble() * 0.08,
        'h': 0.5 + random.nextDouble() * 0.8,
        'stiffness': 0.2 + random.nextDouble() * 0.7,
      });
      _processAFMScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'AFM Control Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amberAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Microscope Viewport
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double size = math.min(
                    constraints.maxWidth * 0.85,
                    340.0,
                  );
                  return GestureDetector(
                    onTapUp: (details) => _handleSurfaceTap(
                      details,
                      BoxConstraints.tight(Size(size, size)),
                    ),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(color: Colors.amberAccent),
                      child: heightMap.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : CustomPaint(
                              painter: AFMMatrixPainter(
                                dataMatrix: currentMode == ScanMode.topography
                                    ? heightMap
                                    : phaseMap,
                                gridSize: gridSize,
                                mode: currentMode,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // Mode Select Toggles
            ToggleButtons(
              isSelected: [
                currentMode == ScanMode.topography,
                currentMode == ScanMode.phase,
              ],
              onPressed: (int index) {
                setState(() {
                  currentMode = index == 0
                      ? ScanMode.topography
                      : ScanMode.phase;
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.black,
              fillColor: Colors.amberAccent,
              color: Colors.white,
              constraints: const BoxConstraints(minWidth: 150, minHeight: 38),
              children: const [
                Text('Topography (Height)'),
                Text('Phase (Material)'),
              ],
            ),

            const SizedBox(height: 15),

            // --- Instrument Controls Panel ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INSTRUMENT PARAMETERS',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Divider(color: Colors.white10),

                  // Slider 1: Probe Tip Convolution Radius
                  _buildSliderRow(
                    label: 'Tip Radius (Convolution)',
                    value: tipRadiusMultiplier,
                    min: 0.5,
                    max: 3.0,
                    displayValue:
                        '${(tipRadiusMultiplier * 10).toStringAsFixed(1)} nm',
                    onChanged: (val) {
                      setState(() {
                        tipRadiusMultiplier = val;
                        _processAFMScan();
                      });
                    },
                  ),

                  // Slider 2: Microscopic Disturbance Noise
                  _buildSliderRow(
                    label: 'Thermal Noise Amplitude',
                    value: noiseAmplitude,
                    min: 0.0,
                    max: 0.3,
                    displayValue:
                        '${(noiseAmplitude * 100).toStringAsFixed(0)} pm',
                    onChanged: (val) {
                      setState(() {
                        noiseAmplitude = val;
                        _processAFMScan();
                      });
                    },
                  ),

                  // Slider 3: Hardware Scan Resolution Density
                  _buildSliderRow(
                    label: 'Scan Resolution Matrix',
                    value: gridSize.toDouble(),
                    min: 50,
                    max: 250,
                    displayValue: '${gridSize}x$gridSize px',
                    onChanged: (val) {
                      setState(() {
                        gridSize = val.toInt();
                        _processAFMScan();
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  normalizedParticles.clear();
                  _processAFMScan();
                });
              },
              icon: const Icon(Icons.layers_clear),
              label: const Text('Reset Substrate Frame'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 40),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required ValueChanged onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                displayValue,
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.amberAccent,
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.amberAccent,
              overlayColor: Colors.amberAccent.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class AFMMatrixPainter extends CustomPainter {
  final List<List> dataMatrix;
  final int gridSize;
  final ScanMode mode;
  AFMMatrixPainter({
    required this.dataMatrix,
    required this.gridSize,
    required this.mode,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (dataMatrix.isEmpty) return;
    final double cellWidth = size.width / gridSize;
    final double cellHeight = size.height / gridSize;
    final Paint paint = Paint()..style = PaintingStyle.fill;
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        double val = dataMatrix[y][x];
        if (mode == ScanMode.topography) {
          double norm = (val / 1.5).clamp(0.0, 1.0);
          paint.color = Color.fromARGB(
            255,
            (norm * 255).toInt(),
            (norm * 145).toInt(),
            (norm * 30).toInt(),
          );
        } else {
          double norm = val.clamp(0.0, 1.0);
          paint.color = Color.fromARGB(
            255,
            (norm * 30).toInt(),
            (norm * 220).toInt(),
            (norm * 240).toInt(),
          );
        }
        canvas.drawRect(
          Rect.fromLTWH(
            x * cellWidth,
            y * cellHeight,
            cellWidth + 0.4,
            cellHeight + 0.4,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant AFMMatrixPainter oldDelegate) {
    return oldDelegate.dataMatrix != dataMatrix ||
        oldDelegate.mode != mode ||
        oldDelegate.gridSize != gridSize;
  }
}
