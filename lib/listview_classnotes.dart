import 'package:flutter/material.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

//void main()
//{
  //runApp(const ListV());
//}

class ListV extends StatelessWidget{
  const ListV({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List View',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,

      ),
      home: const ListVState(),
    );
  }

}

class ListVState extends StatefulWidget {
  const ListVState({super.key});

  @override
  State<ListVState> createState() => _ListVStateState();
}

class _ListVStateState extends State<ListVState> {
  // डेटा लिस्ट
  final List<String> titleVal = ['Sachin', 'Virat', 'Rohit', 'Dhoni', 'Raina', 'Hardik', 'Abisheak', 'Bumrah'];
  final List<String> subTitleVal = ['BAT', 'BAT', 'CAP', 'WK', 'Left Bat', 'All Rounder', 'BAT', 'Fast Bowler'];

  void showAlert(BuildContext context, String name, String desc) {
    // टीप: यासाठी तुमच्या pubspec.yaml मध्ये rflutter_alert पॅकेज असणे आवश्यक आहे.
    // जर नसेल तर तुम्ही Flutter चा Standard 'showDialog' वापरू शकता.
    Alert(
      context: context,
      title: name,
      desc: desc,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List View'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: titleVal.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(titleVal[index]),
            subtitle: Text(subTitleVal[index]), // डायनॅमिक सबटायटल जोडले
            leading: const Icon(Icons.ac_unit),
            onTap: () {
              // इथून दुसऱ्या पेजवर डेटा पाठवला जाईल
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailStatePage(userName: titleVal[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// दुसऱ्या पेजचा कोड (DetailStatePage) - एरर टाळण्यासाठी हा क्लास आवश्यक आहे
class DetailStatePage extends StatelessWidget {
  final String userName;

  const DetailStatePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Welcome, $userName!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// Alert क्लासचा डमी स्ट्रक्चर (जर तुम्ही rflutter_alert वापरत नसाल तर एरर येऊ नये म्हणून)
class Alert {
  final BuildContext context;
  final String title;
  final String desc;

  Alert({required this.context, required this.title, required this.desc});

  void show() {
    // इकडे तुमची अलर्ट दाखवण्याची लॉजिक असेल
    print("Alert Shown: $title - $desc");
  }
}
