import 'package:flutter/material.dart';

class RiskBadge extends StatelessWidget {
  final bool highRisk;

  const RiskBadge({
    super.key,
    required this.highRisk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: highRisk
            ? Colors.red.withValues(alpha: 0.12)
            : Colors.green.withValues(alpha: 0.12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            highRisk ? Icons.warning_amber : Icons.check_circle,
            size: 16,
            color: highRisk ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 6),
          Text(
            highRisk ? 'HIGH RISK' : 'LOW RISK',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: highRisk ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
