import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// void main() {
//   runApp(const EduSphereApp());
// }

// ============================================================
// APP
// ============================================================

class EduSphereApp extends StatelessWidget {
  const EduSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduSphere',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const StudentDashboard(),
    );
  }
}

// ============================================================
// STUDENT MODEL
// ============================================================

class Student {
  final int id;
  final String name;
  final String email;
  final String course;
  final String subject;
  final int marks;
  final int attendance;
  final String grade;
  final String status;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.course,
    required this.subject,
    required this.marks,
    required this.attendance,
    required this.grade,
    required this.status,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      course: json['course'] ?? '',
      subject: json['subject'] ?? '',
      marks: json['marks'] ?? 0,
      attendance: json['attendance'] ?? 0,
      grade: json['grade'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

// ============================================================
// API SERVICE
// ============================================================

// Physical phone example:
// static const String baseUrl =
//     'http://192.168.1.10:8000';
class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  //'http://10.0.2.2:8000';

  static Future<List<Student>> getStudents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/test'),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'HTTP ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final List<dynamic> students = data['students'];

    return students.map((item) => Student.fromJson(item)).toList();
  }
}
// ============================================================
// DASHBOARD
// ============================================================

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  List<Student> students = [];

  List<Student> filteredStudents = [];

  bool loading = true;

  String? error;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadStudents();

    searchController.addListener(
      filterStudents,
    );
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  // ==========================================================
  // LOAD API DATA
  // ==========================================================

  Future<void> loadStudents() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final result = await ApiService.getStudents();

      setState(() {
        students = result;

        filteredStudents = result;

        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();

        loading = false;
      });
    }
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  void filterStudents() {
    final query = searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredStudents = List.from(students);
      } else {
        filteredStudents = students.where((student) {
          return student.name.toLowerCase().contains(query) ||
              student.email.toLowerCase().contains(query) ||
              student.course.toLowerCase().contains(query) ||
              student.subject.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EduSphere Students',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: loadStudents,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? buildError()
              : buildContent(),
    );
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  Widget buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 70,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to connect to Python',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              error ?? '',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: loadStudents,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CONTENT
  // ==========================================================

  Widget buildContent() {
    return RefreshIndicator(
      onRefresh: loadStudents,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: buildSummary(),
          ),
          SliverToBoxAdapter(
            child: buildSearch(),
          ),
          if (filteredStudents.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No students found',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                24,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final student = filteredStudents[index];

                    return StudentCard(
                      student: student,
                    );
                  },
                  childCount: filteredStudents.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // SUMMARY
  // ==========================================================

  Widget buildSummary() {
    final active = students
        .where(
          (s) => s.status == 'Active',
        )
        .length;

    final warning = students
        .where(
          (s) => s.status == 'Warning',
        )
        .length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${students.length} students loaded from FastAPI',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Students',
                  value: '${students.length}',
                  icon: Icons.people,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  title: 'Active',
                  value: '$active',
                  icon: Icons.check_circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  title: 'Warning',
                  value: '$warning',
                  icon: Icons.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  Widget buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search students...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SUMMARY CARD
// ============================================================

class SummaryCard extends StatelessWidget {
  final String title;

  final String value;

  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 28,
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STUDENT CARD
// ============================================================

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  child: Text(
                    student.name.isNotEmpty ? student.name[0] : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        student.email,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(
                  status: student.status,
                ),
              ],
            ),
            const Divider(height: 28),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'Course',
                    value: student.course,
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Subject',
                    value: student.subject,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'Marks',
                    value: '${student.marks}%',
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Attendance',
                    value: '${student.attendance}%',
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Grade',
                    value: student.grade,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: student.marks / 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INFO ITEM
// ============================================================

class _InfoItem extends StatelessWidget {
  final String label;

  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// STATUS BADGE
// ============================================================

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = status == 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: active ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: active ? Colors.green.shade700 : Colors.orange.shade700,
        ),
      ),
    );
  }
}
