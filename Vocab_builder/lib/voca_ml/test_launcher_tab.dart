// ============================================================
// TEST LAUNCHER
// ============================================================

class TestLauncher extends StatelessWidget {
  final List<VocabularyWord> words;
  final Function(AssessmentRecord) onCompleted;

  const TestLauncher({
    super.key,
    required this.words,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Assessment')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    const Icon(
                      Icons.assignment,
                      size: 70,
                      color: Color(0xFF60A5FA),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'AI Vocabulary Test',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${min(words.length, 10)} questions • 10 minutes',
                      style: const TextStyle(color: Colors.white60),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Question types',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Definition recognition\n'
                      '• Meaning recognition\n'
                      '• Context questions\n'
                      '• Synonym questions\n'
                      '• Adaptive difficulty\n'
                      '• Response-time analysis',
                    ),
                    const SizedBox(height: 30),
                    FilledButton.icon(
                      onPressed: words.length < 4
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TestPage(
                                    words: words,
                                    onCompleted: onCompleted,
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.play_arrow),
                      label: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('BEGIN TEST'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TEST PAGE
// ============================================================

class TestPage extends StatefulWidget {
  final List<VocabularyWord> words;
  final Function(AssessmentRecord) onCompleted;

  const TestPage({super.key, required this.words, required this.onCompleted});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final Random random = Random();

  late List<TestQuestion> questions;

  final Map<int, String> answers = {};
  final Map<int, int> questionTimes = {};

  int currentIndex = 0;
  int remainingSeconds = 600;
  int questionStartedAt = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    questions = _generateQuestions();
    questionStartedAt = DateTime.now().millisecondsSinceEpoch;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        remainingSeconds--;
      });

      if (remainingSeconds <= 0) {
        _submit();
      }
    });
  }

  List<TestQuestion> _generateQuestions() {
    final pool = List<VocabularyWord>.from(widget.words)..shuffle(random);

    final selected = pool.take(min(10, pool.length)).toList();

    final result = <TestQuestion>[];

    for (final word in selected) {
      final type =
          QuestionType.values[random.nextInt(QuestionType.values.length)];

      List<String> options;

      switch (type) {
        case QuestionType.definition:
          options = _makeOptions(word, (w) => w.word);

        case QuestionType.meaning:
          options = _makeOptions(word, (w) => w.meaning);

        case QuestionType.example:
          options = _makeOptions(word, (w) => w.word);

        case QuestionType.synonym:
          options = _makeOptions(word, (w) {
            if (w.synonyms.isNotEmpty) {
              return w.synonyms.first;
            }
            return w.word;
          });
      }

      String correct;

      switch (type) {
        case QuestionType.definition:
          correct = word.word;

        case QuestionType.meaning:
          correct = word.meaning;

        case QuestionType.example:
          correct = word.word;

        case QuestionType.synonym:
          correct = word.synonyms.isNotEmpty ? word.synonyms.first : word.word;
      }

      result.add(
        TestQuestion(
          word: word,
          type: type,
          options: options,
          correctAnswer: correct,
        ),
      );
    }

    return result;
  }

  List<String> _makeOptions(
    VocabularyWord correct,
    String Function(VocabularyWord) selector,
  ) {
    final candidates =
        widget.words.where((w) => w.word != correct.word).toList()
          ..shuffle(random);

    final values = <String>[selector(correct)];

    for (final candidate in candidates) {
      final value = selector(candidate);

      if (value.trim().isEmpty) continue;

      if (!values.contains(value)) {
        values.add(value);
      }

      if (values.length >= 4) break;
    }

    while (values.length < 4) {
      values.add('Not enough information');
    }

    values.shuffle(random);

    return values;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _select(String answer) {
    final elapsed =
        ((DateTime.now().millisecondsSinceEpoch - questionStartedAt) / 1000)
            .round();

    answers[currentIndex] = answer;
    questionTimes[currentIndex] = elapsed;

    setState(() {});

    if (currentIndex == questions.length - 1) {
      _submit();
    } else {
      setState(() {
        currentIndex++;
        questionStartedAt = DateTime.now().millisecondsSinceEpoch;
      });
    }
  }

  void _submit() {
    timer?.cancel();

    final results = <TestAnswer>[];

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];

      final selected = answers[i] ?? 'Not answered';

      results.add(
        TestAnswer(
          question: q,
          selectedAnswer: selected,
          correct: selected == q.correctAnswer,
          seconds: questionTimes[i] ?? 0,
        ),
      );
    }

    final score = results.where((e) => e.correct).length;

    final averageTime = results.isEmpty
        ? 0
        : results.map((e) => e.seconds).reduce((a, b) => a + b) /
              results.length;

    final percentage = questions.isEmpty ? 0 : score / questions.length * 100;

    final record = AssessmentRecord(
      date: DateTime.now(),
      score: score,
      total: questions.length,
      averageTime: averageTime.toDouble(),
      voiceScore: 0,
      level: _level(percentage),
    );

    widget.onCompleted(record);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsPage(results: results, record: record),
      ),
    );
  }

  String _level(percentage) {
    if (percentage >= 90) return 'Advanced';
    if (percentage >= 75) return 'Upper Intermediate';
    if (percentage >= 60) return 'Intermediate';
    if (percentage >= 40) return 'Developing';
    return 'Foundation';
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Not enough vocabulary entries.')),
      );
    }

    final question = questions[currentIndex];

    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');

    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentIndex + 1}/${questions.length}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Chip(
              avatar: const Icon(Icons.timer, size: 18),
              label: Text('$minutes:$seconds'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          LinearProgressIndicator(value: (currentIndex + 1) / questions.length),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.type.name.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF60A5FA),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    question.questionText,
                    style: const TextStyle(fontSize: 19, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...question.options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _optionButton(option),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionButton(String option) {
    return OutlinedButton(
      onPressed: () => _select(option),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(18),
        minimumSize: const Size(double.infinity, 60),
      ),
      child: Text(option, style: const TextStyle(fontSize: 15)),
    );
  }
}
