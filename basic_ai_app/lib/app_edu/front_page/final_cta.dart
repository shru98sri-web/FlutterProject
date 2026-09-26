import 'package:flutter/material.dart';

class FinalCta extends StatelessWidget {
  const FinalCta({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 75,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF111C31),
            Color(0xFF172554),
          ],
        ),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        children: [
          const Text(
            'JOIN 25,000+ PROFESSIONALS',
            style: TextStyle(
              color: Colors.cyan,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'READY TO LAUNCH\nYOUR CAREER?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 48,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Start building your future today with AI-powered '
            'career tools, personalized guidance, and '
            'comprehensive skill development.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 30),
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
                horizontal: 30,
                vertical: 17,
              ),
            ),
            child: const Text(
              'START YOUR JOURNEY →',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Wrap(
            alignment: WrapAlignment.center,
            spacing: 25,
            runSpacing: 10,
            children: [
              _CheckText('Free to Start'),
              _CheckText('AI-Powered'),
              _CheckText('Instant Access'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckText extends StatelessWidget {
  final String text;

  const _CheckText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check,
          size: 16,
          color: Colors.cyan,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
