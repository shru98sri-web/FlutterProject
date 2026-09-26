import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// ============================================================
// APP
// ============================================================

class billing extends StatelessWidget {
  const billing({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Interview',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      ),
      home: const PlansBillingScreen(),
    );
  }
}

// ============================================================
// PLANS & BILLING SCREEN
// ============================================================

class PlansBillingScreen extends StatelessWidget {
  const PlansBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Row(
          children: [
            const BillingSidebar(),
            Expanded(
              child: Column(
                children: [
                  const BillingHeader(),
                  Expanded(
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: GridBackground(),
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                40,
                                60,
                                40,
                                50,
                              ),
                              child: _buildPlans(
                                constraints.maxWidth,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlans(double width) {
    // --------------------------------------------------------
    // DESKTOP - FOUR CARDS
    // --------------------------------------------------------

    if (width >= 1200) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(
            child: PlanCard(
              title: 'Starter Plan',
              price: '49',
              credits: '50 Credits',
              accentColor: Color(0xFF079FE5),
              features: [
                '50 credits included',
                'Technical Interview: 16 sessions\n(3 credits)',
                'Elite Coder: 25 uses (2 credits)',
                'Interview Precheck: 50 uses\n(1 credit)',
              ],
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: PlanCard(
              title: 'Essential Plan',
              price: '149',
              credits: '180 Credits',
              accentColor: Color(0xFFB02CFF),
              popular: true,
              features: [
                '180 credits included',
                'Group Discussion: 22 sessions\n(8 credits)',
                'Technical & Visa Interview: 60\nsessions (3 credits)',
                'Resume Builder & Portfolio: 60\nuses (3 credits)',
              ],
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: PlanCard(
              title: 'Pro Plan',
              price: '299',
              credits: '400 Credits',
              accentColor: Color(0xFFFF4B0A),
              features: [
                '400 credits included',
                'Group Discussion: 50 sessions\n(8 credits)',
                'All interview modules included',
                'Ideal for extensive practice',
              ],
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: PlanCard(
              title: 'Power Plan',
              price: '599',
              credits: '900 Credits',
              accentColor: Color(0xFF00B489),
              features: [
                '900 credits included',
                'Group Discussion: 112+ sessions',
                'All modules with maximum usage',
                'Best value for comprehensive prep',
              ],
            ),
          ),
        ],
      );
    }

    // --------------------------------------------------------
    // TABLET - TWO CARDS
    // --------------------------------------------------------

    if (width >= 650) {
      final cardWidth = (width - 25) / 2;

      return Wrap(
        spacing: 25,
        runSpacing: 30,
        children: [
          SizedBox(
            width: cardWidth,
            child: const PlanCard(
              title: 'Starter Plan',
              price: '49',
              credits: '50 Credits',
              accentColor: Color(0xFF079FE5),
              features: [
                '50 credits included',
                'Technical Interview: 16 sessions\n(3 credits)',
                'Elite Coder: 25 uses (2 credits)',
                'Interview Precheck: 50 uses\n(1 credit)',
              ],
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: const PlanCard(
              title: 'Essential Plan',
              price: '149',
              credits: '180 Credits',
              accentColor: Color(0xFFB02CFF),
              popular: true,
              features: [
                '180 credits included',
                'Group Discussion: 22 sessions\n(8 credits)',
                'Technical & Visa Interview: 60\nsessions (3 credits)',
                'Resume Builder & Portfolio: 60\nuses (3 credits)',
              ],
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: const PlanCard(
              title: 'Pro Plan',
              price: '299',
              credits: '400 Credits',
              accentColor: Color(0xFFFF4B0A),
              features: [
                '400 credits included',
                'Group Discussion: 50 sessions\n(8 credits)',
                'All interview modules included',
                'Ideal for extensive practice',
              ],
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: const PlanCard(
              title: 'Power Plan',
              price: '599',
              credits: '900 Credits',
              accentColor: Color(0xFF00B489),
              features: [
                '900 credits included',
                'Group Discussion: 112+ sessions',
                'All modules with maximum usage',
                'Best value for comprehensive prep',
              ],
            ),
          ),
        ],
      );
    }

    // --------------------------------------------------------
    // MOBILE - ONE CARD
    // --------------------------------------------------------

    return Column(
      children: const [
        PlanCard(
          title: 'Starter Plan',
          price: '49',
          credits: '50 Credits',
          accentColor: Color(0xFF079FE5),
          features: [
            '50 credits included',
            'Technical Interview: 16 sessions\n(3 credits)',
            'Elite Coder: 25 uses (2 credits)',
            'Interview Precheck: 50 uses\n(1 credit)',
          ],
        ),
        SizedBox(height: 30),
        PlanCard(
          title: 'Essential Plan',
          price: '149',
          credits: '180 Credits',
          accentColor: Color(0xFFB02CFF),
          popular: true,
          features: [
            '180 credits included',
            'Group Discussion: 22 sessions\n(8 credits)',
            'Technical & Visa Interview: 60\nsessions (3 credits)',
            'Resume Builder & Portfolio: 60\nuses (3 credits)',
          ],
        ),
        SizedBox(height: 30),
        PlanCard(
          title: 'Pro Plan',
          price: '299',
          credits: '400 Credits',
          accentColor: Color(0xFFFF4B0A),
          features: [
            '400 credits included',
            'Group Discussion: 50 sessions\n(8 credits)',
            'All interview modules included',
            'Ideal for extensive practice',
          ],
        ),
        SizedBox(height: 30),
        PlanCard(
          title: 'Power Plan',
          price: '599',
          credits: '900 Credits',
          accentColor: Color(0xFF00B489),
          features: [
            '900 credits included',
            'Group Discussion: 112+ sessions',
            'All modules with maximum usage',
            'Best value for comprehensive prep',
          ],
        ),
      ],
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class BillingHeader extends StatelessWidget {
  const BillingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          children: [
            // GO BACK
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.maybePop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 21,
                      color: Color(0xFF334155),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Go back',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 22),

            // TITLE
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plans & Billing',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Choose the perfect plan for your needs',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // GIFT ICON
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF9B1CFF),
                    Color(0xFFD624A5),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.card_giftcard,
                color: Colors.white,
                size: 31,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PLAN CARD
// ============================================================

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String credits;
  final Color accentColor;
  final List<String> features;
  final bool popular;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.credits,
    required this.accentColor,
    required this.features,
    this.popular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 610,
          ),
          padding: const EdgeInsets.fromLTRB(
            28,
            31,
            28,
            27,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: const Color(0xFFE1E5EA),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PLAN NAME
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // PRICE
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '₹',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 37,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        '/ lifetime',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // DIVIDER
              const Divider(
                color: Color(0xFFE2E5E9),
                thickness: 1,
              ),

              const SizedBox(height: 20),

              // CREDITS
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 17,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: const Color(0xFFDDE2E7),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    credits,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // FEATURES
              for (final feature in features)
                Padding(
                  padding: const EdgeInsets.only(bottom: 17),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 21,
                        height: 21,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              // BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    _selectPlan(
                      context,
                      title,
                      price,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // MOST POPULAR BADGE
        if (popular)
          Positioned(
            top: -14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 19,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9827FF),
                      Color(0xFFE80087),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x339827FF),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _selectPlan(
    BuildContext context,
    String plan,
    String price,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(plan),
          content: Text(
            'You selected the $plan for ₹$price/lifetime.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$plan selected',
                    ),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// SIDEBAR
// ============================================================

class BillingSidebar extends StatelessWidget {
  const BillingSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),

          // TOP LOGO
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF11163D),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(height: 30),

          _sidebarIcon(
            Icons.description_outlined,
            const Color(0xFFE8FFF9),
          ),

          _sidebarIcon(
            Icons.mail_outline,
            const Color(0xFFE8FFF9),
          ),

          _sidebarIcon(
            Icons.business_center_outlined,
            const Color(0xFFECEBFF),
          ),

          _sidebarIcon(
            Icons.menu_book_outlined,
            const Color(0xFFFFEAF5),
          ),

          _sidebarIcon(
            Icons.language,
            const Color(0xFFEDEBFF),
          ),

          _sidebarIcon(
            Icons.check_circle_outline,
            const Color(0xFFE5FAFA),
          ),

          _sidebarIcon(
            Icons.bar_chart,
            const Color(0xFFECEBFF),
          ),

          const Spacer(),

          // GIFT
          Container(
            width: 52,
            height: 52,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5EA),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.orange,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarIcon(
    IconData icon,
    Color background,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF4F46E5),
          size: 22,
        ),
      ),
    );
  }
}

// ============================================================
// GRID BACKGROUND
// ============================================================

class GridBackground extends StatelessWidget {
  const GridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class GridPainter extends CustomPainter {
  const GridPainter();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    const double spacing = 52;

    final Paint paint = Paint()
      ..color = const Color(0xFFE8EDF2)
      ..strokeWidth = 1;

    // Vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}
