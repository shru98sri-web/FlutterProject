import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main()
{
  runApp(Login());

}

class Login extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(home: LoginScreen(),debugShowCheckedModeBanner: false,);
  }

}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Define controllers and secure storage instance
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // 1. Read stored credentials and auto-fill fields if they exist
  Future<void> _loadSavedCredentials() async {
    try {
      final savedUser = await _storage.read(key: "username");
      final savedPass = await _storage.read(key: "password");
      final rememberMeStatus = await _storage.read(key: "remember_me");

      if (rememberMeStatus == "true" && savedUser != null && savedPass != null) {
        setState(() {
          _usernameController.text = savedUser;
          _passwordController.text = savedPass;
          _rememberMe = true;
        });
      }
    } catch (e) {
      debugPrint("Error reading secure storage: $e");
    }
  }

  // 2. Save or clear data depending on the checkbox state
  Future<void> _handleLoginPersistence() async {
    if (_rememberMe) {
      await _storage.write(key: "username", value: _usernameController.text);
      await _storage.write(key: "password", value: _passwordController.text);
      await _storage.write(key: "remember_me", value: "true");
    } else {
      await _storage.delete(key: "username");
      await _storage.delete(key: "password");
      await _storage.delete(key: "remember_me");
    }
  }

  // Fake authentication pipeline mock
  Future<void> _login() async {
    setState(() => _isLoading = true);

    // Simulate Network Request API delay
    await Future.delayed(const Duration(seconds: 2));

    // Handle credentials storage preference
    await _handleLoginPersistence();

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username or Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            // Checkbox Widget for "Remember Me"
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text("Remember me"),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
