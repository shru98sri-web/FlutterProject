import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Wrap the application with ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => PostDataProvider(),
      child: const PostJsonApp(),
    ),
  );
}

// Renamed to PascalCase following Dart naming conventions
class PostJsonApp extends StatelessWidget {
  const PostJsonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter POST API Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PostDataScreen(),
    );
  }
}

/// 1. Provider Class (Business Logic & State Management)
class PostDataProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _apiResponse = "No data sent yet.";

  // Getters to expose variables to the UI safely
  bool get isLoading => _isLoading;
  String get apiResponse => _apiResponse;

  // Method to update the response terminal message
  void updateResponse(String message) {
    _apiResponse = message;
    notifyListeners(); // Triggers UI update
  }

  // Async function handling the HTTP POST request
  Future<void> sendPostRequest({
    required String title,
    required String body,
    required String userId,
    required String id,
  }) async {
    _isLoading = true;
    notifyListeners(); // Show loading spinner

    //const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
    const String apiUrl = 'http://localhost:3000/users';

    final Map<String, dynamic> requestBody = {
      'title': title,
      'body': body,
      'userId': userId,
      'id': id,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _apiResponse = "Success!\nServer Response:\n${response.body}";
      } else {
        _apiResponse = "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      _apiResponse = "Network Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners(); // Hide loading spinner and update UI
    }
  }
}

/// 2. UI Screen
class PostDataScreen extends StatefulWidget {
  const PostDataScreen({super.key});

  @override
  State<PostDataScreen> createState() => _PostDataScreenState();
}

class _PostDataScreenState extends State<PostDataScreen> {
  // Input Text Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    // Memory cleanup
    _titleController.dispose();
    _bodyController.dispose();
    _useridController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    // Read provider state without listening (listen: false is required inside events like clicks)
    final postProvider = Provider.of<PostDataProvider>(context, listen: false);

    if (_titleController.text.isEmpty ||
        _bodyController.text.isEmpty ||
        _useridController.text.isEmpty ||
        _idController.text.isEmpty) {
      postProvider.updateResponse("Please fill in all text fields!");
      return;
    }

    // Trigger the API request method in Provider
    postProvider.sendPostRequest(
      title: _titleController.text,
      body: _bodyController.text,
      userId: _useridController.text,
      id: _idController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API JSON POST - Provider Demo'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Use Consumer to listen for updates inside PostDataProvider
          child: Consumer<PostDataProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bodyController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Body Content',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _useridController,
                    decoration: const InputDecoration(
                      labelText: 'Userid',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Id',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Submit Button
                  ElevatedButton(
                    onPressed: provider.isLoading ? null : _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Data to Server',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Status / Response Terminal:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // Terminal Display Area
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: Text(
                      provider.apiResponse,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
