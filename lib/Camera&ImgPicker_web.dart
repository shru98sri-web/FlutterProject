import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

// Safe web import
import 'package:web/web.dart' as web;

// Global variable to hold available device cameras
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Camera initialization error: $e');
  }
  runApp(const CombinedApp());
}

class CombinedApp extends StatelessWidget {
  const CombinedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Toolbox',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainTabScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Combined Media App'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.photo_library), text: 'Picker Component'),
              Tab(icon: Icon(Icons.camera_alt), text: 'Live Camera View'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(), // Prevents swipe conflicts during live camera streams
          children: [
            ImagePickerScreen(),
            CameraStartPage(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1. IMAGE PICKER MODULE
// ==========================================
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
        _imageUrl = selectedFile.path;
      });
      debugPrint("Selected Media Path--> $_imageUrl");
    } else {
      debugPrint('No images selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: getImage,
              icon: const Icon(Icons.image_search),
              label: const Text('Select your image'),
            ),
            const SizedBox(height: 20),
            _imageUrl == null
                ? const Text('No image selected')
                : SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? Image.network(
                  _imageUrl!,
                  fit: BoxFit.cover,
                )
                    : Image.file(
                  File(_imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. LIVE CAMERA & CAPTURE MODULE
// ==========================================
class CameraStartPage extends StatefulWidget {
  const CameraStartPage({super.key});

  @override
  State<CameraStartPage> createState() => _CameraStartPageState();
}

class _CameraStartPageState extends State<CameraStartPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _downloadWebImage(String blobUrl) {
    final web.HTMLAnchorElement anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = blobUrl;
    anchor.download = 'captured_photo_${DateTime.now().millisecondsSinceEpoch}.png';

    web.document.body!.appendChild(anchor);
    anchor.click();
    web.document.body!.removeChild(anchor);
  }

  Future<void> _takeAndSavePhoto() async {
    try {
      await _initializeControllerFuture;
      if (_controller == null || !_controller!.value.isInitialized) return;

      final XFile image = await _controller!.takePicture();

      setState(() {
        _savedImagePath = image.path;
      });

      if (mounted) {
        final notice = kIsWeb ? 'Tap thumbnail to download.' : 'Photo captured temporary!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(notice), duration: const Duration(seconds: 2)),
        );
      }
    } catch (e) {
      debugPrint('Camera capture exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameras.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No operational camera found.')),
      );
    }

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(_controller!),
                ),
                if (_savedImagePath != null)
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: GestureDetector(
                      onTap: () {
                        if (kIsWeb) {
                          _downloadWebImage(_savedImagePath!);
                        }
                      },
                      child: Tooltip(
                        message: kIsWeb ? 'Click to download file' : 'Captured Preview',
                        child: Container(
                          width: 100,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: kIsWeb
                                ? Image.network(_savedImagePath!, fit: BoxFit.cover)
                                : Image.file(File(_savedImagePath!), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeAndSavePhoto,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}