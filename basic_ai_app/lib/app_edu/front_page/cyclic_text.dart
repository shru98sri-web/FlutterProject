import 'package:flutter/material.dart';

// void main() {
//   runApp(Cycle());
// }

class Cycle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cycling Text Animation'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Marquee Example:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              // Container targeting the horizontal path boundary
              Container(
                width: double.infinity,
                color: Colors.blue.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const CyclingTextAnimation(
                  text:
                      "🚀 This is a continuous horizontal text cycle moving in a straight line!",
                  duration: Duration(seconds: 8),
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CyclingTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;
  const CyclingTextAnimation({
    super.key,
    required this.text,
    this.textStyle,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<CyclingTextAnimation> createState() => _CyclingTextAnimationState();

  // TODO: implement createState
}

class _CyclingTextAnimationState extends State<CyclingTextAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _offsetAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0), end: const Offset(-1.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SlideTransition(
        position: _offsetAnimation,
        child: Text(
          widget.text,
          style: widget.textStyle ??
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}

extension on Colors {
  static const Color blueDark = Color(0xFF0D47A1);
}
