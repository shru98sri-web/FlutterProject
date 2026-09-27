import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const EduSphereApp());
}

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
      ),
      home: const StudentPage(),
    );
  }
}

// ============================================================
// STUDENT MODEL
// ============================================================

class Student {
  int id;
  String name;
  String email;
  String course;
  String subject;
  int marks;
  int attendance;
  String grade;
  String status;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'course': course,
      'subject': subject,
      'marks': marks,
      'attendance': attendance,
      'grade': grade,
      'status': status,
    };
  }
}

// ============================================================
// API SERVICE
// ============================================================

class ApiService {
  // Flutter Web / Chrome
  static const String baseUrl = 'http://127.0.0.1:8000';

  // ==========================================================
  // GET ALL
  // ==========================================================

  static Future<List<Student>> getStudents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/test'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List studentsJson = data['students'];

      return studentsJson
          .map(
            (json) => Student.fromJson(json),
          )
          .toList();
    }

    throw Exception(
      'GET failed: ${response.statusCode}',
    );
  }

  // ==========================================================
  // POST
  // ==========================================================

  static Future<Student> createStudent(
    Student student,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/test'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        student.toJson(),
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Student.fromJson(
        data['student'],
      );
    }

    throw Exception(
      data['message'] ?? 'POST failed: ${response.statusCode}',
    );
  }

  // ==========================================================
  // PUT / UPDATE
  // ==========================================================

  static Future<Student> updateStudent(
    int id,
    Student student,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/test/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        student.toJson(),
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Student.fromJson(
        data['student'],
      );
    }

    throw Exception(
      data['message'] ?? 'PUT failed: ${response.statusCode}',
    );
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  static Future<void> deleteStudent(
    int id,
  ) async {
    final response = await http.delete(
      Uri.parse(
        '$baseUrl/api/test/$id',
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ?? 'DELETE failed: ${response.statusCode}',
      );
    }
  }
}

// ============================================================
// STUDENT PAGE
// ============================================================

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<Student> students = [];

  bool loading = false;

  String searchText = '';

  @override
  void initState() {
    super.initState();

    loadStudents();
  }

  // ==========================================================
  // LOAD
  // ==========================================================

  Future<void> loadStudents() async {
    setState(() {
      loading = true;
    });

    try {
      final result = await ApiService.getStudents();

      setState(() {
        students = result;
      });
    } catch (e) {
      showError(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // ==========================================================
  // POST - ADD
  // ==========================================================

  Future<void> addStudent() async {
    final student = await showStudentForm();

    if (student == null) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      await ApiService.createStudent(
        student,
      );

      await loadStudents();

      showSuccess(
        'Student added successfully',
      );
    } catch (e) {
      showError(e.toString());
    }
  }

  // ==========================================================
  // PUT - UPDATE
  // ==========================================================

  Future<void> updateStudent(
    Student student,
  ) async {
    final updatedStudent = await showStudentForm(
      student: student,
    );

    if (updatedStudent == null) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      await ApiService.updateStudent(
        student.id,
        updatedStudent,
      );

      await loadStudents();

      showSuccess(
        'Student updated successfully',
      );
    } catch (e) {
      showError(e.toString());
    }
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  Future<void> deleteStudent(
    Student student,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Student',
          ),
          content: Text(
            'Are you sure you want to delete '
            '${student.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      await ApiService.deleteStudent(
        student.id,
      );

      await loadStudents();

      showSuccess(
        'Student deleted successfully',
      );
    } catch (e) {
      showError(e.toString());
    }
  }

  // ==========================================================
  // FORM
  // ==========================================================

  Future<Student?> showStudentForm({
    Student? student,
  }) async {
    final bool editing = student != null;

    final idController = TextEditingController(
      text: student?.id.toString() ?? '',
    );

    final nameController = TextEditingController(
      text: student?.name ?? '',
    );

    final emailController = TextEditingController(
      text: student?.email ?? '',
    );

    final courseController = TextEditingController(
      text: student?.course ?? '',
    );

    final subjectController = TextEditingController(
      text: student?.subject ?? '',
    );

    final marksController = TextEditingController(
      text: student?.marks.toString() ?? '',
    );

    final attendanceController = TextEditingController(
      text: student?.attendance.toString() ?? '',
    );

    final gradeController = TextEditingController(
      text: student?.grade ?? '',
    );

    final statusController = TextEditingController(
      text: student?.status ?? 'Active',
    );

    return showDialog<Student?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            editing ? 'Update Student' : 'Add Student',
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: idController,
                    enabled: !editing,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: marksController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Marks',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: attendanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Attendance',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: gradeController,
                    decoration: const InputDecoration(
                      labelText: 'Grade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: statusController,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  null,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                final id = int.tryParse(
                  idController.text,
                );

                final marks = int.tryParse(
                  marksController.text,
                );

                final attendance = int.tryParse(
                  attendanceController.text,
                );

                if (id == null ||
                    nameController.text.trim().isEmpty ||
                    emailController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'ID, Name and Email are required',
                      ),
                    ),
                  );

                  return;
                }

                final result = Student(
                  id: id,
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  course: courseController.text.trim(),
                  subject: subjectController.text.trim(),
                  marks: marks ?? 0,
                  attendance: attendance ?? 0,
                  grade: gradeController.text.trim(),
                  status: statusController.text.trim(),
                );

                Navigator.pop(
                  context,
                  result,
                );
              },
              child: Text(
                editing ? 'Update' : 'Add',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // SUCCESS MESSAGE
  // ==========================================================

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message),
      ),
    );
  }

  // ==========================================================
  // ERROR MESSAGE
  // ==========================================================

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  // ==========================================================
  // UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final filteredStudents = students.where((student) {
      final query = searchText.toLowerCase();

      return student.name.toLowerCase().contains(query) ||
          student.email.toLowerCase().contains(query) ||
          student.course.toLowerCase().contains(query) ||
          student.subject.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EduSphere Students',
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: loadStudents,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      // ======================================================
      // ADD BUTTON
      // ======================================================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: addStudent,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Student',
        ),
      ),

      body: Column(
        children: [
          // ====================================================
          // SEARCH
          // ====================================================

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // ====================================================
          // LOADING
          // ====================================================

          if (loading) const LinearProgressIndicator(),

          // ====================================================
          // LIST
          // ====================================================

          Expanded(
            child: filteredStudents.isEmpty
                ? const Center(
                    child: Text(
                      'No students found',
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredStudents.length,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final student = filteredStudents[index];

                      return StudentCard(
                        student: student,
                        onEdit: () {
                          updateStudent(
                            student,
                          );
                        },
                        onDelete: () {
                          deleteStudent(
                            student,
                          );
                        },
                      );
                    },
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

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentCard({
    super.key,
    required this.student,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              child: Text(
                student.name
                    .substring(
                      0,
                      1,
                    )
                    .toUpperCase(),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    student.email,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        label: Text(
                          'ID: ${student.id}',
                        ),
                      ),
                      Chip(
                        label: Text(
                          student.course,
                        ),
                      ),
                      Chip(
                        label: Text(
                          student.subject,
                        ),
                      ),
                      Chip(
                        label: Text(
                          'Marks: ${student.marks}',
                        ),
                      ),
                      Chip(
                        label: Text(
                          'Attendance: '
                          '${student.attendance}%',
                        ),
                      ),
                      Chip(
                        label: Text(
                          'Grade: '
                          '${student.grade}',
                        ),
                      ),
                      Chip(
                        label: Text(
                          student.status,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==================================================
            // UPDATE BUTTON
            // ==================================================

            IconButton(
              tooltip: 'Update',
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit,
              ),
            ),

            // ==================================================
            // DELETE BUTTON
            // ==================================================

            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
