import 'package:flutter/material.dart';
//void main()
//{
  //runApp(const MaterialApp(home: ListScreen()));
//}

class ListScreen extends StatelessWidget{
  const ListScreen({super.key});
  @override
  Widget build(BuildContext context)
  {
    final items = List.generate(10,(i) => 'Item ${i+1}');
    return Scaffold(
      appBar: AppBar(title: const Text('List and alert')),
      body:ListView.builder(
        itemCount: items.length,
        itemBuilder:(context,index) => ListTile(
          title:Text(items[index]),
          onTap: () => showDialog(
            context:context,
            builder:(c) => AlertDialog(
              title:const Text('Navigate'),
              actions:[
                TextButton(onPressed: () => Navigator.pop(c),child:const Text('No')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(c);
                    Navigator.push(context,MaterialPageRoute(builder: (_) => DetailScreen(items[index])));
                  },
                  child:const Text('Yes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget{
  final String title;
  const DetailScreen(this.title,{super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar:AppBar(title: Text(title)),body:Center(child: Text(title)));
}