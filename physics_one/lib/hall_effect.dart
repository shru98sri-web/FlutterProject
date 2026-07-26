import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ModernHallLab()));

// Blueprint to handle unique semiconductor physics properties
class SemiconductorMaterial {
  final String name;
  final double carrierDensityN; // m^-3
  final Color themeColor;

  const SemiconductorMaterial({
    required this.name,
    required this.carrierDensityN,
    required this.themeColor,
  });
}

class ModernHallLab extends StatefulWidget {
  const ModernHallLab({Key? key}) : super(key: key);

  @override
  State<ModernHallLab> createState() => _ModernHallLabState();
}

class _ModernHallLabState extends State<ModernHallLab> {
  // Graph plotting states
  List<FlSpot> graphPoints = [];
  double elapsedSeconds = 0;
  Timer? _physicsTimer;
  final int maxSavedPoints = 40;

  // --- INTERACTIVE SLIDERS (Default Lab Settings) ---
  double inputCurrentMA = 5.0; // Supply current (mA)
  double magnetStrengthTesla = 1.2; // Peak magnet strength (T)
  double distanceZmm = 5.0; // Distance away from sensor face (mm)
  bool isOscillating = true; // Toggle dynamic physical movement

  // --- MATERIAL DEFINITIONS ---
  static const List<SemiconductorMaterial> materials = [
    SemiconductorMaterial(
      name: 'Silicon (Si)',
      carrierDensityN: 1.5e21,
      themeColor: Colors.cyanAccent,
    ),
    SemiconductorMaterial(
      name: 'Gallium Arsenide (GaAs)',
      carrierDensityN: 1.0e20,
      themeColor: Colors.amberAccent,
    ),
    SemiconductorMaterial(
      name: 'Indium Antimonide (InSb)',
      carrierDensityN: 2.0e16,
      themeColor: Colors.deepOrangeAccent,
    ),
  ];
  SemiconductorMaterial selectedMaterial = materials[0];

  // --- HARDWARE FIXTURE CONSTANTS ---
  final double thicknessD = 1e-6; // 1 micrometer chip thickness
  final double chargeQ = 1.602e-19; // Elementary charge (C)
  final double magnetRadiusR = 0.005; // 5mm geometry

  @override
  void initState() {
    super.initState();
    _startSimulationLoop();
  }

  void _startSimulationLoop() {
    _physicsTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      _computeFrame();
    });
  }

  void _computeFrame() {
    if (!mounted) return;

    setState(() {
      elapsedSeconds += 0.15;

      // Handle structural physics math
      double liveZ = isOscillating
          ? (distanceZmm / 1000.0) + 0.008 * sin(elapsedSeconds * 2.5)
          : (distanceZmm / 1000.0);

      // Clamp distance to avoid absolute zero division
      if (liveZ < 0.0005) liveZ = 0.0005;

      // 1. Core Biot-Savart axis mapping
      double coreFieldB =
          0.5 *
          magnetStrengthTesla *
          ((liveZ + 0.01) / sqrt(pow(magnetRadiusR, 2) + pow(liveZ + 0.01, 2)) -
              liveZ / sqrt(pow(magnetRadiusR, 2) + pow(liveZ, 2)));

      // 2. Structural conversion into Hall Voltage Output
      double currentAmps = inputCurrentMA / 1000.0;
      double hallCoefficientRh =
          1.0 / (selectedMaterial.carrierDensityN * chargeQ);
      double rawVoltage =
          (currentAmps * coreFieldB * hallCoefficientRh) / thicknessD;

      graphPoints.add(FlSpot(elapsedSeconds, rawVoltage));

      if (graphPoints.length > maxSavedPoints) {
        graphPoints.removeAt(0);
      }
    });
  }

  @override
  void dispose() {
    _physicsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double minX = graphPoints.isEmpty ? 0 : graphPoints.first.x;
    double maxX = graphPoints.isEmpty ? 6 : max(elapsedSeconds, 6.0);

    // Dynamic clean rendering parameters derived directly from current sample data
    double latestVoltage = graphPoints.isEmpty ? 0.0 : graphPoints.last.y;
    double highestFrameValue = graphPoints.isEmpty
        ? 0.1
        : graphPoints.map((s) => s.y).reduce(max);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E15),
      appBar: AppBar(
        title: const Text(
          'Quantum Hall Laboratory',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.lightGreenAccent,
          ),
        ),
        backgroundColor: const Color(0xFF161622),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildControlPanel(),
                  const SizedBox(height: 16),
                  _buildVisualizerMetrics(latestVoltage),
                  const SizedBox(height: 24),
                  _buildChartWorkspace(minX, maxX, highestFrameValue),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      color: const Color(0xFF161622),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PHYSICAL ELEMENT MATRIX',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Element Dropdown Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SemiconductorMaterial>(
                  value: selectedMaterial,
                  dropdownColor: const Color(0xFF161622),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.purple, fontSize: 15),
                  items: materials
                      .map(
                        (m) => DropdownMenuItem(value: m, child: Text(m.name)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedMaterial = val;
                        graphPoints
                            .clear(); // Flush frame log for structural clean scaling
                      });
                    }
                  },
                ),
              ),
            ),
            const Divider(color: Colors.white12, height: 24),

            // Dynamic Oscillator Toggle Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Simulate Mechanical Oscillation',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Switch(
                  value: isOscillating,
                  activeColor: selectedMaterial.themeColor,
                  onChanged: (val) => setState(() => isOscillating = val),
                ),
              ],
            ),

            // Slider Control Suite
            _buildLabSlider(
              'Supply Current (I)',
              inputCurrentMA,
              0.5,
              20.0,
              'mA',
              (v) => setState(() => inputCurrentMA = v),
            ),
            _buildLabSlider(
              'Magnet Power (\$Br\$)',
              magnetStrengthTesla,
              0.1,
              2.5,
              'Tesla',
              (v) => setState(() => magnetStrengthTesla = v),
            ),
            _buildLabSlider(
              isOscillating ? 'Median Position (\$z\$)' : 'Static Gap (\$z\$)',
              distanceZmm,
              1.0,
              40.0,
              'mm',
              (v) => setState(() => distanceZmm = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabSlider(
    String label,
    double value,
    double min,
    double max,
    String units,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              '${value.toStringAsFixed(1)} $units',
              style: TextStyle(
                color: selectedMaterial.themeColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: selectedMaterial.themeColor,
            thumbColor: selectedMaterial.themeColor,
            overlayColor: selectedMaterial.themeColor.withOpacity(0.2),
            inactiveTrackColor: Colors.white12,
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _buildVisualizerMetrics(double currentV) {
    // Elegant system architecture conversion logic display units cleanly
    String unit = 'V';
    double printableValue = currentV;
    if (currentV.abs() < 1.0) {
      unit = 'mV';
      printableValue = currentV * 1000;
    }
    if (printableValue.abs() < 1.0) {
      unit = 'µV';
      printableValue = currentV * 1000000;
    }

    return Card(
      color: const Color(0xFF161622),
      child: ListTile(
        leading: Icon(Icons.bolt, color: selectedMaterial.themeColor, size: 32),
        title: const Text(
          'Live Hall Signal Output',
          style: TextStyle(color: Colors.white60, fontSize: 13),
        ),
        subtitle: Text(
          '${printableValue.toStringAsFixed(3)} $unit',
          style: TextStyle(
            color: selectedMaterial.themeColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildChartWorkspace(double minX, double maxX, double dynamicMaxY) {
    return SizedBox(
      height: 280,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: 0.0,
          maxY:
              dynamicMaxY *
              1.15, // Provide safe structural headroom padding dynamically
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (v) =>
                const FlLine(color: Colors.white, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 55,
                getTitlesWidget: (val, meta) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    val.toStringAsExponential(1),
                    style: const TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) => Text(
                  val.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: graphPoints,
              isCurved: true,
              curveSmoothness: 0.2,
              color: selectedMaterial.themeColor,
              barWidth: 3.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: selectedMaterial.themeColor.withOpacity(0.08),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
