import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main()
{
runApp(const DeleteScreen());
}

class PutScreen extends StatelessWidget {
  const PutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HttpPutScreen(),
      debugShowCheckedModeBanner: false,
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



class PatchScreen extends StatelessWidget {
  const PatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HttpPatchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HttpPatchScreen extends StatefulWidget {
  const HttpPatchScreen({super.key});

  @override
  State<HttpPatchScreen> createState() => _HttpPatchScreenState();
}

class _HttpPatchScreenState extends State<HttpPatchScreen> {
  String _resultMessage = 'Press the button to partially update data';
  bool _isLoading = false;

  // Error-free PATCH request function
  Future<void> patchData() async {
    setState(() {
      _isLoading = true;
    });

    // API URL to patch data (Example uses JSONPlaceholder API)
    final Uri url = Uri.parse('http://localhost:3000/users/150');

    // Data payload to update (Only updating the title, leaving other fields unchanged)
    final Map<String, dynamic> patchData = {
      "title": "JEE Maths-6",
    };

    try {
      // Making the http.patch call
      final http.Response response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(patchData), // Data converted to JSON format
      );

      // Status code 200 means data was successfully updated on the server
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _resultMessage = 'Data patched successfully!\nNew Title: ${responseData['title']}';
        });
      } else {
        // Handling server-side errors
        setState(() {
          _resultMessage = 'Server Error: Status Code ${response.statusCode}';
        });
      }
    } catch (error) {
      // Handling client-side network errors (e.g., no internet)
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
      appBar: AppBar(title: const Text('HTTP PATCH Error-Free Code')),
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
                  onPressed: patchData,
                  child: const Text('Patch Data (PATCH)'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


class DeleteScreen extends StatelessWidget {
  const DeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HttpDeleteScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class HttpDeleteScreen extends StatefulWidget {
  const HttpDeleteScreen({super.key});

  @override
  State<HttpDeleteScreen> createState() => _HttpDeleteScreenState();
}

class _HttpDeleteScreenState extends State<HttpDeleteScreen> {
  String _resultMessage = 'Press the button to delete data';
  bool _isLoading = false;

  // Error-free DELETE request function
  Future<void> deleteData() async {
    setState(() {
      _isLoading = true;
    });

    // API URL with specific ID to delete (Example deletes post with ID 1)
    final Uri url = Uri.parse('http://localhost:3000/users/150');

    try {
      // Making the http.delete call
      final http.Response response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': 'Bearer YOUR_TOKEN_HERE', // गरज असल्यास टोकन वापरा
        },
      );

      // Status code 200 or 204 means data was successfully deleted
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _resultMessage = 'Success! Status Code: ${response.statusCode}\nData deleted successfully from the server.';
        });

        // कन्सोलमध्ये रिझल्ट प्रिंट करण्यासाठी
        debugPrint('Delete Success: ${response.body}');
      } else {
        // Handling server-side errors (e.g., 404 Not Found, 403 Forbidden)
        setState(() {
          _resultMessage = 'Server Error: Status Code ${response.statusCode}';
        });
      }
    } catch (error) {
      // Handling client-side network errors (e.g., no internet)
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
      appBar: AppBar(title: const Text('HTTP DELETE Error-Free Code')),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: deleteData,
                  child: const Text('Delete Data (DELETE)', style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
