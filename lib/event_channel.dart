import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Appevent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: EventChannelScreen());
  }
}

class EventChannelScreen extends StatefulWidget {
  const EventChannelScreen({super.key});

  @override
  State<EventChannelScreen> createState() => _EventChannelScreenState();
}

class _EventChannelScreenState extends State<EventChannelScreen> {
  static const EventChannel _eventChannel = EventChannel(
    'com.example.app/stream',
  );

  StreamSubscription? _streamSubscription;
  String _liveData = "No data yet. Start the stream.";
  bool _isStreaming = false;
  int _currentCount = 0; // चालू काऊंट ट्रॅक करण्यासाठी व्हेरिएबल

  void _startListening() {
    if (_isStreaming) return;

    setState(() {
      _isStreaming = true;
      _currentCount = 0; // नवीन स्ट्रीम सुरू करताना काऊंट 0 करा
    });

    _streamSubscription = _eventChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        setState(() {
          _currentCount = event as int; // नेटिव्ह कडून आलेला काऊंट सेव्ह करा
          _liveData = "Native Counter: $_currentCount";
        });
      },
      onError: (dynamic error) {
        setState(() {
          _liveData = "Error: ${error.message}";
        });
      },
      onDone: () {
        _handleStreamEnd();
      },
    );
  }

  // स्ट्रीम थांबल्यावर किंवा संपल्यावर एक्झिक्युट होणारे फंक्शन
  void _handleStreamEnd() {
    // १. टर्मिनलवर शेवटचा काऊंट प्रिंट होईल
    print("===============================");
    print("Stream Ended. Final Count: $_currentCount");
    print("===============================");

    setState(() {
      _isStreaming = false;
      // २. UI स्क्रीनवर देखील शेवटचा काऊंट डिस्प्ले होईल
      _liveData = "Stream Stopped.\nFinal Count: $_currentCount";
    });
  }

  void _stopListening() {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel(); // स्ट्रीम कॅन्सल करा
      _streamSubscription = null;
      _handleStreamEnd(); // प्रिंट आणि UI अपडेट करण्यासाठी कॉल करा
    }
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Event Channel Stream')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _liveData,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center, // दुरुस्त केलेला अलाईनमेंट
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isStreaming ? null : _startListening,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Stream'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isStreaming ? _stopListening : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Stream'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
