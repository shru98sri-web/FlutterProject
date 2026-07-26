import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const QEDSimulationApp());

class QEDSimulationApp extends StatelessWidget {
  const QEDSimulationApp({super.key});

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

  // QED Physical Parameters
  double _couplingG = 3.5; // Vacuum Rabi coupling strength (g)
  double _detuningDelta = 0.0; // Atom-cavity detuning (Δ)
  double _cavityLossKappa = 0.15; // Cavity photon decay rate (κ)

  // System State Vectors: Truncated Basis Space [|g,1⟩, |e,0⟩]
  // Format: [Real c_g1, Imag c_g1, Real c_e0, Imag c_e0]
  // Initial state initialized to |e,0⟩ (Atom excited, 0 photons in cavity)
  late List<double> _stateVector;

  // Historical Rolling Buffer for live tracking
  final List<double> _photonProbabilityHistory = [];
  final int _maxHistoryPoints = 80;

  @override
  void initState() {
    super.initState();
    _resetQEDSystem();

    _ticker = createTicker((elapsed) {
      final double currentTime = elapsed.inMicroseconds / 1000000.0;
      double dt = currentTime - _lastTime;
      if (dt > 0.04) dt = 0.04; // Safety clamp against structural frame lags
      _lastTime = currentTime;

      setState(() {
        _evolveQEDSystem(dt);
      });
    });
    _ticker.start();
  }

  void _resetQEDSystem() {
    _stateVector = [0.0, 0.0, 1.0, 0.0]; // Pure state: |e,0⟩
    _photonProbabilityHistory.clear();
  }

  // Non-Hermitian Schrödinger equation engine solving the Jaynes-Cummings interaction matrix
  void _evolveQEDSystem(double dt) {
    if (dt <= 0) return;

    double cg1R = _stateVector[0];
    double cg1I = _stateVector[1];
    double ce0R = _stateVector[2];
    double ce0I = _stateVector[3];

    // Derivatives derived from H_eff = Δ|g,1⟩⟨g,1| + g(|e,0⟩⟨g,1| + |g,1⟩⟨e,0|) - i(κ/2)|g,1⟩⟨g,1|
    // dc_g1 / dt = -i * Δ * c_g1 - i * g * c_e0 - (κ / 2) * c_g1
    // dc_e0 / dt = -i * g * c_g1
    double dcg1R =
        (_detuningDelta * cg1I) +
        (_couplingG * ce0I) -
        (_cavityLossKappa / 2.0 * cg1R);
    double dcg1I =
        -(_detuningDelta * cg1R) -
        (_couplingG * ce0R) -
        (_cavityLossKappa / 2.0 * cg1I);

    double dce0R = (_couplingG * cg1I);
    double dce0I = -(_couplingG * cg1R);

    // Apply incremental Euler time-step integration updates
    cg1R += dcg1R * dt;
    cg1I += dcg1I * dt;
    ce0R += dce0R * dt;
    ce0I += dce0I * dt;

    // Norm re-balancing loop preserving mathematical vector boundaries
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

    // Map the probability of a photon existing in the cavity: P(|g,1⟩)
    double pPhoton = (cg1R * cg1R) + (cg1I * cg1I);
    _photonProbabilityHistory.add(pPhoton);
    if (_photonProbabilityHistory.length > _maxHistoryPoints) {
      _photonProbabilityHistory.removeAt(0);
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
    double pPhoton =
        (_stateVector[0] * _stateVector[0]) +
        (_stateVector[1] * _stateVector[1]);
    double pExcited =
        (_stateVector[2] * _stateVector[2]) +
        (_stateVector[3] * _stateVector[3]);

    Widget visualizationPanel = Card(
      color: const Color(0xFF090915),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Cavity QED Field Manifestation',
              style: TextStyle(
                fontSize: 14,
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: QEDFieldPainter(pPhoton: pPhoton, pExcited: pExcited),
              ),
            ),
          ],
        ),
      ),
    );

    Widget controlsPanel = Column(
      children: [
        // Real-Time Parametric Slider Group
        Card(
          color: const Color(0xFF0F0F26),
          margin: const EdgeInsets.all(6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildSliderRow(
                  'Coupling (g)',
                  _couplingG,
                  0.0,
                  10.0,
                  Colors.orangeAccent,
                  (v) => setState(() => _couplingG = v),
                ),
                _buildSliderRow(
                  'Detuning (Δ)',
                  _detuningDelta,
                  -5.0,
                  5.0,
                  Colors.tealAccent,
                  (v) => setState(() => _detuningDelta = v),
                ),
                _buildSliderRow(
                  'Loss (κ)',
                  _cavityLossKappa,
                  0.0,
                  2.0,
                  Colors.redAccent,
                  (v) => setState(() => _cavityLossKappa = v),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 14),
                  label: const Text(
                    'Re-Inject Photon State',
                    style: TextStyle(fontSize: 11),
                  ),
                  onPressed: _resetQEDSystem,
                ),
              ],
            ),
          ),
        ),
        // Live Population Spectral Plot Window
        Expanded(
          child: Card(
            color: const Color(0xFF0F0F26),
            margin: const EdgeInsets.all(6),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Photon Probability Waveform Time History',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: QEDChartPainter(
                        history: _photonProbabilityHistory,
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
        title: const Text('QED Jaynes-Cummings Engine'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFF04040C),
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
          width: 85,
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

class QEDFieldPainter extends CustomPainter {
  final double pPhoton;
  final double pExcited;
  QEDFieldPainter({required this.pPhoton, required this.pExcited});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    // 1. Draw Optical Cavity Mirror Frame Elements
    final Paint mirrorPaint = Paint()
      ..color = Colors.white38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.15, size.height * 0.8),
      mirrorPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.85, size.height * 0.2),
      Offset(size.width * 0.85, size.height * 0.8),
      mirrorPaint,
    );

    // 2. Draw Electromagnetic Photon Standing Field Waves inside the Cavity
    if (pPhoton > 0.01) {
      final Path wavePath = Path();
      double waveAmplitude = 25.0 * pPhoton;
      wavePath.moveTo(size.width * 0.15, center.dy);

      for (double x = size.width * 0.15; x <= size.width * 0.85; x += 1) {
        double relativeX = (x - size.width * 0.15) / (size.width * 0.7);
        double y =
            center.dy + waveAmplitude * math.sin(relativeX * 3.0 * math.pi);
        wavePath.lineTo(x, y);
      }

      final Paint wavePaint = Paint()
        ..color = Colors.cyanAccent.withOpacity(0.15 + (0.45 * pPhoton))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawPath(wavePath, wavePaint);
    }

    // 3. Central Trapped Qubit Atom Visualization
    final Paint atomicCloud = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(
            Colors.blueGrey,
            Colors.deepOrangeAccent,
            pExcited,
          )!.withOpacity(0.5),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 45.0));
    canvas.drawCircle(center, 45.0, atomicCloud);

    final Paint corePaint = Paint()
      ..color = Color.lerp(Colors.tealAccent, Colors.redAccent, pExcited)!;
    canvas.drawCircle(center, 6.0 + (5.0 * pExcited), corePaint);
  }

  @override
  bool shouldRepaint(covariant QEDFieldPainter oldDelegate) => true;
}

class QEDChartPainter extends CustomPainter {
  final List<double> history;
  QEDChartPainter({required this.history});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;

    final Paint borderPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
    final Path path = Path();
    double stepX = size.width / 80.0;
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
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant QEDChartPainter oldDelegate) => true;
}
