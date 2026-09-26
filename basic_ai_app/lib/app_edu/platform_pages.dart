import 'package:flutter/material.dart';

class PlatformPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const PlatformPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: Colors.white30,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _card(
                'Get Started',
                'Start exploring this section.',
                Icons.arrow_forward,
              ),
              _card(
                'Your Progress',
                'Track your progress and activities.',
                Icons.analytics_outlined,
              ),
              _card(
                'Recommendations',
                'Personalized recommendations powered by AI.',
                Icons.auto_awesome,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card(
    String title,
    String text,
    IconData icon,
  ) {
    return Container(
      width: 310,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.pinkAccent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.pink,
            size: 30,
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.amber,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PAGE 2
// ============================================================

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlatformPage(
      title: 'Achievements',
      subtitle: 'Track your milestones and career achievements.',
      icon: Icons.emoji_events_outlined,
    );
  }
}

// ============================================================
// PAGE 3
// ============================================================

class CareerExplorerPage extends StatelessWidget {
  const CareerExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlatformPage(
      title: 'Career Explorer',
      subtitle: 'Explore careers and discover your next opportunity.',
      icon: Icons.explore_outlined,
    );
  }
}

// ============================================================
// PAGE 4
// ============================================================

class AICareerToolsPage extends StatelessWidget {
  const AICareerToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlatformPage(
      title: 'AI Career Tools',
      subtitle: 'Use AI to accelerate your career development.',
      icon: Icons.auto_awesome,
    );
  }
}

// ============================================================
// PAGE 5
// ============================================================

class CodingLabPage extends StatelessWidget {
  const CodingLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlatformPage(
      title: 'Coding Lab',
      subtitle: 'Practice coding and technical interview problems.',
      icon: Icons.code_outlined,
    );
  }
}

// ============================================================
// PAGE 6
// ============================================================

class SkillsAssessmentPage extends StatelessWidget {
  const SkillsAssessmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlatformPage(
      title: 'Skills Assessment',
      subtitle: 'Assess your skills and identify knowledge gaps.',
      icon: Icons.hexagon_outlined,
    );
  }
}

// ============================================================
// PAGE 7
// ============================================================

class TypingPracticePage extends StatelessWidget {
  const TypingPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlatformPage(
      title: 'Typing Practice',
      subtitle: 'Improve your typing speed and accuracy.',
      icon: Icons.keyboard_outlined,
    );
  }
}

// ============================================================
// PAGE 9
// ============================================================

class QuickActionsPage extends StatelessWidget {
  const QuickActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlatformPage(
      title: 'Quick Actions',
      subtitle: 'Quickly access your most-used career tools.',
      icon: Icons.bolt,
    );
  }
}
