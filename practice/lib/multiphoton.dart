import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

//void main() => runApp(const MaterialApp(home: MultiphotonScreen()));

class MultiphotonScreen extends StatefulWidget {
  const MultiphotonScreen({super.key});

  @override
  State<MultiphotonScreen> createState() => _MultiphotonScreenState();
}

class _MultiphotonScreenState extends State<MultiphotonScreen>
    with SingleTickerProviderStateMixin {
  ui.FragmentShader? _shader;
  late final Ticker _ticker;
  double _elapsedTime = 0.0;

  // Simulation Controller States
  double _laserIntensity = 1.2;
  double _absorptionExponent = 2.0; // Slider options: 2.0 or 3.0
  double _focalRadius = 0.4; // Beam width restriction

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsedTime = elapsed.inMilliseconds / 1000.0;
      });
    })..start();
  }

  Future<void> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset(
      'shaders/multiphoton.frag',
    );
    setState(() {
      _shader = program.fragmentShader();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multiphoton Lab Controller')),
      body: _shader == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: CustomPaint(
                    painter: MultiphotonPainter(
                      shader: _shader!,
                      time: _elapsedTime,
                      intensity: _laserIntensity,
                      exponent: _absorptionExponent,
                      radius: _focalRadius,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFF121212),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Slider 1: Intensity
                        _buildControlRow(
                          icon: Icons.bolt,
                          label: 'Intensity',
                          value: _laserIntensity,
                          min: 0.1,
                          max: 3.0,
                          displayValue:
                              '${(_laserIntensity * 100).toStringAsFixed(0)}%',
                          onChanged: (val) =>
                              setState(() => _laserIntensity = val),
                        ),
                        const SizedBox(height: 12),
                        // Slider 2: Exponent Order (n)
                        _buildControlRow(
                          icon: Icons.functions,
                          label: 'Order (n)',
                          value: _absorptionExponent,
                          min: 1.0,
                          max: 4.0,
                          divisions: 3,
                          displayValue:
                              '${_absorptionExponent.toStringAsFixed(0)}-Photon',
                          onChanged: (val) =>
                              setState(() => _absorptionExponent = val),
                        ),
                        const SizedBox(height: 12),
                        // Slider 3: Focal Radius
                        _buildControlRow(
                          icon: Icons.radar,
                          label: 'Focal Radius',
                          value: _focalRadius,
                          min: 0.1,
                          max: 1.0,
                          displayValue: _focalRadius.toStringAsFixed(2),
                          onChanged: (val) =>
                              setState(() => _focalRadius = val),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildControlRow({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required String displayValue,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.cyanAccent, size: 20),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: Colors.cyanAccent,
            inactiveColor: Colors.white12,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 70,
          child: Text(
            displayValue,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class MultiphotonPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  final double intensity;
  final double exponent;
  final double radius;

  MultiphotonPainter({
    required this.shader,
    required this.time,
    required this.intensity,
    required this.exponent,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width); // uSize.x
    shader.setFloat(1, size.height); // uSize.y
    shader.setFloat(2, time); // uTime
    shader.setFloat(3, intensity); // uIntensity
    shader.setFloat(4, exponent); // uExponent
    shader.setFloat(5, radius); // uRadius

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant MultiphotonPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.intensity != intensity ||
        oldDelegate.exponent != exponent ||
        oldDelegate.radius != radius;
  }
}
