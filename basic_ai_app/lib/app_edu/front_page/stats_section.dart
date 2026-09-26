import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 65,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 40,
        runSpacing: 40,
        children: const [
          _Stat(
            value: '25k+',
            title: 'Professionals',
            subtitle: 'Accelerating their careers',
          ),
          _Stat(
            value: '98%',
            title: 'Offer Rate',
            subtitle: 'Career preparation',
          ),
          _Stat(
            value: '500+',
            title: 'Companies',
            subtitle: 'Across industries',
          ),
          _Stat(
            value: '4.9',
            title: 'Avg Rating',
            subtitle: 'From professionals',
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle;

  const _Stat({
    required this.value,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
