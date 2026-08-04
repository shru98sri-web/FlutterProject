import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  // Initialize Dio with default configurations
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10), // 10 seconds timeout
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // 1. GET Request: Fetch Data
  Future<Response?> getUsers() async {
    try {
      // Dio automatically parses JSON strings into Maps/Lists
      final response = await _dio.get('/users');
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // 2. POST Request: Send Data
  Future<Response?> createUser(String name, String job) async {
    try {
      final response = await _dio.post(
        '/users',
        data: {
          'name': name,
          'job': job,
        },
      );
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Centralized Error Handling
  void _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      print('Connection timeout. Please check your internet.');
    } else if (error.type == DioExceptionType.badResponse) {
      print('Server error: ${error.response?.statusCode}');
    } else {
      print('Something went wrong: ${error.message}');
    }
  }
}


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response = await _apiService.getUsers();
    if (response != null && response.statusCode == 200) {
      setState(() {
        _users = response.data; // Response data is already mapped
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dio API Example')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user['name'] ?? 'No Name'),
            subtitle: Text(user['email'] ?? 'No Email'),
          );
        },
      ),
    );
  }
}
