import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/dashboard/dashboard_screen.dart';

class CareerAIApp extends StatelessWidget {
  const CareerAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF505CF5),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const DashboardScreen(),
    );
  }
}
