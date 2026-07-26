import 'package:flutter/material.dart';

class PageOne extends StatefulWidget
{
const PageOne ({super.key});

  // TODO: implement Page1
  State<PageOne> createState() => PageOneState();
}

class PageOneState extends State<PageOne>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return Scaffold(appBar: AppBar(title: Text('Page1'),backgroundColor: Colors.blueAccent,),
body: Center(
child: ElevatedButton(child: const Text('Go to Page2'),
onPressed: (){
  Navigator.push(context,MaterialPageRoute(builder: (context) => const PageTwo()));
}
),
),
backgroundColor: Colors.lime,
);
  }
}

class PageTwo extends StatefulWidget
{
  const PageTwo ({super.key});

  // TODO: implement Page1
  State<PageTwo> createState() => PageTwoState();
}

class PageTwoState extends State<PageTwo>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold (appBar: AppBar (title: Text('Page2'),backgroundColor: Colors.blueAccent,),
      body: Center(
        child: ElevatedButton(child: const Text('Go to Page2'),
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => const PageOne()));
            }
        ),
      ),
      backgroundColor: Colors.lightGreen,
    );
  }
}

//void main()
//{
//runApp(MaterialApp(home: PageOne(),debugShowCheckedModeBanner: false,));
//}
