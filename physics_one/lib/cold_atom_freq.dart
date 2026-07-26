import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const ColdAtomAdvancedApp());

class ColdAtomAdvancedApp extends StatelessWidget {
  const ColdAtomAdvancedApp({super.key});

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
  double _lastTime = 0.0;

  // Real-time physical parameters modified by sliders
  double _rabiFrequency = 2.5; // Ω parameter
  double _detuning = 0.0; // Δ parameter

  // Matrix variables tracking quantum state probability amplitudes
  // Each atom holds: [Real alpha, Imaginary alpha, Real beta, Imaginary beta]
  // Complex state vector: |ψ⟩ = c0|0⟩ + c1|1⟩ where |c0|² + |c1|² = 1
  late List<List<List<double>>> _atomWavefunctions;

  // Rolling live history track buffer
  final List<double> _totalExcitationHistory = [];
  final int _maxHistoryPoints = 80;

  @override
  void initState() {
    super.initState();
    _resetSystemState();

    _ticker = createTicker((elapsed) {
      final double currentTime = elapsed.inMicroseconds / 1000000.0;
      double dt = currentTime - _lastTime;
      // Cap maximum time step to prevent arithmetic explosion during frame drops
      if (dt > 0.05) dt = 0.05;
      _lastTime = currentTime;

      setState(() {
        _evolveQuantumSystem(dt);
      });
    });
    _ticker.start();
  }

  void _resetSystemState() {
    // Ground state initialize: c0 = 1.0 + 0.0i, c1 = 0.0 + 0.0i
    _atomWavefunctions = List.generate(
      4,
      (_) => List.generate(4, (_) => [1.0, 0.0, 0.0, 0.0]),
    );
    _totalExcitationHistory.clear();
  }

  // Numerical Schrödinger Solver using standard Euler-Maruyama approximations
  void _evolveQuantumSystem(double dt) {
    if (dt <= 0) return;
    double continuousSum = 0.0;

    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        var state = _atomWavefunctions[row][col];
        double c0R = state[0];
        double c0I = state[1];
        double c1R = state[2];
        double c1I = state[3];

        // Calculating explicit derivatives based on H = (Ω/2 * σ_x) - (Δ * n) matrix mapping
        // dc0/dt = i * (Ω/2) * c1
        // dc1/dt = i * (Ω/2) * c0 - i * Δ * c1
        double dc0R = -(_rabiFrequency / 2.0) * c1I;
        double dc0I = (_rabiFrequency / 2.0) * c1R;

        double dc1R = -(_rabiFrequency / 2.0) * c0I + _detuning * c1I;
        double dc1I = (_rabiFrequency / 2.0) * c0R - _detuning * c1R;

        // Apply forward differential time steps
        c0R += dc0R * dt;
        c0I += dc0I * dt;
        c1R += dc1R * dt;
        c1I += dc1I * dt;

        // Normalization engine to maintain unitary probability laws (|c0|² + |c1|² = 1)
        double norm = math.sqrt(c0R * c0R + c0I * c0I + c1R * c1R + c1I * c1I);
        if (norm > 0) {
          c0R /= norm;
          c0I /= norm;
          c1R /= norm;
          c1I /= norm;
        }

        _atomWavefunctions[row][col] = [c0R, c0I, c1R, c1I];

        // Probability density of state |1⟩: P1 = |c1R|² + |c1I|²
        continuousSum += (c1R * c1R + c1I * c1I);
      }
    }

    double globalExcitationRatio = continuousSum / 16.0;
    _totalExcitationHistory.add(globalExcitationRatio);
    if (_totalExcitationHistory.length > _maxHistoryPoints) {
      _totalExcitationHistory.removeAt(0);
    }
  }

  void _handleGridTap(Offset localPos, Size widgetSize) {
    final double cellWidth = widgetSize.width / 4;
    final double cellHeight = widgetSize.height / 4;

    int col = (localPos.dx / cellWidth).clamp(0, 3).toInt();
    int row = (localPos.dy / cellHeight).clamp(0, 3).toInt();

    setState(() {
      // Coherent Laser Pulse Phase Flip: Injecting system excitation amplitude manually
      var target = _atomWavefunctions[row][col];
      if (target[2].abs() < 0.5) {
        // Pump into excited state amplitude profile
        _atomWavefunctions[row][col] = [0.0, 0.0, 1.0, 0.0];
      } else {
        // Coherently return back down to ground vector base space
        _atomWavefunctions[row][col] = [1.0, 0.0, 0.0, 0.0];
      }
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
        title: const Text('Schrödinger Hamiltonian Lab'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.amberAccent),
            onPressed: _resetSystemState,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF050512),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLandscape = constraints.maxWidth > constraints.maxHeight;

          List<Widget> panels = [
            // Panel A: Main Quantum Lattice Grid view
            Expanded(
              flex: 4,
              child: Card(
                color: const Color(0xFF0C0C22),
                margin: const EdgeInsets.all(8),
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    final size =
                        math.min(
                          boxConstraints.maxWidth,
                          boxConstraints.maxHeight,
                        ) *
                        0.95;
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
                            painter: AdvancedLatticePainter(
                              states: _atomWavefunctions,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Panel B: Control sliders and Probability Wave tracking graphics
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    // Dynamic Slider Control Deck
                    Card(
                      color: const Color(0xFF0C0C22),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Rabi Freq (Ω): ${_rabiFrequency.toStringAsFixed(1)} rad/s',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _rabiFrequency,
                                    min: 0.0,
                                    max: 10.0,
                                    activeColor: Colors.orangeAccent,
                                    onChanged: (val) =>
                                        setState(() => _rabiFrequency = val),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Detuning (Δ): ${_detuning.toStringAsFixed(1)} MHz',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _detuning,
                                    min: -5.0,
                                    max: 5.0,
                                    activeColor: Colors.cyanAccent,
                                    onChanged: (val) =>
                                        setState(() => _detuning = val),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Live Wave Chart Monitoring window
                    Expanded(
                      child: Card(
                        color: const Color(0xFF0C0C22),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Live Target |1⟩ Probability Density',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: CustomPaint(
                                  size: Size.infinite,
                                  painter: AdvancedChartPainter(
                                    history: _totalExcitationHistory,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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

class AdvancedLatticePainter extends CustomPainter {
  final List<List<List<double>>> states;
  AdvancedLatticePainter({required this.states});
  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = size.width / 4;
    final double cellHeight = size.height / 4;
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        double centerX = (col + 0.5) * cellWidth;
        double centerY = (row + 0.5) * cellHeight;
        Offset center = Offset(centerX, centerY);
        var data = states[row][col];
        // Calculate raw localized vector populations
        double p0 = (data[0] * data[0]) + (data[1] * data[1]);
        // |c0|² Ground Probability
        double p1 = (data[2] * data[2]) + (data[3] * data[3]);
        // |c1|² Excited Probability
        // 1. Draw Optical Tweezer Dipole Potential Profile
        final Paint potentialPaint = Paint()
          ..shader =
              RadialGradient(
                colors: [
                  Colors.blue.withOpacity(0.35 * p0),
                  Colors.transparent,
                ],
              ).createShader(
                Rect.fromCircle(center: center, radius: cellWidth * 0.45),
              );
        canvas.drawCircle(center, cellWidth * 0.45, potentialPaint);
        // 2. Draw Excited Wavefunction Field (Grows with Rydberg populations)
        if (p1 > 0.01) {
          final Paint rydbergCloud = Paint()
            ..shader =
                RadialGradient(
                  colors: [
                    Colors.orange.withOpacity(0.4 * p1),
                    Colors.transparent,
                  ],
                ).createShader(
                  Rect.fromCircle(center: center, radius: cellWidth * 0.4 * p1),
                );
          canvas.drawCircle(center, cellWidth * 0.4 * p1, rydbergCloud);
        }
        // 3. Central Physical Atom Core Core
        final Paint coreAtomPaint = Paint()
          ..color = Color.lerp(Colors.tealAccent, Colors.deepOrangeAccent, p1)!
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, 4.0 + (3.0 * p1), coreAtomPaint);
        // 4. Probability Value Tag Strings
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: 'P₁:${p1.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white60, fontSize: 9),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          Offset(centerX - (textPainter.width / 2), centerY + 16),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant AdvancedLatticePainter oldDelegate) => true;
}

class AdvancedChartPainter extends CustomPainter {
  final List history;
  AdvancedChartPainter({required this.history});
  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;
    final Paint axisGrid = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      axisGrid,
    );
    final Path path = Path();
    final double stepX = size.width / 80.0;
    for (int i = 0; i < history.length; i++) {
      double x = i * stepX;
      double y = size.height - (history[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final Paint linePaint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant AdvancedChartPainter oldDelegate) => true;
}
