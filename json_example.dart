import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

    class Jsoneg extends StatefulWidget
    {  const Jsoneg({super.key});

  @override
  JsonegState createState() => JsonegState();
    // TODO: implement createState
  }
  class JsonegState extends State<Jsoneg> {
      late List data;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return Scaffold(appBar: AppBar(title: Text('Json list'),),
  body: Center(
    child: FutureBuilder(
        future: DefaultAssetBundle
        .of(context)
      .loadString('data_repo/Biodata.json'),
        builder: (context,snapshot){
          var newData = json.decode(snapshot.data.toString());

          return ListView.builder(
           itemBuilder: (BuildContext context,int index){
             return Card(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children:<Widget> [
                   Text("Name: ${newData[index]['name']}"),
                   Text("Age: ${newData[index]['age']}"),
                   Text("Price: ${newData[index]['price']}"),
                 ],
               )
             );
           },
            itemCount: newData == null ?0:newData.length,
          );
        }),
  ),);
  }
    }


class Jsonegtable extends StatefulWidget
{  const Jsonegtable({super.key});

@override
JsonegtableState createState() => JsonegtableState();
// TODO: implement createState
}
class JsonegtableState extends State<Jsonegtable> {
  late List data;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text('Json list'),),
      body: Center(
        child: FutureBuilder(
            future: DefaultAssetBundle
                .of(context)
                .loadString('data_repo/Biodata.json'),
            builder: (context,snapshot){
              var newData = json.decode(snapshot.data.toString());

              return ListView.builder(
                itemBuilder: (BuildContext context,int index){
Padding(padding:EdgeInsets.all(32.0));
                  return Table(
                    border: TableBorder.all(),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [Text('Name',textAlign: TextAlign.center,), Text('Age',textAlign: TextAlign.center,), Text('Price',textAlign: TextAlign.center,),Text('Action',textAlign: TextAlign.center,),Text('Action',textAlign: TextAlign.center,),],),
                      for(var item in newData)

                        TableRow(children: [
                          Text("${item['name']}",textAlign: TextAlign.center,),
                          Text("${item['age']}",textAlign: TextAlign.center,),
                          Text("${item['price']}",textAlign: TextAlign.center,),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              print("Edit icon tapped");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Edit icon!'),
                                      duration: Duration(seconds: 2),));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              print("Delete icon tapped");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Delete icon!'),
                                    duration: Duration(seconds: 2),));
                            },
                          ),
                        ],),
                    ],
                  );
                  },
                 itemCount: newData == null ?0:1,
              );
            }),
      ),);
  }
}


class Jsoneg1 extends StatefulWidget
{  const Jsoneg1({super.key});

@override
Jsoneg1State createState() => Jsoneg1State();
// TODO: implement createState
}
class Jsoneg1State extends State<Jsoneg1> {
  late List data;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text('Json list'),),
      body: Center(
        child: FutureBuilder(
            future: DefaultAssetBundle
                .of(context)
                .loadString('data_repo/product.json'),
            builder: (context,snapshot){
              var newData = json.decode(snapshot.data.toString());

              return ListView.builder(
                itemBuilder: (BuildContext context,int index){
                  return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget> [
                          Text("Product: ${newData[index]['Product']}"),
                          Text("Price: ${newData[index]['Price']}"),
                          Text("Color: ${newData[index]['Color']}"),
                          Image.network('${newData[index]['Image']}',height: 100,width:100),
                          Text("Email: ${newData[index]['Email']}"),
                        ],
                      )
                  );
                },
                itemCount: newData == null ?0:newData.length,
              );
            }),
      ),);
  }
}


class Jsonemp extends StatefulWidget
{  const Jsonemp({super.key});

@override
JsonempState createState() => JsonempState();
// TODO: implement createState
}
class JsonempState extends State<Jsonemp> {
  late List data;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text('Json list'),),
      body: Center(
        child: FutureBuilder(
            future: DefaultAssetBundle
                .of(context)
                .loadString('data_repo/employee.json'),
            builder: (context,snapshot){
              var newData = json.decode(snapshot.data.toString());

              return ListView.builder(
                itemBuilder: (BuildContext context,int index){
                  return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget> [
                          Text("Id: ${newData[index]['Id']}"),
                          Text("E-mail: ${newData[index]['E-mail']}"),
                          Text("FirstName: ${newData[index]['FirstName']}"),
                          Text("LastName: ${newData[index]['LastName']}"),
                          Image.network('${newData[index]['Avatar']}',height: 100,width:100),
                        ],
                      )
                  );
                },
                itemCount: newData == null ?0:newData.length,
              );
            }),
      ),);
  }
}

class Jsontuition extends StatefulWidget
{  const Jsontuition({super.key});

@override
JsontuitionState createState() => JsontuitionState();
// TODO: implement createState
}
class JsontuitionState extends State<Jsontuition> {
  late List data;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text('Merchandise list'),),
      body: Center(
        child: FutureBuilder(
            future: DefaultAssetBundle
                .of(context)
                .loadString('data_repo/tuitionmerchandise.json'),
            builder: (context,snapshot){
              var newData = json.decode(snapshot.data.toString());

              return ListView.builder(
                itemBuilder: (BuildContext context,int index){
                  return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget> [
                          Text("Product: ${newData[index]['Product']}"),
                          Text("Id: ${newData[index]['Id']}"),
                          Text("Price: ${newData[index]['Price']}"),
                          Text("Colour: ${newData[index]['Colour']}"),
                          Image.asset('${newData[index]['Image']}',height: 100,width:100),
                          Text('Email to shop')
                        ],
                      )
                  );
                },
                itemCount: newData == null ?0:newData.length,
              );
            }),
      ),);
  }
}

