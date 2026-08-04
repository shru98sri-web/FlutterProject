import 'package:flutter/material.dart';

void main() {
  runApp(first());
}

class first extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: Event(), debugShowCheckedModeBanner: false);
  }
}

class Event extends StatefulWidget {
  const Event({super.key});
  @override
  State<Event> createState() => EventState();
  // TODO: implement createState
}

class EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('EventManagement App'),
        centerTitle: true,
        backgroundColor: Colors.lime,
      ),
      body: Column(
        children: [
          Container(
            width: 1100,
            height: 200,
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0, // Controls shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                // Rounded corners
              ),
            ),
          ),
          Container(
            width: 1100,
            height: 200,
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0, // Controls shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
            ),
          ),
          Container(
            width: 1100,
            height: 200,
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0, // Controls shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
            ),
          ),
          Container(
            width: 1100,
            height: 200,
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0, // Controls shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
            ),
          ),
        ],
      ),
    );
  }
}
