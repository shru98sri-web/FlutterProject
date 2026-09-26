import 'dart:math';

import 'package:dartle/dartle.dart';
import 'package:jb/jb.dart';

/// A class representing a Student's details.
class Student {
  final int id;
  final String name;
  final int age;
  final double gpa;

  Student(
      {required this.id,
      required this.name,
      required this.age,
      required this.gpa});

  @override
  String toString() =>
      'ID: $id | Name: $name | Age: $age | GPA: ${gpa.toStringAsFixed(2)}';
}

Future<void> main(List<String> args) async {
  final stopwatch = Stopwatch()..start();

  // Parse options using the jb CLI argument structure
  final jbOptions = JbCliOptions.parseArgs(args);
  final dartleOptions = parseOptions(jbOptions.dartleArgs);

  activateLogging(
    dartleOptions.logLevel,
    colorfulLog: dartleOptions.colorfulLog,
    logName: 'student-builder',
  );

  // Define a custom Dartle task to generate and print student info
  final printStudentsTask = Task(
    (_) async => _generateAndPrintStudents(200),
    name: 'printStudents',
    description: 'Generates mock records and prints details of 200 students.',
  );

  // Execute the task using Dartle's runtime engine
  await run(args, tasks: {printStudentsTask});

  logger.info(
    ColoredLogMessage(
      'Student task completed successfully in ${stopwatch.elapsed}!',
      LogColor.green,
    ),
  );
}

void _generateAndPrintStudents(int count) {
  final random = Random();

  logger.info(const ColoredLogMessage(
      '=== Printing Student Records ===', LogColor.blue));

  for (var i = 1; i <= count; i++) {
    final student = Student(
      id: 2026000 + i,
      name: 'Student_Name_$i',
      age: random.nextInt(5) + 18, // Ages 18 to 22
      gpa: 2.0 + random.nextDouble() * 2.0, // GPA between 2.0 and 4.0
    );
    print(student);
  }
}
