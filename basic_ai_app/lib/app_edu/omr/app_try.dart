import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const AICoachingPlatform());
}

// ============================================================
// GLOBAL COLORS
// ============================================================

const Color navy = Color(0xFF08111F);
const Color dark = Color(0xFF0B1626);
const Color blue = Color(0xFF2563EB);
const Color cyan = Color(0xFF22D3EE);
const Color purple = Color(0xFF7C3AED);
const Color primary = Color(0xFF1717A8);
const Color lightBg = Color(0xFFF7F9FC);
const Color textDark = Color(0xFF111827);
const Color muted = Color(0xFF64748B);

// ============================================================
// APP
// ============================================================

class AICoachingPlatform extends StatelessWidget {
  const AICoachingPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Coaching Platform',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: lightBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainApp(),
    );
  }
}

// ============================================================
// DATA MODELS
// ============================================================

class Topic {
  final String name;
  final String description;
  final IconData icon;
  final int progress;
  final Color color;

  const Topic({
    required this.name,
    required this.description,
    required this.icon,
    required this.progress,
    required this.color,
  });
}

class Question {
  final String topic;
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;
  final int difficulty;

  const Question({
    required this.topic,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.difficulty,
  });
}

class ChatMessage {
  final String text;
  final bool user;

  ChatMessage({
    required this.text,
    required this.user,
  });
}

// ============================================================
// SAMPLE TOPICS
// ============================================================

const List<Topic> topics = [
  Topic(
    name: 'Python',
    description: 'Programming from basics to advanced',
    icon: Icons.code,
    progress: 82,
    color: Colors.blue,
  ),
  Topic(
    name: 'Dart',
    description: 'Dart programming and OOP',
    icon: Icons.data_object,
    progress: 68,
    color: Colors.cyan,
  ),
  Topic(
    name: 'Flutter',
    description: 'Build modern mobile applications',
    icon: Icons.phone_android,
    progress: 74,
    color: Colors.indigo,
  ),
  Topic(
    name: 'AI / ML',
    description: 'Artificial intelligence and machine learning',
    icon: Icons.psychology,
    progress: 61,
    color: Colors.deepPurple,
  ),
  Topic(
    name: 'SQL',
    description: 'Databases and queries',
    icon: Icons.storage,
    progress: 55,
    color: Colors.orange,
  ),
  Topic(
    name: 'Data Science',
    description: 'Data analysis and visualization',
    icon: Icons.bar_chart,
    progress: 48,
    color: Colors.green,
  ),
  Topic(
    name: 'Cybersecurity',
    description: 'Security concepts and practices',
    icon: Icons.security,
    progress: 39,
    color: Colors.red,
  ),
  Topic(
    name: 'Mathematics',
    description: 'Mathematics and aptitude',
    icon: Icons.calculate,
    progress: 72,
    color: Colors.teal,
  ),
  Topic(
    name: 'Physics',
    description: 'Physics from fundamentals to advanced',
    icon: Icons.science,
    progress: 76,
    color: Colors.deepOrange,
  ),
  Topic(
    name: 'Photonics',
    description: 'Optics, lasers and photonics',
    icon: Icons.lightbulb,
    progress: 58,
    color: Colors.amber,
  ),
  Topic(
    name: 'English',
    description: 'Grammar, vocabulary and communication',
    icon: Icons.language,
    progress: 81,
    color: Colors.pink,
  ),
  Topic(
    name: 'IELTS',
    description: 'Speaking, listening, reading and writing',
    icon: Icons.record_voice_over,
    progress: 64,
    color: Colors.purple,
  ),
  Topic(
    name: 'Interview',
    description: 'Technical and HR interview preparation',
    icon: Icons.business_center,
    progress: 51,
    color: Colors.blueGrey,
  ),
  Topic(
    name: 'Career',
    description: 'Career planning and job preparation',
    icon: Icons.work,
    progress: 44,
    color: Colors.brown,
  ),
];

// ============================================================
// QUESTION BANK
// ============================================================

const List<Question> questions = [
  Question(
    topic: 'Python',
    question: 'Which keyword is used to define a function in Python?',
    options: ['func', 'def', 'function', 'method'],
    answer: 1,
    explanation: 'Python uses the def keyword to define a function.',
    difficulty: 1,
  ),
  Question(
    topic: 'Python',
    question: 'Which of these is mutable?',
    options: ['Tuple', 'String', 'List', 'Integer'],
    answer: 2,
    explanation: 'Python lists are mutable.',
    difficulty: 2,
  ),
  Question(
    topic: 'Dart',
    question: 'Which function is the entry point of a Dart application?',
    options: ['start()', 'main()', 'run()', 'init()'],
    answer: 1,
    explanation: 'Dart applications normally begin execution from main().',
    difficulty: 1,
  ),
  Question(
    topic: 'Flutter',
    question: 'Which method rebuilds a StatefulWidget after state changes?',
    options: ['refresh()', 'reload()', 'setState()', 'rebuild()'],
    answer: 2,
    explanation: 'setState() tells Flutter that state has changed.',
    difficulty: 2,
  ),
  Question(
    topic: 'AI / ML',
    question: 'Which learning method uses labeled data?',
    options: [
      'Supervised learning',
      'Unsupervised learning',
      'Random learning',
      'Manual learning'
    ],
    answer: 0,
    explanation: 'Supervised learning uses labeled training examples.',
    difficulty: 1,
  ),
  Question(
    topic: 'SQL',
    question: 'Which command retrieves data from a database?',
    options: ['INSERT', 'SELECT', 'DELETE', 'UPDATE'],
    answer: 1,
    explanation: 'SELECT retrieves data.',
    difficulty: 1,
  ),
  Question(
    topic: 'Mathematics',
    question: 'What is 15% of 200?',
    options: ['15', '20', '30', '40'],
    answer: 2,
    explanation: '15% of 200 = 0.15 × 200 = 30.',
    difficulty: 2,
  ),
  Question(
    topic: 'Physics',
    question: 'What is the SI unit of force?',
    options: ['Joule', 'Newton', 'Watt', 'Pascal'],
    answer: 1,
    explanation: 'Force is measured in Newtons.',
    difficulty: 1,
  ),
  Question(
    topic: 'Photonics',
    question: 'LASER stands for:',
    options: [
      'Light Amplification by Stimulated Emission of Radiation',
      'Light Absorption by Standard Emission of Radiation',
      'Light Application by Stimulated Electronic Radiation',
      'Laser Amplification by Simple Energy Radiation'
    ],
    answer: 0,
    explanation:
        'LASER means Light Amplification by Stimulated Emission of Radiation.',
    difficulty: 2,
  ),
  Question(
    topic: 'English',
    question: 'Choose the grammatically correct sentence.',
    options: [
      'She go to school.',
      'She going school.',
      'She goes to school.',
      'She gone school.'
    ],
    answer: 2,
    explanation: 'For third-person singular in the simple present, use "goes".',
    difficulty: 1,
  ),
];

// ============================================================
// MAIN APP
// ============================================================

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int page = 0;
  bool darkMode = false;

  final List<String> pageNames = [
    'Dashboard',
    'Learn',
    'AI Coach',
    'Assessment',
    'Progress',
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkMode
          ? ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: blue,
                brightness: Brightness.dark,
              ),
            )
          : ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: lightBg,
              colorScheme: ColorScheme.fromSeed(
                seedColor: blue,
              ),
            ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: navy,
          title: Text(
            pageNames[page],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  darkMode = !darkMode;
                });
              },
              icon: Icon(
                darkMode ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const ProfileDialog(),
                );
              },
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: cyan,
                child: Icon(
                  Icons.person,
                  color: navy,
                  size: 19,
                ),
              ),
            ),
          ],
        ),
        drawer: AppDrawer(
          currentPage: page,
          onSelected: (value) {
            Navigator.pop(context);
            setState(() {
              page = value;
            });
          },
        ),
        body: IndexedStack(
          index: page,
          children: [
            const DashboardPage(),
            const LearnPage(),
            const AICoachPage(),
            const AssessmentPage(),
            const ProgressPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: page,
          onDestinationSelected: (index) {
            setState(() {
              page = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school),
              label: 'Learn',
            ),
            NavigationDestination(
              icon: Icon(Icons.smart_toy_outlined),
              selectedIcon: Icon(Icons.smart_toy),
              label: 'AI Coach',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment),
              label: 'Exam',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: 'Progress',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DRAWER
// ============================================================

class AppDrawer extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onSelected;

  const AppDrawer({
    super.key,
    required this.currentPage,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    navy,
                    purple,
                    blue,
                  ],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: cyan,
                    child: Icon(
                      Icons.smart_toy,
                      color: navy,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'AI Coaching Platform',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Personalized learning',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _drawerItem(
              context,
              Icons.dashboard,
              'Dashboard',
              0,
            ),
            _drawerItem(
              context,
              Icons.school,
              'Learning',
              1,
            ),
            _drawerItem(
              context,
              Icons.smart_toy,
              'AI Coach',
              2,
            ),
            _drawerItem(
              context,
              Icons.assignment,
              'Assessments',
              3,
            ),
            _drawerItem(
              context,
              Icons.analytics,
              'Progress',
              4,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Career Coach'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CareerPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.record_voice_over),
              title: const Text('Interview Practice'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InterviewPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    return ListTile(
      selected: currentPage == index,
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        onSelected(index);
      },
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _hero(),
          const SizedBox(height: 22),
          _stats(),
          const SizedBox(height: 25),
          const Text(
            'Continue Learning',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 14),
          _continueCard(
            context,
            'Flutter',
            'State Management',
            0.74,
            Icons.phone_android,
          ),
          _continueCard(
            context,
            'Python',
            'Machine Learning Basics',
            0.62,
            Icons.code,
          ),
          _continueCard(
            context,
            'AI / ML',
            'Model Evaluation',
            0.45,
            Icons.psychology,
          ),
          const SizedBox(height: 25),
          const Text(
            'Recommended for You',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 14),
          _recommendation(
            context,
            'Adaptive Python Assessment',
            'Test your current Python level',
            Icons.assignment,
          ),
          _recommendation(
            context,
            'AI Interview Practice',
            'Practice technical interview questions',
            Icons.record_voice_over,
          ),
          _recommendation(
            context,
            'Career Roadmap',
            'Create a personalized learning path',
            Icons.route,
          ),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            navy,
            purple,
            blue,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome,
            color: cyan,
            size: 35,
          ),
          SizedBox(height: 15),
          Text(
            'Welcome back 👋',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Your AI Learning Journey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Learn smarter with personalized coaching, adaptive assessments and AI-powered guidance.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats() {
    return Row(
      children: [
        Expanded(
          child: _stat(
            Icons.local_fire_department,
            '7',
            'Day Streak',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _stat(
            Icons.star,
            '1,280',
            'XP',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _stat(
            Icons.check_circle,
            '78%',
            'Accuracy',
          ),
        ),
      ],
    );
  }

  Widget _stat(
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: blue,
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _continueCard(
    BuildContext context,
    String title,
    String lesson,
    double progress,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: blue.withOpacity(0.1),
              child: Icon(
                icon,
                color: blue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    lesson,
                    style: const TextStyle(
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendation(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: purple.withOpacity(0.1),
          child: Icon(
            icon,
            color: purple,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GenericLearningPage(
                title: title,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// LEARNING
// ============================================================

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: topics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final topic = topics[index];

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TopicDetailPage(
                  topic: topic,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: topic.color.withOpacity(0.12),
                  child: Icon(
                    topic.icon,
                    color: topic.color,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  topic.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    topic.description,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 12,
                    ),
                  ),
                ),
                LinearProgressIndicator(
                  value: topic.progress / 100,
                ),
                const SizedBox(height: 5),
                Text(
                  '${topic.progress}% complete',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// TOPIC DETAIL
// ============================================================

class TopicDetailPage extends StatelessWidget {
  final Topic topic;

  const TopicDetailPage({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = [
      'Introduction',
      'Core Concepts',
      'Practical Examples',
      'Exercises',
      'Advanced Concepts',
      'Project',
      'Assessment',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: topic.color,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  topic.icon,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  topic.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  topic.description,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Learning Path',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...lessons.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final lesson = entry.value;

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      '${index + 1}',
                    ),
                  ),
                  title: Text(
                    lesson,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    index < 2 ? 'Completed' : 'Recommended next step',
                  ),
                  trailing: Icon(
                    index < 2 ? Icons.check_circle : Icons.arrow_forward_ios,
                    color: index < 2 ? Colors.green : muted,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonPage(
                          title: '${topic.name} - $lesson',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LESSON
// ============================================================

class LessonPage extends StatelessWidget {
  final String title;

  const LessonPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.school,
                    color: cyan,
                    size: 35,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'AI Learning Lesson',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Concept',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This lesson introduces the core concept step by step. '
              'The AI Coach can explain the concept at beginner, '
              'intermediate or advanced level.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: muted,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Example',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                '// Practice example\n'
                'print("Hello AI Coach");',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.check,
                ),
                label: const Text(
                  'Mark Lesson Complete',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// AI COACH
// ============================================================

class AICoachPage extends StatefulWidget {
  const AICoachPage({super.key});

  @override
  State<AICoachPage> createState() => _AICoachPageState();
}

class _AICoachPageState extends State<AICoachPage> {
  final TextEditingController controller = TextEditingController();

  final List<ChatMessage> messages = [
    ChatMessage(
      user: false,
      text: 'Hello! I am your AI Coach. What would you like to learn today?',
    ),
  ];

  bool listening = false;

  void sendMessage() {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          user: true,
          text: text,
        ),
      );

      messages.add(
        ChatMessage(
          user: false,
          text: generateAIResponse(text),
        ),
      );

      controller.clear();
    });
  }

  String generateAIResponse(String text) {
    final query = text.toLowerCase();

    if (query.contains('flutter')) {
      return 'For Flutter, I recommend this order: '
          'Dart → widgets → layouts → StatefulWidget → '
          'navigation → state management → APIs → Firebase → deployment.';
    }

    if (query.contains('python')) {
      return 'For Python, learn variables, conditions, loops, '
          'functions, collections, OOP, modules and then NumPy, '
          'Pandas and machine learning.';
    }

    if (query.contains('ai') || query.contains('machine learning')) {
      return 'For AI/ML, begin with Python and mathematics, '
          'then learn data preprocessing, supervised learning, '
          'unsupervised learning, evaluation and deep learning.';
    }

    if (query.contains('interview')) {
      return 'For interviews, practice technical questions, '
          'project explanation, problem solving, communication '
          'and behavioral questions.';
    }

    if (query.contains('career')) {
      return 'I can help you create a career roadmap based on '
          'your current skills, target role, projects and learning time.';
    }

    return 'Good question. Let us break this into smaller concepts. '
        'First understand the fundamentals, then practice with examples, '
        'then take an assessment and review your mistakes.';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];

              return Align(
                alignment:
                    message.user ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  padding: const EdgeInsets.all(15),
                  constraints: const BoxConstraints(
                    maxWidth: 340,
                  ),
                  decoration: BoxDecoration(
                    color: message.user ? blue : Colors.white,
                    borderRadius: BorderRadius.circular(
                      18,
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.user ? Colors.white : textDark,
                      height: 1.4,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _chatInput(),
      ],
    );
  }

  Widget _chatInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  listening = !listening;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      listening ? 'Voice mode enabled' : 'Voice mode stopped',
                    ),
                  ),
                );
              },
              icon: Icon(
                listening ? Icons.mic : Icons.mic_none,
                color: listening ? blue : muted,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Ask your AI Coach...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      18,
                    ),
                  ),
                ),
                onSubmitted: (_) => sendMessage(),
              ),
            ),
            const SizedBox(width: 7),
            CircleAvatar(
              backgroundColor: blue,
              child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ASSESSMENT
// ============================================================

class AssessmentPage extends StatelessWidget {
  const AssessmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topicNames = questions.map((q) => q.topic).toSet().toList();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: topicNames.length,
      itemBuilder: (context, index) {
        final topic = topicNames[index];

        final count = questions
            .where(
              (q) => q.topic == topic,
            )
            .length;

        return Card(
          margin: const EdgeInsets.only(
            bottom: 12,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: const CircleAvatar(
              backgroundColor: Color(0x142563EB),
              child: Icon(
                Icons.assignment,
                color: blue,
              ),
            ),
            title: Text(
              topic,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '$count questions • Adaptive assessment',
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExamPage(
                    topic: topic,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ============================================================
// EXAM PAGE
// ============================================================

class ExamPage extends StatefulWidget {
  final String topic;

  const ExamPage({
    super.key,
    required this.topic,
  });

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  late List<Question> examQuestions;

  int index = 0;
  int score = 0;
  int selected = -1;

  int difficulty = 1;

  @override
  void initState() {
    super.initState();

    examQuestions = questions
        .where(
          (q) => q.topic == widget.topic,
        )
        .toList();

    if (examQuestions.isEmpty) {
      examQuestions = questions.take(5).toList();
    }
  }

  void submit() {
    if (selected == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select an answer first.'),
        ),
      );
      return;
    }

    final question = examQuestions[index];

    if (selected == question.answer) {
      score++;
      difficulty++;
    } else {
      difficulty = max(1, difficulty - 1);
    }

    if (index < examQuestions.length - 1) {
      setState(() {
        index++;
        selected = -1;
      });
    } else {
      showResult();
    }
  }

  void showResult() {
    final percentage = (score / examQuestions.length) * 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text(
          'Assessment Complete',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 60,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              '$score / ${examQuestions.length}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              percentage >= 80
                  ? 'Excellent performance!'
                  : percentage >= 60
                      ? 'Good progress!'
                      : 'More practice recommended.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
              Navigator.pop(
                context,
              );
            },
            child: const Text('Done'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
              setState(() {
                index = 0;
                score = 0;
                selected = -1;
                difficulty = 1;
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = examQuestions[index];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.topic} Assessment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (index + 1) / examQuestions.length,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    'Level $difficulty',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, option) {
                  final selectedOption = selected == option;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = option;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      padding: const EdgeInsets.all(
                        17,
                      ),
                      decoration: BoxDecoration(
                        color: selectedOption
                            ? blue.withOpacity(
                                0.08,
                              )
                            : Colors.white,
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        border: Border.all(
                          color: selectedOption ? blue : Colors.grey.shade300,
                          width: selectedOption ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                selectedOption ? blue : Colors.grey.shade100,
                            child: Text(
                              String.fromCharCode(
                                65 + option,
                              ),
                              style: TextStyle(
                                color: selectedOption ? Colors.white : textDark,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: Text(
                              question.options[option],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: submit,
                child: const Text(
                  'Submit Answer',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PROGRESS
// ============================================================

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = {
      'Python': 0.82,
      'Flutter': 0.74,
      'Dart': 0.68,
      'AI / ML': 0.61,
      'SQL': 0.55,
      'Mathematics': 0.72,
      'Physics': 0.76,
      'Photonics': 0.58,
      'English': 0.81,
      'Interview': 0.51,
    };

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                navy,
                blue,
              ],
            ),
            borderRadius: BorderRadius.circular(
              22,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Skill Score',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '68%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your AI learning profile is improving.',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        const Text(
          'Skill Analytics',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ...skills.entries.map(
          (entry) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 17,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(entry.value * 100).round()}%',
                        style: const TextStyle(
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    child: LinearProgressIndicator(
                      value: entry.value,
                      minHeight: 9,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(
          height: 15,
        ),
        _weakArea(
          'SQL',
          'Practice JOIN, GROUP BY and window functions.',
        ),
        _weakArea(
          'Interview',
          'Practice technical and HR questions.',
        ),
        _weakArea(
          'Photonics',
          'Review laser physics and optical systems.',
        ),
      ],
    );
  }

  Widget _weakArea(
    String title,
    String description,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: const Icon(
          Icons.warning_amber,
          color: Colors.orange,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
      ),
    );
  }
}

// ============================================================
// CAREER
// ============================================================

class CareerPage extends StatelessWidget {
  const CareerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Skill assessment',
      'Identify strengths and weaknesses',
      'Choose target career',
      'Build personalized roadmap',
      'Complete projects',
      'Practice interviews',
      'Improve resume',
      'Apply for jobs',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Coach'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  purple,
                  blue,
                ],
              ),
              borderRadius: BorderRadius.circular(
                22,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.work,
                  color: Colors.white,
                  size: 38,
                ),
                SizedBox(height: 12),
                Text(
                  'AI Career Roadmap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Build a personalized path from your current skills to your target role.',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ...steps.asMap().entries.map(
            (entry) {
              return Card(
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      '${entry.key + 1}',
                    ),
                  ),
                  title: Text(
                    entry.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INTERVIEW
// ============================================================

class InterviewPage extends StatefulWidget {
  const InterviewPage({super.key});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  final questions = [
    'Tell me about yourself.',
    'Explain one project you have worked on.',
    'Why should we hire you?',
    'What are your strengths?',
    'What is one technical challenge you solved?',
    'Where do you see yourself in five years?',
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Interview Practice',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(
                  22,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.record_voice_over,
                    color: cyan,
                    size: 45,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'AI Interviewer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'Question ${index + 1} of ${questions.length}',
              style: const TextStyle(
                color: muted,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              questions[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Type your answer...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Voice recording UI ready.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.mic,
                    ),
                    label: const Text(
                      'Speak',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (index < questions.length - 1) {
                          index++;
                        }
                      });
                    },
                    child: const Text(
                      'Next',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SETTINGS
// ============================================================

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool adaptiveLearning = true;
  bool voiceMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Learning Settings',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SwitchListTile(
            value: adaptiveLearning,
            onChanged: (value) {
              setState(() {
                adaptiveLearning = value;
              });
            },
            title: const Text(
              'Adaptive Learning',
            ),
            subtitle: const Text(
              'Automatically adjust question difficulty',
            ),
          ),
          SwitchListTile(
            value: notifications,
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
            title: const Text(
              'Notifications',
            ),
            subtitle: const Text(
              'Learning reminders and daily goals',
            ),
          ),
          SwitchListTile(
            value: voiceMode,
            onChanged: (value) {
              setState(() {
                voiceMode = value;
              });
            },
            title: const Text(
              'Voice Coach',
            ),
            subtitle: const Text(
              'Enable voice-based coaching',
            ),
          ),
          const Divider(
            height: 35,
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
            ),
            title: const Text(
              'Profile',
            ),
            subtitle: const Text(
              'Student profile and preferences',
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.lock,
            ),
            title: const Text(
              'Privacy',
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
            ),
            title: const Text(
              'About',
            ),
            subtitle: const Text(
              'AI Coaching Platform v1.0',
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE DIALOG
// ============================================================

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Student Profile'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: cyan,
            child: Icon(
              Icons.person,
              color: navy,
              size: 40,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'AI Learner',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Personalized learning profile',
            style: TextStyle(
              color: muted,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
            context,
          ),
          child: const Text(
            'Close',
          ),
        ),
      ],
    );
  }
}

// ============================================================
// GENERIC LEARNING PAGE
// ============================================================

class GenericLearningPage extends StatelessWidget {
  final String title;

  const GenericLearningPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 70,
                color: purple,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'This learning module is connected to the AI coaching architecture and can later use your OpenAI/FastAPI backend.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
