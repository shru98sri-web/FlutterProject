import'package:flutter/material.dart';
//void main()
//{
  //runApp(FirstOne());
//}
  class FirstOnprs extends StatelessWidget{
    const FirstOnprs({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home:SecondOnprs(),
  debugShowCheckedModeBanner: false,
    );
  }
}

class SecondOnprs extends StatefulWidget
{const SecondOnprs({super.key});

  @override
  State<SecondOnprs> createState() =>_SecondOnprsState();
    // TODO: implement createState

  }

class _SecondOnprsState extends State<SecondOnprs>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return Scaffold(
  appBar: AppBar(backgroundColor: Colors.orange,title: Text("Welcome"),leading:IconButton(onPressed: (){print('icon button clicked');},icon:Icon(Icons.menu)),
    actions:[
      IconButton(onPressed: ()=>{print('wifi button clicked')}, icon: Icon(Icons.wifi)),
      IconButton(onPressed: ()=>{print('setting button clicked')}, icon: Icon(Icons.settings)),
    ],
),
  body: Center(
    child:Text('Welcome'),
  ),
);
}
}

