import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AngryBasketballGame(),
    ),
  );
}

class ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AngryBasketballGame();
  }
}

class AngryBasketballGame extends StatefulWidget {
  const AngryBasketballGame({super.key});

  @override
  State<AngryBasketballGame> createState() => _AngryBasketballGameState();
}

class _AngryBasketballGameState extends State<AngryBasketballGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Ball physics state
  Offset _ballPos = const Offset(100, 300);
  Offset _ballVelocity = Offset.zero;
  bool _isDragging = false;
  Offset _dragStart = Offset.zero;

  // Game entities
  final Offset _hoopPos = const Offset(650, 180);
  int _score = 0;
  bool _isAngry = false;

  // Particle effects for impact
  List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updatePhysics);
    _controller.repeat();
  }

  void _updatePhysics() {
    if (_isDragging) return;

    setState(() {
      // Apply gravity and velocity
      _ballVelocity += const Offset(0, 0.4); // Gravity
      _ballPos += _ballVelocity;

      // Handle custom boundary collisions (Simulated court wall/floors)
      if (_ballPos.dy > 380) {
        _ballPos = Offset(_ballPos.dx, 380);
        _ballVelocity = Offset(
          _ballVelocity.dx * 0.8,
          -_ballVelocity.dy * 0.7,
        ); // Bounce loss
        _triggerImpact(_ballPos, Colors.orange);
      }
      if (_ballPos.dx > 750 || _ballPos.dx < 20) {
        _ballVelocity = Offset(-_ballVelocity.dx * 0.8, _ballVelocity.dy);
      }

      // Check collision with the Hoop / Backboard area
      double distanceToHoop = (_ballPos - _hoopPos).distance;
      if (distanceToHoop < 35) {
        // Hit target! Shake and bounce back violently
        _ballVelocity = Offset(
          -_ballVelocity.dx * 1.5,
          -_ballVelocity.dy * 1.2,
        );
        _score += 1;
        _isAngry = true;
        _triggerImpact(_hoopPos, Colors.red);

        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) setState(() => _isAngry = false);
        });
      }

      // Update explosion particles
      for (var p in _particles) {
        p.update();
      }
      _particles.removeWhere((p) => p.life <= 0);
    });
  }

  void _triggerImpact(Offset pos, Color color) {
    final random = Random();
    for (int i = 0; i < 12; i++) {
      _particles.add(
        Particle(
          position: pos,
          velocity: Offset(
            random.nextDouble() * 8 - 4,
            random.nextDouble() * 8 - 4,
          ),
          color: color,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text(
          _isAngry ? '💥 ANGRY HIT! 💥' : 'Angry Basketball Slingshot',
        ),
        backgroundColor: _isAngry ? Colors.red : Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Score Hits: $_score',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isAngry ? Colors.red : Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onPanStart: (details) {
                  if ((details.localPosition - _ballPos).distance < 40) {
                    setState(() {
                      _isDragging = true;
                      _dragStart = details.localPosition;
                    });
                  }
                },
                onPanUpdate: (details) {
                  if (_isDragging) {
                    setState(() {
                      _ballPos = details.localPosition;
                    });
                  }
                },
                onPanEnd: (details) {
                  if (_isDragging) {
                    setState(() {
                      _isDragging = false;
                      // Slingshot velocity vector logic
                      _ballVelocity = (_dragStart - _ballPos) * 0.15;
                    });
                  }
                },
                child: AspectRatio(
                  aspectRatio: 1.8,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: _isAngry ? Colors.red[900] : Colors.orange[400],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: CustomPaint(
                      painter: GameCourtPainter(
                        ballPos: _ballPos,
                        hoopPos: _hoopPos,
                        isDragging: _isDragging,
                        dragStart: _dragStart,
                        isAngry: _isAngry,
                        particles: _particles,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Drag and pull back on the orange ball to launch it!',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class GameCourtPainter extends CustomPainter {
  final Offset ballPos;
  final Offset hoopPos;
  final bool isDragging;
  final Offset dragStart;
  final bool isAngry;
  final List<Particle> particles;

  GameCourtPainter({
    required this.ballPos,
    required this.hoopPos,
    required this.isDragging,
    required this.dragStart,
    required this.isAngry,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw stylized background court key lines
    canvas.drawRect(
      Offset(0, size.height * 0.3) & Size(size.width * 0.25, size.height * 0.4),
      linePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.25, size.height / 2),
        radius: size.height * 0.2,
      ),
      -1.57,
      3.14,
      false,
      linePaint,
    );

    // Draw the "Target" Backboard & Hoop
    final hoopPaint = Paint()..color = isAngry ? Colors.red : Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(hoopPos.dx + 20, hoopPos.dy - 40, 10, 60),
      hoopPaint,
    ); // Backboard
    canvas.drawCircle(
      hoopPos,
      20,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    ); // Rim

    // Draw slingshot rubber band guide line if dragging
    if (isDragging) {
      canvas.drawLine(
        dragStart,
        ballPos,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
    }

    // Draw the Angry Ball
    final ballPaint = Paint()
      ..color = isAngry ? Colors.red : Colors.orange[800]!;
    canvas.drawCircle(ballPos, 20, ballPaint);
    // Draw basketball lines
    final seamPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(ballPos.dx - 20, ballPos.dy),
      Offset(ballPos.dx + 20, ballPos.dy),
      seamPaint,
    );
    canvas.drawLine(
      Offset(ballPos.dx, ballPos.dy - 20),
      Offset(ballPos.dx, ballPos.dy + 20),
      seamPaint,
    );

    // Draw Angry Eyes on the ball if launched/angry
    if (isAngry) {
      final eyePaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(ballPos.dx - 6, ballPos.dy - 6), 4, eyePaint);
      canvas.drawCircle(Offset(ballPos.dx + 6, ballPos.dy - 6), 4, eyePaint);
      // Angry eyebrows
      canvas.drawLine(
        Offset(ballPos.dx - 10, ballPos.dy - 12),
        Offset(ballPos.dx - 2, ballPos.dy - 8),
        seamPaint..strokeWidth = 3,
      );
      canvas.drawLine(
        Offset(ballPos.dx + 10, ballPos.dy - 12),
        Offset(ballPos.dx + 2, ballPos.dy - 8),
        seamPaint,
      );
    }

    // Render impact explosion sparks
    for (var particle in particles) {
      canvas.drawCircle(
        particle.position,
        particle.size,
        Paint()..color = particle.color.withOpacity(particle.life),
      );
    }
  }

  @override
  bool shouldRepaint(covariant GameCourtPainter oldDelegate) => true;
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double life = 1.0;
  double size = 4.0;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
  });

  void update() {
    position += velocity;
    life -= 0.04; // Fade out quickly
  }
}
