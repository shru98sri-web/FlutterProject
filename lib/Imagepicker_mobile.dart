import 'dart:io'; // १. हा इंपोर्ट जोडला आहे
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
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> getImage() async {
    final selectedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      setState(() {
        _imageUrl = selectedFile.path; // लोकल फाईलचा पाथ साठवला
      });
      print("Local File Path--> $_imageUrl");
    } else {
      print('No images selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                getImage();
              },
              child: const Text('Select your image'),
            ),
            const SizedBox(height: 20),
            _imageUrl == null
                ? const Text('No image selected')
                : Image.file( // २. Image.network ऐवजी Image.file वापरले
              File(_imageUrl!),
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
            ),
          ],
        ),
      ),
    );
  }
}
