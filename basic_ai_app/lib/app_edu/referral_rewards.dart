import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// ============================================================
// APP
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sasthra Referral Rewards',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      ),
      home: const ReferralRewardsScreen(),
    );
  }
}

// ============================================================
// REFERRAL SCREEN
// ============================================================

class ReferralRewardsScreen extends StatefulWidget {
  const ReferralRewardsScreen({super.key});

  @override
  State<ReferralRewardsScreen> createState() => _ReferralRewardsScreenState();
}

class _ReferralRewardsScreenState extends State<ReferralRewardsScreen> {
  bool generated = false;
  String referralCode = '';

  void generateCode() {
    setState(() {
      generated = true;
      referralCode = 'SASTHRA${DateTime.now().millisecond}';
    });
  }

  void copyCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code copied'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Row(
          children: [
            const SideNavigation(),
            Expanded(
              child: Column(
                children: [
                  const TopNavigation(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildContent(),
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

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 45,
        vertical: 40,
      ),
      child: Column(
        children: [
          // ==================================================
          // HERO ICON
          // ==================================================

          Container(
            width: 83,
            height: 83,
            decoration: BoxDecoration(
              color: const Color(0xFF2468F2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x302466F2),
                  blurRadius: 15,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.white,
              size: 43,
            ),
          ),

          const SizedBox(height: 24),

          // ==================================================
          // TITLE
          // ==================================================

          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Referral ',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF101B35),
                  ),
                ),
                TextSpan(
                  text: 'Rewards',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1616A8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Share your code and earn credits together',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF52627A),
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 40),

          // ==================================================
          // GENERATE REFERRAL CARD
          // ==================================================

          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 1160,
            ),
            padding: const EdgeInsets.fromLTRB(
              32,
              31,
              32,
              35,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE0E4EA),
                width: 1.5,
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
              children: [
                // CARD TITLE
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEAF1FF),
                        ),
                        child: const Icon(
                          Icons.share,
                          size: 18,
                          color: Color(0xFF1264F4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Generate Referral Code',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14213D),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 65),

                if (!generated) ...[
                  const Text(
                    'Generate a unique referral code to share with others',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      color: Color(0xFF52627A),
                    ),
                  ),
                  const SizedBox(height: 23),
                  SizedBox(
                    height: 63,
                    child: ElevatedButton.icon(
                      onPressed: generateCode,
                      icon: const Icon(
                        Icons.card_giftcard,
                        size: 25,
                      ),
                      label: const Text(
                        'Generate Code',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E5FF5),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: const Color(0x401E5FF5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const Text(
                    'Your referral code is ready!',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF52627A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 17,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F8FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFBFD2FF),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            referralCode,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: Color(0xFF1747B5),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: copyCode,
                          icon: const Icon(
                            Icons.copy,
                            color: Color(0xFF2468F2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: copyCode,
                        icon: const Icon(Icons.copy),
                        label: const Text(
                          'Copy Code',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E5FF5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: generateCode,
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          'Generate Again',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1E5FF5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ==================================================
          // REWARD INFORMATION CARD
          // ==================================================

          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 1160,
            ),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE0E4EA),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How Referral Rewards Work',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14213D),
                  ),
                ),
                const SizedBox(height: 25),
                Wrap(
                  spacing: 35,
                  runSpacing: 25,
                  children: const [
                    RewardStep(
                      number: '1',
                      icon: Icons.share,
                      title: 'Share your code',
                      text: 'Share your unique referral code with friends.',
                    ),
                    RewardStep(
                      number: '2',
                      icon: Icons.person_add_alt_1,
                      title: 'Friend joins',
                      text: 'Your friend signs up using your code.',
                    ),
                    RewardStep(
                      number: '3',
                      icon: Icons.card_giftcard,
                      title: 'Earn credits',
                      text: 'Both users receive referral rewards.',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ============================================================
// REWARD STEP
// ============================================================

class RewardStep extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String text;

  const RewardStep({
    super.key,
    required this.number,
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF2468F2),
                  size: 25,
                ),
              ),
              Positioned(
                right: -5,
                top: -7,
                child: Container(
                  width: 21,
                  height: 21,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2468F2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF17233D),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF68768A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TOP NAVIGATION
// ============================================================

class TopNavigation extends StatelessWidget {
  const TopNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE6EAF0),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
        ),
        child: Row(
          children: [
            // MENU BUTTON
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
                color: Color(0xFF536174),
                size: 26,
              ),
            ),

            const SizedBox(width: 17),

            // BREADCRUMB
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Text(
                    'Sasthra',
                    style: TextStyle(
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.w700,
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
                    'Rewards',
                    style: TextStyle(
                      color: Color(0xFF52627A),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 18),

            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.card_giftcard,
                color: Color(0xFFFF8A00),
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Referral Rewards',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF18243B),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Share your invite code and unlock bonus credits',
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
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFFD992),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.link,
                    color: Color(0xFFE27B00),
                    size: 19,
                  ),
                  SizedBox(width: 8),
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
                      color: Color(0xFF994D00),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
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
                  color: Color(0xFF5941FF),
                  size: 20,
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

            const SizedBox(width: 23),

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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: const Color(0xFFE1E6EF),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4259A8),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2468F2),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 1,
                    bottom: 5,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
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

class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key});

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

          _item(
            Icons.description_outlined,
            const Color(0xFFE9FBF7),
            const Color(0xFF0BAA94),
          ),

          _item(
            Icons.mail_outline,
            const Color(0xFFE9FBF7),
            const Color(0xFF0BAA94),
          ),

          _item(
            Icons.business_center_outlined,
            const Color(0xFFECEBFF),
            const Color(0xFF6157E8),
          ),

          _item(
            Icons.menu_book_outlined,
            const Color(0xFFFFEAF4),
            const Color(0xFFDF3284),
          ),

          _item(
            Icons.language,
            const Color(0xFFEDEBFF),
            const Color(0xFF7654E8),
          ),

          _item(
            Icons.check_circle_outline,
            const Color(0xFFE6FAFA),
            const Color(0xFF0AA5C0),
          ),

          _item(
            Icons.bar_chart,
            const Color(0xFFE6F9FA),
            const Color(0xFF159BC4),
          ),

          const Spacer(),

          // ACTIVE REFERRAL BUTTON
          Container(
            width: 57,
            height: 57,
            decoration: BoxDecoration(
              color: const Color(0xFF6251F5),
              borderRadius: BorderRadius.circular(17),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x456251F5),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(height: 20),

          // BOTTOM BUTTON
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

  Widget _item(
    IconData icon,
    Color background,
    Color iconColor,
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
          color: iconColor,
          size: 23,
        ),
      ),
    );
  }
}
