import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const QEDTwoLevelSuite());

class QEDTwoLevelSuite extends StatelessWidget {
  const QEDTwoLevelSuite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const QEDSimulationPage(),
    );
  }
}

class QEDSimulationPage extends StatefulWidget {
  const QEDSimulationPage({super.key});

  @override
  State<QEDSimulationPage> createState() => _QEDSimulationPageState();
}

class _QEDSimulationPageState extends State<QEDSimulationPage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _lastTime = 0.0;

  // QED Core Physics Parameters
  double _couplingG = 4.0; // Vacuum Rabi Coupling strength (g)
  double _cavityLossKappa = 0.15; // Cavity Photon Decay Rate (κ)
  int _initialPhotonSector =
      1; // Input State Selector: 0 = No Photons, 1 = One Photon

  // Pure 4-dimensional basis space amplitudes:
  // Index 0: |g,0⟩ -> Ground Atom, 0 Photons in Cavity
  // Index 1: |e,0⟩ -> Excited Atom, 0 Photons in Cavity
  // Index 2: |g,1⟩ -> Ground Atom, 1 Photon in Cavity
  // Index 3: |e,1⟩ -> Excited Atom, 1 Photon in Cavity (Upper Boundary)
  late List<double> _stateAmplitudes;

  @override
  void initState() {
    super.initState();
    _resetQEDEngine();

    _ticker = createTicker((elapsed) {
      final double currentTime = elapsed.inMicroseconds / 1000000.0;
      double dt = currentTime - _lastTime;
      if (dt > 0.04) dt = 0.04; // Safety frame-drop clamp
      _lastTime = currentTime;

      setState(() {
        _evolveTwoLevelSystem(dt);
      });
    });
    _ticker.start();
  }

  void _resetQEDEngine() {
    _stateAmplitudes = List.filled(4, 0.0);

    // Seed initial system population properties cleanly
    if (_initialPhotonSector == 0) {
      _stateAmplitudes[1] = 1.0; // Instantly start inside |e,0⟩
    } else {
      _stateAmplitudes[2] = 1.0; // Instantly start inside |g,1⟩
    }
  }

  // Solves the primary Jaynes-Cummings matrix loop for 0 and 1 photon spaces
  void _evolveTwoLevelSystem(double dt) {
    if (dt <= 0) return;

    List<double> next = List.from(_stateAmplitudes);

    // Primary Jaynes-Cummings Exchange Loop:
    // Models coherent energy swapping between |e,0⟩ (Index 1) and |g,1⟩ (Index 2)
    double interactionScale = _couplingG * math.sqrt(1.0);
    next[2] +=
        interactionScale *
        _stateAmplitudes[1] *
        dt; // Populates |g,1⟩ from |e,0⟩
    next[1] -=
        interactionScale * _stateAmplitudes[2] * dt; // Siphons |e,0⟩ into |g,1⟩

    // Apply basic Lindblad field decay losses to the 1-photon states
    // Siphons population from |g,1⟩ (Index 2) into the lower resting state |g,0⟩ (Index 0)
    next[2] -= (_cavityLossKappa / 2.0) * _stateAmplitudes[2] * dt;
    next[0] +=
        _cavityLossKappa * (_stateAmplitudes[2] * _stateAmplitudes[2]) * dt;

    // Unitary mathematical re-normalization vector check
    double cumulativeNorm = 0.0;
    for (var val in next) {
      cumulativeNorm += val * val;
    }
    cumulativeNorm = math.sqrt(cumulativeNorm);

    if (cumulativeNorm > 0) {
      for (int i = 0; i < 4; i++) {
        _stateAmplitudes[i] = next[i] / cumulativeNorm;
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    Widget visualPanel = Card(
      color: const Color(0xFF060612),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              'Cavity Field State (0 vs 1 Photon)',
              style: TextStyle(
                fontSize: 13,
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: SimpleQEDFieldPainter(amplitudes: _stateAmplitudes),
              ),
            ),
          ],
        ),
      ),
    );

    Widget diagnosticPanel = Column(
      children: [
        Card(
          color: const Color(0xFF0D0D22),
          margin: const EdgeInsets.all(6),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildSliderRow(
                  'Coupling (g)',
                  _couplingG,
                  1.0,
                  8.0,
                  Colors.orangeAccent,
                  (v) => setState(() => _couplingG = v),
                ),
                _buildSliderRow(
                  'Loss (κ)',
                  _cavityLossKappa,
                  0.0,
                  1.5,
                  Colors.redAccent,
                  (v) => setState(() => _cavityLossKappa = v),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Initial Photon State:',
                      style: TextStyle(fontSize: 11),
                    ),
                    DropdownButton<int>(
                      value: _initialPhotonSector,
                      dropdownColor: const Color(0xFF0D0D22),
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text('0 Photons |e,0⟩'),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text('1 Photon |g,1⟩'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _initialPhotonSector = val;
                            _resetQEDEngine();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Card(
            color: const Color(0xFF04040E),
            margin: const EdgeInsets.all(6),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wigner Function Phase-Space Profile',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: SimpleWignerPainter(
                        amplitudes: _stateAmplitudes,
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
        title: const Text('Isolated Cavity QED Lab'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFF020206),
      body: isLandscape
          ? Row(
              children: [
                Expanded(flex: 4, child: visualPanel),
                Expanded(flex: 3, child: diagnosticPanel),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 4, child: visualPanel),
                Expanded(flex: 4, child: diagnosticPanel),
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
          width: 80,
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

class SimpleQEDFieldPainter extends CustomPainter {
  final List<double> amplitudes;
  SimpleQEDFieldPainter({required this.amplitudes});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    // Evaluate the exact probability of 1 photon existing in the system: P(1) = |c_g1|²
    double pPhoton1 = amplitudes[2] * amplitudes[2];
    double pExcited = amplitudes[1] * amplitudes[1];

    // Mirror structures
    final Paint mirror = Paint()
      ..color = Colors.white24
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.25),
      Offset(size.width * 0.12, size.height * 0.75),
      mirror,
    );
    canvas.drawLine(
      Offset(size.width * 0.88, size.height * 0.25),
      Offset(size.width * 0.88, size.height * 0.75),
      mirror,
    );

    // Draw standalone standing field wave matching 1 photon density properties
    if (pPhoton1 > 0.01) {
      final Path wavePath = Path();
      wavePath.moveTo(size.width * 0.12, center.dy);
      for (double x = size.width * 0.12; x <= size.width * 0.88; x += 2) {
        double relativeX = (x - size.width * 0.12) / (size.width * 0.76);
        double y =
            center.dy + (24.0 * pPhoton1) * math.sin(relativeX * 3.0 * math.pi);
        wavePath.lineTo(x, y);
      }
      canvas.drawPath(
        wavePath,
        Paint()
          ..color = Colors.cyan.withOpacity(0.15 + (pPhoton1 * 0.45))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }

    // Central Atom rendering node
    canvas.drawCircle(
      center,
      12.0 + (6.0 * pExcited),
      Paint()..color = Colors.deepOrange.withOpacity(0.25 * pExcited + 0.05),
    );
    canvas.drawCircle(
      center,
      4.5,
      Paint()
        ..color = Color.lerp(Colors.blueGrey, Colors.tealAccent, pPhoton1)!,
    );
  }

  @override
  bool shouldRepaint(covariant SimpleQEDFieldPainter oldDelegate) => true;
}

class SimpleWignerPainter extends CustomPainter {
  final List<double> amplitudes;
  SimpleWignerPainter({required this.amplitudes});

  @override
  void paint(Canvas canvas, Size size) {
    const int resolution = 16;
    double cellW = size.width / resolution;
    double cellH = size.height / resolution;

    // Isolate population vectors for clear mapping
    double p0 =
        amplitudes[0] * amplitudes[0] +
        amplitudes[1] * amplitudes[1]; // Total 0-photon profile population
    double p1 =
        amplitudes[2] * amplitudes[2]; // Total 1-photon profile population

    for (int q = 0; q < resolution; q++) {
      for (int p = 0; p < resolution; p++) {
        double x = (q - resolution / 2.0) / (resolution / 4.0);
        double y = (p - resolution / 2.0) / (resolution / 4.0);
        double rSq = x * x + y * y;
        // Combined Wigner function profile mapping for 0 and 1 photon modes
        double w0 = math.exp(-rSq) * p0;
        double w1 =
            math.exp(-rSq) *
            (1.0 - 2.0 * rSq) *
            p1; // Parity flips to negative values based on rSq bounds
        double wignerTotal = w0 + w1;
        Color tileColor = wignerTotal >= 0
            ? Colors.deepPurple.withOpacity((wignerTotal * 0.9).clamp(0.0, 1.0))
            : Colors.tealAccent.withOpacity(
                (wignerTotal.abs() * 0.9).clamp(0.0, 1.0),
              );
        canvas.drawRect(
          Rect.fromLTWH(
            q * cellW + 0.5,
            p * cellH + 0.5,
            cellW - 1.0,
            cellH - 1.0,
          ),
          Paint()
            ..color = tileColor
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant SimpleWignerPainter oldDelegate) => true;
}
