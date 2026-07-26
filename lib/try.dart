import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: PostApiPage()));
}

class PostApiPage extends StatefulWidget {
  const PostApiPage({super.key});

  @override
  State<PostApiPage> createState() => _PostApiPageState();
}

class _PostApiPageState extends State<PostApiPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();

  String result = "";

  Future<void> createUser() async {
    var response = await http.post(
      Uri.parse("https://jsonplaceholder.typicode.com/posts"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "job": jobController.text,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        result = response.body;
      });
    } else {
      setState(() {
        result = "Failed";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("POST API Example")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Enter Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: jobController,
              decoration: const InputDecoration(labelText: "Enter Job"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: createUser, child: const Text("Submit")),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
