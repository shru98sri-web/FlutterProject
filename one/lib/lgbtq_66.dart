import 'package:flutter/material.dart';

void main() {
  runApp(const ComprehensivePrideMatchApp());
}

class ComprehensivePrideMatchApp extends StatelessWidget {
  const ComprehensivePrideMatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Pride Matcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff121212),
        primaryColor: Colors.deepPurple,
      ),
      home: const PrideMatchGameScreen(),
    );
  }
}

class FlagData {
  final String name;
  final List<Color> colors;

  FlagData({required this.name, required this.colors});
}

class PrideMatchGameScreen extends StatefulWidget {
  const PrideMatchGameScreen({Key? key}) : super(key: key);

  @override
  State<PrideMatchGameScreen> createState() => _PrideMatchGameScreenState();
}

class _PrideMatchGameScreenState extends State<PrideMatchGameScreen> {
  // Database containing all 66 items from the provided master graphic
  final List<FlagData> _masterFlagDatabase = [
    // Row 1
    FlagData(
      name: "Intersex Inclusive",
      colors: [
        Colors.purple,
        Colors.yellow,
        Colors.white,
        Colors.purple,
        Colors.blue,
      ],
    ),
    FlagData(
      name: "Progress Pride",
      colors: [
        Colors.lightBlue,
        Colors.pink,
        Colors.white,
        Colors.brown,
        Colors.black,
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Philadelphia Pride",
      colors: [
        Colors.black,
        Colors.brown,
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Standard Pride",
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
      ],
    ),
    // Row 2
    FlagData(
      name: "Transgender",
      colors: [
        Colors.lightBlueAccent,
        Colors.pinkAccent,
        Colors.white,
        Colors.pinkAccent,
        Colors.lightBlueAccent,
      ],
    ),
    FlagData(
      name: "Nonbinary",
      colors: [Colors.yellow, Colors.white, Colors.purple, Colors.black],
    ),
    FlagData(
      name: "Vincian (gay)",
      colors: [
        Colors.teal,
        Colors.tealAccent,
        Colors.white,
        Colors.blueAccent,
        Colors.indigo,
      ],
    ),
    FlagData(
      name: "Lesbian",
      colors: [
        Colors.orange,
        Colors.orangeAccent,
        Colors.white,
        Colors.pinkAccent,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Gilbert Baker",
      colors: [
        Colors.pink,
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blueAccent,
        Colors.indigo,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Two-Spirit Inclusive",
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Queer",
      colors: [
        Colors.pink,
        Colors.purple,
        Colors.blue,
        Colors.lightGreen,
        Colors.blue,
        Colors.purple,
        Colors.pink,
      ],
    ),
    // Row 3
    FlagData(
      name: "Bisexual",
      colors: [
        Colors.pink,
        Colors.pink,
        Colors.purple,
        Colors.blue,
        Colors.blue,
      ],
    ),
    FlagData(
      name: "Pansexual",
      colors: [Colors.pink, Colors.yellow, Colors.cyan],
    ),
    FlagData(
      name: "Omnisexual",
      colors: [
        Colors.pink,
        Colors.pinkAccent,
        Colors.purple,
        Colors.blue,
        Colors.indigo,
      ],
    ),
    FlagData(
      name: "Polysexual",
      colors: [Colors.pink, Colors.green, Colors.blue],
    ),
    FlagData(
      name: "Intersex",
      colors: [Colors.yellow, Colors.purple, Colors.yellow],
    ),
    FlagData(
      name: "Apothisexual",
      colors: [
        Colors.purple,
        Colors.white,
        Colors.black,
        Colors.white,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Fictosexual",
      colors: [
        Colors.black,
        Colors.grey,
        Colors.purple,
        Colors.pink,
        Colors.purple,
        Colors.grey,
        Colors.black,
      ],
    ),
    // Row 4
    FlagData(
      name: "Genderqueer",
      colors: [Colors.purple, Colors.white, Colors.green],
    ),
    FlagData(
      name: "Genderfluid",
      colors: [
        Colors.pink,
        Colors.white,
        Colors.purple,
        Colors.black,
        Colors.blue,
      ],
    ),
    FlagData(
      name: "Agender",
      colors: [
        Colors.black,
        Colors.grey,
        Colors.white,
        Colors.greenAccent,
        Colors.white,
        Colors.grey,
        Colors.black,
      ],
    ),
    FlagData(
      name: "Genderflux",
      colors: [
        Colors.pinkAccent,
        Colors.pink,
        Colors.white,
        Colors.grey,
        Colors.lightBlue,
      ],
    ),
    FlagData(
      name: "Perunonbinary",
      colors: [
        Colors.orange,
        Colors.yellow,
        Colors.white,
        Colors.purple,
        Colors.blue,
      ],
    ),
    FlagData(
      name: "Androgyne",
      colors: [Colors.pink, Colors.purple, Colors.blue],
    ),
    FlagData(
      name: "Demiandrogyne",
      colors: [
        Colors.grey,
        Colors.white,
        Colors.purple,
        Colors.white,
        Colors.grey,
      ],
    ),
    // Row 5
    FlagData(
      name: "Asexual",
      colors: [Colors.black, Colors.grey, Colors.white, Colors.purple],
    ),
    FlagData(
      name: "Aromantic",
      colors: [
        Colors.green,
        Colors.lightGreen,
        Colors.white,
        Colors.grey,
        Colors.black,
      ],
    ),
    FlagData(
      name: "Greysexual",
      colors: [
        Colors.purple,
        Colors.white,
        Colors.grey,
        Colors.white,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Greyromantic",
      colors: [
        Colors.green,
        Colors.white,
        Colors.grey,
        Colors.white,
        Colors.green,
      ],
    ),
    FlagData(
      name: "Demisexual",
      colors: [Colors.white, Colors.purple, Colors.grey, Colors.black],
    ),
    FlagData(
      name: "Demiromantic",
      colors: [Colors.white, Colors.green, Colors.grey, Colors.black],
    ),
    FlagData(
      name: "Aroace",
      colors: [
        Colors.orange,
        Colors.yellow,
        Colors.white,
        Colors.lightBlue,
        Colors.indigo,
      ],
    ),
    // Row 6
    FlagData(
      name: "Demifluid",
      colors: [
        Colors.grey,
        Colors.white,
        Colors.cyan,
        Colors.purple,
        Colors.cyan,
        Colors.white,
        Colors.grey,
      ],
    ),
    FlagData(
      name: "Demigirl",
      colors: [
        Colors.grey,
        Colors.white,
        Colors.pinkAccent,
        Colors.white,
        Colors.grey,
      ],
    ),
    FlagData(
      name: "Demiboy",
      colors: [
        Colors.grey,
        Colors.white,
        Colors.lightBlueAccent,
        Colors.white,
        Colors.grey,
      ],
    ),
    FlagData(
      name: "Demiandrogynous",
      colors: [
        Colors.grey,
        Colors.white,
        Colors.purple,
        Colors.white,
        Colors.grey,
      ],
    ),
    FlagData(
      name: "Demigender",
      colors: [
        Colors.grey,
        Colors.white,
        Colors.yellow,
        Colors.white,
        Colors.grey,
      ],
    ),
    FlagData(
      name: "Transmasculine",
      colors: [
        Colors.lightBlue,
        Colors.pink,
        Colors.lightBlue,
        Colors.white,
        Colors.lightBlue,
      ],
    ),
    FlagData(
      name: "Transfeminine",
      colors: [
        Colors.pink,
        Colors.lightBlue,
        Colors.pink,
        Colors.white,
        Colors.pink,
      ],
    ),
    // Row 7
    FlagData(
      name: "Stone Sapphic",
      colors: [
        Colors.purple,
        Colors.pinkAccent,
        Colors.white,
        Colors.grey,
        Colors.black,
      ],
    ),
    FlagData(
      name: "Butch",
      colors: [
        Colors.orange,
        Colors.orangeAccent,
        Colors.white,
        Colors.purple,
        Colors.indigo,
      ],
    ),
    FlagData(
      name: "Labrys",
      colors: [Colors.purple, Colors.black, Colors.white],
    ),
    FlagData(
      name: "Sapphic",
      colors: [Colors.pinkAccent, Colors.white, Colors.pink],
    ),
    FlagData(
      name: "Neptunic",
      colors: [
        Colors.blue,
        Colors.cyan,
        Colors.white,
        Colors.pink,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Bigender",
      colors: [
        Colors.pink,
        Colors.white,
        Colors.purple,
        Colors.white,
        Colors.blue,
      ],
    ),
    FlagData(
      name: "Demi Bigender",
      colors: [
        Colors.grey,
        Colors.pink,
        Colors.white,
        Colors.blue,
        Colors.grey,
      ],
    ),
    // Row 8
    FlagData(
      name: "Genderflor",
      colors: [
        Colors.green,
        Colors.yellow,
        Colors.white,
        Colors.pink,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Aroflux",
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.black,
      ],
    ),
    FlagData(
      name: "Aceflux",
      colors: [
        Colors.red,
        Colors.pink,
        Colors.purple,
        Colors.grey,
        Colors.black,
      ],
    ),
    FlagData(
      name: "Abrosexual",
      colors: [
        Colors.green,
        Colors.lightGreen,
        Colors.white,
        Colors.pinkAccent,
        Colors.pink,
      ],
    ),
    FlagData(
      name: "Metagender",
      colors: [
        Colors.teal,
        Colors.white,
        Colors.green,
        Colors.white,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Pangender",
      colors: [
        Colors.yellow,
        Colors.pink,
        Colors.white,
        Colors.purple,
        Colors.yellow,
      ],
    ),
    FlagData(
      name: "Trigender",
      colors: [
        Colors.pink,
        Colors.purple,
        Colors.green,
        Colors.purple,
        Colors.pink,
      ],
    ),
    // Row 9
    FlagData(
      name: "Bear",
      colors: [
        Colors.brown,
        Colors.orange,
        Colors.yellow,
        Colors.white,
        Colors.grey,
        Colors.black,
      ],
    ),
    FlagData(
      name: "Twink",
      colors: [
        Colors.pink,
        Colors.white,
        Colors.yellow,
        Colors.white,
        Colors.pink,
      ],
    ),
    FlagData(
      name: "Genderfae",
      colors: [
        Colors.green,
        Colors.teal,
        Colors.white,
        Colors.pink,
        Colors.purple,
      ],
    ),
    FlagData(
      name: "Neutrois",
      colors: [Colors.white, Colors.green, Colors.black],
    ),
    FlagData(
      name: "Polyamorous (new)",
      colors: [Colors.blue, Colors.white, Colors.red, Colors.black],
    ),
    FlagData(
      name: "Polyamorous",
      colors: [Colors.blue, Colors.red, Colors.black, Colors.yellow],
    ),
    FlagData(
      name: "Alt Polyamorous",
      colors: [Colors.blue, Colors.black, Colors.red, Colors.yellow],
    ),
    // Row 10
    FlagData(
      name: "Puppy Pride",
      colors: [Colors.blue, Colors.black, Colors.red, Colors.white],
    ),
    FlagData(
      name: "Leather",
      colors: [Colors.black, Colors.blue, Colors.white, Colors.red],
    ),
    FlagData(
      name: "Pony",
      colors: [Colors.black, Colors.blue, Colors.white, Colors.green],
    ),
    FlagData(
      name: "Rubber Pride",
      colors: [Colors.black, Colors.blue, Colors.red, Colors.yellow],
    ),
    FlagData(
      name: "Otherkin",
      colors: [Colors.purple, Colors.white, Colors.black],
    ),
    FlagData(
      name: "Ally",
      colors: [
        Colors.black,
        Colors.white,
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
      ],
    ),
    // Overlays / Systems
    FlagData(
      name: "Disability (Magill)",
      colors: [
        Colors.black,
        Colors.red,
        Colors.yellow,
        Colors.blue,
        Colors.green,
      ],
    ),
    FlagData(
      name: "Disability",
      colors: [
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.red,
        Colors.white,
      ],
    ),
    FlagData(
      name: "DID",
      colors: [Colors.teal, Colors.white, Colors.blue, Colors.black],
    ),
    FlagData(
      name: "Autism",
      colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
    ),
    FlagData(
      name: "Autigender",
      colors: [Colors.purple, Colors.blue, Colors.black],
    ),
  ];

  late List<FlagData> _currentRoundFlags;
  late List<FlagData> _shuffledTargetNames;
  final Map<String, bool> _matchedScorecard = {};
  int _currentBatchIndex = 0;
  final int _batchSize = 6;

  @override
  void initState() {
    super.initState();
    _masterFlagDatabase.shuffle();
    _loadCurrentBatch();
  }

  void _loadCurrentBatch() {
    _matchedScorecard.clear();
    int start = _currentBatchIndex * _batchSize;
    int end = start + _batchSize;

    if (end > _masterFlagDatabase.length) {
      end = _masterFlagDatabase.length;
    }

    _currentRoundFlags = _masterFlagDatabase.sublist(start, end);
    _shuffledTargetNames = List.from(_currentRoundFlags)..shuffle();
  }

  void _advanceNextBatch() {
    setState(() {
      _currentBatchIndex++;
      if (_currentBatchIndex * _batchSize >= _masterFlagDatabase.length) {
        _currentBatchIndex = 0;
        _masterFlagDatabase.shuffle();
      }
      _loadCurrentBatch();
    });
  }

  Widget _renderDynamicFlagStripes(List stripeColors) {
    return Container(
      width: 100,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white30, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.5),
        child: Column(
          children: stripeColors
              .map(
                (stripeColor) => Expanded(child: Container(color: stripeColor)),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isBatchComplete =
        _matchedScorecard.length == _currentRoundFlags.length;
    int grandTotalBatches = (_masterFlagDatabase.length / _batchSize).ceil();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pride Matcher (Round ${_currentBatchIndex + 1}/$grandTotalBatches)',
        ),
        backgroundColor: Colors.purple.shade900,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                'Total: ${_masterFlagDatabase.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Drag a flag image container from the left column and drop it precisely onto its identity name target on the right.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Draggable Graphic Representations
                Expanded(
                  flex: 4,
                  child: Column(
                    children: _currentRoundFlags.map((flagItem) {
                      if (_matchedScorecard[flagItem.name] == true) {
                        return Container(
                          height: 95,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.verified,
                            color: Colors.tealAccent,
                            size: 42,
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Draggable(
                          data: flagItem.name,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Opacity(
                              opacity: 0.75,
                              child: _renderDynamicFlagStripes(flagItem.colors),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.25,
                            child: _renderDynamicFlagStripes(flagItem.colors),
                          ),
                          child: Card(
                            color: Colors.grey.shade900,
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: _renderDynamicFlagStripes(flagItem.colors),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ), // Right Column: Drop Targets for Flag Definitions
                Expanded(
                  flex: 5,
                  child: Column(
                    children: _shuffledTargetNames.map((targetItem) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DragTarget(
                          onAcceptWithDetails: (details) {
                            if (details.data == targetItem.name) {
                              setState(() {
                                _matchedScorecard[targetItem.name] = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Matched: ${targetItem.name}!'),
                                  backgroundColor: Colors.teal.shade700,
                                  duration: const Duration(milliseconds: 700),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Mismatch! Try another combination.',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  duration: const Duration(milliseconds: 700),
                                ),
                              );
                            }
                          },
                          builder:
                              (context, currentIncomingData, rejectedData) {
                                bool isAlreadyMatched =
                                    _matchedScorecard[targetItem.name] == true;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  height: 85,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isAlreadyMatched
                                        ? Colors.teal.withOpacity(0.2)
                                        : (currentIncomingData.isNotEmpty
                                              ? Colors.deepPurple.withOpacity(
                                                  0.25,
                                                )
                                              : Colors.grey.shade900),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isAlreadyMatched
                                          ? Colors.tealAccent
                                          : (currentIncomingData.isNotEmpty
                                                ? Colors.deepPurpleAccent
                                                : Colors.white10),
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    targetItem.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isAlreadyMatched
                                          ? Colors.tealAccent
                                          : Colors.white,
                                      decoration: isAlreadyMatched
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
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
            if (isBatchComplete) ...[
              const SizedBox(height: 32),
              Card(
                color: Colors.teal.shade900.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '✨ Round Completed! ✨',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: _advanceNextBatch,
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Next Set of Flags',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
