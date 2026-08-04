import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: ScienceSoftware(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScienceSoftware extends StatefulWidget {
  @override
  _ScienceSoftwareState createState() => _ScienceSoftwareState();
}

class _ScienceSoftwareState extends State<ScienceSoftware> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // The array of pages
  final List<Widget> _pages = [
    NeuromorphicBrainApp(),
    StructuredLightApp(),
    Stoke(),
    UltimateQuantumSteeringLab(),
    ColdAtomLabSuite(),
    Myoam(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Science Software'),
        backgroundColor: Colors.blueGrey,
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.lens_blur_rounded),
            label: 'Neuromorphic Brain Synapse Signal ',
            backgroundColor: Colors.black87,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lens_outlined),
            label: 'Structured Light Simulator',
            backgroundColor: Colors.black87,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Stoke Law',
            backgroundColor: Colors.black87,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq_outlined),
            label: 'Quantum Steering',
            backgroundColor: Colors.black87,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop_outlined),
            label: 'Cold Atom Suite',
            backgroundColor: Colors.black87,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty_rounded),
            label: 'OAM Laser Simulator',
            backgroundColor: Colors.black87,
          ),
        ],
      ),
    );
  }
}

class NeuromorphicBrainApp extends StatelessWidget {
  const NeuromorphicBrainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neuromorphic Synaptic Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const BrainNetworkScreen(),
    );
  }
}

/// बायोमिमिक न्यूरॉन मॉडेल (सिनेप्टिक कनेक्टिव्हिटीसह)
class NetworkNeuron {
  final int id;
  double a, b, c, d;
  double v; // मेंब्रेन पोटेंशियल (Voltage)
  double u; // रिकव्हरी व्हेरिएबल
  bool isSpiking = false;
  double synapticInput = 0.0; // इतर नोड्स कडून मिळणारा करंट

  NetworkNeuron({
    required this.id,
    this.a = 0.02,
    this.b = 0.2,
    this.c = -65.0,
    this.d = 6.0,
    this.v = -65.0,
    this.u = -13.0,
  });

  /// बाह्य आणि सिनेप्टिक इनपुटच्या आधारे नोड अपडेट करणे
  void update(double externalInput) {
    double totalInput = externalInput + synapticInput;

    // Izhikevich समीकरणे
    v += 0.04 * v * v + 5 * v + 140 - u + totalInput;
    u += a * (b * v - u);

    // सिनेप्टिक इनपुट हळूहळू कमी करणे (Decay)
    synapticInput *= 0.75;

    if (v >= 30.0) {
      isSpiking = true;
      v = c;
      u += d;
    } else {
      isSpiking = false;
    }
  }
}

class BrainNetworkScreen extends StatefulWidget {
  const BrainNetworkScreen({Key? key}) : super(key: key);

  @override
  State<BrainNetworkScreen> createState() => _BrainNetworkScreenState();
}

class _BrainNetworkScreenState extends State<BrainNetworkScreen> {
  final List<NetworkNeuron> _neurons = [];
  final List<FlSpot> _chartData = [];
  late Timer _networkTimer;
  final int _maxChartPoints = 50;

  // प्रत्येक ६ नोड्ससाठी स्वतंत्र इनपुट करंट नियंत्रित करणारी लिस्ट
  final List<double> _nodeCurrents = [15.0, 0.0, 0.0, 0.0, 0.0, 0.0];

  // निवडलेला नोड ज्याचा लाइव्ह ग्राफ Oscilloscope वर दिसेल
  int _selectedNodeForChart = 0;

  // सिनेप्टिक कनेक्शन मॅट्रिक्स
  final Map<int, List<int>> _synapticConnections = {
    0: [], // Node 0 -> Node 1, 2
    1: [], // Node 1 -> Node 3, 4
    2: [], // Node 2 -> Node 5
    3: [], // Feedback Loop
    4: [],
    5: [],
  };

  @override
  void initState() {
    super.initState();
    // ६ न्यूरॉन्सचे जाळे तयार करणे
    for (int i = 0; i < 6; i++) {
      _neurons.add(NetworkNeuron(id: i));
    }

    // ग्राफचा सुरुवातीचा डेटा भरणे
    for (int i = 0; i < _maxChartPoints; i++) {
      _chartData.add(FlSpot(i.toDouble(), -65.0));
    }

    // कॉम्प्युटेशनल इंजिन लूप (30ms)
    _networkTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      // १. सर्व ६ नोड्सना त्यांचे वैयक्तिक करंट इनपुट देऊन अपडेट करणे
      for (int i = 0; i < _neurons.length; i++) {
        _neurons[i].update(_nodeCurrents[i]);
      }

      // २. सिनेप्टिक सिग्नल ट्रान्सफर (Chain Reaction)
      for (var neuron in _neurons) {
        if (neuron.isSpiking) {
          var targets = _synapticConnections[neuron.id] ?? [];
          for (var targetId in targets) {
            _neurons[targetId].synapticInput += 28.0;
          }
        }
      }

      // ३. सिलेक्ट केलेल्या नोडचा लाइव्ह ईईजी (EEG) ग्राफ अपडेट करणे
      setState(() {
        _chartData.removeAt(0);
        for (int i = 0; i < _chartData.length; i++) {
          _chartData[i] = FlSpot(i.toDouble(), _chartData[i].y);
        }
        _chartData.add(
          FlSpot(
            (_maxChartPoints - 1).toDouble(),
            _neurons[_selectedNodeForChart].v,
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _networkTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12131C),
      appBar: AppBar(
        title: const Text("Multi-Current Synaptic Lab"),
        backgroundColor: const Color(0xFF1A1B26),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // विभाग १: सिनेप्टिक नोड्स ग्रिड (क्लिक केल्यावर ग्राफ बदलतो)
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _neurons.length,
                itemBuilder: (context, index) {
                  final neuron = _neurons[index];
                  final isSelectedForGraph = _selectedNodeForChart == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedNodeForChart = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      decoration: BoxDecoration(
                        color: isSelectedForGraph
                            ? const Color(0xFF25283D)
                            : const Color(0xFF1E2030),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: neuron.isSpiking
                              ? Colors.purpleAccent
                              : (isSelectedForGraph
                                    ? Colors.cyanAccent
                                    : Colors.transparent),
                          width: 2,
                        ),
                        boxShadow: neuron.isSpiking
                            ? [
                                BoxShadow(
                                  color: Colors.purpleAccent.withAlpha(180),
                                  blurRadius: 20,
                                  spreadRadius: 6,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withAlpha(100),
                                  offset: const Offset(3, 3),
                                  blurRadius: 8,
                                ),
                              ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bolt,
                            color: neuron.isSpiking
                                ? Colors.amberAccent
                                : Colors.blueGrey,
                            size: neuron.isSpiking ? 30 : 22,
                          ),
                          Text(
                            "N-$index",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: neuron.isSpiking
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            "${neuron.v.toStringAsFixed(0)}mV",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.cyanAccent,
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

          // विभाग २: लाइव्ह ऑसिलोस्कोप ग्राफ (निवडलेल्या नोडचा आलेख)
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1B26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Live Waveform: Node N-$_selectedNodeForChart",
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        minY: -90,
                        maxY: 40,
                        gridData: const FlGridData(
                          show: true,
                          drawVerticalLine: false,
                        ),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _chartData,
                            isCurved: true,
                            barWidth: 2,
                            color: Colors.purpleAccent,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.purpleAccent.withAlpha(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // विभाग ३: वैयक्तिक नोड करंट कंट्रोलर (६ स्लायडर्सची स्क्रोल करण्यायोग्य लिस्ट)
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: const Color(0xFF161722),
              child: ListView.builder(
                itemCount: _neurons.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          "N-$index Current:",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _nodeCurrents[index],
                            min: 0,
                            max: 35,
                            activeColor: Colors.purpleAccent,
                            inactiveColor: Colors.grey.shade900,
                            onChanged: (value) {
                              setState(() {
                                _nodeCurrents[index] = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 45,
                          child: Text(
                            "${_nodeCurrents[index].toStringAsFixed(1)} mA",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontFamily: 'Courier',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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

class StructuredLightApp extends StatelessWidget {
  const StructuredLightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ContourPhaseMappingScreen(),
    );
  }
}

class ContourPhaseMappingScreen extends StatefulWidget {
  const ContourPhaseMappingScreen({super.key});

  @override
  State<ContourPhaseMappingScreen> createState() =>
      _ContourPhaseMappingScreenState();
}

class _ContourPhaseMappingScreenState extends State<ContourPhaseMappingScreen> {
  double _phaseShift = 0.0; // रेडियन्समध्ये फेज शिफ्ट (0 ते 2*Pi)
  double _frequency = 0.05; // फ्रिक्वेन्सी (Fringe density)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Structured Light: Phase Mapping'),

        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          // फेज मॅपिंग सिम्युलेशन एरिया
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: CustomPaint(
                  painter: FringePatternPainter(
                    phase: _phaseShift,
                    frequency: _frequency,
                  ),
                ),
              ),
            ),
          ),
          // कंट्रोल्स (Phase & Frequency Sliders)
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[900],
            child: Column(
              children: [
                Text(
                  'Phase Shift: ${(_phaseShift / math.pi).toStringAsFixed(2)} π',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Slider(
                  value: _phaseShift,
                  min: 0.0,
                  max: 2 * math.pi,
                  onChanged: (value) {
                    setState(() {
                      _phaseShift = value;
                    });
                  },
                ),
                Text(
                  'Fringe Frequency: ${_frequency.toStringAsFixed(3)}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Slider(
                  value: _frequency,
                  min: 0.01,
                  max: 0.2,
                  onChanged: (value) {
                    setState(() {
                      _frequency = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// कस्टम पेंटर - जो रिअल-टाइम लाईट बीम पॅटर्न ड्रॉ करतो
class FringePatternPainter extends CustomPainter {
  final double phase;
  final double frequency;

  FringePatternPainter({required this.phase, required this.frequency});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    // संपूर्ण स्क्रीनवर वर्टिकल लाईन्स (Fringes) ड्रॉ करणे
    for (double x = 0; x < size.width; x += 1.0) {
      // कॉन्टूर इफेक्ट देण्यासाठी मध्यभागी काल्पनिक ३D वस्तू (Sphere/Bump) सिम्युलेट केली आहे
      double centerY = size.height / 2;
      double centerX = size.width / 2;
      double radius = 120.0;

      // प्रत्येक पिक्सेलवर ३D वस्तूमुळे होणारा फेज बदल (Contour Distortion)
      double contourDistortion = 0.0;

      for (double y = 0; y < size.height; y += 4.0) {
        double distance = math.sqrt(
          math.pow(x - centerX, 2) + math.pow(y - centerY, 2),
        );

        if (distance < radius) {
          // ३D गोलाकार वस्तूमुळे प्रकाशाच्या रेषेत होणारा वक्राकार बदल (Phase Modulation)
          contourDistortion =
              math.cos((distance / radius) * (math.pi / 2)) * 15.0;
        } else {
          contourDistortion = 0.0;
        }

        // गणितीय सूत्र: Intensity = I0 * (1 + cos(2 * pi * f * x + phase + distortion))
        double intensity =
            (math.cos((x + contourDistortion) * frequency + phase) + 1.0) / 2.0;

        // मोनोक्रोमॅटिक (स्ट्रक्चर्ड) ग्रे-स्केल किंवा ग्रीन लाईट बीम सेट करणे
        int colorValue = (intensity * 255).toInt();
        paint.color = Color.fromARGB(255, 0, colorValue, 0); // ग्रीन बीम इफेक्ट

        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FringePatternPainter oldDelegate) {
    return oldDelegate.phase != phase || oldDelegate.frequency != frequency;
  }
}

class Stoke extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: StokesCompleteSimulation());
  }
}

class StokesCompleteSimulation extends StatefulWidget {
  const StokesCompleteSimulation({Key? key}) : super(key: key);

  @override
  _StokesCompleteSimulationState createState() =>
      _StokesCompleteSimulationState();
}

class _StokesCompleteSimulationState extends State<StokesCompleteSimulation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // --- कंट्रोलेबल फिजिक्स पॅरामीटर्स (Sliders) ---
  double r = 0.04; // गोलाची त्रिज्या (Radius in meters, range: 0.01 - 0.08)
  double eta = 1.2; // द्रवाची विस्कॉसिटी (Viscosity in Pa·s, range: 0.5 - 3.0)

  // --- स्थिर फिजिक्स पॅरामीटर्स ---
  final double rho = 7800; // गोलाची घनता (Iron: 7800 kg/m³)
  final double sigma = 1260; // द्रवाची घनता (Glycerin: 1260 kg/m³)
  final double g = 9.8; // गुरुत्वाकर्षण (9.8 m/s²)

  // --- सिम्युलेशन स्टेट्स ---
  double yPos = 40.0; // स्क्रीनवरील Y स्थान
  double velocity = 0.0; // सद्य वेग (Current Velocity)
  double terminalVelocity = 0.0;
  double lastTime = 0.0;
  double elapsedTime = 0.0;

  // ग्राफसाठी डेटा पॉईंट्स (Time, Velocity)
  List<Offset> graphData = [];

  @override
  void initState() {
    super.initState();
    _calculateTerminalVelocity();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updatePhysics);

    _controller.repeat();
  }

  void _calculateTerminalVelocity() {
    terminalVelocity = (2 * math.pow(r, 2) * (rho - sigma) * g) / (9 * eta);
  }

  void _updatePhysics() {
    // वेळेतील बदल (Delta Time) मोजणे
    double totalElapsed =
        _controller.value +
        (_controller.status == AnimationStatus.forward ? 0 : 1);
    // साधे सोपे टाइम स्टेपिंग (dt)
    double dt = 0.016; // साधारण ६० FPS साठी स्थिर dt

    elapsedTime += dt;

    // स्टोक्स नियमानुसार प्रवेग (Acceleration) गणना
    double dragAcc =
        (6 * math.pi * eta * r * velocity) /
        ((4 / 3) * math.pi * math.pow(r, 3) * rho);
    double gravityAcc = g * (1 - (sigma / rho));
    double netAcceleration = gravityAcc - dragAcc;

    setState(() {
      // वेग अपडेट करणे
      velocity += netAcceleration * dt;

      // जर वेग टर्मिनल व्हेलाॅसिटीच्या जवळ गेला तर तो स्थिर ठेवणे
      if (velocity > terminalVelocity) velocity = terminalVelocity;

      // स्क्रीन पिक्सेल्ससाठी स्केल करणे (१ मीटर = २०० पिक्सेल)
      double pixelVelocity = velocity * 200;
      yPos += pixelVelocity * dt;

      // ग्राफमध्ये डेटा पॉईंट जोडणे (जास्तीत जास्त १०० पॉईंट्स ठेवणे)
      if (graphData.length > 100) {
        graphData.removeAt(0);
      }
      graphData.add(Offset(elapsedTime, velocity));

      // सिम्युलेशन मर्यादेबाहेर गेल्यास रिसेट करणे
      if (yPos > 400) {
        _resetSimulation();
      }
    });
  }

  void _resetSimulation() {
    yPos = 40.0;
    velocity = 0.0;
    elapsedTime = 0.0;
    graphData.clear();
    _calculateTerminalVelocity();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stokes Law Simulation with Graph')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // १. सिम्युलेशन आणि ग्राफ एरिया (शेजारी शेजारी)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // डावीकडे: लिक्विड ट्यूब सिम्युलेशन
                  Column(
                    children: [
                      const Text(
                        'Fluid Tube',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 420,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.withOpacity(0.25),
                          border: Border.all(color: Colors.blue, width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomPaint(
                          painter: StokesBallPainter(
                            yPos: yPos,
                            radius: r * 350,
                          ), // स्क्रीन स्केलसाठी त्रिज्या वाढवली आहे
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  // उजवीकडे: रियल-टाइम ग्राफ पेंटर
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Velocity vs Time Graph',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: CustomPaint(
                            painter: VelocityGraphPainter(
                              dataPoints: graphData,
                              maxVel: terminalVelocity > 0
                                  ? terminalVelocity * 1.2
                                  : 2.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // रियल-टाइम वाचन (Readings)
                        Text(
                          'Current Velocity: ${velocity.toStringAsFixed(3)} m/s',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Terminal Velocity: ${terminalVelocity.toStringAsFixed(3)} m/s',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _resetSimulation,
                          child: const Text('Reset Physics'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 40, thickness: 1.5),

              // २. स्लाईडर्स कंट्रोल्स (UI Controls)
              const Text(
                'Physics Tuning Controls',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // त्रिज्येचा स्लाईडर (Ball Radius Slider)
              Text('Ball Radius (r): ${r.toStringAsFixed(3)} meters'),
              Slider(
                value: r,
                min: 0.02,
                max: 0.07,
                divisions: 5,
                label: '${r.toStringAsFixed(3)} m',
                onChanged: (val) {
                  setState(() {
                    r = val;
                    _resetSimulation();
                  });
                },
              ),

              // विस्कॉसिटीचा स्लाईडर (Liquid Viscosity Slider)
              Text('Liquid Viscosity (η): ${eta.toStringAsFixed(2)} Pa·s'),
              Slider(
                value: eta,
                min: 0.5,
                max: 3.0,
                divisions: 5,
                label: '${eta.toStringAsFixed(2)} Pa·s',
                onChanged: (val) {
                  setState(() {
                    eta = val;
                    _resetSimulation();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- बॉल ड्रॉ करण्यासाठी पेंटर ---
class StokesBallPainter extends CustomPainter {
  final double yPos;
  final double radius;
  StokesBallPainter({required this.yPos, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;

    // मर्यादेत चेंडू ठेवणे
    double constrainedY = yPos.clamp(radius, size.height - radius);
    canvas.drawCircle(
      Offset(size.width / 2, constrainedY),
      radius.clamp(8, 25),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant StokesBallPainter oldDelegate) {
    return oldDelegate.yPos != yPos || oldDelegate.radius != radius;
  }
}

// --- ग्राफ ड्रॉ करण्यासाठी कस्टम पेंटer ---
class VelocityGraphPainter extends CustomPainter {
  final List<Offset> dataPoints;
  final double maxVel;

  VelocityGraphPainter({required this.dataPoints, required this.maxVel});

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final graphPaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // १. अक्ष (X आणि Y Axis) तयार करणे
    // Y-Axis
    canvas.drawLine(Offset(30, 10), Offset(30, size.height - 20), axisPaint);
    // X-Axis
    canvas.drawLine(
      Offset(30, size.height - 20),
      Offset(size.width - 10, size.height - 20),
      axisPaint,
    );

    if (dataPoints.isEmpty) return;

    // २. डेटा पॉईंट्स मॅप करून ग्राफची लाईन तयार करणे
    final path = Path();
    double maxTime = dataPoints.last.dx > 4.0 ? dataPoints.last.dx : 4.0;

    for (int i = 0; i < dataPoints.length; i++) {
      // वेळ X अक्षावर मॅप करणे
      double x = 30 + ((dataPoints[i].dx / maxTime) * (size.width - 40));
      // वेग Y अक्षावर मॅप करणे (खालील बाजूने वर जाण्यासाठी वजाबाकी)
      double y =
          (size.height - 20) -
          ((dataPoints[i].dy / maxVel) * (size.height - 30));

      // कॅनव्हासच्या सीमारेषा ओलांडणार नाही याची काळजी घेणे
      x = x.clamp(30, size.width - 10);
      y = y.clamp(10, size.height - 20);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, graphPaint);
  }

  @override
  bool shouldRepaint(covariant VelocityGraphPainter oldDelegate) {
    return true;
    // set to true since the data is constantly changing
  }
}

class UltimateQuantumSteeringLab extends StatefulWidget {
  const UltimateQuantumSteeringLab({super.key});

  @override
  State<UltimateQuantumSteeringLab> createState() =>
      _UltimateQuantumSteeringLabState();
}

class _UltimateQuantumSteeringLabState
    extends State<UltimateQuantumSteeringLab> {
  // 3D Camera Angles via Drag Gestures
  double _angleX = 0.35;
  double _angleY = 0.60;

  // Quantum Mechanics System Parameters
  double _purity = 0.85;
  double _asymmetry = 0.15;
  int _measurementSettings = 3; // N=2 vs N=3 Settings

  // Environmental Decoherence Noise Parameters
  double _amplitudeDamping = 0.0; // t parameter (0 = No Noise, 1 = Max Damping)
  double _phaseDephasing =
      0.0; // gamma parameter (0 = No Noise, 1 = Max Dephasing)

  // Alice Live Spherical Polar Coordinates
  double _aliceTheta = 1.0;
  double _alicePhi = 0.5;

  @override
  Widget build(BuildContext context) {
    // 1. Environmental Noise Channel Transformations
    // Amplitude Damping forces state populations toward the ground state |1⟩ (shifts Z axis offset)
    // Phase Dephasing dampens the off-diagonal coherence elements (shrinks X and Y axes)
    double effectivePurityX =
        _purity * (1.0 - _phaseDephasing) * math.sqrt(1.0 - _amplitudeDamping);
    double effectivePurityY =
        _purity * (1.0 - _phaseDephasing) * math.sqrt(1.0 - _amplitudeDamping);
    double effectivePurityZ =
        (_purity - _asymmetry) * (1.0 - _amplitudeDamping);

    // 2. Compute Cavalcanti Steering Bounds Criteria
    final double lhsThreshold = _measurementSettings == 3
        ? 1.0 / math.sqrt(3)
        : 0.5;

    // Evaluate steering ability inside the noisy, deformed quantum channel state
    final bool aliceCanSteerBob =
        effectivePurityX > lhsThreshold || effectivePurityZ > lhsThreshold;
    final bool bobCanSteerAlice =
        (effectivePurityX * (1.0 - _asymmetry)) > lhsThreshold;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text(
          'Quantum Steering & Decoherence Lab',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTopRegimeBanner(aliceCanSteerBob, bobCanSteerAlice),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _angleY += details.delta.dx * 0.01;
                  _angleX -= details.delta.dy * 0.01;
                });
              },
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: AdvancedLabPainter(
                    angleX: _angleX,
                    angleY: _angleY,
                    purityX: effectivePurityX,
                    purityY: effectivePurityY,
                    purityZ: effectivePurityZ,
                    aliceTheta: _aliceTheta,
                    alicePhi: _alicePhi,
                    aliceCanSteerBob: aliceCanSteerBob,
                    settingsCount: _measurementSettings,
                    dampingOffset:
                        _amplitudeDamping * -30.0, // Visual shift down
                  ),
                ),
              ),
            ),
          ),
          _buildLiveDataTable(effectivePurityX, effectivePurityZ, lhsThreshold),
          _buildControlDeck(),
        ],
      ),
    );
  }

  Widget _buildTopRegimeBanner(bool aToB, bool bToA) {
    Color bannerColor = Colors.redAccent;
    String bannerText = 'CLASSICAL REGIME: NO STEERING POSSIBLE';

    if (aToB && !bToA) {
      bannerColor = Colors.amberAccent;
      bannerText = 'ONE-WAY ASYMMETRIC QUANTUM STEERING';
    } else if (aToB && bToA) {
      bannerColor = Colors.greenAccent;
      bannerText = 'TWO-WAY SYMMETRIC QUANTUM STEERING';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFF1F242C),
      child: Center(
        child: Text(
          bannerText,
          style: TextStyle(
            color: bannerColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildLiveDataTable(double pX, double pZ, double threshold) {
    return Container(
      color: const Color(0xFF161B22),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Table(
        border: TableBorder.all(
          color: Colors.white10,
          width: 1,
          borderRadius: BorderRadius.circular(4),
        ),
        children: [
          TableRow(
            children:
                [
                      'Channel Vector',
                      'Effective Matrix Value',
                      'LHS Bound',
                      'Status',
                    ]
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          e,
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
          ),
          _buildDataRow(
            'Alice ➔ Bob (X Axis)',
            pX.toStringAsFixed(3),
            threshold.toStringAsFixed(3),
            pX > threshold ? 'STEERABLE' : 'BLOCKED',
            pX > threshold,
          ),
          _buildDataRow(
            'Alice ➔ Bob (Z Axis)',
            pZ.toStringAsFixed(3),
            threshold.toStringAsFixed(3),
            pZ > threshold ? 'STEERABLE' : 'BLOCKED',
            pZ > threshold,
          ),
        ],
      ),
    );
  }

  TableRow _buildDataRow(
    String label,
    String val,
    String bound,
    String status,
    bool pass,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 9),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            val,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 9,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            bound,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            status,
            style: TextStyle(
              color: pass ? Colors.greenAccent : Colors.redAccent,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildControlDeck() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: const Color(0xFF161B22),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Settings Selector:',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                DropdownButton<int>(
                  value: _measurementSettings,
                  dropdownColor: const Color(0xFF161B22),
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 11,
                  ),
                  isDense: true,
                  items: const [
                    DropdownMenuItem(
                      value: 2,
                      child: Text('N = 2 (X, Z Measurement Settings)'),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text('N = 3 (X, Y, Z Mutually Unbiased Basis)'),
                    ),
                  ],
                  onChanged: (val) =>
                      setState(() => _measurementSettings = val!),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _sliderControl(
              'Purity Parameter (p)',
              _purity,
              (val) => setState(() => _purity = val),
            ),
            _sliderControl(
              'Asymmetry Delta (Δ)',
              _asymmetry,
              (val) => setState(() => _asymmetry = val),
            ),
            _sliderControl(
              'Amplitude Damping (t)',
              _amplitudeDamping,
              (val) => setState(() => _amplitudeDamping = val),
              activeColor: Colors.orangeAccent,
            ),
            _sliderControl(
              'Phase Dephasing (γ)',
              _phaseDephasing,
              (val) => setState(() => _phaseDephasing = val),
              activeColor: Colors.pinkAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderControl(
    String label,
    double val,
    ValueChanged<double> change, {
    Color activeColor = Colors.deepPurpleAccent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ),
          Expanded(
            flex: 6,
            child: Slider(
              value: val,
              min: 0.0,
              max: 1.0,
              activeColor: activeColor,
              inactiveColor: Colors.white10,
              onChanged: change,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              val.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 10,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class AdvancedLabPainter extends CustomPainter {
  final double angleX;
  final double angleY;
  final double purityX;
  final double purityY;
  final double purityZ;
  final double aliceTheta;
  final double alicePhi;
  final bool aliceCanSteerBob;
  final int settingsCount;
  final double
  dampingOffset; // Shifts center of the ellipsoid downward physically

  AdvancedLabPainter({
    required this.angleX,
    required this.angleY,
    required this.purityX,
    required this.purityY,
    required this.purityZ,
    required this.aliceTheta,
    required this.alicePhi,
    required this.aliceCanSteerBob,
    required this.settingsCount,
    required this.dampingOffset,
  });

  Offset project(double x, double y, double z, Size size) {
    double cx = size.width / 2;
    double cy = size.height / 2;

    // Apply 3D Matrix Rotations
    double cosY = math.cos(angleY);
    double sinY = math.sin(angleY);
    double xRot = x * cosY - z * sinY;
    double zRot1 = x * sinY + z * cosY;

    double cosX = math.cos(angleX);
    double sinX = math.sin(angleX);
    double yRot = y * cosX - zRot1 * sinX;
    double scale = 110.0;
    return Offset(cx + xRot * scale, cy - yRot * scale);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // 1. Draw Absolute Pure Bloch Limit Boundary
    canvas.drawCircle(
      center,
      110.0,
      Paint()
        ..color = Colors.white.withOpacity(0.02)
        ..style = PaintingStyle.stroke,
    );
    // 2. Draw Quantum Coordinate Reference Framing Axis Lines
    final axisPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1.0;
    canvas.drawLine(
      project(-1.1, 0, 0, size),
      project(1.1, 0, 0, size),
      axisPaint,
    );
    canvas.drawLine(
      project(0, -1.1, 0, size),
      project(0, 1.1, 0, size),
      axisPaint,
    );
    canvas.drawLine(
      project(0, 0, -1.1, size),
      project(0, 0, 1.1, size),
      axisPaint,
    );
    // 3. Render Shrunken Asymmetric, Decohered Volume Envelope
    final volumePaint = Paint()
      ..color = aliceCanSteerBob
          ? Colors.greenAccent.withOpacity(0.12)
          : Colors.redAccent.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    final wireframePaint = Paint()
      ..color = aliceCanSteerBob
          ? Colors.greenAccent.withOpacity(0.35)
          : Colors.redAccent.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    // Equator Trace Ring Profile Configuration
    final Path equator = Path();
    for (int i = 0; i <= 360; i += 10) {
      double r = i * math.pi / 180;
      // Convert angular projections to Cartesian space, then apply the visual dampingOffset
      Offset p = project(
        math.cos(r) * purityX,
        math.sin(r) * purityY,
        0.0 + (dampingOffset / 110.0),
        size,
      );
      if (i == 0)
        equator.moveTo(p.dx, p.dy);
      else
        equator.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(equator, volumePaint);
    canvas.drawPath(equator, wireframePaint);
    // Longitudinal Trace Ring Profile Configuration
    final Path longitudinal = Path();
    for (int i = 0; i <= 360; i += 10) {
      double r = i * math.pi / 180;
      Offset p = project(
        0.0,
        math.cos(r) * purityY,
        math.sin(r) * purityZ + (dampingOffset / 110.0),
        size,
      );
      if (i == 0)
        longitudinal.moveTo(p.dx, p.dy);
      else
        longitudinal.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(longitudinal, wireframePaint);
    // 4. Transform and Draw Active Selected Projective Measurement Vectors
    double ax = math.sin(aliceTheta) * math.cos(alicePhi);
    double ay = settingsCount == 3
        ? math.sin(aliceTheta) * math.sin(alicePhi)
        : 0.0;
    double az = math.cos(aliceTheta);
    // Bob collapses asymmetric values to the opposite poles adjusted by decoherence matrix parameters
    double bx = -ax * purityX;
    double by = -ay * purityY;
    double bz = (-az * purityZ) + (dampingOffset / 110.0);
    Offset alicePt = project(ax, ay, az, size);
    Offset bobPt = project(bx, by, bz, size); // Render Vector Pointer Lines
    canvas.drawLine(
      center,
      alicePt,
      Paint()
        ..color = Colors.deepPurpleAccent
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      center,
      bobPt,
      Paint()
        ..color = aliceCanSteerBob ? Colors.greenAccent : Colors.orangeAccent
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(alicePt, 4, Paint()..color = Colors.deepPurpleAccent);
    canvas.drawCircle(
      bobPt,
      4,
      Paint()
        ..color = aliceCanSteerBob ? Colors.greenAccent : Colors.orangeAccent,
    );
  }

  @override
  bool shouldRepaint(covariant AdvancedLabPainter oldDelegate) => true;
}

class ColdAtomLabSuite extends StatelessWidget {
  const ColdAtomLabSuite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ColdAtomLabPage(),
    );
  }
}

class ColdAtomLabPage extends StatefulWidget {
  const ColdAtomLabPage({super.key});

  @override
  State<ColdAtomLabPage> createState() => _ColdAtomLabPageState();
}

class _ColdAtomLabPageState extends State<ColdAtomLabPage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _lastTime = 0.0;

  // Controls & Parameters
  double _rabiFrequency = 4.0;
  double _detuning = 0.0;
  double _blockadeRadius = 1.5; // Measured in units of grid lattice spacing

  // State Engine: 4x4 Grid Matrix [Real c0, Imag c0, Real c1, Imag c1]
  late List<List<List<double>>> _wavefunctions;
  final List<double> _history = [];
  final int _maxHistory = 60;

  // JSON Log Telemetry Data
  String _latestJsonLog = '{}';
  double _logTimer = 0.0;

  @override
  void initState() {
    super.initState();
    _resetLab();
    _ticker = createTicker((elapsed) {
      double currentTime = elapsed.inMicroseconds / 1000000.0;
      double dt = currentTime - _lastTime;
      if (dt > 0.05) dt = 0.05;
      _lastTime = currentTime;

      setState(() {
        _evolveSystem(dt);
        _generateTelemetry(dt);
      });
    });
    _ticker.start();
  }

  void _resetLab() {
    _wavefunctions = List.generate(
      4,
      (_) => List.generate(4, (_) => [1.0, 0.0, 0.0, 0.0]),
    );
    _history.clear();
    _latestJsonLog =
        '{"status": "System initialized. Waiting for evolution..."}';
  }

  void _evolveSystem(double dt) {
    if (dt <= 0) return;
    double continuousSum = 0.0;

    // Create a temporary cache mapping of the *current* Rydberg state probabilities
    // used to calculate the spatial blockade interaction shift down-stream.
    List<List<double>> currentP1 = List.generate(
      4,
      (r) => List.generate(
        4,
        (c) =>
            _wavefunctions[r][c][2] * _wavefunctions[r][c][2] +
            _wavefunctions[r][c][3] * _wavefunctions[r][c][3],
      ),
    );

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        var state = _wavefunctions[r][c];
        double c0r = state[0], c0i = state[1], c1r = state[2], c1i = state[3];

        // Compute Rydberg Blockade Shift (V_ij) based on surrounding excited density
        double blockadeShift = 0.0;
        for (int or = 0; or < 4; or++) {
          for (int oc = 0; oc < 4; oc++) {
            if (or == r && oc == c) continue;
            double dist = math.sqrt(math.pow(r - or, 2) + math.pow(c - oc, 2));
            if (dist <= _blockadeRadius && dist > 0) {
              // Standard Van der Waals scaling factor simulation: C6 / R^6
              blockadeShift += currentP1[or][oc] * (5.0 / math.pow(dist, 6));
            }
          }
        }

        // Total effective detuning incorporating local multi-atom interaction blocks
        double effectiveDetuning = _detuning - blockadeShift;

        // Differential equations solving: i h-bar dψ/dt = Hψ
        double dc0r = -(_rabiFrequency / 2.0) * c1i;
        double dc0i = (_rabiFrequency / 2.0) * c1r;
        double dc1r = -(_rabiFrequency / 2.0) * c0i + effectiveDetuning * c1i;
        double dc1i = (_rabiFrequency / 2.0) * c0r - effectiveDetuning * c1r;

        c0r += dc0r * dt;
        c0i += dc0i * dt;
        c1r += dc1r * dt;
        c1i += dc1i * dt;

        double norm = math.sqrt(c0r * c0r + c0i * c0i + c1r * c1r + c1i * c1i);
        if (norm > 0) {
          c0r /= norm;
          c0i /= norm;
          c1r /= norm;
          c1i /= norm;
        }

        _wavefunctions[r][c] = [c0r, c0i, c1r, c1i];
        continuousSum += (c1r * c1r + c1i * c1i);
      }
    }

    double globalRatio = continuousSum / 16.0;
    _history.add(globalRatio);
    if (_history.length > _maxHistory) _history.removeAt(0);
  }

  void _generateTelemetry(double dt) {
    _logTimer += dt;
    if (_logTimer < 0.4) return; // Throttled updates for performance stability
    _logTimer = 0.0;

    List<Map<String, dynamic>> atomLogs = [];
    double totalP1 = 0.0;

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        double p1 =
            _wavefunctions[r][c][2] * _wavefunctions[r][c][2] +
            _wavefunctions[r][c][3] * _wavefunctions[r][c][3];
        totalP1 += p1;
        if (p1 > 0.05) {
          atomLogs.add({
            "coord": "[$r,$c]",
            "rydberg_prob": double.parse(p1.toStringAsFixed(3)),
          });
        }
      }
    }

    Map<String, dynamic> telemetry = {
      "timestamp_sec": double.parse(_lastTime.toStringAsFixed(2)),
      "parameters": {
        "rabi_omega": double.parse(_rabiFrequency.toStringAsFixed(2)),
        "detuning_delta": double.parse(_detuning.toStringAsFixed(2)),
        "blockade_rc": double.parse(_blockadeRadius.toStringAsFixed(2)),
      },
      "system_metrics": {
        "global_excitation_fraction": double.parse(
          (totalP1 / 16.0).toStringAsFixed(4),
        ),
        "active_excited_nodes": atomLogs,
      },
    };

    _latestJsonLog = const JsonEncoder.withIndent('  ').convert(telemetry);
  }

  void _triggerPulse(Offset localPos, Size widgetSize) {
    int col = (localPos.dx / (widgetSize.width / 4)).clamp(0, 3).toInt();
    int row = (localPos.dy / (widgetSize.height / 4)).clamp(0, 3).toInt();

    setState(() {
      // Coherently drive target localized atom vector to excited space
      _wavefunctions[row][col] = [0.0, 0.0, 1.0, 0.0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    Widget coreLatticePanel = Card(
      color: const Color(0xFF0B0B1E),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size =
              math.min(constraints.maxWidth, constraints.maxHeight) * 0.92;
          return Center(
            child: SizedBox(
              width: size,
              height: size,
              child: GestureDetector(
                onTapDown: (d) =>
                    _triggerPulse(d.localPosition, Size(size, size)),
                child: CustomPaint(
                  painter: PhysicsLatticePainter(
                    states: _wavefunctions,
                    blockadeRadius: _blockadeRadius,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    Widget controlTelemetryPanel = Column(
      children: [
        // Sliders Group
        Card(
          color: const Color(0xFF0B0B1E),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                _buildSliderRow(
                  'Rabi (Ω)',
                  _rabiFrequency,
                  0,
                  10,
                  Colors.orangeAccent,
                  (v) => setState(() => _rabiFrequency = v),
                ),
                _buildSliderRow(
                  'Detuning (Δ)',
                  _detuning,
                  -5,
                  5,
                  Colors.cyanAccent,
                  (v) => setState(() => _detuning = v),
                ),
                _buildSliderRow(
                  'Blockade (Rc)',
                  _blockadeRadius,
                  0.5,
                  3.0,
                  Colors.redAccent,
                  (v) => setState(() => _blockadeRadius = v),
                ),
              ],
            ),
          ),
        ),
        // Live Output Display Frame
        Expanded(
          child: Card(
            color: const Color(0xFF04040D),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Telemetry Stream (JSON)',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.tealAccent,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onPressed: () => Clipboard.setData(
                          ClipboardData(text: _latestJsonLog),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _latestJsonLog,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rydberg Blockade Laboratory'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _resetLab),
        ],
      ),
      backgroundColor: const Color(0xFF03030A),
      body: isLandscape
          ? Row(
              children: [
                Expanded(flex: 4, child: coreLatticePanel),
                Expanded(flex: 3, child: controlTelemetryPanel),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 4, child: coreLatticePanel),
                Expanded(flex: 4, child: controlTelemetryPanel),
              ],
            ),
    );
  }

  Widget _buildSliderRow(
    String label,
    double val,
    double min,
    double max,
    Color color,
    ValueChanged<double> cb,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 95,
          child: Text(
            '$label: ${val.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 11),
          ),
        ),
        Expanded(
          child: Slider(
            value: val,
            min: min,
            max: max,
            activeColor: color,
            onChanged: cb,
          ),
        ),
      ],
    );
  }
}

class PhysicsLatticePainter extends CustomPainter {
  final List<List<List<double>>> states;
  final double blockadeRadius;
  PhysicsLatticePainter({required this.states, required this.blockadeRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final double step = size.width / 4;

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        double x = (c + 0.5) * step;
        double y = (r + 0.5) * step;
        Offset center = Offset(x, y);
        double p1 =
            states[r][c][2] * states[r][c][2] +
            states[r][c][3] *
                states[r][c][3]; // Draw Blockade Boundary Ring around atoms containing population density shifts
        if (p1 > 0.1) {
          final Paint blockadeRing = Paint()
            ..color = Colors.redAccent.withOpacity(0.08 * p1)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(center, step * blockadeRadius, blockadeRing);
          final Paint blockadeBorder = Paint()
            ..color = Colors.redAccent.withOpacity(0.2 * p1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;
          canvas.drawCircle(center, step * blockadeRadius, blockadeBorder);
        }
        // Base Trap Well Gradient Graphic
        final Paint trap = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.blue.withOpacity(0.35 * (1.0 - p1)),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: step * 0.4));
        canvas.drawCircle(
          center,
          step * 0.4,
          trap,
        ); // Core Quantum Structural Cloud Particle Mapping
        final Paint atomCore = Paint()
          ..color = Color.lerp(Colors.cyan, Colors.deepOrange, p1)!;
        canvas.drawCircle(center, 4.0 + (3.5 * p1), atomCore);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PhysicsLatticePainter oldDelegate) => true;
}

class Myoam extends StatelessWidget {
  const Myoam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const OamLaserSimulator(),
    );
  }
}

class OamLaserSimulator extends StatefulWidget {
  const OamLaserSimulator({Key? key}) : super(key: key);

  @override
  State<OamLaserSimulator> createState() => _OamLaserSimulatorState();
}

class _OamLaserSimulatorState extends State<OamLaserSimulator> {
  // Simulation parameters
  double l1 = 6; // Azimuthal order / Topological charge of Ring 1
  double l2 = 5; // Azimuthal order / Topological charge of Ring 2
  double theta1 = 0; // Orientation angle of Ring 1 (degrees)
  double theta2 = 0; // Orientation angle of Ring 2 (degrees)
  double alpha = 45; // Coupling alignment angle (degrees)
  double couplingStrength = 0.3; // Coupling strength factor (0.0 to 1.0)
  bool showPhase = false; // Toggle between Intensity Profile and Phase Map

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupled OAM Micro-laser Simulator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Interactive Canvas
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: LaserOamPainter(
                    l1: l1.toInt(),
                    l2: l2.toInt(),
                    theta1: theta1 * math.pi / 180,
                    theta2: theta2 * math.pi / 180,
                    alpha: alpha * math.pi / 180,
                    couplingStrength: couplingStrength,
                    showPhase: showPhase,
                  ),
                ),
              ),
            ),
          ),

          // Mode Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Visualization Mode:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text("Intensity")),
                    ButtonSegment(value: true, label: Text("Phase")),
                  ],
                  selected: {showPhase},
                  onSelectionChanged: (set) =>
                      setState(() => showPhase = set.first),
                ),
              ],
            ),
          ),

          const Divider(height: 16),

          // Control Dashboard
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildSliderRow(
                    label: "Coupling Strength (κ)",
                    value: couplingStrength,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    isDecimal: true,
                    activeColor: Colors.cyanAccent,
                    onChanged: (val) => setState(() => couplingStrength = val),
                  ),
                  _buildSliderRow(
                    label: "Azimuthal Order l₁ (Ring 1)",
                    value: l1,
                    min: 2,
                    max: 12,
                    divisions: 10,
                    onChanged: (val) => setState(() => l1 = val),
                  ),
                  _buildSliderRow(
                    label: "Azimuthal Order l₂ (Ring 2)",
                    value: l2,
                    min: 2,
                    max: 12,
                    divisions: 10,
                    onChanged: (val) => setState(() => l2 = val),
                  ),
                  _buildSliderRow(
                    label: "Long-axis Direction θ₁ (°)",
                    value: theta1,
                    min: 0,
                    max: 360,
                    divisions: 360,
                    onChanged: (val) => setState(() => theta1 = val),
                  ),
                  _buildSliderRow(
                    label: "Long-axis Direction θ₂ (°)",
                    value: theta2,
                    min: 0,
                    max: 360,
                    divisions: 360,
                    onChanged: (val) => setState(() => theta2 = val),
                  ),
                  _buildSliderRow(
                    label: "Coupling Direction α (°)",
                    value: alpha,
                    min: 0,
                    max: 360,
                    divisions: 360,
                    onChanged: (val) => setState(() => alpha = val),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    bool isDecimal = false,
    Color activeColor = Colors.amber,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
            Text(
              isDecimal ? value.toStringAsFixed(2) : value.toStringAsFixed(0),
              style: TextStyle(fontWeight: FontWeight.bold, color: activeColor),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: activeColor,
          inactiveColor: Colors.grey.shade700,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class LaserOamPainter extends CustomPainter {
  final int l1;
  final int l2;
  final double theta1;
  final double theta2;
  final double alpha;
  final double couplingStrength;
  final bool showPhase;

  LaserOamPainter({
    required this.l1,
    required this.l2,
    required this.theta1,
    required this.theta2,
    required this.alpha,
    required this.couplingStrength,
    required this.showPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final double r1 = math.min(size.width, size.height) * 0.16;
    final double r2 = r1 * 0.85;

    // Stronger coupling physically decreases cavity center separation distance
    final double baseSeparation = r1 + r2;
    final double separation = baseSeparation - (couplingStrength * 25);

    final offset1 = Offset(
      -math.cos(alpha) * (separation / 2),
      -math.sin(alpha) * (separation / 2),
    );
    final offset2 = Offset(
      math.cos(alpha) * (separation / 2),
      math.sin(alpha) * (separation / 2),
    );

    final center1 = center + offset1;
    final center2 = center + offset2;

    if (showPhase) {
      _drawPhaseFringes(canvas, size, center1, center2, r1, r2);
    } else {
      // Draw Intensity Profiles with simulated junction mode-coupling effects
      _drawIntensityRing(
        canvas,
        center1,
        r1,
        l1,
        theta1,
        Colors.orangeAccent,
        center2,
        r2,
      );
      _drawIntensityRing(
        canvas,
        center2,
        r2,
        l2,
        theta2,
        Colors.redAccent,
        center1,
        r1,
      );

      _drawReferenceLines(canvas, center1, center2);
    }
  }

  void _drawIntensityRing(
    Canvas canvas,
    Offset center,
    double radius,
    int order,
    double rotation,
    Color color,
    Offset coupledCenter,
    double coupledRadius,
  ) {
    final boundaryPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, boundaryPaint);

    final int totalSpots = order * 2;
    final double angularStep = (2 * math.pi) / totalSpots;

    for (int i = 0; i < totalSpots; i++) {
      double angle = rotation + (i * angularStep);
      Offset spotPos =
          center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);

      // Check distance to the neighboring cavity center to calculate local coupling factor
      double distanceToCoupledCavity = (spotPos - coupledCenter).distance;
      double proximityToJunction = math.max(
        0,
        1 - (distanceToCoupledCavity / (coupledRadius * 1.5)),
      );

      // Stronger coupling scales spot intensity and introduces spatial interference distortions near the junction
      double intensityBoost =
          1.0 + (couplingStrength * proximityToJunction * 1.5);
      double dynamicSize = 7.0 + (couplingStrength * proximityToJunction * 5.0);

      final glowPaint = Paint()
        ..color = color.withOpacity(math.min(1.0, 0.8 * intensityBoost))
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          4 + (couplingStrength * proximityToJunction * 4),
        );
      canvas.drawCircle(spotPos, dynamicSize, glowPaint);

      final corePaint = Paint()
        ..color = Colors.white.withOpacity(
          math.min(1.0, 0.5 + (intensityBoost * 0.2)),
        );
      canvas.drawCircle(spotPos, 2.5, corePaint);
    }
  }

  void _drawPhaseFringes(
    Canvas canvas,
    Size size,
    Offset c1,
    Offset c2,
    double r1,
    double r2,
  ) {
    final paint = Paint();
    final double step = 3.5;

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        double dx1 = x - c1.dx;
        double dy1 = y - c1.dy;
        double dist1 = math.sqrt(dx1 * dx1 + dy1 * dy1);
        double phi1 = math.atan2(dy1, dx1);
        double dx2 = x - c2.dx;
        double dy2 = y - c2.dy;
        double dist2 = math.sqrt(dx2 * dx2 + dy2 * dy2);
        double phi2 = math.atan2(dy2, dx2);
        double phase1 = (l1 * phi1 + theta1) % (2 * math.pi);
        double phase2 = (l2 * phi2 + theta2) % (2 * math.pi);
        // As coupling strength increases, field interaction extends radially outwards
        double interactionRange = 300 + (couplingStrength * 200);
        double w1 = math.exp(-math.pow(dist1 - r1, 2) / interactionRange);
        double w2 = math.exp(-math.pow(dist2 - r2, 2) / interactionRange);
        // Superimpose fields
        double complexReal = w1 * math.cos(phase1) + w2 * math.cos(phase2);
        double complexImag = w1 * math.sin(phase1) + w2 * math.sin(phase2);
        double totalPhase = math.atan2(complexImag, complexReal);
        double normalized = (totalPhase + math.pi) / (2 * math.pi);
        paint.color = Color.lerp(
          Colors.purple.shade900,
          Colors.deepOrangeAccent,
          normalized,
        )!;
        canvas.drawRect(Rect.fromLTWH(x, y, step, step), paint);
      }
    }
  }

  void _drawReferenceLines(Canvas canvas, Offset c1, Offset c2) {
    final linePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(c1, c2, linePaint);
  }

  @override
  bool shouldRepaint(covariant LaserOamPainter oldDelegate) {
    return oldDelegate.l1 != l1 ||
        oldDelegate.l2 != l2 ||
        oldDelegate.theta1 != theta1 ||
        oldDelegate.theta2 != theta2 ||
        oldDelegate.alpha != alpha ||
        oldDelegate.couplingStrength != couplingStrength ||
        oldDelegate.showPhase != showPhase;
  }
}

//https://www.spiedigitallibrary.org/journals/advanced-photonics-nexus/volume-5/issue-05/056001/Coupled-orbital-angular-momentum-modes-for-an-ultra-high-dimensional/10.1117/1.APN.5.5.056001.full
