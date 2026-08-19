import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const VortexSimulationApp());
}

class VortexSimulationApp extends StatelessWidget {
  const VortexSimulationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Incompressible Euler Simulation',
      theme: ThemeData.dark(),
      home: const SimulationScreen(),
    );
  }
}

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<VortexParticle> _particles = [];
  final List<TracerParticle> _tracers = [];

  // Numerical Core Parameter (epsilon squared) to prevent infinite singularities
  final double _coreRadiusSq = 400.0;
  final double _dt = 0.15;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _initSimulation();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateSimulation);
    _controller.repeat();
  }

  void _initSimulation() {
    _particles.clear();
    _tracers.clear();

    // Setup an interacting, self-propelling vortex pair (Dipole)
    _particles.add(VortexParticle(const Offset(150, 450), 200.0));
    _particles.add(VortexParticle(const Offset(250, 450), -200.0));

    // Distribute a uniform grid of visual fluid tracer particles
    for (int i = 0; i < 25; i++) {
      for (int j = 0; j < 35; j++) {
        _tracers.add(TracerParticle(Offset(110.0 + i * 7, 100.0 + j * 8)));
      }
    }
  }

  void _updateSimulation() {
    if (_isPaused) return;

    int numVortices = _particles.length;
    List<Offset> vortexVelocities = List.filled(numVortices, Offset.zero);

    // 1. Calculate velocities of active vortex singularities mutually induced via Biot-Savart
    for (int i = 0; i < numVortices; i++) {
      double vx = 0;
      double vy = 0;
      for (int j = 0; j < numVortices; j++) {
        if (i == j) continue;

        double dx = _particles[i].pos.dx - _particles[j].pos.dx;
        double dy = _particles[i].pos.dy - _particles[j].pos.dy;
        double rSq = dx * dx + dy * dy;

        // Regularized kernel handling the denominator singularity
        double factor = _particles[j].circulation / (2 * math.pi * (rSq + _coreRadiusSq));
        vx += -dy * factor;
        vy += dx * factor;
      }
      vortexVelocities[i] = Offset(vx, vy);
    }

    // Move vortex centers forward
    for (int i = 0; i < numVortices; i++) {
      _particles[i].pos += vortexVelocities[i] * _dt;
    }

    // 2. Advect passive tracer elements along the resultant velocity vector field
    for (var tracer in _tracers) {
      double vx = 0;
      double vy = 0;
      for (var vortex in _particles) {
        double dx = tracer.pos.dx - vortex.pos.dx;
        double dy = tracer.pos.dy - vortex.pos.dy;
        double rSq = dx * dx + dy * dy;

        double factor = vortex.circulation / (2 * math.pi * (rSq + _coreRadiusSq));
        vx += -dy * factor;
        vy += dx * factor;
      }
      tracer.pos += Offset(vx, vy) * _dt;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Euler Incompressible Fluid'),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: () => setState(() => _isPaused = !_isPaused),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(_initSimulation),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 600,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan, width: 2),
            color: Colors.black,
          ),
          child: CustomPaint(
            painter: FluidPainter(particles: _particles, tracers: _tracers),
          ),
        ),
      ),
    );
  }
}

class VortexParticle {
  Offset pos;
  final double circulation;
  VortexParticle(this.pos, this.circulation);
}

class TracerParticle {
  Offset pos;
  TracerParticle(this.pos);
}

class FluidPainter extends CustomPainter {
  final List<VortexParticle> particles;
  final List<TracerParticle> tracers;

  FluidPainter({required this.particles, required this.tracers});

  @override
  void paint(Canvas canvas, Size size) {
    final tracerPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.5)
      ..strokeWidth = 2.0;

    final posVortexPaint = Paint()..color = Colors.redAccent;
    final negVortexPaint = Paint()..color = Colors.blueAccent;

    // Draw fluid tracers
    for (var t in tracers) {
      if (t.pos.dx >= 0 && t.pos.dx <= size.width && t.pos.dy >= 0 && t.pos.dy <= size.height) {
        canvas.drawCircle(t.pos, 1.2, tracerPaint);
      }
    }

    // Draw central driving singular core vortices
    for (var v in particles) {
      canvas.drawCircle(
          v.pos,
          7.0,
          v.circulation > 0 ? posVortexPaint : negVortexPaint
      );
    }
  }

  @override
  bool shouldRepaint(covariant FluidPainter oldDelegate) => true;
}
