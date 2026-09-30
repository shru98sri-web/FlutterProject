// ============================================================
// HISTORY
// ============================================================

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocab_builder/main.dart';

class HistoryPage extends StatelessWidget {
  final List<AssessmentRecord> history;

  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assessment History')),
      body: history.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.white38),
                  SizedBox(height: 12),
                  Text('No assessments yet.'),
                  SizedBox(height: 6),
                  Text(
                    'Complete a test to create history.',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: history.length,
              itemBuilder: (_, index) {
                final item = history[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${item.score}')),
                    title: Text(
                      '${item.percentage.toStringAsFixed(1)}% • ${item.level}',
                    ),
                    subtitle: Text(
                      '${item.date.day}/${item.date.month}/${item.date.year}'
                      ' • Avg ${item.averageTime.toStringAsFixed(1)}s',
                    ),
                    trailing: item.voiceScore > 0
                        ? Text('Voice ${item.voiceScore}')
                        : null,
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// JSON VIEWER
// ============================================================

class JsonPage extends StatefulWidget {
  final List<VocabularyWord> words;

  const JsonPage({super.key, required this.words});

  @override
  State<JsonPage> createState() => _JsonPageState();
}

class _JsonPageState extends State<JsonPage> {
  bool pretty = true;

  String get jsonText {
    final data = {
      'metadata': {
        'title': 'Current English Vocabulary Bank',
        'entry_count': widget.words.length,
        'schema': [
          'id',
          'word',
          'letter',
          'difficult_cefr_style',
          'difficulty',
          'parts_of_speech',
          'definition',
          'meaning',
          'synonyms',
          'example',
          'gmat_relavance',
          'ielts_relavance',
          'usage',
          'current_status',
          'year_focus',
          'source_reference',
          'source_note',
        ],
      },
      'words': widget.words.map((e) => e.toJson()).toList(),
    };

    return pretty
        ? const JsonEncoder.withIndent('  ').convert(data)
        : jsonEncode(data);
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: jsonText));

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('JSON copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary JSON'),
        actions: [
          IconButton(
            tooltip: 'Copy JSON',
            onPressed: _copy,
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            tooltip: 'Pretty JSON',
            onPressed: () {
              setState(() {
                pretty = !pretty;
              });
            },
            icon: Icon(pretty ? Icons.format_align_left : Icons.code),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF020817),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white12),
        ),
        child: SingleChildScrollView(
          child: SelectableText(
            jsonText,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
