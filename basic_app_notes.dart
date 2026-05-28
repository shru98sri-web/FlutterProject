import 'package:flutter/material.dart';
import 'package:sample_self/ScientificCalculatorApp.dart';
import 'package:sample_self/calender.dart';
import 'package:sample_self/json_example.dart';
import 'package:sample_self/newprog.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 1. Add theme state
  ThemeMode _themeMode = ThemeMode.light;

  // 2. Add a function to toggle theme
  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Training Application',
      // 3. Set the themes
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      // 4. Pass the toggle function and current state down
      home: MainPage(
          toggleTheme: _toggleTheme,
          isDarkMode: _themeMode == ThemeMode.dark
      ),
    );
  }
}


class MainPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const MainPage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;


  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const ProfilePage(),
    TogglePageManager(),
    Jsontuition(),
    CustomCalendarPage(),
    AdvancedCalculatorApp()

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Class'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _showSettingsDialog(context);
                },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Class',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          )

        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Class';
      case 2:
        return 'Profile';
        case 3:
        return 'Info';
      case 4:
        return 'Shop';
      case 5:
        return 'Calender';
      case 6:
        return 'Calculator';
      default:
        return 'My App';
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use StatefulBuilder so the switch moves immediately
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Settings'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Dark Mode'),
                  Switch(
                    value: widget.isDarkMode,
                    onChanged: (value) {
                      // Updates the main app
                      widget.toggleTheme(value);
                      // Updates the switch UI inside the dialog
                      setStateDialog(() {});
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

// ... (rest of your build method)
}

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text('Flutter App\nVersion 1.0.0\n\nA demo app with drawer and bottom navigation.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


// Home Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Home Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Welcome to Home Page!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}

// Search Page
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.note_alt,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Class Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Attendance Tracker',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Number of classes attended...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSubmitted: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Number of classes $value'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Profile Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'S Shruthi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'shru98sri@gmail.com',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('+91 9566231908'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Chennai,TamilNadu'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.book),
                      title: Text('Qualification: Master of Science'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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