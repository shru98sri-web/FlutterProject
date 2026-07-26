import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';


void main() {
  runApp(const filepicker());
}

class filepicker extends StatelessWidget {
  const filepicker({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FilePickerDemo(),
    );
  }
}

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({super.key});

  @override
  State<FilePickerDemo> createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  String? _singleFileName;
  List<String> _multipleFileNames = [];

  // Function to pick a single file of any type
  Future<void> _pickSingleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // Options: any, media, image, video, audio, custom
    );

    if (result != null) {
      setState(() {
        _singleFileName = result.files.single.name;
      });
    } else {
      // User canceled the picker
      debugPrint("Single file picking canceled.");
    }
  }

  // Function to pick multiple files (Filtering for PDFs and Images as an example)
  Future<void> _pickMultipleFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'], // Custom extension restrictions
    );

    if (result != null) {
      setState(() {
        _multipleFileNames = result.files.map((file) => file.name).toList();
      });
    } else {
      // User canceled the picker
      debugPrint("Multiple file picking canceled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter File Picker Demo'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Single File Picker ---
            ElevatedButton.icon(
              onPressed: _pickSingleFile,
              icon: const Icon(Icons.file_upload),
              label: const Text('Pick Single File (Any Type)'),
            ),
            const SizedBox(height: 10),
            Text(
              _singleFileName != null
                  ? 'Selected File: $_singleFileName'
                  : 'No single file selected.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Divider(height: 40),

            // --- Multiple File Picker ---
            ElevatedButton.icon(
              onPressed: _pickMultipleFiles,
              icon: const Icon(Icons.file_copy),
              label: const Text('Pick Multiple Files (JPG, PNG, PDF)'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Selected Multiple Files:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: _multipleFileNames.isNotEmpty
                  ? ListView.builder(
                itemCount: _multipleFileNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
                    title: Text(_multipleFileNames[index]),
                  );
                },
              )
                  : const Center(
                child: Text('No multiple files selected.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


