import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RememberMeDemo(),
    );
  }
}

class RememberMeDemo extends StatefulWidget {
  const RememberMeDemo({super.key});

  @override
  State<RememberMeDemo> createState() => _RememberMeDemoState();
}

class _RememberMeDemoState extends State<RememberMeDemo> {
  // Controllers for input fields
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Remember Me checkbox state
  bool _rememberMe = false;

  // Variables to show currently saved data on UI
  String savedUserId =  "No Data Found";
  String savedPassword = "No Data Found";

  // --- State Management Logic (As requested) ---
  // Tracks history for the User ID field
  String _currentUserIdState = "";
  String? _previousUserIdState;


  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // App री-ओपन झाल्यावर डेटा ऑटोमॅटिक लोड होईल
  }

  // Updates state history whenever User ID changes
  void _updateUserIdState(String newValue) {
    setState(() {
      _previousUserIdState = _currentUserIdState;
      _currentUserIdState = newValue;
    });
  }

  // Undo function to restore previous text in User ID field
  void _undoUserId() {
    if (_previousUserIdState != null) {
      setState(() {
        _currentUserIdState = _previousUserIdState!;
        userIdController.text = _currentUserIdState;
        _previousUserIdState = null; // Reset clear history after undo
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Undo Applied to User ID!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No previous state available to undo.")),
      );
    }
  }

  // --- SharedPreferences Storage Logic ---

  // 1. Load Data on App Reopen
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // SharedPreferences
      final String? storedUser = prefs.getString('saved_user_id');
      final String? storedPass = prefs.getString('saved_password');
      final bool? isRemembered = prefs.getBool('remember_me');

      _rememberMe = isRemembered ?? false;

      if (_rememberMe && storedUser != null && storedPass != null) {
        userIdController.text = storedUser;
        passwordController.text = storedPass;
        _currentUserIdState = storedUser;

        savedUserId = storedUser;
        savedPassword = "••••••••"; // saved password
      }
    });
  }

  // 2. Save or Clear Data on Login Button Tap
  Future<void> _handleLoginAndSave() async {
    final prefs = await SharedPreferences.getInstance();

    if (_rememberMe) {
      // जर Checkbox टिक असेल तर डेटा सेव्ह करा
      await prefs.setString('saved_user_id', userIdController.text);
      await prefs.setString('saved_password', passwordController.text);
      await prefs.setBool('remember_me', true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credentials Saved! App will remember you.")),
      );
    } else {
      // जर Checkbox अन-टिक असेल तर जुना डेटा डिलीट करा
      await prefs.remove('saved_user_id');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credentials Cleared from memory.")),
      );
    }

    // UI वरील डेटा अपडेट करण्यासाठी
    setState(() {
      savedUserId = userIdController.text.isNotEmpty ? userIdController.text : "No Data Found";
      savedPassword = passwordController.text.isNotEmpty ? "••••••••" : "No Data Found";
    });
  }

  // 3. Clear All Button Logic
  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      userIdController.clear();
      passwordController.clear();
      _rememberMe = false;
      _currentUserIdState = "";
      _previousUserIdState = null;
      savedUserId = "All Data Cleared";
      savedPassword = "All Data Cleared";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Remember Me & State Sync"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User ID Input Field
            TextField(
              controller: userIdController,
              onChanged: (text) => _updateUserIdState(text),
              decoration: const InputDecoration(
                labelText: "User ID / Username",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Password Input Field
            TextField(
              controller: passwordController,
              obscureText: true, // पासवर्ड लपवण्यासाठी
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Remember Me Checkbox Row
            CheckboxListTile(
              title: const Text("Remember Me on this device"),
              value: _rememberMe,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
            ),
            const SizedBox(height: 15),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: _handleLoginAndSave,
              icon: const Icon(Icons.login),
              label: const Text("Login & Save State"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _undoUserId,
                    icon: const Icon(Icons.undo),
                    label: const Text("Undo User ID"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text("Clear Memory"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // SharedPreferences Status Display
            const Text(
              "Active SharedPreferences Session:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text("Logged User ID: $savedUserId", style: const TextStyle(fontSize: 16, color: Colors.green)),
            Text("Logged Password: $savedPassword", style: const TextStyle(fontSize: 16, color: Colors.green)),
            const SizedBox(height: 20),

            // Behind-the-scenes state monitor cards
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Undo State Tracker:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                    const SizedBox(height: 5),
                    Text("Current Workspace State: '$_currentUserIdState'"),
                    Text("Previous History Undo State: '${_previousUserIdState ?? 'None'}'"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//keywords for state setting
// int _currentState = 0;
// int? _previousState;
//
// void _updateState(int newValue)
// {
//   setState(() {
//     _previousState = _currentState;
//     _currentState = newValue;
//   });
// }
//
// void _undo(){
//   if(_previousState != null){
//     setState(() {
//       _currentState= _previousState!;
//     });
//   }
// }
//
// Future<void> _saveState(int value)async{
//   final prefs=await SharedPreferences.getInstance();
//   await prefs.setInt('saved_state',value);
// }