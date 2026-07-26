import 'package:flutter/material.dart';

//void main() {
  //runApp(const FirstOne());
//}

class FirstOne extends StatelessWidget {
  const FirstOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SecondOne(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SecondOne extends StatefulWidget {
  const SecondOne({super.key});

  @override
  State<SecondOne> createState() => _SecondOneState();
}

class _SecondOneState extends State<SecondOne> {
  String message = "Welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Welcome"),
        leading: IconButton(
          onPressed: () {
            setState(() {
              message = "Menu Icon Clicked";
            });
          },
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                message = "Wifi Icon Clicked";
              });
            },
            icon: const Icon(Icons.wifi),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                message = "Settings Icon Clicked";
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
