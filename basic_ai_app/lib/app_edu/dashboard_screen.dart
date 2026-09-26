import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ai_floating_button.dart';
import 'chat_screen.dart';
import 'login_screen.dart';
import 'platform_pages.dart';
import 'sidebar_navi_icon.dart';
import 'top_navi_icons.dart';

class dashb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  bool chatOpen = false;

  bool profileOpen = false;

  // ==========================================================
  // NINE PAGES
  // ==========================================================

   final List<Widget> pages = [
    const DashboardHome(),
    const AchievementsPage(),
    const CareerExplorerPage(),
    const AICareerToolsPage(),
    const CodingLabPage(),
    const SkillsAssessmentPage(),
    const TypingPracticePage(),
    const ChatScreen(),
    const QuickActionsPage(),
  ];

  final List<IconData> icons = [
    Icons.dashboard_customize_outlined,
    Icons.emoji_events_outlined,
    Icons.explore_outlined,
    Icons.auto_awesome,
    Icons.code_outlined,
    Icons.hexagon_outlined,
    Icons.keyboard_outlined,
    Icons.psychology_outlined,
    Icons.bolt,
  ];

  final List<String> labels = [
    'Dashboard',
    'Achievements',
    'Career Explorer',
    'AI Career Tools',
    'Coding Lab',
    'Skills Assessment',
    'Typing Practice',
    'AI Assistant',
    'Quick Actions',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      body: Stack(
        children: [
          Column(
            children: [
              _topNavigation(),
              Expanded(
                child: Row(
                  children: [
                    _sideNavigation(),
                    Expanded(
                      child: IndexedStack(
                        index: selectedIndex,
                        children: pages,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (chatOpen) _chatOverlay(),
          if (!chatOpen)
            Positioned(
              right: 45,
              bottom: 35,
              child: AIFloatingButton(
                onTap: () {
                  setState(() {
                    chatOpen = true;
                  });
                },
              ),
            ),
          if (profileOpen) _profilePopup(),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP NAVIGATION
  // ==========================================================

  Widget _topNavigation() {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 22),

          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 28),

          TopNavIcon(
            icon: Icons.menu,
            tooltip: 'Menu',
            onTap: () {},
          ),

          const SizedBox(width: 10),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3167F5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                const Text(
                  'Sasthra',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('/'),
                const SizedBox(width: 8),
                const Text(
                  'Main',
                  style: TextStyle(
                    color: Colors.white30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          const Icon(
            Icons.chevron_right,
            color: Color(0xFF98A2B3),
          ),

          const SizedBox(width: 16),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: Color(0xFF3564F4),
            ),
          ),

          const SizedBox(width: 15),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labels[selectedIndex],
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Overview of your activities, progress & career metrics',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white30,
                ),
              ),
            ],
          ),

          const Spacer(),

          _credits(),

          const SizedBox(width: 20),

          _rewards(),

          const SizedBox(width: 18),

          TopNavIcon(
            icon: Icons.notifications_none_outlined,
            tooltip: 'Notifications',
            onTap: () {},
          ),

          const SizedBox(width: 8),

          // ==================================================
          // LOGIN / PROFILE ICON
          // ==================================================

          GestureDetector(
            onTap: () {
              setState(() {
                profileOpen = !profileOpen;
              });
            },
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2837A8),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    profileOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _credits() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFD76A),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.generating_tokens_outlined,
            size: 19,
            color: Color(0xFFF59E0B),
          ),
          const SizedBox(width: 7),
          const Text(
            '₹348',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF92400E),
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            'CREDITS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF92400E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rewards() {
    return Row(
      children: [
        const Icon(
          Icons.card_giftcard_outlined,
          color: Color(0xFF4B46E8),
        ),
        const SizedBox(width: 7),
        const Text(
          'Rewards',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 7),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '+50',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF4F46E5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SIDEBAR
  // ==========================================================

  Widget _sideNavigation() {
    return Container(
      width: 102,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 30),
          for (int i = 0; i < icons.length; i++)
            SidebarNavIcon(
              icon: icons[i],
              selected: selectedIndex == i,
              tooltip: labels[i],
              onTap: () {
                setState(() {
                  selectedIndex = i;
                  profileOpen = false;
                });
              },
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // PROFILE POPUP
  // ==========================================================

  Widget _profilePopup() {
    return Positioned(
      right: 20,
      top: 82,
      child: Material(
        elevation: 15,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 270,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2837A8),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shruthi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Career AI User',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                height: 30,
              ),
              _profileItem(
                Icons.person_outline,
                'My Profile',
                () {},
              ),
              _profileItem(
                Icons.settings_outlined,
                'Settings',
                () {},
              ),
              _profileItem(
                Icons.login_outlined,
                'Login',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),
              _profileItem(
                Icons.logout,
                'Logout',
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: const Color(0xFF475467),
            ),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CHAT OVERLAY
  // ==========================================================

  Widget _chatOverlay() {
    return Positioned(
      right: 25,
      top: 120,
      bottom: 25,
      width: 520,
      child: Material(
        elevation: 25,
        borderRadius: BorderRadius.circular(23),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              height: 72,
              color: Colors.blueAccent,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Text(
                    'AI Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        chatOpen = false;
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: ChatScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// DASHBOARD HOME PAGE
// =================================================================

class DashboardHome extends StatelessWidget {
  const DashboardHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Stack(
        children: [
          Positioned(
            left: 60,
            top: 20,
            child: _circle(
              190,
              Colors.white.withOpacity(.07),
            ),
          ),
          Positioned(
            right: 180,
            top: 165,
            child: _circle(
              420,
              Colors.white.withOpacity(.08),
            ),
          ),
          Positioned(
            right: 40,
            top: 480,
            child: _circle(
              270,
              Colors.white.withOpacity(.07),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 62,
              top: 72,
              right: 60,
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.yellow,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.track_changes,
                        color: Colors.yellow,
                      ),
                      SizedBox(width: 9),
                      Text(
                        'CAREER DEVELOPMENT PLATFORM',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 55),
                const Text(
                  'Good Evening,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 76,
                    height: .98,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Shruthi',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 82,
                    height: .98,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 42),
                const Text(
                  'Accelerate Your Career Journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Master essential skills, build your portfolio, and land your dream\n'
                  'job with our comprehensive learning platform.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _circle(
    double size,
    Color color,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
