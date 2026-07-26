import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SharedPreferenceDemo(),
    );
  }
}

class SharedPreferenceDemo extends StatefulWidget {
  const SharedPreferenceDemo({super.key});

  @override
  State<SharedPreferenceDemo> createState() =>
      _SharedPreferenceDemoState();
}

class _SharedPreferenceDemoState
    extends State<SharedPreferenceDemo> {

  TextEditingController nameController =
  TextEditingController();

   String savedName = "No Data";
//String savedName = "No Data";


   // @override
   // void initState() {
   //  super.initState();
   //   getData();
   // }


  Future<void> saveData() async {
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      "username",
      nameController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Saved"),
      ),
    );
    //getData();
    //to display previous state
  }

  Future<void> getData() async {
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    String? name =
    prefs.getString("username");

    setState(() {
      savedName = name ?? "No Data Found";
      //savedName = name?? "No Data Found"

       // if (name != null) {
       //   nameController.text = name;
       // }
// get data previous state
    });
  }

  Future<void> deleteData() async {
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove("username");

    setState(() {
      savedName = "No Data";

      // nameController.clear(); // TextField रिकामे करण्यासाठी


    });
  }

  Future<void> clearData() async {
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.clear();

    setState(() {
      savedName = "All Data Cleared";

      // nameController.clear(); // TextField रिकामे करण्यासाठी

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shared Preferences Demo",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Enter Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveData,
              child: const Text("Save"),
            ),

            ElevatedButton(
              onPressed: getData,
              child: const Text("Get Data"),
            ),

            ElevatedButton(
              onPressed: deleteData,
              child: const Text("Delete"),
            ),

            ElevatedButton(
              onPressed: clearData,
              child: const Text("Clear All"),
            ),

            const SizedBox(height: 30),

            Text(
              "Saved Name:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              savedName,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}