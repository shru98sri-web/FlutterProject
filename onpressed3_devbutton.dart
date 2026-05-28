import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:group_button/group_button.dart';



void main() {
  runApp(const FirstOne());
}

class FirstOne extends StatelessWidget {
  const FirstOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SecondOne(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SecondOne extends StatefulWidget {
  const SecondOne({super.key});

  @override
  State<SecondOne> createState() => _SecondOneState();
}

class _SecondOneState extends State<SecondOne> {
  String message = "Welcome";
  String image1= 'https://www.build-electronic-circuits.com/wp-content/uploads/2013/11/LDR-circuit-improved.png';
  String image2='https://media.istockphoto.com/id/1328153839/vector/electric-circuitry.jpg?s=612x612&w=0&k=20&c=whLpsntHETkxTr38GSQYv8QaAPcSl028iR9QXaAuuZE=';
  String image3='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPCdf5K49YHBsRp1ZToaM1ztpi4WrH-r55cw&s';

  void _updateMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Tuition App"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _updateMessage("Menu Icon Clicked"),
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () => _updateMessage("Book Icon Clicked"),
            icon: const Icon(Icons.book),
          ),
          IconButton(
            onPressed: () => _updateMessage("Settings Icon Clicked"),
            icon: const Icon(Icons.settings),
          ),
    IconButton(
          onPressed: () => _updateMessage("Laptop icon CLicked"),
          icon: const Icon(Icons.laptop),
        ),
          RoundCheckBox(
            onTap: (selected) {},),

      ]),
      body: Center(
        child:Padding(
          padding:const EdgeInsets.all(8.0),
          child:Column(
            children:[
              SizedBox(height:20,),
              Text('Program'),
              SizedBox(height:20,),
              TextField(
                decoration:InputDecoration(
                  border:OutlineInputBorder(),
                  hintText:"Enter first number",
                ),
              ),
              SizedBox(height:20),
              TextField(
                  decoration:InputDecoration(
                    border:OutlineInputBorder(),
                    hintText:"Enter second number",
                  )
              ),
              SizedBox(height:20),
              ElevatedButton(onPressed:(){
                print('button clicked');
              },child:Text('Click Me')),
              IconButton(
                icon: Image.network(image1,height:250,width:250,),
                iconSize: 250,
                onPressed: () {
                  setState(() {
                    icon:
                    print('Image1 clicked');
                    image1= image2;
                  },);
                },
                  onLongPress:() {
                setState(() {
                  icon:Image.network(image2,height:250,width:250,);
                  print('Image2 clicked');
                  image2= image3;
                },);
                onPressed() {
                  setState(() {
                    icon:Image.network(image3,height:250,width:250,);
                    print('Image3 clicked');
                    image3= image1;
                  },);
      };


                }
              ),
              GroupButton<DateTime>(
                buttons: [DateTime(2026, 5, 16,01,01,36,1234), DateTime(2026, 5, 17,05,05,36,1254)],
              )


            ],
        ),
      ),
      )
    );


  }
}