import 'package:flutter/material.dart';

class GrowthSection extends StatelessWidget {
  const GrowthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 40,
      ),
      padding: const EdgeInsets.all(45),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0A1728),
            Color(0xFF111D35),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth > 750;

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'START YOUR JOURNEY',
                style: TextStyle(
                  color: Colors.cyan,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Accelerate your career\ndevelopment',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 38,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Personalized guidance and AI-powered tools '
                'to help you move forward.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              ...[
                'Personalized Career Map',
                'AI Resume Analysis (Weekly)',
                'Community Access',
              ].map(
                (text) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: Colors.cyan,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

          final action = Column(
            children: [
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.06),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 75,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/login',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'START GROWING',
                ),
              ),
            ],
          );

          if (desktop) {
            return Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: 40),
                action,
              ],
            );
          }

          return Column(
            children: [
              content,
              const SizedBox(height: 40),
              action,
            ],
          );
        },
      ),
    );
  }
}
