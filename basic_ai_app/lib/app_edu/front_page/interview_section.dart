import 'package:flutter/material.dart';

class InterviewSection extends StatelessWidget {
  const InterviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth > 800;

              final left = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '5.0',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    '15,000+ interviews aced',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'The Complete Interview\nPreparation Platform',
                    style: TextStyle(
                      fontSize: 43,
                      height: 1.08,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Master technical rounds, ace HR interviews, '
                    'and land your dream job with AI-powered '
                    'interview preparation tools.',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/login',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                    ),
                  ),
                ],
              );

              final right = Container(
                height: 420,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFDBEAFE),
                      Color(0xFFEDE9FE),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 25,
                      left: 25,
                      child: _smallCard(
                        Icons.code,
                        'Technical',
                      ),
                    ),
                    Positioned(
                      right: 25,
                      top: 90,
                      child: _smallCard(
                        Icons.people_alt_outlined,
                        'HR Round',
                      ),
                    ),
                    Positioned(
                      bottom: 35,
                      left: 40,
                      child: _smallCard(
                        Icons.analytics_outlined,
                        'AI Feedback',
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.10),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.video_camera_front_outlined,
                          size: 80,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              );

              if (desktop) {
                return Row(
                  children: [
                    Expanded(child: left),
                    const SizedBox(width: 60),
                    Expanded(child: right),
                  ],
                );
              }

              return Column(
                children: [
                  left,
                  const SizedBox(height: 45),
                  right,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _smallCard(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.blue,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
