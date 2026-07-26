import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataProvider extends ChangeNotifier {
  String _sharedValue = "Initial Value";

  String get sharedValue => _sharedValue;

  // Call this function from Page 1 to update the data
  void updateValue(String newValue) {
    _sharedValue = newValue;
    notifyListeners(); // Triggers a rebuild on listening pages
  }
}

// Import your screens and provider files here

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),
      body:
      //Center(
      //child:

      Column(
        children:[ Text('Name_info'),
          ElevatedButton(
          onPressed: () {
            // 1. Update the value in provider
            Provider.of<DataProvider>(context, listen: false)
                .updateValue("Name_info from Page 1!");
            // 2. Navigate to the second page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondPage()),
            );
          },
          child: const Text('Send Value & Go to Page 2'),
    ),],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Read and listen to changes from the DataProvider
    final dataProvider = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: Center(
        child: Text(
          dataProvider.sharedValue, // Displays: "Value from Page 1!"
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

