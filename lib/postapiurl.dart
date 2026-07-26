import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//void main() {
  //runApp(const MyApp());
//}

class postapi extends StatelessWidget {
  const postapi({super.key});

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
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _totalpriceController = TextEditingController();
  final TextEditingController _depositpaidController = TextEditingController();
  final TextEditingController _checkinController = TextEditingController();
  final TextEditingController _checkoutController = TextEditingController();
  final TextEditingController _additionalneedsController = TextEditingController();


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
    if (_firstnameController.text.isEmpty || _lastnameController.text.isEmpty||_totalpriceController.text.isEmpty||_depositpaidController.text.isEmpty||_checkinController.text.isEmpty||_checkoutController.text.isEmpty||_additionalneedsController.text.isEmpty)
    {
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

    int parsedPrice = int.tryParse(_totalpriceController.text) ?? 0;

// 2. Convert the deposit text string safely into an actual true/false boolean value
    bool isDepositPaid = _depositpaidController.text.toLowerCase() == 'true';


    final Map<String, dynamic> requestBody = {
      "firstname": _firstnameController.text,
      "lastname": _lastnameController.text,
      "totalprice": parsedPrice,       // FIX: Removed quotes to make it an integer number
      "depositpaid": isDepositPaid,      // FIX: Changed "500" string to an actual boolean true or false
      "bookingdates": {         // FIX: Added the nested parent object map wrap
        "checkin": _checkinController.text,
        "checkout":_checkoutController.text
      },
      "additionalneeds": _additionalneedsController.text // FIX: Removed the empty space from "additional needs"
    };


    // 1. Structure data into a Map payload

    try {
      // 2. Execute the POST request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'

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
    _firstnameController.dispose();
    _lastnameController.dispose();
    _totalpriceController.dispose();
    _depositpaidController.dispose();
    _checkinController.dispose();
    _checkoutController.dispose();
    _additionalneedsController.dispose();
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
                controller: _firstnameController,
                decoration: const InputDecoration(
                  labelText: 'FirstName',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Body Content Entry Field
              TextField(
                controller: _lastnameController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _totalpriceController,
                decoration: const InputDecoration(
                    labelText: 'Total price',floatingLabelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _depositpaidController,
                decoration: const InputDecoration(
                  labelText: 'deposit paid',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _checkinController,
                decoration: const InputDecoration(
                  labelText: 'Checkin',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _checkoutController,
                decoration: const InputDecoration(
                  labelText: 'Checkout',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _additionalneedsController,
                decoration: const InputDecoration(
                  labelText: 'additional needs',
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


