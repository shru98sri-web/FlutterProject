import 'package:flutter/material.dart';

class SwapGridImage extends StatefulWidget {
  @override
  _SwapGridImageState createState() => _SwapGridImageState();
}

class _SwapGridImageState extends State<SwapGridImage> {
  // 1. Initial images
  List<String> images = [
    'assets/andal.jpg',
    'assets/birthday.jpg',
    'assets/picsart.jpg',
    'assets/Screenshot.png',
  ];

  String newImage = 'assets/unnamed.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tap Image to Swap")),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 4-grid (2x2)
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // 2. Swap logic
              setState(() {
                images[index] = newImage;
              });
            },
            child: Container(
              color: Colors.grey[300],
              child: Image.asset(images[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
