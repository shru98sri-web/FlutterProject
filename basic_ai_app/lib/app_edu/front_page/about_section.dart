import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     home: AboutSection(),
//   ));
// }

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: Column(
            children: [
              const Text(
                'About Tuition',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Empowering Your\nCareer Success',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 44,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                "This app is a comprehensive career development platform "
                "designed to help students and professionals prepare for "
                "interviews, build standout resumes, and grow confidently "
                "in today's competitive job market.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 800;

                  final cards = [
                    _aboutCard(
                      '01',
                      'Understand You',
                      [
                        'Skills and experience',
                        'Career goals and interests',
                        'Industry preferences',
                      ],
                      'This creates a clear picture of where you are and where you want to go.',
                    ),
                    _aboutCard(
                      '02',
                      'Prepare You',
                      [
                        'Real-time mock interviews',
                        'Skill-based assessments',
                        'Interview prechecks and feedback',
                      ],
                      'Every interaction adapts to your performance, helping you improve where it matters most.',
                    ),
                    _aboutCard(
                      '03',
                      'Grow With You',
                      [
                        'Learning paths',
                        'Skill recommendations',
                        'Career readiness insights',
                      ],
                      'Your journey evolves as you do — ensuring long-term growth.',
                    ),
                  ];

                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < cards.length; i++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: i == 2 ? 0 : 18,
                              ),
                              child: cards[i],
                            ),
                          ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      for (final card in cards) ...[
                        card,
                        const SizedBox(height: 18),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _aboutCard(
    String number,
    String title,
    List<String> bullets,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 18),
          for (final item in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white24,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
