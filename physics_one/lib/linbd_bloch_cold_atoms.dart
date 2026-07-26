import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const ColdAtomFullSuiteApp());

class ColdAtomFullSuiteApp extends StatelessWidget {
  const ColdAtomFullSuiteApp({super.key});

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

  // Physical parameters
  double _rabiFrequency = 4.0;
  double _detuning = 0.0;
  double _blockadeRadius = 1.5;
  double _decayRate = 0.3; // Lindblad spontaneous emission rate (γ)

  // System Matrix Grid [Real c0, Imag c0, Real c1, Imag c1]
  late List<List<List<double>>> _wavefunctions;

  // Coordinate pointer tracking selected atom for the Bloch Sphere panel
  int _selectedRow = 0;
  int _selectedCol = 0;

  @override
  void initState() {
    super.initState();
    _resetLab();
    _ticker = createTicker((elapsed) {
      double currentTime = elapsed.inMicroseconds / 1000000.0;
      double dt = currentTime - _lastTime;
      if (dt > 0.04) dt = 0.04;
      _lastTime = currentTime;

      setState(() {
        _evolveSystemWithDecay(dt);
      });
    });
    _ticker.start();
  }

  void _resetLab() {
    _wavefunctions = List.generate(
      4,
      (_) => List.generate(4, (_) => [1.0, 0.0, 0.0, 0.0]),
    );
  }

  // Solves numerical evolution using a non-Hermitian Hamiltonian matching Lindblad relaxation paths
  void _evolveSystemWithDecay(double dt) {
    if (dt <= 0) return;

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        var state = _wavefunctions[r][c];
        double c0r = state as double,
            c0i = state as double,
            c1r = state as double,
            c1i = state as double;

        // Interaction Blockade shift computations
        double blockadeShift = 0.0;
        for (int or = 0; or < 4; or++) {
          for (int oc = 0; oc < 4; oc++) {
            if (or == r && oc == c) continue;
            double dist = math.sqrt(math.pow(r - or, 2) + math.pow(c - oc, 2));
            if (dist <= _blockadeRadius && dist > 0) {
              double p1Other =
                  _wavefunctions[or][oc][2] * _wavefunctions[or][oc][2] +
                  _wavefunctions[or][oc][3] * _wavefunctions[or][oc][3];
              blockadeShift += p1Other * (5.0 / math.pow(dist, 6));
            }
          }
        }

        double effectiveDetuning = _detuning - blockadeShift;

        // Differential solver terms incorporating Lindblad non-Hermitian state damping (-i * γ/2 * c1)
        double dc0r = -(_rabiFrequency / 2.0) * c1i;
        double dc0i = (_rabiFrequency / 2.0) * c1r;

        double dc1r =
            -(_rabiFrequency / 2.0) * c0i +
            effectiveDetuning * c1i -
            (_decayRate / 2.0) * c1r;
        double dc1i =
            (_rabiFrequency / 2.0) * c0r -
            effectiveDetuning * c1r -
            (_decayRate / 2.0) * c1i;

        c0r += dc0r * dt;
        c0i += dc0i * dt;
        c1r += dc1r * dt;
        c1i += dc1i * dt;

        // Unitary tracking reset
        double norm = math.sqrt(c0r * c0r + c0i * c0i + c1r * c1r + c1i * c1i);
        if (norm > 0) {
          c0r /= norm;
          c0i /= norm;
          c1r /= norm;
          c1i /= norm;
        }

        _wavefunctions[r][c] = [c0r, c0i, c1r, c1i];
      }
    }
  }

  void _selectAtom(Offset localPos, Size widgetSize) {
    int col = (localPos.dx / (widgetSize.width / 4)).clamp(0, 3).toInt();
    int row = (localPos.dy / (widgetSize.height / 4)).clamp(0, 3).toInt();
    setState(() {
      _selectedRow = row;
      _selectedCol = col;
      // Pump selected cell into transition space to kickstart rotation visualization
      _wavefunctions[row][col] = [0.707, 0.0, 0.707, 0.0];
    });
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
    var selectedQubit = _wavefunctions[_selectedRow][_selectedCol];

    Widget arrayPanel = Card(
      color: const Color(0xFF0A0A18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size =
              math.min(constraints.maxWidth, constraints.maxHeight) * 0.9;
          return Center(
            child: SizedBox(
              width: size,
              height: size,
              child: GestureDetector(
                onTapDown: (d) =>
                    _selectAtom(d.localPosition, Size(size, size)),
                child: CustomPaint(
                  painter: GasLatticePainter(
                    states: _wavefunctions,
                    selRow: _selectedRow,
                    selCol: _selectedCol,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    Widget diagnosticPanel = Column(
      children: [
        // Controls configuration deck
        Card(
          color: const Color(0xFF0A0A18),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                  'Decay (γ)',
                  _decayRate,
                  0.0,
                  4.0,
                  Colors.lightGreenAccent,
                  (v) => setState(() => _decayRate = v),
                ),
              ],
            ),
          ),
        ),
        // Interactive Bloch sphere panel frame
        Expanded(
          child: Card(
            color: const Color(0xFF04040A),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Bloch Sphere Analyzer (Atom [$_selectedRow,$_selectedCol])',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: BlochSpherePainter(qubitState: selectedQubit),
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
        title: const Text('Lindblad & Bloch Diagnostics Laboratory'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF020205),
      body: isLandscape
          ? Row(
              children: [
                Expanded(flex: 4, child: arrayPanel),
                Expanded(flex: 3, child: diagnosticPanel),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 4, child: arrayPanel),
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
          width: 75,
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

class GasLatticePainter extends CustomPainter {
  final List<List<List<double>>> states;
  final int selRow, selCol;
  GasLatticePainter({
    required this.states,
    required this.selRow,
    required this.selCol,
  });

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

        if (r == selRow && c == selCol) {
          final Paint selectionRing = Paint()
            ..color = Colors.pinkAccent
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;
          canvas.drawCircle(center, step * 0.45, selectionRing);
        }

        final Paint atom = Paint()
          ..color = Color.lerp(Colors.blueGrey, Colors.amberAccent, p1)!;
        canvas.drawCircle(center, 6.0 + (3.0 * p1), atom);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GasLatticePainter oldDelegate) => true;
}

class BlochSpherePainter extends CustomPainter {
  final List<double> qubitState;
  BlochSpherePainter({required this.qubitState});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = math.min(size.width, size.height) * 0.38;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Compute standard quantum expectation values (Pauli Spin vector coordinates)
    // x = 2 * Real(c0 * conj(c1))
    // y = 2 * Imag(c0 * conj(c1))
    // z = |c0|² - |c1|²
    double c0r = qubitState[0], c0i = qubitState[1];
    double c1r = qubitState[2], c1i = qubitState[3];

    double xCoord = 2.0 * (c0r * c1r + c0i * c1i);
    double yCoord = 2.0 * (c0i * c1r - c0r * c1i);
    double zCoord = (c0r * c0r + c0i * c0i) - (c1r * c1r + c1i * c1i);

    // Isometric 3D projection parameters onto 2D viewport
    double px = center.dx + radius * (xCoord * 0.7 - yCoord * 0.4);
    double py = center.dy - radius * (zCoord * 0.9 + yCoord * 0.3);

    // Draw main structural sphere outline
    final Paint sphereWire = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, sphereWire);
    canvas.drawOval(
      Rect.fromLTRB(
        center.dx - radius,
        center.dy - radius * 0.25,
        center.dx + radius,
        center.dy + radius * 0.25,
      ),
      sphereWire,
    );

    // Draw reference axes lines
    final Paint axisPaint = Paint()..color = Colors.white10;
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      axisPaint,
    );
    // Z Axis// Draw the active state vector pointing to coordinate locus
    final Paint vectorPaint = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(center, Offset(px, py), vectorPaint);
    canvas.drawCircle(Offset(px, py), 4.0, Paint()..color = Colors.cyanAccent);
  }

  @override
  bool shouldRepaint(covariant BlochSpherePainter oldDelegate) => true;
}
