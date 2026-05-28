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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theoretical Physics Section
            Text("Theory Lessons:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            buildTheoryRow(Icons.science, "Theoretical Physics 1", Colors.black),
            buildTheoryRow(Icons.book, "Theoretical Physics 2", Colors.orange),
            buildTheoryRow(Icons.psychology, "Theoretical Physics 3", Colors.red),
            buildTheoryRow(Icons.biotech, "Theoretical Physics 4", Colors.green),
            buildTheoryRow(Icons.lightbulb, "Theoretical Physics 5",Colors.deepPurple),


            SizedBox(height: 30),
            // Problems Section
            Text("Practice Problems:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildProblemItem(Icons.calculate, "Prob 1", Colors.black),
                  buildProblemItem(Icons.edit, "Prob 2", Colors.orange),
                  buildProblemItem(Icons.functions, "Prob 3", Colors.red),
                  buildProblemItem(Icons.grid_on, "Prob 4", Colors.green),
                  buildProblemItem(Icons.task_alt, "Prob 5", Colors.deepPurple),
                  Image.asset('images/picsart.jpg',height:100,width: 100,),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Theory साठी मदतनीस (Helper) फंक्शन
  Widget buildTheoryRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Text(text, style: TextStyle(color: color, fontSize: 16)),
        ],
      ),
    );
  }

  // Problems साठी मदतनीस (Helper) फंक्शन
  Widget buildProblemItem(IconData icon, String text, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

