import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PostProvider extends ChangeNotifier {
  List<dynamic> _posts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<dynamic> get posts => _posts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final Uri url = Uri.parse('http://localhost:8080/api/v1/tuition');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _posts = jsonDecode(response.body) as List<dynamic>;
      } else {
        _errorMessage = 'Failed to load posts';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PostProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JsonListViewExample1(),
    );
  }
}


class JsonListViewExample1 extends StatefulWidget {
  const JsonListViewExample1({super.key});

  @override
  State<JsonListViewExample1> createState() => _JsonListViewExample1State();
}

class _JsonListViewExample1State extends State<JsonListViewExample1> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts JSON ListView (Provider)'),
        backgroundColor: Colors.blue,
      ),
      body: _buildBody(postProvider),
    );
  }

  Widget _buildBody(PostProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(child: Text(provider.errorMessage));
    }

    if (provider.posts.isEmpty) {
      return const Center(child: Text('No data found'));
    }

    return ListView.builder(
      itemCount: provider.posts.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> post = provider.posts[index];

        final String id = post['classId'].toString();
        final String userId = post['name'].toString();
         final String title = post['author'] ?? 'Package';
         final String body = post['rateUnit'] ?? 'Discount ';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                id,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'classid: $id  |  name : $userId',
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}