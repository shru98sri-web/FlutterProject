// ============================================================
// HOME
// ============================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocab_builder/main.dart';

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
  StudentPerformanceML studentML = StudentPerformanceML();
  bool mlLoading = true;
  double currentMastery = 0;
  int totalTrainingSamples = 0;

  @override
  void initState() {
    super.initState();
    loadVocabulary();
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    try {
      final savedHistory = await StudentStorage.loadAssessments();
      final samples = await StudentStorage.loadPerformanceSamples();
      final model = await StudentStorage.loadModel();
      if (model.trainingSteps == 0 && samples.isNotEmpty) {
        model.trainMany(samples);
        await StudentStorage.saveModel(model);
      }
      final latest = savedHistory.isNotEmpty ? savedHistory.first : null;
      if (!mounted) return;
      setState(() {
        history
          ..clear()
          ..addAll(savedHistory);
        studentML = model;
        totalTrainingSamples = samples.length;
        currentMastery = latest == null
            ? 0
            : model.predict(
                accuracy: latest.percentage,
                averageTime: latest.averageTime,
                voiceScore: latest.voiceScore.toDouble(),
              );
        mlLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => mlLoading = false);
    }
  }

  Future<void> loadVocabulary() async {
    try {
      final raw = await rootBundle.loadString('assets/vocabulary.json');

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
            (item) => VocabularyWord.fromJson(Map<String, dynamic>.from(item)),
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

  Future<void> addHistory(AssessmentRecord record) async {
    final accuracy = (record.percentage / 100).clamp(0.0, 1.0).toDouble();
    final speed = record.averageTime <= 0
        ? 1.0
        : (1 / (1 + record.averageTime / 15)).clamp(0.0, 1.0).toDouble();
    final voice = (record.voiceScore / 100).clamp(0.0, 1.0).toDouble();
    final target = ((accuracy * .65) + (speed * .15) + (voice * .20))
        .clamp(0.0, 1.0)
        .toDouble();
    final sample = PerformanceSample(
      accuracy: accuracy,
      speed: speed,
      voiceScore: voice,
      target: target,
    );
    studentML.train(sample);
    await StudentStorage.saveAssessment(record);
    await StudentStorage.savePerformanceSample(sample);
    await StudentStorage.saveModel(studentML);
    if (!mounted) return;
    setState(() {
      history.insert(0, record);
      if (history.length > 100) history.removeLast();
      totalTrainingSamples++;
      currentMastery = studentML.predict(
        accuracy: record.percentage,
        averageTime: record.averageTime,
        voiceScore: record.voiceScore.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vocabulary AI')),
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
        mastery: currentMastery,
        trainingSamples: totalTrainingSamples,
        onTest: () {
          setState(() {
            selectedIndex = 1;
          });
        },
      ),
      TestLauncher(words: words, onCompleted: addHistory),
      VoiceTutorPage(words: words, onCompleted: addHistory),
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
            Expanded(child: pages[selectedIndex]),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DASHBOARD - MOBILE RESPONSIVE VERSION
// ============================================================

class DashboardPage extends StatefulWidget {
  final List<VocabularyWord> words;
  final VoidCallback onTest;
  final double mastery;
  final int trainingSamples;

  const DashboardPage({
    super.key,
    required this.words,
    required this.onTest,
    required this.mastery,
    required this.trainingSamples,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String search = '';
  String selectedDifficulty = 'All';
  String selectedLetter = 'All';

  // ============================================================
  // FILTERED WORDS
  // ============================================================

  List<VocabularyWord> get filtered {
    return widget.words.where((word) {
      final searchText = search.toLowerCase().trim();

      final matchesSearch =
          searchText.isEmpty ||
          word.word.toLowerCase().contains(searchText) ||
          word.definition.toLowerCase().contains(searchText) ||
          word.meaning.toLowerCase().contains(searchText) ||
          word.synonyms.any((s) => s.toLowerCase().contains(searchText));

      final matchesDifficulty =
          selectedDifficulty == 'All' ||
          word.difficulty == selectedDifficulty ||
          word.difficultCefrStyle == selectedDifficulty;

      final matchesLetter =
          selectedLetter == 'All' ||
          word.letter.toUpperCase() == selectedLetter;

      return matchesSearch && matchesDifficulty && matchesLetter;
    }).toList();
  }

  // ============================================================
  // LETTERS
  // ============================================================

  Set<String> get letters {
    return widget.words
        .map((e) => e.letter.toUpperCase())
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  // ============================================================
  // DIFFICULTIES
  // ============================================================

  Set<String> get difficulties {
    return widget.words
        .map((e) => e.difficulty)
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vocabulary AI-ML',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Start Test',
            onPressed: widget.onTest,
            icon: const Icon(Icons.play_circle),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallPhone = constraints.maxWidth < 380;

          final horizontalPadding = isSmallPhone ? 12.0 : 20.0;

          return ListView(
            padding: EdgeInsets.all(horizontalPadding),
            children: [
              _hero(),
              const SizedBox(height: 20),

              _stats(),

              const SizedBox(height: 16),

              _performanceCard(),

              const SizedBox(height: 20),

              _filters(),

              const SizedBox(height: 20),

              Text(
                '${filtered.length} vocabulary entries',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              ...filtered.take(100).map(_wordCard),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF87CEEB)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, size: 40),

          const SizedBox(height: 16),

          const Text(
            'AI Vocabulary Hub',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            '${widget.words.length} words • GMAT • IELTS • Academic • Contemporary English',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.onTest,
              icon: const Icon(Icons.quiz),
              label: const Text(
                'Start Vocabulary Test',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _stats() {
    final advanced = widget.words
        .where(
          (e) =>
              e.difficultCefrStyle.toUpperCase() == 'C1' ||
              e.difficultCefrStyle.toUpperCase() == 'C2',
        )
        .length;

    final gmat = widget.words
        .where((e) => e.gmatRelevance.toLowerCase() == 'high')
        .length;

    final ielts = widget.words
        .where((e) => e.ieltsRelevance.toLowerCase() == 'high')
        .length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Two columns on phones.
        final cardWidth = width < 700 ? (width - 12) / 2 : 180.0;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _statCard(
              'Total Words',
              '${widget.words.length}',
              Icons.menu_book,
              cardWidth,
            ),
            _statCard('Advanced', '$advanced', Icons.trending_up, cardWidth),
            _statCard('GMAT High', '$gmat', Icons.school, cardWidth),
            _statCard('IELTS High', '$ielts', Icons.language, cardWidth),
          ],
        );
      },
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard(String title, String value, IconData icon, double width) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 28),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PERFORMANCE ML CARD
  // ============================================================

  Widget _performanceCard() {
    final mastery = widget.mastery.clamp(0.0, 100.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 330;

            if (compact) {
              return Column(
                children: [
                  _masteryCircle(mastery),

                  const SizedBox(height: 16),

                  _performanceText(),
                ],
              );
            }

            return Row(
              children: [
                _masteryCircle(mastery),

                const SizedBox(width: 16),

                Expanded(child: _performanceText()),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // MASTERY CIRCLE
  // ============================================================

  Widget _masteryCircle(double mastery) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(value: mastery / 100, strokeWidth: 7),

          Center(
            child: Text(
              '${mastery.round()}%',
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PERFORMANCE TEXT
  // ============================================================

  Widget _performanceText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Student Performance ML',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        Text(
          '${widget.trainingSamples} training samples',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 3),

        const Text(
          'Local adaptive learning model',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _filters() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search word, definition, meaning or synonym...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          onChanged: (value) {
            setState(() {
              search = value;
            });
          },
        ),

        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            // Stack dropdowns vertically on narrow phones.
            if (constraints.maxWidth < 430) {
              return Column(
                children: [
                  _difficultyDropdown(),

                  const SizedBox(height: 12),

                  _letterDropdown(),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: _difficultyDropdown()),

                const SizedBox(width: 12),

                Expanded(child: _letterDropdown()),
              ],
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // DIFFICULTY DROPDOWN
  // ============================================================

  Widget _difficultyDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedDifficulty,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Difficulty',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(
          value: 'All',
          child: Text('All', overflow: TextOverflow.ellipsis),
        ),
        ...difficulties.map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(e, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          selectedDifficulty = value;
        });
      },
    );
  }

  // ============================================================
  // LETTER DROPDOWN
  // ============================================================

  Widget _letterDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedLetter,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Letter',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(
          value: 'All',
          child: Text('All', overflow: TextOverflow.ellipsis),
        ),
        ...letters.map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(e, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          selectedLetter = value;
        });
      },
    );
  }

  // ============================================================
  // WORD CARD
  // ============================================================

  Widget _wordCard(VocabularyWord word) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
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
              // ------------------------------------------------
              // WORD + CEFR
              // ------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      word.word,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Flexible(child: _badge(word.difficultCefrStyle, Colors.blue)),
                ],
              ),

              const SizedBox(height: 6),

              // ------------------------------------------------
              // PART OF SPEECH / DIFFICULTY
              // ------------------------------------------------
              Text(
                '${word.partsOfSpeech} • ${word.difficulty}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white60),
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // DEFINITION
              // ------------------------------------------------
              Text(
                word.definition,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(height: 1.4),
              ),

              const SizedBox(height: 10),

              // ------------------------------------------------
              // EXAMPLE
              // ------------------------------------------------
              Text(
                'Example: ${word.example}',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              ),

              const SizedBox(height: 10),

              // ------------------------------------------------
              // TAGS
              // ------------------------------------------------
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _smallBadge('GMAT ${word.gmatRelevance}'),
                  _smallBadge('IELTS ${word.ieltsRelevance}'),
                  _smallBadge(word.currentStatus),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CEFR BADGE
  // ============================================================

  Widget _badge(String text, Color color) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 90),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  // ============================================================
  // SMALL BADGE
  // ============================================================

  Widget _smallBadge(String text) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }
}

// ============================================================
// WORD DETAIL
// ============================================================

class WordDetailSheet extends StatelessWidget {
  final VocabularyWord word;

  const WordDetailSheet({super.key, required this.word});

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
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(word.letter)),
                Chip(label: Text(word.difficultCefrStyle)),
                Chip(label: Text(word.difficulty)),
                Chip(label: Text(word.partsOfSpeech)),
              ],
            ),
            const SizedBox(height: 20),
            _section('Definition', word.definition),
            _section('Meaning', word.meaning),
            _section(
              'Synonyms',
              word.synonyms.isEmpty
                  ? 'No synonyms supplied.'
                  : word.synonyms.join(', '),
            ),
            _section('Example', word.example),
            _section('Usage', word.usage),
            _section('GMAT relevance', word.gmatRelevance),
            _section('IELTS relevance', word.ieltsRelevance),
            _section('Current status', word.currentStatus),
            _section('Year focus', word.yearFocus),
            _section('Source reference', word.sourceReference.join('\n')),
            _section('Source note', word.sourceNote),
          ],
        );
      },
    );
  }

  Widget _section(String title, String content) {
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
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}
