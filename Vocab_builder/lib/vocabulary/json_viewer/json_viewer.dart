// ============================================================
// JSON VIEWER
// ============================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../vocabulary model/vocabulary_model.dart';

class JsonPage extends StatefulWidget {
  final List<VocabularyWord> words;

  const JsonPage({
    super.key,
    required this.words,
  });

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
    await Clipboard.setData(
      ClipboardData(
        text: jsonText,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'JSON copied to clipboard',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vocabulary JSON',
        ),
        actions: [
          IconButton(
            tooltip: 'Copy JSON',
            onPressed: _copy,
            icon: const Icon(
              Icons.copy,
            ),
          ),
          IconButton(
            tooltip: 'Pretty JSON',
            onPressed: () {
              setState(() {
                pretty = !pretty;
              });
            },
            icon: Icon(
              pretty ? Icons.format_align_left : Icons.code,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF020817),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white12,
          ),
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
