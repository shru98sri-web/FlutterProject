import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: RagaAnimatorPage()));

class RagaAnimatorPage extends StatefulWidget {
  const RagaAnimatorPage({super.key});

  @override
  State<RagaAnimatorPage> createState() => _RagaAnimatorPageState();
}

class _RagaAnimatorPageState extends State<RagaAnimatorPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  // Categorized structural data for prominent sample Ragas across major Thaats
  final List<RagaData> _ragas = [
    RagaData(
      'Bhairav',
      'Bhairav Thaat',
      'Early Morning',
      ['S', 'r', 'G', 'm', 'P', 'd', 'N'],
      ['S', 'N', 'd', 'P', 'm', 'G', 'r'],
    ),
    RagaData(
      'Yaman',
      'Kalyan Thaat',
      'Evening',
      ['S', 'R', 'G', 'M', 'P', 'D', 'N'],
      ['S', 'N', 'D', 'P', 'M', 'G', 'R'],
    ),
    RagaData(
      'Bhairavi',
      'Bhairavi Thaat',
      'Any Time',
      ['S', 'r', 'g', 'm', 'P', 'd', 'n'],
      ['S', 'n', 'd', 'P', 'm', 'g', 'r'],
    ),
    RagaData(
      'Kafi',
      'Kafi Thaat',
      'Midnight',
      ['S', 'R', 'g', 'm', 'P', 'D', 'n'],
      ['S', 'n', 'D', 'P', 'm', 'g', 'R'],
    ),
    RagaData(
      'Asavari',
      'Asavari Thaat',
      'Morning',
      ['S', 'R', 'M', 'P', 'd'],
      ['S', 'n', 'd', 'P', 'm', 'g', 'R'],
    ),
    RagaData(
      'Bilawal',
      'Bilawal Thaat',
      'Morning',
      ['S', 'R', 'G', 'm', 'P', 'D', 'N'],
      ['S', 'N', 'D', 'P', 'm', 'G', 'R'],
    ),
    RagaData(
      'Todi',
      'Todi Thaat',
      'Morning',
      ['S', 'r', 'g', 'M', 'P', 'd', 'N'],
      ['S', 'N', 'd', 'P', 'M', 'g', 'r'],
    ),
    RagaData(
      'Darbari',
      'Asavari Thaat',
      'Midnight',
      ['S', 'R', 'g', 'm', 'P', 'd', 'n'],
      ['S', 'n', 'd', 'P', 'm', 'g', 'R'],
    ),
    RagaData(
      'Malkauns',
      'Bhairavi Thaat',
      'Late Night',
      ['S', 'g', 'm', 'd', 'n'],
      ['S', 'n', 'd', 'm', 'g'],
    ),
    RagaData(
      'Bhupali',
      'Kalyan Thaat',
      'Evening',
      ['S', 'R', 'G', 'P', 'D'],
      ['S', 'D', 'P', 'G', 'R'],
    ),
  ];

  int _selectedRagaIndex = 0;

  @override
  void initState() {
    super.initState();
    // Controls the fluid speed of the frequency wave animation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentRaga = _ragas[_selectedRagaIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF070714),
      appBar: AppBar(
        title: const Text(
          'Raga Swara Animator',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF101026),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Horizontal Selector Grid for Ragas
          Container(
            height: 70,
            color: const Color(0xFF101026),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _ragas.length,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedRagaIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRagaIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurpleAccent
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.purpleAccent
                            : Colors.white10,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _ragas[index].name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Meta info panel
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentRaga.thaat,
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Prahar: ${currentRaga.time}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.music_note, color: Colors.amberAccent, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Scale Grid',
                      style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Animation Canvas View
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(double.infinity, 300),
                    painter: RagaWavePainter(
                      raga: currentRaga,
                      animValue: _waveController.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // Interactive Swara Scale Visualizer Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: const Color(0xFF101026),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSwaraRow(
                  'Arohana (Ascending)',
                  currentRaga.arohana,
                  Colors.greenAccent,
                ),
                const SizedBox(height: 16),
                _buildSwaraRow(
                  'Avarohana (Descending)',
                  currentRaga.avarohana,
                  Colors.orangeAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwaraRow(String label, List<String> swaras, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: swaras.map((swara) {
            return Container(
              margin: const EdgeInsets.only(right: 6),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                border: Border.all(color: color.withValues(alpha: 0.4)),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                swara,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class RagaData {
  final String name;
  final String thaat;
  final String time;
  final List<String> arohana;
  final List<String> avarohana;

  RagaData(this.name, this.thaat, this.time, this.arohana, this.avarohana);
}

class RagaWavePainter extends CustomPainter {
  final RagaData raga;
  final double animValue;

  RagaWavePainter({required this.raga, required this.animValue});

  // Structural mapping of frequencies representing structural heights of Swaras
  final Map<String, double> _swaraHeights = {
    'S': 0.9,
    'r': 0.78,
    'R': 0.7,
    'g': 0.58,
    'G': 0.5,
    'm': 0.38,
    'M': 0.3,
    'P': 0.1,
    'd': -0.1,
    'D': -0.2,
    'n': -0.4,
    'N': -0.5,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final midY = size.height / 2;
    final width = size.width;

    // 1. Draw a mathematical sine wave tracking rhythmic pulsation (Taal baseline)
    final wavePaint = Paint()
      ..color = Colors.indigo.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    path.moveTo(0, midY);
    for (double x = 0; x <= width; x++) {
      final double relativeX = x / width;
      final double y =
          midY +
          math.sin((relativeX * 2 * math.pi) + (animValue * 2 * math.pi)) * 40;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, wavePaint);

    // 2. Map Arohana & Avarohana nodes chronologically across horizontal space
    final totalNotes = raga.arohana.length + raga.avarohana.length;
    final stepX = width / (totalNotes + 1);

    int noteIndex = 0;

    // Draw Ascending Phase Nodes
    for (int i = 0; i < raga.arohana.length; i++) {
      final swara = raga.arohana[i];
      _drawSwaraNode(canvas, swara, ++noteIndex, stepX, midY, true);
    }

    // Draw Descending Phase Nodes
    for (int i = 0; i < raga.avarohana.length; i++) {
      final swara = raga.avarohana[i];
      _drawSwaraNode(canvas, swara, ++noteIndex, stepX, midY, false);
    }
  }

  void _drawSwaraNode(
    Canvas canvas,
    String swara,
    int index,
    double stepX,
    double midY,
    bool isAscending,
  ) {
    final double nodeX = index * stepX;
    // Map vertical axis delta via musical pitch height
    final double pitchFactor = _swaraHeights[swara] ?? 0.0;

    // Animate node vibration based on timeline oscillation
    final double dynamicOffset =
        math.sin((animValue * 2 * math.pi) + index) * 6;
    final double nodeY = midY + (pitchFactor * 80) + dynamicOffset;

    final nodeColor = isAscending
        ? Colors.greenAccent
        : Colors.orangeAccent; // Draw visual glow structure around note center
    canvas.drawCircle(
      Offset(nodeX, nodeY),
      12,
      Paint()..color = nodeColor.withValues(alpha: 0.15),
    );
    canvas.drawCircle(
      Offset(nodeX, nodeY),
      4,
      Paint()..color = nodeColor,
    ); // Render underlying Swara character text layout directly over vectors
    final textPainter = TextPainter(
      text: TextSpan(
        text: swara,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(nodeX - (textPainter.width / 2), nodeY - 24),
    );
  }

  @override
  bool shouldRepaint(covariant RagaWavePainter oldDelegate) => true;
}
