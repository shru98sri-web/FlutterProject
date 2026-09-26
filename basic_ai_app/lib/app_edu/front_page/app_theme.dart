import 'package:flutter/material.dart';

class AppTheme {
  static const Color navy = Color(0xFF08111F);
  static const Color dark = Color(0xFF0B1626);
  static const Color blue = Color(0xFF2563EB);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color purple = Color(0xFF7C3AED);
  static const Color light = Color(0xFFF7F9FC);
  static const Color text = Color(0xFF111827);
  static const Color muted = Color(0xFF64748B);

  static ThemeData get yellow {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue,
        brightness: Brightness.light,
      ),
      fontFamily: 'Arial',
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: text,
      ),
    );
  }
}
