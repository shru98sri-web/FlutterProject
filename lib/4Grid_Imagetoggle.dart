import 'package:flutter/material.dart';

//void main() {
  //runApp(const MyApp());
//}
import 'package:flutter/cupertino.dart';

class Grid extends StatelessWidget {
  const Grid({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GridImageToggle(),
    );
  }
}

class GridImageToggle extends StatefulWidget {
  const GridImageToggle({super.key});

  @override
  State<GridImageToggle> createState() => _GridImageToggleState();
}

class _GridImageToggleState extends State<GridImageToggle> {

  // List to store image toggle state
  List<bool> isChanged = [true, true, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grid Image Toggle"),
        centerTitle: true,
        backgroundColor: Colors.blue,

      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: 4,

          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),

          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset('images/picsart.jpg',height:100,width: 100,),

                // Image Container
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: Image.asset(
                        isChanged[index]
                            ? "images/imagetobeadded.jpg"
                            : "images/picsart.jpg",
                        fit: BoxFit.cover,



                      ),

                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isChanged[index] = !isChanged[index];
                    });
                  },

                  child: const Text("Change Image"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}