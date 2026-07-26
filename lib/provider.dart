import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  // Factory constructor to convert JSON map into a Todo object
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Public getters to access private variables safely from the UI
  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Method to fetch data from the API endpoint
  Future<void> fetchTodos() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Notify UI to render the loading indicator

    final url = Uri.parse('https://typicode.com');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        _todos = decodedData.map((item) => Todo.fromJson(item)).toList();
      } else {
        _errorMessage = 'Server Error: Status code ${response.statusCode}';
      }
    } catch (error) {
      _errorMessage = 'Network Error: Failed to fetch data from server.';
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI to display data or error screen
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}


class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule API call safely immediately after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    // watch listens to updates and rebuilds the UI automatically
    final todoProvider = context.watch<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('API GET Request Tutorial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => todoProvider.fetchTodos(),
          )
        ],
      ),
      body: _buildBody(todoProvider),
    );
  }

  Widget _buildBody(TodoProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          provider.errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (provider.todos.isEmpty) {
      return const Center(child: Text('No elements found in list.'));
    }

    return ListView.builder(
      itemCount: provider.todos.length,
      itemBuilder: (context, index) {
        final todo = provider.todos[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${todo.id}')),
          title: Text(todo.title),
          trailing: Icon(
            todo.completed ? Icons.check_circle : Icons.circle_outlined,
            color: todo.completed ? Colors.green : Colors.grey,
          ),
        );
      },
    );
  }
}
