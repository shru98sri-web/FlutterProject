import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

void main()
{
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: Page1(),
  ),);
}

class Page1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home:PostApiPage());
  }

}

class UserProvider extends ChangeNotifier {
  String _result = "";
  bool _isLoading = false;

  String get result => _result;
  bool get isLoading => _isLoading;

  Future<void> createUser(String name, String job) async {
    _isLoading = true;
    _result = "";
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "job": job,
        }),
      );

      if (response.statusCode == 201) {
        _result = response.body;
      } else {
        _result = "Failed to create user. Status: ${response.statusCode}";
      }
    } catch (e) {
      _result = "Error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class PostApiPage extends StatefulWidget {
  const PostApiPage({super.key});

  @override
  State<PostApiPage> createState() => _PostApiPageState();
}

class _PostApiPageState extends State<PostApiPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post API Request with Provider"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Enter Name",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: jobController,
              decoration: const InputDecoration(
                labelText: "Enter Job",
              ),
            ),
            const SizedBox(height: 20),

            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return userProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    userProvider.createUser(
                      nameController.text,
                      jobController.text,
                    );
                  },
                  child: const Text("Submit"),
                );
              },
            ),
            const SizedBox(height: 20),

            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Text(
                  userProvider.result,
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}