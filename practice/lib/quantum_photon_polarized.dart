import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const PhotonPolarizationApp());
}

class PhotonPolarizationApp extends StatelessWidget {
  const PhotonPolarizationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photon Spin Matrix Simulator',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
      ),
      home: const PhotonSimulationHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PhotonSimulationHome extends StatefulWidget {
  const PhotonSimulationHome({super.key});

  @override
  State<PhotonSimulationHome> createState() => _PhotonSimulationHomeState();
}

class _PhotonSimulationHomeState extends State<PhotonSimulationHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _timeController;

  // Toggles and State Sliders
  double _phiAngle = 0.0; // Rotation angle φ in radians
  bool _isRightHanded =
      true; // State toggle: true = |R⟩ (m=+1), false = |L⟩ (m=-1)
  bool _animateTime = true; // Simulates the wave propagation phase

  double _currentTimePhase = 0.0;

  @override
  void initState() {
    super.initState();
    _timeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addListener(() {
            if (_animateTime) {
              setState(() {
                _currentTimePhase = _timeController.value * 2 * math.pi;
              });
            }
          });
    _timeController.repeat();
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Computing Transformation matrix elements derived from Feynman Table 17-3
    // R_z(φ)|R⟩ = e^(+iφ)|R⟩  ==> Cos(φ) + i Sin(φ)
    // R_z(φ)|L⟩ = e^(-iφ)|L⟩  ==> Cos(-φ) + i Sin(-φ) = Cos(φ) - i Sin(φ)
    double matrixReal = math.cos(_phiAngle);
    double matrixImag = _isRightHanded
        ? math.sin(_phiAngle)
        : -math.sin(_phiAngle);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photon Rotation Matrix (Table 17-3)'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // State Display Matrix Card
            Card(
              color: Colors.amber.shade900.withOpacity(0.15),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _isRightHanded
                          ? 'State: |R⟩ (m = +1)'
                          : 'State: |L⟩ (m = -1)',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _isRightHanded
                            ? Colors.amberAccent
                            : Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isRightHanded
                          ? 'R_z(ϕ)|R⟩ = e⁺ⁱᵠ|R⟩ = (${matrixReal.toStringAsFixed(2)} + ${matrixImag.toStringAsFixed(2)}i) |R⟩'
                          : 'R_z(ϕ)|L⟩ = e⁻ⁱᵠ|L⟩ = (${matrixReal.toStringAsFixed(2)} + ${matrixImag.toStringAsFixed(2)}i) |L⟩',
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Controls Segment
            const Text(
              'System Setup & Inputs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // State Selection Row Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip(
                          label: const Text('|R⟩ State (RHC)'),
                          selected: _isRightHanded,
                          selectedColor: Colors.amber.shade700,
                          onSelected: (val) =>
                              setState(() => _isRightHanded = true),
                        ),
                        ChoiceChip(
                          label: const Text('|L⟩ State (LHC)'),
                          selected: !_isRightHanded,
                          selectedColor: Colors.cyan.shade700,
                          onSelected: (val) =>
                              setState(() => _isRightHanded = false),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Angle Selector Slider
                    Text(
                      'Z-Axis Spatial Rotation Angle (ϕ): ${(_phiAngle * 180 / math.pi).toStringAsFixed(0)}°',
                    ),
                    Slider(
                      value: _phiAngle,
                      min: 0,
                      max: 2 * math.pi,
                      divisions: 72,
                      activeColor: Colors.amberAccent,
                      onChanged: (val) => setState(() => _phiAngle = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Canvas Output Grid Panels
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Complex Phase Unit Plane',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          border: Border.all(color: Colors.white12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomPaint(
                          size: const Size(double.infinity, 160),
                          painter: PhasePlanePainter(
                            real: matrixReal,
                            imag: matrixImag,
                            isRhc: _isRightHanded,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Electric Field Profile (X-Y)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          border: Border.all(color: Colors.white12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomPaint(
                          size: const Size(double.infinity, 160),
                          painter: FieldVectorPainter(
                            phi: _phiAngle,
                            timePhase: _currentTimePhase,
                            isRhc: _isRightHanded,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Operator Transformation Matrix Definition Table Visual Layout
            const Text(
              'Feynman Basis Table 17-3 Transformation Matrix',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: Colors.white24),
              children: [
                TableRow(
                  children: const [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          'R_z(ϕ)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          '|R⟩ Basis',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          '|L⟩ Basis',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text('⟨R| (Row)'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          'e⁺ⁱᵠ\n(${matrixReal.toStringAsFixed(1)} + ${math.sin(_phiAngle).toStringAsFixed(1)}i)',
                          style: TextStyle(
                            color: _isRightHanded
                                ? Colors.amberAccent
                                : Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          '0',
                          style: TextStyle(color: Colors.white24),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text('⟨L| (Row)'),
                      ),
                    ),
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          '0',
                          style: TextStyle(color: Colors.white24),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          'e⁻ⁱᵠ\n(${matrixReal.toStringAsFixed(1)} - ${math.sin(_phiAngle).toStringAsFixed(1)}i)',
                          style: TextStyle(
                            color: !_isRightHanded
                                ? Colors.cyanAccent
                                : Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter to plot the complex transformation phase rotation vector
class PhasePlanePainter extends CustomPainter {
  final double real;
  final double imag;
  final bool isRhc;
  PhasePlanePainter({
    required this.real,
    required this.imag,
    required this.isRhc,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 12;
    final axisPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      axisPaint,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white10
        ..style = PaintingStyle.stroke,
    );
    final vectorPaint = Paint()
      ..color = isRhc ? Colors.amberAccent : Colors.cyanAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final targetPoint = Offset(
      center.dx + (real * radius),
      center.dy - (imag * radius),
    );
    canvas.drawLine(center, targetPoint, vectorPaint);
    canvas.drawCircle(targetPoint, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant PhasePlanePainter oldDelegate) =>
      oldDelegate.real != real ||
      oldDelegate.imag != imag ||
      oldDelegate.isRhc != isRhc;
}

// Custom Painter to draw the structural spinning projection trace of the E field vector
class FieldVectorPainter extends CustomPainter {
  final double phi;
  final double timePhase;
  final bool isRhc;
  FieldVectorPainter({
    required this.phi,
    required this.timePhase,
    required this.isRhc,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = math.min(size.width, size.height) / 2.5;
    // Draw coordinate axes
    final gridPaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      gridPaint,
    );
    // Calculate dynamic E-field vector components including time evolution and spatial shift z-rotation
    // |R⟩ base: Ex = cos(t + φ), Ey = sin(t + φ)// |L⟩ base: Ex = cos(t - φ), Ey = -sin(t - φ)
    double compositeAngle = isRhc ? (timePhase + phi) : (timePhase - phi);
    double ex = math.cos(compositeAngle);
    double ey = isRhc ? math.sin(compositeAngle) : -math.sin(compositeAngle);
    final fieldVector = Offset(
      center.dx + (ex * scale),
      center.dy - (ey * scale),
    ); // Draw running tip history path envelope ring
    canvas.drawCircle(
      center,
      scale,
      Paint()
        ..color = Colors.white10
        ..style = PaintingStyle.stroke,
    ); // Draw active vector arm
    canvas.drawLine(
      center,
      fieldVector,
      Paint()
        ..color = Colors.orangeAccent
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(fieldVector, 5, Paint()..color = Colors.redAccent);
  }

  @override
  bool shouldRepaint(covariant FieldVectorPainter oldDelegate) =>
      oldDelegate.phi != phi ||
      oldDelegate.timePhase != timePhase ||
      oldDelegate.isRhc != isRhc;
}
