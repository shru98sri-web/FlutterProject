import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Ensure engine interaction is ready before forcing orientation layout
  WidgetsFlutterBinding.ensureInitialized();

  // Lock app orientation to horizontal/landscape for side-by-side subplot visualization
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const HelmholtzTransitionApp());
  });
}

class HelmholtzTransitionApp extends StatelessWidget {
  const HelmholtzTransitionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helmholtz Transition Visualizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: const Color(0xFF121212)),
      home: const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Helmholtz Transition Wavefield Visualization',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 16),

                  // The Custom Shader Widget from the previous step
                  WaveFieldViewer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WaveFieldViewer extends StatefulWidget {
  const WaveFieldViewer({super.key});

  @override
  State<WaveFieldViewer> createState() => _WaveFieldViewerState();
}

class _WaveFieldViewerState extends State<WaveFieldViewer> {
  ui.FragmentShader? _shader;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  Future<void> _loadShader() async {
    try {
      debugPrint('Attempting to compile and load fragment shader asset...');
      final program = await ui.FragmentProgram.fromAsset(
        'shaders/wave_fld_helmholtz.frag',
      );
      //real part,imaginary part(-1.5 to 1.5) and absolute value
      //hl(kr)e^i*l*theta+h0(k|x=x0|)

      setState(() {
        _shader = program.fragmentShader();
      });
      debugPrint('Shader compiled and loaded successfully!');
    } catch (e, stackTrace) {
      debugPrint('🚨 SHADER COMPILATION EXCEPTION:');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(child: Text('Failed to compile hardware shader.'));
    }

    if (_shader == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: 18 / 5, // Match target image width/height aspect ratio
      child: CustomPaint(painter: ShaderPainter(shader: _shader!)),
    );
  }
}

class ShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;

  ShaderPainter({required this.shader});

  @override
  void paint(Canvas canvas, Size size) {
    // Match uniform layouts from the GLSL file
    shader.setFloat(0, size.width); // u_resolution.x
    shader.setFloat(1, size.height); // u_resolution.y
    shader.setFloat(2, 0.0); // u_time (Static value instance)

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
