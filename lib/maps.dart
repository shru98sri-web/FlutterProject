import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Open Native Maps')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Strategy A: Open using a text description/address
              ElevatedButton(
                onPressed: () => MapsLauncher.launchQuery(
                  'Boopathy Nagar,Keelkatalai,Chennai 600 117',
                ),
                child: const Text('Open via Address'),
              ),
              const SizedBox(height: 20),

              // Strategy B: Open using exact GPS coordinates
              ElevatedButton(
                onPressed: () => MapsLauncher.launchCoordinates(
                  12.951618,
                  80.1904809,
                ),
                child: const Text('Open via Coordinates'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
