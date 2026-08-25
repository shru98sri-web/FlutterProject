import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const QuantumTimeEvolutionApp());
}

class QuantumTimeEvolutionApp extends StatelessWidget {
  const QuantumTimeEvolutionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Time Evolution',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const QuantumEvolutionSimulator(),
    );
  }
}

class QuantumEvolutionSimulator extends StatefulWidget {
  const QuantumEvolutionSimulator({super.key});

  @override
  State<QuantumEvolutionSimulator> createState() =>
      _QuantumEvolutionSimulatorState();
}

class _QuantumEvolutionSimulatorState extends State<QuantumEvolutionSimulator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Toggle State 1: Simulation Running / Paused
  bool _isEvolving = true;

  // Toggle State 2: Frequency Modifier (Normal ω vs Fast 2ω)
  bool _isFastFrequency = false;

  // Toggle State 3: Wavefunction Profile (Ground State vs First Excited State)
  bool _isFirstExcitedState = false;

  double _tau = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..addListener(() {
            if (_isEvolving) {
              setState(() {
                // Keep incrementing tau parameter dynamically
                _tau = _animationController.value * 2 * math.pi * 2;
              });
            }
          });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double omega = _isFastFrequency ? 3.0 : 1.5;
    double currentPhase = -omega * _tau;

    // Real and Imaginary coefficients for phase factors e^(-iωτ) = cos(-ωτ) + i sin(-ωτ)
    double realPart = math.cos(currentPhase);
    double imagPart = math.sin(currentPhase);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quantum State Phase Evolution'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dynamic Complex Equation Card
            Card(
              color: Colors.deepPurple.shade900.withOpacity(0.4),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'D̂ᵗ(τ)|ψ₀⟩ = e⁻ⁱᵂᵗ|ψ₀⟩',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Courier',
                        color: Colors.purpleAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Current Phase Value: ${realPart.toStringAsFixed(2)} + (${imagPart.toStringAsFixed(2)})i',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Courier',
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // The 3 Mandatory Interactive Toggle Switches Container
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Simulator Strategy Toggles',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(color: Colors.white24),

                    // Toggle 1: Time Evolution Engine Control
                    SwitchListTile(
                      title: const Text('Time Evolution (τ Engine)'),
                      subtitle: Text(
                        _isEvolving
                            ? 'Active Progression'
                            : 'Frozen Matrix State',
                      ),
                      value: _isEvolving,
                      activeColor: Colors.purpleAccent,
                      onChanged: (bool value) {
                        setState(() {
                          _isEvolving = value;
                          if (_isEvolving) {
                            _animationController.repeat();
                          } else {
                            _animationController.stop();
                          }
                        });
                      },
                    ),

                    // Toggle 2: Frequency Modifier (ω Speed)
                    SwitchListTile(
                      title: const Text('Frequency Mode (ω)'),
                      subtitle: Text(
                        _isFastFrequency
                            ? 'High Energy (3.0 rad/s)'
                            : 'Base Level (1.5 rad/s)',
                      ),
                      value: _isFastFrequency,
                      activeColor: Colors.cyanAccent,
                      onChanged: (bool value) {
                        setState(() {
                          _isFastFrequency = value;
                        });
                      },
                    ),

                    // Toggle 3: Quantum System Basis Eigenstate Vector Choose
                    SwitchListTile(
                      title: const Text('Wavefunction Vector Profile (|ψ₀⟩)'),
                      subtitle: Text(
                        _isFirstExcitedState
                            ? 'First Excited State (Nodes present)'
                            : 'Ground State Vector (Gaussian Peak)',
                      ),
                      value: _isFirstExcitedState,
                      activeColor: Colors.amberAccent,
                      onChanged: (bool value) {
                        setState(() {
                          _isFirstExcitedState = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Live Vector Phase Complex Space Diagram Drawing Area
            const Text(
              'Complex Phase Vector Tracker (Argand Space View)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  shape: BoxShape.circle,
                  color: Colors.black26,
                ),
                child: CustomPaint(
                  painter: PhaseVectorPainter(realPart, imagPart),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Probability Density Distribution Wave Profile Output UI Panel
            const Text(
              'Wavefunction Spatial Map Re[ψ(x)] vs |ψ(x)|²',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: CustomPaint(
                painter: WaveformPainter(realPart, _isFirstExcitedState),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Notice: While the real component (purple wave) oscillates dramatically through space time, the underlying spatial probability density (solid blue envelope line) remains rigidly immutable.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white54,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter to draw the complex plane vector tracking rotation
class PhaseVectorPainter extends CustomPainter {
  final double real;
  final double imag;
  PhaseVectorPainter(this.real, this.imag);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paintAxis = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;

    // Draw crosshair axes
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      paintAxis,
    );
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paintAxis,
    );

    // Draw rotating phase vector arm line arrow setup
    final targetPoint = Offset(
      center.dx + (real * (size.width / 2 - 10)),
      center.dy - (imag * (size.height / 2 - 10)),
    );
    final paintVector = Paint()
      ..color = Colors.purpleAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, targetPoint, paintVector);
    canvas.drawCircle(targetPoint, 5, Paint()..color = Colors.cyanAccent);
  }

  @override
  bool shouldRepaint(covariant PhaseVectorPainter oldDelegate) =>
      oldDelegate.real != real || oldDelegate.imag != imag;
}

// Custom Painter to compute spatial representation profile lines
class WaveformPainter extends CustomPainter {
  final double phaseFactor;
  final bool isExcited;
  WaveformPainter(this.phaseFactor, this.isExcited);

  @override
  void paint(Canvas canvas, Size size) {
    final paintRealWave = Paint()
      ..color = Colors.purple.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final paintProbability = Paint()
      ..color = Colors.cyan.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final pathReal = Path();
    final pathProb = Path();

    bool first = true;
    for (double x = 0; x <= size.width; x++) {
      double normalizedX =
          (x / size.width) * 4 -
          2; // maps range mapping bounds from -2 to +2// Calculate basic spatial wave profiles shape envelopes
      double envelope = math.exp(-normalizedX * normalizedX);
      if (isExcited) {
        envelope =
            envelope *
            normalizedX *
            2; // adds nodes characteristic to first excited states vectors}
        double realWaveY =
            (size.height / 2) - (envelope * phaseFactor * (size.height / 2.5));
        double probDensityY =
            (size.height / 2) - (envelope.abs() * (size.height / 2.5));
        if (first) {
          pathReal.moveTo(x, realWaveY);
          pathProb.moveTo(x, probDensityY);
          first = false;
        } else {
          pathReal.lineTo(x, realWaveY);
          pathProb.lineTo(x, probDensityY);
        }
      }
      canvas.drawPath(pathReal, paintRealWave);
      canvas.drawPath(pathProb, paintProbability);
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) =>
      oldDelegate.phaseFactor != phaseFactor ||
      oldDelegate.isExcited != isExcited;
}
