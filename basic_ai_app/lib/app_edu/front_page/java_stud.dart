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

  // 1. Initialize custom configuration tracking blocks for jb engine
  final config = await loadConfigString('''
    source-dirs: [ src ]
    resource-dirs: [ res ]
  ''');

  final jbOptions = JbCliOptions.parseArgs(args);
  final dartleOptions = parseOptions(jbOptions.dartleArgs);

  activateLogging(
    dartleOptions.logLevel,
    colorfulLog: dartleOptions.colorfulLog,
    logName: 'jbuild-pipeline',
  );

  // 2. Initialize the custom student task mapping both output loops and jb execution
  final printStudentsTask = Task(
    (_) async {
      // Step A: Print the student records directly to terminal channel
      _generateAndPrintStudents(200);

      // Step B: Run the jb workspace task tracker pipeline inside the active task routine
      final buildRan = await runJb(
        jbOptions,
        dartleOptions,
        InstanceConfigSource(config),
      );

      // Step C: Force print validation summary to bypass external stream filters
      if (buildRan) {
        logger.info(
          ColoredLogMessage(
            'jb completed successfully in ${stopwatch.elapsed.inMilliseconds}ms!',
            LogColor.green,
          ),
        );
      }
    },
    name: 'printStudents',
    description:
        'Generates mock records, prints 200 students, and triggers jb project builds.',
  );

  // 3. Guarantee that the custom lifecycle runs cleanly if no task flags are provided
  final targetTasks = args.isEmpty ? ['printStudents'] : args;

  await run(targetTasks, tasks: {printStudentsTask});
}

void _generateAndPrintStudents(int count) {
  final random = Random();

  logger.info(const ColoredLogMessage(
      '=== Printing 200 Student Records ===\n', LogColor.blue));

  for (var i = 1; i <= count; i++) {
    final student = Student(
      id: 2026000 + i,
      name: 'Student_Name_$i',
      age: random.nextInt(5) + 18,
      gpa: 2.0 + random.nextDouble() * 2.0,
    );
    logger.info(ColoredLogMessage(student.toString(), LogColor.magenta));
  }
  logger.info(const ColoredLogMessage(
      '\n====================================', LogColor.blue));
}
