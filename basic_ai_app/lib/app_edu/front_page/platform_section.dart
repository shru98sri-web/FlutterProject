import 'package:flutter/material.dart';

import 'feature.dart';

class PlatformSection extends StatelessWidget {
  const PlatformSection({super.key});

  static const features = [
    CareerFeature(
      number: '01',
      title: 'Resume Builder',
      description:
          'Create professional ATS-optimized resumes with AI-powered suggestions.',
      icon: Icons.description_outlined,
    ),
    CareerFeature(
      number: '02',
      title: 'Mock Interviews',
      description:
          'Practice interviews with AI feedback for technical, aptitude, and HR rounds.',
      icon: Icons.record_voice_over_outlined,
    ),
    CareerFeature(
      number: '03',
      title: 'Career Roadmap',
      description:
          'Get personalized learning paths aligned with your career goals.',
      icon: Icons.route_outlined,
    ),
    CareerFeature(
      number: '04',
      title: 'Skill Assessment',
      description: 'Test your coding, typing, aptitude, and technical skills.',
      icon: Icons.assessment_outlined,
    ),
    CareerFeature(
      number: '05',
      title: 'Learning Resources',
      description:
          'Access curated materials to boost your knowledge and skills.',
      icon: Icons.menu_book_outlined,
    ),
    CareerFeature(
      number: '06',
      title: 'Portfolio Builder',
      description: 'Showcase your projects and achievements professionally.',
      icon: Icons.work_outline,
    ),
    CareerFeature(
      number: '07',
      title: 'Group Discussion',
      description: 'Practice and master group communication dynamics.',
      icon: Icons.groups_outlined,
    ),
    CareerFeature(
      number: '08',
      title: 'Visa Preparation',
      description: 'Get ready for visa interviews and documentation.',
      icon: Icons.flight_takeoff_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 90,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: Column(
            children: [
              const Text(
                'PLATFORM',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Complete Career\nDevelopment Platform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Everything you need to prepare, practice, and succeed '
                'in your career journey — all in one place.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 55),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 900
                      ? 4
                      : constraints.maxWidth > 550
                          ? 2
                          : 1;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: features.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: columns == 1 ? 2.1 : 1.15,
                    ),
                    itemBuilder: (context, index) {
                      return _FeatureCard(
                        feature: features[index],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final CareerFeature feature;

  const _FeatureCard({
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                feature.number,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Icon(
                feature.icon,
                color: Colors.blue,
                size: 27,
              ),
            ],
          ),
          const Spacer(),
          Text(
            feature.title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            feature.description,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
