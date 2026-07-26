import 'package:flutter/material.dart';

//void main() {
  //runApp(MaterialApp(
    //home: Shruthi(),
    //debugShowCheckedModeBanner: false,
  //));
//}

class Listcard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Tuition App")),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [


          // १. Theoretical Physics विभाग
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.menu_book, color: Colors.blue),
              title: Text("Theoretical Physics Lessons",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                // येथे तुम्ही टेक्स्ट टाकू शकता
                buildTextEntry("Physics 1: Newton's Laws", "An object at rest stays at rest, and an object in motion stays in motion with the same speed and in a straight line unless acted upon by an external unbalanced force."),
                buildTextEntry("Physics 2: Thermodynamics", "Energy cannot be created or destroyed, only transferred or transformed."),
              ],
            ),
          ),

          SizedBox(height: 20),

          // २. Practice Problems विभाग
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.calculate, color: Colors.green),
              title: Text("Practice Problems",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                buildTextEntry("Problem Set 1", "The force acting on the bat for a ball of mass 0.25kg and speed 10m/s is..."),
                buildTextEntry("Problem Set 2", "Calculate work done by the gas for 1.5moles of ideal gas..."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // टेक्स्ट एन्ट्री दाखवण्यासाठी फंक्शन
  Widget buildTextEntry(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text(description, style: TextStyle(color: Colors.grey[700])),
          Divider(), // दोन ओळींमध्ये रेघ ओढण्यासाठी
        ],
      ),
    );
  }
}