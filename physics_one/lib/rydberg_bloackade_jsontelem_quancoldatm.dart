import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

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

  // Controls & Parameters
  double _rabiFrequency = 4.0;
  double _detuning = 0.0;
  double _blockadeRadius = 1.5; // Measured in units of grid lattice spacing

  // State Engine: 4x4 Grid Matrix [Real c0, Imag c0, Real c1, Imag c1]
  late List<List<List<double>>> _wavefunctions;
  final List<double> _history = [];
  final int _maxHistory = 60;

  // JSON Log Telemetry Data
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
    _latestJsonLog =
        '{"status": "System initialized. Waiting for evolution..."}';
  }

  void _evolveSystem(double dt) {
    if (dt <= 0) return;
    double continuousSum = 0.0;

    // Create a temporary cache mapping of the *current* Rydberg state probabilities
    // used to calculate the spatial blockade interaction shift down-stream.
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

        // Compute Rydberg Blockade Shift (V_ij) based on surrounding excited density
        double blockadeShift = 0.0;
        for (int or = 0; or < 4; or++) {
          for (int oc = 0; oc < 4; oc++) {
            if (or == r && oc == c) continue;
            double dist = math.sqrt(math.pow(r - or, 2) + math.pow(c - oc, 2));
            if (dist <= _blockadeRadius && dist > 0) {
              // Standard Van der Waals scaling factor simulation: C6 / R^6
              blockadeShift += currentP1[or][oc] * (5.0 / math.pow(dist, 6));
            }
          }
        }

        // Total effective detuning incorporating local multi-atom interaction blocks
        double effectiveDetuning = _detuning - blockadeShift;

        // Differential equations solving: i h-bar dψ/dt = Hψ
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

  void _generateTelemetry(double dt) {
    _logTimer += dt;
    if (_logTimer < 0.4) return; // Throttled updates for performance stability
    _logTimer = 0.0;

    List<Map<String, dynamic>> atomLogs = [];
    double totalP1 = 0.0;

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        double p1 =
            _wavefunctions[r][c][2] * _wavefunctions[r][c][2] +
            _wavefunctions[r][c][3] * _wavefunctions[r][c][3];
        totalP1 += p1;
        if (p1 > 0.05) {
          atomLogs.add({
            "coord": "[$r,$c]",
            "rydberg_prob": double.parse(p1.toStringAsFixed(3)),
          });
        }
      }
    }

    Map<String, dynamic> telemetry = {
      "timestamp_sec": double.parse(_lastTime.toStringAsFixed(2)),
      "parameters": {
        "rabi_omega": double.parse(_rabiFrequency.toStringAsFixed(2)),
        "detuning_delta": double.parse(_detuning.toStringAsFixed(2)),
        "blockade_rc": double.parse(_blockadeRadius.toStringAsFixed(2)),
      },
      "system_metrics": {
        "global_excitation_fraction": double.parse(
          (totalP1 / 16.0).toStringAsFixed(4),
        ),
        "active_excited_nodes": atomLogs,
      },
    };

    _latestJsonLog = const JsonEncoder.withIndent('  ').convert(telemetry);
  }

  void _triggerPulse(Offset localPos, Size widgetSize) {
    int col = (localPos.dx / (widgetSize.width / 4)).clamp(0, 3).toInt();
    int row = (localPos.dy / (widgetSize.height / 4)).clamp(0, 3).toInt();

    setState(() {
      // Coherently drive target localized atom vector to excited space
      _wavefunctions[row][col] = [0.0, 0.0, 1.0, 0.0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    Widget coreLatticePanel = Card(
      color: const Color(0xFF0B0B1E),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size =
              math.min(constraints.maxWidth, constraints.maxHeight) * 0.92;
          return Center(
            child: SizedBox(
              width: size,
              height: size,
              child: GestureDetector(
                onTapDown: (d) =>
                    _triggerPulse(d.localPosition, Size(size, size)),
                child: CustomPaint(
                  painter: PhysicsLatticePainter(
                    states: _wavefunctions,
                    blockadeRadius: _blockadeRadius,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    Widget controlTelemetryPanel = Column(
      children: [
        // Sliders Group
        Card(
          color: const Color(0xFF0B0B1E),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                _buildSliderRow(
                  'Rabi (Ω)',
                  _rabiFrequency,
                  0,
                  10,
                  Colors.orangeAccent,
                  (v) => setState(() => _rabiFrequency = v),
                ),
                _buildSliderRow(
                  'Detuning (Δ)',
                  _detuning,
                  -5,
                  5,
                  Colors.cyanAccent,
                  (v) => setState(() => _detuning = v),
                ),
                _buildSliderRow(
                  'Blockade (Rc)',
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
        // Live Output Display Frame
        Expanded(
          child: Card(
            color: const Color(0xFF04040D),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Telemetry Stream (JSON)',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.tealAccent,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onPressed: () => Clipboard.setData(
                          ClipboardData(text: _latestJsonLog),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _latestJsonLog,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: Colors.greenAccent,
                        ),
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
        title: const Text('Rydberg Blockade Laboratory'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _resetLab),
        ],
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
    ValueChanged<double> cb,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 95,
          child: Text(
            '$label: ${val.toStringAsFixed(2)}',
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
  final List<List<List<double>>> states;
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
            states[r][c][3] *
                states[r][c][3]; // Draw Blockade Boundary Ring around atoms containing population density shifts
        if (p1 > 0.1) {
          final Paint blockadeRing = Paint()
            ..color = Colors.redAccent.withOpacity(0.08 * p1)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(center, step * blockadeRadius, blockadeRing);
          final Paint blockadeBorder = Paint()
            ..color = Colors.redAccent.withOpacity(0.2 * p1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;
          canvas.drawCircle(center, step * blockadeRadius, blockadeBorder);
        }
        // Base Trap Well Gradient Graphic
        final Paint trap = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.blue.withOpacity(0.35 * (1.0 - p1)),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: step * 0.4));
        canvas.drawCircle(
          center,
          step * 0.4,
          trap,
        ); // Core Quantum Structural Cloud Particle Mapping
        final Paint atomCore = Paint()
          ..color = Color.lerp(Colors.cyan, Colors.deepOrange, p1)!;
        canvas.drawCircle(center, 4.0 + (3.5 * p1), atomCore);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PhysicsLatticePainter oldDelegate) => true;
}
