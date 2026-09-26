import 'package:flutter/material.dart';

class AIFloatingButton extends StatefulWidget {
  final VoidCallback onTap;

  const AIFloatingButton({
    super.key,
    required this.onTap,
  });

  @override
  State<AIFloatingButton> createState() => _AIFloatingButtonState();
}

class _AIFloatingButtonState extends State<AIFloatingButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovering = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: hovering ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 180),
          child: Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEAF4F7),
              border: Border.all(
                color: Colors.white,
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.20),
                  blurRadius: 22,
                ),
              ],
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              size: 50,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ),
    );
  }
}
