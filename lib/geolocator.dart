import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Current Location',
      debugShowCheckedModeBanner: false,
      home: const LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String latitude = "";
  String longitude = "";
  String message = "Press the button to fetch location";

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          message = "Location service is disabled";
        });
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          message = "Location permission denied";
        });
        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        setState(() {
          message =
          "Location permission permanently denied";
        });
        return;
      }

      Position position =
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        message = "Location fetched successfully";
      });
    } catch (e) {
      setState(() {
        message = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Current Location"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              Text(
                "Latitude: $latitude",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                "Longitude: $longitude",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: getCurrentLocation,
                child: const Text(
                  "Get Current Location",
                ),
              ),

              const SizedBox(height: 15),

              // 5. Button to Launch External Maps App (Bugs Fixed Here)
              ElevatedButton.icon(
                // The button stays disabled (null) until valid coordinates are present
                onPressed: (latitude.isNotEmpty && longitude.isNotEmpty)
                    ? () {
                  MapsLauncher.launchCoordinates(
                    double.parse(latitude),   // Converted String to double safely
                    double.parse(longitude),  // Converted String to double safely
                  );
                }
                    : null,
                icon: const Icon(Icons.map),
                label: const Text('Open via Coordinates'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
      ),
      ));
  }
}