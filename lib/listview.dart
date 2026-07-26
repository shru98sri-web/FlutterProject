import 'package:flutter/material.dart';
import 'package:untitled1/Navigation.dart';

//void main()
//{runApp(const MaterialApp(home:SimpleListExample()));
//}

class SimpleListExample extends StatelessWidget
{
  const SimpleListExample({super.key});

  @override
  Widget build(BuildContext context){
    final List<String> items = List<String>.generate(10,(i) =>"Item ${i+1}");
    return Scaffold(
      appBar:AppBar(title:const Text('ListView.builder Example')),
      body:ListView.builder(
      itemCount:items.length,
      itemBuilder:(context,index){
        return ListTile(
          leading: const Icon(Icons.label),
          title:Text(items[index]),
          onTap: () => print('Tapped on ${items[index]}'),

        );
      },
    ),

    );
  }
}