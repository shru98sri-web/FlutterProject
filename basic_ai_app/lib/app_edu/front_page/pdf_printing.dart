import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(MaterialApp(
    home: StudentPrintScreen(),
  ));
}

// Simple model container to structure the student details
class Student {
  final String id;
  final String name;
  final String grade;
  final String section;

  Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.section,
  });
}

class StudentPrintScreen extends StatelessWidget {
  const StudentPrintScreen({Key? key}) : super(key: key);

  // Helper method to generate mock records for 200 students
  List<Student> _generateMockStudents() {
    return List.generate(
      200,
      (index) => Student(
        id: "STU${(index + 1).toString().padLeft(3, '0')}",
        name: "Student Name ${index + 1}",
        grade: "Class ${1 + (index % 12)}",
        section: ["A", "B", "C", "D"][index % 4],
      ),
    );
  }

  // Generates the PDF document stream and opens the platform print preview layout
  Future<void> _printStudentDetails(List<Student> students) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        // Global header rendered on top of every page layout boundary
        header: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 20),
          child: pw.Text(
            'Academic Records - Student Directory',
            style: pw.TextStyle(color: PdfColors.grey700, fontSize: 10),
          ),
        ),
        // Dynamic footer tracking current page numbers across the continuous document
        footer: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.all(20),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Master Student Enrollment List',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(padding: const pw.EdgeInsets.only(bottom: 15)),

          // Table layout engine that automatically handles wrapping across page breaks
          pw.TableHelper.fromTextArray(
            headers: ['Student ID', 'Full Name', 'Grade', 'Section'],
            data: students
                .map((student) => [
                      student.id,
                      student.name,
                      student.grade,
                      student.section,
                    ])
                .toList(),
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
            cellAlignment: pw.Alignment.centerLeft,
            cellHeight: 25,
            cellAlignments: {
              0: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
            },
          ),
        ],
      ),
    );

    // Invokes the platform's native PDF viewing and printing engine dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'student_directory_200.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockStudents = _generateMockStudents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Record Printing'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.print),
          label: Text('Print Details of ${mockStudents.length} Students'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 16),
          ),
          onPressed: () => _printStudentDetails(mockStudents),
        ),
      ),
    );
  }
}
