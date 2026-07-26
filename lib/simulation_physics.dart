import 'package:flutter/material.dart';
import 'package:flutter/physics.dart'; // Required for SpringSimulation
import 'dart:math';
import 'package:flutter/scheduler.dart';

void main() => runApp(const MaterialApp(home: FrictionSimulationScreen()));

class SpringSimulationExample extends StatefulWidget {
  const SpringSimulationExample({super.key});

  @override
  State<SpringSimulationExample> createState() => _SpringSimulationExampleState();
}

class _SpringSimulationExampleState extends State<SpringSimulationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    // Use an unbounded controller because spring simulations can overshoot boundaries
    _controller = AnimationController.unbounded(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  void _runSpringAnimation(Offset pixelsPerSecond, Size size) {
    // Defines where the animation starts (current drag location) and ends (center)
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

    // Calculate the initial velocity relative to the widget size
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    // Configure physics parameters
    const springProps = SpringDescription(
      mass: 1.0,       // Heavy objects take longer to move and stop
      stiffness: 300.0, // High stiffness pulls back faster and harder
      damping: 15.0,    // Low damping creates more oscillation/bounces
    );

    // Create the spring simulation instance
    final simulation = SpringSimulation(
      springProps,
      0.0,           // Starting position (0% of the tween)
      1.0,           // Ending target position (100% of the tween)
      -unitVelocity, // Initial velocity factor
    );

    // Execute the physics simulation
    _controller.animateWith(simulation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Spring Simulation')),
      body: GestureDetector(
        onPanDown: (details) {
          _controller.stop(); // Stop any active spring motion when touched
        },
        onPanUpdate: (details) {
          setState(() {
            // Update position manually during a user drag gesture
            _dragAlignment += Alignment(
              details.delta.dx / (size.width / 2),
              details.delta.dy / (size.height / 2),
            );
          });
        },
        onPanEnd: (details) {
          // Release and trigger the spring physics using the release velocity
          _runSpringAnimation(details.velocity.pixelsPerSecond, size);
        },
        child: Stack(
          children: [
            Align(
              alignment: _dragAlignment,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('Drag Me', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//import 'package:flutter/material.dart';
//import 'package:flutter/physics.dart';

//void main() {
 // runApp(const MaterialApp(
 //   home: GravitySimulationDemo(),
 //   debugShowCheckedModeBanner: false,
 // ));
//}

class GravitySimulationDemo extends StatefulWidget {
  const GravitySimulationDemo({super.key});

  @override
  State<GravitySimulationDemo> createState() => _GravitySimulationDemoState();
}

class _GravitySimulationDemoState extends State<GravitySimulationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _ballYPosition = 0.0;
  double _currentVelocity = 0.0;

  // Simulation Constants
  final double _gravity = 800.0; // Pixels per second squared
  final double _floorLevel = 500.0; // The bottom boundary for the ball
  final double _bounceRestitution = 0.75; // Energy retained after a bounce (0.0 to 1.0)

  @override
  void initState() {
    super.initState();

    // Use an unbounded controller since physics simulations handle their own limits
    _controller = AnimationController.unbounded(vsync: this);

    _controller.addListener(() {
      setState(() {
        _ballYPosition = _controller.value;

        // When the ball hits or passes the floor, calculate the bounce
        if (_ballYPosition >= _floorLevel && _currentVelocity > 0) {
          _ballYPosition = _floorLevel;

          // Reverse direction and reduce speed based on restitution
          double bounceVelocity = -_currentVelocity * _bounceRestitution;

          if (bounceVelocity.abs() < 50) {
            // Stop the animation if the velocity is too low to prevent micro-jigglings
            _controller.stop();
          } else {
            _clearAndRunSimulation(
              startPos: _floorLevel,
              velocity: bounceVelocity,
            );
          }
        }
      });
    });

    // Start the initial fall after the widget renders
    WidgetsBinding.instance.addPostFrameCallback((_) => _startInitialFall());
  }

  void _startInitialFall() {
    _clearAndRunSimulation(startPos: 0.0, velocity: 0.0);
  }

  void _clearAndRunSimulation({required double startPos, required double velocity}) {
    // Create the built-in Flutter gravity simulation
    final simulation = GravitySimulation(
      _gravity,     // Acceleration
      startPos,     // Starting position
      _floorLevel,  // Ending position threshold
      velocity,     // Starting velocity
    );

    // Track the velocity to manage the bounce trajectory manually on floor collision
    _currentVelocity = velocity;

    // Update velocity dynamically as the simulation progresses
    _controller.addListener(_updateVelocityTrack);

    _controller.animateWith(simulation);
  }

  void _updateVelocityTrack() {
    // Crude estimate of current velocity from the controller's internal simulation
    if (_controller.lastElapsedDuration != null) {
      double seconds = _controller.lastElapsedDuration!.inMilliseconds / 1000.0;
      // v = u + at
      _currentVelocity = _currentVelocity + (_gravity * seconds * 0.01);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateVelocityTrack);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gravity Simulation')),
      body: Stack(
        children: [
          // The Drop Target/Floor Line
          Positioned(
            top: _floorLevel + 50, // Accounts for the ball's height center
            left: 0,
            right: 0,
            child: Container(height: 4, color: Colors.black),
          ),
          // The Simulating Object
          Positioned(
            top: _ballYPosition,
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: GestureDetector(
              onTap: () {
                if (!_controller.isAnimating) {
                  _startInitialFall();
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_clock, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//import 'package:flutter/material.dart';
//import 'package:flutter/physics.dart';

//void main() => runApp(const MaterialApp(home: FrictionSimulationScreen()));

class FrictionSimulationScreen extends StatefulWidget {
  const FrictionSimulationScreen({super.key});

  @override
  State<FrictionSimulationScreen> createState() => _FrictionSimulationScreenState();
}

class _FrictionSimulationScreenState extends State<FrictionSimulationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Tracking alignment instead of absolute coordinates for easy centering
  Alignment _dragAlignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    // A lower value or unbound controller is necessary since physics simulations
    // often compute values outside the typical 0.0 to 1.0 range.
    _controller = AnimationController.unbounded(vsync: this);

    _controller.addListener(() {
      setState(() {
        // Update the horizontal position dynamically using simulation values
        _dragAlignment = Alignment(_controller.value, 0.0);
      });
    });
  }

  void _onDragEnd(DragEndDetails details) {
    // 1. Get the pixels-per-second velocity from the gesture
    final pixelsPerSecond = details.velocity.pixelsPerSecond.dx;

    // 2. Convert raw pixels to alignment units (-1.0 to 1.0)
    final size = MediaQuery.of(context).size;
    final alignmentVelocity = pixelsPerSecond / (size.width / 2);

    // 3. Define your friction configuration parameters
    const double dragCoefficient = 0.4;
    final double startPosition = _dragAlignment.x;

    // 4. Create and trigger the physics simulation
    final simulation = FrictionSimulation(
      dragCoefficient,
      startPosition,
      alignmentVelocity,
    );

    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friction Physics Simulation')),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final size = MediaQuery.of(context).size;
            _dragAlignment += Alignment(details.delta.dx / (size.width / 2), 0.0);
          });
        },
        onPanStart: (details) => _controller.stop(),
        onPanEnd: _onDragEnd,
        child: Stack(
          children: [
            Align(
              alignment: _dragAlignment,
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


//import 'dart:math';
//import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';

//void main() {
  //runApp(const GravitySimulatorApp());
//}

class GravitySimulatorApp extends StatelessWidget {
  const GravitySimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SimulatorPage(),
    );
  }
}

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key});

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final List<Body> _bodies;

  // Gravitational constant (scaled for visual clarity)
  final double G = 100.0;
  final double softening = 10.0; // Avoids divide-by-zero errors

  @override
  void initState() {
    super.initState();
    _bodies = [];

    // Initialize N=4 bodies
    _initBodies();

    _ticker = createTicker((_) {
      _updatePhysics();
      setState(() {});
    });
    _ticker.start();
  }

  void _initBodies() {
    // Adding 4 bodies with varying positions, masses, and velocities
    _bodies.add(Body(name: 'Sun', mass: 1000, position: const Offset(400, 400), velocity: const Offset(0, 0), color: Colors.amber, radius: 25));
    _bodies.add(Body(name: 'Planet 1', mass: 5, position: const Offset(200, 400), velocity: const Offset(0, 15), color: Colors.blue, radius: 8));
    _bodies.add(Body(name: 'Planet 2', mass: 2, position: const Offset(400, 150), velocity: const Offset(-20, 0), color: Colors.red, radius: 6));
    _bodies.add(Body(name: 'Planet 3', mass: 1, position: const Offset(550, 400), velocity: const Offset(0, -18), color: Colors.green, radius: 5));
  }

  void _updatePhysics() {
    // 1. Reset forces
    for (var body in _bodies) {
      body.force = Offset.zero;
    }

    // 2. Calculate gravitational forces for every pair
    for (int i = 0; i < _bodies.length; i++) {
      for (int j = 0; j < _bodies.length; j++) {
        if (i != j) {
          final bodyA = _bodies[i];
          final bodyB = _bodies[j];

          final dx = bodyB.position.dx - bodyA.position.dx;
          final dy = bodyB.position.dy - bodyA.position.dy;
          final distanceSq = dx * dx + dy * dy + softening;
          final distance = sqrt(distanceSq);

          // $F = \frac{G \times m_1 \times m_2}{d^2}$
          final forceMagnitude = (G * bodyA.mass * bodyB.mass) / distanceSq;

          // Force vector
          final fx = (dx / distance) * forceMagnitude;
          final fy = (dy / distance) * forceMagnitude;

          bodyA.force += Offset(fx, fy);
        }
      }
    }

    // 3. Update velocities and positions (using Euler-Cromer method)
    const dt = 0.016; // Simulated timestep (~60fps)
    for (var body in _bodies) {
      // $a = \frac{F}{m}$
      final ax = body.force.dx / body.mass;
      final ay = body.force.dy / body.mass;

      body.velocity += Offset(ax, ay) * dt;
      body.position += body.velocity * dt;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('N=4 Gravity Simulator'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: CustomPaint(
        painter: GravityPainter(_bodies),
        child: Container(),
      ),
    );
  }
}

class Body {
  final String name;
  final double mass;
  Offset position;
  Offset velocity;
  Offset force = Offset.zero;
  final Color color;
  final double radius;

  Body({
    required this.name,
    required this.mass,
    required this.position,
    required this.velocity,
    required this.color,
    required this.radius,
  });
}

class GravityPainter extends CustomPainter {
  final List<Body> bodies;

  GravityPainter(this.bodies);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var body in bodies) {
      paint.color = body.color;
      // Draw the celestial body
      canvas.drawCircle(body.position, body.radius, paint);

      // Draw the body name
      final textPainter = TextPainter(
        text: TextSpan(
          text: body.name,
          style: TextStyle(color: body.color, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(body.position.dx - textPainter.width / 2, body.position.dy + body.radius + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
