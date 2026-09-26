import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: MelakartaMatrixPage()));

class MelakartaMatrixPage extends StatefulWidget {
  const MelakartaMatrixPage({super.key});

  @override
  State<MelakartaMatrixPage> createState() => _MelakartaMatrixPageState();
}

class _MelakartaMatrixPageState extends State<MelakartaMatrixPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;
  int _selectedRagaNumber =
      1; // Tracks currently active Melakarta Raga (1 to 72)

  // Melakarta System Constant Structural Arrays
  final List<String> _chakras = [
    'Indu',
    'Netra',
    'Agni',
    'Veda',
    'Bana',
    'Rutu',
    'Rishi',
    'Vasu',
    'Brahma',
    'Disa',
    'Rudra',
    'Aditya',
  ];

  // Swara nomenclature strings for Carnatic system matching index formulas
  final List<String> _rCombinations = ['R1', 'R1', 'R1', 'R2', 'R2', 'R3'];
  final List<String> _gCombinations = ['G1', 'G2', 'G3', 'G2', 'G3', 'G3'];
  final List<String> _dCombinations = ['D1', 'D1', 'D1', 'D2', 'D2', 'D3'];
  final List<String> _nCombinations = ['N1', 'N2', 'N3', 'N2', 'N3', 'N3'];

  // All 72 Melakarta Raga Names in canonical chronological order
  final List<String> _ragaNames = [
    'Kanakangi',
    'Ratnangi',
    'Ganamurthi',
    'Vanaspati',
    'Manavati',
    'Tanarupi',
    'Senavati',
    'Hanumatodi',
    'Dhenuka',
    'Natabhairavi',
    'Mayamalavagowla',
    'Charukesi',
    'Sarasangi',
    'Harikambhoji',
    'Dheerasankarabharanam',
    'Naganandini',
    'Yagapriya',
    'Ragavardhini',
    'Asavari',
    'Nadavangini',
    'Dharmavati',
    'Haripriya',
    'Gowrimanohari',
    'Varunapriya',
    'Mararanjani',
    'Charumathi',
    'Saraswathi',
    'Haridasapriya',
    'Dheera',
    'Naganandhi',
    'Yagapriya',
    'Ragavardhini',
    'Gangeyabhushani',
    'Vagadhishwari',
    'Shulini',
    'Chalanata',
    'Salagam',
    'Jalarnavam',
    'Jhalavarali',
    'Navaneetam',
    'Pavani',
    'Raghupriya',
    'Gavambhodhi',
    'Bhavapriya',
    'Shubhapantuvarali',
    'Shadvidhamargini',
    'Suvarnangi',
    'Divyamani',
    'Dhavalambari',
    'Namanarayani',
    'Kamavardhini',
    'Ramapriya',
    'Gamanaashrama',
    'Vishwambhari',
    'Shyamalangi',
    'Shanmukhapriya',
    'Simhendramadhyamam',
    'Hemavati',
    'Dharmavati',
    'Nitimati',
    'Kantamani',
    'Rishabhapriya',
    'Latangi',
    'Vachaspati',
    'Me Kalyani',
    'Chitrambari',
    'Sucharitra',
    'Jyotiswarupini',
    'Dhatuvardhani',
    'Nasikabhushani',
    'Kosalam',
    'Rasikapriya',
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  // Pure mathematical generator computing precise notes using structural index logic
  List<String> _generateScale(int ragaNum) {
    int zeroIndex = ragaNum - 1;
    String m = ragaNum <= 36 ? 'M1' : 'M2'; // Suddha vs Prati Madhyama split

    int chakraIndex = zeroIndex ~/ 6;
    int ragaInChakra = zeroIndex % 6;

    // Outer cyclic variation patterns determining context combinations
    String r = _rCombinations[chakraIndex % 6];
    String g = _gCombinations[chakraIndex % 6];
    String d = _dCombinations[ragaInChakra];
    String n = _nCombinations[ragaInChakra];

    return ['S', r, g, m, 'P', d, n, 'S\''];
  }

  @override
  Widget build(BuildContext context) {
    final scale = _generateScale(_selectedRagaNumber);
    final currentChakra = _chakras[(_selectedRagaNumber - 1) ~/ 6];
    final isPratiM = _selectedRagaNumber > 36;

    return Scaffold(
      backgroundColor: const Color(0xFF030312),
      appBar: AppBar(
        title: const Text(
          '72 Melakarta Matrix Explorer',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF0C0C24),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Dynamic Header Detail View Dashboard
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0C0C24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No. $_selectedRagaNumber: ${_ragaNames[_selectedRagaNumber - 1]}',
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chakra: $currentChakra | Class: ${isPratiM ? "Prati Madhyama (M2)" : "Suddha Madhyama (M1)"}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scale Frequencies Custom Vector Animation Graph
          Expanded(
            flex: 2,
            child: Center(
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(double.infinity, 220),
                    painter: MelakartaScalePainter(
                      scale: scale,
                      animValue: _waveController.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // Complete Matrix Grid Scroll Container covering all 72 items concurrently
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF08081A),
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      6, // Compact grid columns mapping complete layout clean
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: 72,
                itemBuilder: (context, index) {
                  final ragaNum = index + 1;
                  final isSelected = ragaNum == _selectedRagaNumber;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRagaNumber = ragaNum),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.deepPurpleAccent.withValues(alpha: 0.8)
                            : const Color(0xFF121236),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? Colors.cyanAccent
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$ragaNum',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _ragaNames[index].substring(
                              0,
                              math.min(4, _ragaNames[index].length),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MelakartaScalePainter extends CustomPainter {
  final List<String> scale;
  final double animValue;

  MelakartaScalePainter({required this.scale, required this.animValue});

  // Vertical position factor map mimicking musical pitch elevation offsets
  final Map<String, double> _swaraHeights = {
    'S': 0.8,
    'R1': 0.65,
    'R2': 0.55,
    'R3': 0.45,
    'G1': 0.45,
    'G2': 0.35,
    'G3': 0.25,
    'M1': 0.1,
    'M2': 0.0,
    'P': -0.2,
    'D1': -0.4,
    'D2': -0.5,
    'D3': -0.6,
    'N1': -0.6,
    'N2': -0.7,
    'N3': -0.8,
    'S\'': -0.95,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final midY = size.height / 2;
    final width = size.width;

    // Draw baseline thread line link
    final pathPaint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final stepX = width / (scale.length + 1);
    final List<Offset> points = [];

    for (int i = 0; i < scale.length; i++) {
      final swara = scale[i];
      final double x = (i + 1) * stepX;
      final double pitchFactor = _swaraHeights[swara] ?? 0.0;

      // Calculate micro-pulsation variance loop string frequency dynamics
      final double waveOffset = math.sin((animValue * 2 * math.pi) + i) * 5;
      final double y = midY + (pitchFactor * 75) + waveOffset;
      points.add(Offset(x, y));
    }

    // Connect node pathways elegantly
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (var pt in points) {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(path, pathPaint);

    // Draw visual glow indicators for each scale element
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      canvas.drawCircle(
        pt,
        8,
        Paint()..color = Colors.tealAccent.withValues(alpha: 0.2),
      );
      canvas.drawCircle(pt, 3, Paint()..color = Colors.tealAccent);

      // Overlay Swara identifier string text explicitly above coordinate center
      final textPainter = TextPainter(
        text: TextSpan(
          text: scale[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(pt.dx - (textPainter.width / 2), pt.dy - 22),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MelakartaScalePainter oldDelegate) => true;
}
