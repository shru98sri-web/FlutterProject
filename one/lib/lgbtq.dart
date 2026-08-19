import 'package:flutter/material.dart';

void main() {
  runApp(const PrideMatchGameApp());
}

class PrideMatchGameApp extends StatelessWidget {
  const PrideMatchGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pride Flag Matcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff121212),
        primaryColor: Colors.purple,
      ),
      home: const PrideMatchScreen(),
    );
  }
}

class FlagModel {
  final String id;
  final String name;
  final String meaning;
  final Widget flagWidget;

  FlagModel({
    required this.id,
    required this.name,
    required this.meaning,
    required this.flagWidget,
  });
}

class PrideMatchScreen extends StatefulWidget {
  const PrideMatchScreen({Key? key}) : super(key: key);

  @override
  State<PrideMatchScreen> createState() => _PrideMatchScreenState();
}

class _PrideMatchScreenState extends State<PrideMatchScreen> {
  late List<FlagModel> flags;
  late List<FlagModel> shuffledMeanings;
  Map<String, bool> score = {};

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    flags = [
      FlagModel(
        id: '1',
        name: 'LGBT Pride (Umbrella)',
        meaning: 'Umbrella pride flag representing the wider community.',
        flagWidget: _buildStripedFlag([
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.purple,
        ]),
      ),
      FlagModel(
        id: '2',
        name: 'Bisexual Pride',
        meaning: 'Sexual attraction to two or multiple genders.',
        flagWidget: _buildStripedFlag([
          Colors.pink,
          Colors.pink,
          Colors.purple,
          Colors.blue,
          Colors.blue,
        ]),
      ),
      FlagModel(
        id: '3',
        name: 'Pansexual Pride',
        meaning: 'Sexual attraction regardless of gender.',
        flagWidget: _buildStripedFlag([
          Colors.pink,
          Colors.yellow,
          Colors.cyan,
        ]),
      ),
      FlagModel(
        id: '4',
        name: 'Transgender Pride',
        meaning: 'Having a different gender from the one assigned at birth.',
        flagWidget: _buildStripedFlag([
          Colors.lightBlueAccent,
          Colors.pinkAccent,
          Colors.white,
          Colors.pinkAccent,
          Colors.lightBlueAccent,
        ]),
      ),
      FlagModel(
        id: '5',
        name: 'Asexual Pride',
        meaning: 'Experiencing no sexual attraction.',
        flagWidget: _buildStripedFlag([
          Colors.black,
          Colors.grey,
          Colors.white,
          Colors.purple,
        ]),
      ),
    ];

    shuffledMeanings = List.from(flags)..shuffle();
    score.clear();
  }

  static Widget _buildStripedFlag(List<Color> colors) {
    return Container(
      width: 90,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Column(
          children: colors
              .map((color) => Expanded(child: Container(color: color)))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isGameOver = score.length == flags.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match the Pride Flags'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _resetGame()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Drag a flag from the left and drop it onto its correct description on the right!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Draggable Flags
                Expanded(
                  flex: 2,
                  child: Column(
                    children: flags.map((flag) {
                      if (score[flag.id] == true) {
                        return Container(
                          height: 90,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 40,
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Draggable<String>(
                          data: flag.id,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Opacity(
                              opacity: 0.7,
                              child: flag.flagWidget,
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: flag.flagWidget,
                          ),
                          child: Card(
                            color: Colors.grey.shade900,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  flag.flagWidget,
                                  const SizedBox(height: 4),
                                  Text(
                                    flag.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 24),
                // Right Column: Drop Targets (Meanings)
                Expanded(
                  flex: 3,
                  child: Column(
                    children: shuffledMeanings.map((flag) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DragTarget<String>(
                          onAcceptWithDetails: (details) {
                            if (details.data == flag.id) {
                              setState(() {
                                score[flag.id] = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Correct! That is the ${flag.name} flag.',
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Incorrect alignment. Try again!',
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          builder: (context, incoming, rejected) {
                            bool isMatched = score[flag.id] == true;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 90,
                              decoration: BoxDecoration(
                                color: isMatched
                                    ? Colors.green.withOpacity(0.2)
                                    : (incoming.isNotEmpty
                                          ? Colors.purple.withOpacity(0.2)
                                          : Colors.grey.shade900),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isMatched
                                      ? Colors.green
                                      : (incoming.isNotEmpty
                                            ? Colors.purple
                                            : Colors.transparent),
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              alignment: Alignment.center,
                              child: Text(
                                flag.meaning,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isMatched
                                      ? Colors.green.shade200
                                      : Colors.white,
                                  decoration: isMatched
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            if (isGameOver) ...[
              const SizedBox(height: 30),
              const Text(
                '🎉 Congratulations! 🎉\nYou matched all the flags perfectly!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: () => setState(() => _resetGame()),
                child: const Text(
                  'Play Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
