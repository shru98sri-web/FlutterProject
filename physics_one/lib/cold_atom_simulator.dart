import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const ColdAtomSimulationApp());

class ColdAtomSimulationApp extends StatelessWidget {
  const ColdAtomSimulationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ColdAtomSimulationPage(),
    );
  }
}

class ColdAtomSimulationPage extends StatefulWidget {
  const ColdAtomSimulationPage({super.key});

  @override
  State<ColdAtomSimulationPage> createState() => _ColdAtomSimulationPageState();
}

class _ColdAtomSimulationPageState extends State<ColdAtomSimulationPage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _elapsedSeconds = 0.0;

  // 4x4 Grid Matrix holding atomic state: 0 = Ground state |0⟩, 1 = Excited state |1⟩
  final List<List<int>> _atomStates = List.generate(
    4,
    (_) => List.generate(4, (_) => 0),
  );

  // Rolling structural history buffer for probability charting
  final List<double> _excitationHistory = [];
  final int _maxHistoryPoints = 60;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsedSeconds = elapsed.inMicroseconds / 1000000.0;
        _updateMetrics();
      });
    });
    _ticker.start();
  }

  void _updateMetrics() {
    int excitedCount = 0;
    for (var row in _atomStates) {
      for (var state in row) {
        if (state == 1) excitedCount++;
      }
    }
    double activeRatio = excitedCount / 16.0;
    _excitationHistory.add(activeRatio);
    if (_excitationHistory.length > _maxHistoryPoints) {
      _excitationHistory.removeAt(0);
    }
  }

  void _handleGridTap(Offset localPos, Size widgetSize) {
    final double cellWidth = widgetSize.width / 4;
    final double cellHeight = widgetSize.height / 4;

    int col = (localPos.dx / cellWidth).clamp(0, 3).toInt();
    int row = (localPos.dy / cellHeight).clamp(0, 3).toInt();

    setState(() {
      // Flips between 0 (|0⟩ Ground) and 1 (|1⟩ Rydberg Excited State)
      _atomStates[row][col] = _atomStates[row][col] == 0 ? 1 : 0;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quantum Gas Simulator'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFF070714),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLandscape = constraints.maxWidth > constraints.maxHeight;

          List<Widget> panels = [
            // Core Lattice Simulator Window
            Expanded(
              flex: 3,
              child: Card(
                color: const Color(0xFF0F0F26),
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LayoutBuilder(
                    builder: (context, boxConstraints) {
                      final size = math.min(
                        boxConstraints.maxWidth,
                        boxConstraints.maxHeight,
                      );
                      return Center(
                        child: SizedBox(
                          width: size,
                          height: size,
                          child: GestureDetector(
                            onTapDown: (details) => _handleGridTap(
                              details.localPosition,
                              Size(size, size),
                            ),
                            child: CustomPaint(
                              painter: LatticePainter(
                                time: _elapsedSeconds,
                                states: _atomStates,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Metrics Analysis Panel
            Expanded(
              flex: 2,
              child: Card(
                color: const Color(0xFF0F0F26),
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Probability Density Chart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Total operational excited-state fraction over time.',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const Expanded(child: SizedBox(height: 12)),
                      Expanded(
                        flex: 6,
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: MetricsChartPainter(
                            history: _excitationHistory,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];

          return isLandscape ? Row(children: panels) : Column(children: panels);
        },
      ),
    );
  }
}

class LatticePainter extends CustomPainter {
  final double time;
  final List<List<int>> states;
  LatticePainter({required this.time, required this.states});

  @override
  void paint(Canvas canvas, Size size) {
    final int gridSize = 4;
    final double cellWidth = size.width / gridSize;
    final double cellHeight = size.height / gridSize;

    // Drawing Laser Wire Background Grid
    final Paint laserPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i <= gridSize; i++) {
      canvas.drawLine(
        Offset(i * cellWidth, 0),
        Offset(i * cellWidth, size.height),
        laserPaint,
      );
      canvas.drawLine(
        Offset(0, i * cellHeight),
        Offset(size.width, i * cellHeight),
        laserPaint,
      );
    }

    // Node Rendering Calculations
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        double centerX = (col + 0.5) * cellWidth;
        double centerY = (row + 0.5) * cellHeight;
        Offset center = Offset(centerX, centerY);

        bool isExcited = states[row][col] == 1;
        double speedModifier = isExcited ? 6.0 : 2.5;
        double currentPhase =
            (time * speedModifier) + (row * 1.2) + (col * 0.6);
        double amplitude = (math.sin(currentPhase) + 1.0) / 2.0;

        // Draw Dipole Optical Trap Potential Well
        final Paint trapPaint = Paint()
          ..shader =
              RadialGradient(
                colors: [
                  Colors.blue.withOpacity(isExcited ? 0.2 : 0.45),
                  Colors.blue.withOpacity(0.05),
                  Colors.transparent,
                ],
              ).createShader(
                Rect.fromCircle(center: center, radius: cellWidth * 0.4),
              );
        canvas.drawCircle(center, cellWidth * 0.4, trapPaint);

        // Rendering state visual manifestations
        Color waveColor = isExcited ? Colors.orangeAccent : Colors.purple;
        double baseRadius = isExcited ? 18.0 : 10.0;
        double waveRadius = baseRadius + (4.0 * amplitude);

        final Paint wavePaint = Paint()
          ..color = waveColor.withOpacity(0.25 + (0.15 * amplitude))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, waveRadius, wavePaint);

        // Atomic Physical Core
        final Paint corePaint = Paint()
          ..color = isExcited ? Colors.deepOrangeAccent : Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, isExcited ? 6.0 : 3.5, corePaint);

        // Micro Text Element displaying Quantum Bra-ket vector shorthand
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: isExcited ? '|1⟩' : '|0⟩',
            style: TextStyle(
              color: isExcited ? Colors.orangeAccent : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          Offset(centerX - (textPainter.width / 2), centerY + 20),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant LatticePainter oldDelegate) => true;
}

class MetricsChartPainter extends CustomPainter {
  final List<double> history;
  MetricsChartPainter({required this.history});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;

    final Paint borderPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);

    final Path path = Path();
    final double stepX = size.width / 60.0;

    for (int i = 0; i < history.length; i++) {
      double x = i * stepX;
      // Invert Y mapping context for Flutter canvas layout mechanics
      double y = size.height - (history[i] * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final Paint linePaint = Paint()
      ..color = Colors.amberAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant MetricsChartPainter oldDelegate) => true;
}
