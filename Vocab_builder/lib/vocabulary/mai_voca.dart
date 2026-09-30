import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const VocabularyJsonApp());
}

// ============================================================
// APP
// ============================================================

class VocabularyJsonApp extends StatelessWidget {
  const VocabularyJsonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Vocabulary JSON',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1120),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF22C55E),
          surface: Color(0xFF111827),
        ),
        fontFamily: 'Arial',
      ),
      home: const VocabularyHomePage(),
    );
  }
}

// ============================================================
// DATA MODEL
// ============================================================

class VocabularyWord {
  final int id;
  final String word;
  final String partOfSpeech;
  final String definition;
  final String example;
  final String difficulty;
  final bool isEssential;
  final bool isForeign;

  VocabularyWord({
    required this.id,
    required this.word,
    required this.partOfSpeech,
    required this.definition,
    required this.example,
    required this.difficulty,
    required this.isEssential,
    required this.isForeign,
  });

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      word: '${json['word'] ?? ''}',
      partOfSpeech: '${json['part_of_speech'] ?? ''}',
      definition: '${json['definition'] ?? ''}',
      example: '${json['example'] ?? ''}',
      difficulty: '${json['difficulty_cefr_style'] ?? 'Unknown'}',
      isEssential: json['isEssential'] == true,
      isForeign: json['isForeign'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'part_of_speech': partOfSpeech,
      'definition': definition,
      'example': example,
      'difficulty_cefr_style': difficulty,
      'isEssential': isEssential,
      'isForeign': isForeign,
    };
  }
}

// ============================================================
// MAIN PAGE
// ============================================================

class VocabularyHomePage extends StatefulWidget {
  const VocabularyHomePage({super.key});

  @override
  State<VocabularyHomePage> createState() => _VocabularyHomePageState();
}

class _VocabularyHomePageState extends State<VocabularyHomePage> {
  List<VocabularyWord> allWords = [];
  List<VocabularyWord> filteredWords = [];

  Map<String, dynamic> completeJson = {};

  bool loading = true;
  String? errorMessage;

  String searchText = '';
  String selectedDifficulty = 'All';

  @override
  void initState() {
    super.initState();
    loadVocabularyJson();
  }

  // ==========================================================
  // LOAD JSON
  // ==========================================================

  Future<void> loadVocabularyJson() async {
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final String jsonString = await rootBundle.loadString(
        'assets/vocabulary.json',
      );

      final dynamic decoded = json.decode(jsonString);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'The JSON root must be an object.',
        );
      }

      final dynamic wordsData = decoded['words'];

      if (wordsData is! List) {
        throw const FormatException(
          'The JSON must contain a "words" array.',
        );
      }

      final List<VocabularyWord> loadedWords = [];

      for (final item in wordsData) {
        if (item is Map<String, dynamic>) {
          loadedWords.add(
            VocabularyWord.fromJson(item),
          );
        }
      }

      setState(() {
        completeJson = decoded;
        allWords = loadedWords;
        filteredWords = loadedWords;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ==========================================================
  // FILTER
  // ==========================================================

  void filterWords() {
    final query = searchText.toLowerCase().trim();

    setState(() {
      filteredWords = allWords.where((word) {
        final matchesSearch = word.word.toLowerCase().contains(query) ||
            word.definition.toLowerCase().contains(query) ||
            word.example.toLowerCase().contains(query);

        final matchesDifficulty = selectedDifficulty == 'All' ||
            word.difficulty == selectedDifficulty;

        return matchesSearch && matchesDifficulty;
      }).toList();
    });
  }

  // ==========================================================
  // JSON STRING
  // ==========================================================

  String get formattedJson {
    return const JsonEncoder.withIndent('  ').convert(completeJson);
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: Color(0xFF818CF8),
            ),
            SizedBox(width: 10),
            Text(
              'AI Vocabulary JSON',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Reload JSON',
            onPressed: loadVocabularyJson,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? _buildErrorScreen()
              : _buildMainUI(),
    );
  }

  // ==========================================================
  // ERROR SCREEN
  // ==========================================================

  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          color: const Color(0xFF1F2937),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'JSON Loading Error',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  errorMessage ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: loadVocabularyJson,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // MAIN UI
  // ==========================================================

  Widget _buildMainUI() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool desktop = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildStatistics(),
              const SizedBox(height: 20),
              _buildSearchSection(),
              const SizedBox(height: 20),
              if (desktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildVocabularyList(),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: _buildJsonViewer(),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildVocabularyList(),
                    const SizedBox(height: 20),
                    _buildJsonViewer(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF312E81),
            Color(0xFF4F46E5),
            Color(0xFF1E3A8A),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                size: 36,
                color: Colors.white,
              ),
              SizedBox(width: 14),
              Text(
                'Vocabulary Intelligence',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'JSON-powered vocabulary learning dashboard',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STATISTICS
  // ==========================================================

  Widget _buildStatistics() {
    final int essentialCount = allWords.where((w) => w.isEssential).length;

    final int foreignCount = allWords.where((w) => w.isForeign).length;

    final Set<String> levels = allWords.map((w) => w.difficulty).toSet();

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        _statCard(
          'Total Words',
          '${allWords.length}',
          Icons.menu_book,
          const Color(0xFF6366F1),
        ),
        _statCard(
          'Essential',
          '$essentialCount',
          Icons.star,
          const Color(0xFFF59E0B),
        ),
        _statCard(
          'Foreign',
          '$foreignCount',
          Icons.language,
          const Color(0xFF06B6D4),
        ),
        _statCard(
          'Levels',
          '${levels.length}',
          Icons.layers,
          const Color(0xFF22C55E),
        ),
      ],
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return SizedBox(
      width: 190,
      child: Card(
        color: const Color(0xFF111827),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  Widget _buildSearchSection() {
    final levels = <String>{
      'All',
      ...allWords.map((word) => word.difficulty),
    }.toList();

    return Card(
      color: const Color(0xFF111827),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 350,
              child: TextField(
                onChanged: (value) {
                  searchText = value;
                  filterWords();
                },
                decoration: InputDecoration(
                  hintText: 'Search word, definition or example...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFF0B1120),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            DropdownButton<String>(
              value: levels.contains(selectedDifficulty)
                  ? selectedDifficulty
                  : 'All',
              dropdownColor: const Color(0xFF1F2937),
              items: levels.map((level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                selectedDifficulty = value;
                filterWords();
              },
            ),
            Text(
              '${filteredWords.length} results',
              style: const TextStyle(
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // VOCABULARY LIST
  // ==========================================================

  Widget _buildVocabularyList() {
    return Card(
      color: const Color(0xFF111827),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.library_books,
                  color: Color(0xFF818CF8),
                ),
                SizedBox(width: 10),
                Text(
                  'Vocabulary Bank',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (filteredWords.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    'No vocabulary found.',
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredWords.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _wordCard(
                    filteredWords[index],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // WORD CARD
  // ==========================================================

  Widget _wordCard(VocabularyWord word) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        _showWordDetails(word);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1120),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.word,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF818CF8),
                    ),
                  ),
                ),
                _difficultyBadge(word.difficulty),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              word.partOfSpeech,
              style: const TextStyle(
                color: Colors.white54,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              word.definition,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '"${word.example}"',
                style: const TextStyle(
                  color: Colors.white60,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                if (word.isEssential)
                  const Chip(
                    avatar: Icon(
                      Icons.star,
                      size: 16,
                    ),
                    label: Text('Essential'),
                  ),
                if (word.isForeign)
                  const Chip(
                    avatar: Icon(
                      Icons.language,
                      size: 16,
                    ),
                    label: Text('Foreign'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DIFFICULTY
  // ==========================================================

  Widget _difficultyBadge(String level) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level,
        style: const TextStyle(
          color: Color(0xFFA5B4FC),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // ==========================================================
  // JSON VIEWER
  // ==========================================================

  Widget _buildJsonViewer() {
    return Card(
      color: const Color(0xFF111827),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.data_object,
                  color: Color(0xFF22C55E),
                ),
                SizedBox(width: 10),
                Text(
                  'Live JSON',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Source: assets/vocabulary.json',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 600,
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white10,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: SelectableText(
                    formattedJson,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xFF86EFAC),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: formattedJson,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'JSON copied to clipboard',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy JSON'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // WORD DETAILS
  // ==========================================================

  void _showWordDetails(VocabularyWord word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111827),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF818CF8),
                          ),
                        ),
                      ),
                      _difficultyBadge(word.difficulty),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    word.partOfSpeech,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Definition',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF818CF8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    word.definition,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Example',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF818CF8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1120),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '"${word.example}"',
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (word.isEssential)
                        const Chip(
                          label: Text('Essential'),
                        ),
                      const SizedBox(width: 8),
                      if (word.isForeign)
                        const Chip(
                          label: Text('Foreign'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
