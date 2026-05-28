import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Shruthi(),
    debugShowCheckedModeBanner: false,
  ));
}

class Shruthi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Tuition App")),
        backgroundColor: Colors.blue,
      ),
      body: ListView( // स्क्रीनच्या बाहेर डेटा गेल्यास स्क्रोल होण्यासाठी
        padding: EdgeInsets.all(16.0),
        children: [

          // १. Theoretical Physics साठी ड्रॉपडाउन
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.menu_book, color: Colors.blue),
              title: Text("Theoretical Physics Lessons",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                buildListTile("Theoretical Physics 1", Icons.science, Colors.black),
                buildListTile("Theoretical Physics 2", Icons.bolt, Colors.orange),
                buildListTile("Theoretical Physics 3", Icons.psychology, Colors.red),
                buildListTile("Theoretical Physics 4", Icons.biotech, Colors.green),
                buildListTile("Theoretical Physics 5", Icons.lightbulb, Colors.purple),
              ],
            ),
          ),

          ListTile(
            title: Text('Stephen Hawking'),
            subtitle: Text('Physicist'),
            leading: Icon(Icons.note_alt_rounded),
            onTap: () {
              print('You clicked-Stephen Hawking');
            },
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text('Einstein'),
            subtitle: Text('Physicist'),
            leading: Icon(Icons.note_alt_rounded),
            onTap: () {
              print('You clicked-Einstein');
            },
          ),
          SizedBox(height: 20),

          ListTile(
            title: Text('Newton'),
            subtitle: Text('Physicist'),
            leading: Icon(Icons.note_alt_rounded),
            onTap: () {
              print('You clicked-Newton');
            },
          ),
          SizedBox(height: 20),
          
          // २. Problems साठी ड्रॉपडाउन
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.calculate, color: Colors.green),
              title: Text("Practice Problems",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                buildListTile("Problem Set 1", Icons.edit, Colors.black),
                buildListTile("Problem Set 2", Icons.functions, Colors.orange),
                buildListTile("Problem Set 3", Icons.architecture, Colors.red),
                buildListTile("Problem Set 4", Icons.grid_on, Colors.green),
                buildListTile("Problem Set 5", Icons.task_alt, Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ड्रॉपडाउनच्या आतील आयटम्स तयार करण्यासाठी फंक्शन
  Widget buildListTile(String title, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: () {
        // येथे तुम्ही क्लिक केल्यावर काय व्हायला हवे ते लिहू शकता
      },
    );
  }
}


