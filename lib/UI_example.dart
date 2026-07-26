import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

void main() {
  runApp(const MaterialApp(
    home: UI5(),
    debugShowCheckedModeBanner: false,
  ));
}

// Setting state
class UI5 extends StatefulWidget {
  const UI5({super.key});

  @override
  State<UI5> createState() => _UI5State();
}

class _UI5State extends State<UI5> {
  final TextEditingController _iController = TextEditingController();
  String classNumberStatus = "0"; // String status variable

  void _checkInput() {
    double? number = double.tryParse(_iController.text);
    setState(() {
      if (number != null && number != 0) {
        classNumberStatus = number.toString();
        print('Class Number is: $classNumberStatus');
      } else {
        classNumberStatus = "Invalid Input";
      }
    });
  }

  @override
  void dispose() {
    _iController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tuition App"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      // Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              subtitle: const Text("Home Screen"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              subtitle: const Text("Settings Screen"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Settings Clicked!")),
                );
              },
            ),
          ],
        ),
      ),
      // 3.Using UI components


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField
              TextField(
                controller: _iController,
                keyboardType: TextInputType.number,
                onChanged: (value) => _checkInput(),
                decoration: const InputDecoration(
                  labelText: "Class Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Status: $classNumberStatus",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "Theory Lessons:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              buildTheoryRow(context, Icons.science, "Theoretical Physics 1", Colors.black),
              buildTheoryRow(context, Icons.icecream, "Theoretical Physics 2", Colors.orange),
              buildTheoryRow(context, Icons.psychology, "Theoretical Physics 3", Colors.red),
              const SizedBox(height: 30),
              const Text(
                "Practice Problems:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildProblemItem(context, Icons.calculate, "Prob 1", Colors.black),
                    buildProblemItem(context, Icons.edit, "Prob 2", Colors.orange),
                    buildProblemItem(context, Icons.functions, "Prob 3", Colors.red),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'images/Screenshot.png',
                  height: 250,
                  width: 250,
                  errorBuilder: (context, error, stackTrace) {
                    return const Column(
                      children: [
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        Text('Image not found in assets', style: TextStyle(color: Colors.red)),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),


              Center(
                child: ElevatedButton(
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Class joined Successfully!',
                    );
                  },
                  child: const Text('Join Class'),

                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(onPressed: () { print('Showing Alert');
                showAlertDialog(context);},
                    child: Text('Show Alert')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert Title'),
          content: const Text('This is a simple alert message.'),
          actions: [
            TextButton(
              onPressed: () {
                print('Alert Button Clicked');
                Navigator.of(context).pop(); // Closes the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  Widget buildTheoryRow(BuildContext context, IconData icon, String text, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening $text..."), backgroundColor: color),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(text, style: TextStyle(color: color, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget buildProblemItem(BuildContext context, IconData icon, String text, Color color) {
    return GestureDetector(
      onTap: () {
        print("$text selected");
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            Text(text, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
