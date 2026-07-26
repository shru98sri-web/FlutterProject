import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


 // void main() {
 //   runApp(const Mode());
  //}


class pagename extends StatelessWidget {
  const pagename({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NameStorageScreen(),
    );
  }
}


class NameStorageScreen extends StatefulWidget {
  const NameStorageScreen({super.key});

  @override
  State<NameStorageScreen> createState() => _NameStorageScreenState();
}

class _NameStorageScreenState extends State<NameStorageScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _savedName = "No name saved yet";

  @override
  void initState() {
    super.initState();
    _loadSavedName(); // Automatically load data when the app opens
  }

  // Load the name from SharedPreferences
  Future<void> _loadSavedName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // If 'saved_name' doesn't exist, use the default string
      _savedName = prefs.getString('saved_name') ?? "No name saved yet";
    });
  }

  // Save the name to SharedPreferences
  Future<void> _saveName() async {
    final String enteredName = _nameController.text.trim();

    if (enteredName.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_name', enteredName);

      setState(() {
        _savedName = enteredName; // Update UI immediately
        _nameController.clear();  // Clear input text field
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose(); // Clean up controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store User Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Displays the persisted name
            Text(
              'Hello, $_savedName!',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Input field for the new name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
                hintText: 'John Doe',
              ),
            ),
            const SizedBox(height: 16),

            // Button to commit data to storage
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveName,
                child: const Text(
                  'Save Name',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class Mode extends StatefulWidget {
  const Mode({super.key});

  @override
  State<Mode> createState() => _ModeState();
}

class _ModeState extends State<Mode> {
  ThemeMode _themeMode = ThemeMode.light; // Default theme state

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Load theme immediately at startup
  }

  // Fetch the saved theme preference from storage
  Future<void> _loadThemePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Read boolean: true = Dark Mode, false = Light Mode
      final bool isDark = prefs.getBool('is_dark_mode') ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Toggle and save the theme mode change
  Future<void> _toggleTheme(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define Light Theme properties
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      // Define Dark Theme properties
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      themeMode: _themeMode, // Dynamically updates the global app theme
      home: NameAndThemeScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class NameAndThemeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const NameAndThemeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<NameAndThemeScreen> createState() => _NameAndThemeScreenState();
}

class _NameAndThemeScreenState extends State<NameAndThemeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _savedName = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadSavedName();
  }

  Future<void> _loadSavedName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('saved_name') ?? "No name saved yet";
    });
  }

  Future<void> _saveName() async {
    final String enteredName = _nameController.text.trim();
    if (enteredName.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_name', enteredName);
      setState(() {
        _savedName = enteredName;
        _nameController.clear();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences Manager'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Theme preference row switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark Mode Theme',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Switch(
                  value: widget.isDarkMode,
                  onChanged: widget.onThemeChanged, // Triggers state change up to MyApp
                ),
              ],
            ),
            const Spacer(),

            // Name display section
            Text(
              'Hello, $_savedName!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveName,
                child: const Text('Save Name', style: TextStyle(fontSize: 16)),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// third prog
 void main() async {
  // 1. Ensure engine bindings are active before loading data
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Fetch all preferences beforehand to ensure instant UI rendering
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  final bool isDark = prefs.getBool('is_dark_mode') ?? false;

  runApp(MyApp2(isLoggedIn: isLoggedIn, initialDarkMode: isDark));
}

class MyApp2 extends StatefulWidget {
  final bool isLoggedIn;
  final bool initialDarkMode;

  const MyApp2({
    super.key,
    required this.isLoggedIn,
    required this.initialDarkMode
  });

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    // Initialize theme state from preloaded parameters
    _themeMode = widget.initialDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // Task 2 logic: Handle global application theme switching
  Future<void> _toggleTheme(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),
      themeMode: _themeMode,
      // Task 3 logic: Auto-routing guard based on auth status
      home: widget.isLoggedIn
          ? HomeScreen(isDarkMode: _themeMode == ThemeMode.dark, onThemeChanged: _toggleTheme)
          : const LoginScreen(),
    );
  }
}

// ==========================================
// LOGIN SCREEN WIDGET
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save global login flag status
      await prefs.setBool('is_logged_in', true);

      // Task 1 logic: Save the username automatically into the profile profile cache
      await prefs.setString('saved_name', _usernameController.text.trim());

      if (mounted) {
        // Fetch fresh theme settings to build the next view
        final bool isDark = prefs.getBool('is_dark_mode') ?? false;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              isDarkMode: isDark,
              onThemeChanged: (context.findAncestorStateOfType<_MyApp2State>()!)._toggleTheme,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Login'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_person, size: 64, color: Colors.indigo),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username / Name',
                  ),
                  validator: (val) => val!.trim().isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter a password' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Log In', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// HOME SCREEN (Task 1 & Task 2 Integration)
// ==========================================
class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameEditController = TextEditingController();
  String _savedName = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadSavedName();
  }

// Task 1: Auto-fetch stored user identity string
  Future<void> _loadSavedName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('saved_name') ?? "User";
    });
  }

// Task 1: Allow users to overwrite their persistent profile strings
  Future<void> _updateName() async {
    final String cleanText = _nameEditController.text.trim();
    if (cleanText.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_name', cleanText);
      setState(() {
        _savedName = cleanText;
        _nameEditController.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name updated successfully!')),
        );
      }
    }
  }

// Task 3: Revoke session keys and clear app routing layers
  Future<void> _handleLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _nameEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Log Out',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// Theme Customization Module (Task 2 UI Switch)
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.palette),
                        SizedBox(width: 12),
                        Text(
                            'Dark Mode Option', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Switch(
                      value: widget.isDarkMode,
                      onChanged: widget.onThemeChanged,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

// Persistent Greeting Output Module (Task 1 UI Text Display)
            Center(
              child: Column(
                children: [
                  Text(
                    'Welcome back, $_savedName!',
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your preferences are safely stored.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Spacer(),

// Runtime Storage Overwrite Text Field (Task 1 UI Input Field)
            const Text(
              'Change display name:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameEditController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'New Name',
                      isDense: true,),),),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _updateName,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),),
                  child: const Text('Update'),
                ),
              ],),
          ],),),);
  }
}


