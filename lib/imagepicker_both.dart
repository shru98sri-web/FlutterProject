import 'dart:io';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const Imagepick());
}

class Imagepick extends StatelessWidget {
  const Imagepick({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImagePickerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  String? _imagePath;
  Uint8List? _webImageBytes;

  final ImagePicker _picker = ImagePicker();

  Future<void> getImage() async {
    final selectedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      if (kIsWeb) {
        final bytes = await selectedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _imagePath = selectedFile.path;
        });
        print("Web Image Loaded Successfully");
      } else {
        setState(() {
          _imagePath = selectedFile.path;
        });
        print("Mobile Local Path--> $_imagePath");
      }
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universal Image Picker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: getImage,
              child: const Text('Select your image'),
            ),
            const SizedBox(height: 20),
            _buildImageWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (kIsWeb) {
      //  Image.memory
      return _webImageBytes == null
          ? const Text('No image selected')
          : Image.memory(
        _webImageBytes!,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      // Image.file
      return _imagePath == null
          ? const Text('No image selected')
          : Image.file(
        File(_imagePath!),
        width: 150,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Text(
            'Unable to load image',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          );
        },
      );
    }
  }
}
