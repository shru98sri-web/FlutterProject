import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: OhmCalculator(),
    debugShowCheckedModeBanner: false,
  ));
}

class OhmCalculator extends StatefulWidget {
  @override
  _OhmCalculatorState createState() => _OhmCalculatorState();
}

class _OhmCalculatorState extends State<OhmCalculator> {
  // १. दोन इनपुटसाठी दोन कंट्रोलर्स
  final TextEditingController _iController = TextEditingController(); // Current (I)
  final TextEditingController _rController = TextEditingController(); // Resistance (R)

  String _result = "0";

  // २. कॅल्क्युलेशन फंक्शन
  void _calculateVoltage() {
    double? current = double.tryParse(_iController.text);
    double? resistance = double.tryParse(_rController.text);

    if (current != null && resistance != null) {
      setState(() {
        _result = (current * resistance).toStringAsFixed(2);
      });
    } else {
      setState(() {
        _result = "Invalid Input";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ohm's Law (V = IR)"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Current (I) साठी इनपुट
            TextField(
              controller: _iController,
              keyboardType: TextInputType.number, // फक्त नंबर कीबोर्ड उघडेल
              decoration: InputDecoration(
                labelText: "Current (I) in Amperes",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            // Resistance (R) साठी इनपुट
            TextField(
              controller: _rController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Resistance (R) in Ohms",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // ३. कॅल्क्युलेट बटन
            ElevatedButton(
              onPressed: _calculateVoltage,
              child: Text("Calculate Voltage (V)"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),

            SizedBox(height: 30),

            // ४. आउटपुट रिझल्ट
            Text("Result:", style: TextStyle(fontSize: 16)),
            Text(
              "V = $_result Volts",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height:20),
            Image.network('https://images.edrawmax.com/images/knowledge/circuit-1-what-is-a-circuit-diagram.jpg',height:200,width:200),

          ],
        ),
      ),
    );
  }
}