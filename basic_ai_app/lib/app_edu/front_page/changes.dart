import 'package:flutter/material.dart';

// void main() {
//   runApp(const IntervuCloneApp());
// }

// ============================================================
// THEME
// ============================================================

class AppColors {
  static const navy = Color(0xFF101B3D);
  static const navy2 = Color(0xFF17275A);
  static const blue = Color(0xFF2867F0);
  static const purple = Color(0xFF6C4CF1);
  static const cyan = Color(0xFF22B8E8);
  static const green = Color(0xFF22B573);
  static const orange = Color(0xFFFFA63D);
  static const red = Color(0xFFEF5350);
  static const bg = Color(0xFFF7F8FC);
  static const border = Color(0xFFE7EAF2);
  static const text = Color(0xFF20263A);
  static const muted = Color(0xFF7D8498);
}

class IntervuCloneApp extends StatelessWidget {
  const IntervuCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Career Platform',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        fontFamily: 'Arial',
      ),
      home: const AppShell(),
    );
  }
}

// ============================================================
// PAGE MODEL
// ============================================================

class AppPage {
  final String title;
  final IconData icon;
  final WidgetBuilder builder;

  const AppPage({
    required this.title,
    required this.icon,
    required this.builder,
  });
}

// ============================================================
// MAIN SHELL
// ============================================================

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selected = 0;
  bool assistantOpen = false;

  late final List<AppPage> pages = [
    AppPage(
        title: 'Dashboard',
        icon: Icons.grid_view_rounded,
        builder: (_) => const DashboardPage()),
    AppPage(
        title: 'Leaderboard',
        icon: Icons.emoji_events_outlined,
        builder: (_) => const LeaderboardPage()),
    AppPage(
        title: 'AI Assistant',
        icon: Icons.smart_toy_outlined,
        builder: (_) => const AIChatPage()),
    AppPage(
        title: 'Recommendations',
        icon: Icons.lightbulb_outline_rounded,
        builder: (_) => const RecommendationsPage()),
    AppPage(
        title: 'Elite Coder',
        icon: Icons.code_rounded,
        builder: (_) => const EliteCoderPage()),
    AppPage(
        title: 'Quiz',
        icon: Icons.quiz_outlined,
        builder: (_) => const QuizPage()),
    AppPage(
        title: 'Lessons',
        icon: Icons.menu_book_outlined,
        builder: (_) => const LessonsPage()),
    AppPage(
        title: 'Aptitude & Reasoning',
        icon: Icons.psychology_alt_outlined,
        builder: (_) => const AptitudePage()),
    AppPage(
        title: 'Interview Prep',
        icon: Icons.business_center_outlined,
        builder: (_) => const InterviewPage()),
    AppPage(
        title: 'Group Discussion',
        icon: Icons.groups_outlined,
        builder: (_) => const GroupDiscussionPage()),
    AppPage(
        title: 'ATS Checker',
        icon: Icons.fact_check_outlined,
        builder: (_) => const ATSCheckerPage()),
    AppPage(
        title: 'Resume Builder',
        icon: Icons.description_outlined,
        builder: (_) => const ResumeBuilderPage()),
    AppPage(
        title: 'Cover Letter',
        icon: Icons.mail_outline_rounded,
        builder: (_) => const CoverLetterPage()),
    AppPage(
        title: 'AI Portfolio',
        icon: Icons.web_outlined,
        builder: (_) => const PortfolioPage()),
    AppPage(
        title: 'Skills',
        icon: Icons.auto_awesome_outlined,
        builder: (_) => const SkillsPage()),
    AppPage(
        title: 'Visa Interview',
        icon: Icons.flight_takeoff_outlined,
        builder: (_) => const VisaInterviewPage()),
    AppPage(
        title: 'Interview Precheck',
        icon: Icons.verified_user_outlined,
        builder: (_) => const InterviewPrecheckPage()),
    AppPage(
        title: 'Real-Time Analytics',
        icon: Icons.analytics_outlined,
        builder: (_) => const AnalyticsPage()),
    AppPage(
        title: 'Referral Rewards',
        icon: Icons.card_giftcard_outlined,
        builder: (_) => const ReferralPage()),
    AppPage(
        title: 'Plans & Billing',
        icon: Icons.credit_card_outlined,
        builder: (_) => const BillingPage()),
  ];

  void selectPage(int index) {
    setState(() {
      selected = index;
      assistantOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;

        return Scaffold(
          body: Stack(
            children: [
              Row(
                children: [
                  if (!compact)
                    SideRail(
                      pages: pages,
                      selected: selected,
                      onSelected: selectPage,
                    ),
                  Expanded(
                    child: Column(
                      children: [
                        TopBar(
                          title: pages[selected].title,
                          compact: compact,
                          onMenu:
                              compact ? () => _showMobileMenu(context) : null,
                          onAssistant: () {
                            setState(() => assistantOpen = true);
                          },
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: selected,
                            children: pages
                                .map((p) => Builder(builder: p.builder))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (compact && assistantOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => setState(() => assistantOpen = false),
                    child: Container(color: Colors.black38),
                  ),
                ),
              if (assistantOpen)
                Positioned(
                  top: 70,
                  right: 16,
                  bottom: 16,
                  width: compact ? constraints.maxWidth - 32 : 390,
                  child: AssistantPanel(
                    onClose: () => setState(() => assistantOpen = false),
                  ),
                ),
              if (!assistantOpen)
                Positioned(
                  right: 22,
                  bottom: 22,
                  child: FloatingAssistantButton(
                    onTap: () => setState(() => assistantOpen = true),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 12),
          children: [
            for (int i = 0; i < pages.length; i++)
              ListTile(
                leading: Icon(
                  pages[i].icon,
                  color: i == selected ? AppColors.blue : AppColors.muted,
                ),
                title: Text(pages[i].title),
                selected: i == selected,
                onTap: () {
                  Navigator.pop(context);
                  selectPage(i);
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TOP BAR + SIDE NAV
// ============================================================

class SideRail extends StatelessWidget {
  final List<AppPage> pages;
  final int selected;
  final ValueChanged<int> onSelected;

  const SideRail({
    super.key,
    required this.pages,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: const LinearGradient(
                colors: [AppColors.blue, AppColors.purple],
              ),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemBuilder: (_, i) {
                final active = selected == i;
                return Tooltip(
                  message: pages[i].title,
                  child: InkWell(
                    onTap: () => onSelected(i),
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.blue.withOpacity(.10)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        pages[i].icon,
                        color: active ? AppColors.blue : AppColors.muted,
                        size: 22,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: Color(0xFFE9EDFA),
              child: Icon(Icons.person_outline, color: AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final String title;
  final bool compact;
  final VoidCallback? onMenu;
  final VoidCallback onAssistant;

  const TopBar({
    super.key,
    required this.title,
    required this.compact,
    required this.onMenu,
    required this.onAssistant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (compact)
            IconButton(
              onPressed: onMenu,
              icon: const Icon(Icons.menu_rounded),
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const Spacer(),
          _CreditPill(
            icon: Icons.bolt_rounded,
            value: '1,250',
          ),
          const SizedBox(width: 8),
          _CreditPill(
            icon: Icons.workspace_premium_outlined,
            value: '240',
          ),
          const SizedBox(width: 10),
          IconButton(
            tooltip: 'AI Assistant',
            onPressed: onAssistant,
            icon: const Icon(Icons.smart_toy_outlined),
          ),
          const SizedBox(width: 4),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE8EEFF),
            child: Icon(Icons.person_outline, color: AppColors.blue),
          ),
        ],
      ),
    );
  }
}

class _CreditPill extends StatelessWidget {
  final IconData icon;
  final String value;

  const _CreditPill({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.purple),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COMMON UI
// ============================================================

class PageBody extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const PageBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(28, 26, 28, 40),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: child,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;

  const CardBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 5),
            color: Color(0x07000000),
          ),
        ],
      ),
      child: child,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 17),
      label: Text(text),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.open_in_new_rounded, size: 17),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CardBox(
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.blue),
          ),
          const SizedBox(width: 13),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  const FeatureTile({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: CardBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: AppColors.purple),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 13),
            const Row(
              children: [
                Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_rounded,
                    size: 14, color: AppColors.blue),
              ],
            ),
          ],
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
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.navy, AppColors.navy2, AppColors.blue],
              ),
            ),
            child: LayoutBuilder(
              builder: (_, c) {
                return Flex(
                  direction: c.maxWidth > 700 ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: c.maxWidth > 700 ? 3 : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CAREER DEVELOPMENT PLATFORM',
                            style: TextStyle(
                              color: Color(0xFFAFC5FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Good Evening, Shruthi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 31,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 9),
                          const Text(
                            'Build skills, practise interviews and move closer to your next career opportunity.',
                            style: TextStyle(
                              color: Color(0xFFD8E1FF),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              FilledButton(
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.navy,
                                ),
                                child: const Text('Continue learning'),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white54),
                                ),
                                child: const Text('View recommendations'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (c.maxWidth > 700) const SizedBox(width: 30),
                    SizedBox(
                      width: c.maxWidth > 700 ? 250 : double.infinity,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(.08),
                              border: Border.all(color: Colors.white24),
                            ),
                          ),
                          const Icon(
                            Icons.smart_toy_rounded,
                            size: 78,
                            color: Colors.white,
                          ),
                          Positioned(
                            right: 30,
                            top: 20,
                            child: _MiniOrb(icon: Icons.auto_awesome),
                          ),
                          Positioned(
                            left: 25,
                            bottom: 24,
                            child:
                                _MiniOrb(icon: Icons.psychology_alt_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 2.25,
            children: const [
              StatCard(
                  label: 'Learning progress',
                  value: '68%',
                  icon: Icons.trending_up),
              StatCard(
                  label: 'Interview readiness',
                  value: '74%',
                  icon: Icons.business_center_outlined),
              StatCard(
                  label: 'Skills completed',
                  value: '18',
                  icon: Icons.auto_awesome_outlined),
              StatCard(
                  label: 'Practice streak',
                  value: '12 days',
                  icon: Icons.local_fire_department_outlined),
            ],
          ),
          const SizedBox(height: 26),
          const SectionTitle(
            title: 'Explore your AI career tools',
            subtitle: 'Use the tools below to practise, improve and prepare.',
          ),
          LayoutBuilder(
            builder: (_, c) {
              final cols = c.maxWidth > 1000
                  ? 4
                  : c.maxWidth > 650
                      ? 2
                      : 1;
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.45,
                children: const [
                  FeatureTile(
                    title: 'AI Interview Prep',
                    description:
                        'Practise interview questions with guided AI feedback.',
                    icon: Icons.record_voice_over_outlined,
                  ),
                  FeatureTile(
                    title: 'Resume Builder',
                    description:
                        'Create a professional resume using structured templates.',
                    icon: Icons.description_outlined,
                  ),
                  FeatureTile(
                    title: 'ATS Checker',
                    description:
                        'Review your resume against ATS-friendly requirements.',
                    icon: Icons.fact_check_outlined,
                  ),
                  FeatureTile(
                    title: 'AI Portfolio',
                    description:
                        'Build a polished portfolio from your career details.',
                    icon: Icons.web_outlined,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          CardBox(
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFE9EDFF),
                  child: Icon(Icons.lightbulb_outline, color: AppColors.blue),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today’s recommendation',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Complete one interview practice session and review your feedback.',
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                PrimaryButton(text: 'Start'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniOrb extends StatelessWidget {
  final IconData icon;

  const _MiniOrb({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(.12),
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

// ============================================================
// LEADERBOARD
// ============================================================

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      ('Ananya R', '9,840', '98%'),
      ('Rahul K', '9,240', '95%'),
      ('Shruthi', '8,720', '91%'),
      ('Priya S', '8,110', '89%'),
      ('Arjun M', '7,940', '87%'),
    ];

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Leaderboard',
            subtitle: 'Track your progress against other learners.',
          ),
          CardBox(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  color: const Color(0xFFF7F8FC),
                  child: const Row(
                    children: [
                      SizedBox(width: 50, child: Text('#')),
                      Expanded(child: Text('Learner')),
                      SizedBox(width: 120, child: Text('Score')),
                      SizedBox(width: 100, child: Text('Accuracy')),
                    ],
                  ),
                ),
                for (int i = 0; i < users.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 17,
                                backgroundColor:
                                    AppColors.blue.withOpacity(.10),
                                child: Text(
                                  users[i].$1.substring(0, 1),
                                  style: const TextStyle(color: AppColors.blue),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(users[i].$1),
                            ],
                          ),
                        ),
                        SizedBox(width: 120, child: Text(users[i].$2)),
                        SizedBox(width: 100, child: Text(users[i].$3)),
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
}

// ============================================================
// AI CHAT
// ============================================================

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final controller = TextEditingController();
  final scroll = ScrollController();
  final messages = <ChatMessage>[
    ChatMessage(
      text: 'Hello! I am your AI career assistant. How can I help you today?',
      mine: false,
    ),
  ];
  bool typing = false;

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty || typing) return;

    controller.clear();
    setState(() {
      messages.add(ChatMessage(text: text, mine: true));
      typing = true;
    });

    await Future.delayed(const Duration(milliseconds: 650));

    setState(() {
      messages.add(ChatMessage(text: demoReply(text), mine: false));
      typing = false;
    });

    await Future.delayed(const Duration(milliseconds: 30));
    if (scroll.hasClients) {
      scroll.animateTo(
        scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  String demoReply(String input) {
    final q = input.toLowerCase();
    if (q.contains('resume')) {
      return 'I can help you improve your resume structure, achievements, skills and ATS readability.';
    }
    if (q.contains('interview')) {
      return 'Try a mock interview first. I can also help you practise technical, HR and behavioural questions.';
    }
    if (q.contains('flutter')) {
      return 'For Flutter preparation, practise Dart fundamentals, widgets, state management, navigation and responsive layouts.';
    }
    if (q.contains('job')) {
      return 'Start by defining your target role, then align your resume, skills and interview preparation with that role.';
    }
    return 'That is a good career-development question. Try giving me the role, skill or interview situation you are working on.';
  }

  @override
  void dispose() {
    controller.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 30),
      child: CardBox(
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 650,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white12,
                      child:
                          Icon(Icons.smart_toy_outlined, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Assistant',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 4, backgroundColor: AppColors.green),
                              SizedBox(width: 6),
                              Text(
                                'Online',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => messages.clear()),
                      icon: const Icon(Icons.refresh_rounded,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scroll,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length + (typing ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (typing && i == messages.length) {
                      return const _TypingBubble();
                    }
                    final m = messages[i];
                    return Align(
                      alignment:
                          m.mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 650),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              m.mine ? AppColors.blue : const Color(0xFFF1F3F8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          m.text,
                          style: TextStyle(
                            color: m.mine ? Colors.white : AppColors.text,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onSubmitted: (_) => send(),
                        decoration: InputDecoration(
                          hintText: 'Ask your AI career assistant...',
                          filled: true,
                          fillColor: const Color(0xFFF6F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: send,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool mine;

  ChatMessage({required this.text, required this.mine});
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Text(
          'AI is typing...',
          style: TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ),
    );
  }
}

// ============================================================
// ASSISTANT OVERLAY
// ============================================================

class FloatingAssistantButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingAssistantButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.blue, AppColors.purple],
            ),
          ),
          child: const Icon(Icons.smart_toy_rounded,
              color: Colors.white, size: 27),
        ),
      ),
    );
  }
}

class AssistantPanel extends StatefulWidget {
  final VoidCallback onClose;

  const AssistantPanel({super.key, required this.onClose});

  @override
  State<AssistantPanel> createState() => _AssistantPanelState();
}

class _AssistantPanelState extends State<AssistantPanel> {
  final controller = TextEditingController();
  final messages = <ChatMessage>[
    ChatMessage(
      text:
          'Hi Shruthi! I’m your AI Assistant. What would you like to work on?',
      mine: false,
    ),
  ];

  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    controller.clear();
    setState(() {
      messages.add(ChatMessage(text: text, mine: true));
      messages.add(
        ChatMessage(
          text:
              'I can help you with resumes, interviews, skills, jobs and career preparation.',
          mine: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
            color: AppColors.navy,
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white12,
                  child: Icon(Icons.smart_toy_outlined, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 3.5, backgroundColor: AppColors.green),
                          SizedBox(width: 5),
                          Text(
                            'Online',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final m in messages)
                  Align(
                    alignment:
                        m.mine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 290),
                      decoration: BoxDecoration(
                        color:
                            m.mine ? AppColors.blue : const Color(0xFFF1F3F8),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        m.text,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: m.mine ? Colors.white : AppColors.text,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => send(),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: const Color(0xFFF6F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: send,
                  icon: const Icon(Icons.send_rounded, color: AppColors.blue),
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
// RECOMMENDATIONS
// ============================================================

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      (
        'Improve your interview introduction',
        'Practise a concise 60-second introduction.',
        Icons.record_voice_over_outlined
      ),
      (
        'Strengthen technical skills',
        'Complete the recommended technical lessons.',
        Icons.code_outlined
      ),
      (
        'Review your resume',
        'Improve measurable achievements and keywords.',
        Icons.description_outlined
      ),
      (
        'Practise communication',
        'Try a group discussion simulation.',
        Icons.groups_outlined
      ),
    ];

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Actionable Recommendations',
            subtitle: 'Personalized activities to help you progress.',
          ),
          for (final x in data)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CardBox(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(.10),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(x.$3, color: AppColors.blue),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(x.$1,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 5),
                          Text(x.$2,
                              style: const TextStyle(
                                  color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: AppColors.muted),
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
// ELITE CODER
// ============================================================

class EliteCoderPage extends StatelessWidget {
  const EliteCoderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [AppColors.navy, AppColors.purple],
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ELITE CODER',
                        style: TextStyle(
                          color: Color(0xFFCBD7FF),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.3,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 9),
                      Text(
                        'Level up your coding skills',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 29,
                        ),
                      ),
                      SizedBox(height: 9),
                      Text(
                        'Solve coding challenges, improve problem solving and build consistency.',
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Icon(Icons.code_rounded, color: Colors.white, size: 90),
              ],
            ),
          ),
          const SizedBox(height: 22),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            childAspectRatio: 2.1,
            children: const [
              StatCard(
                  label: 'Problems solved',
                  value: '126',
                  icon: Icons.check_circle_outline),
              StatCard(
                  label: 'Current streak',
                  value: '12',
                  icon: Icons.local_fire_department_outlined),
              StatCard(
                  label: 'Rank',
                  value: '#482',
                  icon: Icons.emoji_events_outlined),
              StatCard(
                  label: 'Accuracy',
                  value: '87%',
                  icon: Icons.track_changes_outlined),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Recommended challenges'),
          LayoutBuilder(
            builder: (_, c) => GridView.count(
              crossAxisCount: c.maxWidth > 900 ? 3 : 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 2.0,
              children: const [
                FeatureTile(
                    title: 'Arrays & Strings',
                    description: 'Practice common interview patterns.',
                    icon: Icons.data_array),
                FeatureTile(
                    title: 'Algorithms',
                    description: 'Improve your algorithmic thinking.',
                    icon: Icons.account_tree_outlined),
                FeatureTile(
                    title: 'Problem Solving',
                    description: 'Timed coding practice.',
                    icon: Icons.timer_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// QUIZ
// ============================================================

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String category = 'Technical';
  String difficulty = 'Medium';
  int questions = 10;

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Quiz',
            subtitle: 'Configure your practice quiz.',
          ),
          CardBox(
            child: Column(
              children: [
                _DropdownField(
                  label: 'Category',
                  value: category,
                  items: const [
                    'Technical',
                    'Aptitude',
                    'Dart & Flutter',
                    'General'
                  ],
                  onChanged: (v) => setState(() => category = v!),
                ),
                const SizedBox(height: 18),
                _DropdownField(
                  label: 'Difficulty',
                  value: difficulty,
                  items: const ['Easy', 'Medium', 'Hard'],
                  onChanged: (v) => setState(() => difficulty = v!),
                ),
                const SizedBox(height: 18),
                _DropdownField(
                  label: 'Number of questions',
                  value: '$questions',
                  items: const ['5', '10', '15', '20'],
                  onChanged: (v) => setState(() => questions = int.parse(v!)),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    PrimaryButton(
                        text: 'Start Quiz', icon: Icons.play_arrow_rounded),
                    const SizedBox(width: 10),
                    Text(
                      '$questions questions • $difficulty',
                      style:
                          const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          items: [
            for (final item in items)
              DropdownMenuItem(value: item, child: Text(item)),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F9FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// LESSONS
// ============================================================

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      ('Dart Fundamentals', '12 lessons', Icons.code),
      ('Flutter Widgets', '18 lessons', Icons.widgets_outlined),
      ('State Management', '10 lessons', Icons.sync_alt),
      ('Responsive UI', '8 lessons', Icons.devices_outlined),
      ('Interview Coding', '15 lessons', Icons.laptop_mac_outlined),
      ('Communication', '9 lessons', Icons.record_voice_over_outlined),
    ];

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
              title: 'Lessons',
              subtitle: 'Continue learning at your own pace.'),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.6,
            children: [
              for (final x in lessons)
                FeatureTile(title: x.$1, description: x.$2, icon: x.$3),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// APTITUDE
// ============================================================

class AptitudePage extends StatefulWidget {
  const AptitudePage({super.key});

  @override
  State<AptitudePage> createState() => _AptitudePageState();
}

class _AptitudePageState extends State<AptitudePage> {
  String topic = 'Quantitative Aptitude';
  String level = 'Intermediate';

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Aptitude & Reasoning',
            subtitle: 'Select your practice configuration.',
          ),
          CardBox(
            child: Column(
              children: [
                _DropdownField(
                  label: 'Topic',
                  value: topic,
                  items: const [
                    'Quantitative Aptitude',
                    'Logical Reasoning',
                    'Verbal Ability',
                    'Data Interpretation',
                  ],
                  onChanged: (v) => setState(() => topic = v!),
                ),
                const SizedBox(height: 18),
                _DropdownField(
                  label: 'Level',
                  value: level,
                  items: const ['Beginner', 'Intermediate', 'Advanced'],
                  onChanged: (v) => setState(() => level = v!),
                ),
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryButton(
                      text: 'Start Practice', icon: Icons.play_arrow),
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
// INTERVIEW PREP
// ============================================================

class InterviewPage extends StatelessWidget {
  const InterviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modes = [
      (
        'Technical Interview',
        'Technical questions and problem solving.',
        Icons.code
      ),
      ('HR Interview', 'Behavioural and HR preparation.', Icons.people_outline),
      (
        'Mock Interview',
        'Simulate a complete interview session.',
        Icons.mic_none_outlined
      ),
      (
        'Role Based Interview',
        'Prepare for your target role.',
        Icons.business_center_outlined
      ),
    ];

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [AppColors.navy, AppColors.blue],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INTERVIEW PREPARATION',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 10),
                Text(
                  'Let’s Get You Interview Ready',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 9),
                Text(
                  'Practise realistic questions and improve your confidence.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.45,
            children: [
              for (final x in modes)
                FeatureTile(title: x.$1, description: x.$2, icon: x.$3),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GROUP DISCUSSION
// ============================================================

class GroupDiscussionPage extends StatelessWidget {
  const GroupDiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Group Discussion',
            subtitle: 'Practise speaking, structure and communication.',
          ),
          CardBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose a topic',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    'AI in Education',
                    'Future of Work',
                    'Remote Work',
                    'Technology',
                    'Environment',
                  ].map((e) => Chip(label: Text(e))).toList(),
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                    text: 'Start Discussion', icon: Icons.groups_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ATS CHECKER
// ============================================================

class ATSCheckerPage extends StatefulWidget {
  const ATSCheckerPage({super.key});

  @override
  State<ATSCheckerPage> createState() => _ATSCheckerPageState();
}

class _ATSCheckerPageState extends State<ATSCheckerPage> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'ATS Checker',
            subtitle:
                'Review your resume for applicant tracking system compatibility.',
          ),
          CardBox(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(38),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_upload_outlined,
                          size: 48, color: AppColors.blue),
                      const SizedBox(height: 12),
                      const Text(
                        'Upload your resume',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'PDF or DOCX • demo upload control',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                      const SizedBox(height: 18),
                      PrimaryButton(
                        text: 'Choose File',
                        icon: Icons.upload_file_outlined,
                        onPressed: () => setState(() => checked = true),
                      ),
                    ],
                  ),
                ),
                if (checked) ...[
                  const SizedBox(height: 20),
                  const _ScoreRow(label: 'ATS compatibility', value: 0.84),
                  const _ScoreRow(label: 'Keywords', value: 0.76),
                  const _ScoreRow(label: 'Formatting', value: 0.92),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final double value;

  const _ScoreRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 150, child: Text(label)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('${(value * 100).round()}%'),
        ],
      ),
    );
  }
}

// ============================================================
// RESUME BUILDER
// ============================================================

class ResumeBuilderPage extends StatefulWidget {
  const ResumeBuilderPage({super.key});

  @override
  State<ResumeBuilderPage> createState() => _ResumeBuilderPageState();
}

class _ResumeBuilderPageState extends State<ResumeBuilderPage> {
  final name = TextEditingController(text: 'Shruthi Srivatsan');
  final role = TextEditingController(text: 'Software / AI Career Professional');

  @override
  void dispose() {
    name.dispose();
    role.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
              title: 'Resume Builder',
              subtitle: 'Build your professional resume.'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CardBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Personal details',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 15),
                      _TextField(label: 'Full name', controller: name),
                      const SizedBox(height: 12),
                      _TextField(label: 'Target role', controller: role),
                      const SizedBox(height: 12),
                      const _TextField(label: 'Email'),
                      const SizedBox(height: 12),
                      const _TextField(label: 'Phone'),
                      const SizedBox(height: 20),
                      PrimaryButton(text: 'Save & Continue'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: CardBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Resume preview',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 15),
                      Container(
                        height: 410,
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name.text,
                                style: const TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 5),
                            Text(role.text,
                                style: const TextStyle(color: AppColors.blue)),
                            const Divider(height: 28),
                            const Text('PROFILE',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 11)),
                            const SizedBox(height: 8),
                            const Text(
                              'Professional summary and career highlights will appear here.',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.muted),
                            ),
                            const SizedBox(height: 20),
                            const Text('SKILLS',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 11)),
                            const SizedBox(height: 8),
                            const Text(
                                'Flutter • Dart • AI • Photonics • Research',
                                style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
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
// COVER LETTER
// ============================================================

class CoverLetterPage extends StatefulWidget {
  const CoverLetterPage({super.key});

  @override
  State<CoverLetterPage> createState() => _CoverLetterPageState();
}

class _CoverLetterPageState extends State<CoverLetterPage> {
  final role = TextEditingController();
  final company = TextEditingController();

  @override
  void dispose() {
    role.dispose();
    company.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Cover Letter Generator',
            subtitle: 'Create a tailored cover letter for a target role.',
          ),
          CardBox(
            child: Column(
              children: [
                _TextField(label: 'Target role', controller: role),
                const SizedBox(height: 13),
                _TextField(label: 'Company', controller: company),
                const SizedBox(height: 13),
                const _TextField(label: 'Key achievements'),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryButton(
                      text: 'Generate Cover Letter', icon: Icons.auto_awesome),
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
// PORTFOLIO
// ============================================================

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    final titles = ['Profile', 'Experience', 'Projects', 'Skills', 'Preview'];

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'AI Portfolio Maker',
            subtitle:
                'Create a professional portfolio from your career information.',
          ),
          CardBox(
            child: Column(
              children: [
                Row(
                  children: [
                    for (int i = 0; i < titles.length; i++) ...[
                      Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: i <= step
                                  ? AppColors.blue
                                  : const Color(0xFFECEEF4),
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: i <= step
                                      ? Colors.white
                                      : AppColors.muted,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              titles[i],
                              style: TextStyle(
                                fontSize: 11,
                                color: i <= step
                                    ? AppColors.blue
                                    : AppColors.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 30),
                if (step < 4)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titles[step],
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                      const SizedBox(height: 15),
                      const _TextField(label: 'Enter details'),
                      const SizedBox(height: 12),
                      const _TextField(label: 'Additional information'),
                    ],
                  )
                else
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.navy, AppColors.purple]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'PORTFOLIO PREVIEW',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    if (step > 0)
                      OutlineButton(
                        text: 'Back',
                        icon: Icons.arrow_back,
                        onPressed: () => setState(() => step--),
                      ),
                    const Spacer(),
                    PrimaryButton(
                      text: step == 4 ? 'Finish' : 'Continue',
                      onPressed: () {
                        if (step < 4) setState(() => step++);
                      },
                    ),
                  ],
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
// SKILLS
// ============================================================

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      ('Programming', Icons.code),
      ('AI & Machine Learning', Icons.smart_toy_outlined),
      ('Communication', Icons.record_voice_over_outlined),
      ('Leadership', Icons.groups_outlined),
      ('Data', Icons.bar_chart_outlined),
      ('Cloud', Icons.cloud_outlined),
      ('Design', Icons.design_services_outlined),
      ('Research', Icons.science_outlined),
      ('Cyber Security', Icons.security_outlined),
      ('DevOps', Icons.settings_suggest_outlined),
      ('Project Management', Icons.task_alt_outlined),
      ('Problem Solving', Icons.psychology_alt_outlined),
    ];

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
              title: 'Skills',
              subtitle: 'Explore skills and build your career profile.'),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 2.2,
            children: [
              for (final x in skills)
                FeatureTile(
                    title: x.$1,
                    description: 'Explore this skill category.',
                    icon: x.$2),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// VISA INTERVIEW
// ============================================================

class VisaInterviewPage extends StatefulWidget {
  const VisaInterviewPage({super.key});

  @override
  State<VisaInterviewPage> createState() => _VisaInterviewPageState();
}

class _VisaInterviewPageState extends State<VisaInterviewPage> {
  String country = 'United States';
  String purpose = 'Higher Education';

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'AI VISA Interview',
            subtitle:
                'Practise visa interview questions in a guided environment.',
          ),
          CardBox(
            child: Column(
              children: [
                _DropdownField(
                  label: 'Destination',
                  value: country,
                  items: const [
                    'United States',
                    'Canada',
                    'United Kingdom',
                    'Australia',
                    'Germany'
                  ],
                  onChanged: (v) => setState(() => country = v!),
                ),
                const SizedBox(height: 16),
                _DropdownField(
                  label: 'Purpose',
                  value: purpose,
                  items: const [
                    'Higher Education',
                    'Work',
                    'Business',
                    'Tourism'
                  ],
                  onChanged: (v) => setState(() => purpose = v!),
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryButton(
                      text: 'Start AI Interview',
                      icon: Icons.mic_none_outlined),
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
// PRECHECK
// ============================================================

class InterviewPrecheckPage extends StatelessWidget {
  const InterviewPrecheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checks = [
      ('Camera', 'Ready', Icons.videocam_outlined),
      ('Microphone', 'Ready', Icons.mic_none_outlined),
      ('Environment', 'Good', Icons.wifi_outlined),
      ('Profile', 'Complete', Icons.person_outline),
    ];

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Interview Precheck',
            subtitle: 'Make sure your setup is ready before starting.',
          ),
          CardBox(
            child: Column(
              children: [
                for (final x in checks)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.green.withOpacity(.12),
                      child: Icon(x.$3, color: AppColors.green),
                    ),
                    title: Text(x.$1,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(x.$2),
                    trailing:
                        const Icon(Icons.check_circle, color: AppColors.green),
                  ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryButton(
                      text: 'Continue', icon: Icons.arrow_forward),
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
// ANALYTICS
// ============================================================

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Real-Time Analytics',
            subtitle: 'Monitor your practice metrics.',
          ),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            childAspectRatio: 2.1,
            children: const [
              StatCard(
                  label: 'Sessions',
                  value: '24',
                  icon: Icons.play_circle_outline),
              StatCard(
                  label: 'Questions', value: '184', icon: Icons.help_outline),
              StatCard(
                  label: 'Avg. score',
                  value: '82%',
                  icon: Icons.analytics_outlined),
              StatCard(
                  label: 'Improvement', value: '+16%', icon: Icons.trending_up),
            ],
          ),
          const SizedBox(height: 20),
          CardBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Performance overview',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 22),
                SizedBox(
                  height: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final h in [
                        0.40,
                        0.55,
                        0.47,
                        0.66,
                        0.60,
                        0.78,
                        0.88,
                        0.72,
                        0.94
                      ])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: FractionallySizedBox(
                              heightFactor: h,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withOpacity(.75),
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6)),
                                ),
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
        ],
      ),
    );
  }
}

// ============================================================
// REFERRAL
// ============================================================

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [AppColors.navy, AppColors.purple],
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.card_giftcard_rounded,
                    color: Colors.white, size: 65),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Referral Rewards',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Invite friends and earn rewards.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CardBox(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your referral code',
                          style: TextStyle(color: AppColors.muted)),
                      SizedBox(height: 7),
                      Text(
                        'SHRUTHI240',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                PrimaryButton(text: 'Copy Code', icon: Icons.copy_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BILLING
// ============================================================

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      (
        'Free',
        '₹0',
        ['Basic practice', 'Limited AI usage', 'Community access']
      ),
      (
        'Pro',
        '₹499/mo',
        ['Advanced AI tools', 'Interview practice', 'Resume tools']
      ),
      (
        'Premium',
        '₹999/mo',
        ['All Pro features', 'Advanced analytics', 'Priority tools']
      ),
    ];

    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Plans & Billing',
            subtitle: 'Choose the plan that fits your learning needs.',
          ),
          LayoutBuilder(
            builder: (_, c) {
              final cols = c.maxWidth > 900 ? 3 : 1;
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: c.maxWidth > 900 ? 0.90 : 1.25,
                children: [
                  for (int i = 0; i < plans.length; i++)
                    CardBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plans[i].$1,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Text(plans[i].$2,
                              style: const TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 20),
                          for (final feature in plans[i].$3)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline,
                                      color: AppColors.green, size: 17),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(feature,
                                          style:
                                              const TextStyle(fontSize: 12))),
                                ],
                              ),
                            ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: i == 0
                                ? const OutlineButton(text: 'Current plan')
                                : PrimaryButton(text: 'Choose plan'),
                          ),
                        ],
                      ),
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
// SMALL FORM HELPERS
// ============================================================

class _TextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const _TextField({
    required this.label,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
