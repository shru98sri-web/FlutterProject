import 'package:flutter/material.dart';

// void main() => runApp(const CareerApp());

class AppColors {
  static const navy = Color(0xFF0B1740);
  static const blue = Color(0xFF2039B7);
  static const brightBlue = Color(0xFF3455E6);
  static const purple = Color(0xFF6C4FE8);
  static const bg = Color(0xFFF7F8FC);
  static const text = Color(0xFF17203A);
  static const muted = Color(0xFF6B7280);
  static const border = Color(0xFFE6E8EF);
  static const green = Color(0xFF35A56A);
}

class CareerApp extends StatelessWidget {
  const CareerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Career Guidance',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
      ),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int page = 0;

  final pages = const [
    HomePage(),
    DashboardPage(),
    CareerMappingPage(),
    AptitudePage(),
    ChatPage(),
    AtsCheckerPage(),
    EliteCoderPage(),
    ProgramBuilderPage(),
    ResumeBuilderPage(),
    VisaInterviewPage(),
    ReferralPage(),
  ];

  void go(int index) => setState(() => page = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopNav(onGetStarted: () => go(1)),
          Expanded(
            child: Row(
              children: [
                if (page != 0) SideBar(selected: page, onSelect: go),
                Expanded(
                  child: IndexedStack(index: page, children: pages),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopNav extends StatelessWidget {
  final VoidCallback onGetStarted;
  const TopNav({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 34),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.blue, size: 24),
          const SizedBox(width: 10),
          const Text('AI CAREER GUIDANCE',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(width: 42),
          if (MediaQuery.sizeOf(context).width > 900) ...[
            navText('HOME'),
            navText('CAREER ROADMAP'),
            navText('SKILL ASSESSMENT'),
            navText('PORTFOLIO BUILDER'),
            navText('LEARNING PATH'),
          ],
          const Spacer(),
          OutlinedButton(
            onPressed: onGetStarted,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.navy,
              side: const BorderSide(color: AppColors.navy),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
            ),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget navText(String s) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(s,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black54)),
      );
}

class SideBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const SideBar({super.key, required this.selected, required this.onSelect});

  final items = const [
    (Icons.grid_view_rounded, 'Dashboard', 1),
    (Icons.route_rounded, 'Career Map', 2),
    (Icons.psychology_rounded, 'Aptitude', 3),
    (Icons.chat_bubble_outline_rounded, 'AI Chat', 4),
    (Icons.description_outlined, 'ATS Checker', 5),
    (Icons.code_rounded, 'Elite Coder', 6),
    (Icons.extension_outlined, 'Program Builder', 7),
    (Icons.article_outlined, 'Resume Builder', 8),
    (Icons.flight_takeoff_rounded, 'Visa Interview', 9),
    (Icons.card_giftcard_rounded, 'Referral', 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 16),
          ...items.map((e) {
            final active = selected == e.$3;
            return Tooltip(
              message: e.$2,
              child: InkWell(
                onTap: () => onSelect(e.$3),
                child: Container(
                  width: 72,
                  height: 52,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        active ? const Color(0xFFECEFFF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(e.$1,
                      color: active ? AppColors.blue : Colors.black45,
                      size: 21),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 70),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF7F8FC), Color(0xFFEFF2FF)],
              ),
            ),
            child: LayoutBuilder(builder: (context, c) {
              final compact = c.maxWidth < 850;
              final text = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Chip(
                    label: Text('FUTURE OF CAREER GROWTH',
                        style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(height: 18),
                  const Text('YOUR CAREER\nLAUNCHPAD',
                      style: TextStyle(
                          fontSize: 52,
                          height: .98,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text)),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 520,
                    child: Text(
                      'Master interviews, build standout resumes, and accelerate your career growth with AI-powered guidance.',
                      style: TextStyle(
                          color: AppColors.muted, fontSize: 16, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const DashboardPage())),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                    ),
                    child: const Text('Explore Platform'),
                  ),
                ],
              );
              final visual = Container(
                height: 310,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2439B5), Color(0xFF101A4B)],
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      right: 30,
                      top: 30,
                      child: Icon(Icons.auto_awesome,
                          color: Colors.white54, size: 40),
                    ),
                    Center(
                      child: Container(
                        width: 240,
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.96),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AI Career Coach',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.navy)),
                              SizedBox(height: 18),
                              LinearProgressIndicator(value: .78),
                              SizedBox(height: 13),
                              Text('Career readiness 78%',
                                  style: TextStyle(fontSize: 11)),
                              SizedBox(height: 18),
                              Text('✓ Resume optimized',
                                  style: TextStyle(fontSize: 10)),
                              Text('✓ Interview practice',
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
              return compact
                  ? Column(children: [text, const SizedBox(height: 40), visual])
                  : Row(
                      children: [
                        Expanded(child: text),
                        const SizedBox(width: 55),
                        Expanded(child: visual),
                      ],
                    );
            }),
          ),
          const FeatureGrid(),
          const Footer(),
        ],
      ),
    );
  }
}

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});
  @override
  Widget build(BuildContext context) {
    final data = [
      ('01', 'RESUME BUILDER', 'Create professional resumes with AI guidance.'),
      (
        '02',
        'MOCK INTERVIEWS',
        'Practice interviews with an intelligent coach.'
      ),
      (
        '03',
        'CAREER ROADMAP',
        'Discover skills and roles that fit your goals.'
      ),
      ('04', 'SKILL ASSESSMENT', 'Measure your strengths and identify gaps.'),
      (
        '05',
        'ATS CHECKER',
        'Improve your resume for applicant tracking systems.'
      ),
      ('06', 'AI CHAT', 'Ask questions about careers, learning and jobs.'),
      (
        '07',
        'ELITE CODER',
        'Build coding confidence with practical challenges.'
      ),
      ('08', 'VISA INTERVIEW', 'Practice international interview questions.'),
    ];
    return Padding(
      padding: const EdgeInsets.all(55),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 1.6,
        ),
        itemBuilder: (_, i) => Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.border)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data[i].$1,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black26,
                        fontSize: 20)),
                const Spacer(),
                Text(data[i].$2,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 12)),
                const SizedBox(height: 5),
                Text(data[i].$3,
                    style:
                        const TextStyle(fontSize: 10, color: AppColors.muted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E35B5), Color(0xFF304DDF)],
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Evening,',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 18)),
                      Text('Shruthi',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w900)),
                      SizedBox(height: 8),
                      Text('Accelerate Your Career Journey',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text(
                        'Master essential skills, build your portfolio, and plan your dream job with our comprehensive learning platform.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 42),
                )
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text('Continue Learning',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: const [
              FeatureCard(
                  Icons.psychology,
                  'Aptitude & Reasoning',
                  'Master logical thinking and quantitative skills.',
                  AppColors.purple),
              FeatureCard(
                  Icons.integration_instructions,
                  'ATS Checker',
                  'Optimize your resume for applicant tracking systems.',
                  Color(0xFF2B9D69)),
              FeatureCard(
                  Icons.route,
                  'Career Path',
                  'Discover career directions and required skills.',
                  Color(0xFF8D61D9)),
              FeatureCard(
                  Icons.code,
                  'Elite Coder',
                  'Level up your coding and problem solving.',
                  Color(0xFFE04A39)),
              FeatureCard(Icons.extension, 'Program Builder',
                  'Build structured programming practice.', Color(0xFF8C59E0)),
              FeatureCard(
                  Icons.article,
                  'Resume Builder',
                  'Create a professional resume in minutes.',
                  Color(0xFFC76A32)),
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  const FeatureCard(this.icon, this.title, this.subtitle, this.iconColor,
      {super.key});
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.border)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundColor: iconColor.withOpacity(.12),
                  child: Icon(icon, color: iconColor, size: 20)),
              const Spacer(),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(height: 5),
              Text(subtitle,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.muted, height: 1.3)),
              const SizedBox(height: 8),
              const Text('GET STARTED →',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue)),
            ],
          ),
        ),
      );
}

class PageFrame extends StatelessWidget {
  final Widget child;
  final String? title;
  const PageFrame({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30, 25, 30, 50),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: child,
        ),
      ),
    );
  }
}

class CareerMappingPage extends StatelessWidget {
  const CareerMappingPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(
              number: '01',
              title: 'Career Mapping',
              subtitle: 'Find the right direction for your career journey.'),
          const SizedBox(height: 25),
          const FormBox(
              title: 'What are your interests?',
              child: TextField(
                  decoration: InputDecoration(
                      hintText: 'e.g. technology, finance, design, science',
                      border: OutlineInputBorder()))),
          const SizedBox(height: 16),
          const FormBox(
              title: 'Your current skills',
              child: TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                      hintText: 'Enter your skills',
                      border: OutlineInputBorder()))),
          const SizedBox(height: 20),
          FilledButton.icon(
              onPressed: null,
              icon: Icon(Icons.auto_awesome),
              label: Text('Generate Career Roadmap')),
          const SizedBox(height: 25),
          const RoadmapResult(),
        ]),
      );
}

class RoadmapResult extends StatelessWidget {
  const RoadmapResult({super.key});
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Suggested roadmap',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 20),
            Row(children: [
              roadmapStep('01', 'Foundation'),
              roadmapStep('02', 'Projects'),
              roadmapStep('03', 'Portfolio'),
              roadmapStep('04', 'Interviews'),
            ]),
          ]),
        ),
      );
  Widget roadmapStep(String n, String s) => Expanded(
        child: Column(children: [
          CircleAvatar(
              backgroundColor: AppColors.blue,
              child: Text(n, style: const TextStyle(color: Colors.white))),
          const SizedBox(height: 8),
          Text(s, style: const TextStyle(fontWeight: FontWeight.w700)),
        ]),
      );
}

class AptitudePage extends StatefulWidget {
  const AptitudePage({super.key});
  @override
  State<AptitudePage> createState() => _AptitudePageState();
}

class _AptitudePageState extends State<AptitudePage> {
  int questions = 10;
  String domain = 'Aptitude';
  @override
  Widget build(BuildContext context) => PageFrame(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(
              number: '02',
              title: 'Aptitude & Reasoning',
              subtitle:
                  'Fine-tune your practice session for the best results.'),
          const SizedBox(height: 25),
          Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TEST CONFIGURATION',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 18),
                      const Text('Programming language'),
                      const SizedBox(height: 7),
                      DropdownButtonFormField<String>(
                        value: 'Select a language',
                        items: [
                          'Select a language',
                          'Python',
                          'Java',
                          'C++',
                          'Dart'
                        ]
                            .map((x) =>
                                DropdownMenuItem(value: x, child: Text(x)))
                            .toList(),
                        onChanged: (_) {},
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 18),
                      const Text('Number of Questions'),
                      Wrap(
                        spacing: 10,
                        children: [5, 10, 15, 20, 25]
                            .map((n) => ChoiceChip(
                                  label: Text('$n'),
                                  selected: questions == n,
                                  onSelected: (_) =>
                                      setState(() => questions = n),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 22),
                      const Text('Select Domain'),
                      const SizedBox(height: 10),
                      Wrap(
                          spacing: 12,
                          children: ['Aptitude', 'Reasoning']
                              .map((x) => ChoiceChip(
                                  label: Text(x),
                                  selected: domain == x,
                                  onSelected: (_) =>
                                      setState(() => domain = x)))
                              .toList()),
                      const SizedBox(height: 24),
                      SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: const Text('Session Ready'),
                                      content: Text(
                                          '$questions $domain questions selected.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'))
                                      ],
                                    )),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start Quiz'),
                          )),
                    ]),
              )),
        ]),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  final messages = <String>[];
  @override
  Widget build(BuildContext context) => PageFrame(
        child: SizedBox(
          height: 650,
          child: Card(
              elevation: 0,
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColors.navy, AppColors.blue]),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Row(children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 10),
                    Text('AI Career Coach',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800)),
                  ]),
                ),
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.psychology,
                              size: 55, color: Colors.black12),
                          SizedBox(height: 12),
                          Text('Start a Conversation',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 18)),
                          Text(
                              'Ask me anything about your career path, learning\nroadmap, or skill development.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.muted)),
                        ]))
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: messages.length,
                          itemBuilder: (_, i) => Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFECEFFF),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Text(messages[i]),
                                ),
                              )),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Expanded(
                        child: TextField(
                      controller: controller,
                      onSubmitted: (_) => send(),
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                        border: OutlineInputBorder(),
                      ),
                    )),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: send,
                      icon: const Icon(Icons.send),
                    ),
                  ]),
                ),
              ])),
        ),
      );
  void send() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      messages.add(controller.text.trim());
      controller.clear();
    });
  }
}

class AtsCheckerPage extends StatelessWidget {
  const AtsCheckerPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(
              number: '05',
              title: 'ATS CHECKER',
              subtitle:
                  'Make your resume easier for applicant tracking systems to read.'),
          const SizedBox(height: 22),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(children: [
                        const Icon(Icons.cloud_upload_outlined,
                            size: 42, color: Colors.black38),
                        const SizedBox(height: 10),
                        const Text('UPLOAD RESUME',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        const Text('Drag your resume here or click to upload',
                            style: TextStyle(
                                color: AppColors.muted, fontSize: 11)),
                        const SizedBox(height: 18),
                        OutlinedButton.icon(
                          onPressed: () =>
                              _message(context, 'Choose a PDF or DOCX resume.'),
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Choose File'),
                        ),
                      ]),
                    ))),
            const SizedBox(width: 20),
            Expanded(
                child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('JOB DETAILS',
                                style: TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 15),
                            const TextField(
                                maxLines: 6,
                                decoration: InputDecoration(
                                    hintText:
                                        'Paste the target job description here...',
                                    border: OutlineInputBorder())),
                            const SizedBox(height: 15),
                            SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () => _message(context,
                                      'Upload a resume to start the ATS analysis.'),
                                  child: const Text('Analyze Resume'),
                                )),
                          ]),
                    ))),
          ]),
        ]),
      );
}

class EliteCoderPage extends StatelessWidget {
  const EliteCoderPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
              number: '06',
              title: 'Elite Coder',
              subtitle:
                  'Practice coding problems and improve your problem solving skills.'),
          const SizedBox(height: 22),
          const ProblemCard(
              'Two Sum', 'Find two numbers that add up to a target.', 'Easy'),
          const ProblemCard('Valid Parentheses',
              'Determine whether brackets are valid.', 'Easy'),
          const ProblemCard(
              'Longest Substring',
              'Find the longest substring without repeating characters.',
              'Medium'),
          const ProblemCard('Binary Tree Search',
              'Traverse a binary search tree efficiently.', 'Medium'),
        ],
      ));
}

class ProblemCard extends StatelessWidget {
  final String title, desc, level;
  const ProblemCard(this.title, this.desc, this.level, {super.key});
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.code)),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(desc),
          trailing: Chip(label: Text(level)),
        ),
      );
}

class ProgramBuilderPage extends StatelessWidget {
  const ProgramBuilderPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(
              number: '07',
              title: 'Program Builder',
              subtitle: 'Build a structured programming learning plan.'),
          const SizedBox(height: 22),
          Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  const TextField(
                      decoration: InputDecoration(
                          labelText: 'Programming goal',
                          hintText: 'e.g. Become a Flutter developer',
                          border: OutlineInputBorder())),
                  const SizedBox(height: 15),
                  const TextField(
                      decoration: InputDecoration(
                          labelText: 'Current level',
                          border: OutlineInputBorder())),
                  const SizedBox(height: 15),
                  SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _message(context,
                            'Your learning program will be generated here.'),
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Generate Program'),
                      )),
                ]),
              )),
        ]),
      );
}

class ResumeBuilderPage extends StatefulWidget {
  const ResumeBuilderPage({super.key});
  @override
  State<ResumeBuilderPage> createState() => _ResumeBuilderPageState();
}

class _ResumeBuilderPageState extends State<ResumeBuilderPage> {
  int mode = 0;
  @override
  Widget build(BuildContext context) => PageFrame(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              gradient:
                  LinearGradient(colors: [AppColors.navy, AppColors.blue]),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: const Row(children: [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 10),
              Text('Resume Builder',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900)),
            ]),
          ),
          const SizedBox(height: 22),
          const Center(
              child: Text('How would you like to start?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
          const Center(
              child: Text('Choose the option that works best for you.',
                  style: TextStyle(color: AppColors.muted))),
          const SizedBox(height: 25),
          Row(children: [
            Expanded(
                child: StartCard(
                    Icons.upload_file,
                    'Upload Existing Resume',
                    'Improve an existing resume',
                    () => setState(() => mode = 1))),
            const SizedBox(width: 18),
            Expanded(
                child: StartCard(
                    Icons.description,
                    'Start from Scratch',
                    'Build a new professional resume',
                    () => setState(() => mode = 2))),
          ]),
          if (mode != 0) ...[
            const SizedBox(height: 22),
            ResumeForm(mode: mode),
          ]
        ]),
      );
}

class StartCard extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final VoidCallback onTap;
  const StartCard(this.icon, this.title, this.sub, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(children: [
                Icon(icon, size: 36, color: AppColors.navy),
                const SizedBox(height: 12),
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(sub,
                    style:
                        const TextStyle(color: AppColors.muted, fontSize: 11)),
              ]),
            )),
      );
}

class ResumeForm extends StatelessWidget {
  final int mode;
  const ResumeForm({super.key, required this.mode});
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const TextField(
                decoration: InputDecoration(
                    labelText: 'Full name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(
                decoration: InputDecoration(
                    labelText: 'Professional headline',
                    border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                    labelText: 'Professional summary',
                    border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _message(context, 'Resume draft created.'),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Create Resume'),
                )),
          ]),
        ),
      );
}

class VisaInterviewPage extends StatefulWidget {
  const VisaInterviewPage({super.key});
  @override
  State<VisaInterviewPage> createState() => _VisaInterviewPageState();
}

class _VisaInterviewPageState extends State<VisaInterviewPage> {
  String country = 'United States';
  @override
  Widget build(BuildContext context) => PageFrame(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(
              number: '09',
              title: 'AI VISA INTERVIEW',
              subtitle:
                  'Answer a few questions to prepare for your visa interview.'),
          const SizedBox(height: 25),
          Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('VISA PREPARATION',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 20),
                      const Text('Which country are you planning to visit?',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            'United States',
                            'United Kingdom',
                            'Canada',
                            'Australia',
                            'New Zealand',
                            'Ireland'
                          ]
                              .map((x) => ChoiceChip(
                                  label: Text(x),
                                  selected: country == x,
                                  onSelected: (_) =>
                                      setState(() => country = x)))
                              .toList()),
                      const SizedBox(height: 24),
                      SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _message(context,
                                'Visa interview practice for $country is ready.'),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start Interview'),
                          )),
                    ]),
              )),
        ]),
      );
}

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(
              number: '10',
              title: 'Referral Program',
              subtitle: 'Invite friends and earn rewards.'),
          const SizedBox(height: 25),
          Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(children: [
                  const Icon(Icons.card_giftcard,
                      size: 52, color: AppColors.green),
                  const SizedBox(height: 15),
                  const Text('Have a Referral Code?',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text(
                      'Enter your referral code below to unlock your reward.',
                      style: TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 22),
                  SizedBox(
                      width: 420,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ENTER REFERRAL CODE',
                          suffixIcon: TextButton(
                              onPressed: () =>
                                  _message(context, 'Referral code applied.'),
                              child: const Text('Apply')),
                          border: const OutlineInputBorder(),
                        ),
                      )),
                ]),
              )),
        ]),
      );
}

class SectionHeader extends StatelessWidget {
  final String number, title, subtitle;
  const SectionHeader(
      {super.key,
      required this.number,
      required this.title,
      required this.subtitle});
  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black12)),
          const SizedBox(width: 15),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 23)),
                const SizedBox(height: 5),
                Text(subtitle, style: const TextStyle(color: AppColors.muted)),
              ])),
        ],
      );
}

class FormBox extends StatelessWidget {
  final String title;
  final Widget child;
  const FormBox({super.key, required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            child,
          ]),
        ),
      );
}

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(45),
        color: const Color(0xFFF0F1F5),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('© 2026 AI Career Guidance',
                style: TextStyle(fontSize: 11, color: AppColors.muted)),
            Text('Career • Company • Legal',
                style: TextStyle(fontSize: 11, color: AppColors.muted)),
          ],
        ),
      );
}

void _message(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
