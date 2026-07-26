// This file is generated automatically by build_runner
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class TodoModel extends HiveObject {
  String title;
  String description;
  bool isCompleted;

  TodoModel({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

class TodoModelAdapter extends TypeAdapter<TodoModel> {
  @override
  final int typeId = 0;

  @override
  TodoModel read(BinaryReader reader) {
    return TodoModel(
      title: reader.readString(),
      description: reader.readString(),
      isCompleted: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, TodoModel obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeBool(obj.isCompleted);
  }
}

void main() async {
  // Ensure Flutter engine bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Register the TypeAdapter generated for TodoModel
  Hive.registerAdapter(TodoModelAdapter());

  // Open a Hive Box to store Todo items
  await Hive.openBox<TodoModel>('todoBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hive CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // Reference to open box
  late final Box<TodoModel> todoBox;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<TodoModel>('todoBox');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // CREATE / UPDATE Dialog
  void _showTodoDialog({TodoModel? todo, int? index}) {
    if (todo != null) {
      _titleController.text = todo.title;
      _descController.text = todo.description;
    } else {
      _titleController.clear();
      _descController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(todo == null ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final desc = _descController.text.trim();

                if (title.isNotEmpty) {
                  if (todo == null) {
                    // CREATE: Add new object
                    todoBox.add(TodoModel(title: title, description: desc));
                  } else {
                    // UPDATE: Modify properties and save changes
                    todo.title = title;
                    todo.description = desc;
                    todo.save();
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(todo == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive Todo List'), centerTitle: true),
      // Listens to database box changes dynamically
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<TodoModel> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('No tasks added yet!'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              // READ: Retrieve object from index
              final todo = box.getAt(index);

              if (todo == null) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      // UPDATE: Toggle complete status
                      todo.isCompleted = value ?? false;
                      todo.save();
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(todo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _showTodoDialog(todo: todo, index: index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // DELETE: Remove item from database
                          todo.delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
