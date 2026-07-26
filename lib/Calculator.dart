import 'package:flutter/material.dart';

//void main() {
  //runApp(const MaterialApp(
    //home: Calculator(),
    //debugShowCheckedModeBanner: false,
 // ));
//}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  // Fixed naming capitalization consistency
  final TextEditingController _acontroller = TextEditingController();
  final TextEditingController _bcontroller = TextEditingController();

  // Changed to String to properly handle both numeric results and 'Invalid' messages
  String _sum = "0";
  String _sub = "0";
  String _multi = "0";
  String _div = "0";
  String _mod = "0";

  // Moved calculation function inside the State class where setState lives
  void _calculation() {
    // Fixed typo: double.tryParse is case-sensitive
    double? a = double.tryParse(_acontroller.text);
    double? b = double.tryParse(_bcontroller.text);

    if (a != null && b != null) {
      setState(() {
        _sum = (a + b).toString();
        _sub = (a - b).toString();
        _multi = (a * b).toString();
        // Prevent division by zero runtime crash
        _div = b != 0 ? (a / b).toStringAsFixed(2) : "Cannot divide by 0";
        _mod = b != 0 ? (a % b).toString() : "Cannot divide by 0";
      });
    } else {
      setState(() {
        _sum = "Invalid input";
        _sub = "Invalid input";
        _multi = "Invalid input";
        _div = "Invalid input";
        _mod = "Invalid input";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        backgroundColor: Colors.blue,
      ),
      // SingleChildScrollView prevents overflow errors when keyboard pops up
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _acontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Variable a",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _bcontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Variable b",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Trigger the math operation using a single action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Calculate All", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 25),

              // Consolidated result display area with correct styling properties
              const Text("Results:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Sum = $_sum", style: const TextStyle(fontSize: 18, color: Colors.blue)),
              Text("Difference = $_sub", style: const TextStyle(fontSize: 18, color: Colors.blue)),
              Text("Multiplication = $_multi", style: const TextStyle(fontSize: 18, color: Colors.blue)),
              Text("Division = $_div", style: const TextStyle(fontSize: 18, color: Colors.blue)),
              Text("Mod Division = $_mod", style: const TextStyle(fontSize: 18, color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
