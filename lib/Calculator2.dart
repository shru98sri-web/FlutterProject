import 'package:flutter/material.dart';

//void main() {
  //runApp(Demo());

//}

class Demo extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(debugShowCheckedModeBanner: false,
        home:Calculator());



  }

}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String image1='https://static.vecteezy.com/system/resources/thumbnails/006/591/455/small/math-formula-on-blackboard-isolated-grid-background-free-vector.jpg';
  String image2='https://static.vecteezy.com/system/resources/thumbnails/022/085/877/small/mathematics-doodle-set-education-and-study-concept-school-equipment-maths-formulas-in-sketch-style-hand-drawn-ector-illustration-isolated-on-white-background-vector.jpg';
  String image3='https://www.shutterstock.com/shutterstock/photos/2267618757/display_1500/stock-vector-math-and-number-text-banner-illustration-2267618757.jpg';

  void _updateMessage(String newMessage){
    setState(() {
      var message= newMessage;
    });
  }

  final TextEditingController _acontroller = TextEditingController();
  final TextEditingController _bcontroller = TextEditingController();

  String _resultLabel = "Null";
  String _resultValue = "0";

  void _calculate(String operation) {
    double? a = double.tryParse(_acontroller.text);
    double? b = double.tryParse(_bcontroller.text);

    if (a == null || b == null) {
      setState(() {
        _resultLabel = "Error";
        _resultValue = "Invalid input";
      });
      return;
    }

    setState(() {
      switch (operation) {
        case '+':
          _resultLabel = "(Sum)";
          _resultValue = (a + b).toString();
          break;
        case '-':
          _resultLabel = "(Difference)";
          _resultValue = (a - b).toString();
          break;
        case '*':
          _resultLabel = "(Multiplication)";
          _resultValue = (a * b).toString();
          break;
        case '/':
          _resultLabel = "(Division)";
          _resultValue = b != 0 ? (a / b).toStringAsFixed(2) : "0 ने भागत येत नाही";
          break;
        case '%':
          _resultLabel = "(Mod Division)";
          _resultValue = b != 0 ? (a % b).toString() : "0 ने भागत येत नाही";
          break;
      }
    });
  }

       //(Helper Function)
  Widget _buildOpButton(String op) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          onPressed: () => _calculate(op),
          child: Text(
            op,
            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        centerTitle: true,
        leading: IconButton(onPressed: () => _updateMessage("Menu icon clicked") ,
            icon: const Icon(Icons.menu)
        ),
        actions: [
          IconButton(onPressed: () => _updateMessage("Book icon clicked"),
              icon: const Icon(Icons.book)
          ),
          IconButton(onPressed: () => _updateMessage("Wifi icon clicked"),
              icon: const Icon(Icons.wifi)
          ),
          IconButton(onPressed: () => _updateMessage("Setting icon clicked"),
              icon: const Icon(Icons.settings)
          ),
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // इनपुट फील्ड्स
              TextField(
                controller: _acontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Input of a",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bcontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Input of b",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  _buildOpButton('+'),
                  _buildOpButton('-'),
                  _buildOpButton('*'),
                  _buildOpButton('/'),
                  _buildOpButton('%'),
                ],
              ),
              const SizedBox(height: 7),




              // (Result Display Card)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        _resultLabel,
                        style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        _resultValue,
                        style: const TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    IconButton(
                        icon: Image.network(image1,height:250,width:250,),
                        iconSize: 250,
                        onPressed: () {
                          setState(() {
                            icon:
                            print('Image1 clicked');
                            image1= image2;
                          },);
                        },
                        onLongPress:() {
                          setState(() {
                            icon:
                            Image.network(image2, height: 250, width: 250,);
                            print('Image2 clicked');
                            image2 = image3;
                          },);
                          onPressed() {
                            setState(() {
                              icon:
                              Image.network(image3, height: 250, width: 250,);
                              print('Image3 clicked');
                              image3 = image1;
                            },);
                          };
                        }
                        )
                          ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
