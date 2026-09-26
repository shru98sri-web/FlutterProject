import 'dart:io';

import 'package:jni/jni.dart';
// Ensure this path matches the location where you generated the bindings file

void main() {
  print('========================================');
  print('   JNIGen Student Demonstration Code   ');
  print('========================================\n');

  try {
    // 1. Point the JVM classpath to the folder containing your compiled Java files
    // If you are using source code files, you can point to the 'java_src' directory
    final String javaClasspath = 'java_src';

    print('[JVM] Initializing Java Virtual Machine...');
    Jni.initialize(args: ['-Djava.class.path=$javaClasspath']);
    print('[JVM] Java Virtual Machine loaded successfully.\n');

    // 2. Call the static integer addition method from Java
    final int numberA = 15;
    final int numberB = 25;

    print('[Dart -> Java] Sending integers: $numberA and $numberB');
    final int sumResult = Calculator.add(numberA, numberB);
    print('[Java -> Dart] Integer execution result: $sumResult\n');

    // 3. Send a string from Dart into Java
    final String studentName = 'Alex';
    print('[Dart -> Java] Sending string parameter: "$studentName"');

    // Explicitly convert the Dart String to a native Java JString format
    final JString inputJString = studentName.toJString();

    // Execute the Java greeting logic
    final JString outputJString = Calculator.greetStudent(inputJString);

    // Convert the returned Java string instance type back into a Dart String
    final String resultMessage = outputJString.toDartString();
    print('[Java -> Dart] String execution result: "$resultMessage"\n');
  } on JniException catch (e) {
    print('[CRITICAL ERROR] A JNI Runtime exception occurred: $e');
    print(
        'Please check that your Java class is compiled and matching the classpath.');
  } catch (e) {
    print('[UNEXPECTED ERROR] An error occurred during runtime: $e');
  }

  print('========================================');
  print('         Execution Finished             ');
  print('========================================');
}
