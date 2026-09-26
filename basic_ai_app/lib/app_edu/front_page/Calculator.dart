import 'package:jni/jni.dart' as jni;

void main() {
  // 1. Initialize the JVM so Dart can talk to Java
  // We pass the path to the compiled Java classes or source files
  final jni.JString pathString = 'java_src'.toJString();

  print('--- JNIGen Student Demo ---');

  // 2. Call the static Java methods directly using the generated Dart bindings
  var Calculator;
  final sum = Calculator.add(15, 25);
  print('Result from Java addition (15 + 25): $sum');

  // 3. Pass and receive strings between Dart and Java
  // jnigen automatically converts Dart Strings to JString objects
  final messageJString = Calculator.greetStudent('Alex'.toJString());

  // Convert the Java JString back to a standard Dart String
  final dartMessage = messageJString.toDartString();
  print('Message from Java: $dartMessage');
}
