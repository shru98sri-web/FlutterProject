import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//void main() {
  //runApp(const MyApp_post());
//}

class MyApp_post extends StatelessWidget {
  const MyApp_post({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter POST API Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PostDataScreen_booking(),
    );
  }
}

class PostDataScreen_booking extends StatefulWidget {
  const PostDataScreen_booking({super.key});

  @override
  State<PostDataScreen_booking> createState() => _PostDataScreen_bookingState();
}

class _PostDataScreen_bookingState extends State<PostDataScreen_booking> {
  // Controllers to capture user input from text fields
  final TextEditingController _bookingidController = TextEditingController();



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
    if (_bookingidController.text.isEmpty ) {
      setState(() {
        _apiResponse = "Please fill in all text fields!";
      });
      return;
    }

    setState(() {
      _isLoading = true; // Show loading spinner
    });

    //const String apiUrl = 'http://localhost:3000/users';
   const String apiUrl = 'https://restful-booker.herokuapp.com/booking';


    // 1. Structure data into a Map payload
    final Map<String, dynamic> requestBody = {
      'booking id': _bookingidController.text,

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
    _bookingidController.dispose();
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
                controller: _bookingidController,
                decoration: const InputDecoration(
                  labelText: 'Booking id',
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

