import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final desktop = width > 850;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: desktop ? 70 : 25,
        vertical: desktop ? 80 : 55,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5F9FF),
            Color(0xFFEFF5FF),
            Color(0xFFF9F7FF),
          ],
        ),
      ),
      child: desktop
          ? Row(
              children: [
                Expanded(
                  flex: 6,
                  child: _content(context),
                ),
                const SizedBox(width: 50),
                Expanded(
                  flex: 5,
                  child: _visual(),
                ),
              ],
            )
          : Column(
              children: [
                _content(context),
                const SizedBox(height: 40),
                _visual(),
              ],
            ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.blue.shade100,
            ),
          ),
          child: const Text(
            'AI Career Guidance',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Your intelligent partner\nfor career success',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width > 850 ? 60 : 42,
            height: 1.05,
            fontWeight: FontWeight.w900,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Master interviews, build standout resumes, '
          'and accelerate your career growth with '
          'AI-powered tools.',
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Get Started →',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _visual() {
    return Container(
      height: 430,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
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
            top: 35,
            right: 30,
            child: _floatingCard(
              Icons.auto_graph,
              'Career Growth',
              'Build your future',
            ),
          ),
          Positioned(
            left: 30,
            bottom: 45,
            child: _floatingCard(
              Icons.task_alt,
              'Interview Ready',
              'AI-powered practice',
            ),
          ),
          Center(
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(.25),
                    blurRadius: 50,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 95,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
