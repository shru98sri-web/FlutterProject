import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    home: UltimateQuantumSteeringLab(),
    debugShowCheckedModeBanner: false,
  ),
);

class UltimateQuantumSteeringLab extends StatefulWidget {
  const UltimateQuantumSteeringLab({super.key});

  @override
  State<UltimateQuantumSteeringLab> createState() =>
      _UltimateQuantumSteeringLabState();
}

class _UltimateQuantumSteeringLabState
    extends State<UltimateQuantumSteeringLab> {
  // 3D Camera Angles via Drag Gestures
  double _angleX = 0.35;
  double _angleY = 0.60;

  // Quantum Mechanics System Parameters
  double _purity = 0.85;
  double _asymmetry = 0.15;
  int _measurementSettings = 3; // N=2 vs N=3 Settings

  // Environmental Decoherence Noise Parameters
  double _amplitudeDamping = 0.0; // t parameter (0 = No Noise, 1 = Max Damping)
  double _phaseDephasing =
      0.0; // gamma parameter (0 = No Noise, 1 = Max Dephasing)

  // Alice Live Spherical Polar Coordinates
  double _aliceTheta = 1.0;
  double _alicePhi = 0.5;

  @override
  Widget build(BuildContext context) {
    // 1. Environmental Noise Channel Transformations
    // Amplitude Damping forces state populations toward the ground state |1⟩ (shifts Z axis offset)
    // Phase Dephasing dampens the off-diagonal coherence elements (shrinks X and Y axes)
    double effectivePurityX =
        _purity * (1.0 - _phaseDephasing) * math.sqrt(1.0 - _amplitudeDamping);
    double effectivePurityY =
        _purity * (1.0 - _phaseDephasing) * math.sqrt(1.0 - _amplitudeDamping);
    double effectivePurityZ =
        (_purity - _asymmetry) * (1.0 - _amplitudeDamping);

    // 2. Compute Cavalcanti Steering Bounds Criteria
    final double lhsThreshold = _measurementSettings == 3
        ? 1.0 / math.sqrt(3)
        : 0.5;

    // Evaluate steering ability inside the noisy, deformed quantum channel state
    final bool aliceCanSteerBob =
        effectivePurityX > lhsThreshold || effectivePurityZ > lhsThreshold;
    final bool bobCanSteerAlice =
        (effectivePurityX * (1.0 - _asymmetry)) > lhsThreshold;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text(
          'Quantum Steering & Decoherence Lab',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTopRegimeBanner(aliceCanSteerBob, bobCanSteerAlice),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _angleY += details.delta.dx * 0.01;
                  _angleX -= details.delta.dy * 0.01;
                });
              },
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: AdvancedLabPainter(
                    angleX: _angleX,
                    angleY: _angleY,
                    purityX: effectivePurityX,
                    purityY: effectivePurityY,
                    purityZ: effectivePurityZ,
                    aliceTheta: _aliceTheta,
                    alicePhi: _alicePhi,
                    aliceCanSteerBob: aliceCanSteerBob,
                    settingsCount: _measurementSettings,
                    dampingOffset:
                        _amplitudeDamping * -30.0, // Visual shift down
                  ),
                ),
              ),
            ),
          ),
          _buildLiveDataTable(effectivePurityX, effectivePurityZ, lhsThreshold),
          _buildControlDeck(),
        ],
      ),
    );
  }

  Widget _buildTopRegimeBanner(bool aToB, bool bToA) {
    Color bannerColor = Colors.redAccent;
    String bannerText = 'CLASSICAL REGIME: NO STEERING POSSIBLE';

    if (aToB && !bToA) {
      bannerColor = Colors.amberAccent;
      bannerText = 'ONE-WAY ASYMMETRIC QUANTUM STEERING';
    } else if (aToB && bToA) {
      bannerColor = Colors.greenAccent;
      bannerText = 'TWO-WAY SYMMETRIC QUANTUM STEERING';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFF1F242C),
      child: Center(
        child: Text(
          bannerText,
          style: TextStyle(
            color: bannerColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildLiveDataTable(double pX, double pZ, double threshold) {
    return Container(
      color: const Color(0xFF161B22),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Table(
        border: TableBorder.all(
          color: Colors.white10,
          width: 1,
          borderRadius: BorderRadius.circular(4),
        ),
        children: [
          TableRow(
            children:
                [
                      'Channel Vector',
                      'Effective Matrix Value',
                      'LHS Bound',
                      'Status',
                    ]
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          e,
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
          ),
          _buildDataRow(
            'Alice ➔ Bob (X Axis)',
            pX.toStringAsFixed(3),
            threshold.toStringAsFixed(3),
            pX > threshold ? 'STEERABLE' : 'BLOCKED',
            pX > threshold,
          ),
          _buildDataRow(
            'Alice ➔ Bob (Z Axis)',
            pZ.toStringAsFixed(3),
            threshold.toStringAsFixed(3),
            pZ > threshold ? 'STEERABLE' : 'BLOCKED',
            pZ > threshold,
          ),
        ],
      ),
    );
  }

  TableRow _buildDataRow(
    String label,
    String val,
    String bound,
    String status,
    bool pass,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 9),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            val,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 9,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            bound,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            status,
            style: TextStyle(
              color: pass ? Colors.greenAccent : Colors.redAccent,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildControlDeck() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: const Color(0xFF161B22),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Settings Selector:',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                DropdownButton<int>(
                  value: _measurementSettings,
                  dropdownColor: const Color(0xFF161B22),
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 11,
                  ),
                  isDense: true,
                  items: const [
                    DropdownMenuItem(
                      value: 2,
                      child: Text('N = 2 (X, Z Measurement Settings)'),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text('N = 3 (X, Y, Z Mutually Unbiased Basis)'),
                    ),
                  ],
                  onChanged: (val) =>
                      setState(() => _measurementSettings = val!),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _sliderControl(
              'Purity Parameter (p)',
              _purity,
              (val) => setState(() => _purity = val),
            ),
            _sliderControl(
              'Asymmetry Delta (Δ)',
              _asymmetry,
              (val) => setState(() => _asymmetry = val),
            ),
            _sliderControl(
              'Amplitude Damping (t)',
              _amplitudeDamping,
              (val) => setState(() => _amplitudeDamping = val),
              activeColor: Colors.orangeAccent,
            ),
            _sliderControl(
              'Phase Dephasing (γ)',
              _phaseDephasing,
              (val) => setState(() => _phaseDephasing = val),
              activeColor: Colors.pinkAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderControl(
    String label,
    double val,
    ValueChanged<double> change, {
    Color activeColor = Colors.deepPurpleAccent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ),
          Expanded(
            flex: 6,
            child: Slider(
              value: val,
              min: 0.0,
              max: 1.0,
              activeColor: activeColor,
              inactiveColor: Colors.white10,
              onChanged: change,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              val.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 10,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class AdvancedLabPainter extends CustomPainter {
  final double angleX;
  final double angleY;
  final double purityX;
  final double purityY;
  final double purityZ;
  final double aliceTheta;
  final double alicePhi;
  final bool aliceCanSteerBob;
  final int settingsCount;
  final double
  dampingOffset; // Shifts center of the ellipsoid downward physically

  AdvancedLabPainter({
    required this.angleX,
    required this.angleY,
    required this.purityX,
    required this.purityY,
    required this.purityZ,
    required this.aliceTheta,
    required this.alicePhi,
    required this.aliceCanSteerBob,
    required this.settingsCount,
    required this.dampingOffset,
  });

  Offset project(double x, double y, double z, Size size) {
    double cx = size.width / 2;
    double cy = size.height / 2;

    // Apply 3D Matrix Rotations
    double cosY = math.cos(angleY);
    double sinY = math.sin(angleY);
    double xRot = x * cosY - z * sinY;
    double zRot1 = x * sinY + z * cosY;

    double cosX = math.cos(angleX);
    double sinX = math.sin(angleX);
    double yRot = y * cosX - zRot1 * sinX;
    double scale = 110.0;
    return Offset(cx + xRot * scale, cy - yRot * scale);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // 1. Draw Absolute Pure Bloch Limit Boundary
    canvas.drawCircle(
      center,
      110.0,
      Paint()
        ..color = Colors.white.withOpacity(0.02)
        ..style = PaintingStyle.stroke,
    );
    // 2. Draw Quantum Coordinate Reference Framing Axis Lines
    final axisPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1.0;
    canvas.drawLine(
      project(-1.1, 0, 0, size),
      project(1.1, 0, 0, size),
      axisPaint,
    );
    canvas.drawLine(
      project(0, -1.1, 0, size),
      project(0, 1.1, 0, size),
      axisPaint,
    );
    canvas.drawLine(
      project(0, 0, -1.1, size),
      project(0, 0, 1.1, size),
      axisPaint,
    );
    // 3. Render Shrunken Asymmetric, Decohered Volume Envelope
    final volumePaint = Paint()
      ..color = aliceCanSteerBob
          ? Colors.greenAccent.withOpacity(0.12)
          : Colors.redAccent.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    final wireframePaint = Paint()
      ..color = aliceCanSteerBob
          ? Colors.greenAccent.withOpacity(0.35)
          : Colors.redAccent.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    // Equator Trace Ring Profile Configuration
    final Path equator = Path();
    for (int i = 0; i <= 360; i += 10) {
      double r = i * math.pi / 180;
      // Convert angular projections to Cartesian space, then apply the visual dampingOffset
      Offset p = project(
        math.cos(r) * purityX,
        math.sin(r) * purityY,
        0.0 + (dampingOffset / 110.0),
        size,
      );
      if (i == 0)
        equator.moveTo(p.dx, p.dy);
      else
        equator.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(equator, volumePaint);
    canvas.drawPath(equator, wireframePaint);
    // Longitudinal Trace Ring Profile Configuration
    final Path longitudinal = Path();
    for (int i = 0; i <= 360; i += 10) {
      double r = i * math.pi / 180;
      Offset p = project(
        0.0,
        math.cos(r) * purityY,
        math.sin(r) * purityZ + (dampingOffset / 110.0),
        size,
      );
      if (i == 0)
        longitudinal.moveTo(p.dx, p.dy);
      else
        longitudinal.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(longitudinal, wireframePaint);
    // 4. Transform and Draw Active Selected Projective Measurement Vectors
    double ax = math.sin(aliceTheta) * math.cos(alicePhi);
    double ay = settingsCount == 3
        ? math.sin(aliceTheta) * math.sin(alicePhi)
        : 0.0;
    double az = math.cos(aliceTheta);
    // Bob collapses asymmetric values to the opposite poles adjusted by decoherence matrix parameters
    double bx = -ax * purityX;
    double by = -ay * purityY;
    double bz = (-az * purityZ) + (dampingOffset / 110.0);
    Offset alicePt = project(ax, ay, az, size);
    Offset bobPt = project(bx, by, bz, size); // Render Vector Pointer Lines
    canvas.drawLine(
      center,
      alicePt,
      Paint()
        ..color = Colors.deepPurpleAccent
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      center,
      bobPt,
      Paint()
        ..color = aliceCanSteerBob ? Colors.greenAccent : Colors.orangeAccent
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(alicePt, 4, Paint()..color = Colors.deepPurpleAccent);
    canvas.drawCircle(
      bobPt,
      4,
      Paint()
        ..color = aliceCanSteerBob ? Colors.greenAccent : Colors.orangeAccent,
    );
  }

  @override
  bool shouldRepaint(covariant AdvancedLabPainter oldDelegate) => true;
}
