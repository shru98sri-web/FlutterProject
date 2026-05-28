import 'package:flutter/material.dart';
import 'package:sample_self/toggleexample.dart';
//
class StepOne extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(home: Scaffold(
  appBar: AppBar(title: Text('Step One')
    ,),
), );
  }

}
// this example to understand appbar
class StepTwo extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
return MaterialApp(home:Scaffold(
  appBar: AppBar(title: Text('Step Two'),
  centerTitle: true,
  )));  }

}
// this example to add appbar, body and bottom appbar
class StepThree extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(home:Scaffold(
  body: Text("Class1",),backgroundColor: Colors.blueAccent,
bottomNavigationBar: BottomAppBar(child: Text("Designed by Shruthi",textAlign: TextAlign.center,),),

));  }

}
// this example to add one image to the body
class StepFour extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(home:Scaffold(
  body: Image.network('https://www.build-electronic-circuits.com/wp-content/uploads/2013/11/LDR-circuit-improved.png'),
  bottomNavigationBar: BottomAppBar(child: Text("Designed by Shruthi",textAlign: TextAlign.center,),),
));  }
  
  
}


// this example to add more than one image using row
class FifthOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home:Scaffold(
    body:Row(
      children: [
        Image.network('https://www.build-electronic-circuits.com/wp-content/uploads/2013/11/LDR-circuit-improved.png',height: 120,width: 120,),
        Image.network('https://media.istockphoto.com/id/1328153839/vector/electric-circuitry.jpg?s=612x612&w=0&k=20&c=whLpsntHETkxTr38GSQYv8QaAPcSl028iR9QXaAuuZE=',height: 120,width: 120,),
        Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPCdf5K49YHBsRp1ZToaM1ztpi4WrH-r55cw&s',height: 120,width:120,),

      ],
    ),
    bottomNavigationBar: BottomAppBar(child: Text("Designed by Shruthi",textAlign: TextAlign.center,)),
    ),
      debugShowCheckedModeBanner: false,);
  }
}

// this example to add more than one image using column

class SixthOne extends StatelessWidget
{
  const SixthOne({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home:Scaffold(
    body: Stack(
      children: [
        Positioned(top: 20,
          left: 10,child:Image.network('https://www.build-electronic-circuits.com/wp-content/uploads/2013/11/LDR-circuit-improved.png',height: 100,width: 100,),
        ),
        Positioned(top: 80,
            left:50,child: Image.network('https://media.istockphoto.com/id/1328153839/vector/electric-circuitry.jpg?s=612x612&w=0&k=20&c=whLpsntHETkxTr38GSQYv8QaAPcSl028iR9QXaAuuZE=',height: 150,width: 100,),
        ),
        Positioned(top:190,
          left: 80,child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPCdf5K49YHBsRp1ZToaM1ztpi4WrH-r55cw&s',height: 100,width:100,),
        ),

      ],
    ),
    ));
  }


}

class SeventhOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(home: Scaffold(
  body: Column(
    children: [
      SizedBox(height: 80,),
      Text('Image 1'),
      Center(child: Image.network('https://www.build-electronic-circuits.com/wp-content/uploads/2013/11/LDR-circuit-improved.png',height: 120,width: 120),
      ),
      Text('Image 2'),
      Image.network('https://media.istockphoto.com/id/1328153839/vector/electric-circuitry.jpg?s=612x612&w=0&k=20&c=whLpsntHETkxTr38GSQYv8QaAPcSl028iR9QXaAuuZE=',height: 120,width: 120,),
      Text('Image 3'),
      Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPCdf5K49YHBsRp1ZToaM1ztpi4WrH-r55cw&s',height: 120,width:120,),

    ],
  ),
),);  }
}
//container

class EightOne extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
return MaterialApp(home: Scaffold(
  backgroundColor: Colors.orange,
  appBar: AppBar(title: Text('Demo',),
      centerTitle: true,
      ),
    body: Container(height: 200,width: 200,color: Colors.blue,child: const Text('data'),),

),);
  }


}

//Stateful widget
class NinthOne extends StatefulWidget {
 const NinthOne ({super.key});
  @override
  State<NinthOne> createState() => NinthOneState();
  }
class NinthOneState extends State<NinthOne>{
 int counter = 0;
 void _incrementcounter() {
   setState(() {
     counter++;
   });
 }
@override
  Widget build(BuildContext context){

    return Directionality(textDirection: TextDirection.ltr,
        child: Column(children: [Text('count $counter',style: TextStyle(fontSize: 20),),
        ElevatedButton(onPressed: _incrementcounter,
            child: Text('increment'))],));


}
}

class TenthOne extends StatefulWidget {
  const TenthOne ({super.key});
  @override
  State<TenthOne> createState() => TenthOneState();
}
class TenthOneState extends State<TenthOne>{
  int counter = 0;
  void _incrementcounter() {
    setState(() {
      counter++;
    });
  }
  @override
  Widget build(BuildContext context){

    // return Column(children: [Text('count $counter',style: TextStyle(fontSize: 20),),
    //       ElevatedButton(onPressed: _incrementcounter, child: Text('increment'))],);

   return Directionality(textDirection: TextDirection.ltr,
       child:Column(children: [Text('count $counter',
         style: TextStyle(fontSize: 20),),
         ElevatedButton(onPressed: _incrementcounter, child: Text('increment'))],) );
  }
}

class EleventhOne extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return  MaterialApp(

      home: Scaffold(
        body:TenthOne()
      ),
    );
  }
}

//Stateful widget and textfield

class TwelthOne extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: GridView.count(primary:false,padding:const EdgeInsets.all(20),crossAxisSpacing: 10,mainAxisSpacing: 10,
            crossAxisCount: 2,
        children:<Widget> [
          ElevatedButton(onPressed: (){print('Container 1 clicked');}, child: const Text('Tap me')),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue[100],
            child: const Text('Image box 1',),height: 20,width: 20,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue[200],
            child: const Text('Image box 2'),height: 20,width: 20,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue[300],
            child: const Text('Image box 3'),height: 20,width: 20,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue[400],
            child: const Text('Image box 4'),height: 20,width: 20,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue[500],
            child: const Text('Image box 5'),height: 20,width: 20,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue[600],
            child: const Text('Image box 6'),height: 20,width: 20,
          ),
        ],

        ),
      )
    );
  }
}


class Student
{
  final String id;
  final String name;
  final String mark;

  const Student({required this.id,required this.name,required this.mark});
}

class ThirteenOne extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
Student student = new Student(id: 'Ba', name: 'ram', mark: '80');
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text("title"), centerTitle: true,),
    body: Table(
      border: TableBorder.all(),
      children: [
        TableRow(children: [Text('id'), Text('name'), Text('mark')],),
      TableRow(children: [Text(student.id), Text(student.name), Text(student.mark)],),

    ],
    ),));
  }}

//array of values
class FourteenOne extends StatelessWidget
{
  const FourteenOne({super.key});

  @override
  Widget build(BuildContext context) {
    List<Student> studList =[
      Student(id: 'Ba', name: 'ram', mark: '80'),
      Student(id: 'Bb', name: 'shyam', mark: '99'),
      Student(id: 'Bc', name: 'sita', mark: '95'),
      Student(id: 'Bd', name: 'gyan', mark: '89')

      ,];
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text("title"), centerTitle: true,),
      body: Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [Text('id'), Text('name'), Text('mark')],),
       for(Student student in studList)
         TableRow(children: [
           Text(student.id),
           Text(student.name),
           Text(student.mark)
         ],),

        ],
      ),
    ));
  }}

class Product
{
final String id;
final String name;
final double price;

const Product({required this.id,required this.name,required this.price});
}

class FifteenOne extends StatelessWidget
{
  Product product = new Product(id: 'Ba', name: 'Apple', price: 600);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text("title"), centerTitle: true,),
      body: Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [Text('Id'), Text('Name'), Text('Price')],),
          TableRow(children: [Text(product.id), Text(product.name), Text(product.price.toString())],),

        ],
      ),));
  }}

class SixteenOne extends StatelessWidget
{
  const SixteenOne({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> prodList =[
      Product(id: 'Ba', name: 'apple', price: 800.00),
      Product(id: 'Bb', name: 'samsung', price: 990.90),
      Product(id: 'Bc', name: 'vivo', price: 950.00),
      Product(id: 'Bd', name: 'moto', price: 890.00)

      ,];
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text("Title"), centerTitle: true,),
      body:Padding(padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [Text('Id'), Text('Name'), Text('Price')],),
          for(Product product in prodList)
            TableRow(children: [
              Text(product.id),
              Text(product.name),
              Text(product.price .toString())
            ],),

        ],
      ),),
      ));
  }}

class SeventeenOne extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Row Print'),),
    body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:<Widget> [
        Icon(Icons.menu_book),
        Expanded(child: Text('Row 1')),
        Icon(Icons.menu_book),
        Expanded(child: Text('Row2')),
        Icon(Icons.menu_book),
        Expanded(child: Text('Row 3')),
        Icon(Icons.menu_book),
        Expanded(child: Text('Row 4')),
        Icon(Icons.menu_book),
        Expanded(child: Text('Row 5')),
        Icon(Icons.menu_book),
        Expanded(child: Text('Row 6')),
      ],),
    ), debugShowCheckedModeBanner: false,);
  }
}

class EighteenOne extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Column Print'),),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget> [
          Icon(Icons.menu_book),
          Expanded(child: Text('Column 1')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Column 2')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Column 3')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Column 4')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Column 5')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Column 6')),
        ],),
    ), debugShowCheckedModeBanner: false,);
  }
}

class NineteenOne extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Stack Print'),),
      body: Stack(
        children:<Widget> [
          Icon(Icons.menu_book),
          Expanded(child: Text('Stack 1')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Stack 2')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Stack 3')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Stack 4')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Stack 5')),
          Icon(Icons.menu_book),
          Expanded(child: Text('Stack 6')),
        ],),
    ), debugShowCheckedModeBanner: false,);
  }
}

class TwentyOne extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Main topic'),),
  drawer: Drawer(
  child: ListView(
  padding: EdgeInsets.zero,
  children: [
    const DrawerHeader(
      decoration: BoxDecoration(color: Colors.blue),
      child: Text(
        "Menu",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    ),
    ListTile(
      leading: const Icon(Icons.home),
      title: const Text("Home"),
      onTap: () => Navigator.pop(context),
    ),
    ListTile(
      leading: const Icon(Icons.settings),
      title: const Text("Settings"),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Settings Clicked!")),
        );
      },
    ),
  ],
),
),
),);

  }
}

class TwentyTwo extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Tuition App'),),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              }),
                ListTile(
                  leading: const Icon(Icons.note),
                  title: const Text("Physics"),
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ListTile(
                leading: const Icon(Icons.note),
                title: const Text("Class 1 to XII"),
                onTap: () {
                  Navigator.pop(context);
                }),
    ]),
      ),
      ),
    );
  }
}

class Twentythree extends StatefulWidget {
  const Twentythree({super.key});

  @override
  State<Twentythree> createState() => _TwentythreeState();
}

class _TwentythreeState extends State<Twentythree> {
  final TextEditingController _iController = TextEditingController();
  String classNumberStatus = "0"; // String status variable

  void _checkInput() {
    double? number = double.tryParse(_iController.text);
    setState(() {
      if (number != null && number != 0) {
        classNumberStatus = number.toString();
        print('Class Number is: $classNumberStatus');
      } else {
        classNumberStatus = "Invalid Input";
      }
    });
  }

  @override
  void dispose() {
    _iController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(debugShowCheckedModeBanner: false,home: Scaffold(appBar: AppBar(title: Text('Input'),),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // TextField आता योग्य ठिकाणी आहे
              TextField(
              controller: _iController,
              keyboardType: TextInputType.number,
              onChanged: (value) => _checkInput(), // नंबर बदलल्यावर चेक होईल
              decoration: const InputDecoration(
                labelText: "Class Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Status: $classNumberStatus",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],),))
      ));
  }}


class Twentyfive extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return  MaterialApp(

      home: Scaffold(
          body:Twentyfour()
      ),
    );
  }
}


class Twentyfour extends StatefulWidget
{
  const Twentyfour({super.key});
  @override
  State<Twentyfour> createState() => _TwentyfourState();
}

class _TwentyfourState extends State<Twentyfour>
{
  String ? selectedValue = 'Module 1';
  final List<String> items = ['Module 1','Module 2','Module 3','Module 4'];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Dropdown')),
      body: Center(
        child: DropdownButton<String>(
          value: selectedValue, // Current value
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.blue),
          underline: Container(height: 2, color: Colors.blueAccent),
          // 3. Convert the String list to a List of DropdownMenuItems
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          // 4. Update the state when a new item is selected
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
        ),
      ),
    );
  }
}

class Twentysix extends StatelessWidget
{
  const Twentysix({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(home: Scaffold(
  body: SafeArea(child: Text(
      'My protected content',
    style: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
      letterSpacing: 2.0
    ),
  ),),
) );  }
}


class Twentyseven extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Twentyeight(),
    );
  }
}

class Twentyeight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Navigation'),),body: TwentyNineRefactored(),),
    );
  }
}

class Twentynine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Class 1'),
            Text('Smart Tuition'),
            Image.asset('assets/image1/pg1.png',height: 350,width:350,),
            ElevatedButton(
              onPressed: () {
                print('creating replacement page 1');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                  return Twentynine();
                }));
              },
              child: Text('Go to page 1'),
            ),SizedBox(height: 10,width: 10,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 2');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return Thirty();
                }));
              },
              child: Text('Go to page 2'),
            ),SizedBox(height: 10,width: 10,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 3');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return Page3();
                }));
              },
              child: Text('Go to page 3'),
            ),SizedBox(height: 10,width: 10,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 4');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return Page4();
                }));
              },
              child: Text('Go to page 4'),
            ),
            SizedBox(height: 10,width: 10,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 5 ');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return Page5();
                }));
              },
              child: Text('Go to page 5'),
            ),
            SizedBox(height: 10,width: 10,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 6');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return Page6();
                }));
              },
              child: Text('Go to page 6'),
            ),
            SizedBox(height: 10,width: 10,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 7');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return Page7();
                }));
              },
              child: Text('Go to page 7'),
            ),
            SizedBox(height: 10,width: 10,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 8');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return Page8();
                }));
              },
              child: Text('Go to page 8'),
            ),
          ],
        ),
      ),
    );
  }
}

class Thirty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Class 2'),
            Text('Mastery Learning'),
            Image.asset('assets/image1/pg2.png', height: 350,width:350),
            ElevatedButton(
              onPressed: () {
                print('creating new page 1');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Twentynine()));
              },
              child: Text('Go to page 1'),
            ),SizedBox(height: 10,width: 10,),
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 3'),
      ),
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Class 3'),
            Text('Satisfactory teaching and guidance'),
            Image.asset('assets/image1/pg3.png', height: 350,width: 350,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 1');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Twentynine()));
              },
              child: Text('Go to page 1'),
            ),SizedBox(height: 10,width: 10,),
          ],
        ),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 4'),
      ),
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Class 4'),
            Text('Study Online or Offline'),
            Image.asset('assets/image1/pg4.png', height: 350,width: 350,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 1');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Twentynine()));
              },
              child: Text('Go to page 1'),
            ),SizedBox(height: 10,width: 10,),
          ],
        ),
      ),
    );
  }
}
class Page5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 5'),
      ),
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Class 5'),
            Text('Target high Score'),
            Image.asset('assets/image1/pg5.png', height:350,width: 350,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 1');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Twentynine()));
              },
              child: Text('Go to page 1'),
            ),SizedBox(height: 10,width: 10,),
          ],
        ),
      ),
    );
  }
}

class Page6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 6'),
      ),
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Class 6'),
            Text('Clear Learning'),
            Image.asset('assets/image1/pg6.png', height:350,width:350),
            ElevatedButton(
              onPressed: () {
                print('creating new page 1');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Twentynine()));
              },
              child: Text('Go to page 1'),
            ),SizedBox(height: 10,width: 10,),
          ],
        ),
      ),
    );
  }
}

class Page7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 7'),
      ),
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Class 7'),
            Text('Insightful Presentation and Revision Class'),
            Image.asset('assets/image1/Screenshot7.png', height: 350,width: 350,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 1');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Twentynine()));
              },
              child: Text('Go to page 1'),
            ),SizedBox(height: 10,width: 10,),
          ],
        ),
      ),
    );
  }
}

class Page8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 8'),
        centerTitle: true,
      ),
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Class 8'),
            Text('Exam level Practice'),
            Image.asset('assets/image1/Screenshot5.png', height: 350,width:350,),
            ElevatedButton(
              onPressed: () {
                print('creating new page 1');
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Twentynine()));
              },
              child: Text('Go to page 1'),
            ),SizedBox(height: 10,width: 10,),
          ],
        ),
      ),
    );
  }
}

class ThirtyOne extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text('floating button'),),
        floatingActionButton: FloatingActionButton(onPressed: () {
        print('Floating button clicked');
      },
      child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      )),);
  }
}

class ThirtyTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(appBar: AppBar(title: Text('End Drawer'),),
        endDrawer: Drawer(child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(decoration: BoxDecoration(color: Colors.blue),
            child: Text('Setting menu'),),
          ListTile(
            title: const Text('Close Drawer'),
            onTap: () => Navigator.pop(context),
          ),
        ],),),
        body: const Center(child: Text('swipe from right or tap menu icon'),),

      ),);
  }
}

class TwentyNineRefactored extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // १. पानांची माहिती ठेवणारी लिस्ट (Page Data List)
    final List<Map<String, dynamic>> pages = [
      {'title': 'Go to page 1','log': 'creating replacement page 1', 'widget': () => Twentynine(), 'isReplacement': true},
      {'title': 'Go to page 2', 'log': 'creating new page 2', 'widget': () => Thirty()},
      {'title': 'Go to page 3', 'log': 'creating new page 3', 'widget': () => Page3()},
      {'title': 'Go to page 4', 'log': 'creating new page 4', 'widget': () => Page4()},
      {'title': 'Go to page 5', 'log': 'creating new page 5', 'widget': () => Page5()},
      {'title': 'Go to page 6', 'log': 'creating new page 6', 'widget': () => Page6()},
      {'title': 'Go to page 7', 'log': 'creating new page 7', 'widget': () => Page7()},
      {'title': 'Go to page 8', 'log': 'creating new page 8', 'widget': () => Page8()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      backgroundColor: Colors.amber,
      body:Center(
        child: SingleChildScrollView( // अनेक बटणे असल्यास स्क्रीन स्क्रोल होण्यासाठी
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Class 1'),
              const SizedBox(height: 10),

              // २. map() वापरून बटणे ऑटोमॅटिक तयार करणे
              ...pages.map((page) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0), // SizedBox ऐवजी पॅडिंग
                  child: ElevatedButton(
                    onPressed: () {
                      print(page['log']);
                      // नेव्हिगेशन लॉजिक (Route Builder)
                      final route = MaterialPageRoute(
                        builder: (BuildContext context) => page['widget'](),
                      );

                      if (page['isReplacement'] == true) {
                        Navigator.pushReplacement(context, route);
                      } else {
                        Navigator.push(context, route);
                      }
                    },
                    child: Text(page['title']),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class BaseLayout extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(home:Scaffold(
  body: Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(image:NetworkImage('https://media.istockphoto.com/id/1328153839/vector/electric-circuitry.jpg?s=612x612&w=0&k=20&c=whLpsntHETkxTr38GSQYv8QaAPcSl028iR9QXaAuuZE='),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [],
    ),
  ),
), );
  }
}

class Thirtythree extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(home:Scaffold(
  body: Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage('image1/pg6.png'),
        fit: BoxFit.fill,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [],
    ),
  ),
), );
  }
}


//import 'package:flutter/material.dart';

//void main() => runApp(const MaterialApp(home: PageOne()));

// --- PAGE 1 (Stateful Widget) ---
class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 1'),backgroundColor:Colors.lightBlueAccent,),

      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Page 2'),
          onPressed: () {
            // Page 2 वर जाण्यासाठी खालील कोड वापरा
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PageTwo()),
            );
          },
        ),

      ),backgroundColor: Colors.lightGreen,
    );
  }
}

// Page 2 can be added to stateful widget
// --- PAGE 2 (Stateless Widget) ---
class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2'),backgroundColor: Colors.lightBlueAccent,),
      body: Center(
        child: ElevatedButton(
          child: const Text('Back to Page 1'),
          onPressed: () {
            // परत Page 1 वर येण्यासाठी
            Navigator.pop(context);
          },
        ),
      ),backgroundColor: Colors.limeAccent,
    );
  }
}

class Grid extends StatelessWidget {
  const Grid({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tuition App')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2, // 2 columns for a 2x2 grid
            crossAxisSpacing: 10, // Horizontal space between images
            mainAxisSpacing: 10,  // Vertical space between images
            children: [
              Image.asset('assets/image1/pg1.png',height: 150,width:150,),
              Image.asset('assets/image1/pg2.png', height: 150,width:150),
              Image.asset('assets/image1/pg3.png', height: 150,width: 150,),
              Image.asset('assets/image1/pg4.png', height: 150,width: 150,),
              Image.asset('assets/image1/pg5.png', height:150,width: 150,),
              Image.asset('assets/image1/pg6.png', height:150,width:150),
              Image.asset('assets/image1/Screenshot7.png', height: 150,width: 150,),
              Image.asset('assets/image1/Screenshot5.png', height: 150,width:150,),
            ],
          ),
        ),
      ),
    );
  }
}

class image_list extends StatelessWidget {
  const image_list({super.key});

  @override
  Widget build(BuildContext context) {
    // List of asset image paths
    final List<String> imageList = [
      'assets/image1/pg1.png',
      'assets/image1/pg2.png',
      'assets/image1/pg3.png',
      'assets/image1/pg4.png',
      'assets/image1/pg5.png',
      'assets/image1/pg6.png',
      'assets/image1/Screenshot5.png',
      'assets/image1/Screenshot7.png',
    ];

    return MaterialApp(debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('List View')),
        body: ListView.builder(
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                onTap: (){
                  showImageDialog(context,imageList[index]);
                },
                // leading property displays the image on the left
                leading: Image.asset(
                  imageList[index],
                  width: 150,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                title: Text('Image ${index + 1}'),
              ),
            );
          },
        ),
      ),
    );
  }
}

void showImageDialog(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min, // कॉन्टेंटनुसार साईझ लहान ठेवते
        children: [
          Image.asset(imagePath, fit: BoxFit.contain),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('(Close)'),
          )
        ],
      ),
    ),
  );
}

class Grid_img extends StatelessWidget {
  const Grid_img({super.key});

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, fit: BoxFit.contain,),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('(Close)'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // तुमच्या इमेज पाथची लिस्ट जेणेकरून कोड सुटसुटीत दिसेल
    final List<String> images = [
      'assets/image1/pg1.png',
      'assets/image1/pg2.png',
      'assets/image1/pg3.png',
      'assets/image1/pg4.png',
      'assets/image1/pg5.png',
      'assets/image1/pg6.png',
      'assets/image1/Screenshot7.png',
      'assets/image1/Screenshot5.png',
    ];

    return MaterialApp(debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Grid View'),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // एका ओळीत २ कार्ड्स
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showImageDialog(context, images[index]), // क्लिक केल्यावर इमेज दिसेल
                child: Card(
                  elevation: 4, // कार्डची सावली (Shadow)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // गोल कडा (Rounded corners)
                  ),
                  clipBehavior: Clip.antiAlias, // इमेज कडांच्या बाहेर जाणार नाही
                  child: Image.asset(
                    images[index], height: 150,width: 150, // इमेज कार्डमध्ये व्यवस्थित फिट करण्यासाठी
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


class TogglePageManager extends StatefulWidget {
  @override
  _TogglePageManagerState createState() => _TogglePageManagerState();
}

class _TogglePageManagerState extends State<TogglePageManager> {
  bool _isToggled = false; // The shared state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tuition App')),
      body: _isToggled ? Grid4windowpagest() : List4windowpagest(), // Toggle the views
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isToggled = !_isToggled;
          });
        },
        child: Icon(Icons.swap_horiz,),
      ),
    );
  }
}


//import 'package:flutter/material.dart';

class Gridwindow extends StatelessWidget {
  const Gridwindow({super.key});

  @override
  Widget build(BuildContext context) {
    // इमेज पाथ आणि त्यांच्याशी संबंधित टेक्स्टची लिस्ट
    final List<Map<String,String>> gridItems = [
      {'image':'assets/image1/pg1.png','title':'Smart Tuition'},
      {'image':'assets/image1/pg2.png','title':'Mastery Learning'},
      {'image':'assets/image1/pg3.png','title':'Satisfactory Teaching and Guidance'},
      {'image':'assets/image1/pg4.png','title':'Study Online or Offline'},
      {'image':'assets/image1/pg5.png','title':'Target High Score'},
      {'image':'assets/image1/pg6.png','title':'Clear Learning'},
      {'image':'assets/image1/Screenshot7.png','title':'Exam Level Practice'},
      {'image':'assets/image1/Screenshot5.png','title':'Insightful Presentation and Revision Classes'},
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tuition App')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8, // कार्ड योग्य आकारात दिसण्यासाठी
            ),
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageDetailScreen(
                        imagePath: gridItems[index]['image']!,
                        title: gridItems[index]['title']!,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // १. इमेज
                      Expanded(
                        child: Image.asset(
                          gridItems[index]['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // २. इमेजखालील टेक्स्ट
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          gridItems[index]['title']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// नवीन विंडो/स्क्रीन (Image Detail Screen)
class ImageDetailScreen extends StatelessWidget {
  final String imagePath;
  final String title;

  const ImageDetailScreen({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // १. झूम होणारी इमेज
          Expanded(
            child: Center(
              child: InteractiveViewer(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // २. इमेजच्या खाली दिसणारा टेक्स्ट (येथून चुकीची 'physics' लाइन काढली आहे)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.black54,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}


//import 'package:flutter/material.dart';

// मुख्य ग्रीड स्क्रीन (Main Grid Screen)
class NaviGrid extends StatelessWidget {
  const NaviGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // इमेज पाथची लिस्ट
    final List<String> images = [
      'assets/image1/pg1.png',
      'assets/image1/pg2.png',
      'assets/image1/pg3.png',
      'assets/image1/pg4.png',
      'assets/image1/pg5.png',
      'assets/image1/pg6.png',
      'assets/image1/Screenshot7.png',
      'assets/image1/Screenshot5.png',
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tuition App')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  //click to navigate
                  Widget nextPage;
                  switch (index) {
                    case 0: nextPage = const NaviPageOne(); break;
                    case 1: nextPage = const NaviPageTwo(); break;
                    case 2: nextPage = const PageThree(); break;
                    case 3: nextPage = const PageFour(); break;
                    case 4: nextPage = const PageFive(); break;
                    case 5: nextPage = const PageSix(); break;
                    case 6: nextPage = const PageSeven(); break;
                    case 7: nextPage = const PageEight(); break;
                    default: nextPage = const PageOne();
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => nextPage),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(images[index], height: 150,width: 150,),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// --- खाली ८ वेगळी पेजेस दिली आहेत (प्रत्येकात स्वतंत्र डिझाइन करू शकता) ---

class NaviPageOne extends StatelessWidget {
  const NaviPageOne({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context), // पेज बंद करून मागे जाण्यासाठी
          child: const Text('Close (बंद करा)'),
        ),
      ),
    );
  }
}

class NaviPageTwo extends StatelessWidget {
  const NaviPageTwo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  const PageThree({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 3')),
      body: Center(
        child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ),
    );
  }
}

class PageFour extends StatelessWidget {
  const PageFour({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 4')),
      body: Center(
        child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ),
    );
  }
}

class PageFive extends StatelessWidget {
  const PageFive({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 5')),
      body: Center(
        child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ),
    );
  }
}

class PageSix extends StatelessWidget {
  const PageSix({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 6')),
      body: Center(
        child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ),
    );
  }
}

class PageSeven extends StatelessWidget {
  const PageSeven({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 7')),
      body: Center(
        child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ),
    );
  }
}

class PageEight extends StatelessWidget {
  const PageEight({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 8')),
      body: Center(
        child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ),
    );
  }
}

class ScreenthreeGridwindow extends StatelessWidget {
  const ScreenthreeGridwindow({super.key});

  @override
  Widget build(BuildContext context) {
    // List of image asset paths
    final List<String> images = [
      'assets/image1/pg1.png',
      'assets/image1/pg2.png',
      'assets/image1/pg3.png',
      'assets/image1/pg4.png',
      'assets/image1/pg5.png',
      'assets/image1/pg6.png',
      'assets/image1/Screenshot7.png',
      'assets/image1/Screenshot5.png',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tuition App')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Opens the alert dialog on image click
                _showChoiceDialog(context, images[index], index + 1);
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to display the Alert Dialog
  void _showChoiceDialog(BuildContext context, String imagePath, int imageNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image #$imageNumber'),
          content: const Text('Do you want to view this image on a larger screen?'),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Closes the alert box
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            // Confirmation Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Closes the alert box first

                // Navigates to the details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageDetail(imagePath: imagePath),
                  ),
                );
              },
              child: const Text('View Image'),
            ),
          ],
        );
      },
    );
  }
}

// Fullscreen Image Detail View Screen
class ImageDetail extends StatelessWidget {
  final String imagePath;
  const ImageDetail({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background to highlight the image
      appBar: AppBar(
        title: const Text('Image View'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white, // Back button color
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0, // Allows up to 4x zoom
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

//import 'package:flutter/material.dart';

class ScreenthreeListwindow extends StatelessWidget {
  const ScreenthreeListwindow({super.key});

  @override
  Widget build(BuildContext context) {
    // List of image asset paths
    final List<String> images = [
      'assets/image1/pg1.png',
      'assets/image1/pg2.png',
      'assets/image1/pg3.png',
      'assets/image1/pg4.png',
      'assets/image1/pg5.png',
      'assets/image1/pg6.png',
      'assets/image1/Screenshot7.png',
      'assets/image1/Screenshot5.png',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tuition App')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Opens the alert dialog on image click
                _showChoiceDialog(context, images[index], index + 1);
              },
              child: Container(
                margin: const EdgeInsets.only(),
                height: 200, // Fixed height for vertical list rows
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    // Ensures image fills row width
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to display the Alert Dialog
  void _showChoiceDialog(BuildContext context, String imagePath, int imageNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image #$imageNumber'),
          content: const Text('Do you want to view this image on a larger screen?'),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Closes the alert box
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            // Confirmation Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Closes the alert box first

                // Navigates to the details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageDetail(imagePath: imagePath),
                  ),
                );
              },
              child: const Text('View Image'),
            ),
          ],
        );
      },
    );
  }
}

// Fullscreen Image Detail View Screen
class ImageDetaillist extends StatelessWidget {
  final String imagePath;
  const ImageDetaillist({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background to highlight the image
      appBar: AppBar(
        title: const Text('Image View'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white, // Back button color
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0, // Allows up to 4x zoom
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class Grid4window extends StatelessWidget {
  const Grid4window({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String,String>> gridItems = [
      {'image':'assets/image1/pg1.png','title':'Smart Tuition'},
      {'image':'assets/image1/pg2.png','title':'Mastery Learning'},
      {'image':'assets/image1/pg3.png','title':'Satisfactory Teaching and Guidance'},
      {'image':'assets/image1/pg4.png','title':'Study Online or Offline'},
      {'image':'assets/image1/pg5.png','title':'Target High Score'},
      {'image':'assets/image1/pg6.png','title':'Clear Learning'},
      {'image':'assets/image1/Screenshot7.png','title':'Exam Level Practice'},
      {'image':'assets/image1/Screenshot5.png','title':'Insightful Presentation and Revision Classes'},
    ];

    // Alert Dialog
    void showItemDialog(BuildContext context, String title, String imagePath) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: const Text('To view clear information click'),
            actions: [
              // cancel button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close the dialog
                },
                child: const Text('Cancel'),
              ),
              // elevated button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // navigate to next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageDetail3Screen(
                        imagePath: imagePath,
                        title: title,
                      ),
                    ),
                  );
                },
                child: const Text('Open View'),
              ),
            ],
          );
        },
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tuition App')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // on tap show dialog then from dialog display screen
                  showItemDialog(
                    context,
                    gridItems[index]['title']!,
                    gridItems[index]['image']!,
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.asset(
                          gridItems[index]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          gridItems[index]['title']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),debugShowCheckedModeBanner: false,
    );
  }
}

// (Image Detail Screen)
class ImageDetail3Screen extends StatelessWidget {
  final String imagePath;
  final String title;

  const ImageDetail3Screen({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.black54,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}


//import 'package:flutter/material.dart';

class List4window extends StatelessWidget {
  const List4window({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> listItems = [
      {'image': 'assets/image1/pg1.png', 'title': 'Smart Tuition'},
      {'image': 'assets/image1/pg2.png', 'title': 'Mastery Learning'},
      {
        'image': 'assets/image1/pg3.png',
        'title': 'Satisfactory Teaching and Guidance'
      },
      {'image': 'assets/image1/pg4.png', 'title': 'Study Online or Offline'},
      {'image': 'assets/image1/pg5.png', 'title': 'Target High Score'},
      {'image': 'assets/image1/pg6.png', 'title': 'Clear Learning'},
      {'image': 'assets/image1/Screenshot7.png', 'title': 'Exam Level Practice'},
      {
        'image': 'assets/image1/Screenshot5.png',
        'title': 'Insightful Presentation and Revision Classes'
      },
    ];

    // Alert Dialog
    void showItemDialog(BuildContext context, String title, String imagePath) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: const Text('To view the details click'),
            actions: [
              // Cancel button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // to close dialog
                },
                child: const Text('Cancel'),
              ),
              // Elevated Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // to close previous screen
                  // open imgdetail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageDetail4Screen(
                        imagePath: imagePath,
                        title: title,
                      ),
                    ),
                  );
                },
                child: const Text('Open View'),
              ),
            ],
          );
        },
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tuition App')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          //ListView.builder
          child: ListView.builder(
            itemCount: listItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showItemDialog(
                    context,
                    listItems[index]['title']!,
                    listItems[index]['image']!,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  // printing images in row
                  child: Row(
                    children: [
                      // डाव्या बाजूला इमेज
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          listItems[index]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // text alongside image
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            listItems[index]['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, // textoverflow indicator
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),debugShowCheckedModeBanner: false,
    );
  }
}

// (Image Detail Screen)
class ImageDetail4Screen extends StatelessWidget {
  final String imagePath;
  final String title;

  const ImageDetail4Screen({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.black54,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}



class List4windowpage extends StatelessWidget {
  const List4windowpage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listItems = [
      {
        'image': 'assets/image1/pg1.png',
        'title': 'Smart Tuition',
        'page': const SmartTuitionPage(),
      },
      {
        'image': 'assets/image1/pg2.png',
        'title': 'Mastery Learning',
        'page': const MasteryLearningPage(),
      },
      {
        'image': 'assets/image1/pg3.png',
        'title': 'Satisfactory Teaching',
        'page': const SatisfactoryTeachingPage(),
      },
      {
        'image': 'assets/image1/pg4.png',
        'title': 'Study Online or Offline',
        'page': const StudyModePage(),
      },

      {
        'image': 'assets/image1/pg5.png',
        'title': 'Target High Score',
        'page': const ScoreTrackerPage(),
      },

      {
        'image': 'assets/image1/pg6.png',
        'title': 'Clear Learning',
        'page': const LearnerPortalPage(),
      },

      {
        'image': 'assets/image1/Screenshot7.png',
        'title': 'ExamLevel Practice',
        'page': const PracticeQuestionsPage(),
      },

      {
        'image': 'assets/image1/Screenshot5.png',
        'title': 'Insightful Presentation and Revision Classes',
        'page': const DiscussionPage(),
      },
    ];

    // Alert Dialog
    void showItemDialog(BuildContext context, String title, Widget targetPage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: const Text('To view the details click Open View'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetPage),
                  );
                },
                child: const Text('Open View'),
              ),
            ],
          );
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: listItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showItemDialog(
                    context,
                    listItems[index]['title']!,
                    listItems[index]['page']!,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          listItems[index]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            listItems[index]['title']!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ====================(Different Pages) ====================

// १. Smart Tuition Page
class SmartTuitionPage extends StatelessWidget {
  const SmartTuitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Tuition Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book_outlined, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            const Text('Welcome to Smart Tuition - Here we use digital resources and tools to enhance student learning', style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Image.asset('assets/image1/pg1.png', height: 250,width:250),
          ],
        ),
      ),
    );
  }
}

// २. Mastery Learning Page
class MasteryLearningPage extends StatelessWidget {
  const MasteryLearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mastery Learning Program')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book_outlined, size: 50, color: Colors.blueAccent),
            const SizedBox(height: 10),
            const Text('Focus on concept clarity until you master it!', style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Image.asset('assets/image1/pg2.png', height: 250,width:250),

          ],
        ),
      ),
    );
  }
}

// ३. Satisfactory Teaching Page
class SatisfactoryTeachingPage extends StatelessWidget {
  const SatisfactoryTeachingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Our Teaching Guidance')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book, size: 50, color: Colors.lightBlue),
            const SizedBox(height: 10),
            const Text('Personalized 1-on-1 mentorship for every student. ', style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Image.asset('assets/image1/pg3.png', height: 250,width:250),
          ],
        ),
      ),
    );
  }
}

// ४. Study Online or Offline Page
class StudyModePage extends StatelessWidget {
  const StudyModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flexible Study Modes')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.note_alt, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            const Text('Affordable Online and Offline classes', style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Image.asset('assets/image1/pg4.png', height: 250,width:250),
            const SizedBox(height: 10),
            ElevatedButton.icon(onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Offline Hub!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }, icon: const Icon(Icons.room), label: const Text('Offline Hub')),
            const SizedBox(height: 10),
            ElevatedButton.icon(onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Online Class!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }, icon: const Icon(Icons.computer), label: const Text('Online Class')),

          ],
        ),

      ),
    );
  }
}

class ScoreTrackerPage extends StatelessWidget {
  const ScoreTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achieve Target')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.note_alt_rounded, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            const Text('Track your Score', style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Image.asset('assets/image1/pg5.png', height: 250,width:250),
            const SizedBox(height: 10),
            Image.network('https://ecdn.teacherspayteachers.com/cdn-cgi/image/format=avif,quality=70,onerror=redirect/thumbitem/Test-Score-Tracking-Graph-Editable-12213276-1736100776/750f-12213276-1.jpg',height: 250,width: 250,),
            const Text('Download Score Tracker Graph', style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),

          ],
        ),
      ),
    );
  }
}

class LearnerPortalPage extends StatelessWidget {
  const LearnerPortalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learner Portal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.note_alt_rounded, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            const Text('Downloadable notes', style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Image.asset('assets/image1/pg6.png', height: 350,width:350),
          ],
        ),
      ),
    );
  }
}

class PracticeQuestionsPage extends StatelessWidget {
  const PracticeQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Questions Portal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.note_alt_outlined, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            const Text('Develop Problem Solving Skills and Practice important problems', style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Image.asset('assets/image1/Screenshot7.png', height: 250,width:250),
          ],
        ),
      ),
    );
  }
}

class DiscussionPage extends StatelessWidget {
  const DiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discussion Portal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.note_alt_rounded, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            const Text('Profound Presentation and Discussion', style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Image.asset('assets/image1/Screenshot5.png', height: 250,width:250),
            const SizedBox(height: 10),
            ElevatedButton.icon(onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Online Discussion'),
                  duration: Duration(seconds: 2),
                ),
              );
            }, icon: const Icon(Icons.computer), label: const Text('Online Discussion'),),
            const SizedBox(height: 10),
            ElevatedButton.icon(onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Offline Discussion!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }, icon: const Icon(Icons.room), label: const Text('Offline Discussion')),
            const SizedBox(height: 10),

          ],
        ),

      ),
    );
  }
}


class Grid4windowpage extends StatelessWidget {
const Grid4windowpage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridItems = [
      {
        'image': 'assets/image1/pg1.png',
        'title': 'Smart Tuition',
        'page': const SmartTuitionPage(),
      },
      {
        'image': 'assets/image1/pg2.png',
        'title': 'Mastery Learning',
        'page': const MasteryLearningPage(),
      },
      {
        'image': 'assets/image1/pg3.png',
        'title': 'Satisfactory Teaching',
        'page': const SatisfactoryTeachingPage(),
      },
      {
        'image': 'assets/image1/pg4.png',
        'title': 'Study Online or Offline',
        'page': const StudyModePage(),
      },

      {
        'image': 'assets/image1/pg5.png',
        'title': 'Target High Score',
        'page': const ScoreTrackerPage(),
      },

      {
        'image': 'assets/image1/pg6.png',
        'title': 'Clear Learning',
        'page': const LearnerPortalPage(),
      },

      {
        'image': 'assets/image1/Screenshot7.png',
        'title': 'ExamLevel Practice',
        'page': const PracticeQuestionsPage(),
      },

      {
        'image': 'assets/image1/Screenshot5.png',
        'title': 'Insightful Presentation and Revision Classes',
        'page': const DiscussionPage(),
      },
    ];

    // Alert Dialog
    void showItemDialog(BuildContext context, String title, Widget targetPage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: const Text('To view the details click Open View'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetPage),
                  );
                },
                child: const Text('Open View'),
              ),
            ],
          );
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:2,
              crossAxisSpacing:10,
              mainAxisSpacing:10,
              childAspectRatio:0.8,
            ),
            itemCount: gridItems.length,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: () {
                  showItemDialog(
                    context,
                    gridItems[index]['title']!,
                    gridItems[index]['page']!,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.asset(
                          gridItems[index]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                       Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            gridItems[index]['title']!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}



class Grid4windowpagest extends StatefulWidget {
  const Grid4windowpagest({super.key});

  @override
  State<Grid4windowpagest> createState() => _Grid4windowpagestState();
}

class _Grid4windowpagestState extends State<Grid4windowpagest> {
  final List<Map<String, dynamic>> gridItems = [
    {
      'image': 'assets/image1/pg1.png',
      'title': 'Smart Tuition',
      'page': const SmartTuitionPage(),
    },
    {
      'image': 'assets/image1/pg2.png',
      'title': 'Mastery Learning',
      'page': const MasteryLearningPage(),
    },
    {
      'image': 'assets/image1/pg3.png',
      'title': 'Satisfactory Teaching',
      'page': const SatisfactoryTeachingPage(),
    },
    {
      'image': 'assets/image1/pg4.png',
      'title': 'Study Online or Offline',
      'page': const StudyModePage(),
    },
    {
      'image': 'assets/image1/pg5.png',
      'title': 'Target High Score',
      'page': const ScoreTrackerPage(),
    },
    {
      'image': 'assets/image1/pg6.png',
      'title': 'Clear Learning',
      'page': const LearnerPortalPage(),
    },
    {
      'image': 'assets/image1/Screenshot7.png',
      'title': 'ExamLevel Practice',
      'page': const PracticeQuestionsPage(),
    },
    {
      'image': 'assets/image1/Screenshot5.png',
      'title': 'Insightful Presentation and Revision Classes',
      'page': const DiscussionPage(),
    },
  ];

  void showItemDialog(BuildContext context, String title, Widget targetPage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: const Text('To view the details click Open View'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => targetPage),
                );
              },
              child: const Text('Open View'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showItemDialog(
                    context,
                    gridItems[index]['title']!,
                    gridItems[index]['page']!,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.asset(
                          gridItems[index]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          gridItems[index]['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


class List4windowpagest extends StatefulWidget {
  const List4windowpagest({super.key});

  @override
  State<List4windowpagest> createState() => _List4windowpagestState();
}

class _List4windowpagestState extends State<List4windowpagest> {
  // डेटा लिस्ट आता स्टेट क्लासचा भाग आहे
  final List<Map<String, dynamic>> listItems = [
    {
      'image': 'assets/image1/pg1.png',
      'title': 'Smart Tuition',
      'page': const SmartTuitionPage(),
    },
    {
      'image': 'assets/image1/pg2.png',
      'title': 'Mastery Learning',
      'page': const MasteryLearningPage(),
    },
    {
      'image': 'assets/image1/pg3.png',
      'title': 'Satisfactory Teaching',
      'page': const SatisfactoryTeachingPage(),
    },
    {
      'image': 'assets/image1/pg4.png',
      'title': 'Study Online or Offline',
      'page': const StudyModePage(),
    },
    {
      'image': 'assets/image1/pg5.png',
      'title': 'Target High Score',
      'page': const ScoreTrackerPage(),
    },
    {
      'image': 'assets/image1/pg6.png',
      'title': 'Clear Learning',
      'page': const LearnerPortalPage(),
    },
    {
      'image': 'assets/image1/Screenshot7.png',
      'title': 'ExamLevel Practice',
      'page': const PracticeQuestionsPage(),
    },
    {
      'image': 'assets/image1/Screenshot5.png',
      'title': 'Insightful Presentation and Revision Classes',
      'page': const DiscussionPage(),
    },
  ];

  void showItemDialog(BuildContext context, String title, Widget targetPage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: const Text('To view the details click Open View'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => targetPage),
                );
              },
              child: const Text('Open View'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: listItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showItemDialog(
                    context,
                    listItems[index]['title']!,
                    listItems[index]['page']!,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          listItems[index]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            listItems[index]['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Create global key for form validation
  final _formKey = GlobalKey<FormState>();

  // 2. Define controllers to retrieve text values
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // 3. Validate form before processing
    if (_formKey.currentState!.validate()) {
      debugPrint("Email: ${_emailController.text}");
      debugPrint("Password: ${_passwordController.text}");
      // Add your authentication logic here (e.g., Firebase or API call)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Hides password characters
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBiodata extends StatelessWidget {
  const MyBiodata({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Biodata Form'),
          backgroundColor: Colors.blue,
        ),
        body: const SingleChildScrollView(
          child: BiodataForm(),
        ),
      ),
    );
  }
}

class BiodataForm extends StatefulWidget {
  const BiodataForm({super.key});

  @override
  State<BiodataForm> createState() => _BiodataFormState();
}

class _BiodataFormState extends State<BiodataForm> {
  // Form key tracking state
  final _formKey = GlobalKey<FormState>();

  // Input controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();

  // Memory cleanup
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Triggers validation logic
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully saved $name\'s biodata!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Age Field
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your age';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Profession Field
            TextFormField(
              controller: _professionController,
              decoration: const InputDecoration(
                labelText: 'Profession',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your profession';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Submit Biodata', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickBite Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class FoodItem {
  final String name;
  final String category;
  final String image;
  final double price;
  final double rating;

  const FoodItem({
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.rating,
  });
}

// Sample Data Array
const List<FoodItem> mockFoodList = [
  FoodItem(
    name: 'Cheesy Pepperoni Pizza',
    category: 'Pizza',
    image: '🍕',
    price: 12.99,
    rating: 4.8,
  ),
  FoodItem(
    name: 'Double Bacon Burger',
    category: 'Burger',
    image: '🍔',
    price: 8.49,
    rating: 4.6,
  ),
  FoodItem(
    name: 'Crunchy French Fries',
    category: 'Snacks',
    image: '🍟',
    price: 3.99,
    rating: 4.3,
  ),
  FoodItem(
    name: 'Berry Glazed Donut',
    category: 'Desserts',
    image: '🍩',
    price: 2.49,
    rating: 4.7,
  ),
];


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivering to', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('123 Innovation Way', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.deepOrange),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Layout
            TextField(
              decoration: InputDecoration(
                hintText: 'Search delicious meals...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Categories Row
            const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['All', 'Pizza', 'Burger', 'Snacks', 'Desserts'].map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(label: Text(cat), selected: cat == 'All'),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Restaurant Listings
            const Text('Popular Near You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockFoodList.length,
              itemBuilder: (context, index) {
                final item = mockFoodList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: Text(item.image, style: const TextStyle(fontSize: 40)),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(' ${item.rating} • 25 mins'),
                      ],
                    ),
                    trailing: Text('\$${item.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuScreen(item: item)),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class MenuScreen extends StatelessWidget {
  final FoodItem item;

  const MenuScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 220,
            color: Colors.orange.shade50,
            child: Center(child: Text(item.image, style: const TextStyle(fontSize: 100))),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            key: const Key('details_panel'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(label: Text(item.category)),
                const SizedBox(height: 12),
                Text(item.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(' ${item.rating} (120+ Reviews)', style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Prepared fresh with premium ingredients. Customizations are fully applicable upon checkout requests.',
                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} added to cart!')),
                );
              },
              child: Text(
                'Add to Basket — \$${item.price}',
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class NykaaApp extends StatelessWidget {
  const NykaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nykaa Clone',
      theme: ThemeData(
        primaryColor: const Color(0xFFE8006F), // Nykaa Pink
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// --- MAIN NAVIGATION SCREEN ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen1(),
    Center(child: Text('Categories', style: TextStyle(fontSize: 24))),
    Center(child: Text('Cart', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Bag'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFE8006F),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// --- HOME SCREEN ---
class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Text('Search for brands, products...', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
            IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Featured Brands', style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 120,
            child: BrandHorizontalList(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Best Sellers', style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        const ProductGrid(),
      ],
    );
  }
}

// --- HORIZONTAL BRAND LIST ---
class BrandHorizontalList extends StatelessWidget {
  const BrandHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = ['Nykaa', 'Maybelline', 'Loreal', 'MAC', 'Lakme'];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: brands.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                child: Text(brands[index][0], style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(brands[index], style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }
}

// --- PRODUCT GRID ---
class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Brand Name', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Product description goes here...', maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('₹ 599', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          );
        },
        childCount: 6,
      ),
    );
  }
}


