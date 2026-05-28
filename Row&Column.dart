import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Shruthi(),
    debugShowCheckedModeBanner: false, // कोपऱ्यातील लाल पट्टी काढण्यासाठी
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Theoretical Physics ची यादी (Vertical)
          Text("Theoretical Physics1"),
          SizedBox(height: 10),
          Text("Theoretical Physics2", style: TextStyle(color: Colors.orange)),
          SizedBox(height: 10),
          Text("Theoretical Physics3", style: TextStyle(color: Colors.red)),
          SizedBox(height: 10),
          Text("Theoretical Physics4", style: TextStyle(color: Colors.green)),
          SizedBox(height: 10),
          Text("Theoretical Physics5", style: TextStyle(color: Colors.deepPurple)),

          SizedBox(height: 30), // Column आणि Row मध्ये अंतर ठेवण्यासाठी

          // Problems ची यादी (Horizontal)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // जर स्क्रीन लहान असेल तर आडवे स्क्रोल करण्यासाठी
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Problem1"),
                SizedBox(width: 10),
                Text("Problem2", style: TextStyle(color: Colors.orange)),
                SizedBox(width: 10),
                Text("Problem3", style: TextStyle(color: Colors.red)),
                SizedBox(width: 10),
                Text("Problem4", style: TextStyle(color: Colors.green)),
                SizedBox(width: 10),
                Text("Problem5", style: TextStyle(color: Colors.deepPurple)),
                Image.asset('images/birthday.jpg',height:100,width: 100,),

              ],
            ),
          ),
        ],

      ),
    );
  }
}