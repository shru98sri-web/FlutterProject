import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ==========================================
// 1. MAIN INITIALIZATION
// ==========================================
// void main() async {
//   // Ensure Flutter engine bindings are fully booted before Firebase initializes
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // 2. PASS THE OPTIONS FILE HERE TO FIX THE BLANK SCREEN
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase CRUD App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: const UserCrudScreen(),
    );
  }
}

class FirestoreService {
  // Get reference to the 'users' collection
  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection('users');

  // 1. CREATE: Add a new user with a auto-generated Document ID
  Future<void> createUser(String name, int age) async {
    try {
      await _usersCollection.add({
        'name': name,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  // 2. READ: Get live stream updates from the collection
  Stream<QuerySnapshot> getUsersStream() {
    return _usersCollection.orderBy('createdAt', descending: true).snapshots();
  }

  // 3. UPDATE: Modify an existing user document using its unique ID
  Future<void> updateUser(String docId, String newName, int newAge) async {
    try {
      await _usersCollection.doc(docId).update({
        'name': newName,
        'age': newAge,
      });
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  // 4. DELETE: Remove a user document using its unique ID
  Future<void> deleteUser(String docId) async {
    try {
      await _usersCollection.doc(docId).delete();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}

class UserCrudScreen extends StatefulWidget {
  const UserCrudScreen({super.key});

  @override
  State<UserCrudScreen> createState() => _UserCrudScreenState();
}

class _UserCrudScreenState extends State<UserCrudScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Displays dialog form wrapper for handling Create or Update operations
  void _showFormDialog({String? docId, String? currentName, int? currentAge}) {
    if (docId != null) {
      _nameController.text = currentName ?? '';
      _ageController.text = currentAge?.toString() ?? '';
    } else {
      _nameController.clear();
      _ageController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docId == null ? 'Add User' : 'Update User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final String name = _nameController.text;
              final int? age = int.tryParse(_ageController.text);

              if (name.isNotEmpty && age != null) {
                if (docId == null) {
                  // Execute Create Action
                  await _firestoreService.createUser(name, age);
                } else {
                  // Execute Update Action
                  await _firestoreService.updateUser(docId, name, age);
                }
                if (mounted) Navigator.pop(context);
              }
            },
            child: Text(docId == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Firestore CRUD')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No users found. Add some!'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final docId = doc.id;
              final data = doc.data() as Map<String, dynamic>;

              final String name = data['name'] ?? 'N/A';
              final int age = data['age'] ?? 0;

              return ListTile(
                title: Text(name),
                subtitle: Text('Age: $age'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit Icon (Triggers Update Dialog)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showFormDialog(
                        docId: docId,
                        currentName: name,
                        currentAge: age,
                      ),
                    ),
                    // Trash Icon (Triggers Delete Function)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _firestoreService.deleteUser(docId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
