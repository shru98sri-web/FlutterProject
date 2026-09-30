// ============================================================
// WORD DETAIL
// ============================================================

import 'package:flutter/material.dart';

import '../vocabulary model/vocabulary_model.dart';

class WordDetailSheet extends StatelessWidget {
  final VocabularyWord word;

  const WordDetailSheet({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .85,
      maxChildSize: .95,
      builder: (_, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              word.word,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(word.letter),
                ),
                Chip(
                  label: Text(word.difficultCefrStyle),
                ),
                Chip(
                  label: Text(word.difficulty),
                ),
                Chip(
                  label: Text(word.partsOfSpeech),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _section(
              'Definition',
              word.definition,
            ),
            _section(
              'Meaning',
              word.meaning,
            ),
            _section(
              'Synonyms',
              word.synonyms.isEmpty
                  ? 'No synonyms supplied.'
                  : word.synonyms.join(', '),
            ),
            _section(
              'Example',
              word.example,
            ),
            _section(
              'Usage',
              word.usage,
            ),
            _section(
              'GMAT relevance',
              word.gmatRelevance,
            ),
            _section(
              'IELTS relevance',
              word.ieltsRelevance,
            ),
            _section(
              'Current status',
              word.currentStatus,
            ),
            _section(
              'Year focus',
              word.yearFocus,
            ),
            _section(
              'Source reference',
              word.sourceReference.join('\n'),
            ),
            _section(
              'Source note',
              word.sourceNote,
            ),
          ],
        );
      },
    );
  }

  Widget _section(
    String title,
    String content,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            content.isEmpty ? 'Not available' : content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
