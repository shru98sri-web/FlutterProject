import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


class AdditionProvider extends ChangeNotifier {
  int _totalValue = 0;
  static const String _storageKey = 'saved_addition_value';

  int get totalValue => _totalValue;

  // Load the saved data when the app starts
  Future<void> loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    _totalValue = prefs.getInt(_storageKey) ?? 0;
    notifyListeners();
  }

  // Add value and persist it
  Future<void> addValue(int amount) async {
    _totalValue += amount;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storageKey, _totalValue);
  }

  // Clear data from memory and storage
  Future<void> clearValue() async {
    _totalValue = 0;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}


void main() async {
  // Ensure framework is ready before accessing SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  final provider = AdditionProvider();
  await provider.loadValue(); // Load saved value

  runApp(
    ChangeNotifierProvider(
      create: (context) => provider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PageOne(),debugShowCheckedModeBanner: false,
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch for changes so this page rebuilds when values are added
    final provider = context.watch<AdditionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Page One'),backgroundColor: Colors.amberAccent,),
      body: Center(
        child: Text(
          'Total Addition: ${provider.totalValue}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PageTwo()),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AdditionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Page Two'),backgroundColor: Colors.amberAccent,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => provider.addValue(10),
              child: const Text('Add 10'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => provider.clearValue(),
              child: const Text('Clear Value', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}