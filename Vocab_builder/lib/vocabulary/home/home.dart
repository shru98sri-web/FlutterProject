// ============================================================
// HOME
// ============================================================

import 'dart:convert';

import 'package:vocab_builder/vocabulary/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../history_page_fortest/history_page.dart';
import '../json_viewer/json_viewer.dart';
import '../test/test_launcher/test_launcher.dart';
import '../test/test_models/test_models.dart';
import '../vocabulary model/vocabulary_model.dart';
import '../voice_tutor/voice_tutor.dart';

class VocabularyHome extends StatefulWidget {
  const VocabularyHome({super.key});

  @override
  State<VocabularyHome> createState() => _VocabularyHomeState();
}

class _VocabularyHomeState extends State<VocabularyHome> {
  int selectedIndex = 0;

  List<VocabularyWord> words = [];
  bool loading = true;
  String? error;

  final List<AssessmentRecord> history = [];

  @override
  void initState() {
    super.initState();
    loadVocabulary();
  }

  Future<void> loadVocabulary() async {
    try {
      final raw = await rootBundle.loadString(
        'assets/vocabulary.json',
      );

      final decoded = jsonDecode(raw);

      List<dynamic> list = [];

      if (decoded is Map<String, dynamic>) {
        if (decoded['words'] is List) {
          list = decoded['words'];
        }
      } else if (decoded is List) {
        list = decoded;
      }

      final loaded = list
          .whereType<Map>()
          .map(
            (item) => VocabularyWord.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where((item) => item.word.trim().isNotEmpty)
          .toList();

      setState(() {
        words = loaded;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  void addHistory(AssessmentRecord record) {
    setState(() {
      history.insert(0, record);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Vocabulary AI'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to load vocabulary.json\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final pages = [
      DashboardPage(
        words: words,
        onTest: () {
          setState(() {
            selectedIndex = 1;
          });
        },
      ),
      TestLauncher(
        words: words,
        onCompleted: addHistory,
      ),
      VoiceTutorPage(words: words),
      HistoryPage(history: history),
      JsonPage(words: words),
    ];

    final destinations = [
      const NavigationRailDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: Text('Dashboard'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.quiz_outlined),
        selectedIcon: Icon(Icons.quiz),
        label: Text('Test'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.mic_none),
        selectedIcon: Icon(Icons.mic),
        label: Text('Voice'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.history),
        selectedIcon: Icon(Icons.history),
        label: Text('History'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.data_object),
        selectedIcon: Icon(Icons.data_object),
        label: Text('JSON'),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: destinations,
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: pages[selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
