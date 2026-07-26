import 'package:flutter/material.dart';

class BeamStatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const BeamStatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(side: BorderSide(color: color.withOpacity(0.5), width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
