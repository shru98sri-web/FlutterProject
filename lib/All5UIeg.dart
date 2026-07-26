import 'package:flutter/material.dart';

//void main() {
  //runApp(const MyApp());
//}

class UIeg extends StatelessWidget {
  const UIeg({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,

      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Scaffold provides the top-level structure
    return Scaffold(
      // 2. AppBar - Title
      appBar: AppBar(
        title: const Text('Top 5 UI Elements'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          children: [
            // 3. Container - Image/Placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blueGrey[100],
              margin: const EdgeInsets.all(16),
              child: const Icon(Icons.image, size: 100, color: Colors.white),
            ),

            Image.asset('images/picsart.jpg',height:100,width: double.infinity,color:Colors.blueAccent[150],),

            // 4. Text - Headings/Content
            const Text(
              'Welcome to Flutter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('This is a description of the UI elements.'),
            ),
            // 5. ElevatedButton - Interactivity
            ElevatedButton(
              onPressed: () {},
              child: const Text('Action Button'),
            ),
            // 6. ListView/ListTile - Scrollable list
            Expanded(
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.list), title: Text('Item 1')),
                  ListTile(leading: Icon(Icons.list), title: Text('Item 2')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
