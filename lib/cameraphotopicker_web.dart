import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// Import the modern, non-deprecated web standards package
import 'package:web/web.dart' as web;

// Global variable to hold available cameras
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
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

  // Modern, WASM-compatible downloder using package:web
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

      final XFile image = await _controller!.takePicture();

      setState(() {
        _savedImagePath = image.path;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Captured! Tap the thumbnail to save to your PC.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('========== CAMERA APP EXCEPTION LOG ==========');
      debugPrint('Error Object: $e');
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
      appBar: AppBar(title: const Text('Camera Web (No Deprecations)')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // 1. Live Camera Preview
                Positioned.fill(
                  child: CameraPreview(_controller!),
                ),

                // 2. Clickable Thumbnail Container
                if (_savedImagePath != null)
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: GestureDetector(
                      onTap: () => _downloadWebImage(_savedImagePath!),
                      child: Tooltip(
                        message: 'Click to download to Laptop/PC',
                        child: Container(
                          width: 100,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 8),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _savedImagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image, color: Colors.red),
                                );
                              },
                            ),
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