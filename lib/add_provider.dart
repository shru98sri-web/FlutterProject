import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorProvider extends ChangeNotifier {
  int _result = 0;

  // Getter to display the result in the UI
  int get result => _result;

  // Main method to perform addition
  void addNumbers(String num1, String num2) {
    // Validate inputs and convert them to integers
    int number1 = int.tryParse(num1) ?? 0;
    int number2 = int.tryParse(num2) ?? 0;

    _result = number1 + number2;

    // Notify all listening UI widgets about the change
    notifyListeners();
  }
}

void main() {
  runApp(
    // 1. Wrap the app with Provider here
    ChangeNotifierProvider(
      create: (context) => CalculatorProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers to capture user input
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  @override
  void dispose() {
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Addition Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Result section (Only this widget rebuilds when the result changes)
            Consumer<CalculatorProvider>(
              builder: (context, calculator, child) {
                return Text(
                  'Result: ${calculator.result}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // First Input Field
            TextField(
              controller: _num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter first number',
              ),
            ),
            const SizedBox(height: 15),
            // Second Input Field
            TextField(
              controller: _num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter second number',
              ),
            ),
            const SizedBox(height: 25),
            // Action Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () {
                // Call the Provider method without listening to changes here
                Provider.of<CalculatorProvider>(
                  context,
                  listen: false,
                ).addNumbers(_num1Controller.text, _num2Controller.text);
              },
              child: const Text('Add Numbers', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

//ChangeNotifier: Holds the application state and listens for data changes.
// notifyListeners()
// Consumer: Listens specifically to the model and rebuilds only the nested widget, optimizing app performance.
// listen: false
