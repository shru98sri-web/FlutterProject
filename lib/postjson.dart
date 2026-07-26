import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const postjson());
}


class postjson extends StatelessWidget {
  const postjson({super.key});

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

class PostDataScreen extends StatefulWidget {
  const PostDataScreen({super.key});

  @override
  State<PostDataScreen> createState() => _PostDataScreenState();
}

class _PostDataScreenState extends State<PostDataScreen> {
  // Controllers to capture user input from text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _idController = TextEditingController();



  //Map<String, dynamic> bookingData = {
   // "firstname": "Vignesh",
    //"lastname": "K",
    //"totalprice": 1000,
    //"depositpaid": true,
   // "bookingdates": {
     // "checkin": "2018-01-01",
     // "checkout": "2019-01-01"
   // },
   // "additionalneeds": "super bowls"
  //};

  bool _isLoading = false;
  String _apiResponse = "No data sent yet.";

  // Async function to handle the HTTP POST network request
  Future<void> sendPostRequest() async {
    // Basic validation to prevent sending empty fields
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty||_useridController.text.isEmpty||_idController.text.isEmpty) {
      setState(() {
        _apiResponse = "Please fill in all text fields!";
      });
      return;
    }

    setState(() {
      _isLoading = true; // Show loading spinner
    });

    const String apiUrl = 'http://localhost:3000/users';
    //const String apiUrl = 'https://restful-booker.herokuapp.com/booking';


    // 1. Structure data into a Map payload
    final Map<String, dynamic> requestBody = {
      'title': _titleController.text,
      'body': _bodyController.text,
      'userId': _useridController.text,
      'id': _idController.text
    };

    try {
      // 2. Execute the POST request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody), // Encodes Map to standard JSON format
      );

      // 3. Process status code results
      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          _apiResponse = "Success!\nServer Response:\n${response.body}";
        });
      } else {
        setState(() {
          _apiResponse = "Server Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _apiResponse = "Network Exception: $e";
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner and restore button UI
      });
    }
  }

  @override
  void dispose() {
    // Clean up controllers when widget is unmounted to preserve device memory
    _titleController.dispose();
    _bodyController.dispose();
    _useridController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API JSON POST Demo'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Entry Field
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Body Content Entry Field
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
                  labelText: 'Userid',floatingLabelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder()
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


              // Action Request Trigger Button
              ElevatedButton(
                onPressed: _isLoading ? null : sendPostRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text('Submit Data to Server', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 24),

              // Live Server Update Terminal Display Area
              const Text(
                'Status / Response Terminal:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Text(
                  _apiResponse,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class MyAppbuilder extends StatelessWidget {
  const MyAppbuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JSON POST Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PostDatabuilder(),
    );
  }
}

// 1. Define your Data Model
class PostResponse {
  final int id;
  final int userId;
  final String title;
  final String body;

  PostResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}

class PostDatabuilder extends StatefulWidget {
  const PostDatabuilder({super.key});

  @override
  State<PostDatabuilder> createState() => _PostDatabuilderState();
}

class _PostDatabuilderState extends State<PostDatabuilder> {
  Future<PostResponse>? _postFuture;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  // 2. HTTP POST Request Function
  Future<PostResponse> sendJsonPost(int id, int userId, String title, String body) async {
    final url = Uri.parse('http://localhost:3000/users');
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};

    final jsonPayload = jsonEncode(<String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    });

    final response = await http.post(url, headers: headers, body: jsonPayload);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return PostResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post data. Status: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _idController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON POST with FutureBuilder')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _postFuture == null ? _buildInputForm() : _buildFutureBuilder(),
      ),
    );
  }


  Widget _buildInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _idController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Enter ID'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _userIdController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Enter User ID'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Enter Title'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _bodyController,
          decoration: const InputDecoration(labelText: 'Enter Body Content'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _bodyController.text.isNotEmpty &&
                _idController.text.isNotEmpty &&
                _userIdController.text.isNotEmpty) {
              setState(() {

                _postFuture = sendJsonPost(
                  int.parse(_idController.text.trim()),
                  int.parse(_userIdController.text.trim()),
                  _titleController.text.trim(),
                  _bodyController.text.trim(),
                );
              });
            }
          },
          child: const Text('Submit POST Request'),
        ),
      ],
    );
  }

  // 4. FutureBuilder Widget to handle states and display response
  Widget _buildFutureBuilder() {
    return FutureBuilder<PostResponse>(
      future: _postFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Text(
                  'Error occurred: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _postFuture = null;
                    });
                  },
                  child: const Text('Try Again'),
                )
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final postData = snapshot.data!;
          return Center(
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Server Response Success:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    const Divider(),
                    Text('ID: ${postData.id}'),
                    const SizedBox(height: 8),
                    Text('User ID: ${postData.userId}'),
                    const SizedBox(height: 8),
                    Text('Title: ${postData.title}'),
                    const SizedBox(height: 8),
                    Text('Body: ${postData.body}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _postFuture = null;
                          _idController.clear();
                          _userIdController.clear();
                          _titleController.clear();
                          _bodyController.clear();
                        });
                      },
                      child: const Text('Back to Form'),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: Text('No data status found.'));
      },
    );
  }
}

