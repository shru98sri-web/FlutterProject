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
  // इमेजची URL किंवा पाथ स्ट्रिंग स्वरूपात साठवण्यासाठी
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> getImage() async {
    // गॅलरीमधून इमेज निवडणे
    final selectedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      setState(() {
        // selectedFile.path हा स्ट्रिंग फॉरमॅटमध्ये असतो
        // (टीप: वेबवर किंवा काही विशिष्ट सर्व्हर केसेसमध्ये Image.network थेट चालते)
        _imageUrl = selectedFile.path;
      });
      print("Network Path--> $_imageUrl");
    } else {
      print('No images selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Network Example'),
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
            // इमेज दाखवण्यासाठी Image.network चा वापर
            _imageUrl == null
                ? const Text('No image selected')
                : Image.network(
              _imageUrl!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              // इमेज लोड होताना एरर आल्यास (कारण हा लोकल पाथ असू शकतो) एरर हँडलर
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'Unable to load as Network Image\n(Needs valid URL)',
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


