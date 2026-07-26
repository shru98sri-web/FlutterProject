import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main()
{
  runApp(Page1());
}

class Page1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home:HttpPutScreen());
  }

}
class PostApiPage extends StatefulWidget{
  const PostApiPage({super.key});
  @override
  State<PostApiPage> createState()=> _PostApiPageState();
}
class _PostApiPageState extends State<PostApiPage> {

  TextEditingController bookIdController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController rateUunitController = TextEditingController();

  String result = "";

  Future<void> createUser() async {
    var response = await http.post(
      Uri.parse("http://localhost:8080/api/v1/books"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "bookId": bookIdController.text,
        "bookName": bookNameController.text,
        "author": authorController.text,
        "rateUunit":rateUunitController.text,
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
      appBar: AppBar(
        title: const Text("Post API Request"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children:[
          TextField(
          controller: bookIdController,
          decoration: const InputDecoration(
            labelText: "Enter bookId",
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: bookNameController,
          decoration: const InputDecoration(
            labelText: "Enter BookName",
          ),
        ),
        const SizedBox(height:10),
        TextField(
          controller: authorController,
          decoration: const InputDecoration(
            labelText:"Enter AuthorName",
          )
        ),
            const SizedBox(height: 20),
        TextField(
          controller: rateUunitController,
          decoration: const InputDecoration(
            labelText:"Enter rateUunit",
          ),
        ),
        ElevatedButton(
            onPressed: createUser,
            child:const Text("Submit"),
      ),
      const SizedBox(height: 20),
      Text(result),
      ],
    ),),
    );
  }
}

class HttpPutScreen extends StatefulWidget {
  const HttpPutScreen({super.key});

  @override
  State<HttpPutScreen> createState() => _HttpPutScreenState();
}

class _HttpPutScreenState extends State<HttpPutScreen> {
  String _resultMessage = 'Press the button to update data';
  bool _isLoading = false;

  // Error-free PUT request function
  Future<void> updateData() async {
    setState(() {
      _isLoading = true;
    });

    // API URL to update (Example uses JSONPlaceholder API)
    final Uri url = Uri.parse('http://localhost:3000/users/150');

    // New data payload to send to the server
    final Map<String, dynamic> updateData = {
      "title": "JEE Maths-5",
      "body": "Presentation",
      "userId": "151",
      "id": "150"
    };

    try {
      // Making the http.put call
      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateData), // Data converted to JSON format
      );

      // Status code 200 or 201 means the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _resultMessage = 'Data updated successfully!\nResponse: ${responseData['title']}';
        });
      } else {
        // Handling server-side errors (e.g., 404, 500)
        setState(() {
          _resultMessage = 'Server Error: Status Code ${response.statusCode}';
        });
      }
    } catch (error) {
      // Handling client-side network errors (e.g., no internet, timeout)
      setState(() {
        _resultMessage = 'Network Error: Please check your internet. ($error)';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HTTP PUT Error-Free Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else ...[
                Text(
                  _resultMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateData,
                  child: const Text('Update Data (PUT)'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
