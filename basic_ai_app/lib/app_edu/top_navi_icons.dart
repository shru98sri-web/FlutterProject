import 'package:flutter/material.dart';

class TopNavIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const TopNavIcon({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  State<TopNavIcon> createState() => _TopNavIconState();
}

class _TopNavIconState extends State<TopNavIcon> {
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
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: hovering ? const Color(0xFFF1F4FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.icon,
              color:
                  hovering ? const Color(0xFF4F46E5) : const Color(0xFF475467),
            ),
          ),
        ),
      ),
    );
  }
}
