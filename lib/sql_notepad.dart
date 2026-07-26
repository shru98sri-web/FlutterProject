import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const NotepadApp());
}

// 1. Database Model
class Note {
  int? id;
  String title;
  String content;

  Note({this.id, required this.title, required this.content});

  factory Note.fromMap(Map<String, dynamic> json) =>
      Note(id: json['id'], title: json['title'], content: json['content']);

  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'title': title, 'content': content};
  }
}

// 2. Local Database SQLite Helper
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT
      )
    ''');
  }

  Future<int> create(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'id DESC');
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}

// 3. User Interface Layer
class NotepadApp extends StatelessWidget {
  const NotepadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Split-Screen Notepad',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo,
        useMaterial3: true,
      ),
      home: const NotepadHome(),
    );
  }
}

class NotepadHome extends StatefulWidget {
  const NotepadHome({super.key});

  @override
  State<NotepadHome> createState() => _NotepadHomeState();
}

class _NotepadHomeState extends State<NotepadHome> {
  List<Note> notes = [];
  Note? selectedNote;
  bool isLoading = true;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshNotes();
    titleController.addListener(_onTextChanged);
    contentController.addListener(_onTextChanged);
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await DatabaseHelper.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  void _onTextChanged() async {
    if (selectedNote != null) {
      selectedNote!.title = titleController.text;
      selectedNote!.content = contentController.text;

      await DatabaseHelper.instance.update(selectedNote!);
      final updatedNotes = await DatabaseHelper.instance.readAllNotes();
      setState(() {
        notes = updatedNotes;
      });
    }
  }

  void selectNote(Note note) {
    setState(() {
      selectedNote = note;
      titleController.text = note.title;
      contentController.text = note.content;
    });
  }

  Future<void> _addNewNote() async {
    final newNote = Note(title: 'New Note', content: '');
    final id = await DatabaseHelper.instance.create(newNote);
    newNote.id = id;

    await refreshNotes();
    selectNote(notes.firstWhere((note) => note.id == id));
  }

  Future<void> _deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      selectedNote = null;
      titleController.clear();
      contentController.clear();
    });
    refreshNotes();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Split Screen Notepad Workspace'),
        backgroundColor: Colors.indigo.shade50,
        actions: [
          ElevatedButton.icon(
            onPressed: _addNewNote,
            icon: const Icon(Icons.add),
            label: const Text('New Note'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // ================= LEFT SIDE PANEL (NOTES LIST) =================
          Expanded(
            flex: 1, // 50% screen width allocation
            child: Container(
              color: Colors.grey.shade100,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notes.isEmpty
                  ? const Center(child: Text('Your workspace is empty.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: notes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        final isSelected = selectedNote?.id == note.id;
                        return Card(
                          elevation: isSelected ? 4 : 0,
                          color: isSelected
                              ? Colors.indigo.shade50
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.indigo
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              note.title.isEmpty ? 'Untitled Note' : note.title,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.indigo.shade900
                                    : Colors.black87,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                note.content.isEmpty
                                    ? 'No additional text'
                                    : note.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _deleteNote(note.id!),
                            ),
                            onTap: () => selectNote(note),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Physical Center Dividing Border line
          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),

          // ================= RIGHT SIDE PANEL (EDITOR TEXTFIELD) =================
          Expanded(
            flex: 1, // Remaining 50% screen width allocation
            child: selectedNote == null
                ? Container(
                    color: Colors.white,
                    child: const Center(
                      child: Text(
                        'Select a note from the left panel to begin editing.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter Note Title...',
                            border: InputBorder.none,
                          ),
                        ),
                        const Divider(height: 20, thickness: 1),
                        Expanded(
                          child: TextField(
                            controller: contentController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                            decoration: const InputDecoration(
                              hintText: 'Type your content details here...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
