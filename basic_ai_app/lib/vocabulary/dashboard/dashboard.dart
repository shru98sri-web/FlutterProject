// ============================================================
// DASHBOARD
// ============================================================

import 'package:flutter/material.dart';

import '../vocabulary model/vocabulary_model.dart';
import '../word_detail/word_detail.dart';

class DashboardPage extends StatefulWidget {
  final List<VocabularyWord> words;
  final VoidCallback onTest;

  const DashboardPage({
    super.key,
    required this.words,
    required this.onTest,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String search = '';
  String selectedDifficulty = 'All';
  String selectedLetter = 'All';

  List<VocabularyWord> get filtered {
    return widget.words.where((word) {
      final matchesSearch = search.isEmpty ||
          word.word.toLowerCase().contains(search.toLowerCase()) ||
          word.definition.toLowerCase().contains(search.toLowerCase()) ||
          word.meaning.toLowerCase().contains(search.toLowerCase()) ||
          word.synonyms.any(
            (s) => s.toLowerCase().contains(search.toLowerCase()),
          );

      final matchesDifficulty = selectedDifficulty == 'All' ||
          word.difficulty == selectedDifficulty ||
          word.difficultCefrStyle == selectedDifficulty;

      final matchesLetter = selectedLetter == 'All' ||
          word.letter.toUpperCase() == selectedLetter;

      return matchesSearch && matchesDifficulty && matchesLetter;
    }).toList();
  }

  Set<String> get letters {
    return widget.words
        .map((e) => e.letter.toUpperCase())
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  Set<String> get difficulties {
    return widget.words
        .map((e) => e.difficulty)
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vocabulary AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Start Test',
            onPressed: widget.onTest,
            icon: const Icon(Icons.note_alt_sharp),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _hero(),
          const SizedBox(height: 20),
          _stats(),
          const SizedBox(height: 20),
          _filters(),
          const SizedBox(height: 20),
          Text(
            '${filtered.length} vocabulary entries',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...filtered.take(100).map(_wordCard),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF87CEEB),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 40,
          ),
          const SizedBox(height: 16),
          const Text(
            'AI-Ml Vocabulary Hub',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.words.length} words • GMAT • IELTS • Academic • Contemporary English',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: widget.onTest,
            icon: const Icon(Icons.quiz),
            label: const Text('Start Vocabulary Test'),
          ),
        ],
      ),
    );
  }

  Widget _stats() {
    final advanced = widget.words
        .where(
          (e) =>
              e.difficultCefrStyle.toUpperCase() == 'C1' ||
              e.difficultCefrStyle.toUpperCase() == 'C2',
        )
        .length;

    final gmat = widget.words
        .where(
          (e) => e.gmatRelevance.toLowerCase() == 'high',
        )
        .length;

    final ielts = widget.words
        .where(
          (e) => e.ieltsRelevance.toLowerCase() == 'high',
        )
        .length;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _statCard(
          'Total Words',
          '${widget.words.length}',
          Icons.menu_book,
        ),
        _statCard(
          'Advanced',
          '$advanced',
          Icons.trending_up,
        ),
        _statCard(
          'GMAT High',
          '$gmat',
          Icons.school,
        ),
        _statCard(
          'IELTS High',
          '$ielts',
          Icons.language,
        ),
      ],
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
  ) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(title),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filters() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search word, definition, meaning or synonym...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) {
            setState(() {
              search = value;
            });
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: selectedDifficulty,
                decoration: const InputDecoration(
                  labelText: 'Difficulty',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                    value: 'All',
                    child: Text('All'),
                  ),
                  ...difficulties.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedDifficulty = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: selectedLetter,
                decoration: const InputDecoration(
                  labelText: 'Letter',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                    value: 'All',
                    child: Text('All'),
                  ),
                  ...letters.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedLetter = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _wordCard(VocabularyWord word) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => WordDetailSheet(word: word),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      word.word,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _badge(
                    word.difficultCefrStyle,
                    Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${word.partsOfSpeech} • ${word.difficulty}',
                style: const TextStyle(
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              Text(word.definition),
              const SizedBox(height: 10),
              Text(
                'Example: ${word.example}',
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: [
                  _smallBadge(
                    'GMAT ${word.gmatRelevance}',
                  ),
                  _smallBadge(
                    'IELTS ${word.ieltsRelevance}',
                  ),
                  _smallBadge(
                    word.currentStatus,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }

  Widget _smallBadge(String text) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}
