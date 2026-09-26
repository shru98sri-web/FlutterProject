import 'package:flutter/material.dart';

import '../dashboard_screen.dart';

// void main() {
//   runApp(const CareerApp());
// }

// ============================================================
// APP
// ============================================================

class CareerApp extends StatelessWidget {
  const CareerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Career Guidance',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================
// COLORS
// ============================================================

const navy = Color(0xFF08111F);
const dark = Color(0xFF0B1626);
const blue = Color(0xFF2563EB);
const cyan = Color(0xFF22D3EE);
const purple = Color(0xFF7C3AED);
const lightBg = Color(0xFFF7F9FC);
const textDark = Color(0xFF111827);
const muted = Color(0xFF64748B);

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Header(),
            HeroSection(),
            FeatureStrip(),
            StatsSection(),
            PlatformSection(),
            AboutSection(),
            GrowthSection(),
            InterviewSection(),
            FinalCTA(),
            Footer(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
                (_) => false,
              );
            },
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        blue,
                        purple,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 11),
                const Text(
                  'AI Career',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (MediaQuery.of(context).size.width > 750) ...[
            TextButton(
              onPressed: () {},
              child: const Text(
                'Platform',
                style: TextStyle(
                  color: textDark,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Career',
                style: TextStyle(
                  color: textDark,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'About',
                style: TextStyle(
                  color: textDark,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 21,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Get Started →',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HERO
// ============================================================

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width > 850;

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
                  child: _heroText(context),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: _heroVisual(),
                ),
              ],
            )
          : Column(
              children: [
                _heroText(context),
                const SizedBox(height: 40),
                _heroVisual(),
              ],
            ),
    );
  }

  Widget _heroText(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width > 850;

    //screen size,resolution,orientation
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
              color: blue,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Your intelligent partner\nfor career success',
          style: TextStyle(
            fontSize: desktop ? 58 : 40,
            height: 1.06,
            fontWeight: FontWeight.w900,
            color: navy,
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
            color: muted,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: navy,
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

  Widget _heroVisual() {
    //to create shared element transitions
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
            top: 30,
            right: 25,
            child: _floatingCard(
              Icons.auto_graph,
              'Career Growth',
              'Build your future',
            ),
          ),
          Positioned(
            left: 25,
            bottom: 40,
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
                    blue,
                    purple,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: blue.withOpacity(.25),
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
      padding: const EdgeInsets.all(14),
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
              color: blue,
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
                style: const TextStyle(
                  fontSize: 11,
                  color: muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FEATURE STRIP
// ============================================================

class FeatureStrip extends StatelessWidget {
  const FeatureStrip({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      'Resume Builder',
      'Mock Interviews',
      'Career Roadmap',
      'Skill Assessment',
      'Portfolio Builder',
      'Learning Resources',
    ];

    return Container(
      height: 65,
      color: navy,
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
                      const SizedBox(width: 9),
                      Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
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

// ============================================================
// STATISTICS
// ============================================================

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 65,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 40,
        runSpacing: 40,
        children: const [
          StatCard(
            '25k+',
            'Professionals',
            'Accelerating their careers',
          ),
          StatCard(
            '98%',
            'Offer Rate',
            'Career preparation',
          ),
          StatCard(
            '500+',
            'Companies',
            'Across industries',
          ),
          StatCard(
            '4.9',
            'Average Rating',
            'From professionals',
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle;

  const StatCard(
    this.value,
    this.title,
    this.subtitle, {
    super.key,
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
              color: navy,
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
              color: muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PLATFORM
// ============================================================

class PlatformSection extends StatelessWidget {
  const PlatformSection({super.key});

  @override
  Widget build(BuildContext context) {
    const features = [
      [
        '01',
        'Resume Builder',
        'Create professional ATS-optimized resumes with AI-powered suggestions.',
        Icons.description_outlined,
      ],
      [
        '02',
        'Mock Interviews',
        'Practice interviews with AI feedback for technical, aptitude and HR rounds.',
        Icons.record_voice_over_outlined,
      ],
      [
        '03',
        'Career Roadmap',
        'Get personalized learning paths aligned with your career goals.',
        Icons.route_outlined,
      ],
      [
        '04',
        'Skill Assessment',
        'Test your coding, typing, aptitude and technical skills.',
        Icons.assessment_outlined,
      ],
      [
        '05',
        'Learning Resources',
        'Access curated materials to boost your knowledge and skills.',
        Icons.menu_book_outlined,
      ],
      [
        '06',
        'Portfolio Builder',
        'Showcase your projects and achievements professionally.',
        Icons.work_outline,
      ],
      [
        '07',
        'Group Discussion',
        'Practice and master group communication dynamics.',
        Icons.groups_outlined,
      ],
      [
        '08',
        'Visa Preparation',
        'Get ready for visa interviews and documentation.',
        Icons.flight_takeoff_outlined,
      ],
    ];

    return Container(
      color: lightBg,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 90,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'PLATFORM',
                style: TextStyle(
                  color: blue,
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
                  fontSize: 44,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                  color: navy,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Everything you need to prepare, practice, '
                'and succeed in your career journey — all in one place.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 55),
              LayoutBuilder(
                //builds a widget tree depending on parent's widget size
                //evaluates layout constraints at the specific location of the widget tree where it is placed
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
                      childAspectRatio: columns == 1 ? 2.0 : 1.15,
                    ),
                    itemBuilder: (context, index) {
                      final item = features[index];

                      return FeatureCard(
                        number: item[0] as String,
                        title: item[1] as String,
                        description: item[2] as String,
                        icon: item[3] as IconData,
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

class FeatureCard extends StatefulWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  const FeatureCard({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      //used to track mouse pointer movements over a specific area of the screen
      onEnter: (_) {
        setState(() => hover = true);
      },
      onExit: (_) {
        setState(() => hover = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(25),
        transform: Matrix4.translationValues(
          0,
          hover ? -5 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hover ? blue : const Color(0xFFE5E7EB),
          ),
          boxShadow: hover
              ? [
                  BoxShadow(
                    color: blue.withOpacity(.10),
                    blurRadius: 25,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.number,
                  style: const TextStyle(
                    color: blue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Icon(
                  widget.icon,
                  color: navy,
                  size: 27,
                ),
              ],
            ),
            const Spacer(),
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              widget.description,
              style: const TextStyle(
                color: muted,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ABOUT
// ============================================================

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'ABOUT SASTHRA-G',
                style: TextStyle(
                  color: blue,
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
                  color: navy,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Sasthra-G is a comprehensive career development '
                'platform designed to help students and professionals '
                'prepare for interviews, build standout resumes, '
                'and grow confidently in today’s competitive job market.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 55),
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
                    ),
                    _aboutCard(
                      '02',
                      'Prepare You',
                      [
                        'Real-time mock interviews',
                        'Skill-based assessments',
                        'Interview feedback',
                      ],
                    ),
                    _aboutCard(
                      '03',
                      'Grow With You',
                      [
                        'Learning paths',
                        'Skill recommendations',
                        'Career readiness insights',
                      ],
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
                                right: i == cards.length - 1 ? 0 : 18,
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
  ) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: lightBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: blue,
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
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: blue,
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
          const SizedBox(height: 8),
          const Text(
            'Personalized guidance helps you understand '
            'where you are and how to move forward.',
            style: TextStyle(
              color: muted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GROWTH SECTION
// ============================================================

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

          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'START YOUR JOURNEY',
                style: TextStyle(
                  color: cyan,
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
              for (final text in [
                'Personalized Career Map',
                'AI Resume Analysis',
                'Community Access',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: cyan,
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
            ],
          );

          final right = Column(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: navy,
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
                Expanded(child: left),
                const SizedBox(width: 40),
                right,
              ],
            );
          }

          return Column(
            children: [
              left,
              const SizedBox(height: 40),
              right,
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// INTERVIEW
// ============================================================

class InterviewSection extends StatelessWidget {
  const InterviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
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
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
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
                      color: blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'The Complete Interview\nPreparation Platform',
                    style: TextStyle(
                      fontSize: 42,
                      height: 1.08,
                      fontWeight: FontWeight.w900,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Master technical rounds, ace HR interviews, '
                    'and prepare confidently with AI-powered '
                    'interview tools.',
                    style: TextStyle(
                      color: muted,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
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
                      child: _interviewCard(
                        Icons.code,
                        'Technical',
                      ),
                    ),
                    Positioned(
                      top: 90,
                      right: 25,
                      child: _interviewCard(
                        Icons.people_alt_outlined,
                        'HR Round',
                      ),
                    ),
                    Positioned(
                      //used to place and size a child widget at an exact location inside stack
                      bottom: 35,
                      left: 40,
                      child: _interviewCard(
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
                          color: blue,
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

  Widget _interviewCard(
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
            color: blue,
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

// ============================================================
// FINAL CTA
// ============================================================

class FinalCTA extends StatelessWidget {
  const FinalCTA({super.key});

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
              color: cyan,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: navy,
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
              CheckText('Free to Start'),
              CheckText('AI-Powered'),
              CheckText('Instant Access'),
            ],
          ),
        ],
      ),
    );
  }
}

class CheckText extends StatelessWidget {
  final String text;

  const CheckText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check,
          size: 16,
          color: cyan,
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

// ============================================================
// FOOTER
// ============================================================

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: navy,
      padding: const EdgeInsets.fromLTRB(
        30,
        70,
        30,
        30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Wrap(
                spacing: 70,
                runSpacing: 40,
                children: [
                  SizedBox(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'AI Career Guidance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Navigate your future with AI.',
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'A comprehensive career platform '
                          'for modern professionals.',
                          style: TextStyle(
                            color: Colors.white54,
                            height: 1.5,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FooterColumn(
                    'Platform',
                    [
                      'Career Mapping',
                      'Resume Scoring',
                      'Enterprise Workforce',
                      'Career API',
                    ],
                  ),
                  FooterColumn(
                    'Company',
                    [
                      'Our Mission',
                      'Partners',
                      'Contact',
                    ],
                  ),
                  FooterColumn(
                    'Legal',
                    [
                      'Privacy Policy',
                      'Terms & Conditions',
                      'Refund Policy',
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 55),
              const Divider(
                color: Colors.white12,
              ),
              const SizedBox(height: 25),
              const Text(
                '© 2026 AI Career Guidance.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const FooterColumn(
    this.title,
    this.items, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Container(
            width: 440,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.07),
                  blurRadius: 35,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        blue,
                        purple,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'AI CAREER GUIDANCE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sign in to start your interview '
                  'preparation journey',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => dashb(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.g_mobiledata,
                      size: 30,
                    ),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textDark,
                      side: const BorderSide(
                        color: Color(0xFFD1D5DB),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '← Back to home',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'By signing in, you agree to our '
                  'Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const cards = [
      [
        Icons.description_outlined,
        'Resume Builder',
      ],
      [
        Icons.video_camera_front_outlined,
        'Mock Interview',
      ],
      [
        Icons.route_outlined,
        'Career Roadmap',
      ],
      [
        Icons.assessment_outlined,
        'Skill Assessment',
      ],
      [
        Icons.menu_book_outlined,
        'Learning',
      ],
      [
        Icons.work_outline,
        'Portfolio',
      ],
      [
        Icons.groups_outlined,
        'Group Discussion',
      ],
      [
        Icons.flight_takeoff_outlined,
        'Visa Preparation',
      ],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text(
          'AI Career',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    blue,
                    purple,
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Evening 👋',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ready to grow your career?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Your Career Tools',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
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
                  itemCount: cards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) {
                    return DashboardCard(
                      icon: cards[index][0] as IconData,
                      title: cards[index][1] as String,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatefulWidget {
  final IconData icon;
  final String title;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => hover = true);
      },
      onExit: (_) {
        setState(() => hover = false);
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: hover ? blue : const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 38,
                color: blue,
              ),
              const SizedBox(height: 15),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
