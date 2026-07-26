import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const ColdAtomLabSuite());

class ColdAtomLabSuite extends StatelessWidget {
  const ColdAtomLabSuite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ColdAtomLabPage(),
    );
  }
}

class ColdAtomLabPage extends StatefulWidget {
  const ColdAtomLabPage({super.key});

  @override
  State<ColdAtomLabPage> createState() => _ColdAtomLabPageState();
}

class _ColdAtomLabPageState extends State<ColdAtomLabPage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _lastTime = 0.0;

  // Physical Parameters
  double _rabiFrequency = 4.0;
  double _detuning = 0.0;
  double _blockadeRadius = 1.5;

  // Simulation Matrices [Real c0, Imag c0, Real c1, Imag c1]
  late List<List<List<double>>> _wavefunctions;
  final List<double> _history = [];
  final int _maxHistory = 64; // Power of 2 for clean FFT window tracking

  // Gate Pulse Sequencer Configuration
  bool _isSequenceRunning = false;
  double _sequenceTime = 0.0;
  String _activeGateName = "Idle";

  // Telemetry
  String _latestJsonLog = '{}';
  double _logTimer = 0.0;

  @override
  void initState() {
    super.initState();
    _resetLab();
    _ticker = createTicker((elapsed) {
      double currentTime = elapsed.inMicroseconds / 1000000.0;
      double dt = currentTime - _lastTime;
      if (dt > 0.05) dt = 0.05;
      _lastTime = currentTime;

      setState(() {
        _handleGateSequencer(dt);
        _evolveSystem(dt);
        _generateTelemetry(dt);
      });
    });
    _ticker.start();
  }

  void _resetLab() {
    _wavefunctions = List.generate(
      4,
      (_) => List.generate(4, (_) => [1.0, 0.0, 0.0, 0.0]),
    );
    _history.clear();
    _isSequenceRunning = false;
    _sequenceTime = 0.0;
    _activeGateName = "Idle";
    _latestJsonLog = '{"status": "System Ready"}';
  }

  // Automates laser pulse steps targeting specific index coordinates
  void _startCZGateSequence() {
    _resetLab();
    _isSequenceRunning = true;
    _sequenceTime = 0.0;
    _activeGateName = "Executing CZ Phase Sequence";
  }

  void _handleGateSequencer(double dt) {
    if (!_isSequenceRunning) return;
    _sequenceTime += dt;

    // Step 1 (0.0s - 0.5s): π-pulse on Control Atom [1,1] -> Drive to excited state
    if (_sequenceTime > 0.0 && _sequenceTime <= 0.5) {
      _wavefunctions[1][1] = [0.0, 0.0, 1.0, 0.0];
      _activeGateName = "Step 1: π-pulse on Control [1,1]";
    }
    // Step 2 (0.5s - 1.0s): 2π-pulse on Target Atom [1,2] -> Shift conditional phase
    else if (_sequenceTime > 0.5 && _sequenceTime <= 1.0) {
      _wavefunctions[1][2] = [0.0, 0.0, -1.0, 0.0];
      _activeGateName = "Step 2: 2π conditional phase pulse on Target [1,2]";
    }
    // Step 3 (1.0s - 1.5s): Return Control Atom via π-pulse
    else if (_sequenceTime > 1.0 && _sequenceTime <= 1.5) {
      _wavefunctions[1][1] = [1.0, 0.0, 0.0, 0.0];
      _activeGateName = "Step 3: Returning Control atom down";
    } else {
      _isSequenceRunning = false;
      _activeGateName = "CZ Gate Sequence Completed";
    }
  }

  void _evolveSystem(double dt) {
    if (dt <= 0) return;
    double continuousSum = 0.0;

    List<List<double>> currentP1 = List.generate(
      4,
      (r) => List.generate(
        4,
        (c) =>
            _wavefunctions[r][c][2] * _wavefunctions[r][c][2] +
            _wavefunctions[r][c][3] * _wavefunctions[r][c][3],
      ),
    );

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        var state = _wavefunctions[r][c];
        double c0r = state[0], c0i = state[1], c1r = state[2], c1i = state[3];

        double blockadeShift = 0.0;
        for (int or = 0; or < 4; or++) {
          for (int oc = 0; oc < 4; oc++) {
            if (or == r && oc == c) continue;
            double dist = math.sqrt(math.pow(r - or, 2) + math.pow(c - oc, 2));
            if (dist <= _blockadeRadius && dist > 0) {
              blockadeShift += currentP1[or][oc] * (5.0 / math.pow(dist, 6));
            }
          }
        }

        double effectiveDetuning = _detuning - blockadeShift;

        double dc0r = -(_rabiFrequency / 2.0) * c1i;
        double dc0i = (_rabiFrequency / 2.0) * c1r;
        double dc1r = -(_rabiFrequency / 2.0) * c0i + effectiveDetuning * c1i;
        double dc1i = (_rabiFrequency / 2.0) * c0r - effectiveDetuning * c1r;

        c0r += dc0r * dt;
        c0i += dc0i * dt;
        c1r += dc1r * dt;
        c1i += dc1i * dt;

        double norm = math.sqrt(c0r * c0r + c0i * c0i + c1r * c1r + c1i * c1i);
        if (norm > 0) {
          c0r /= norm;
          c0i /= norm;
          c1r /= norm;
          c1i /= norm;
        }

        _wavefunctions[r][c] = [c0r, c0i, c1r, c1i];
        continuousSum += (c1r * c1r + c1i * c1i);
      }
    }

    double globalRatio = continuousSum / 16.0;
    _history.add(globalRatio);
    if (_history.length > _maxHistory) _history.removeAt(0);
  }

  // Simplified Discrete Fourier Transform calculation tracking population oscillation spectrum
  List<double> _calculateSpectrumFFT() {
    if (_history.length < 8) return [];
    int n = _history.length;
    List<double> spectrum = List.filled(n ~/ 2, 0.0);

    for (int k = 0; k < n ~/ 2; k++) {
      double realSum = 0.0;
      double imagSum = 0.0;
      for (int t = 0; t < n; t++) {
        double angle = (2 * math.pi * k * t) / n;
        realSum += _history[t] * math.cos(angle);
        imagSum -= _history[t] * math.sin(angle);
      }
      spectrum[k] = math.sqrt(realSum * realSum + imagSum * imagSum) / n;
    }
    return spectrum;
  }

  void _generateTelemetry(double dt) {
    _logTimer += dt;
    if (_logTimer < 0.4) return;
    _logTimer = 0.0;

    Map<String, dynamic> telemetry = {
      "timestamp_sec": double.parse(_lastTime.toStringAsFixed(2)),
      "active_sequence": _activeGateName,
      "parameters": {
        "rabi_omega": double.parse(_rabiFrequency.toStringAsFixed(2)),
        "detuning_delta": double.parse(_detuning.toStringAsFixed(2)),
      },
      "system_metrics": {
        "global_excitation_fraction": _history.isEmpty
            ? 0
            : double.parse(_history.last.toStringAsFixed(4)),
      },
    };
    _latestJsonLog = const JsonEncoder.withIndent('  ').convert(telemetry);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    Widget coreLatticePanel = Card(
      color: const Color(0xFF0B0B1E),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final size =
                  math.min(constraints.maxWidth, constraints.maxHeight) * 0.88;
              return Center(
                child: SizedBox(
                  width: size,
                  height: size,
                  child: CustomPaint(
                    painter: PhysicsLatticePainter(
                      states: _wavefunctions,
                      blockadeRadius: _blockadeRadius,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Chip(
              backgroundColor: Colors.black54,
              label: Text(
                _activeGateName,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.amberAccent,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Widget controlTelemetryPanel = Column(
      children: [
        // Controls Deck
        Card(
          color: const Color(0xFF0B0B1E),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_fill, size: 14),
                      label: const Text(
                        'Run CZ Protocol',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: _startCZGateSequence,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh, size: 14),
                      label: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 11),
                      ),
                      onPressed: _resetLab,
                    ),
                  ],
                ),
                _buildSliderRow(
                  'Rabi (Ω)',
                  _rabiFrequency,
                  0,
                  10,
                  Colors.orangeAccent,
                  (v) => setState(() => _rabiFrequency = v),
                ),
                _buildSliderRow(
                  'Blockade',
                  _blockadeRadius,
                  0.5,
                  3.0,
                  Colors.redAccent,
                  (v) => setState(() => _blockadeRadius = v),
                ),
              ],
            ),
          ),
        ),
        // Live FFT Spectral Graphics Chart Frame
        Expanded(
          child: Card(
            color: const Color(0xFF050515),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rabi Spectral Analyzer (FFT Magnitude)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: SpectralChartPainter(
                        spectrum: _calculateSpectrumFFT(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quantum Pulse Lab Suite'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF03030A),
      body: isLandscape
          ? Row(
              children: [
                Expanded(flex: 4, child: coreLatticePanel),
                Expanded(flex: 3, child: controlTelemetryPanel),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 4, child: coreLatticePanel),
                Expanded(flex: 4, child: controlTelemetryPanel),
              ],
            ),
    );
  }

  Widget _buildSliderRow(
    String label,
    double val,
    double min,
    double max,
    Color color,
    ValueChanged cb,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '$label: ${val.toStringAsFixed(1)}',
            style: const TextStyle(fontSize: 11),
          ),
        ),
        Expanded(
          child: Slider(
            value: val,
            min: min,
            max: max,
            activeColor: color,
            onChanged: cb,
          ),
        ),
      ],
    );
  }
}

class PhysicsLatticePainter extends CustomPainter {
  final List<List<List>> states;
  final double blockadeRadius;
  PhysicsLatticePainter({required this.states, required this.blockadeRadius});
  @override
  void paint(Canvas canvas, Size size) {
    final double step = size.width / 4;
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        double x = (c + 0.5) * step;
        double y = (r + 0.5) * step;
        Offset center = Offset(x, y);
        double p1 =
            states[r][c][2] * states[r][c][2] +
            states[r][c][3] * states[r][c][3];
        if (p1 > 0.1) {
          final Paint blockadeRing = Paint()
            ..color = Colors.redAccent.withOpacity(0.06 * p1);
          canvas.drawCircle(center, step * blockadeRadius, blockadeRing);
        }
        final Paint atomCore = Paint()
          ..color = Color.lerp(Colors.tealAccent, Colors.deepOrangeAccent, p1)!;
        canvas.drawCircle(center, 5.0 + (4.0 * p1), atomCore);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PhysicsLatticePainter oldDelegate) => true;
}

class SpectralChartPainter extends CustomPainter {
  final List spectrum;
  SpectralChartPainter({required this.spectrum});
  @override
  void paint(Canvas canvas, Size size) {
    if (spectrum.isEmpty) return;
    final Paint barPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    double barWidth = size.width / spectrum.length;
    for (int i = 0; i < spectrum.length; i++) {
      double magnitude = spectrum[i] * size.height * 2.5;
      double clampedMagnitude = magnitude.clamp(0.0, size.height);
      canvas.drawRect(
        Rect.fromLTWH(
          i * barWidth + 2,
          size.height - clampedMagnitude,
          barWidth - 4,
          clampedMagnitude,
        ),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SpectralChartPainter oldDelegate) => true;
}
