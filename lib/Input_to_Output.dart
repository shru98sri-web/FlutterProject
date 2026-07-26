import 'package:flutter/material.dart';

//void main() {
  //runApp(MaterialApp(
    //home: TextOutputScreen(),
    //debugShowCheckedModeBanner: false,
  //));
//}

class TextOutputScreen extends StatefulWidget {
  @override
  _TextOutputScreenState createState() => _TextOutputScreenState();
}

class _TextOutputScreenState extends State<TextOutputScreen> {
  // १. इनपुट कंट्रोल करण्यासाठी कंट्रोलर
  final TextEditingController _myController = TextEditingController();

  // २. आउटपुट साठवण्यासाठी व्हेरिएबल
  String _outputValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input to Output Example"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ३. टेक्स्ट इनपुट बॉक्स
            TextField(
              controller: _myController,
              decoration: InputDecoration(
                hintText: "Input is ...",
                labelText: "Input",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // ४. इनपुट आउटपुटमध्ये दाखवण्यासाठी बटन
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _outputValue = _myController.text; // इनपुट व्हॅल्यू आउटपुटला देणे
                });
              },
              child: Text("Display Output"),
            ),

            SizedBox(height: 40),

            // ५. आउटपुट रिझल्ट सेक्शन
            Text(
              "Output:",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              _outputValue,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}