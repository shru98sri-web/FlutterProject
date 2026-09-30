// ============================================================
// APP
// ============================================================

import 'package:flutter/material.dart';

import '../home/home.dart';

class VocabularyAIApp extends StatelessWidget {
  const VocabularyAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF08111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF87CEEB),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const VocabularyHome(),
    );
  }
}
