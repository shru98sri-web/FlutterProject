import 'package:flutter/material.dart';

// void main() {
//   runApp(const TuitionApp());
// }

// ============================================================
// APP CONSTANTS
// ============================================================

class AppColors {
  static const navy = Color(0xFF08111F);
  static const dark = Color(0xFF0B1626);
  static const blue = Color(0xFF2563EB);
  static const lightBlue = Color(0xFF3B82F6);
  static const background = Color(0xFFF5F7FB);
  static const white = Colors.white;
  static const text = Color(0xFF172033);
  static const secondaryText = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const green = Color(0xFF16A34A);
  static const orange = Color(0xFFF59E0B);
  static const red = Color(0xFFDC2626);
  static const purple = Color(0xFF7C3AED);
}

class AppConstants {
  static const appName = 'EduSphere';
  static const appVersion = '1.0.0';
}

// ============================================================
// ENUMS
// ============================================================

enum UserRole {
  student,
  teacher,
  admin,
}

// ============================================================
// USER MODEL
// ============================================================

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String avatar;
  final String phone;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar = '',
    this.phone = '',
  });
}

// ============================================================
// COURSE MODEL
// ============================================================

class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String category;
  final int lessons;
  final double progress;
  final String image;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.category,
    required this.lessons,
    required this.progress,
    this.image = '',
  });
}

// ============================================================
// ASSIGNMENT MODEL
// ============================================================

class Assignment {
  final String id;
  final String title;
  final String subject;
  final String dueDate;
  final int questions;
  final bool submitted;

  const Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.questions,
    required this.submitted,
  });
}

// ============================================================
// NOTIFICATION MODEL
// ============================================================

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool read;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.read,
  });
}

// ============================================================
// MOCK DATABASE
// ============================================================

class MockDatabase {
  static const courses = <Course>[
    Course(
      id: 'C001',
      title: 'Physics Masterclass',
      description:
          'Complete physics course covering mechanics, optics, electricity and modern physics.',
      instructor: 'Dr. Arun Kumar',
      category: 'Physics',
      lessons: 42,
      progress: .72,
    ),
    Course(
      id: 'C002',
      title: 'Advanced Mathematics',
      description:
          'Algebra, calculus, geometry, probability and advanced problem solving.',
      instructor: 'Prof. Meena Rao',
      category: 'Mathematics',
      lessons: 56,
      progress: .58,
    ),
    Course(
      id: 'C003',
      title: 'Computer Science',
      description:
          'Programming, algorithms, data structures and computer fundamentals.',
      instructor: 'Rahul Sharma',
      category: 'Computer Science',
      lessons: 38,
      progress: .41,
    ),
    Course(
      id: 'C004',
      title: 'English Communication',
      description:
          'Grammar, vocabulary, writing, speaking and professional communication.',
      instructor: 'Priya Nair',
      category: 'English',
      lessons: 30,
      progress: .84,
    ),
  ];

  static const assignments = <Assignment>[
    Assignment(
      id: 'A001',
      title: 'Newton Laws Assignment',
      subject: 'Physics',
      dueDate: '24 Sep 2026',
      questions: 20,
      submitted: false,
    ),
    Assignment(
      id: 'A002',
      title: 'Integration Problems',
      subject: 'Mathematics',
      dueDate: '26 Sep 2026',
      questions: 15,
      submitted: false,
    ),
    Assignment(
      id: 'A003',
      title: 'Dart Programming',
      subject: 'Computer Science',
      dueDate: '28 Sep 2026',
      questions: 25,
      submitted: true,
    ),
  ];

  static const notifications = <AppNotification>[
    AppNotification(
      id: 'N001',
      title: 'New Assignment',
      message: 'Physics assignment has been added.',
      time: '10 min ago',
      read: false,
    ),
    AppNotification(
      id: 'N002',
      title: 'Live Class',
      message: 'Mathematics class starts at 6:00 PM.',
      time: '1 hour ago',
      read: false,
    ),
    AppNotification(
      id: 'N003',
      title: 'Result Published',
      message: 'Your Physics quiz result is available.',
      time: 'Yesterday',
      read: true,
    ),
  ];
}

// ============================================================
// APP STATE
// ============================================================

class AppState extends ChangeNotifier {
  AppUser? currentUser;

  bool isLoading = false;

  Future<bool> login(
    String email,
    String password,
    UserRole role,
  ) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    currentUser = AppUser(
      id: 'USR001',
      name: role == UserRole.student
          ? 'Shruthi Student'
          : role == UserRole.teacher
              ? 'Dr. Teacher'
              : 'Administrator',
      email: email,
      role: role,
      phone: '+91 9876543210',
    );

    isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}

// ============================================================
// ROOT APP
// ============================================================

class TuitionApp extends StatefulWidget {
  const TuitionApp({super.key});

  @override
  State<TuitionApp> createState() => _TuitionAppState();
}

class _TuitionAppState extends State<TuitionApp> {
  final AppState appState = AppState();

  @override
  void dispose() {
    appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          home: appState.currentUser == null
              ? LoginScreen(appState: appState)
              : MainShell(appState: appState),
        );
      },
    );
  }
}

// ============================================================
// THEME
// ============================================================

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blue,
        brightness: Brightness.light,
      ),
      fontFamily: 'Arial',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.blue,
            width: 2,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LOGIN SCREEN
// ============================================================

class LoginScreen extends StatefulWidget {
  final AppState appState;

  const LoginScreen({
    super.key,
    required this.appState,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserRole selectedRole = UserRole.student;

  bool obscurePassword = true;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      errorMessage = null;
    });

    final success = await widget.appState.login(
      emailController.text,
      passwordController.text,
      selectedRole,
    );

    if (!success && mounted) {
      setState(() {
        errorMessage = 'Please enter your email and password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.navy,
              AppColors.dark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width > 900 ? 1050 : 480,
              ),
              child: width > 900
                  ? Row(
                      children: [
                        Expanded(
                          child: _LoginBranding(),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: _LoginCard(),
                        ),
                      ],
                    )
                  : _LoginCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _LoginCard() {
    return Card(
      elevation: 20,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.school_rounded,
              size: 48,
              color: AppColors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome Back',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to continue learning',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Login as',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<UserRole>(
              initialValue: selectedRole,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
              ),
              items: UserRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(_roleName(role)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedRole = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                style: const TextStyle(
                  color: AppColors.red,
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: widget.appState.isLoading ? null : _login,
                child: widget.appState.isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Forgot Password?'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Demo: enter any email and password',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _roleName(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.admin:
        return 'Administrator';
    }
  }
}

// ============================================================
// LOGIN BRANDING
// ============================================================

class _LoginBranding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 70,
          ),
          SizedBox(height: 28),
          Text(
            'EduSphere',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Complete Digital Learning Platform',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Learn. Practice. Improve. Succeed.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MAIN SHELL
// ============================================================

class MainShell extends StatefulWidget {
  final AppState appState;

  const MainShell({
    super.key,
    required this.appState,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = widget.appState.currentUser!;

    final pages = _pagesForRole(user.role);
    final navigation = _navigationForRole(user.role);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width >= 1100,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            backgroundColor: AppColors.navy,
            selectedIconTheme: const IconThemeData(
              color: Colors.white,
            ),
            unselectedIconTheme: const IconThemeData(
              color: Colors.white54,
            ),
            selectedLabelTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelTextStyle: const TextStyle(
              color: Colors.white60,
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 34,
                  ),
                  if (MediaQuery.sizeOf(context).width >= 1100)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'EduSphere',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            destinations: navigation,
          ),
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  user: user,
                  onLogout: widget.appState.logout,
                ),
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
    );
  }

  List<NavigationRailDestination> _navigationForRole(
    UserRole role,
  ) {
    switch (role) {
      case UserRole.student:
        return const [
          NavigationRailDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: Text('Dashboard'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: Text('Courses'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: Text('Assignments'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: Text('Exams'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: Text('Progress'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: Text('Notifications'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: Text('Profile'),
          ),
        ];

      case UserRole.teacher:
        return const [
          NavigationRailDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: Text('Dashboard'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: Text('Courses'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: Text('Students'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: Text('Assignments'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: Text('Exams'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check),
            label: Text('Attendance'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: Text('Analytics'),
          ),
        ];

      case UserRole.admin:
        return const [
          NavigationRailDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: Text('Dashboard'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: Text('Students'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: Text('Teachers'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: Text('Courses'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.payment_outlined),
            selectedIcon: Icon(Icons.payment),
            label: Text('Payments'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: Text('Reports'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
        ];
    }
  }

  List<Widget> _pagesForRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        return [
          StudentDashboard(appState: widget.appState),
          const CoursesScreen(),
          const AssignmentsScreen(),
          const ExamsScreen(),
          const ProgressScreen(),
          const NotificationsScreen(),
          ProfileScreen(appState: widget.appState),
        ];

      case UserRole.teacher:
        return [
          const TeacherDashboard(),
          const CoursesScreen(),
          const StudentsScreen(),
          const AssignmentsScreen(),
          const ExamsScreen(),
          const AttendanceScreen(),
          const AnalyticsScreen(),
        ];

      case UserRole.admin:
        return [
          const AdminDashboard(),
          const StudentsScreen(),
          const TeachersScreen(),
          const CoursesScreen(),
          const PaymentsScreen(),
          const AnalyticsScreen(),
          const SettingsScreen(),
        ];
    }
  }
}

// ============================================================
// TOP BAR
// ============================================================

class _TopBar extends StatelessWidget {
  final AppUser user;
  final VoidCallback onLogout;

  const _TopBar({
    required this.user,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _greeting(user),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.blue.withOpacity(.1),
            child: const Icon(
              Icons.person,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(width: 10),
          if (MediaQuery.sizeOf(context).width > 700)
            Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                onLogout();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _greeting(AppUser user) {
    switch (user.role) {
      case UserRole.student:
        return 'Student Dashboard';
      case UserRole.teacher:
        return 'Teacher Dashboard';
      case UserRole.admin:
        return 'Administration';
    }
  }
}

// ============================================================
// STUDENT DASHBOARD
// ============================================================

class StudentDashboard extends StatelessWidget {
  final AppState appState;

  const StudentDashboard({
    super.key,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WelcomeBanner(
            name: appState.currentUser?.name ?? 'Student',
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: 'Overview',
            subtitle: 'Your learning activity',
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: MediaQuery.sizeOf(context).width > 1000 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: const [
              StatCard(
                title: 'Courses',
                value: '8',
                icon: Icons.menu_book,
                iconColor: AppColors.blue,
              ),
              StatCard(
                title: 'Completed',
                value: '24',
                icon: Icons.check_circle,
                iconColor: AppColors.green,
              ),
              StatCard(
                title: 'Assignments',
                value: '12',
                icon: Icons.assignment,
                iconColor: AppColors.orange,
              ),
              StatCard(
                title: 'Average Score',
                value: '87%',
                icon: Icons.emoji_events,
                iconColor: AppColors.purple,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const _SectionTitle(
            title: 'Continue Learning',
            subtitle: 'Pick up where you left off',
          ),
          const SizedBox(height: 16),
          ...MockDatabase.courses.take(3).map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CourseProgressCard(course: course),
                ),
              ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: 'Upcoming Assignments',
            subtitle: 'Stay on top of your work',
          ),
          const SizedBox(height: 16),
          const AssignmentList(),
        ],
      ),
    );
  }
}

// ============================================================
// WELCOME BANNER
// ============================================================

class _WelcomeBanner extends StatelessWidget {
  final String name;

  const _WelcomeBanner({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            AppColors.blue,
            AppColors.lightBlue,
          ],
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good afternoon 👋',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ready to learn something new?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Keep your learning streak going today.',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          if (MediaQuery.sizeOf(context).width > 600)
            const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 90,
            ),
        ],
      ),
    );
  }
}

// ============================================================
// TEACHER DASHBOARD
// ============================================================

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'Teacher Dashboard',
            subtitle: 'Manage your teaching activities',
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: MediaQuery.sizeOf(context).width > 1000 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: const [
              StatCard(
                title: 'Courses',
                value: '12',
                icon: Icons.library_books,
                iconColor: AppColors.blue,
              ),
              StatCard(
                title: 'Students',
                value: '428',
                icon: Icons.people,
                iconColor: AppColors.green,
              ),
              StatCard(
                title: 'Assignments',
                value: '36',
                icon: Icons.assignment,
                iconColor: AppColors.orange,
              ),
              StatCard(
                title: 'Average Rating',
                value: '4.8',
                icon: Icons.star,
                iconColor: AppColors.purple,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const ActivityCard(
            icon: Icons.person_add,
            title: 'New student enrolled',
            subtitle: '12 students joined Physics Masterclass',
            time: '20 min ago',
          ),
          const ActivityCard(
            icon: Icons.assignment_turned_in,
            title: 'Assignments submitted',
            subtitle: '18 new submissions require grading',
            time: '1 hour ago',
          ),
          const ActivityCard(
            icon: Icons.video_call,
            title: 'Live class scheduled',
            subtitle: 'Advanced Physics at 6:00 PM',
            time: '2 hours ago',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ADMIN DASHBOARD
// ============================================================

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'Administration Dashboard',
            subtitle: 'Platform overview',
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: MediaQuery.sizeOf(context).width > 1000 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: const [
              StatCard(
                title: 'Students',
                value: '2,840',
                icon: Icons.people,
                iconColor: AppColors.blue,
              ),
              StatCard(
                title: 'Teachers',
                value: '124',
                icon: Icons.school,
                iconColor: AppColors.green,
              ),
              StatCard(
                title: 'Courses',
                value: '186',
                icon: Icons.menu_book,
                iconColor: AppColors.orange,
              ),
              StatCard(
                title: 'Revenue',
                value: '₹8.4L',
                icon: Icons.currency_rupee,
                iconColor: AppColors.purple,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Platform Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const ActivityCard(
            icon: Icons.person_add,
            title: 'Students registered',
            subtitle: '42 new students today',
            time: 'Today',
          ),
          const ActivityCard(
            icon: Icons.payment,
            title: 'Payments received',
            subtitle: '₹1,24,500 received today',
            time: 'Today',
          ),
          const ActivityCard(
            icon: Icons.library_add,
            title: 'Courses published',
            subtitle: '6 new courses were published',
            time: 'Today',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COURSES
// ============================================================

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'Courses',
            subtitle: 'Explore your learning programs',
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: true,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Physics'),
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Mathematics'),
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Computer Science'),
                onSelected: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MockDatabase.courses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width > 1100
                  ? 3
                  : MediaQuery.sizeOf(context).width > 700
                      ? 2
                      : 1,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 1.35,
            ),
            itemBuilder: (context, index) {
              return CourseCard(
                course: MockDatabase.courses[index],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COURSE CARD
// ============================================================

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: AppColors.border,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CourseDetailsScreen(
                course: course,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                course.category,
                style: const TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                course.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                '${course.lessons} lessons • ${course.instructor}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: course.progress,
                minHeight: 6,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 6),
              Text(
                '${(course.progress * 100).round()}% completed',
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// COURSE DETAILS
// ============================================================

class CourseDetailsScreen extends StatelessWidget {
  final Course course;

  const CourseDetailsScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.navy,
                    AppColors.blue,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.category,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    course.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Course Content',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              8,
              (index) => Card(
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.blue.withOpacity(.1),
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    'Lesson ${index + 1}: '
                    '${_lessonName(index)}',
                  ),
                  subtitle: Text(
                    '${index + 3} videos • 25 minutes',
                  ),
                  trailing: const Icon(
                    Icons.play_circle_outline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _lessonName(int index) {
    const names = [
      'Introduction',
      'Fundamentals',
      'Core Concepts',
      'Problem Solving',
      'Applications',
      'Advanced Concepts',
      'Practice',
      'Final Revision',
    ];

    return names[index];
  }
}

// ============================================================
// ASSIGNMENTS
// ============================================================

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'Assignments',
            subtitle: 'Complete your pending work',
          ),
          const SizedBox(height: 24),
          ...MockDatabase.assignments.map(
            (assignment) => AssignmentTile(
              assignment: assignment,
            ),
          ),
        ],
      ),
    );
  }
}

class AssignmentList extends StatelessWidget {
  const AssignmentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: MockDatabase.assignments.map(
        (assignment) {
          return AssignmentTile(
            assignment: assignment,
          );
        },
      ).toList(),
    );
  }
}

class AssignmentTile extends StatelessWidget {
  final Assignment assignment;

  const AssignmentTile({
    super.key,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.orange.withOpacity(.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.assignment_outlined,
            color: AppColors.orange,
          ),
        ),
        title: Text(
          assignment.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${assignment.subject} • '
          '${assignment.questions} questions • '
          'Due ${assignment.dueDate}',
        ),
        trailing: assignment.submitted
            ? const Chip(
                label: Text('Submitted'),
                avatar: Icon(
                  Icons.check,
                  size: 16,
                ),
              )
            : FilledButton(
                onPressed: () {},
                child: const Text('Start'),
              ),
      ),
    );
  }
}

// ============================================================
// EXAMS
// ============================================================

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'Examinations',
            subtitle: 'Tests and assessments',
          ),
          const SizedBox(height: 24),
          const ExamCard(
            title: 'Physics Unit Test',
            subject: 'Physics',
            questions: 30,
            duration: '45 minutes',
            status: 'Upcoming',
          ),
          const ExamCard(
            title: 'Mathematics Assessment',
            subject: 'Mathematics',
            questions: 40,
            duration: '60 minutes',
            status: 'Available',
          ),
          const ExamCard(
            title: 'Programming Fundamentals',
            subject: 'Computer Science',
            questions: 25,
            duration: '40 minutes',
            status: 'Completed',
          ),
        ],
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  final String title;
  final String subject;
  final int questions;
  final String duration;
  final String status;

  const ExamCard({
    super.key,
    required this.title,
    required this.subject,
    required this.questions,
    required this.duration,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.quiz,
                color: AppColors.purple,
                size: 28,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$subject • $questions questions • $duration',
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(status),
            ),
            const SizedBox(width: 10),
            if (status != 'Completed')
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ExamScreen(),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EXAM ENGINE
// ============================================================

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int questionIndex = 0;
  int? selectedAnswer;

  final questions = const [
    {
      'question': 'Which law describes inertia?',
      'answers': [
        'Newton’s First Law',
        'Newton’s Second Law',
        'Newton’s Third Law',
        'Law of Gravitation',
      ],
      'correct': 0,
    },
    {
      'question': 'What is the SI unit of force?',
      'answers': [
        'Joule',
        'Newton',
        'Watt',
        'Pascal',
      ],
      'correct': 1,
    },
    {
      'question': 'Which quantity is a vector?',
      'answers': [
        'Mass',
        'Temperature',
        'Velocity',
        'Time',
      ],
      'correct': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final question = questions[questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics Examination'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Center(
              child: Text(
                '${questionIndex + 1}/${questions.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 850,
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: (questionIndex + 1) / questions.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 36),
                Text(
                  'Question ${questionIndex + 1}',
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  question['question'] as String,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),
                ...(question['answers'] as List<String>).asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RadioListTile<int>(
                          value: entry.key,
                          groupValue: selectedAnswer,
                          onChanged: (value) {
                            setState(() {
                              selectedAnswer = value;
                            });
                          },
                          title: Text(entry.value),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                        ),
                      ),
                    ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: questionIndex == 0
                          ? null
                          : () {
                              setState(() {
                                questionIndex--;
                                selectedAnswer = null;
                              });
                            },
                      child: const Text('Previous'),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (questionIndex == questions.length - 1) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Exam Submitted'),
                              content: const Text(
                                'Your examination has been submitted successfully.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Done'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          setState(() {
                            questionIndex++;
                            selectedAnswer = null;
                          });
                        }
                      },
                      child: Text(
                        questionIndex == questions.length - 1
                            ? 'Submit'
                            : 'Next',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PROGRESS
// ============================================================

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'My Progress',
            subtitle: 'Track your academic performance',
          ),
          const SizedBox(height: 24),
          const ProgressMetric(
            title: 'Overall Course Completion',
            value: .72,
            percentage: '72%',
          ),
          const ProgressMetric(
            title: 'Assignments Completed',
            value: .84,
            percentage: '84%',
          ),
          const ProgressMetric(
            title: 'Examination Performance',
            value: .87,
            percentage: '87%',
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subject Performance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SubjectScore(
                    subject: 'Physics',
                    score: 91,
                  ),
                  _SubjectScore(
                    subject: 'Mathematics',
                    score: 86,
                  ),
                  _SubjectScore(
                    subject: 'Computer Science',
                    score: 89,
                  ),
                  _SubjectScore(
                    subject: 'English',
                    score: 82,
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

class ProgressMetric extends StatelessWidget {
  final String title;
  final double value;
  final String percentage;

  const ProgressMetric({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  percentage,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: value,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectScore extends StatelessWidget {
  final String subject;
  final int score;

  const _SubjectScore({
    required this.subject,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(subject),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            '$score%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// NOTIFICATIONS
// ============================================================

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'Notifications',
            subtitle: 'Latest updates',
          ),
          const SizedBox(height: 24),
          ...MockDatabase.notifications.map(
            (notification) => Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: AppColors.blue.withOpacity(.1),
                  child: const Icon(
                    Icons.notifications,
                    color: AppColors.blue,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight:
                        notification.read ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(notification.message),
                trailing: Text(
                  notification.time,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({
    super.key,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    child: Icon(
                      Icons.person,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _ProfileRow(
                    label: 'User ID',
                    value: user.id,
                  ),
                  _ProfileRow(
                    label: 'Email',
                    value: user.email,
                  ),
                  _ProfileRow(
                    label: 'Phone',
                    value: user.phone,
                  ),
                  _ProfileRow(
                    label: 'Role',
                    value: user.role.name.toUpperCase(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GENERIC SCREENS
// ============================================================

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericManagementScreen(
      title: 'Students',
      subtitle: 'Manage students',
      icon: Icons.people,
    );
  }
}

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericManagementScreen(
      title: 'Teachers',
      subtitle: 'Manage teachers',
      icon: Icons.school,
    );
  }
}

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericManagementScreen(
      title: 'Attendance',
      subtitle: 'Track class attendance',
      icon: Icons.fact_check,
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericManagementScreen(
      title: 'Analytics',
      subtitle: 'Performance and platform analytics',
      icon: Icons.analytics,
    );
  }
}

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericManagementScreen(
      title: 'Payments',
      subtitle: 'Manage payments and subscriptions',
      icon: Icons.payment,
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericManagementScreen(
      title: 'Settings',
      subtitle: 'Application settings',
      icon: Icons.settings,
    );
  }
}

class GenericManagementScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const GenericManagementScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: title,
            subtitle: subtitle,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 64,
                      color: AppColors.blue,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$title Management',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This production module will be expanded in the next application modules.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// REUSABLE COMPONENTS
// ============================================================

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
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

class CourseProgressCard extends StatelessWidget {
  final Course course;

  const CourseProgressCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.play_circle_fill,
                color: AppColors.blue,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: course.progress,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${(course.progress * 100).round()}%',
              style: const TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: AppColors.blue.withOpacity(.1),
          child: Icon(
            icon,
            color: AppColors.blue,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ============================================================
// PART 2 — COMPLETE STUDY MODULE
// ============================================================
// ============================================================
//
// This module contains:
//
// 1. Study enums
// 2. Study data models
// 3. Study database
// 4. Study state manager
// 5. Study home
// 6. Subject browser
// 7. Course browser
// 8. Course details
// 9. Chapter list
// 10. Lesson list
// 11. Lesson viewer
// 12. Notes
// 13. Bookmarks
// 14. Study history
// 15. Study progress
// 16. Search
// 17. Responsive layouts
//
// ============================================================

// ============================================================
// 1. STUDY ENUMS
// ============================================================

enum LessonType {
  video,
  article,
  quiz,
  assignment,
  liveClass,
}

// ============================================================
// 2. STUDY DATA MODELS
// ============================================================

class StudySubject {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int courseCount;

  const StudySubject({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.courseCount,
  });
}

class StudyCourse {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final String instructor;
  final int totalLessons;
  final int completedLessons;
  final double rating;
  final int students;
  final String level;

  const StudyCourse({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.instructor,
    required this.totalLessons,
    required this.completedLessons,
    required this.rating,
    required this.students,
    required this.level,
  });

  double get progress {
    if (totalLessons == 0) {
      return 0;
    }

    return completedLessons / totalLessons;
  }
}

class StudyChapter {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int chapterNumber;

  const StudyChapter({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.chapterNumber,
  });
}

class StudyLesson {
  final String id;
  final String chapterId;
  final String title;
  final String description;
  final LessonType type;
  final int durationMinutes;
  final int lessonNumber;
  final bool isFree;
  final String content;

  const StudyLesson({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.type,
    required this.durationMinutes,
    required this.lessonNumber,
    required this.isFree,
    required this.content,
  });
}

class StudyNote {
  final String id;
  final String lessonId;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StudyNote({
    required this.id,
    required this.lessonId,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}

class StudyBookmark {
  final String id;
  final String lessonId;
  final String userId;
  final DateTime createdAt;

  const StudyBookmark({
    required this.id,
    required this.lessonId,
    required this.userId,
    required this.createdAt,
  });
}

class StudyHistory {
  final String id;
  final String lessonId;
  final String userId;
  final DateTime openedAt;
  final int watchedMinutes;

  const StudyHistory({
    required this.id,
    required this.lessonId,
    required this.userId,
    required this.openedAt,
    required this.watchedMinutes,
  });
}

// ============================================================
// 3. STUDY DATABASE
// ============================================================

class StudyDatabase {
  static const List<StudySubject> subjects = [
    StudySubject(
      id: 'SUB001',
      name: 'Physics',
      description: 'Mechanics, optics, electricity, waves and modern physics.',
      icon: Icons.science_rounded,
      courseCount: 8,
    ),
    StudySubject(
      id: 'SUB002',
      name: 'Mathematics',
      description: 'Algebra, calculus, geometry, probability and statistics.',
      icon: Icons.calculate_rounded,
      courseCount: 12,
    ),
    StudySubject(
      id: 'SUB003',
      name: 'Chemistry',
      description:
          'Organic, inorganic, physical chemistry and laboratory concepts.',
      icon: Icons.biotech_rounded,
      courseCount: 7,
    ),
    StudySubject(
      id: 'SUB004',
      name: 'Computer Science',
      description:
          'Programming, algorithms, data structures and computer systems.',
      icon: Icons.computer_rounded,
      courseCount: 10,
    ),
    StudySubject(
      id: 'SUB005',
      name: 'English',
      description:
          'Grammar, vocabulary, communication, writing and comprehension.',
      icon: Icons.menu_book_rounded,
      courseCount: 6,
    ),
  ];

  static const List<StudyCourse> courses = [
    StudyCourse(
      id: 'COURSE001',
      subjectId: 'SUB001',
      title: 'Physics Masterclass',
      description:
          'Complete physics course covering mechanics, optics, electricity, waves and modern physics.',
      instructor: 'Dr. Arun Kumar',
      totalLessons: 42,
      completedLessons: 30,
      rating: 4.8,
      students: 12450,
      level: 'Advanced',
    ),
    StudyCourse(
      id: 'COURSE002',
      subjectId: 'SUB001',
      title: 'Modern Physics',
      description:
          'Learn quantum mechanics, relativity, atomic physics and nuclear physics.',
      instructor: 'Dr. Kavya Rao',
      totalLessons: 24,
      completedLessons: 10,
      rating: 4.7,
      students: 8200,
      level: 'Intermediate',
    ),
    StudyCourse(
      id: 'COURSE003',
      subjectId: 'SUB002',
      title: 'Advanced Mathematics',
      description:
          'Algebra, calculus, coordinate geometry and advanced problem solving.',
      instructor: 'Prof. Meena Rao',
      totalLessons: 56,
      completedLessons: 32,
      rating: 4.9,
      students: 15600,
      level: 'Advanced',
    ),
    StudyCourse(
      id: 'COURSE004',
      subjectId: 'SUB002',
      title: 'Calculus Complete Course',
      description:
          'Limits, differentiation, integration and differential equations.',
      instructor: 'Prof. Rajesh Kumar',
      totalLessons: 35,
      completedLessons: 18,
      rating: 4.8,
      students: 9300,
      level: 'Intermediate',
    ),
    StudyCourse(
      id: 'COURSE005',
      subjectId: 'SUB003',
      title: 'Chemistry Fundamentals',
      description:
          'Build strong fundamentals in physical, organic and inorganic chemistry.',
      instructor: 'Dr. Priya Nair',
      totalLessons: 40,
      completedLessons: 22,
      rating: 4.7,
      students: 7200,
      level: 'Beginner',
    ),
    StudyCourse(
      id: 'COURSE006',
      subjectId: 'SUB004',
      title: 'Dart Programming',
      description:
          'Learn Dart from fundamentals to object-oriented programming.',
      instructor: 'Rahul Sharma',
      totalLessons: 30,
      completedLessons: 16,
      rating: 4.9,
      students: 11800,
      level: 'Beginner',
    ),
    StudyCourse(
      id: 'COURSE007',
      subjectId: 'SUB004',
      title: 'Flutter Complete Course',
      description:
          'Build professional Flutter applications from beginner to advanced.',
      instructor: 'Rahul Sharma',
      totalLessons: 60,
      completedLessons: 21,
      rating: 4.9,
      students: 17400,
      level: 'Advanced',
    ),
    StudyCourse(
      id: 'COURSE008',
      subjectId: 'SUB005',
      title: 'English Communication',
      description:
          'Improve grammar, vocabulary, writing and professional communication.',
      instructor: 'Priya Nair',
      totalLessons: 30,
      completedLessons: 25,
      rating: 4.8,
      students: 6100,
      level: 'Intermediate',
    ),
  ];

  static const List<StudyChapter> chapters = [
    StudyChapter(
      id: 'CH001',
      courseId: 'COURSE001',
      title: 'Introduction to Mechanics',
      description: 'Fundamental concepts of motion, force and measurement.',
      chapterNumber: 1,
    ),
    StudyChapter(
      id: 'CH002',
      courseId: 'COURSE001',
      title: 'Newton Laws of Motion',
      description: 'Detailed study of Newton laws and applications.',
      chapterNumber: 2,
    ),
    StudyChapter(
      id: 'CH003',
      courseId: 'COURSE001',
      title: 'Work, Energy and Power',
      description:
          'Understand work, kinetic energy, potential energy and power.',
      chapterNumber: 3,
    ),
    StudyChapter(
      id: 'CH004',
      courseId: 'COURSE002',
      title: 'Quantum Physics',
      description:
          'Introduction to quantum mechanics and wave-particle duality.',
      chapterNumber: 1,
    ),
    StudyChapter(
      id: 'CH005',
      courseId: 'COURSE003',
      title: 'Differential Calculus',
      description: 'Limits, continuity and differentiation.',
      chapterNumber: 1,
    ),
    StudyChapter(
      id: 'CH006',
      courseId: 'COURSE003',
      title: 'Integral Calculus',
      description: 'Integration techniques and applications.',
      chapterNumber: 2,
    ),
    StudyChapter(
      id: 'CH007',
      courseId: 'COURSE006',
      title: 'Dart Fundamentals',
      description: 'Variables, types, functions and operators.',
      chapterNumber: 1,
    ),
    StudyChapter(
      id: 'CH008',
      courseId: 'COURSE006',
      title: 'Object Oriented Dart',
      description:
          'Classes, objects, constructors, inheritance and polymorphism.',
      chapterNumber: 2,
    ),
    StudyChapter(
      id: 'CH009',
      courseId: 'COURSE007',
      title: 'Flutter Fundamentals',
      description: 'Widgets, layouts, state and navigation.',
      chapterNumber: 1,
    ),
    StudyChapter(
      id: 'CH010',
      courseId: 'COURSE007',
      title: 'Flutter State Management',
      description: 'Learn practical state management patterns.',
      chapterNumber: 2,
    ),
  ];

  static const List<StudyLesson> lessons = [
    StudyLesson(
      id: 'LES001',
      chapterId: 'CH001',
      title: 'Introduction to Motion',
      description:
          'Understand the basic concepts of motion and reference frames.',
      type: LessonType.video,
      durationMinutes: 28,
      lessonNumber: 1,
      isFree: true,
      content:
          'Motion is the change in position of an object with respect to a reference frame over time.',
    ),
    StudyLesson(
      id: 'LES002',
      chapterId: 'CH001',
      title: 'Distance and Displacement',
      description: 'Learn the difference between distance and displacement.',
      type: LessonType.article,
      durationMinutes: 20,
      lessonNumber: 2,
      isFree: true,
      content:
          'Distance is a scalar quantity representing the total path travelled. Displacement is a vector quantity representing the change in position.',
    ),
    StudyLesson(
      id: 'LES003',
      chapterId: 'CH001',
      title: 'Speed and Velocity',
      description:
          'Understand speed, velocity and their mathematical relationships.',
      type: LessonType.video,
      durationMinutes: 32,
      lessonNumber: 3,
      isFree: false,
      content:
          'Speed is the rate of change of distance while velocity is the rate of change of displacement.',
    ),
    StudyLesson(
      id: 'LES004',
      chapterId: 'CH002',
      title: 'Newton First Law',
      description: 'Learn the law of inertia and its applications.',
      type: LessonType.video,
      durationMinutes: 35,
      lessonNumber: 1,
      isFree: false,
      content:
          'An object remains at rest or continues in uniform motion unless acted upon by an external unbalanced force.',
    ),
    StudyLesson(
      id: 'LES005',
      chapterId: 'CH002',
      title: 'Newton Second Law',
      description: 'Understand force, mass and acceleration.',
      type: LessonType.video,
      durationMinutes: 40,
      lessonNumber: 2,
      isFree: false,
      content:
          'Newton second law states that the net force acting on an object is equal to the rate of change of momentum. For constant mass, F = ma.',
    ),
    StudyLesson(
      id: 'LES006',
      chapterId: 'CH002',
      title: 'Newton Laws Quiz',
      description: 'Test your understanding of Newton laws.',
      type: LessonType.quiz,
      durationMinutes: 15,
      lessonNumber: 3,
      isFree: false,
      content:
          'Complete the quiz to evaluate your understanding of Newton laws of motion.',
    ),
    StudyLesson(
      id: 'LES007',
      chapterId: 'CH003',
      title: 'Work',
      description: 'Learn the physical meaning of work.',
      type: LessonType.article,
      durationMinutes: 25,
      lessonNumber: 1,
      isFree: false,
      content:
          'Work is done when a force causes displacement in the direction of the force.',
    ),
    StudyLesson(
      id: 'LES008',
      chapterId: 'CH003',
      title: 'Kinetic Energy',
      description: 'Understand kinetic energy and its mathematical expression.',
      type: LessonType.video,
      durationMinutes: 30,
      lessonNumber: 2,
      isFree: false,
      content:
          'Kinetic energy is the energy possessed by an object due to its motion and is given by KE = 1/2 mv².',
    ),
    StudyLesson(
      id: 'LES009',
      chapterId: 'CH004',
      title: 'Quantum Introduction',
      description: 'Introduction to quantum physics.',
      type: LessonType.video,
      durationMinutes: 36,
      lessonNumber: 1,
      isFree: true,
      content:
          'Quantum physics describes physical phenomena at microscopic scales where classical physics is insufficient.',
    ),
    StudyLesson(
      id: 'LES010',
      chapterId: 'CH005',
      title: 'Limits',
      description: 'Understand the concept of limits.',
      type: LessonType.video,
      durationMinutes: 30,
      lessonNumber: 1,
      isFree: true,
      content:
          'A limit describes the value that a function approaches as its input approaches a particular value.',
    ),
    StudyLesson(
      id: 'LES011',
      chapterId: 'CH005',
      title: 'Continuity',
      description: 'Learn continuity of functions.',
      type: LessonType.article,
      durationMinutes: 22,
      lessonNumber: 2,
      isFree: false,
      content:
          'A function is continuous at a point when its limit, function value and surrounding behavior satisfy the continuity condition.',
    ),
    StudyLesson(
      id: 'LES012',
      chapterId: 'CH005',
      title: 'Differentiation',
      description: 'Learn derivatives and differentiation rules.',
      type: LessonType.video,
      durationMinutes: 42,
      lessonNumber: 3,
      isFree: false,
      content:
          'Differentiation measures the rate at which a function changes with respect to its variable.',
    ),
    StudyLesson(
      id: 'LES013',
      chapterId: 'CH007',
      title: 'Dart Variables',
      description: 'Learn variables and data types in Dart.',
      type: LessonType.video,
      durationMinutes: 24,
      lessonNumber: 1,
      isFree: true,
      content:
          'Dart provides variables and static types such as int, double, String and bool.',
    ),
    StudyLesson(
      id: 'LES014',
      chapterId: 'CH007',
      title: 'Dart Functions',
      description: 'Learn how functions work in Dart.',
      type: LessonType.video,
      durationMinutes: 28,
      lessonNumber: 2,
      isFree: true,
      content:
          'Functions allow us to group reusable logic into named blocks of code.',
    ),
    StudyLesson(
      id: 'LES015',
      chapterId: 'CH008',
      title: 'Classes and Objects',
      description: 'Understand object oriented programming in Dart.',
      type: LessonType.video,
      durationMinutes: 35,
      lessonNumber: 1,
      isFree: false,
      content:
          'A class defines the structure and behavior of objects. Objects are instances of classes.',
    ),
    StudyLesson(
      id: 'LES016',
      chapterId: 'CH008',
      title: 'Constructors',
      description: 'Learn Dart constructors.',
      type: LessonType.article,
      durationMinutes: 26,
      lessonNumber: 2,
      isFree: false,
      content:
          'Constructors initialize objects when an instance of a class is created.',
    ),
    StudyLesson(
      id: 'LES017',
      chapterId: 'CH009',
      title: 'Flutter Widgets',
      description:
          'Learn the fundamental building blocks of Flutter applications.',
      type: LessonType.video,
      durationMinutes: 40,
      lessonNumber: 1,
      isFree: true,
      content:
          'Widgets are the fundamental building blocks of Flutter user interfaces.',
    ),
    StudyLesson(
      id: 'LES018',
      chapterId: 'CH009',
      title: 'Flutter Layouts',
      description: 'Learn Row, Column, Container and other layout widgets.',
      type: LessonType.video,
      durationMinutes: 38,
      lessonNumber: 2,
      isFree: false,
      content:
          'Flutter provides flexible layout widgets for constructing responsive user interfaces.',
    ),
    StudyLesson(
      id: 'LES019',
      chapterId: 'CH010',
      title: 'State Management',
      description: 'Understand why application state needs to be managed.',
      type: LessonType.video,
      durationMinutes: 45,
      lessonNumber: 1,
      isFree: false,
      content:
          'State management controls how application data changes and how widgets react to those changes.',
    ),
  ];
}

// ============================================================
// 4. STUDY STATE
// ============================================================

class StudyState extends ChangeNotifier {
  final Set<String> completedLessons = <String>{};

  final List<StudyNote> notes = [];

  final List<StudyBookmark> bookmarks = [];

  final List<StudyHistory> history = [];

  String searchQuery = '';

  String? selectedSubjectId;

  List<StudyCourse> get filteredCourses {
    final query = searchQuery.trim().toLowerCase();

    return StudyDatabase.courses.where((course) {
      final matchesSubject =
          selectedSubjectId == null || course.subjectId == selectedSubjectId;

      if (!matchesSubject) {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }

      return course.title.toLowerCase().contains(query) ||
          course.description.toLowerCase().contains(query) ||
          course.instructor.toLowerCase().contains(query);
    }).toList();
  }

  List<StudyChapter> chaptersForCourse(String courseId) {
    return StudyDatabase.chapters
        .where((chapter) => chapter.courseId == courseId)
        .toList();
  }

  List<StudyLesson> lessonsForChapter(String chapterId) {
    return StudyDatabase.lessons
        .where((lesson) => lesson.chapterId == chapterId)
        .toList();
  }

  StudyCourse? courseById(String courseId) {
    for (final course in StudyDatabase.courses) {
      if (course.id == courseId) {
        return course;
      }
    }

    return null;
  }

  StudyChapter? chapterById(String chapterId) {
    for (final chapter in StudyDatabase.chapters) {
      if (chapter.id == chapterId) {
        return chapter;
      }
    }

    return null;
  }

  StudyLesson? lessonById(String lessonId) {
    for (final lesson in StudyDatabase.lessons) {
      if (lesson.id == lessonId) {
        return lesson;
      }
    }

    return null;
  }

  StudySubject? subjectById(String subjectId) {
    for (final subject in StudyDatabase.subjects) {
      if (subject.id == subjectId) {
        return subject;
      }
    }

    return null;
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setSubject(String? subjectId) {
    selectedSubjectId = subjectId;
    notifyListeners();
  }

  bool isCompleted(String lessonId) {
    return completedLessons.contains(lessonId);
  }

  void toggleLessonCompleted(String lessonId) {
    if (completedLessons.contains(lessonId)) {
      completedLessons.remove(lessonId);
    } else {
      completedLessons.add(lessonId);
    }

    notifyListeners();
  }

  bool isBookmarked(String lessonId) {
    return bookmarks.any(
      (bookmark) => bookmark.lessonId == lessonId,
    );
  }

  void toggleBookmark(
    String lessonId,
    String userId,
  ) {
    final existingIndex = bookmarks.indexWhere(
      (bookmark) => bookmark.lessonId == lessonId && bookmark.userId == userId,
    );

    if (existingIndex >= 0) {
      bookmarks.removeAt(existingIndex);
    } else {
      bookmarks.add(
        StudyBookmark(
          id: 'BM${DateTime.now().microsecondsSinceEpoch}',
          lessonId: lessonId,
          userId: userId,
          createdAt: DateTime.now(),
        ),
      );
    }

    notifyListeners();
  }

  void addNote({
    required String lessonId,
    required String userId,
    required String title,
    required String content,
  }) {
    final now = DateTime.now();

    notes.add(
      StudyNote(
        id: 'NOTE${DateTime.now().microsecondsSinceEpoch}',
        lessonId: lessonId,
        userId: userId,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      ),
    );

    notifyListeners();
  }

  void deleteNote(String noteId) {
    notes.removeWhere(
      (note) => note.id == noteId,
    );

    notifyListeners();
  }

  List<StudyNote> notesForLesson(String lessonId) {
    return notes.where((note) => note.lessonId == lessonId).toList();
  }

  void recordHistory({
    required String lessonId,
    required String userId,
    required int watchedMinutes,
  }) {
    history.insert(
      0,
      StudyHistory(
        id: 'H${DateTime.now().microsecondsSinceEpoch}',
        lessonId: lessonId,
        userId: userId,
        openedAt: DateTime.now(),
        watchedMinutes: watchedMinutes,
      ),
    );

    if (history.length > 30) {
      history.removeLast();
    }

    notifyListeners();
  }

  List<StudyHistory> get recentHistory {
    return List<StudyHistory>.from(history);
  }

  double courseProgress(String courseId) {
    final lessons = StudyDatabase.lessons.where((lesson) {
      final chapter = chapterById(lesson.chapterId);
      return chapter?.courseId == courseId;
    }).toList();

    if (lessons.isEmpty) {
      return 0;
    }

    final completed =
        lessons.where((lesson) => completedLessons.contains(lesson.id)).length;

    return completed / lessons.length;
  }

  int completedCountForCourse(String courseId) {
    final lessons = StudyDatabase.lessons.where((lesson) {
      final chapter = chapterById(lesson.chapterId);

      return chapter?.courseId == courseId;
    });

    return lessons
        .where((lesson) => completedLessons.contains(lesson.id))
        .length;
  }

  void clearSearch() {
    searchQuery = '';
    selectedSubjectId = null;
    notifyListeners();
  }
}

// ============================================================
// 5. STUDY HOME SCREEN
// ============================================================

class StudyHomeScreen extends StatefulWidget {
  final AppState appState;

  const StudyHomeScreen({
    super.key,
    required this.appState,
  });

  @override
  State<StudyHomeScreen> createState() => _StudyHomeScreenState();
}

class _StudyHomeScreenState extends State<StudyHomeScreen> {
  late final StudyState studyState;

  @override
  void initState() {
    super.initState();
    studyState = StudyState();
  }

  @override
  void dispose() {
    studyState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: studyState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(
                    isDesktop ? 32 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StudyHeader(
                        appState: widget.appState,
                      ),
                      const SizedBox(height: 28),
                      _StudySearchBar(
                        studyState: studyState,
                      ),
                      const SizedBox(height: 28),
                      _ContinueLearningSection(
                        appState: widget.appState,
                        studyState: studyState,
                      ),
                      const SizedBox(height: 32),
                      _StudySectionHeader(
                        title: 'Browse Subjects',
                        subtitle: 'Choose a subject to start learning',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubjectsScreen(
                                studyState: studyState,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _SubjectsHorizontalList(
                        studyState: studyState,
                      ),
                      const SizedBox(height: 32),
                      _StudySectionHeader(
                        title: 'My Courses',
                        subtitle: 'Continue your learning journey',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoursesScreenPart2(
                                studyState: studyState,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _CourseGrid(
                        courses: StudyDatabase.courses.take(4).toList(),
                        studyState: studyState,
                      ),
                      const SizedBox(height: 32),
                      _StudySectionHeader(
                        title: 'Recommended Courses',
                        subtitle: 'Courses selected for you',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoursesScreenPart2(
                                studyState: studyState,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _CourseGrid(
                        courses: StudyDatabase.courses.skip(4).take(4).toList(),
                        studyState: studyState,
                      ),
                      const SizedBox(height: 32),
                      _RecentLessonsSection(
                        studyState: studyState,
                        appState: widget.appState,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// 6. STUDY HEADER
// ============================================================

class _StudyHeader extends StatelessWidget {
  final AppState appState;

  const _StudyHeader({
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final name = appState.currentUser?.name ?? 'Student';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Study',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Welcome back, $name',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.blue.withOpacity(.12),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.blue,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 7. SEARCH BAR
// ============================================================

class _StudySearchBar extends StatelessWidget {
  final StudyState studyState;

  const _StudySearchBar({
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: studyState.setSearchQuery,
      decoration: InputDecoration(
        hintText: 'Search courses, subjects or lessons...',
        prefixIcon: const Icon(
          Icons.search_rounded,
        ),
        suffixIcon: studyState.searchQuery.isNotEmpty
            ? IconButton(
                onPressed: studyState.clearSearch,
                icon: const Icon(
                  Icons.clear_rounded,
                ),
              )
            : null,
      ),
    );
  }
}

// ============================================================
// 8. CONTINUE LEARNING
// ============================================================

class _ContinueLearningSection extends StatelessWidget {
  final AppState appState;
  final StudyState studyState;

  const _ContinueLearningSection({
    required this.appState,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    final course = StudyDatabase.courses.first;

    final progress = studyState.courseProgress(course.id);

    return Card(
      elevation: 0,
      color: AppColors.navy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONTINUE LEARNING',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    course.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.instructor,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress == 0 ? course.progress : progress,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${((progress == 0 ? course.progress : progress) * 100).round()}% completed',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.navy,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailsScreenPart2(
                            course: course,
                            studyState: studyState,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                    ),
                    label: const Text(
                      'Continue',
                    ),
                  ),
                ],
              ),
            ),
            if (MediaQuery.sizeOf(context).width > 700)
              const SizedBox(width: 40),
            if (MediaQuery.sizeOf(context).width > 700)
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  size: 90,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 9. SECTION HEADER
// ============================================================

class _StudySectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onPressed;

  const _StudySectionHeader({
    required this.title,
    required this.subtitle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        if (onPressed != null)
          TextButton(
            onPressed: onPressed,
            child: const Text('View All'),
          ),
      ],
    );
  }
}

// ============================================================
// 10. SUBJECT HORIZONTAL LIST
// ============================================================

class _SubjectsHorizontalList extends StatelessWidget {
  final StudyState studyState;

  const _SubjectsHorizontalList({
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: StudyDatabase.subjects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final subject = StudyDatabase.subjects[index];

          return SizedBox(
            width: 190,
            child: _SubjectCard(
              subject: subject,
              studyState: studyState,
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// 11. SUBJECT CARD
// ============================================================

class _SubjectCard extends StatelessWidget {
  final StudySubject subject;
  final StudyState studyState;

  const _SubjectCard({
    required this.subject,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoursesScreenPart2(
              studyState: studyState,
              subjectId: subject.id,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(
            color: AppColors.border,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  subject.icon,
                  color: AppColors.blue,
                ),
              ),
              const Spacer(),
              Text(
                subject.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${subject.courseCount} courses',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 12. COURSE GRID
// ============================================================

class _CourseGrid extends StatelessWidget {
  final List<StudyCourse> courses;
  final StudyState studyState;

  const _CourseGrid({
    required this.courses,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    int columns = 1;

    if (width >= 1300) {
      columns = 4;
    } else if (width >= 900) {
      columns = 3;
    } else if (width >= 600) {
      columns = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: width < 600 ? 1.05 : 1.15,
      ),
      itemBuilder: (context, index) {
        return _StudyCourseCard(
          course: courses[index],
          studyState: studyState,
        );
      },
    );
  }
}

// ============================================================
// 13. COURSE CARD
// ============================================================

class _StudyCourseCard extends StatelessWidget {
  final StudyCourse course;
  final StudyState studyState;

  const _StudyCourseCard({
    required this.course,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    final progress = studyState.courseProgress(course.id);

    final effectiveProgress = progress == 0 ? course.progress : progress;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailsScreenPart2(
              course: course,
              studyState: studyState,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: AppColors.border,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.blue,
                      AppColors.lightBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.school_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                course.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                course.instructor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 17,
                    color: AppColors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    course.rating.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    course.level,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: effectiveProgress,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(effectiveProgress * 100).round()}% complete',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 14. SUBJECTS SCREEN
// ============================================================

class SubjectsScreen extends StatelessWidget {
  final StudyState studyState;

  const SubjectsScreen({
    super.key,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: StudyDatabase.subjects.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          final subject = StudyDatabase.subjects[index];

          return _SubjectLargeCard(
            subject: subject,
            studyState: studyState,
          );
        },
      ),
    );
  }
}

// ============================================================
// 15. LARGE SUBJECT CARD
// ============================================================

class _SubjectLargeCard extends StatelessWidget {
  final StudySubject subject;
  final StudyState studyState;

  const _SubjectLargeCard({
    required this.subject,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoursesScreenPart2(
              studyState: studyState,
              subjectId: subject.id,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(
            color: AppColors.border,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.blue.withOpacity(.10),
                child: Icon(
                  subject.icon,
                  color: AppColors.blue,
                  size: 30,
                ),
              ),
              const Spacer(),
              Text(
                subject.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subject.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${subject.courseCount} courses',
                style: const TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 16. COURSES SCREEN
// ============================================================

class CoursesScreenPart2 extends StatefulWidget {
  final StudyState studyState;
  final String? subjectId;

  const CoursesScreenPart2({
    super.key,
    required this.studyState,
    this.subjectId,
  });

  @override
  State<CoursesScreenPart2> createState() => _CoursesScreenPart2State();
}

class _CoursesScreenPart2State extends State<CoursesScreenPart2> {
  @override
  void initState() {
    super.initState();

    if (widget.subjectId != null) {
      widget.studyState.setSubject(
        widget.subjectId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.studyState,
      builder: (context, _) {
        final courses = widget.studyState.filteredCourses;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Courses'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  10,
                ),
                child: _CourseFilterBar(
                  studyState: widget.studyState,
                ),
              ),
              Expanded(
                child: courses.isEmpty
                    ? const _EmptyStudyState(
                        title: 'No courses found',
                        message: 'Try another search or subject.',
                        icon: Icons.search_off_rounded,
                      )
                    : _CourseGrid(
                        courses: courses,
                        studyState: widget.studyState,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// 17. COURSE FILTER BAR
// ============================================================

class _CourseFilterBar extends StatelessWidget {
  final StudyState studyState;

  const _CourseFilterBar({
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      initialValue: studyState.selectedSubjectId,
      decoration: const InputDecoration(
        labelText: 'Filter by subject',
        prefixIcon: Icon(Icons.filter_list_rounded),
      ),
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('All Subjects'),
        ),
        ...StudyDatabase.subjects.map(
          (subject) => DropdownMenuItem<String?>(
            value: subject.id,
            child: Text(subject.name),
          ),
        ),
      ],
      onChanged: studyState.setSubject,
    );
  }
}

// ============================================================
// 18. COURSE DETAILS SCREEN
// ============================================================

class CourseDetailsScreenPart2 extends StatelessWidget {
  final StudyCourse course;
  final StudyState studyState;

  const CourseDetailsScreenPart2({
    super.key,
    required this.course,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    final chapters = studyState.chaptersForCourse(
      course.id,
    );

    final progress = studyState.courseProgress(course.id);

    final effectiveProgress = progress == 0 ? course.progress : progress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CourseHero(
                  course: course,
                  progress: effectiveProgress,
                ),
                const SizedBox(height: 28),
                const Text(
                  'About this course',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  course.description,
                  style: const TextStyle(
                    height: 1.6,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Course Content',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                ...chapters.map(
                  (chapter) => _ChapterTile(
                    chapter: chapter,
                    studyState: studyState,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 19. COURSE HERO
// ============================================================

class _CourseHero extends StatelessWidget {
  final StudyCourse course;
  final double progress;

  const _CourseHero({
    required this.course,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.navy,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              course.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Instructor: ${course.instructor}',
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.orange,
                ),
                const SizedBox(width: 5),
                Text(
                  course.rating.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  '${course.students} students',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).round()}% completed',
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 20. CHAPTER TILE
// ============================================================

class _ChapterTile extends StatelessWidget {
  final StudyChapter chapter;
  final StudyState studyState;

  const _ChapterTile({
    required this.chapter,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = studyState.lessonsForChapter(
      chapter.id,
    );

    final completed = lessons
        .where(
          (lesson) => studyState.isCompleted(
            lesson.id,
          ),
        )
        .length;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: AppColors.border,
        ),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.blue.withOpacity(.10),
          child: Text(
            chapter.chapterNumber.toString(),
            style: const TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          chapter.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '$completed/${lessons.length} lessons completed',
        ),
        children: lessons
            .map(
              (lesson) => _LessonTile(
                lesson: lesson,
                studyState: studyState,
              ),
            )
            .toList(),
      ),
    );
  }
}

// ============================================================
// 21. LESSON TILE
// ============================================================

class _LessonTile extends StatelessWidget {
  final StudyLesson lesson;
  final StudyState studyState;

  const _LessonTile({
    required this.lesson,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    final completed = studyState.isCompleted(
      lesson.id,
    );

    return ListTile(
      leading: Icon(
        _lessonIcon(lesson.type),
        color: completed ? AppColors.green : AppColors.blue,
      ),
      title: Text(
        lesson.title,
        style: TextStyle(
          fontWeight: completed ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        '${lesson.durationMinutes} min',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (lesson.isFree)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'FREE',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (completed)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.green,
            )
          else
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonViewerScreen(
              lesson: lesson,
              studyState: studyState,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// 22. LESSON VIEWER
// ============================================================

class LessonViewerScreen extends StatefulWidget {
  final StudyLesson lesson;
  final StudyState studyState;

  const LessonViewerScreen({
    super.key,
    required this.lesson,
    required this.studyState,
  });

  @override
  State<LessonViewerScreen> createState() => _LessonViewerScreenState();
}

class _LessonViewerScreenState extends State<LessonViewerScreen> {
  @override
  void initState() {
    super.initState();

    final userId = 'USR001';

    widget.studyState.recordHistory(
      lessonId: widget.lesson.id,
      userId: userId,
      watchedMinutes: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return AnimatedBuilder(
      animation: widget.studyState,
      builder: (context, _) {
        final completed = widget.studyState.isCompleted(
          lesson.id,
        );

        final bookmarked = widget.studyState.isBookmarked(
          lesson.id,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(
              lesson.title,
            ),
            actions: [
              IconButton(
                tooltip: 'Bookmark',
                onPressed: () {
                  widget.studyState.toggleBookmark(
                    lesson.id,
                    'USR001',
                  );
                },
                icon: Icon(
                  bookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LessonMediaPlaceholder(
                      lesson: lesson,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lesson.description,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _InfoChip(
                          icon: Icons.timer_outlined,
                          text: '${lesson.durationMinutes} minutes',
                        ),
                        _InfoChip(
                          icon: Icons.category_outlined,
                          text: _lessonTypeName(lesson.type),
                        ),
                        if (lesson.isFree)
                          const _InfoChip(
                            icon: Icons.lock_open_rounded,
                            text: 'Free lesson',
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Lesson Content',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          18,
                        ),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: Text(
                        lesson.content,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              widget.studyState.toggleLessonCompleted(
                                lesson.id,
                              );
                            },
                            icon: Icon(
                              completed
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                            ),
                            label: Text(
                              completed ? 'Completed' : 'Mark as Complete',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filledTonal(
                          tooltip: 'Add Note',
                          onPressed: () {
                            _showAddNoteDialog(
                              context,
                            );
                          },
                          icon: const Icon(
                            Icons.note_add_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _LessonNotesSection(
                      lesson: lesson,
                      studyState: widget.studyState,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddNoteDialog(
    BuildContext context,
  ) {
    final titleController = TextEditingController();

    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Add Note',
          ),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                if (contentController.text.trim().isEmpty) {
                  return;
                }

                widget.studyState.addNote(
                  lessonId: widget.lesson.id,
                  userId: 'USR001',
                  title: titleController.text.trim().isEmpty
                      ? 'My Note'
                      : titleController.text.trim(),
                  content: contentController.text.trim(),
                );

                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Save',
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// 23. LESSON MEDIA PLACEHOLDER
// ============================================================

class _LessonMediaPlaceholder extends StatelessWidget {
  final StudyLesson lesson;

  const _LessonMediaPlaceholder({
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;

    switch (lesson.type) {
      case LessonType.video:
        icon = Icons.play_circle_fill_rounded;
        break;

      case LessonType.article:
        icon = Icons.article_rounded;
        break;

      case LessonType.quiz:
        icon = Icons.quiz_rounded;
        break;

      case LessonType.assignment:
        icon = Icons.assignment_rounded;
        break;

      case LessonType.liveClass:
        icon = Icons.live_tv_rounded;
        break;
    }

    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.navy,
            AppColors.dark,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: 90,
        ),
      ),
    );
  }
}

// ============================================================
// 24. INFO CHIP
// ============================================================

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
            color: AppColors.blue,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 25. LESSON NOTES
// ============================================================

class _LessonNotesSection extends StatelessWidget {
  final StudyLesson lesson;
  final StudyState studyState;

  const _LessonNotesSection({
    required this.lesson,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    final notes = studyState.notesForLesson(
      lesson.id,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Notes',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        if (notes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  size: 42,
                  color: AppColors.secondaryText,
                ),
                SizedBox(height: 10),
                Text(
                  'No notes yet',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        else
          ...notes.map(
            (note) => Card(
              elevation: 0,
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              child: ListTile(
                title: Text(
                  note.title,
                ),
                subtitle: Text(
                  note.content,
                ),
                trailing: IconButton(
                  onPressed: () {
                    studyState.deleteNote(
                      note.id,
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================
// 26. RECENT LESSONS
// ============================================================

class _RecentLessonsSection extends StatelessWidget {
  final StudyState studyState;
  final AppState appState;

  const _RecentLessonsSection({
    required this.studyState,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    if (studyState.recentHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recently Studied',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        ...studyState.recentHistory.take(5).map(
          (historyItem) {
            final lesson = studyState.lessonById(
              historyItem.lessonId,
            );

            if (lesson == null) {
              return const SizedBox.shrink();
            }

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEFF6FF),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.blue,
                  ),
                ),
                title: Text(
                  lesson.title,
                ),
                subtitle: Text(
                  '${lesson.durationMinutes} minutes',
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonViewerScreen(
                        lesson: lesson,
                        studyState: studyState,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// 27. BOOKMARKS SCREEN
// ============================================================

class StudyBookmarksScreen extends StatelessWidget {
  final StudyState studyState;

  const StudyBookmarksScreen({
    super.key,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: studyState,
      builder: (context, _) {
        final bookmarks = studyState.bookmarks;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bookmarks'),
          ),
          body: bookmarks.isEmpty
              ? const _EmptyStudyState(
                  title: 'No bookmarks yet',
                  message: 'Bookmark lessons to find them quickly later.',
                  icon: Icons.bookmark_border_rounded,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarks[index];

                    final lesson = studyState.lessonById(
                      bookmark.lessonId,
                    );

                    if (lesson == null) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.bookmark_rounded,
                          color: AppColors.blue,
                        ),
                        title: Text(lesson.title),
                        subtitle: Text(
                          lesson.description,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LessonViewerScreen(
                                lesson: lesson,
                                studyState: studyState,
                              ),
                            ),
                          );
                        },
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
// 28. NOTES SCREEN
// ============================================================

class StudyNotesScreen extends StatelessWidget {
  final StudyState studyState;

  const StudyNotesScreen({
    super.key,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: studyState,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Notes'),
          ),
          body: studyState.notes.isEmpty
              ? const _EmptyStudyState(
                  title: 'No notes yet',
                  message: 'Your lesson notes will appear here.',
                  icon: Icons.note_alt_outlined,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  itemCount: studyState.notes.length,
                  itemBuilder: (context, index) {
                    final note = studyState.notes[index];

                    final lesson = studyState.lessonById(
                      note.lessonId,
                    );

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: ListTile(
                        title: Text(note.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              note.content,
                            ),
                            if (lesson != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: Text(
                                  'Lesson: ${lesson.title}',
                                  style: const TextStyle(
                                    color: AppColors.blue,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            studyState.deleteNote(
                              note.id,
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.red,
                          ),
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
// 29. STUDY PROGRESS SCREEN
// ============================================================

class StudyProgressScreen extends StatelessWidget {
  final StudyState studyState;

  const StudyProgressScreen({
    super.key,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: studyState,
      builder: (context, _) {
        final totalLessons = StudyDatabase.lessons.length;

        final completed = studyState.completedLessons.length;

        final progress = totalLessons == 0 ? 0.0 : completed / totalLessons;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Study Progress'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  color: AppColors.navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      28,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 10,
                                  backgroundColor: Colors.white24,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${(progress * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Overall Progress',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '$completed of $totalLessons lessons completed',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Course Progress',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ...StudyDatabase.courses.map(
                  (course) {
                    final courseProgress = studyState.courseProgress(
                      course.id,
                    );

                    final effective =
                        courseProgress == 0 ? course.progress : courseProgress;

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                          18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            LinearProgressIndicator(
                              value: effective,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              '${(effective * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
// 30. SEARCH RESULTS SCREEN
// ============================================================

class StudySearchScreen extends StatelessWidget {
  final StudyState studyState;

  const StudySearchScreen({
    super.key,
    required this.studyState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: studyState,
      builder: (context, _) {
        final courses = studyState.filteredCourses;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  20,
                ),
                child: TextField(
                  autofocus: true,
                  onChanged: studyState.setSearchQuery,
                  decoration: const InputDecoration(
                    hintText: 'Search courses...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: courses.isEmpty
                    ? const _EmptyStudyState(
                        title: 'Nothing found',
                        message: 'Try a different search term.',
                        icon: Icons.search_off_rounded,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        itemCount: courses.length,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(
                                  0xFFEFF6FF,
                                ),
                                child: Icon(
                                  Icons.school_rounded,
                                  color: AppColors.blue,
                                ),
                              ),
                              title: Text(
                                courses[index].title,
                              ),
                              subtitle: Text(
                                courses[index].instructor,
                              ),
                              trailing: const Icon(
                                Icons.chevron_right_rounded,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailsScreenPart2(
                                      course: courses[index],
                                      studyState: studyState,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// 31. EMPTY STATE
// ============================================================

class _EmptyStudyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const _EmptyStudyState({
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 70,
              color: AppColors.secondaryText,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 32. LESSON ICON
// ============================================================

IconData _lessonIcon(
  LessonType type,
) {
  switch (type) {
    case LessonType.video:
      return Icons.play_circle_outline_rounded;

    case LessonType.article:
      return Icons.article_outlined;

    case LessonType.quiz:
      return Icons.quiz_outlined;

    case LessonType.assignment:
      return Icons.assignment_outlined;

    case LessonType.liveClass:
      return Icons.live_tv_outlined;
  }
}

// ============================================================
// 33. LESSON TYPE NAME
// ============================================================

String _lessonTypeName(
  LessonType type,
) {
  switch (type) {
    case LessonType.video:
      return 'Video';

    case LessonType.article:
      return 'Article';

    case LessonType.quiz:
      return 'Quiz';

    case LessonType.assignment:
      return 'Assignment';

    case LessonType.liveClass:
      return 'Live Class';
  }
}

// ============================================================
// ============================================================
// PART 3 — ASSIGNMENTS & HOMEWORK MODULE
// ============================================================
// ============================================================
//
// Features:
//
// 1. Assignment models
// 2. Assignment questions
// 3. Assignment database
// 4. Assignment state management
// 5. Assignment home
// 6. Assignment filters
// 7. Assignment details
// 8. Question navigation
// 9. Multiple-choice answers
// 10. Progress tracking
// 11. Assignment submission
// 12. Score calculation
// 13. Result screen
// 14. Answer review
// 15. Assignment history
// 16. Responsive UI
//
// ============================================================


// ============================================================
// 1. ASSIGNMENT ENUMS
// ============================================================

enum AssignmentStatusPart3 {
  upcoming,
  inProgress,
  submitted,
  overdue,
}


// ============================================================
// 2. ASSIGNMENT QUESTION MODEL
// ============================================================

class AssignmentQuestionPart3 {
  final String id;
  final String assignmentId;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final int marks;

  const AssignmentQuestionPart3({
    required this.id,
    required this.assignmentId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.marks,
  });
}


// ============================================================
// 3. ASSIGNMENT MODEL
// ============================================================

class AssignmentModelPart3 {
  final String id;
  final String title;
  final String subject;
  final String description;
  final String instructor;
  final DateTime dueDate;
  final int totalMarks;
  final int durationMinutes;
  final List<String> questionIds;

  const AssignmentModelPart3({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.instructor,
    required this.dueDate,
    required this.totalMarks,
    required this.durationMinutes,
    required this.questionIds,
  });

  int get questionCount => questionIds.length;
}


// ============================================================
// 4. ASSIGNMENT SUBMISSION MODEL
// ============================================================

class AssignmentSubmissionPart3 {
  final String id;
  final String assignmentId;
  final String userId;
  final Map<String, int> answers;
  final int score;
  final int totalMarks;
  final DateTime submittedAt;

  const AssignmentSubmissionPart3({
    required this.id,
    required this.assignmentId,
    required this.userId,
    required this.answers,
    required this.score,
    required this.totalMarks,
    required this.submittedAt,
  });

  double get percentage {
    if (totalMarks == 0) {
      return 0;
    }

    return score / totalMarks;
  }
}


// ============================================================
// 5. ASSIGNMENT DATABASE
// ============================================================

class AssignmentDatabasePart3 {
  static final List<AssignmentModelPart3> assignments = [
    AssignmentModelPart3(
      id: 'ASG001',
      title: 'Newton Laws Assignment',
      subject: 'Physics',
      description:
      'Test your understanding of Newton laws of motion, force, mass and acceleration.',
      instructor: 'Dr. Arun Kumar',
      dueDate: DateTime(2026, 9, 24, 23, 59),
      totalMarks: 20,
      durationMinutes: 30,
      questionIds: [
        'Q001',
        'Q002',
        'Q003',
        'Q004',
        'Q005',
      ],
    ),

    AssignmentModelPart3(
      id: 'ASG002',
      title: 'Integration Problems',
      subject: 'Mathematics',
      description:
      'Practice integration techniques and applications.',
      instructor: 'Prof. Meena Rao',
      dueDate: DateTime(2026, 9, 26, 23, 59),
      totalMarks: 25,
      durationMinutes: 40,
      questionIds: [
        'Q006',
        'Q007',
        'Q008',
        'Q009',
        'Q010',
      ],
    ),

    AssignmentModelPart3(
      id: 'ASG003',
      title: 'Dart Programming',
      subject: 'Computer Science',
      description:
      'Test your understanding of Dart fundamentals and object-oriented programming.',
      instructor: 'Rahul Sharma',
      dueDate: DateTime(2026, 9, 28, 23, 59),
      totalMarks: 25,
      durationMinutes: 35,
      questionIds: [
        'Q011',
        'Q012',
        'Q013',
        'Q014',
        'Q015',
      ],
    ),

    AssignmentModelPart3(
      id: 'ASG004',
      title: 'English Grammar',
      subject: 'English',
      description:
      'Practice grammar, sentence structure and vocabulary.',
      instructor: 'Priya Nair',
      dueDate: DateTime(2026, 10, 1, 23, 59),
      totalMarks: 20,
      durationMinutes: 25,
      questionIds: [
        'Q016',
        'Q017',
        'Q018',
        'Q019',
        'Q020',
      ],
    ),
  ];


  static const List<AssignmentQuestionPart3> questions = [
    // --------------------------------------------------------
    // PHYSICS
    // --------------------------------------------------------

    AssignmentQuestionPart3(
      id: 'Q001',
      assignmentId: 'ASG001',
      question:
      'Which law states that an object remains at rest or in uniform motion unless acted upon by an external force?',
      options: [
        'Newton First Law',
        'Newton Second Law',
        'Newton Third Law',
        'Law of Gravitation',
      ],
      correctAnswer: 0,
      explanation:
      'Newton First Law is also called the law of inertia.',
      marks: 4,
    ),

    AssignmentQuestionPart3(
      id: 'Q002',
      assignmentId: 'ASG001',
      question:
      'What is the SI unit of force?',
      options: [
        'Joule',
        'Newton',
        'Watt',
        'Pascal',
      ],
      correctAnswer: 1,
      explanation:
      'The SI unit of force is the Newton (N).',
      marks: 4,
    ),

    AssignmentQuestionPart3(
      id: 'Q003',
      assignmentId: 'ASG001',
      question:
      'According to Newton Second Law, force is equal to:',
      options: [
        'm / a',
        'm + a',
        'm × a',
        'a / m',
      ],
      correctAnswer: 2,
      explanation:
      'For constant mass, Newton Second Law is F = ma.',
      marks: 4,
    ),

    AssignmentQuestionPart3(
      id: 'Q004',
      assignmentId: 'ASG001',
      question:
      'Newton Third Law states that every action has:',
      options: [
        'No reaction',
        'An equal and opposite reaction',
        'A smaller reaction',
        'A larger reaction',
      ],
      correctAnswer: 1,
      explanation:
      'Newton Third Law states that forces occur in equal and opposite pairs.',
      marks: 4,
    ),

    AssignmentQuestionPart3(
      id: 'Q005',
      assignmentId: 'ASG001',
      question:
      'Which quantity is a vector?',
      options: [
        'Mass',
        'Distance',
        'Speed',
        'Velocity',
      ],
      correctAnswer: 3,
      explanation:
      'Velocity has both magnitude and direction.',
      marks: 4,
    ),

    // --------------------------------------------------------
    // MATHEMATICS
    // --------------------------------------------------------

    AssignmentQuestionPart3(
      id: 'Q006',
      assignmentId: 'ASG002',
      question:
      'What is the integral of x with respect to x?',
      options: [
        'x',
        'x²',
        'x²/2 + C',
        '2x + C',
      ],
      correctAnswer: 2,
      explanation:
      'The integral of x is x²/2 + C.',
      marks: 5,
    ),

    AssignmentQuestionPart3(
      id: 'Q007',
      assignmentId: 'ASG002',
      question:
      'What is the integral of 1/x?',
      options: [
        'x',
        'ln|x| + C',
        '1/x²',
        'x² + C',
      ],
      correctAnswer: 1,
      explanation:
      'The integral of 1/x is ln|x| + C.',
      marks: 5,
    ),

    AssignmentQuestionPart3(
      id: 'Q008',
      assignmentId: 'ASG002',
      question:
      'What is the derivative of x²?',
      options: [
        'x',
        '2x',
        'x²',
        '2',
      ],
      correctAnswer: 1,
      explanation:
      'Using the power rule, d(x²)/dx = 2x.',
      marks: 5,
    ),

    AssignmentQuestionPart3(
      id: 'Q009',
      assignmentId: 'ASG002',
      question:
      'The constant of integration is represented by:',
      options: [
        'A',
        'B',
        'C',
        'C',
      ],
      correctAnswer: 3,
      explanation:
      'C is conventionally used as the arbitrary constant.',
      marks: 5,
    ),

    AssignmentQuestionPart3(
      id: 'Q010',
      assignmentId: 'ASG002',
      question:
      'The derivative represents:',
      options: [
        'Rate of change',
        'Total distance',
        'Area only',
        'Constant value',
      ],
      correctAnswer: 0,
      explanation:
      'The derivative represents the instantaneous rate of change.',
      marks: 5,
    ),

    // --------------------------------------------------------
    // DART
    // --------------------------------------------------------

    AssignmentQuestionPart3(
      id: 'Q011',
      assignmentId: 'ASG003',
      question:
      'Which keyword declares a compile-time constant in Dart?',
      options: [
        'var',
        'final',
        'const',
        'static',
      ],
      correctAnswer: 2,
      explanation:
      'const creates a compile-time constant.',
      marks: 5,
    ),

    AssignmentQuestionPart3(
      id: 'Q012',
      assignmentId: 'ASG003',
      question:
      'Which keyword is used to create a subclass relationship?',
      options: [
        'extends',
        'inherits',
        'implements',
        'superclass',
      ],
      correctAnswer: 0,
      explanation:
      'The extends keyword is used for class inheritance.',
      marks: 5,
    ),

    AssignmentQuestionPart3(
      id: 'Q013',
      assignmentId: 'ASG003',
      question:
      'Which function is normally the entry point of a Dart program?',
      options: [
        'start()',
        'run()',
        'main()',
        'execute()',
      ],
      correctAnswer: 2,
      explanation:
      'The main() function is the standard entry point.',
      marks: 5,
    ),

    AssignmentQuestionPart3(
      id: 'Q014',
      assignmentId: 'ASG003',
      question:
      'Which type stores true or false?',
      options: [
        'String',
        'bool',
        'int',
        'double',
      ],
      correctAnswer: 1,
      explanation:
      'bool represents true or false values.',
      marks: 5,
    ),

    AssignmentQuestionPart3(
      id: 'Q015',
      assignmentId: 'ASG003',
      question:
      'What does a constructor normally do?',
      options: [
        'Deletes an object',
        'Initializes an object',
        'Stops the application',
        'Creates a package',
      ],
      correctAnswer: 1,
      explanation:
      'Constructors initialize objects when they are created.',
      marks: 5,
    ),

    // --------------------------------------------------------
    // ENGLISH
    // --------------------------------------------------------

    AssignmentQuestionPart3(
      id: 'Q016',
      assignmentId: 'ASG004',
      question:
      'Which word is a noun?',
      options: [
        'Beautiful',
        'Quickly',
        'Education',
        'Run',
      ],
      correctAnswer: 2,
      explanation:
      'Education is a noun.',
      marks: 4,
    ),

    AssignmentQuestionPart3(
      id: 'Q017',
      assignmentId: 'ASG004',
      question:
      'Choose the correct sentence.',
      options: [
        'She go to school.',
        'She goes to school.',
        'She going school.',
        'She gone school.',
      ],
      correctAnswer: 1,
      explanation:
      'With "she", the simple present verb is "goes".',
      marks: 4,
    ),

    AssignmentQuestionPart3(
      id: 'Q018',
      assignmentId: 'ASG004',
      question:
      'Which word is an adjective?',
      options: [
        'Quickly',
        'Beautiful',
        'Run',
        'Education',
      ],
      correctAnswer: 1,
      explanation:
      'Beautiful is an adjective.',
      marks: 4,
    ),

    AssignmentQuestionPart3(
      id: 'Q019',
      assignmentId: 'ASG004',
      question:
      'What is the opposite of "ancient"?',
      options: [
        'Old',
        'Modern',
        'Historic',
        'Past',
      ],
      correctAnswer: 1,
      explanation:
      'Modern is the opposite of ancient.',
      marks: 4,
    ),

    AssignmentQuestionPart3(
      id: 'Q020',
      assignmentId: 'ASG004',
      question:
      'Which is a synonym for "rapid"?',
      options: [
        'Slow',
        'Fast',
        'Weak',
        'Late',
      ],
      correctAnswer: 1,
      explanation:
      'Fast is a synonym for rapid.',
      marks: 4,
    ),
  ];


  static AssignmentModelPart3? assignmentById(
      String id,
      ) {
    for (final assignment in assignments) {
      if (assignment.id == id) {
        return assignment;
      }
    }

    return null;
  }


  static AssignmentQuestionPart3? questionById(
      String id,
      ) {
    for (final question in questions) {
      if (question.id == id) {
        return question;
      }
    }

    return null;
  }
}


// ============================================================
// 6. ASSIGNMENT STATE
// ============================================================

class AssignmentStatePart3
    extends ChangeNotifier {
  final Map<String, Map<String, int>>
  answersByAssignment = {};

  final Map<String, AssignmentSubmissionPart3>
  submissions = {};

  String? activeAssignmentId;

  int activeQuestionIndex = 0;


  AssignmentModelPart3? get activeAssignment {
    if (activeAssignmentId == null) {
      return null;
    }

    return AssignmentDatabasePart3
        .assignmentById(
      activeAssignmentId!,
    );
  }


  List<AssignmentQuestionPart3>
  questionsForAssignment(
      String assignmentId,
      ) {
    final assignment =
    AssignmentDatabasePart3.assignmentById(
      assignmentId,
    );

    if (assignment == null) {
      return [];
    }

    return assignment.questionIds
        .map(
      AssignmentDatabasePart3.questionById,
    )
        .whereType<AssignmentQuestionPart3>()
        .toList();
  }


  Map<String, int> answersForAssignment(
      String assignmentId,
      ) {
    return answersByAssignment[
    assignmentId] ??
        {};
  }


  int? answerForQuestion(
      String assignmentId,
      String questionId,
      ) {
    return answersByAssignment[
    assignmentId]?[questionId];
  }


  void startAssignment(
      String assignmentId,
      ) {
    activeAssignmentId =
        assignmentId;

    activeQuestionIndex = 0;

    answersByAssignment.putIfAbsent(
      assignmentId,
          () => <String, int>{},
    );

    notifyListeners();
  }


  void selectAnswer({
    required String assignmentId,
    required String questionId,
    required int answerIndex,
  }) {
    answersByAssignment
        .putIfAbsent(
      assignmentId,
          () => <String, int>{},
    )[questionId] = answerIndex;

    notifyListeners();
  }


  void nextQuestion() {
    final assignment =
        activeAssignment;

    if (assignment == null) {
      return;
    }

    final questions =
    questionsForAssignment(
      assignment.id,
    );

    if (activeQuestionIndex <
        questions.length - 1) {
      activeQuestionIndex++;
      notifyListeners();
    }
  }


  void previousQuestion() {
    if (activeQuestionIndex > 0) {
      activeQuestionIndex--;
      notifyListeners();
    }
  }


  void goToQuestion(int index) {
    final assignment =
        activeAssignment;

    if (assignment == null) {
      return;
    }

    final questions =
    questionsForAssignment(
      assignment.id,
    );

    if (index >= 0 &&
        index < questions.length) {
      activeQuestionIndex = index;
      notifyListeners();
    }
  }


  bool isQuestionAnswered(
      String assignmentId,
      String questionId,
      ) {
    return answersByAssignment[
    assignmentId]
        ?.containsKey(questionId) ??
        false;
  }


  int answeredCount(
      String assignmentId,
      ) {
    return answersByAssignment[
    assignmentId]
        ?.length ??
        0;
  }


  double assignmentProgress(
      String assignmentId,
      ) {
    final questions =
    questionsForAssignment(
      assignmentId,
    );

    if (questions.isEmpty) {
      return 0;
    }

    return answeredCount(
      assignmentId,
    ) /
        questions.length;
  }


  int calculateScore(
      String assignmentId,
      ) {
    final questions =
    questionsForAssignment(
      assignmentId,
    );

    final answers =
    answersForAssignment(
      assignmentId,
    );

    int score = 0;

    for (final question in questions) {
      final selected =
      answers[question.id];

      if (selected != null &&
          selected ==
              question.correctAnswer) {
        score += question.marks;
      }
    }

    return score;
  }


  int totalMarks(
      String assignmentId,
      ) {
    final questions =
    questionsForAssignment(
      assignmentId,
    );

    return questions.fold(
      0,
          (sum, question) =>
      sum + question.marks,
    );
  }


  AssignmentSubmissionPart3 submitAssignment({
    required String assignmentId,
    required String userId,
  }) {
    final score =
    calculateScore(
      assignmentId,
    );

    final total =
    totalMarks(
      assignmentId,
    );

    final answers =
    Map<String, int>.from(
      answersForAssignment(
        assignmentId,
      ),
    );

    final submission =
    AssignmentSubmissionPart3(
      id:
      'SUB${DateTime.now().microsecondsSinceEpoch}',
      assignmentId:
      assignmentId,
      userId:
      userId,
      answers:
      answers,
      score:
      score,
      totalMarks:
      total,
      submittedAt:
      DateTime.now(),
    );

    submissions[assignmentId] =
        submission;

    notifyListeners();

    return submission;
  }


  bool isSubmitted(
      String assignmentId,
      ) {
    return submissions
        .containsKey(assignmentId);
  }


  AssignmentStatusPart3 statusForAssignment(
      AssignmentModelPart3 assignment,
      ) {
    if (isSubmitted(
      assignment.id,
    )) {
      return AssignmentStatusPart3
          .submitted;
    }

    final now = DateTime.now();

    if (now.isAfter(
      assignment.dueDate,
    )) {
      return AssignmentStatusPart3
          .overdue;
    }

    if (answeredCount(
      assignment.id,
    ) >
        0) {
      return AssignmentStatusPart3
          .inProgress;
    }

    return AssignmentStatusPart3
        .upcoming;
  }


  void resetAssignment(
      String assignmentId,
      ) {
    answersByAssignment
        .remove(assignmentId);

    submissions
        .remove(assignmentId);

    activeAssignmentId = null;

    activeQuestionIndex = 0;

    notifyListeners();
  }
}


// ============================================================
// 7. ASSIGNMENT HOME SCREEN
// ============================================================

class AssignmentHomeScreenPart3
    extends StatefulWidget {
  final AppState appState;

  const AssignmentHomeScreenPart3({
    super.key,
    required this.appState,
  });

  @override
  State<AssignmentHomeScreenPart3>
  createState() =>
      _AssignmentHomeScreenPart3State();
}


class _AssignmentHomeScreenPart3State
    extends State<
        AssignmentHomeScreenPart3> {
  late final AssignmentStatePart3
  assignmentState;


  @override
  void initState() {
    super.initState();

    assignmentState =
        AssignmentStatePart3();
  }


  @override
  void dispose() {
    assignmentState.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: assignmentState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor:
          AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _AssignmentHeader(
                    appState:
                    widget.appState,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  _AssignmentStatistics(
                    state:
                    assignmentState,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  const _AssignmentSectionTitle(
                    title:
                    'My Assignments',
                    subtitle:
                    'Complete your pending coursework',
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  _AssignmentListPart3(
                    state:
                    assignmentState,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


// ============================================================
// 8. ASSIGNMENT HEADER
// ============================================================

class _AssignmentHeader
    extends StatelessWidget {
  final AppState appState;

  const _AssignmentHeader({
    required this.appState,
  });


  @override
  Widget build(BuildContext context) {
    final name =
        appState.currentUser?.name ??
            'Student';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Assignments',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  AppColors.text,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                'Hello $name, keep your learning on track.',
                style:
                const TextStyle(
                  color:
                  AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),

        CircleAvatar(
          radius: 25,
          backgroundColor:
          AppColors.blue.withOpacity(.10),
          child: const Icon(
            Icons.assignment_rounded,
            color:
            AppColors.blue,
          ),
        ),
      ],
    );
  }
}


// ============================================================
// 9. ASSIGNMENT STATISTICS
// ============================================================

class _AssignmentStatistics
    extends StatelessWidget {
  final AssignmentStatePart3 state;

  const _AssignmentStatistics({
    required this.state,
  });


  @override
  Widget build(BuildContext context) {
    int pending = 0;
    int submitted = 0;
    int overdue = 0;

    for (final assignment
    in AssignmentDatabasePart3
        .assignments) {
      switch (
      state.statusForAssignment(
        assignment,
      )) {
        case AssignmentStatusPart3
            .upcoming:
        case AssignmentStatusPart3
            .inProgress:
          pending++;
          break;

        case AssignmentStatusPart3
            .submitted:
          submitted++;
          break;

        case AssignmentStatusPart3
            .overdue:
          overdue++;
          break;
      }
    }

    return LayoutBuilder(
      builder:
          (context, constraints) {
        final columns =
        constraints.maxWidth >
            850
            ? 3
            : 1;

        return GridView.count(
          crossAxisCount:
          columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          childAspectRatio:
          columns == 1
              ? 4.2
              : 2.2,
          children: [
            _AssignmentStatCard(
              title:
              'Pending',
              value:
              pending.toString(),
              icon:
              Icons.pending_actions_rounded,
              color:
              AppColors.orange,
            ),

            _AssignmentStatCard(
              title:
              'Submitted',
              value:
              submitted.toString(),
              icon:
              Icons.check_circle_rounded,
              color:
              AppColors.green,
            ),

            _AssignmentStatCard(
              title:
              'Overdue',
              value:
              overdue.toString(),
              icon:
              Icons.warning_rounded,
              color:
              AppColors.red,
            ),
          ],
        );
      },
    );
  }
}


// ============================================================
// 10. STAT CARD
// ============================================================

class _AssignmentStatCard
    extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AssignmentStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
        side:
        const BorderSide(
          color:
          AppColors.border,
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration:
              BoxDecoration(
                color:
                color.withOpacity(.10),
                borderRadius:
                BorderRadius.circular(
                  14,
                ),
              ),
              child: Icon(
                icon,
                color:
                color,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style:
                  const TextStyle(
                    fontSize: 22,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style:
                  const TextStyle(
                    color:
                    AppColors.secondaryText,
                    fontSize: 12,
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
// 11. SECTION TITLE
// ============================================================

class _AssignmentSectionTitle
    extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AssignmentSectionTitle({
    required this.title,
    required this.subtitle,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
          const TextStyle(
            fontSize: 22,
            fontWeight:
            FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          subtitle,
          style:
          const TextStyle(
            color:
            AppColors.secondaryText,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}


// ============================================================
// 12. ASSIGNMENT LIST
// ============================================================

class _AssignmentListPart3
    extends StatelessWidget {
  final AssignmentStatePart3 state;

  const _AssignmentListPart3({
    required this.state,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children:
      AssignmentDatabasePart3
          .assignments
          .map(
            (assignment) =>
            _AssignmentCardPart3(
              assignment:
              assignment,
              state:
              state,
            ),
      )
          .toList(),
    );
  }
}


// ============================================================
// 13. ASSIGNMENT CARD
// ============================================================

class _AssignmentCardPart3
    extends StatelessWidget {
  final AssignmentModelPart3 assignment;
  final AssignmentStatePart3 state;

  const _AssignmentCardPart3({
    required this.assignment,
    required this.state,
  });


  @override
  Widget build(BuildContext context) {
    final status =
    state.statusForAssignment(
      assignment,
    );

    final progress =
    state.assignmentProgress(
      assignment.id,
    );

    return Card(
      elevation: 0,
      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),
      color: Colors.white,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),
        side:
        const BorderSide(
          color:
          AppColors.border,
        ),
      ),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AssignmentDetailsScreenPart3(
                    assignment:
                    assignment,
                    state:
                    state,
                  ),
            ),
          );
        },
        child: Padding(
          padding:
          const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration:
                    BoxDecoration(
                      color:
                      AppColors.blue
                          .withOpacity(
                        .10,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        15,
                      ),
                    ),
                    child:
                    const Icon(
                      Icons.assignment_rounded,
                      color:
                      AppColors.blue,
                    ),
                  ),

                  const SizedBox(
                    width: 14,
                  ),

                  Expanded(
                    child:
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          assignment
                              .title,
                          style:
                          const TextStyle(
                            fontSize:
                            17,
                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          assignment
                              .subject,
                          style:
                          const TextStyle(
                            color:
                            AppColors
                                .secondaryText,
                            fontSize:
                            12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _AssignmentStatusBadge(
                    status:
                    status,
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              Text(
                assignment.description,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style:
                const TextStyle(
                  color:
                  AppColors.secondaryText,
                  height: 1.4,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              Wrap(
                spacing: 18,
                runSpacing: 8,
                children: [
                  _AssignmentMeta(
                    icon:
                    Icons.quiz_outlined,
                    text:
                    '${assignment.questionCount} questions',
                  ),
                  _AssignmentMeta(
                    icon:
                    Icons.timer_outlined,
                    text:
                    '${assignment.durationMinutes} min',
                  ),
                  _AssignmentMeta(
                    icon:
                    Icons.calendar_today_outlined,
                    text:
                    _formatAssignmentDate(
                      assignment.dueDate,
                    ),
                  ),
                ],
              ),

              if (status ==
                  AssignmentStatusPart3
                      .inProgress &&
                  progress > 0) ...[
                const SizedBox(
                  height: 16,
                ),

                LinearProgressIndicator(
                  value:
                  progress,
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  '${(progress * 100).round()}% answered',
                  style:
                  const TextStyle(
                    fontSize:
                    11,
                    color:
                    AppColors.secondaryText,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// 14. STATUS BADGE
// ============================================================

class _AssignmentStatusBadge
    extends StatelessWidget {
  final AssignmentStatusPart3 status;

  const _AssignmentStatusBadge({
    required this.status,
  });


  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case AssignmentStatusPart3
          .upcoming:
        color = AppColors.blue;
        text = 'Upcoming';
        break;

      case AssignmentStatusPart3
          .inProgress:
        color = AppColors.orange;
        text = 'In Progress';
        break;

      case AssignmentStatusPart3
          .submitted:
        color = AppColors.green;
        text = 'Submitted';
        break;

      case AssignmentStatusPart3
          .overdue:
        color = AppColors.red;
        text = 'Overdue';
        break;
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration:
      BoxDecoration(
        color:
        color.withOpacity(.10),
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style:
        TextStyle(
          color:
          color,
          fontSize: 11,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }
}


// ============================================================
// 15. ASSIGNMENT META
// ============================================================

class _AssignmentMeta
    extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AssignmentMeta({
    required this.icon,
    required this.text,
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize:
      MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color:
          AppColors.secondaryText,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style:
          const TextStyle(
            color:
            AppColors.secondaryText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


// ============================================================
// 16. ASSIGNMENT DETAILS SCREEN
// ============================================================

class AssignmentDetailsScreenPart3
    extends StatelessWidget {
  final AssignmentModelPart3 assignment;
  final AssignmentStatePart3 state;

  const AssignmentDetailsScreenPart3({
    super.key,
    required this.assignment,
    required this.state,
  });


  @override
  Widget build(BuildContext context) {
    final status =
    state.statusForAssignment(
      assignment,
    );

    final submission =
    state.submissions[
    assignment.id];

    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
          'Assignment Details',
        ),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints:
            const BoxConstraints(
              maxWidth: 1000,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _AssignmentHero(
                  assignment:
                  assignment,
                  status:
                  status,
                ),

                const SizedBox(
                  height: 28,
                ),

                const Text(
                  'Description',
                  style:
                  TextStyle(
                    fontSize: 22,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  assignment.description,
                  style:
                  const TextStyle(
                    color:
                    AppColors.secondaryText,
                    height: 1.6,
                  ),
                ),

                const SizedBox(
                  height: 28,
                ),

                _AssignmentInformation(
                  assignment:
                  assignment,
                ),

                const SizedBox(
                  height: 28,
                ),

                if (submission != null)
                  _SubmissionSummary(
                    submission:
                    submission,
                  ),

                const SizedBox(
                  height: 24,
                ),

                SizedBox(
                  width:
                  double.infinity,
                  height: 54,
                  child:
                  FilledButton.icon(
                    onPressed:
                    status ==
                        AssignmentStatusPart3
                            .submitted
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AssignmentResultScreenPart3(
                                assignment:
                                assignment,
                                submission:
                                submission!,
                                state:
                                state,
                              ),
                        ),
                      );
                    }
                        : () {
                      state.startAssignment(
                        assignment.id,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AssignmentQuizScreenPart3(
                                assignment:
                                assignment,
                                state:
                                state,
                              ),
                        ),
                      );
                    },
                    icon: Icon(
                      status ==
                          AssignmentStatusPart3
                              .submitted
                          ? Icons
                          .assessment_rounded
                          : Icons
                          .play_arrow_rounded,
                    ),
                    label: Text(
                      status ==
                          AssignmentStatusPart3
                              .submitted
                          ? 'View Result'
                          : 'Start Assignment',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ============================================================
// 17. ASSIGNMENT HERO
// ============================================================

class _AssignmentHero
    extends StatelessWidget {
  final AssignmentModelPart3 assignment;
  final AssignmentStatusPart3 status;

  const _AssignmentHero({
    required this.assignment,
    required this.status,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color:
      AppColors.navy,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(24),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.assignment_rounded,
              size: 55,
              color:
              Colors.white,
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              assignment.title,
              style:
              const TextStyle(
                color:
                Colors.white,
                fontSize: 28,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              assignment.subject,
              style:
              const TextStyle(
                color:
                Colors.white70,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                _WhiteMeta(
                  icon:
                  Icons.person_outline,
                  text:
                  assignment.instructor,
                ),
                _WhiteMeta(
                  icon:
                  Icons.quiz_outlined,
                  text:
                  '${assignment.questionCount} questions',
                ),
                _WhiteMeta(
                  icon:
                  Icons.timer_outlined,
                  text:
                  '${assignment.durationMinutes} minutes',
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
// 18. WHITE META
// ============================================================

class _WhiteMeta
    extends StatelessWidget {
  final IconData icon;
  final String text;

  const _WhiteMeta({
    required this.icon,
    required this.text,
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize:
      MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 17,
          color:
          Colors.white70,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          text,
          style:
          const TextStyle(
            color:
            Colors.white70,
            fontSize:
            12,
          ),
        ),
      ],
    );
  }
}


// ============================================================
// 19. ASSIGNMENT INFORMATION
// ============================================================

class _AssignmentInformation
    extends StatelessWidget {
  final AssignmentModelPart3 assignment;

  const _AssignmentInformation({
    required this.assignment,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          children: [
            _InfoRowPart3(
              label:
              'Subject',
              value:
              assignment.subject,
            ),
            _InfoRowPart3(
              label:
              'Instructor',
              value:
              assignment.instructor,
            ),
            _InfoRowPart3(
              label:
              'Questions',
              value:
              assignment.questionCount
                  .toString(),
            ),
            _InfoRowPart3(
              label:
              'Total Marks',
              value:
              assignment.totalMarks
                  .toString(),
            ),
            _InfoRowPart3(
              label:
              'Duration',
              value:
              '${assignment.durationMinutes} minutes',
            ),
            _InfoRowPart3(
              label:
              'Due Date',
              value:
              _formatAssignmentDate(
                assignment.dueDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// 20. INFO ROW
// ============================================================

class _InfoRowPart3
    extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRowPart3({
    required this.label,
    required this.value,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style:
              const TextStyle(
                color:
                AppColors.secondaryText,
              ),
            ),
          ),
          Text(
            value,
            style:
            const TextStyle(
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// 21. QUIZ SCREEN
// ============================================================

class AssignmentQuizScreenPart3
    extends StatefulWidget {
  final AssignmentModelPart3 assignment;
  final AssignmentStatePart3 state;

  const AssignmentQuizScreenPart3({
    super.key,
    required this.assignment,
    required this.state,
  });

  @override
  State<AssignmentQuizScreenPart3>
  createState() =>
      _AssignmentQuizScreenPart3State();
}


class _AssignmentQuizScreenPart3State
    extends State<
        AssignmentQuizScreenPart3> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, _) {
        final questions =
        widget.state
            .questionsForAssignment(
          widget.assignment.id,
        );

        if (questions.isEmpty) {
          return const Scaffold(
            body: Center(
              child:
              Text(
                'No questions available.',
              ),
            ),
          );
        }

        final index =
            widget.state.activeQuestionIndex;

        final question =
        questions[index];

        final selected =
        widget.state.answerForQuestion(
          widget.assignment.id,
          question.id,
        );

        final answered =
        widget.state.answeredCount(
          widget.assignment.id,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.assignment.title,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Question ${index + 1} of ${questions.length}',
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$answered/${questions.length} answered',
                            style:
                            const TextStyle(
                              color:
                              AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      LinearProgressIndicator(
                        value:
                        (index + 1) /
                            questions.length,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child:
                  SingleChildScrollView(
                    padding:
                    const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      20,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                        const BoxConstraints(
                          maxWidth: 850,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              question.question,
                              style:
                              const TextStyle(
                                fontSize:
                                24,
                                fontWeight:
                                FontWeight
                                    .bold,
                                height:
                                1.4,
                              ),
                            ),

                            const SizedBox(
                              height: 28,
                            ),

                            ...List.generate(
                              question.options
                                  .length,
                                  (optionIndex) {
                                final isSelected =
                                    selected ==
                                        optionIndex;

                                return _AnswerOption(
                                  index:
                                  optionIndex,
                                  text:
                                  question
                                      .options[
                                  optionIndex],
                                  selected:
                                  isSelected,
                                  onTap:
                                      () {
                                    widget.state
                                        .selectAnswer(
                                      assignmentId:
                                      widget
                                          .assignment
                                          .id,
                                      questionId:
                                      question
                                          .id,
                                      answerIndex:
                                      optionIndex,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                _QuizBottomBar(
                  state:
                  widget.state,
                  assignment:
                  widget.assignment,
                  questions:
                  questions,
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
// 22. ANSWER OPTION
// ============================================================

class _AnswerOption
    extends StatelessWidget {
  final int index;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.index,
    required this.text,
    required this.selected,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    final letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
    ];

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),
      child: Material(
        color: selected
            ? AppColors.blue.withOpacity(.08)
            : Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        child: InkWell(
          borderRadius:
          BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding:
            const EdgeInsets.all(16),
            decoration:
            BoxDecoration(
              borderRadius:
              BorderRadius.circular(16),
              border:
              Border.all(
                color: selected
                    ? AppColors.blue
                    : AppColors.border,
                width:
                selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment:
                  Alignment.center,
                  decoration:
                  BoxDecoration(
                    color: selected
                        ? AppColors.blue
                        : AppColors.background,
                    shape:
                    BoxShape.circle,
                  ),
                  child: Text(
                    letters[index],
                    style:
                    TextStyle(
                      color: selected
                          ? Colors.white
                          : AppColors.text,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 14,
                ),

                Expanded(
                  child: Text(
                    text,
                    style:
                    const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),

                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color:
                    AppColors.blue,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ============================================================
// 23. QUIZ BOTTOM BAR
// ============================================================

class _QuizBottomBar
    extends StatelessWidget {
  final AssignmentStatePart3 state;
  final AssignmentModelPart3 assignment;
  final List<AssignmentQuestionPart3>
  questions;

  const _QuizBottomBar({
    required this.state,
    required this.assignment,
    required this.questions,
  });


  @override
  Widget build(BuildContext context) {
    final isLast =
        state.activeQuestionIndex ==
            questions.length - 1;

    final isFirst =
        state.activeQuestionIndex == 0;

    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration:
      BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color:
            Colors.black.withOpacity(.08),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            OutlinedButton.icon(
              onPressed: isFirst
                  ? null
                  : state.previousQuestion,
              icon:
              const Icon(
                Icons.arrow_back_rounded,
              ),
              label:
              const Text('Previous'),
            ),

            const Spacer(),

            if (!isLast)
              FilledButton.icon(
                onPressed:
                state.nextQuestion,
                icon:
                const Icon(
                  Icons.arrow_forward_rounded,
                ),
                label:
                const Text('Next'),
              )
            else
              FilledButton.icon(
                style:
                FilledButton.styleFrom(
                  backgroundColor:
                  AppColors.green,
                ),
                onPressed: () {
                  _confirmSubmit(
                    context,
                  );
                },
                icon:
                const Icon(
                  Icons.send_rounded,
                ),
                label:
                const Text(
                  'Submit',
                ),
              ),
          ],
        ),
      ),
    );
  }


  void _confirmSubmit(
      BuildContext context,
      ) {
    final unanswered =
        questions.length -
            state.answeredCount(
              assignment.id,
            );

    showDialog(
      context: context,
      builder:
          (dialogContext) {
        return AlertDialog(
          title:
          const Text(
            'Submit Assignment?',
          ),
          content:
          Text(
            unanswered == 0
                ? 'You have answered all questions. Submit your assignment?'
                : 'You still have $unanswered unanswered question(s). Submit anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
              const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                final submission =
                state.submitAssignment(
                  assignmentId:
                  assignment.id,
                  userId:
                  'USR001',
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AssignmentResultScreenPart3(
                          assignment:
                          assignment,
                          submission:
                          submission,
                          state:
                          state,
                        ),
                  ),
                );
              },
              child:
              const Text(
                'Submit',
              ),
            ),
          ],
        );
      },
    );
  }
}


// ============================================================
// 24. RESULT SCREEN
// ============================================================

class AssignmentResultScreenPart3
    extends StatelessWidget {
  final AssignmentModelPart3 assignment;
  final AssignmentSubmissionPart3 submission;
  final AssignmentStatePart3 state;

  const AssignmentResultScreenPart3({
    super.key,
    required this.assignment,
    required this.submission,
    required this.state,
  });


  @override
  Widget build(BuildContext context) {
    final percentage =
        submission.percentage;

    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
          'Assignment Result',
        ),
        automaticallyImplyLeading:
        false,
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints:
            const BoxConstraints(
              maxWidth: 800,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),

                Container(
                  width: 130,
                  height: 130,
                  decoration:
                  BoxDecoration(
                    color:
                    AppColors.green
                        .withOpacity(
                      .10,
                    ),
                    shape:
                    BoxShape.circle,
                  ),
                  child:
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 80,
                    color:
                    AppColors.green,
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Assignment Submitted!',
                  textAlign:
                  TextAlign.center,
                  style:
                  TextStyle(
                    fontSize: 28,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  assignment.title,
                  textAlign:
                  TextAlign.center,
                  style:
                  const TextStyle(
                    color:
                    AppColors.secondaryText,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                Card(
                  elevation: 0,
                  color:
                  AppColors.navy,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),
                  ),
                  child:
                  Padding(
                    padding:
                    const EdgeInsets.all(
                      30,
                    ),
                    child:
                    Row(
                      children: [
                        Expanded(
                          child:
                          _ResultMetric(
                            value:
                            '${submission.score}',
                            label:
                            'Score',
                          ),
                        ),
                        Expanded(
                          child:
                          _ResultMetric(
                            value:
                            '${submission.totalMarks}',
                            label:
                            'Total',
                          ),
                        ),
                        Expanded(
                          child:
                          _ResultMetric(
                            value:
                            '${(percentage * 100).round()}%',
                            label:
                            'Percentage',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                SizedBox(
                  width:
                  double.infinity,
                  height: 52,
                  child:
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AssignmentReviewScreenPart3(
                                assignment:
                                assignment,
                                submission:
                                submission,
                                state:
                                state,
                              ),
                        ),
                      );
                    },
                    icon:
                    const Icon(
                      Icons.rate_review_rounded,
                    ),
                    label:
                    const Text(
                      'Review Answers',
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                SizedBox(
                  width:
                  double.infinity,
                  height: 52,
                  child:
                  OutlinedButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                            (route) =>
                        route.isFirst,
                      );
                    },
                    child:
                    const Text(
                      'Back to Assignments',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ============================================================
// 25. RESULT METRIC
// ============================================================

class _ResultMetric
    extends StatelessWidget {
  final String value;
  final String label;

  const _ResultMetric({
    required this.value,
    required this.label,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style:
          const TextStyle(
            color:
            Colors.white,
            fontSize: 28,
            fontWeight:
            FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label,
          style:
          const TextStyle(
            color:
            Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


// ============================================================
// 26. SUBMISSION SUMMARY
// ============================================================

class _SubmissionSummary
    extends StatelessWidget {
  final AssignmentSubmissionPart3
  submission;

  const _SubmissionSummary({
    required this.submission,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color:
      AppColors.green.withOpacity(.06),
      child:
      Padding(
        padding:
        const EdgeInsets.all(20),
        child:
        Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color:
              AppColors.green,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child:
              Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  const Text(
                    'Already Submitted',
                    style:
                    TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Score: ${submission.score}/${submission.totalMarks} (${(submission.percentage * 100).round()}%)',
                    style:
                    const TextStyle(
                      color:
                      AppColors.secondaryText,
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
// 27. REVIEW SCREEN
// ============================================================

class AssignmentReviewScreenPart3
    extends StatelessWidget {
  final AssignmentModelPart3 assignment;
  final AssignmentSubmissionPart3 submission;
  final AssignmentStatePart3 state;

  const AssignmentReviewScreenPart3({
    super.key,
    required this.assignment,
    required this.submission,
    required this.state,
  });


  @override
  Widget build(BuildContext context) {
    final questions =
    state.questionsForAssignment(
      assignment.id,
    );

    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
          'Review Answers',
        ),
      ),
      body: ListView.builder(
        padding:
        const EdgeInsets.all(20),
        itemCount:
        questions.length,
        itemBuilder:
            (context, index) {
          final question =
          questions[index];

          final selected =
          submission.answers[
          question.id];

          final correct =
              selected ==
                  question.correctAnswer;

          return Card(
            elevation: 0,
            margin:
            const EdgeInsets.only(
              bottom: 16,
            ),
            child:
            Padding(
              padding:
              const EdgeInsets.all(
                20,
              ),
              child:
              Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                        correct
                            ? AppColors
                            .green
                            .withOpacity(
                          .10,
                        )
                            : AppColors
                            .red
                            .withOpacity(
                          .10,
                        ),
                        child:
                        Icon(
                          correct
                              ? Icons
                              .check
                              : Icons
                              .close,
                          size: 18,
                          color:
                          correct
                              ? AppColors
                              .green
                              : AppColors
                              .red,
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child:
                        Text(
                          'Question ${index + 1}',
                          style:
                          const TextStyle(
                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  Text(
                    question.question,
                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  if (selected != null)
                    Text(
                      'Your answer: ${question.options[selected]}',
                      style:
                      TextStyle(
                        color:
                        correct
                            ? AppColors
                            .green
                            : AppColors
                            .red,
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    )
                  else
                    const Text(
                      'Not answered',
                      style:
                      TextStyle(
                        color:
                        AppColors.red,
                      ),
                    ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'Correct answer: ${question.options[question.correctAnswer]}',
                    style:
                    const TextStyle(
                      color:
                      AppColors.green,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Container(
                    width:
                    double.infinity,
                    padding:
                    const EdgeInsets
                        .all(
                      14,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      AppColors
                          .background,
                      borderRadius:
                      BorderRadius
                          .circular(
                        12,
                      ),
                    ),
                    child:
                    Text(
                      question
                          .explanation,
                      style:
                      const TextStyle(
                        color:
                        AppColors
                            .secondaryText,
                        height:
                        1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// ============================================================
// 28. ASSIGNMENT HISTORY SCREEN
// ============================================================

class AssignmentHistoryScreenPart3
    extends StatelessWidget {
  final AssignmentStatePart3 state;

  const AssignmentHistoryScreenPart3({
    super.key,
    required this.state,
  });


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final submissions =
        state.submissions.values
            .toList();

        return Scaffold(
          appBar: AppBar(
            title:
            const Text(
              'Assignment History',
            ),
          ),
          body: submissions.isEmpty
              ? const Center(
            child:
            Padding(
              padding:
              EdgeInsets.all(
                30,
              ),
              child:
              Column(
                mainAxisAlignment:
                MainAxisAlignment
                    .center,
                children: [
                  Icon(
                    Icons
                        .history_rounded,
                    size: 65,
                    color:
                    AppColors
                        .secondaryText,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'No submissions yet',
                    style:
                    TextStyle(
                      fontSize:
                      20,
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  ),
                ],
              ),
            ),
          )
              : ListView.builder(
            padding:
            const EdgeInsets
                .all(
              20,
            ),
            itemCount:
            submissions.length,
            itemBuilder:
                (context, index) {
              final submission =
              submissions[
              index];

              final assignment =
              AssignmentDatabasePart3
                  .assignmentById(
                submission
                    .assignmentId,
              );

              if (assignment ==
                  null) {
                return const SizedBox
                    .shrink();
              }

              return Card(
                elevation: 0,
                margin:
                const EdgeInsets
                    .only(
                  bottom: 12,
                ),
                child:
                ListTile(
                  leading:
                  const CircleAvatar(
                    backgroundColor:
                    Color(
                      0xFFEFFAF1,
                    ),
                    child:
                    Icon(
                      Icons
                          .check_circle_rounded,
                      color:
                      AppColors
                          .green,
                    ),
                  ),
                  title:
                  Text(
                    assignment
                        .title,
                  ),
                  subtitle:
                  Text(
                    'Score: ${submission.score}/${submission.totalMarks}',
                  ),
                  trailing:
                  Text(
                    '${(submission.percentage * 100).round()}%',
                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight
                          .bold,
                      color:
                      AppColors
                          .green,
                    ),
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
// 29. DATE FORMATTER
// ============================================================

String _formatAssignmentDate(
    DateTime date,
    ) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}