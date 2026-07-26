import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: Postapi()));
}

class Postapi extends StatefulWidget {
  const Postapi({super.key});
  @override
  State<Postapi> createState() => _PostapiState();
}

class _PostapiState extends State<Postapi> {
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
        result = "failed";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('postapi example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Enter name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: jobController,
              decoration: const InputDecoration(labelText: "Enter job"),
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
