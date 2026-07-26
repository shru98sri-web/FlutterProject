import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

void main() {
  runApp(const MyAppfp());
}

class MyAppfp extends StatelessWidget {
  const MyAppfp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FilePickerViewerScreen(),
    );
  }
}

class FilePickerViewerScreen extends StatefulWidget {
  const FilePickerViewerScreen({super.key});

  @override
  State<FilePickerViewerScreen> createState() => _FilePickerViewerScreenState();
}

class _FilePickerViewerScreenState extends State<FilePickerViewerScreen> {
  File? _selectedFile;
  String _fileName = "No file selected";

  // 1. Function to pick a file
  Future<void> _pickFile() async {
    try {
      // You can choose single, multiple, or specific extensions (e.g., only PDF)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Use 'any' for all file types
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _fileName = result.files.single.name;
        });
      } else {
        // User canceled the picker
        debugPrint("User canceled file selection.");
      }
    } catch (e) {
      debugPrint("Error while picking file: $e");
    }
  }

  // 2. Function to view/open the file
  Future<void> _viewFile() async {
    if (_selectedFile != null) {
      // open_filex opens the file using the appropriate default app on the device
      final result = await OpenFilex.open(_selectedFile!.path);
      debugPrint("Open result: ${result.message}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a file first!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File Picker & Viewer"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.insert_drive_file, size: 80, color: Colors.blue),
              const SizedBox(height: 20),

              // Displays the name of the selected file
              Text(
                _fileName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Button to select a file
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.file_upload),
                label: const Text("Upload / Select File"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
              const SizedBox(height: 15),

              // Button to view the file
              ElevatedButton.icon(
                onPressed: _selectedFile != null
                    ? _viewFile
                    : null, // Button remains disabled if no file is selected
                icon: const Icon(Icons.remove_red_eye),
                label: const Text("View File"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
