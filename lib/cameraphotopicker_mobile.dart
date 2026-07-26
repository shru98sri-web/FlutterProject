import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';//import gal instead of gallery_saver

// Global variable to hold available camera
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Camera not available: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CameraStartPage(),
    );
  }
}

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
      _initializeControllerFuture = _initializeCamera(cameras.first);
    }
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );
    try {
      await _controller!.initialize();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // 2. Corrected function to save photo to gallery using 'gal'
  Future<void> _saveImageToGallery(String imagePath) async {
    try {
      // Check or request gallery access permission
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        await Gal.requestAccess();
      }

      // Save the image into the local system gallery
      await Gal.putImage(imagePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo successfully saved to gallery!')),
        );
      }
    } catch (e) {
      debugPrint('Gallery save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $e')),
        );
      }
    }
  }

  Future<void> _takeAndSavePhoto() async {
    try {
      await _initializeControllerFuture;

      if (_controller == null || !_controller!.value.isInitialized) {
        return;
      }

      final XFile image = await _controller!.takePicture();

      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final File localImage = await File(image.path).copy(filePath);

      setState(() {
        _savedImagePath = localImage.path;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo captured!Tap the thumbnail to save to your gallery.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameras.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No camera found on this device.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera App(Mobile)')),
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
                      onTap: () => _saveImageToGallery(_savedImagePath!),
                      child: Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_savedImagePath!),
                            fit: BoxFit.cover,
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
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
