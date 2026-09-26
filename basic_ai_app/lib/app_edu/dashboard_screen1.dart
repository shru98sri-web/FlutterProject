import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class dashb1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: DashboardScreen1(),
    );
  }
}

class DashboardScreen1 extends StatefulWidget {
  const DashboardScreen1({super.key});

  @override
  State<DashboardScreen1> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen1> {
  int selectedIndex = 0;
  bool assistantOpen = false;

  final Color navy = const Color(0xFF05058F);
  final Color yellow = const Color(0xFFFFC629);
  final Color blue = const Color(0xFF315EFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: Row(
                      children: [
                        _buildSideBar(),
                        Expanded(
                          child: _buildMainContent(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (assistantOpen) _buildAssistantPanel(),
              if (!assistantOpen) _buildAssistantFloatingButton(),
              //handling google assistant
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
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
          const SizedBox(width: 24),

          // Logo / AI button
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF11118F),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: blue.withOpacity(.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 34),

          // Hamburger
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE6E9EF),
              ),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                size: 28,
              ),
            ),
          ),

          const SizedBox(width: 18),

          // Breadcrumb
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3267F6),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Sasthra',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/',
                  style: GoogleFonts.inter(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Main',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          const Icon(
            Icons.chevron_right,
            color: Color(0xFFB5BDC9),
          ),

          const SizedBox(width: 18),

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
              size: 22,
            ),
          ),

          const SizedBox(width: 16),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Overview of your activities, progress & career metrics',
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const Spacer(),

          _creditsWidget(),

          const SizedBox(width: 20),

          _rewardsWidget(),

          const SizedBox(width: 22),

          const Icon(
            Icons.notifications_none_outlined,
            size: 29,
            color: Color(0xFF344054),
          ),

          const SizedBox(width: 25),

          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE7EAF0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2634A7),
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),

          const SizedBox(width: 25),
        ],
      ),
    );
  }

  Widget _creditsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
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
          Icon(
            Icons.generating_tokens_outlined,
            color: const Color(0xFFF59E0B),
            size: 19,
          ),
          const SizedBox(width: 8),
          Text(
            '₹348',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF92400E),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'CREDITS',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: const Color(0xFF92400E),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.visibility_off_outlined,
            size: 16,
            color: Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _rewardsWidget() {
    return Row(
      children: [
        const Icon(
          Icons.card_giftcard_outlined,
          color: Color(0xFF4B46E8),
        ),
        const SizedBox(width: 7),
        Text(
          'Rewards',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF344054),
          ),
        ),
        const SizedBox(width: 7),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Text(
            '+50',
            style: TextStyle(
              color: Color(0xFF4F46E5),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LEFT SIDEBAR
  // ============================================================

  Widget _buildSideBar() {
    return Container(
      width: 102,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 28),
          _sideIcon(
            Icons.dashboard_customize_outlined,
            0,
          ),
          _sideIcon(
            Icons.emoji_events_outlined,
            1,
          ),
          _sideIcon(
            Icons.explore_outlined,
            2,
          ),
          _sideIcon(
            Icons.auto_awesome,
            3,
          ),
          _sideIcon(
            Icons.code_outlined,
            4,
          ),
          _sideIcon(
            Icons.hexagon_outlined,
            5,
          ),
          _sideIcon(
            Icons.keyboard_outlined,
            6,
          ),
          _sideIcon(
            Icons.psychology_outlined,
            7,
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(
              bottom: 18,
            ),
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF15184F),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.bolt,
              color: Color(0xFFFFC629),
              size: 27,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideIcon(
    IconData icon,
    int index,
  ) {
    final selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.only(
          bottom: 18,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF5668F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(
                      0xFF5668F5,
                    ).withOpacity(.25),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: selected ? Colors.white : const Color(0xFF657184),
          size: 25,
        ),
      ),
    );
  }

  // ============================================================
  // MAIN HERO
  // ============================================================

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 850,
        ),
        decoration: BoxDecoration(
          color: navy,
        ),
        child: Stack(
          children: [
            _backgroundDecoration(),
            Padding(
              padding: const EdgeInsets.only(
                left: 63,
                top: 74,
                right: 60,
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _platformBadge(),
                  const SizedBox(height: 55),
                  Text(
                    'Good Evening,',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 76,
                      height: .98,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Shruthi',
                    style: GoogleFonts.inter(
                      color: yellow,
                      fontSize: 82,
                      height: .98,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -3,
                    ),
                  ),
                  const SizedBox(height: 45),
                  Text(
                    'Accelerate Your Career Journey',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 31,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: 780,
                    child: Text(
                      'Master essential skills, build your portfolio, and land your dream\n'
                      'job with our comprehensive learning platform.',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.65,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 21,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Get Started',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Icon(
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
      ),
    );
  }

  Widget _platformBadge() {
    //to add a native platform app icon badge in flutter
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: yellow,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.track_changes,
            color: yellow,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            'CAREER DEVELOPMENT PLATFORM',
            style: GoogleFonts.inter(
              color: yellow,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: .3,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BACKGROUND CIRCLES
  // ============================================================

  Widget _backgroundDecoration() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              left: 55,
              top: 15,
              child: _circle(
                200,
                Colors.white.withOpacity(.08),
              ),
            ),
            Positioned(
              right: 180,
              top: 195,
              child: _circle(
                420,
                Colors.white.withOpacity(.08),
              ),
            ),
            Positioned(
              right: 70,
              top: 480,
              child: _circle(
                260,
                Colors.white.withOpacity(.07),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 120,
              child: _circle(
                300,
                Colors.white.withOpacity(.035),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(
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

  // ============================================================
  // FLOATING AI BUTTON
  // ============================================================

  Widget _buildAssistantFloatingButton() {
    return Positioned(
      right: 48,
      bottom: 45,
      child: GestureDetector(
        onTap: () {
          setState(() {
            assistantOpen = true;
          });
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE9F4F8),
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.18),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.smart_toy_outlined,
              size: 53,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // AI ASSISTANT PANEL
  // ============================================================

  Widget _buildAssistantPanel() {
    return Positioned(
      right: 25,
      top: 120,
      bottom: 125,
      width: 520,
      child: Material(
        elevation: 25,
        borderRadius: BorderRadius.circular(23),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(23),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              _assistantHeader(),
              Expanded(
                child: _assistantMessages(),
              ),
              _assistantInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _assistantHeader() {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF05058F),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: const BoxDecoration(
              color: Color(0xFF00E676),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            'AI Assistant',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.open_in_full,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                assistantOpen = false;
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _assistantMessages() {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE1E7EF),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "I'm your AI assistant. I can help you with:",
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    height: 1.5,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 18),
                _assistantBullet(
                  'Interview preparation tips',
                ),
                _assistantBullet(
                  'Platform features and navigation',
                ),
                _assistantBullet(
                  'Technical questions',
                ),
                _assistantBullet(
                  'Career guidance',
                ),
                const SizedBox(height: 22),
                Text(
                  'How can I assist you today?',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '07:50 PM',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _assistantBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _assistantInput() {
    final controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(23),
          bottomRight: Radius.circular(23),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF98A2B3),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFDDE3EC),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFDDE3EC),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF5668F5),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6FA),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.send_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
//ignore pointer used to prevent the user from interacting with a specific widget and its entire subtree
