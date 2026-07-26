import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyAppcf extends StatelessWidget {
  const MyAppcf({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CrossPlatformFilePicker(),
    );
  }
}

class CrossPlatformFilePicker extends StatefulWidget {
  const CrossPlatformFilePicker({super.key});

  @override
  State<CrossPlatformFilePicker> createState() =>
      _CrossPlatformFilePickerState();
}

class _CrossPlatformFilePickerState extends State<CrossPlatformFilePicker> {
  PlatformFile? _pickedFile;
  Uint8List? _fileBytes; // To store bytes for Web platforms

  // 1. Pick file safely across platforms
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true, // Crucial: Ensures bytes are loaded into memory for Web
      );

      if (result != null) {
        setState(() {
          _pickedFile = result.files.first;
          _fileBytes =
              result.files.first.bytes; // Safely read file data as byte arrays
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  // 2. Open or View the File
  void _viewFile() {
    if (_pickedFile == null) return;

    // Condition A: If the file is a PDF, open it inside our integrated App Viewer
    if (_pickedFile!.extension?.toLowerCase() == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            fileBytes: _fileBytes,
            filePath: _pickedFile!.path,
            fileName: _pickedFile!.name,
          ),
        ),
      );
    }
    // Condition B: Non-PDF files (Images, Docs) on Mobile
    else if (!kIsWeb && _pickedFile!.path != null) {
      OpenFilex.open(_pickedFile!.path!);
    }
    // Condition C: Non-PDF files on Web (Browsers block local execution)
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "In-app preview for this file type is only supported for PDFs on Web.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Universal File Picker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _pickedFile != null
                  ? "Selected: ${_pickedFile!.name}"
                  : "No file picked",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text("Pick Any File"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickedFile != null ? _viewFile : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("View / Preview File"),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Independent Screen to render PDFs natively using Paths or Raw Bytes
class PDFViewerScreen extends StatelessWidget {
  final Uint8List? fileBytes;
  final String? filePath;
  final String fileName;

  const PDFViewerScreen({
    super.key,
    this.fileBytes,
    this.filePath,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: kIsWeb
          ? SfPdfViewer.memory(
              fileBytes!,
            ) // Uses in-memory binary array directly on Browsers
          : SfPdfViewer.file(
              File(filePath!),
            ), // Uses typical platform paths on Mobile devices
    );
  }
}
