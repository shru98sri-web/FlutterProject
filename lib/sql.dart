import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // प्लगइन सेवा पूर्णपणे सुरू झाल्याची खात्री करण्यासाठी हे आवश्यक आहे
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLite Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PersonListScreen(),
    );
  }
}

// ----------------------------------------------------
// १. डेटा मॉडेल (Data Model)
// ----------------------------------------------------
class Person {
  final int? id;
  final String name;
  final int age;

  Person({this.id, required this.name, required this.age});

  // Dog डेटा मॅप (Map) मध्ये बदलण्यासाठी (डेटाबेसमध्ये सेव्ह करण्यासाठी)
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  // मॅप (Map) मधून पुन्हा Dog ऑब्जेक्ट बनवण्यासाठी
  factory Person.fromMap(Map<String, Object?> map) {
    return Person(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }
}

// ----------------------------------------------------
// २. डेटाबेस हेल्पर (Database Helper)
// ----------------------------------------------------
class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // मोबाईलमधील डेटाबेसचा मार्ग (Path) मिळवणे
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'person_database.db');

    // डेटाबेस ओपन किंवा नवीन तयार करणे
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE person(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
        );
      },
    );
    return _database!;
  }

  // डेटा जोडणे (Insert)
  static Future<void> insertPerson(Person person) async {
    final db = await getDatabase();
    await db.insert(
      'Person',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // सर्व डेटा आणणे (Read)
  static Future<List<Person>> getPerson() async {
    final db = await getDatabase();
    final List<Map<String, Object?>> dogMaps = await db.query('Person');
    return dogMaps.map((map) => Person.fromMap(map)).toList();
  }

  // डेटा अपडेट करणे (Update)
  static Future<void> updatePerson(Person person) async {
    final db = await getDatabase();
    await db.update(
      'person',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  // डेटा डिलीट करणे (Delete)
  static Future<void> deletePerson(int id) async {
    final db = await getDatabase();
    await db.delete('person', where: 'id = ?', whereArgs: [id]);
  }
}

// ----------------------------------------------------
// ३. युझर इंटरफेस (UI Screen)
// ----------------------------------------------------
class PersonListScreen extends StatefulWidget {
  const PersonListScreen({super.key});

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

class _PersonListScreenState extends State<PersonListScreen> {
  List<Person> _person = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState(); // आधीच्या कोडमधील टायपो इथे दुरुस्त केला आहे
    _refreshPersonList();
  }

  // डेटाबेस मधून नवीन लिस्ट आणून स्क्रीन अपडेट करणे
  Future<void> _refreshPersonList() async {
    final data = await DatabaseHelper.getPerson();
    setState(() {
      _person = data;
    });
  }

  // नवीन डॉग जोडण्यासाठी किंवा अपडेट करण्यासाठी फॉर्म शीट दाखवणे
  void _showForm(BuildContext context, Person? person) {
    if (person != null) {
      _nameController.text = person.name;
      _ageController.text = person.age.toString();
    } else {
      _nameController.clear();
      _ageController.clear();
    }

    showModalBottomSheet(
      context: context, // स्क्रीनचा चालू काँटेक्स्ट (यावर एरर येणार नाही)
      isScrollControlled: true,
      builder: (ctx) => Padding(
        // एरर टाळण्यासाठी इथे 'ctx' वापरला आहे
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Person Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final age = int.tryParse(_ageController.text) ?? 0;

                if (person == null) {
                  await DatabaseHelper.insertPerson(
                    Person(name: name, age: age),
                  );
                } else {
                  await DatabaseHelper.updatePerson(
                    Person(id: person.id, name: name, age: age),
                  );
                }

                // 'Don't use BuildContexts across async gaps' एरर टाळण्यासाठी ही अट आवश्यक आहे:
                if (!mounted) return;
                Navigator.of(context as BuildContext).pop();

                _refreshPersonList();
              },
              child: Text(person == null ? 'Add Person' : 'Update Person'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite Person Tracker')),
      body: _person.isEmpty
          ? const Center(child: Text('No Person registered yet.'))
          : ListView.builder(
              itemCount: _person.length,
              itemBuilder: (context, index) {
                final person = _person[index];
                return ListTile(
                  title: Text(person.name),
                  subtitle: Text('Age: ${person.age} and Id : ${person.id}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showForm(context, person),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          if (person.id != null) {
                            await DatabaseHelper.deletePerson(person.id!);
                            _refreshPersonList();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
