import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdditionProvider extends ChangeNotifier {
  int _totalValue = 0;

  int get totalValue => _totalValue;

  void addValue(int amount) {
    _totalValue += amount;
    notifyListeners(); // Updates all UI widgets listening to this provider
  }
}


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AdditionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PageOne(),
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
      appBar: AppBar(title: const Text('Page One')),
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
    // Use read instead of watch inside callbacks/functions to avoid rebuilding
    final provider = context.read<AdditionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Page Two')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Adds 10 to the totalValue and notifies Page One
            provider.addValue(20);
          },
          child: const Text('Add 20'),
        ),
      ),
    );
  }
}

