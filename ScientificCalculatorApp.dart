import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const AdvancedCalculatorApp());
}

class AdvancedCalculatorApp extends StatefulWidget {
  const AdvancedCalculatorApp({super.key});

  @override
  State<AdvancedCalculatorApp> createState() => _AdvancedCalculatorAppState();
}

class _AdvancedCalculatorAppState extends State<AdvancedCalculatorApp> {
  bool _isDarkMode = true;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ultimate Calculator',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MainNavigationScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  const MainNavigationScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  String _currentScreen = 'Scientific Calculator';
  final List<String> _historyLog = [];

  void addToHistory(String expression, String result) {
    setState(() {
      _historyLog.insert(0, '$expression = $result');
    });
  }

  void clearHistory() {
    setState(() {
      _historyLog.clear();
    });
  }

  Widget _getScreen() {
    switch (_currentScreen) {
      case 'Scientific Calculator':
        return ScientificCalculator(onCalculate: addToHistory);
      case 'All-in-One Converter':
        return const AllUnitConverterScreen();
      case 'Calculation History':
        return HistoryScreen(history: _historyLog, onClear: clearHistory);
      case 'App Settings':
        return SettingsScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode);
      default:
        return ScientificCalculator(onCalculate: addToHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentScreen),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                'Calculator Menu',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.science),
              title: const Text('Scientific Calculator'),
              onTap: () {
                setState(() => _currentScreen = 'Scientific Calculator');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sync_alt),
              title: const Text('All-in-One Converter'),
              onTap: () {
                setState(() => _currentScreen = 'All-in-One Converter');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Calculation History'),
              onTap: () {
                setState(() => _currentScreen = 'Calculation History');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('App Settings'),
              onTap: () {
                setState(() => _currentScreen = 'App Settings');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _getScreen(),
    );
  }
}

// 1. SCIENTIFIC CALCULATOR COMPONENT
class ScientificCalculator extends StatefulWidget {
  final Function(String, String) onCalculate;
  const ScientificCalculator({super.key, required this.onCalculate});

  @override
  State<ScientificCalculator> createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  String _expression = '';
  String _result = '0';
  bool _isRad = true;

  void _onPressed(String text) {
    setState(() {
      if (text == 'C') {
        _expression = '';
        _result = '0';
      } else if (text == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (text == '=') {
        _calculate();
      } else if (text == 'RAD' || text == 'DEG') {
        _isRad = !_isRad;
      } else {
        _expression += text;
      }
    });
  }

  void _calculate() {
    if (_expression.isEmpty) return;
    try {
      String cleanExp = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString());

      double evalResult = _parseAndEvaluate(cleanExp);

      setState(() {
        if (evalResult.isNaN || evalResult.isInfinite) {
          _result = 'Error';
        } else {
          _result = evalResult == evalResult.toInt().toDouble()
              ? evalResult.toInt().toString()
              : evalResult.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
          widget.onCalculate(_expression, _result);
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  double _parseAndEvaluate(String exp) {
    exp = exp.trim();
    if (exp.isEmpty) return 0.0;

    if (exp.endsWith('!')) {
      double val = _parseAndEvaluate(exp.substring(0, exp.length - 1));
      return _factorial(val.toInt()).toDouble();
    }

    if (exp.startsWith('sin(') && exp.endsWith(')')) {
      double val = _parseAndEvaluate(exp.substring(4, exp.length - 1));
      return _isRad ? math.sin(val) : math.sin(val * math.pi / 180);
    }
    if (exp.startsWith('cos(') && exp.endsWith(')')) {
      double val = _parseAndEvaluate(exp.substring(4, exp.length - 1));
      return _isRad ? math.cos(val) : math.cos(val * math.pi / 180);
    }
    if (exp.startsWith('tan(') && exp.endsWith(')')) {
      double val = _parseAndEvaluate(exp.substring(4, exp.length - 1));
      return _isRad ? math.tan(val) : math.tan(val * math.pi / 180);
    }
    if (exp.startsWith('√(') && exp.endsWith(')')) {
      double val = _parseAndEvaluate(exp.substring(2, exp.length - 1));
      return math.sqrt(val);
    }

    if (exp.contains('+')) {
      int idx = exp.lastIndexOf('+');
      return _parseAndEvaluate(exp.substring(0, idx)) + _parseAndEvaluate(exp.substring(idx + 1));
    }
    if (exp.contains('-')) {
      int idx = exp.lastIndexOf('-');
      if (idx > 0 && RegExp(r'[0-9)]').hasMatch(exp[idx - 1])) {
        return _parseAndEvaluate(exp.substring(0, idx)) - _parseAndEvaluate(exp.substring(idx + 1));
      }
    }
    if (exp.contains('*')) {
      int idx = exp.lastIndexOf('*');
      return _parseAndEvaluate(exp.substring(0, idx)) * _parseAndEvaluate(exp.substring(idx + 1));
    }
    if (exp.contains('/')) {
      int idx = exp.lastIndexOf('/');
      double divisor = _parseAndEvaluate(exp.substring(idx + 1));
      if (divisor == 0) return double.nan;
      return _parseAndEvaluate(exp.substring(0, idx)) / divisor;
    }
    if (exp.contains('^')) {
      int idx = exp.indexOf('^');
      return math.pow(_parseAndEvaluate(exp.substring(0, idx)), _parseAndEvaluate(exp.substring(idx + 1))).toDouble();
    }

    return double.tryParse(exp) ?? 0.0;
  }

  int _factorial(int n) {
    if (n < 0) return 0;
    if (n == 0 || n == 1) return 1;
    return n * _factorial(n - 1);
  }

  Widget _buildButton(String text, Color color, {Color textColor = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onPressed: () => _onPressed(text),
          child: Text(text, style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // FIXED: Changed from mainaxisalignment.leading to MainAxisAlignment.start
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.orange,
                      child: Text(_isRad ? 'RAD' : 'DEG', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(_expression, style: const TextStyle(fontSize: 24, color: Colors.grey)),
                ),
                const SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(_result, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Row(children: [_buildButton(_isRad ? 'DEG' : 'RAD', Colors.lightGreen), _buildButton('π', Colors.lightGreen), _buildButton('e', Colors.lightGreen), _buildButton('!', Colors.lightGreen)]),
            Row(children: [_buildButton('sin(', Colors.lightGreen), _buildButton('cos(', Colors.lightGreen), _buildButton('tan(', Colors.lightGreen), _buildButton('^', Colors.lightGreen)]),
            Row(children: [_buildButton('√(', Colors.lightGreen), _buildButton('(', Colors.grey), _buildButton(')', Colors.grey), _buildButton('⌫', Colors.orangeAccent)]),
            Row(children: [_buildButton('C', Colors.green), _buildButton('÷', Colors.green), _buildButton('×', Colors.green), _buildButton('-', Colors.green)]),
            Row(children: [_buildButton('7', Colors.grey!), _buildButton('8', Colors.grey!), _buildButton('9', Colors.grey!), _buildButton('+', Colors.green)]),
            Row(children: [_buildButton('4', Colors.grey!), _buildButton('5', Colors.grey!), _buildButton('6', Colors.grey!), _buildButton('=', Colors.greenAccent)]),
            Row(children: [_buildButton('1', Colors.grey!), _buildButton('2', Colors.grey!), _buildButton('3', Colors.grey!), _buildButton('0', Colors.grey!)]),
            Row(children: [_buildButton('.', Colors.grey!)]),
          ],
        )
      ],
    );
  }
}

// 2. ALL-IN-ONE UNIT CONVERTER COMPONENT
class AllUnitConverterScreen extends StatefulWidget {
  const AllUnitConverterScreen({super.key});

  @override
  State<AllUnitConverterScreen> createState() => _AllUnitConverterScreenState();
}

class _AllUnitConverterScreenState extends State<AllUnitConverterScreen> {
  String _selectedCategory = 'Length';
  String _fromUnit = 'Meter';
  String _toUnit = 'Kilometer';
  double _input = 0.0;
  String _outputText = '0.0';

  final Map<String, List<String>> _units = {
    'Currency': ['USD', 'INR', 'EUR', 'GBP'],
    'Length': ['Meter', 'Kilometer', 'Mile', 'Foot'],
    'Area': ['Square Meter', 'Acre', 'Hectare'],
    'Volume': ['Liter', 'Milliliter', 'Gallon'],
    'Weight': ['Kilogram', 'Gram', 'Pound'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Speed': ['Meters/Sec', 'Km/Hour', 'Miles/Hour'],
    'Pressure': ['Pascal', 'Bar', 'PSI'],
    'Power': ['Watt', 'Kilowatt', 'Horsepower'],
    'Number System': ['Decimal', 'Binary', 'Hexadecimal'],
  };

  void _convert() {
    setState(() {
      try {
        if (_selectedCategory == 'Number System') {
          int? decVal;
          if (_fromUnit == 'Decimal') decVal = _input.toInt();
          if (_fromUnit == 'Binary') decVal = int.tryParse(_input.toInt().toString(), radix: 2);

          if (decVal == null) { _outputText = 'Invalid Input'; return; }
          if (_toUnit == 'Decimal') _outputText = decVal.toString();
          if (_toUnit == 'Binary') _outputText = decVal.toRadixString(2);
          if (_toUnit == 'Hexadecimal') _outputText = decVal.toRadixString(16).toUpperCase();
          return;
        }

        double baseValue = _input;
        switch (_selectedCategory) {
          case 'Currency':
            if (_fromUnit == 'INR') baseValue = _input / 83.0;
            if (_fromUnit == 'EUR') baseValue = _input / 0.92;
            if (_fromUnit == 'GBP') baseValue = _input / 0.79;
            break;
          case 'Length':
            if (_fromUnit == 'Kilometer') baseValue = _input * 1000;
            if (_fromUnit == 'Mile') baseValue = _input * 1609.34;
            if (_fromUnit == 'Foot') baseValue = _input * 0.3048;
            break;
          case 'Area':
            if (_fromUnit == 'Acre') baseValue = _input * 4046.86;
            if (_fromUnit == 'Hectare') baseValue = _input * 10000;
            break;
          case 'Volume':
            if (_fromUnit == 'Milliliter') baseValue = _input / 1000;
            if (_fromUnit == 'Gallon') baseValue = _input * 3.78541;
            break;
          case 'Weight':
            if (_fromUnit == 'Gram') baseValue = _input / 1000;
            if (_fromUnit == 'Pound') baseValue = _input * 0.453592;
            break;
          case 'Temperature':
            break;
          case 'Speed':
            if (_fromUnit == 'Km/Hour') baseValue = _input / 3.6;
            if (_fromUnit == 'Miles/Hour') baseValue = _input * 0.44704;
            break;
          case 'Pressure':
            if (_fromUnit == 'Bar') baseValue = _input * 100000;
            if (_fromUnit == 'PSI') baseValue = _input * 6894.76;
            break;
          case 'Power':
            if (_fromUnit == 'Kilowatt') baseValue = _input * 1000;
            if (_fromUnit == 'Horsepower') baseValue = _input * 745.7;
            break;
        }

        double finalResult = baseValue;
        switch (_selectedCategory) {
          case 'Currency':
            if (_toUnit == 'INR') finalResult = baseValue * 83.0;
            if (_toUnit == 'EUR') finalResult = baseValue * 0.92;
            if (_toUnit == 'GBP') finalResult = baseValue * 0.79;
            break;
          case 'Length':
            if (_toUnit == 'Kilometer') finalResult = baseValue / 1000;
            if (_toUnit == 'Mile') finalResult = baseValue / 1609.34;
            if (_toUnit == 'Foot') finalResult = baseValue / 0.3048;
            break;
          case 'Area':
            if (_toUnit == 'Acre') finalResult = baseValue / 4046.86;
            if (_toUnit == 'Hectare') finalResult = baseValue / 10000;
            break;
          case 'Volume':
            if (_toUnit == 'Milliliter') finalResult = baseValue * 1000;
            if (_toUnit == 'Gallon') finalResult = baseValue / 3.78541;
            break;
          case 'Weight':
            if (_toUnit == 'Gram') finalResult = baseValue * 1000;
            if (_toUnit == 'Pound') finalResult = baseValue / 0.453592;
            break;
          case 'Temperature':
            if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') finalResult = (_input * 9 / 5) + 32;
            if (_fromUnit == 'Celsius' && _toUnit == 'Kelvin') finalResult = _input + 273.15;
            if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') finalResult = (_input - 32) * 5 / 9;
            if (_fromUnit == 'Fahrenheit' && _toUnit == 'Kelvin') finalResult = (_input - 32) * 5 / 9 + 273.15;
            if (_fromUnit == 'Kelvin' && _toUnit == 'Celsius') finalResult = _input - 273.15;
            if (_fromUnit == 'Kelvin' && _toUnit == 'Fahrenheit') finalResult = (_input - 273.15) * 9 / 5 + 32;
            break;
          case 'Speed':
            if (_toUnit == 'Km/Hour') finalResult = baseValue * 3.6;
            if (_toUnit == 'Miles/Hour') finalResult = baseValue / 0.44704;
            break;
          case 'Pressure':
            if (_toUnit == 'Bar') finalResult = baseValue / 100000;
            if (_toUnit == 'PSI') finalResult = baseValue / 6894.76;
            break;
          case 'Power':
            if (_toUnit == 'Kilowatt') finalResult = baseValue / 1000;
            if (_toUnit == 'Horsepower') finalResult = baseValue / 745.7;
            break;
        }

        _outputText = finalResult.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      } catch (e) {
        _outputText = 'Conversion Error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Select Category:', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            items: _units.keys.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
            onChanged: (val) {
              setState(() {
                _selectedCategory = val!;
                _fromUnit = _units[_selectedCategory]!.first;
                _toUnit = _units[_selectedCategory]!.first;
                _convert();
              });
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('From:'),
                    DropdownButton<String>(
                      value: _fromUnit,
                      isExpanded: true,
                      items: _units[_selectedCategory]!.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (val) => setState(() { _fromUnit = val!; _convert(); }),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('To:'),
                    DropdownButton<String>(
                      value: _toUnit,
                      isExpanded: true,
                      items: _units[_selectedCategory]!.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (val) => setState(() { _toUnit = val!; _convert(); }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Enter Value', border: OutlineInputBorder()),
            onChanged: (value) {
              _input = double.tryParse(value) ?? 0.0;
              _convert();
            },
          ),
          const SizedBox(height: 30),
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text('Result: $_outputText $_toUnit', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 3. HISTORY COMPONENT
class HistoryScreen extends StatelessWidget {
  final List<String> history;
  final VoidCallback onClear;
  const HistoryScreen({super.key, required this.history, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: onClear,
            icon: const Icon(Icons.delete, color: Colors.white),
            label: const Text('Clear Log History', style: TextStyle(color: Colors.white)),
          ),
        ),
        Expanded(
          child: history.isEmpty
              ? const Center(child: Text('No history logs available yet.'))
              : ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.calculate_outlined),
                title: Text(history[index], style: const TextStyle(fontSize: 16)),
              );
            },
          ),
        ),
      ],
    );
  }
}

// 4. SETTINGS COMPONENT
class SettingsScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  const SettingsScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Navigator.canPop(context) ? const SizedBox() : const SizedBox(), // Safe mock wrapper
          ListTile(
            title: const Text('App UI Theme Status'),
            subtitle: Text(isDarkMode ? 'Dark Mode Active' : 'Light Mode Active'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) => toggleTheme(),
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Build Engine State'),
            trailing: Text('v4.2.0 (Pure Dart Engine)', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
