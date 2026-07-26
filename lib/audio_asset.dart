import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Appauda extends StatelessWidget {
  const Appauda({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AssetAudioPlayerScreen(),
    );
  }
}

class AssetAudioPlayerScreen extends StatefulWidget {
  const AssetAudioPlayerScreen({super.key});

  @override
  State<AssetAudioPlayerScreen> createState() => _AssetAudioPlayerScreenState();
}

class _AssetAudioPlayerScreenState extends State<AssetAudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAssetAudio();
  }

  // Load the audio file from the assets folder
  Future<void> _initAssetAudio() async {
    try {
      setState(() => _isLoading = true);

      // ✅ Using local 'setAsset' instead of network 'setUrl'
      await _audioPlayer.setAsset('audio/song.mp3');

      setState(() => _isLoading = false);

      // Listen to player state changes
      _audioPlayer.playerStateStream.listen((playerState) {
        if (mounted) {
          setState(() {
            _isPlaying = playerState.playing;
          });
        }

        // Reset to the beginning and pause when the song finishes
        if (playerState.processingState == ProcessingState.completed) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error loading asset file: $e");
    }
  }

  // Core play and pause toggle function
  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }

    setState(() {
      _isPlaying = _audioPlayer.playing;
    });
  }

  @override
  void dispose() {
    // Release system memory resources when the screen is closed
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Asset Audio Player'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Music icon changes based on state
            Icon(
              _isPlaying ? Icons.music_note : Icons.music_off,
              size: 120,
              color: _isPlaying ? Colors.deepPurple : Colors.grey,
            ),
            const SizedBox(height: 30),

            // Progress tracking timeline slider
            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _audioPlayer.duration ?? Duration.zero;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Slider(
                        activeColor: Colors.deepPurple,
                        inactiveColor: Colors.grey.shade300,
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                        value: position.inMilliseconds.toDouble().clamp(
                          0.0,
                          duration.inMilliseconds.toDouble(),
                        ),
                        onChanged: (value) {
                          _audioPlayer.seek(
                            Duration(milliseconds: value.toInt()),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Play / Pause button trigger
            _isLoading
                ? const CircularProgressIndicator(color: Colors.deepPurple)
                : InkWell(
                    onTap: _togglePlayPause,
                    borderRadius: BorderRadius.circular(50),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Format Helper: Converts Timestamp Duration to MM:SS structures
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
