import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const QuantumPlasmonicsApp());

class QuantumPlasmonicsApp extends StatelessWidget {
  const QuantumPlasmonicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const PlasmonicSimulationPage(),
    );
  }
}

class PlasmonicSimulationPage extends StatefulWidget {
  const PlasmonicSimulationPage({super.key});

  @override
  State<PlasmonicSimulationPage> createState() =>
      _PlasmonicSimulationPageState();
}

class _PlasmonicSimulationPageState extends State<PlasmonicSimulationPage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _lastTime = 0.0;

  // Quantum Plasmonic Parameters
  double _couplingG =
      6.5; // Enhanced Plasmonic coupling strength (g) due to tiny mode volume
  double _detuningDelta = 0.0; // Emitter-Plasmon detuning (Δ)
  double _plasmonLossGamma = 1.8; // High ohmic dissipation rate of metal (γ_pl)

  // System State Vector: Basis Space [|g,1⟩, |e,0⟩]
  // Format: [Real c_g1, Imag c_g1, Real c_e0, Imag c_e0]
  // Initial state initialized to |e,0⟩ (Emitter excited, 0 plasmons in waveguide)
  late List<double> _stateVector;

  // Rolling historical buffer for plasmon wave tracking
  final List<double> _plasmonProbabilityHistory = [];
  final int _maxHistoryPoints = 70;

  @override
  void initState() {
    super.initState();
    _resetPlasmonicSystem();

    _ticker = createTicker((elapsed) {
      final double currentTime = elapsed.inMicroseconds / 1000000.0;
      double dt = currentTime - _lastTime;
      if (dt > 0.04) dt = 0.04; // Frame-lag clamp
      _lastTime = currentTime;

      setState(() {
        _evolvePlasmonicSystem(dt);
      });
    });
    _ticker.start();
  }

  void _resetPlasmonicSystem() {
    _stateVector = [0.0, 0.0, 1.0, 0.0]; // Pure initial state: |e,0⟩
    _plasmonProbabilityHistory.clear();
  }

  // Non-Hermitian Schrödinger engine modeling the localized plasmon-emitter interaction
  void _evolvePlasmonicSystem(double dt) {
    if (dt <= 0) return;

    double cg1R = _stateVector[0];
    double cg1I = _stateVector[1];
    double ce0R = _stateVector[2];
    double ce0I = _stateVector[3];

    // Equations of motion incorporating severe metal Ohmic damping (γ_pl / 2)
    // dc_g1 / dt = -i * Δ * c_g1 - i * g * c_e0 - (γ_pl / 2) * c_g1
    // dc_e0 / dt = -i * g * c_g1
    double dcg1R =
        (_detuningDelta * cg1I) +
        (_couplingG * ce0I) -
        (_plasmonLossGamma / 2.0 * cg1R);
    double dcg1I =
        -(_detuningDelta * cg1R) -
        (_couplingG * ce0R) -
        (_plasmonLossGamma / 2.0 * cg1I);

    double dce0R = (_couplingG * cg1I);
    double dce0I = -(_couplingG * cg1R);

    // Forward Euler step integration
    cg1R += dcg1R * dt;
    cg1I += dcg1I * dt;
    ce0R += dce0R * dt;
    ce0I += dce0I * dt;

    // Unitary re-normalization trace preserving active quantum populations
    double norm = math.sqrt(
      cg1R * cg1R + cg1I * cg1I + ce0R * ce0R + ce0I * ce0I,
    );
    if (norm > 0) {
      cg1R /= norm;
      cg1I /= norm;
      ce0R /= norm;
      ce0I /= norm;
    }

    _stateVector = [cg1R, cg1I, ce0R, ce0I];

    // Map probability of finding a Surface Plasmon Polariton (SPP)
    double pPlasmon = (cg1R * cg1R) + (cg1I * cg1I);
    _plasmonProbabilityHistory.add(pPlasmon);
    if (_plasmonProbabilityHistory.length > _maxHistoryPoints) {
      _plasmonProbabilityHistory.removeAt(0);
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
    double pPlasmon =
        (_stateVector[0] * _stateVector[0]) +
        (_stateVector[1] * _stateVector[1]);
    double pExcited =
        (_stateVector[2] * _stateVector[2]) +
        (_stateVector[3] * _stateVector[3]);

    Widget visualizationPanel = Card(
      color: const Color(0xFF0D0A14),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Surface Plasmon Polariton (SPP) Near-Field',
              style: TextStyle(
                fontSize: 14,
                color: Colors.amberAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: PlasmonicFieldPainter(
                  pPlasmon: pPlasmon,
                  pExcited: pExcited,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget controlsPanel = Column(
      children: [
        // Controls Deck
        Card(
          color: const Color(0xFF131026),
          margin: const EdgeInsets.all(6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildSliderRow(
                  'Coupling (g)',
                  _couplingG,
                  1.0,
                  15.0,
                  Colors.deepOrangeAccent,
                  (v) => setState(() => _couplingG = v),
                ),
                _buildSliderRow(
                  'Detuning (Δ)',
                  _detuningDelta,
                  -5.0,
                  5.0,
                  Colors.cyanAccent,
                  (v) => setState(() => _detuningDelta = v),
                ),
                _buildSliderRow(
                  'Ohmic Loss (γ)',
                  _plasmonLossGamma,
                  0.0,
                  5.0,
                  Colors.redAccent,
                  (v) => setState(() => _plasmonLossGamma = v),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.bolt, size: 14),
                  label: const Text(
                    'Pulse Quantum Emitter',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: _resetPlasmonicSystem,
                ),
              ],
            ),
          ),
        ),
        // History Graph
        Expanded(
          child: Card(
            color: const Color(0xFF131026),
            margin: const EdgeInsets.all(6),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Plasmon Population History P(|g,1⟩)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: PlasmonicChartPainter(
                        history: _plasmonProbabilityHistory,
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
        title: const Text('Quantum Plasmonics Core Lab'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFF06040A),
      body: isLandscape
          ? Row(
              children: [
                Expanded(flex: 4, child: visualizationPanel),
                Expanded(flex: 3, child: controlsPanel),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 4, child: visualizationPanel),
                Expanded(flex: 4, child: controlsPanel),
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
          width: 90,
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

class PlasmonicFieldPainter extends CustomPainter {
  final double pPlasmon;
  final double pExcited;
  PlasmonicFieldPainter({required this.pPlasmon, required this.pExcited});

  @override
  void paint(Canvas canvas, Size size) {
    Offset baseLine = Offset(0, size.height * 0.65);
    Offset emitterPos = Offset(size.width * 0.35, size.height * 0.45);

    // 1. Draw Metallic Nanowire / Waveguide Interface Profile (The Metal-Dielectric interface)
    final Paint metalPaint = Paint()
      ..color = const Color(0xFF4A4A5A)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, baseLine.dy, size.width, size.height - baseLine.dy),
      metalPaint,
    );

    final Paint interfaceLine = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, baseLine.dy),
      Offset(size.width, baseLine.dy),
      interfaceLine,
    );

    // 2. Draw Evanescently Bound Surface Plasmon Waveform hugging the metal boundary
    if (pPlasmon > 0.01) {
      final Path plasmonPath = Path();
      plasmonPath.moveTo(0, baseLine.dy);

      for (double x = 0; x <= size.width; x += 2) {
        // Models decay length moving away from emitter position along waveguide
        double distanceFactor = math.exp(
          -(x - emitterPos.dx).abs() / (size.width * 0.35),
        );

        // Evanescent decay moving upward vertically into the dielectric zone
        double waveY =
            baseLine.dy -
            (30.0 * pPlasmon * distanceFactor) * (math.sin(x * 0.08).abs());
        if (x == 0) {
          plasmonPath.moveTo(x, waveY);
        } else {
          plasmonPath.lineTo(x, waveY);
        }
      }

      final Paint plasmonPaint = Paint()
        ..color = Colors.amberAccent.withOpacity(0.2 + (pPlasmon * 0.5))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawPath(plasmonPath, plasmonPaint);
    }

    // 3. Central Localized Quantum Dot Emitter Node
    final Paint emitterGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(
            Colors.blueGrey,
            Colors.purpleAccent,
            pExcited,
          )!.withOpacity(0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: emitterPos, radius: 35.0));
    canvas.drawCircle(emitterPos, 35.0, emitterGlow);
    final Paint emitterCore = Paint()
      ..color = Color.lerp(Colors.cyan, Colors.pinkAccent, pExcited)!;
    canvas.drawCircle(emitterPos, 7.0, emitterCore);
    // Draw coupling link indicator line showing dipole interaction zone
    final Paint couplingWire = Paint()
      ..color = Colors.white30
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(
      emitterPos,
      Offset(emitterPos.dx, baseLine.dy),
      couplingWire,
    );
  }

  @override
  bool shouldRepaint(covariant PlasmonicFieldPainter oldDelegate) => true;
}

class PlasmonicChartPainter extends CustomPainter {
  final List history;
  PlasmonicChartPainter({required this.history});
  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;
    final Paint borderPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
    final Path path = Path();
    double stepX = size.width / 70.0;
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
      ..strokeWidth = 2.0;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant PlasmonicChartPainter oldDelegate) => true;
}
