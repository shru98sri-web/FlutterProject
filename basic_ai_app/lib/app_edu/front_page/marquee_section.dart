import 'package:flutter/material.dart';

class MarqueeSection extends StatelessWidget {
  const MarqueeSection({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      'Resume Builder',
      'Mock Interviews',
      'Career Roadmap',
      'Skill Assessment',
      'Portfolio Maker',
      'Learning Resources',
    ];

    return Container(
      height: 65,
      color: const Color(0xFF07111F),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int repeat = 0; repeat < 2; repeat++)
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Center(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.diamond_outlined,
                        size: 11,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
