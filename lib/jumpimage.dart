import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

void main() {
  runApp(Demo());
}
class Demo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar:  AppBar(title: Text("Toggle Image Grid"),centerTitle: true,backgroundColor: Colors.blue,
            leading: IconButton(onPressed: () {print('Icon button clicked');}, icon: Icon(Icons.menu)),
            actions: [IconButton(onPressed: () {print('Search button clicked');}, icon: Icon(Icons.search)),
              IconButton(onPressed: () {print('Setting button clicked');}, icon: Icon(Icons.settings)),



            ],
          ),
          body: MovingImageGrid(),
        ));
  }

}

class MovingImageGrid extends StatefulWidget {
  const MovingImageGrid({super.key});

  @override
  State<MovingImageGrid> createState() => _MovingImageGridState();
}

class _MovingImageGridState extends State<MovingImageGrid> {
  // Tracks which cell holds the moving image. -1 means nowhere (all default).
  int _activeIndex = -1;

  void _moveImage() {
    setState(() {
      // Increments from 0 -> 1 -> 2 -> 3 and then resets to 0
      _activeIndex = (_activeIndex + 1) % 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Image.asset("images/birthday.jpg",height: 150,width: 150,),
        Text("Image"),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Transaction Completed Successfully!',
            );
    },
          child: const Text('Move File'),
        ),
        //https:pub.dev/packages/quickalert
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              text: 'You just broke protocol',
            );
          },
          child: const Text('Warning'),
        ),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              title: 'Loading',
              text: 'Fetching your data',
            );
          },
          child: const Text('Data Load'),
        ),
        SizedBox(height:15),
        ElevatedButton(
          onPressed: _moveImage,
          child: const Text('Move Image'),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Creates a 2x2 grid
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              // Checks if this specific cell is the active one
              final bool isActive = index == _activeIndex;

              return Container(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[300],
                child: isActive
                    ? Image.asset('images/birthday.jpg',height: 150,width: 150,) // Your special image
                    : SizedBox.square(),
                //Image.asset('images/imgtobeadded.jpg'),  Default image
              );
            },
          ),
        ),

      ],
    );
  }
}
