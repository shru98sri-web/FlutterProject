import 'package:flutter/material.dart';

void main() {
  runApp(const OmrExamApp());
}

// ============================================================
// APP
// ============================================================

class OmrExamApp extends StatelessWidget {
  const OmrExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OMR Examination',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const OmrExamPage(),
    );
  }
}

// ============================================================
// QUESTION MODEL
// ============================================================

class OmrQuestion {
  final int number;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final int marks;

  const OmrQuestion({
    required this.number,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.marks = 1,
  });
}

// ============================================================
// EXAM DATA
// ============================================================

class OmrExamData {
  static const List<OmrQuestion> questions = [
    OmrQuestion(
      number: 1,
      question: 'What is the SI unit of force?',
      options: [
        'Joule',
        'Newton',
        'Watt',
        'Pascal',
      ],
      correctAnswer: 1,
      explanation: 'The SI unit of force is Newton (N).',
    ),
    OmrQuestion(
      number: 2,
      question:
          'Which law states that every action has an equal and opposite reaction?',
      options: [
        'Newton First Law',
        'Newton Second Law',
        'Newton Third Law',
        'Law of Gravitation',
      ],
      correctAnswer: 2,
      explanation:
          'Newton Third Law states that every action has an equal and opposite reaction.',
    ),
    OmrQuestion(
      number: 3,
      question: 'What is the formula for force?',
      options: [
        'F = mv',
        'F = ma',
        'F = m/a',
        'F = a/m',
      ],
      correctAnswer: 1,
      explanation: 'According to Newton Second Law, F = ma.',
    ),
    OmrQuestion(
      number: 4,
      question: 'Which quantity is a vector quantity?',
      options: [
        'Mass',
        'Temperature',
        'Velocity',
        'Time',
      ],
      correctAnswer: 2,
      explanation: 'Velocity has both magnitude and direction.',
    ),
    OmrQuestion(
      number: 5,
      question:
          'What is the approximate acceleration due to gravity near Earth?',
      options: [
        '9.8 m/s²',
        '5.6 m/s²',
        '15.2 m/s²',
        '20 m/s²',
      ],
      correctAnswer: 0,
      explanation:
          'The acceleration due to gravity near Earth is approximately 9.8 m/s².',
    ),
    OmrQuestion(
      number: 6,
      question: 'Which of the following is a scalar quantity?',
      options: [
        'Velocity',
        'Force',
        'Displacement',
        'Mass',
      ],
      correctAnswer: 3,
      explanation: 'Mass has magnitude but no direction, so it is a scalar.',
    ),
    OmrQuestion(
      number: 7,
      question: 'What is the SI unit of energy?',
      options: [
        'Newton',
        'Joule',
        'Watt',
        'Volt',
      ],
      correctAnswer: 1,
      explanation: 'The SI unit of energy is Joule (J).',
    ),
    OmrQuestion(
      number: 8,
      question: 'Which instrument is used to measure electric current?',
      options: [
        'Voltmeter',
        'Ammeter',
        'Barometer',
        'Thermometer',
      ],
      correctAnswer: 1,
      explanation: 'An ammeter measures electric current.',
    ),
    OmrQuestion(
      number: 9,
      question: 'What is the approximate speed of light in vacuum?',
      options: [
        '3 × 10⁸ m/s',
        '3 × 10⁶ m/s',
        '3 × 10⁴ m/s',
        '3 × 10² m/s',
      ],
      correctAnswer: 0,
      explanation: 'The speed of light in vacuum is approximately 3 × 10⁸ m/s.',
    ),
    OmrQuestion(
      number: 10,
      question: 'Which particle has a negative electric charge?',
      options: [
        'Proton',
        'Neutron',
        'Electron',
        'Photon',
      ],
      correctAnswer: 2,
      explanation: 'An electron has a negative electric charge.',
    ),
  ];
}

// ============================================================
// MAIN EXAM STATEFUL WIDGET
// ============================================================

class OmrExamPage extends StatefulWidget {
  const OmrExamPage({super.key});

  @override
  State<OmrExamPage> createState() => _OmrExamPageState();
}

class _OmrExamPageState extends State<OmrExamPage> {
  // ----------------------------------------------------------
  // STATE VARIABLES
  // ----------------------------------------------------------

  int currentQuestionIndex = 0;

  final Map<int, int> selectedAnswers = {};

  final Set<int> markedForReview = {};

  bool submitted = false;

  // ----------------------------------------------------------
  // CURRENT QUESTION
  // ----------------------------------------------------------

  OmrQuestion get currentQuestion {
    return OmrExamData.questions[currentQuestionIndex];
  }

  // ----------------------------------------------------------
  // SELECT ANSWER
  // ----------------------------------------------------------

  void selectAnswer(int optionIndex) {
    if (submitted) {
      return;
    }

    setState(() {
      selectedAnswers[currentQuestionIndex] = optionIndex;
    });
  }

  // ----------------------------------------------------------
  // CLEAR ANSWER
  // ----------------------------------------------------------

  void clearAnswer() {
    if (submitted) {
      return;
    }

    setState(() {
      selectedAnswers.remove(currentQuestionIndex);
    });
  }

  // ----------------------------------------------------------
  // MARK FOR REVIEW
  // ----------------------------------------------------------

  void toggleReview() {
    if (submitted) {
      return;
    }

    setState(() {
      if (markedForReview.contains(currentQuestionIndex)) {
        markedForReview.remove(currentQuestionIndex);
      } else {
        markedForReview.add(currentQuestionIndex);
      }
    });
  }

  // ----------------------------------------------------------
  // NEXT QUESTION
  // ----------------------------------------------------------

  void nextQuestion() {
    if (currentQuestionIndex < OmrExamData.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  // ----------------------------------------------------------
  // PREVIOUS QUESTION
  // ----------------------------------------------------------

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  // ----------------------------------------------------------
  // GO TO QUESTION
  // ----------------------------------------------------------

  void goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
  }

  // ----------------------------------------------------------
  // CALCULATE SCORE
  // ----------------------------------------------------------

  int calculateScore() {
    int score = 0;

    for (int i = 0; i < OmrExamData.questions.length; i++) {
      final selected = selectedAnswers[i];

      if (selected != null &&
          selected == OmrExamData.questions[i].correctAnswer) {
        score += OmrExamData.questions[i].marks;
      }
    }

    return score;
  }

  // ----------------------------------------------------------
  // CORRECT COUNT
  // ----------------------------------------------------------

  int calculateCorrect() {
    int count = 0;

    for (int i = 0; i < OmrExamData.questions.length; i++) {
      final selected = selectedAnswers[i];

      if (selected != null &&
          selected == OmrExamData.questions[i].correctAnswer) {
        count++;
      }
    }

    return count;
  }

  // ----------------------------------------------------------
  // WRONG COUNT
  // ----------------------------------------------------------

  int calculateWrong() {
    int count = 0;

    for (int i = 0; i < OmrExamData.questions.length; i++) {
      final selected = selectedAnswers[i];

      if (selected != null &&
          selected != OmrExamData.questions[i].correctAnswer) {
        count++;
      }
    }

    return count;
  }

  // ----------------------------------------------------------
  // UNANSWERED COUNT
  // ----------------------------------------------------------

  int calculateUnanswered() {
    return OmrExamData.questions.length - selectedAnswers.length;
  }

  // ==========================================================
  // SUBMIT CONFIRMATION
  // ==========================================================

  void showSubmitDialog() {
    final answered = selectedAnswers.length;

    final total = OmrExamData.questions.length;

    final unanswered = total - answered;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Submit Examination',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Questions: $total',
              ),
              const SizedBox(height: 8),
              Text(
                'Answered: $answered',
              ),
              const SizedBox(height: 8),
              Text(
                'Unanswered: $unanswered',
              ),
              const SizedBox(height: 8),
              Text(
                'Marked for Review: '
                '${markedForReview.length}',
              ),
              const SizedBox(height: 20),
              const Text(
                'Are you sure you want to submit the examination?',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'CANCEL',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  submitted = true;
                });
              },
              child: const Text(
                'SUBMIT',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // RESET EXAM
  // ==========================================================

  void restartExam() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswers.clear();
      markedForReview.clear();
      submitted = false;
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    if (submitted) {
      return buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OMR Examination',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildExamHeader(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: buildQuestionArea(),
                  ),
                  buildQuestionPalette(),
                ],
              ),
            ),
            buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // EXAM HEADER
  // ==========================================================

  Widget buildExamHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Physics',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Physics Model Examination',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          buildHeaderStat(
            'Answered',
            '${selectedAnswers.length}',
          ),
          const SizedBox(width: 20),
          buildHeaderStat(
            'Review',
            '${markedForReview.length}',
          ),
        ],
      ),
    );
  }

  Widget buildHeaderStat(
    String title,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2563EB),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // QUESTION AREA
  // ==========================================================

  Widget buildQuestionArea() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Question '
                      '${currentQuestion.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${currentQuestion.marks} Mark',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                currentQuestion.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              ...List.generate(
                currentQuestion.options.length,
                (index) {
                  return buildOmrOption(
                    index,
                    currentQuestion.options[index],
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: clearAnswer,
                    icon: const Icon(
                      Icons.clear,
                    ),
                    label: const Text(
                      'Clear Answer',
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: toggleReview,
                    icon: Icon(
                      markedForReview.contains(
                        currentQuestionIndex,
                      )
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                    ),
                    label: Text(
                      markedForReview.contains(
                        currentQuestionIndex,
                      )
                          ? 'Remove Review'
                          : 'Mark for Review',
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
  // OMR OPTION
  // ==========================================================

  Widget buildOmrOption(
    int optionIndex,
    String optionText,
  ) {
    final selected = selectedAnswers[currentQuestionIndex] == optionIndex;

    final letter = String.fromCharCode(65 + optionIndex);

    return GestureDetector(
      onTap: () {
        selectAnswer(optionIndex);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF6FF) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF2563EB) : const Color(0xFFD1D5DB),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // OMR BUBBLE
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? const Color(0xFF2563EB) : Colors.white,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF9CA3AF),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                optionText,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2563EB),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // QUESTION PALETTE
  // ==========================================================

  Widget buildQuestionPalette() {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(
        top: 24,
        right: 24,
        bottom: 24,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Question Palette',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                OmrExamData.questions.length,
                (index) {
                  return buildPaletteButton(
                    index,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            buildLegend(
              const Color(0xFF2563EB),
              'Answered',
            ),
            buildLegend(
              const Color(0xFFFFA000),
              'Marked for Review',
            ),
            buildLegend(
              const Color(0xFFE5E7EB),
              'Not Answered',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaletteButton(int index) {
    final answered = selectedAnswers.containsKey(index);

    final review = markedForReview.contains(index);

    final active = currentQuestionIndex == index;

    Color background;

    if (review) {
      background = const Color(0xFFFFA000);
    } else if (answered) {
      background = const Color(0xFF2563EB);
    } else {
      background = const Color(0xFFE5E7EB);
    }

    return GestureDetector(
      onTap: () {
        goToQuestion(index);
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: active
              ? Border.all(
                  color: Colors.black,
                  width: 3,
                )
              : null,
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: answered || review ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLegend(
    Color color,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  Widget buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
          ),
        ],
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: currentQuestionIndex == 0 ? null : previousQuestion,
            icon: const Icon(
              Icons.arrow_back,
            ),
            label: const Text(
              'Previous',
            ),
          ),
          const Spacer(),
          if (currentQuestionIndex == OmrExamData.questions.length - 1)
            ElevatedButton.icon(
              onPressed: showSubmitDialog,
              icon: const Icon(
                Icons.send,
              ),
              label: const Text(
                'Submit Examination',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: nextQuestion,
              icon: const Icon(
                Icons.arrow_forward,
              ),
              label: const Text(
                'Next',
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // RESULT SCREEN
  // ==========================================================

  Widget buildResultScreen() {
    final score = calculateScore();
    final correct = calculateCorrect();
    final wrong = calculateWrong();
    final unanswered = calculateUnanswered();

    final totalMarks = OmrExamData.questions.fold<int>(
      0,
      (sum, question) => sum + question.marks,
    );

    final percentage = totalMarks == 0 ? 0 : score / totalMarks * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exam Result',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // SCORE CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 70,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Examination Completed',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '$score / $totalMarks',
                      style: const TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // STATISTICS
            Row(
              children: [
                Expanded(
                  child: buildResultStat(
                    'Correct',
                    '$correct',
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildResultStat(
                    'Wrong',
                    '$wrong',
                    Colors.red,
                    Icons.cancel,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildResultStat(
                    'Unanswered',
                    '$unanswered',
                    Colors.grey,
                    Icons.remove_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // REVIEW BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OmrAnswerReviewPage(
                        answers: selectedAnswers,
                        markedForReview: markedForReview,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.rate_review,
                ),
                label: const Text(
                  'Review All Answers',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // RESTART
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: restartExam,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: const Text(
                  'Take Examination Again',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResultStat(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ANSWER REVIEW PAGE
// ============================================================

class OmrAnswerReviewPage extends StatelessWidget {
  final Map<int, int> answers;

  final Set<int> markedForReview;

  const OmrAnswerReviewPage({
    super.key,
    required this.answers,
    required this.markedForReview,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Answer Review',
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: OmrExamData.questions.length,
        itemBuilder: (context, index) {
          final question = OmrExamData.questions[index];

          final selected = answers[index];

          final isAnswered = selected != null;

          final isCorrect = isAnswered && selected == question.correctAnswer;

          final isMarked = markedForReview.contains(index);

          return buildReviewCard(
            question,
            selected,
            isCorrect,
            isAnswered,
            isMarked,
          );
        },
      ),
    );
  }

  Widget buildReviewCard(
    OmrQuestion question,
    int? selectedAnswer,
    bool isCorrect,
    bool isAnswered,
    bool marked,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // QUESTION HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: !isAnswered
                      ? Colors.grey
                      : isCorrect
                          ? Colors.green
                          : Colors.red,
                  child: Text(
                    '${question.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (marked)
                  const Icon(
                    Icons.bookmark,
                    color: Colors.orange,
                  ),
              ],
            ),

            const SizedBox(height: 18),

            // OPTIONS
            ...List.generate(
              question.options.length,
              (optionIndex) {
                return buildReviewOption(
                  question,
                  optionIndex,
                  selectedAnswer,
                );
              },
            ),

            const SizedBox(height: 16),

            // RESULT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: !isAnswered
                    ? const Color(
                        0xFFF3F4F6,
                      )
                    : isCorrect
                        ? const Color(
                            0xFFF0FDF4,
                          )
                        : const Color(
                            0xFFFFF1F2,
                          ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Text(
                !isAnswered
                    ? 'Not Answered'
                    : isCorrect
                        ? 'Correct Answer'
                        : 'Wrong Answer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !isAnswered
                      ? Colors.grey
                      : isCorrect
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // EXPLANATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explanation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    question.explanation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReviewOption(
    OmrQuestion question,
    int optionIndex,
    int? selectedAnswer,
  ) {
    final isCorrect = optionIndex == question.correctAnswer;

    final isSelected = optionIndex == selectedAnswer;

    Color background = Colors.white;

    Color border = Colors.grey.shade300;

    if (isCorrect) {
      background = const Color(0xFFEFFAF1);
      border = Colors.green;
    } else if (isSelected && !isCorrect) {
      background = const Color(0xFFFFF1F2);
      border = Colors.red;
    }

    final letter = String.fromCharCode(
      65 + optionIndex,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(
          color: border,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: border,
              ),
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              question.options[optionIndex],
            ),
          ),
          if (isCorrect)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          else if (isSelected)
            const Icon(
              Icons.cancel,
              color: Colors.red,
            ),
        ],
      ),
    );
  }
}
