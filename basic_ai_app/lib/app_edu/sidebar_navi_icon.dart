import 'package:flutter/material.dart';

class SidebarNavIcon extends StatefulWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String tooltip;

  const SidebarNavIcon({
    super.key,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.tooltip,
  });

  @override
  State<SidebarNavIcon> createState() => _SidebarNavIconState();
}

class _SidebarNavIconState extends State<SidebarNavIcon> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || hovering;

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
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 58,
            height: 58,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: widget.selected
                  ? Colors.white
                  : hovering
                      ? const Color(0xFFF0F3FF)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: widget.selected
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.30),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 180),
              scale: hovering ? 1.08 : 1.0,
              child: Icon(
                widget.icon,
                size: 26,
                color: widget.selected
                    ? Colors.white
                    : hovering
                        ? Colors.grey
                        : const Color(
                            0xFF667085,
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
