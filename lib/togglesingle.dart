import 'package:flutter/material.dart';

//void main() {
  //runApp(Demo());
//}

class Demo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
        appBar:  AppBar(title: Text("Toggle Image Grid"),centerTitle: true,backgroundColor: Colors.blue,
          leading: IconButton(onPressed: () {print('icon button clicked');}, icon: Icon(Icons.menu)),
          actions: [IconButton(onPressed: () {print('search button clicked');}, icon: Icon(Icons.search)),
            IconButton(onPressed: () {print('setting button clicked');},icon: Icon(Icons.settings)),
          ],
        ),
        body: ToggleGridItem(),
      ));
  }

}

class ToggleGridItem extends StatefulWidget {
  const ToggleGridItem({super.key});

  @override
  ToggleGridItemState createState() => ToggleGridItemState();
}

class ToggleGridItemState extends State<ToggleGridItem> {
  // 1. Create a state variable to track the toggle
  bool _isImageVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset("images/picsart.jpg",height: 150,width: 150,),
            Text("Image"),
        const SizedBox(height: 15),
        GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 3 columns
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: 4, // Total items
        itemBuilder: (context, index) {
          // GestureDetector to handle click
          return GestureDetector(
            onTap: () {
              setState(() {
                // 2. Toggle the state
                _isImageVisible = !_isImageVisible;

              });
            },
            child: Container(
              color: Colors.grey[300],
              child: _isImageVisible
                  ? Image.asset(
                'images/picsart.jpg', // Example image
                fit: BoxFit.cover,
              )
                  : SizedBox.shrink(), // 3. Show empty box
            ),
          );
        },
      ),
    ])));
  }

}
