import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class AIChurnApp extends StatefulWidget {
  const AIChurnApp({super.key});

  @override
  State<AIChurnApp> createState() => _AIChurnAppState();
}

class _AIChurnAppState extends State<AIChurnApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Customer Intelligence',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
