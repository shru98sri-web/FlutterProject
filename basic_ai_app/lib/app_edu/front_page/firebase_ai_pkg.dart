import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// void main() async {
//   // Ensure framework engine bindings are active before executing async setups
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // 1. Core Firebase system connection layer initialization
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => StudentProfileProvider(),
//       child: const EduTechAiApp(),
//     ),
//   );
// }

/// State provider for tracking student data, track level, and lesson metrics
class StudentProfileProvider extends ChangeNotifier {
  final String _studentName = "Alex";
  String _academicLevel = "High School (10th Grade)";
  int _completedLessons = 14;

  String get studentName => _studentName;
  String get academicLevel => _academicLevel;
  int get completedLessons => _completedLessons;

  void updateLevel(String newLevel) {
    _academicLevel = newLevel;
    notifyListeners();
  }
}

class EduTechAiApp extends StatelessWidget {
  const EduTechAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduTech Smart Tutor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Deep Academic Blue
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const TutorDashboardScreen(),
    );
  }
}

class TutorDashboardScreen extends StatefulWidget {
  const TutorDashboardScreen({super.key});

  @override
  State<TutorDashboardScreen> createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  late final LlmProvider _aiProvider;

  @override
  void initState() {
    super.initState();

    // 2. Safely initialize native provider without raw API key variables
    _aiProvider = FirebaseProvider(
      model: FirebaseAI.googleAI().generativeModel(
        model: 'gemini-1.5-flash',
        // Optional custom parameters can be wired here securely
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentData = Provider.of<StudentProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EduTutor Studio',
          style: GoogleFonts.philosopher(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${studentData.completedLessons} Badges',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Side - Menu & System Navigation
          Expanded(
            flex: 3,
            child: Container(
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back, ${studentData.studentName}!",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Current Track:",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  DropdownButton<String>(
                    value: studentData.academicLevel,
                    isExpanded: true,
                    items: <String>[
                      'Elementary School (5th Grade)',
                      'High School (10th Grade)',
                      'Undergraduate (STEM Track)'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        studentData.updateLevel(newValue);
                      }
                    },
                  ),
                  const Divider(height: 32),
                  Text(
                    "Quick Shortcuts",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildPromptChip("Explain Quantum Mechanics simply"),
                  _buildPromptChip("Help me verify this calculus formula"),
                ],
              ),
            ),
          ),

          const VerticalDivider(width: 1, thickness: 1),

          // Right Side - Interactive Chat Workspace View
          Expanded(
            flex: 7,
            child: LlmChatView(
              provider: _aiProvider,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ActionChip(
        avatar: const Icon(Icons.psychology, size: 16),
        label: Text(text, style: const TextStyle(fontSize: 12)),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Type: "$text" into the conversation window below!')),
          );
        },
      ),
    );
  }
}
