import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

// Simulating flutter_synth style software oscillator tone engine
class AudioSynthEngine {
  bool _isPlaying = false;
  Timer? _noteTimer;

  // Exact frequencies mapping a standard Carnatic dynamic octave (Adharashadjama C4 = 261.63Hz)
  final Map<String, double> swaraFreqs = {
    'S': 261.63, // Shadjam
    'R1': 277.18, // Suddha Rishabham
    'R2': 293.66, // Chatusruti Rishabham / Suddha Gandharam
    'R3': 311.13, // Shatsruti Rishabham / Sadharana Gandharam
    'G1': 293.66, // Suddha Gandharam
    'G2': 311.13, // Sadharana Gandharam
    'G3': 329.63, // Antara Gandharam
    'M1': 349.23, // Suddha Madhyamam
    'M2': 369.99, // Prati Madhyamam
    'P': 392.00, // Panchamam
    'D1': 415.30, // Suddha Dhaivatam
    'D2': 440.00, // Chatusruti Dhaivatam / Suddha Nishadham
    'D3': 466.16, // Shatsruti Dhaivatam / Sadharana Nishadham
    'N1': 440.00, // Suddha Nishadham
    'N2': 466.16, // Sadharana Nishadham
    'N3': 493.88, // Antara Nishadham
    'S\'': 523.25, // Tara Shadjam (Higher Octave Sa)
  };

  void playScale(
    List<String> notes,
    Function(String activeNote) onNoteTrigger,
    Function() onComplete,
  ) {
    if (_isPlaying) stop();
    _isPlaying = true;
    int index = 0;

    _noteTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (index >= notes.length) {
        timer.cancel();
        _isPlaying = false;
        onComplete();
        return;
      }
      String currentNote = notes[index];
      double? frequency = swaraFreqs[currentNote];

      // flutter_synth invocation trigger logic output channel simulation
      debugPrint(
        "flutter_synth -> Generating Square/Sine wave stream at: $frequency Hz",
      );

      onNoteTrigger(currentNote);
      index++;
    });
  }

  void stop() {
    _noteTimer?.cancel();
    _isPlaying = false;
  }
}

void main() => runApp(const MaterialApp(home: ComprehensiveMelakartaPage()));

class ComprehensiveMelakartaPage extends StatefulWidget {
  const ComprehensiveMelakartaPage({super.key});

  @override
  State<ComprehensiveMelakartaPage> createState() =>
      _ComprehensiveMelakartaPageState();
}

class _ComprehensiveMelakartaPageState extends State<ComprehensiveMelakartaPage>
    with SingleTickerProviderStateMixin {
  final AudioSynthEngine _synth = AudioSynthEngine();
  late final AnimationController _waveController;

  int _selectedRagaNum = 1;
  String _currentPlayingSwara = '';
  bool _playbackActive = false;

  // Complete mapping lists containing regular Sampurna names alongside historically accurate Asampurna variants
  final List<String> _sampurnaNames = [
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
    'Varunapriya',
    'Mararanjani',
    'Charumathi',
    'Saraswathi',
    'Haridasapriya',
    'Dheera',
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

  final List<String> _asampurnaNames = [
    'Kanakambari',
    'Phenadyuti',
    'Ganasamavarali',
    'Bhanumati',
    'Manoranjani',
    'Tanukirti',
    'Senagrani',
    'Janatodi',
    'Dhanyasi',
    'Natabharanam',
    'Mayamalavagowla',
    'Tarangini',
    'Geevani',
    'Harikedaragowla',
    'Sankarabharanam',
    'Natakuranji',
    'Chayavati',
    'Jayashuddhamalavi',
    'Jhankarabhramari',
    'Nariritigowla',
    'Kiranavali',
    'Sriranjani',
    'Gowrivelavali',
    'Viravasantam',
    'Sharavati',
    'Tarangini',
    'Sowrashtram',
    'Harikambhoji',
    'Sankarabharanam',
    'Naganandini',
    'Kalavati',
    'Ragachudamani',
    'Gangatarangini',
    'Vagishwari',
    'Sailadesakshi',
    'Chalanata',
    'Sowrashtra',
    'Jaganmohana',
    'Dhalivarali',
    'Nabhomani',
    'Pratapa',
    'Ravikriya',
    'Geervani',
    'Bhavani',
    'Pantuvarali',
    'Stavaraja',
    'Souvarnam',
    'Jivantika',
    'Dhavalanga',
    'Namadeshi',
    'Kasiramakriya',
    'Ramakali',
    'Gamanaashrama',
    'Vishwambhari',
    'Syamala',
    'Simhendramadhyamam',
    'DeshiKalyani',
    'Hemavati',
    'Dharmavati',
    'Nisada',
    'Kuntala',
    'Ratnapriya',
    'Geetapriya',
    'Bhushavati',
    'Shantakalyani',
    'Chaturangini',
    'SantanaManjari',
    'Jeevantini',
    'Dhatuvardhani',
    'Nasamani',
    'Kusumavali',
    'Rasika',
  ];

  final List<String> _rCombs = ['R1', 'R1', 'R1', 'R2', 'R2', 'R3'];
  final List<String> _gCombs = ['G1', 'G2', 'G3', 'G2', 'G3', 'G3'];
  final List<String> _dCombs = ['D1', 'D1', 'D1', 'D2', 'D2', 'D3'];
  final List<String> _nCombs = ['N1', 'N2', 'N3', 'N2', 'N3', 'N3'];

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
    _synth.stop();
    _waveController.dispose();
    super.dispose();
  }

  // Generates clean linear scales for full continuous playback validation loops
  Map<String, List<String>> _generateFullScales(int num) {
    int idx = num - 1;
    String m = num <= 36 ? 'M1' : 'M2';
    String r = _rCombs[idx ~/ 6 % 6];
    String g = _gCombs[idx ~/ 6 % 6];
    String d = _dCombs[idx % 6];
    String n = _nCombs[idx % 6];

    return {
      'arohanam': ['S', r, g, m, 'P', d, n, 'S\''],
      'avarohanam': ['S\'', n, d, 'P', m, g, r, 'S'],
    };
  }

  void _triggerPlayback(List<String> arohanam, List<String> avarohanam) {
    setState(() => _playbackActive = true);
    List<String> fullSequence = [...arohanam, ...avarohanam];

    _synth.playScale(
      fullSequence,
      (activeNote) {
        setState(() => _currentPlayingSwara = activeNote);
      },
      () {
        setState(() {
          _playbackActive = false;
          _currentPlayingSwara = '';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scales = _generateFullScales(_selectedRagaNum);
    final arohanam = scales['arohanam']!;
    final avarohanam = scales['avarohanam']!;

    return Scaffold(
      backgroundColor: const Color(0xFF02020A),
      appBar: AppBar(
        title: const Text(
          'Melakarta Synth & System Nomenclature',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: const Color(0xFF0A0A1E),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Informational Metadata Card Display Block
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0A0A1E),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mela Raga #$_selectedRagaNum',
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _playbackActive
                          ? null
                          : () => _triggerPlayback(arohanam, avarohanam),
                      icon: const Icon(Icons.audiotrack, size: 14),
                      label: const Text(
                        'Play via Synth',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Sampurna (Govinda): ${_sampurnaNames[_selectedRagaNum - 1]}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Asampurna (Dikshitar): ${_asampurnaNames[_selectedRagaNum - 1]}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Double Scale Visualization Display Engine Panel (Arohanam + Avarohanam Canvas rows)
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'Arohanam (Ascending)',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: RagaScaleCanvasPainter(
                              scale: arohanam,
                              activeSwara: _currentPlayingSwara,
                              isAscending: true,
                              animValue: _waveController.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'Avarohanam (Descending)',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: RagaScaleCanvasPainter(
                              scale: avarohanam,
                              activeSwara: _currentPlayingSwara,
                              isAscending: false,
                              animValue: _waveController.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ), // Core Selection Matrix interface grid selection engine
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF050512),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 72,
                itemBuilder: (context, index) {
                  final currentNum = index + 1;
                  final isSelected = currentNum == _selectedRagaNum;
                  return InkWell(
                    onTap: () {
                      _synth.stop();
                      setState(() {
                        _selectedRagaNum = currentNum;
                        _playbackActive = false;
                        _currentPlayingSwara = '';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.cyanAccent.withValues(alpha: 0.2)
                            : const Color(0xFF0E0E26),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected
                              ? Colors.cyanAccent
                              : Colors.white10,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$currentNum',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.cyanAccent
                              : Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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

class RagaScaleCanvasPainter extends CustomPainter {
  final List scale;
  final String activeSwara;
  final bool isAscending;
  final double animValue;
  RagaScaleCanvasPainter({
    required this.scale,
    required this.activeSwara,
    required this.isAscending,
    required this.animValue,
  });
  final Map<String, double> _heightMap = {
    'S': 0.8,
    'R1': 0.68,
    'R2': 0.58,
    'R3': 0.48,
    'G1': 0.58,
    'G2': 0.48,
    'G3': 0.38,
    'M1': 0.2,
    'M2': 0.0,
    'P': -0.2,
    'D1': -0.4,
    'D2': -0.5,
    'D3': -0.6,
    'N1': -0.5,
    'N2': -0.6,
    'N3': -0.7,
    'S': -0.85,
  };
  @override
  // TODO: implement paint
  void paint(Canvas canvas, Size size) {
    final midY = size.height / 2;
    final double stepX = size.width / (scale.length + 1);
    List points = [];
    for (int i = 0; i < scale.length; i++) {
      double x = (i + 1) * stepX;
      double hFactor =
          _heightMap[scale[i]] ??
          0.0; // Compute micro-vibrations tracking ongoing oscillation loops
      double waveOffset = math.sin((animValue * 2 * math.pi) + i) * 4;
      double y = midY + (hFactor * (size.height * 0.4)) + waveOffset;
      points.add(Offset(x, y));
    } // Paint line segments linking computed scale properties
    final edgePaint = Paint()
      ..color = (isAscending ? Colors.tealAccent : Colors.orangeAccent)
          .withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (var pt in points) {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(
      path,
      edgePaint,
    ); // Draw active indicator rings overlaying node pathways cleanly
    for (int i = 0; i < scale.length; i++) {
      final pt = points[i];
      final isCurrentNode = scale[i] == activeSwara;
      if (isCurrentNode) {
        canvas.drawCircle(
          pt,
          14,
          Paint()..color = Colors.blueAccent.withValues(alpha: 0.4),
        );
        canvas.drawCircle(pt, 5, Paint()..color = Colors.blueAccent);
      } else {
        canvas.drawCircle(
          pt,
          4,
          Paint()
            ..color = isAscending ? Colors.tealAccent : Colors.orangeAccent,
        );
      }
      final textPainter = TextPainter(
        text: TextSpan(
          text: scale[i],
          style: TextStyle(
            color: isCurrentNode ? Colors.blueAccent : Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(pt.dx - (textPainter.width / 2), pt.dy - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant RagaScaleCanvasPainter oldDelegate) => true;
}
