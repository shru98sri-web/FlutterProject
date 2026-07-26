import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const NotepadApp());
}

// 1. Note Data Model
class Note {
  int? id;
  String title;
  String content;
  String modifiedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.modifiedAt,
  });

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    modifiedAt: json['modifiedAt'] ?? '',
  );

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'modifiedAt': modifiedAt,
    };
  }
}

// 2. Database Helper
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_v3.db');
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
        content TEXT,
        modifiedAt TEXT
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

// 3. Main Application UI
class NotepadApp extends StatelessWidget {
  const NotepadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Split Notepad',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
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

  // Structural State Toggles
  bool isGridView = false;
  bool isBold = false;
  bool isItalic = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await DatabaseHelper.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  void _saveCurrentNote() async {
    if (selectedNote != null) {
      final now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
      selectedNote!.title = titleController.text;
      selectedNote!.content = contentController.text;
      selectedNote!.modifiedAt = now;

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
    final now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    final newNote = Note(title: 'New Note', content: '', modifiedAt: now);
    final id = await DatabaseHelper.instance.create(newNote);
    newNote.id = id;

    await refreshNotes();
    selectNote(notes.firstWhere((note) => note.id == id));
  }

  Future<void> _deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      if (selectedNote?.id == id) {
        selectedNote = null;
        titleController.clear();
        contentController.clear();
      }
    });
    refreshNotes();
  }

  void _insertFormatting(String type) {
    if (selectedNote == null) return;

    final text = contentController.text;
    final selection = contentController.selection;
    String insertText = type == 'bullet' ? '\n• ' : '\n1. ';

    int insertionIndex = selection.isValid ? selection.start : text.length;
    final newText = text.replaceRange(
      insertionIndex,
      insertionIndex,
      insertText,
    );

    contentController.text = newText;
    contentController.selection = TextSelection.collapsed(
      offset: insertionIndex + insertText.length,
    );

    _saveCurrentNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: isGridView ? 'Switch to List View' : 'Switch to Grid View',
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Create New Note',
            onPressed: _addNewNote,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Left Half Pane Viewport
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade50,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notes.isEmpty
                  ? const Center(child: Text('No Concepts Logged.'))
                  : isGridView
                  ? _buildGridView()
                  : _buildListView(),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          // Right Half Native Editor Core
          Expanded(
            flex: 3,
            child: selectedNote == null
                ? const Center(
                    child: Text(
                      'Select or instantiate a note to begin modification.',
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tooling Bar
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.format_list_bulleted),
                              tooltip: 'Insert Bullet List',
                              onPressed: () => _insertFormatting('bullet'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.format_list_numbered),
                              tooltip: 'Insert Numbered List',
                              onPressed: () => _insertFormatting('number'),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.format_bold,
                                color: isBold ? Colors.blue : null,
                              ),
                              tooltip: 'Toggle Bold Style',
                              onPressed: () => setState(() => isBold = !isBold),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.format_italic,
                                color: isItalic ? Colors.blue : null,
                              ),
                              tooltip: 'Toggle Italic Style',
                              onPressed: () =>
                                  setState(() => isItalic = !isItalic),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: _saveCurrentNote,
                              icon: const Icon(Icons.cloud_upload_outlined),
                              label: const Text('Save State'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Last edited: ${selectedNote!.modifiedAt}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        TextField(
                          controller: titleController,
                          onChanged: (_) => _saveCurrentNote(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter Note Title...',
                            border: InputBorder.none,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: contentController,
                            onChanged: (_) => _saveCurrentNote(),
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: TextStyle(
                              fontWeight: isBold
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontStyle: isItalic
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Start writing your concepts here...',
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

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        final isSelected = selectedNote?.id == note.id;
        return ListTile(
          selected: isSelected,
          selectedTileColor: Colors.blue.withAlpha(25),
          title: Text(
            note.title.isEmpty ? 'Untitled Note' : note.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${note.modifiedAt}\n${note.content.trim().isEmpty ? '[Empty Body]' : note.content}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          isThreeLine: true,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: 'Delete Note',
            onPressed: () => _deleteNote(note.id!),
          ),
          onTap: () => selectNote(note),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        final isSelected = selectedNote?.id == note.id;
        return InkWell(
          onTap: () => selectNote(note),
          child: Card(
            elevation: isSelected ? 4 : 1,
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          note.title.isEmpty ? 'Untitled Note' : note.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _deleteNote(note.id!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    note.modifiedAt,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                  const Divider(height: 12),
                  Expanded(
                    child: Text(
                      note.content.trim().isEmpty
                          ? '[Empty Body]'
                          : note.content,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
