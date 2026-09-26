import 'package:flutter/material.dart';

void main() {
  // Ensure Flutter engine frame bindings are up before rendering
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YogaApp());
}

/// Root Application Widget Configuration
class YogaApp extends StatelessWidget {
  const YogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
      ),
      home: const YogaSequencePage(),
    );
  }
}

/// Data model representing each Yoga Pose in our sequence
class YogaPose {
  final int id;
  final String englishName;
  final String sanskritName;
  final String benefits;

  const YogaPose({
    required this.id,
    required this.englishName,
    required this.sanskritName,
    required this.benefits,
  });
}

class YogaSequencePage extends StatefulWidget {
  const YogaSequencePage({super.key});

  @override
  State<YogaSequencePage> createState() => _YogaSequencePageState();
}

class _YogaSequencePageState extends State<YogaSequencePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _morphController;

  // Track current selection and historic step for smooth linear interpolation
  int _currentPoseIndex = 0;
  int _previousPoseIndex = 0;

  // The curated sequence matching your painter's procedural data indices
  final List<YogaPose> _sequence = const [
    YogaPose(
      id: 0,
      englishName: "Prayer Pose",
      sanskritName: "Pranamasana",
      benefits: "Centers the mind, improves posture and balance.",
    ),
    YogaPose(
      id: 1,
      englishName: "Raised Arms Pose",
      sanskritName: "Hastauttanasana",
      benefits: "Stretches the abdomen, opens the chest and lungs.",
    ),
    YogaPose(
      id: 2,
      englishName: "Standing Forward Fold",
      sanskritName: "Uttanasana",
      benefits: "Calms the brain, stretches hamstrings and calves.",
    ),
    YogaPose(
      id: 3,
      englishName: "Low Lunge",
      sanskritName: "Anjaneyasana",
      benefits: "Opens hip flexors, strengthens quadriceps and glutes.",
    ),
    YogaPose(
      id: 4,
      englishName: "Plank Pose",
      sanskritName: "Dandasana",
      benefits: "Builds core stability, strengthens wrists and shoulders.",
    ),
    YogaPose(
      id: 5,
      englishName: "8-Point Touch",
      sanskritName: "Ashtanga Namaskara",
      benefits: "Strengthens arm muscles, develops chest flexibility.",
    ),
    YogaPose(
      id: 6,
      englishName: "Cobra Pose",
      sanskritName: "Bhujangasana",
      benefits: "Strengthens the spine, stretches chest and shoulders.",
    ),
    YogaPose(
      id: 7,
      englishName: "Downward-Facing Dog",
      sanskritName: "Adho Mukha Svanasana",
      benefits: "Energises the body, deeply stretches the entire spine.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Smooth bone morph speed
    );
    // Complete the initial frame setup immediately
    _morphController.forward(from: 1.0);
  }

  @override
  void dispose() {
    _morphController.dispose();
    super.dispose();
  }

  void _onPoseSelected(int index) {
    if (index == _currentPoseIndex) return;

    setState(() {
      _previousPoseIndex = _sequence[_currentPoseIndex].id;
      _currentPoseIndex = index;
    });

    // Reset and fire the morph animation controller
    _morphController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final activePose = _sequence[_currentPoseIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        title: const Text(
          "Yoga Asanas",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal.shade900,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 1. Interactive Morphing Canvas Window
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedBuilder(
                  animation: _morphController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(280, 280),
                      painter: DynamicAsanaPainter(
                        currentPoseIndex: activePose.id,
                        previousPoseIndex: _previousPoseIndex,
                        animationValue: CurvedAnimation(
                          parent: _morphController,
                          curve: Curves
                              .easeInOutCubic, // Beautiful biological deceleration curve
                        ).value,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 2. Dynamically Updating Asana Context Metadata Cards
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activePose.englishName,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activePose.sanskritName,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.teal.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    activePose.benefits,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Scrollable Progress Timeline Controller View
          Container(
            height: 110,
            padding: const EdgeInsets.only(bottom: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              itemCount: _sequence.length,
              itemBuilder: (context, index) {
                final pose = _sequence[index];
                final bool isSelected = index == _currentPoseIndex;

                return GestureDetector(
                  onTap: () => _onPoseSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 76,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.teal.withOpacity(0.15),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : Colors.teal.shade800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            pose.englishName.split(
                              ' ',
                            )[0], // Punchy single-word label truncation
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white.withOpacity(0.9)
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// DynamicAsanaPainter Engine implementation goes below
class DynamicAsanaPainter extends CustomPainter {
  final int currentPoseIndex;
  final int previousPoseIndex;
  final double animationValue;

  DynamicAsanaPainter({
    required this.currentPoseIndex,
    required this.previousPoseIndex,
    required this.animationValue,
  });

  Map<String, Offset> _getPoseJoints(int index, Offset center) {
    Offset head = Offset(center.dx, center.dy - 70);
    Offset neck = Offset(center.dx, center.dy - 50);
    Offset pelvis = Offset(center.dx, center.dy + 10);
    Offset leftHand = Offset(center.dx - 25, center.dy - 20);
    Offset rightHand = Offset(center.dx + 25, center.dy - 20);
    Offset leftFoot = Offset(center.dx - 20, center.dy + 80);
    Offset rightFoot = Offset(center.dx + 20, center.dy + 80);

    if (index == 0 || index == 11 || index == 100) {
      leftHand = Offset(center.dx - 12, center.dy - 40);
      rightHand = Offset(center.dx + 12, center.dy - 40);
    } else if (index == 1 || index == 10 || index == 101) {
      head = Offset(center.dx - 15, center.dy - 65);
      neck = Offset(center.dx - 5, center.dy - 45);
      leftHand = Offset(center.dx - 40, center.dy - 95);
      rightHand = Offset(center.dx - 35, center.dy - 95);
    } else if (index == 2 || index == 9 || index == 105) {
      head = Offset(center.dx - 5, center.dy + 30);
      neck = Offset(center.dx, center.dy + 10);
      pelvis = Offset(center.dx, center.dy - 20);
      leftHand = Offset(center.dx - 20, center.dy + 65);
      rightHand = Offset(center.dx + 10, center.dy + 65);
    } else if (index == 3 || index == 8 || index == 106) {
      pelvis = Offset(center.dx - 10, center.dy + 30);
      head = Offset(center.dx - 10, center.dy - 20);
      neck = Offset(center.dx - 10, center.dy);
      leftFoot = Offset(center.dx - 60, center.dy + 75);
      rightFoot = Offset(center.dx + 70, center.dy + 75);
      leftHand = Offset(center.dx - 15, center.dy + 65);
      rightHand = Offset(center.dx + 15, center.dy + 65);
    } else if (index == 4) {
      pelvis = Offset(center.dx, center.dy + 20);
      head = Offset(center.dx - 70, center.dy - 5);
      neck = Offset(center.dx - 50, center.dy);
      leftHand = Offset(center.dx - 50, center.dy + 60);
      rightHand = Offset(center.dx - 45, center.dy + 60);
      leftFoot = Offset(center.dx + 70, center.dy + 40);
      rightFoot = Offset(center.dx + 75, center.dy + 40);
    } else if (index == 5) {
      pelvis = Offset(center.dx, center.dy - 5);
      head = Offset(center.dx - 70, center.dy + 25);
      neck = Offset(center.dx - 50, center.dy + 35);
      leftHand = Offset(center.dx - 45, center.dy + 45);
      rightHand = Offset(center.dx - 40, center.dy + 45);
      leftFoot = Offset(center.dx + 70, center.dy + 45);
      rightFoot = Offset(center.dx + 75, center.dy + 45);
    } else if (index == 6) {
      pelvis = Offset(center.dx + 10, center.dy + 45);
      head = Offset(center.dx - 50, center.dy - 25);
      neck = Offset(center.dx - 45, center.dy);
      leftHand = Offset(center.dx - 40, center.dy + 45);
      rightHand = Offset(center.dx - 35, center.dy + 45);
      leftFoot = Offset(center.dx + 80, center.dy + 45);
      rightFoot = Offset(center.dx + 85, center.dy + 45);
    } else if (index == 7) {
      pelvis = Offset(center.dx, center.dy - 40);
      head = Offset(center.dx - 45, center.dy + 35);
      neck = Offset(center.dx - 35, center.dy + 15);
      leftHand = Offset(center.dx - 55, center.dy + 65);
      rightHand = Offset(center.dx - 50, center.dy + 65);
      leftFoot = Offset(center.dx + 50, center.dy + 65);
      rightFoot = Offset(center.dx + 55, center.dy + 65);
    }
    return {
      'head': head,
      'neck': neck,
      'pelvis': pelvis,
      'leftHand': leftHand,
      'rightHand': rightHand,
      'leftFoot': leftFoot,
      'rightFoot': rightFoot,
    };
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.teal.shade700
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final headPaint = Paint()
      ..color = Colors.teal.shade800
      ..style = PaintingStyle.fill;
    final startPose = _getPoseJoints(previousPoseIndex, center);
    final endPose = _getPoseJoints(currentPoseIndex, center);
    Offset lerpJoint(String key) {
      return Offset.lerp(startPose[key], endPose[key], animationValue)!;
    }

    final head = lerpJoint('head');
    final neck = lerpJoint('neck');
    final pelvis = lerpJoint('pelvis');
    final leftHand = lerpJoint('leftHand');
    final rightHand = lerpJoint('rightHand');
    final leftFoot = lerpJoint('leftFoot');
    final rightFoot = lerpJoint('rightFoot');
    canvas.drawCircle(head, 15, headPaint);
    canvas.drawLine(head, neck, paint);
    canvas.drawLine(neck, pelvis, paint);
    canvas.drawLine(neck, leftHand, paint);
    canvas.drawLine(neck, rightHand, paint);
    canvas.drawLine(pelvis, leftFoot, paint);
    canvas.drawLine(pelvis, rightFoot, paint);
  }

  @override
  bool shouldRepaint(covariant DynamicAsanaPainter oldDelegate) {
    return oldDelegate.currentPoseIndex != currentPoseIndex ||
        oldDelegate.previousPoseIndex != previousPoseIndex ||
        oldDelegate.animationValue != animationValue;
  }
}
