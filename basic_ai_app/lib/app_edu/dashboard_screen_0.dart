import 'package:flutter/material.dart';

// void main() => runApp(const SasthraCloneApp());

class SasthraCloneApp extends StatelessWidget {
  const SasthraCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sasthra Interview UI',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1717A8),
        ),
      ),
      home: const AppShell(),
    );
  }
}

// -----------------------------------------------------------------------------
// APP SHELL + PERSISTENT SIDEBAR
// -----------------------------------------------------------------------------

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selected = 0;

  final List<NavItem> items = const [
    NavItem(Icons.grid_view_rounded, 'Dashboard'),
    NavItem(Icons.emoji_events_outlined, 'Leaderboard'),
    NavItem(Icons.chat_bubble_outline, 'AI Chat'),
    NavItem(Icons.auto_awesome_outlined, 'AI Recommendations'),
    NavItem(Icons.code_outlined, 'Coding'),
    NavItem(Icons.hexagon_outlined, 'Quiz'),
    NavItem(Icons.keyboard_outlined, 'Lesson Browser'),
    NavItem(Icons.psychology_outlined, 'Aptitude & Reasoning'),
    NavItem(Icons.record_voice_over_outlined, 'AI Interview'),
    NavItem(Icons.groups_outlined, 'Group Discussion'),
    NavItem(Icons.fact_check_outlined, 'ATS Checker'),
    NavItem(Icons.description_outlined, 'Resume Builder'),
    NavItem(Icons.mail_outline, 'Cover Letter'),
    NavItem(Icons.work_outline, 'AI Portfolio'),
    NavItem(Icons.work_history_outlined, 'Experience'),
    NavItem(Icons.build_outlined, 'Skills'),
    NavItem(Icons.folder_outlined, 'Projects'),
    NavItem(Icons.category_outlined, 'Job Roles'),
    NavItem(Icons.flight_takeoff_outlined, 'AI Visa Interview'),
    NavItem(Icons.check_circle_outline, 'Interview Precheck'),
    NavItem(Icons.analytics_outlined, 'Mock Test Analytics'),
    NavItem(Icons.card_giftcard_outlined, 'Referral Rewards'),
    NavItem(Icons.bolt_outlined, 'Plans & Billing'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = _pages();

    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            items: items,
            selected: selected,
            onSelected: (i) => setState(() => selected = i),
          ),
          Expanded(
            child: Column(
              children: [
                _TopBar(title: items[selected].label),
                Expanded(
                  child: IndexedStack(
                    index: selected,
                    children: pages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _pages() => const [
        DashboardPage(),
        LeaderboardPage(),
        AiChatPage(),
        RecommendationsPage(),
        CodingPage(),
        QuizPage(),
        LessonBrowserPage(),
        AptitudePage(),
        AiInterviewPage(),
        GroupDiscussionPage(),
        AtsCheckerPage(),
        ResumeBuilderPage(),
        CoverLetterPage(),
        PortfolioPage(),
        ExperiencePage(),
        SkillsPage(),
        ProjectsPage(),
        JobRolesPage(),
        VisaInterviewPage(),
        InterviewPrecheckPage(),
        MockAnalyticsPage(),
        ReferralPage(),
        BillingPage(),
      ];
}

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}

class _Sidebar extends StatelessWidget {
  final List<NavItem> items;
  final int selected;
  final ValueChanged<int> onSelected;

  const _Sidebar({
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF0E0E75),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(.20),
                  blurRadius: 8,
                )
              ],
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final active = selected == i;
                return Tooltip(
                  message: items[i].label,
                  child: InkWell(
                    onTap: () => onSelected(i),
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF5555FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color:
                                      const Color(0xFF5555FF).withOpacity(.35),
                                  blurRadius: 8,
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        items[i].icon,
                        size: 22,
                        color: active ? Colors.white : const Color(0xFF53566D),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Color(0xFF55596D)),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 8, color: Colors.blue),
                SizedBox(width: 6),
                Text('Sasthra / Main'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '₹348 CREDITS',
              style: TextStyle(
                color: Color(0xFF9A6410),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 18),
          const Text(
            'Rewards  +50',
            style: TextStyle(
              color: Color(0xFF3133A8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 18),
          const Icon(Icons.notifications_none),
          const SizedBox(width: 15),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF3133A8),
            child: Text('S', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMMON UI
// -----------------------------------------------------------------------------

class PageFrame extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;

  const PageFrame({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(34, 28, 34, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF171A2E),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 7),
              Text(
                subtitle!,
                style: const TextStyle(
                  color: Color(0xFF777B91),
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
          child,
        ],
      ),
    );
  }
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E9F1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D111827),
            blurRadius: 10,
            offset: Offset(0, 3),
          )
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
    return ElevatedButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon ?? Icons.arrow_forward, size: 17),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1111A0),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatBox({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF1FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF3030C0)),
          ),
          const SizedBox(width: 13),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF777B91),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class FormFieldBox extends StatelessWidget {
  final String label;
  final String hint;
  const FormFieldBox({
    super.key,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 7),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFFBFBFD),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFE1E3EA)),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 1 DASHBOARD
// -----------------------------------------------------------------------------

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Elite Coder',
      subtitle: 'Your personalized interview preparation dashboard',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF17175E), Color(0xFF29298B)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ready to elevate your algorithmic skills?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Practice coding, interviews and group discussions with AI.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                PrimaryButton(
                  text: 'Resume AI Practice',
                  icon: Icons.play_arrow,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Row(
            children: [
              Expanded(
                child: StatBox(
                  title: 'Interview Score',
                  value: '82%',
                  icon: Icons.person_search_outlined,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: StatBox(
                  title: 'Tests Completed',
                  value: '24',
                  icon: Icons.task_alt,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: StatBox(
                  title: 'Credits',
                  value: '348',
                  icon: Icons.toll_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2 LEADERBOARD
// -----------------------------------------------------------------------------

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      ('Amrish Al', 'amrishamirthalingam@gmail.com', '201.00', '1st'),
      ('Rajesh kumar', 'mrk060304@gmail.com', '184.00', '2nd'),
      ('Student User', 'student@example.com', '178.00', '3rd'),
    ];

    return PageFrame(
      title: 'Leaderboard',
      subtitle:
          'See how you rank against other users based on interview and group discussion scores',
      child: Column(
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'Overall Score', label: Text('Overall Score')),
              ButtonSegment(
                  value: 'Interview Score', label: Text('Interview Score')),
              ButtonSegment(value: 'GD Score', label: Text('GD Score')),
            ],
            selected: const {'Overall Score'},
            onSelectionChanged: (_) {},
          ),
          const SizedBox(height: 28),
          ...users.map(
            (u) => Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0FA),
                border: Border.all(
                  color: const Color(0xFF1717A8),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE0E4FF),
                    child: Text(u.$4),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          u.$1,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          u.$2,
                          style: const TextStyle(color: Color(0xFF777B91)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    u.$3,
                    style: const TextStyle(
                      color: Color(0xFF1111A0),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
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

// -----------------------------------------------------------------------------
// 3 AI CHAT
// -----------------------------------------------------------------------------

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final controller = TextEditingController();
  final messages = <String>[];

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'AI Chat',
      subtitle: 'Ask anything about interviews, coding, careers and learning',
      child: SizedBox(
        height: 620,
        child: Panel(
          child: Column(
            children: [
              const Icon(Icons.smart_toy, size: 44, color: Color(0xFF2525A8)),
              const SizedBox(height: 10),
              const Text(
                'Start a Conversation',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text('Ask anything to begin your personalized AI session.'),
              const SizedBox(height: 25),
              Expanded(
                child: ListView(
                  children: messages
                      .map(
                        (m) => Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1717A8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              m,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    onPressed: () {
                      if (controller.text.trim().isEmpty) return;
                      setState(() {
                        messages.add(controller.text.trim());
                        controller.clear();
                      });
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4 RECOMMENDATIONS
// -----------------------------------------------------------------------------

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'AI Recommendations',
      subtitle: 'Personalized recommendations based on your activity and goals',
      child: Column(
        children: [
          Panel(
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF5D54E8)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Actionable Recommendations',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Panel(
            child: Column(
              children: const [
                Icon(Icons.star_border, size: 50, color: Color(0xFF9A8AFF)),
                SizedBox(height: 10),
                Text(
                  'No recommendations yet',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                SizedBox(height: 6),
                Text(
                  'Complete more activities to receive personalized recommendations.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 5 CODING
// -----------------------------------------------------------------------------

class CodingPage extends StatelessWidget {
  const CodingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Elite Coder',
      subtitle: 'Improve your programming and problem-solving skills',
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF15155B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Ready to elevate your algorithmic skills?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                  child:
                      StatBox(title: 'Solved', value: '32', icon: Icons.check)),
              SizedBox(width: 14),
              Expanded(
                  child: StatBox(
                      title: 'Accuracy',
                      value: '82%',
                      icon: Icons.track_changes)),
              SizedBox(width: 14),
              Expanded(
                  child: StatBox(
                      title: 'Streak',
                      value: '7 days',
                      icon: Icons.local_fire_department)),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 6 QUIZ
// -----------------------------------------------------------------------------

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Configure Your Quiz',
      subtitle: 'Select your language and quiz preferences',
      child: Center(
        child: SizedBox(
          width: 700,
          child: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Programming Language',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: 'Python',
                  items: ['Python', 'Java', 'C++', 'JavaScript', 'Dart']
                      .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                      .toList(),
                  onChanged: (_) {},
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Number of Questions',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(
                        child: ChoiceChip(label: Text('10'), selected: true)),
                    SizedBox(width: 8),
                    Expanded(
                        child: ChoiceChip(label: Text('20'), selected: false)),
                    SizedBox(width: 8),
                    Expanded(
                        child: ChoiceChip(label: Text('30'), selected: false)),
                  ],
                ),
                const SizedBox(height: 25),
                PrimaryButton(text: 'Start Quiz', icon: Icons.play_arrow),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 7 LESSON BROWSER
// -----------------------------------------------------------------------------

class LessonBrowserPage extends StatelessWidget {
  const LessonBrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      'Where, When and If',
      'Adding a comma',
      'Grammar basics',
      'Vocabulary',
      'Interview communication',
      'Advanced English',
    ];

    return PageFrame(
      title: 'Lesson Browser',
      subtitle: 'Browse lessons and learning material',
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search lessons...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lessons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 2.8,
            ),
            itemBuilder: (_, i) => Panel(
              child: Row(
                children: [
                  const Icon(Icons.menu_book, color: Color(0xFF2424A6)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(lessons[i])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 8 APTITUDE
// -----------------------------------------------------------------------------

class AptitudePage extends StatelessWidget {
  const AptitudePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Aptitude & Reasoning',
      subtitle: 'Configure your practice session',
      child: Center(
        child: SizedBox(
          width: 760,
          child: Panel(
            child: Column(
              children: [
                const Icon(Icons.psychology,
                    size: 48, color: Color(0xFF2424A6)),
                const SizedBox(height: 10),
                const Text(
                  'Configure Your Test',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                        child: StatBox(
                            title: 'Aptitude',
                            value: '20 Q',
                            icon: Icons.calculate)),
                    SizedBox(width: 12),
                    Expanded(
                        child: StatBox(
                            title: 'Reasoning',
                            value: '20 Q',
                            icon: Icons.psychology)),
                  ],
                ),
                const SizedBox(height: 22),
                PrimaryButton(text: 'Start Test', icon: Icons.play_arrow),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 9 AI INTERVIEW
// -----------------------------------------------------------------------------

class AiInterviewPage extends StatelessWidget {
  const AiInterviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: "Let's Get You Interview Ready",
      subtitle: 'Practice realistic AI-powered interviews',
      child: Center(
        child: SizedBox(
          width: 700,
          child: Panel(
            child: Column(
              children: [
                const Icon(Icons.record_voice_over,
                    size: 60, color: Color(0xFF2424A6)),
                const SizedBox(height: 15),
                const Text(
                  'Practice your interview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                const Text('Upload your resume or choose a role to begin.'),
                const SizedBox(height: 25),
                PrimaryButton(
                    text: 'Upload Your Resume', icon: Icons.upload_file),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 10 GROUP DISCUSSION
// -----------------------------------------------------------------------------

class GroupDiscussionPage extends StatelessWidget {
  const GroupDiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Group Discussion',
      subtitle: 'Join an AI-powered group discussion session',
      child: Center(
        child: SizedBox(
          width: 720,
          child: Panel(
            child: Column(
              children: [
                const Icon(Icons.groups, size: 60, color: Color(0xFF1717A8)),
                const SizedBox(height: 15),
                const Text(
                  'Choose Your Discussion Topic',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter or select a discussion topic',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                PrimaryButton(text: 'Start Discussion', icon: Icons.play_arrow),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 11 ATS CHECKER
// -----------------------------------------------------------------------------

class AtsCheckerPage extends StatelessWidget {
  const AtsCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'ATS CHECKER',
      subtitle: 'Check how well your resume matches applicant tracking systems',
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Panel(
                  child: Column(
                    children: [
                      Text('UPLOAD RESUME',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      SizedBox(height: 18),
                      Icon(Icons.upload_file,
                          size: 48, color: Color(0xFF2929A8)),
                      SizedBox(height: 10),
                      Text('Drop your resume here or click to upload'),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: Panel(
                  child: Column(
                    children: [
                      Text('JOB DETAILS',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      SizedBox(height: 18),
                      TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Paste the job description...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(text: 'Check ATS Score', icon: Icons.analytics),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 12 RESUME BUILDER
// -----------------------------------------------------------------------------

class ResumeBuilderPage extends StatelessWidget {
  const ResumeBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Resume Builder',
      subtitle: 'Create a professional resume with AI assistance',
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            color: const Color(0xFF1717A8),
            child: const Text(
              'Resume Builder',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                  child: Panel(
                      child: _ChoiceTile(
                          icon: Icons.upload_file,
                          title: 'Upload Existing Resume'))),
              SizedBox(width: 16),
              Expanded(
                  child: Panel(
                      child: _ChoiceTile(
                          icon: Icons.description,
                          title: 'Start From Scratch'))),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _ChoiceTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 44, color: const Color(0xFF1717A8)),
        const SizedBox(height: 10),
        Text(title, textAlign: TextAlign.center),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 13 COVER LETTER
// -----------------------------------------------------------------------------

class CoverLetterPage extends StatelessWidget {
  const CoverLetterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'COVER LETTER GENERATOR',
      subtitle: 'Create a tailored cover letter for your target role',
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                  child: Panel(
                      child: FormFieldBox(
                          label: 'Upload Resume',
                          hint: 'Drop your resume here'))),
              SizedBox(width: 16),
              Expanded(
                  child: Panel(
                      child: FormFieldBox(
                          label: 'Job Details', hint: 'Paste job details'))),
            ],
          ),
          const SizedBox(height: 20),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Style & Tone'),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: 'Professional',
                  items: ['Professional', 'Friendly', 'Confident', 'Concise']
                      .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                      .toList(),
                  onChanged: (_) {},
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
              text: 'Generate Cover Letter', icon: Icons.auto_awesome),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 14 PORTFOLIO
// -----------------------------------------------------------------------------

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'AI PORTFOLIO Maker',
      subtitle: 'Create a professional portfolio with AI',
      child: Column(
        children: [
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Details',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Expanded(
                        child: FormFieldBox(label: 'Name', hint: 'Your name')),
                    SizedBox(width: 14),
                    Expanded(
                        child: FormFieldBox(label: 'Role', hint: 'Your role')),
                  ],
                ),
                const SizedBox(height: 14),
                const FormFieldBox(
                    label: 'About', hint: 'Tell us about yourself'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(text: 'Upload Resume', icon: Icons.upload_file),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 15 EXPERIENCE
// -----------------------------------------------------------------------------

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Experience',
      subtitle: 'Add your professional experience',
      child: Column(
        children: [
          Panel(
            child: Column(
              children: const [
                FormFieldBox(label: 'Role', hint: 'Job title'),
                SizedBox(height: 14),
                FormFieldBox(label: 'Company', hint: 'Company name'),
                SizedBox(height: 14),
                FormFieldBox(label: 'Dates', hint: 'Start - End'),
                SizedBox(height: 14),
                FormFieldBox(label: 'Description', hint: 'Describe your work'),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: PrimaryButton(text: 'Add Experience', icon: Icons.add),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 16 SKILLS
// -----------------------------------------------------------------------------

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      'AI & ML',
      'Android and Mobile App Development',
      'Blockchain Technology',
      'Business Management',
      'Cybersecurity',
      'Data Science',
      'Cloud Computing',
      'Embedded Systems',
      'Software Development',
      'Testing & Quality',
    ];

    return PageFrame(
      title: 'Skills',
      subtitle: 'Select skills relevant to your profile',
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: skills
            .map(
              (s) => SizedBox(
                width: 250,
                child: Panel(
                  child: Row(
                    children: [
                      const Icon(Icons.workspace_premium,
                          color: Color(0xFF1717A8)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(s)),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 17 PROJECTS
// -----------------------------------------------------------------------------

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Projects',
      subtitle: 'Add projects to your portfolio',
      child: Panel(
        child: Column(
          children: const [
            FormFieldBox(label: 'Project Name', hint: 'Project title'),
            SizedBox(height: 14),
            FormFieldBox(label: 'Description', hint: 'Project description'),
            SizedBox(height: 14),
            FormFieldBox(label: 'Technologies', hint: 'Flutter, Python, AI...'),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 18 JOB ROLES
// -----------------------------------------------------------------------------

class JobRolesPage extends StatelessWidget {
  const JobRolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = [
      'Software Development',
      'Sales & Marketing',
      'System Design',
      'Testing & Quality',
      'Virtual Reality (VR) and AR',
    ];

    return PageFrame(
      title: 'Job Roles',
      subtitle: 'Explore roles and configure interview practice',
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: roles
            .map(
              (r) => SizedBox(
                width: 270,
                child: Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 15),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('OPEN MODULE'),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 19 VISA INTERVIEW
// -----------------------------------------------------------------------------

class VisaInterviewPage extends StatelessWidget {
  const VisaInterviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'AI VISA INTERVIEW',
      subtitle: 'Practice visa interview questions with AI',
      child: Center(
        child: SizedBox(
          width: 720,
          child: Panel(
            child: Column(
              children: [
                const Icon(Icons.flight_takeoff,
                    size: 56, color: Color(0xFF1717A8)),
                const SizedBox(height: 14),
                const Text(
                  'Which country are you planning to visit?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    'United States',
                    'Canada',
                    'Australia',
                    'New Zealand',
                    'United Kingdom'
                  ]
                      .map((x) => OutlinedButton(
                            onPressed: () {},
                            child: Text(x),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 20 INTERVIEW PRECHECK
// -----------------------------------------------------------------------------

class InterviewPrecheckPage extends StatelessWidget {
  const InterviewPrecheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Interview Precheck',
      subtitle: 'Get your resume and profile ready before the interview',
      child: Column(
        children: [
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('How It Works',
                    style:
                        TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                const SizedBox(height: 15),
                ...[
                  'Review your profile and resume',
                  'Identify missing interview information',
                  'Prepare personalized interview questions',
                  'Receive actionable feedback',
                ].map(
                  (x) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 10),
                        Text(x),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(text: 'Start Precheck', icon: Icons.play_arrow),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 21 ANALYTICS
// -----------------------------------------------------------------------------

class MockAnalyticsPage extends StatelessWidget {
  const MockAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Mock Test Analytics',
      subtitle: 'Analyze your mock interview and test performance',
      child: Column(
        children: [
          Panel(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Overall Score',
                          style: TextStyle(color: Color(0xFF777B91))),
                      SizedBox(height: 5),
                      Text('0.0 / 10',
                          style: TextStyle(
                              fontSize: 34, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: 0.0,
                    strokeWidth: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                  child: StatBox(
                      title: 'Questions',
                      value: '0',
                      icon: Icons.help_outline)),
              SizedBox(width: 14),
              Expanded(
                  child:
                      StatBox(title: 'Correct', value: '0', icon: Icons.check)),
              SizedBox(width: 14),
              Expanded(
                  child: StatBox(
                      title: 'Completion', value: '0%', icon: Icons.timelapse)),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 22 REFERRAL
// -----------------------------------------------------------------------------

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Referral Rewards',
      subtitle: 'Invite friends and earn credits',
      child: Center(
        child: SizedBox(
          width: 760,
          child: Panel(
            child: Column(
              children: [
                const Icon(Icons.card_giftcard,
                    size: 55, color: Color(0xFF1717A8)),
                const SizedBox(height: 12),
                const Text(
                  'Generate Referral Code',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Share your referral code with friends and earn rewards.',
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                    text: 'Generate Referral Code',
                    icon: Icons.generating_tokens),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 23 BILLING
// -----------------------------------------------------------------------------

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      ('Starter Plan', '₹49', const Color(0xFF1717A8)),
      ('Essential Plan', '₹149', const Color(0xFF7A22D8)),
      ('Pro Plan', '₹299', const Color(0xFFEF5A00)),
      ('Power Plan', '₹599', const Color(0xFF0B8A62)),
    ];

    return PageFrame(
      title: 'Plans & Billing',
      subtitle: 'Choose a plan and manage your credits',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: plans
            .map(
              (p) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.$1,
                          style: TextStyle(
                            color: p.$3,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.$2,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ...[
                          'AI interview access',
                          'Practice sessions',
                          'Resume tools',
                          'Credit rewards',
                        ].map(
                          (x) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, size: 17, color: p.$3),
                                const SizedBox(width: 7),
                                Expanded(child: Text(x)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Choose Plan'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
