import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';


void main(){
  runApp(Welcome());
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: helloAlert(),
    );
  }
}

class helloAlert extends StatefulWidget {
  const helloAlert({super.key});
  @override
  State<helloAlert> createState() => _helloAlertState();
}

class _helloAlertState extends State<helloAlert> {

  void showSimpleAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert Title"),
          content: const Text("This is a simple alert message."),
          actions: [
            TextButton(
              onPressed: () {
                print('Alert Button Clicked');
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(onPressed: () {
          print('Showing Alert');
          showSimpleAlert(context);
        }, child: Text('Show Alert')),
      ),
    );
  }
}