import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'user_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'user.dart';

// user.dart
class User {
  final String name;
  final int age;

  User(this.name, this.age);
}

// user_provider.dart


class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  // Key names for SharedPreferences storage
  static const String _keyName = 'user_name';
  static const String _keyAge = 'user_age';

  UserProvider() {
    _loadUserFromPrefs(); // Auto-load saved info upon creation
  }

  // Fetch persistently stored profile values
  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance(); //
    final String? savedName = prefs.getString(_keyName); //
    final int? savedAge = prefs.getInt(_keyAge); //

    if (savedName != null && savedAge != null) {
      _user = User(savedName, savedAge);
      notifyListeners();
    }
  }

  // Save new values locally and broadcast UI updates
  Future<void> updateUser(String name, int age) async {
    _user = User(name, age);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance(); //
    await prefs.setString(_keyName, name); //
    await prefs.setInt(_keyAge, age); //
  }
}


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
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
      home: UserProfileScreen(),
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final currentUser = userProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Persistent User Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display Section
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: currentUser == null
                      ? const Text(
                    'No local profile found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                      : Column(
                    children: [
                      Text(
                        'Name: ${currentUser.name}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Age: ${currentUser.age} years old',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Form Input Fields Section
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
              ),
              const SizedBox(height: 25),

              // Action Processing Trigger
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                onPressed: () {
                  final String enteredName = _nameController.text.trim();
                  final String ageText = _ageController.text.trim();

                  // Validation check for empty configurations
                  if (enteredName.isEmpty || ageText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: Name and age cannot be blank.')),
                    );
                    return;
                  }

                  // Data-type correction evaluation
                  final int? enteredAge = int.tryParse(ageText);
                  if (enteredAge == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: Age must be a valid number.')),
                    );
                    return;
                  }

                  // Dispatching structural change to state framework
                  context.read<UserProvider>().updateUser(enteredName, enteredAge);

                  _nameController.clear();
                  _ageController.clear();
                },
                child: const Text('Save Locally', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}