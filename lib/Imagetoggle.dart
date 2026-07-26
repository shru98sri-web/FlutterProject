import 'package:flutter/material.dart';

//void main() {
  //runApp(const MyApp());
//}

class Imagetoggle extends StatelessWidget {
  const Imagetoggle({super.key});

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
  int changedCount = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grid Image Toggle One by One"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () {print('icon button clicked');}, icon: Icon(Icons.menu)),
      actions: [IconButton(onPressed: () {print('search button clicked');}, icon: Icon(Icons.search)),
      IconButton(onPressed: () {print('setting button clicked');}, icon: Icon(Icons.settings)),
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset("images/picsart.jpg",height: 150,width: 150,),
            Text("Image"),
            const SizedBox(height: 15),
            // Important signal button
            SizedBox(
              width: double.infinity,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (changedCount < 4) {
                      changedCount++;
                    } else {
                      changedCount = 0;
                    }

                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  changedCount < 4 ? "Change Next Image" : "Reset Grid",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  bool isChanged = index < changedCount;

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: isChanged ?
                        Image.asset("images/picsart.jpg" ,
                          fit: BoxFit.cover,height: 100,width:100,
                      )
                            : SizedBox.square(),
                      //Image.asset("images/imgtobeadded.jpg",width: 100,height: 100,),

                    ),  //A widget that clips its child using a rounded rectangle
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
