import 'package:flutter/material.dart';

// void main() {
//   runApp(const AnalyticsApp());
// }

// ============================================================
// APP
// ============================================================

class AnalyticsApp extends StatelessWidget {
  const AnalyticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real-Time Analytics',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        fontFamily: 'Arial',
      ),
      home: const RealTimeAnalyticsPage(),
    );
  }
}

// ============================================================
// MAIN PAGE
// ============================================================

class RealTimeAnalyticsPage extends StatelessWidget {
  const RealTimeAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Row(
          children: [
            const SideBar(),
            Expanded(
              child: Column(
                children: [
                  const TopHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          34,
                          34,
                          34,
                          50,
                        ),
                        child: Column(
                          children: [
                            const AnalyticsTitle(),
                            const SizedBox(height: 40),
                            const OverallScoreCard(),
                            const SizedBox(height: 30),
                            const CategoryOverviewCard(),
                          ],
                        ),
                      ),
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
}

// ============================================================
// ANALYTICS TITLE
// ============================================================

class AnalyticsTitle extends StatelessWidget {
  const AnalyticsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ANALYTICS ICON
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: const Color(0xFF0E0A96),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x25000080),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),

            const SizedBox(width: 20),

            // TITLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Real-Time ',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                        TextSpan(
                          text: 'Analytics',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1616A8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Welcome back, Shruthi Srivatsan',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF52627A),
                    ),
                  ),
                ],
              ),
            ),

            // REFRESH BUTTON
            Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: const Color(0xFFE0E5EC),
                ),
              ),
              child: IconButton(
                tooltip: 'Refresh',
                onPressed: () {},
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 25,
                  color: Color(0xFF172033),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// OVERALL SCORE CARD
// ============================================================

class OverallScoreCard extends StatelessWidget {
  const OverallScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 480,
      ),
      padding: const EdgeInsets.fromLTRB(
        42,
        40,
        42,
        36,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF6B7280),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================
          // CARD HEADER
          // ==================================================

          Row(
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.emoji_events_outlined,
                  color: Color(0xFF737D8D),
                  size: 40,
                ),
              ),
              const SizedBox(width: 18),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Score',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8A9AB3),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your performance summary',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF52627A),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 43),

          // ==================================================
          // SCORE
          // ==================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '0.0',
                style: TextStyle(
                  fontSize: 88,
                  height: 0.9,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF717987),
                ),
              ),
              const SizedBox(width: 14),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ 10',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A9AB3),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 34),

          // ==================================================
          // NOT TAKEN
          // ==================================================

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 19,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 20,
                  color: Color(0xFF334155),
                ),
                SizedBox(width: 9),
                Text(
                  'NOT TAKEN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 34),

          // ==================================================
          // COMPLETION HEADER
          // ==================================================

          Row(
            children: [
              const Icon(
                Icons.adjust_rounded,
                size: 22,
                color: Color(0xFF8495AE),
              ),
              const SizedBox(width: 12),
              const Text(
                'Completion Progress',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),
              const Spacer(),
              const Text(
                '0%',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF68768A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ==================================================
          // PROGRESS BAR
          // ==================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0,
              minHeight: 15,
              backgroundColor: Color(0xFFEFF3F7),
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF315EFF),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            '0 of 5 categories completed',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF52627A),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY OVERVIEW
// ============================================================

class CategoryOverviewCard extends StatelessWidget {
  const CategoryOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE0E5EC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Categories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 25),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              if (width > 900) {
                return const Row(
                  children: [
                    Expanded(
                      child: CategoryItem(
                        icon: Icons.code,
                        title: 'Technical',
                        score: '0.0',
                      ),
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: CategoryItem(
                        icon: Icons.record_voice_over,
                        title: 'Communication',
                        score: '0.0',
                      ),
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: CategoryItem(
                        icon: Icons.psychology_outlined,
                        title: 'Problem Solving',
                        score: '0.0',
                      ),
                    ),
                  ],
                );
              }

              return const Column(
                children: [
                  CategoryItem(
                    icon: Icons.code,
                    title: 'Technical',
                    score: '0.0',
                  ),
                  SizedBox(height: 15),
                  CategoryItem(
                    icon: Icons.record_voice_over,
                    title: 'Communication',
                    score: '0.0',
                  ),
                  SizedBox(height: 15),
                  CategoryItem(
                    icon: Icons.psychology_outlined,
                    title: 'Problem Solving',
                    score: '0.0',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY ITEM
// ============================================================

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String score;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.title,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE5E9EF),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF315EFF),
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF243047),
              ),
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF717987),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TOP HEADER
// ============================================================

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE4E8EF),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
        ),
        child: Row(
          children: [
            // MENU
            Container(
              width: 47,
              height: 47,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: const Color(0xFFE0E5EC),
                ),
              ),
              child: const Icon(
                Icons.menu,
                size: 27,
                color: Color(0xFF52627A),
              ),
            ),

            const SizedBox(width: 17),

            // BREADCRUMB
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: Color(0xFF1465FF),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sasthra',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF18243B),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '/',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Career Tools',
                    style: TextStyle(
                      color: Color(0xFF68768A),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 17),

            // PAGE ICON
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.bar_chart,
                color: Color(0xFF315EFF),
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            // PAGE DESCRIPTION
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Real-Time Analytics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Live score telemetry and growth performance charts',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // CREDITS
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EA),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFFFD998),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.link,
                    size: 18,
                    color: Color(0xFFE08000),
                  ),
                  SizedBox(width: 7),
                  Text(
                    '₹348',
                    style: TextStyle(
                      color: Color(0xFF994D00),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'CREDITS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF994D00),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.visibility_off_outlined,
                    size: 17,
                    color: Color(0xFFB47A2C),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 25),

            // REWARDS
            Row(
              children: [
                const Icon(
                  Icons.card_giftcard,
                  size: 20,
                  color: Color(0xFF5941FF),
                ),
                const SizedBox(width: 7),
                const Text(
                  'Rewards',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '+50',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4C38E8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 22),

            // NOTIFICATION
            Stack(
              children: [
                const Icon(
                  Icons.notifications_none,
                  size: 27,
                  color: Color(0xFF334155),
                ),
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1465FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 22),

            // PROFILE
            Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FB),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: const Color(0xFFE0E5EC),
                ),
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4359A7),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF315EFF),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF718096),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// LEFT SIDEBAR
// ============================================================

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 15),

          // LOGO
          Container(
            width: 51,
            height: 51,
            decoration: BoxDecoration(
              color: const Color(0xFF11163D),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFF315EFF),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(height: 28),

          _sideItem(
            Icons.description_outlined,
            const Color(0xFFE8FBF7),
            const Color(0xFF08A58F),
          ),

          _sideItem(
            Icons.mail_outline,
            const Color(0xFFE8FBF7),
            const Color(0xFF08A58F),
          ),

          _sideItem(
            Icons.business_center_outlined,
            const Color(0xFFECEBFF),
            const Color(0xFF6157E8),
          ),

          _sideItem(
            Icons.menu_book_outlined,
            const Color(0xFFFFEAF4),
            const Color(0xFFDE3284),
          ),

          _sideItem(
            Icons.language,
            const Color(0xFFEDEBFF),
            const Color(0xFF7654E8),
          ),

          _sideItem(
            Icons.check_circle_outline,
            const Color(0xFFE5FAFA),
            const Color(0xFF0AA5C0),
          ),

          // ACTIVE ANALYTICS
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 7,
            ),
            child: Container(
              width: 57,
              height: 57,
              decoration: BoxDecoration(
                color: const Color(0xFF594BF2),
                borderRadius: BorderRadius.circular(17),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x45594BF2),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: Colors.white,
                size: 29,
              ),
            ),
          ),

          const Spacer(),

          // REFERRAL
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E7),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.orange,
              size: 25,
            ),
          ),

          const SizedBox(height: 20),

          // BOTTOM
          Container(
            width: 57,
            height: 57,
            decoration: BoxDecoration(
              color: const Color(0xFF11163D),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.bolt,
              color: Colors.amber,
              size: 29,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sideItem(
    IconData icon,
    Color background,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 23,
        ),
      ),
    );
  }
}
