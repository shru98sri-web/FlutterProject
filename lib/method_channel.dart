import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for using platform channels

class Appmethod extends StatelessWidget {
  const Appmethod({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: StatesScreen());
  }
}

class StatesScreen extends StatefulWidget {
  const StatesScreen({super.key});

  @override
  State<StatesScreen> createState() => _StatesScreenState();
}

class _StatesScreenState extends State<StatesScreen> {
  // 1. Define the channel name identifier (Note: This is NOT a file path, just a unique ID)
  static const MethodChannel _methodChannel = MethodChannel(
    'com.example.app/states',
  );

  List<Map<String, String>> _statesList = [];
  bool _isLoading = false;

  // 2. Function to request data from the native side
  Future<void> _fetchStatesData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Invoke the native method named 'getStatesData'
      final List<dynamic> result = await _methodChannel.invokeMethod(
        'getStatesData',
      );

      // Parse the dynamic map structure returned from native layers into strongly typed records
      final List<Map<String, String>> formattedStates = result.map((item) {
        final Map<dynamic, dynamic> stateMap = item as Map<dynamic, dynamic>;
        return {
          'name': stateMap['name']?.toString() ?? '',
          'capital': stateMap['capital']?.toString() ?? '',
        };
      }).toList();

      setState(() {
        _statesList = formattedStates;
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Platform Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('State & Capital Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchStatesData,
              child: const Text('Load States Data'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            Expanded(
              child: _statesList.isEmpty
                  ? const Center(child: Text('No data loaded. Tap the button.'))
                  : ListView.builder(
                      itemCount: _statesList.length,
                      itemBuilder: (context, index) {
                        final state = _statesList[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(
                              state['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Capital: ${state['capital']}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
