import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: QuinckesMethodLab()));

class FluidSample {
  final String name;
  final double density; // kg/m³
  final double susceptibility; // Dimensionless SI units (Volume Chi)
  final Color themeColor;

  const FluidSample({
    required this.name,
    required this.density,
    required this.susceptibility,
    required this.themeColor,
  });
}

class QuinckesMethodLab extends StatefulWidget {
  const QuinckesMethodLab({Key? key}) : super(key: key);

  @override
  State<QuinckesMethodLab> createState() => _QuinckesMethodLabState();
}

class _QuinckesMethodLabState extends State<QuinckesMethodLab> {
  static const List<FluidSample> fluidCatalog = [
    FluidSample(
      name: 'Manganese Sulphate (MnSO₄ Solution)',
      density: 1250.0,
      susceptibility: 3.2e-4,
      themeColor: Colors.tealAccent,
    ),
    FluidSample(
      name: 'Ferric Chloride (FeCl₃ Solution)',
      density: 1450.0,
      susceptibility: 2.7e-4,
      themeColor: Colors.orangeAccent,
    ),
    FluidSample(
      name: 'Pure Water (H₂O)',
      density: 1000.0,
      susceptibility: -9.0e-6,
      themeColor: Colors.blueAccent,
    ),
  ];

  late FluidSample selectedFluid;
  double currentAmp = 2.5;

  final double g = 9.81;
  final double mu0 = 4 * pi * 1e-7;
  final double coilTurnsPerMeter = 180000;

  @override
  void initState() {
    super.initState();
    selectedFluid = fluidCatalog[0];
  }

  double _calculateDisplacement(double current) {
    double fieldH = coilTurnsPerMeter * current;
    double numerator = selectedFluid.susceptibility * mu0 * pow(fieldH, 2);
    double denominator = 2 * selectedFluid.density * g;
    return (numerator / denominator) * 1000;
  }

  List<FlSpot> _generateGraphData() {
    List<FlSpot> points = [];
    for (double i = 0.0; i <= 5.0; i += 0.25) {
      points.add(FlSpot(i, _calculateDisplacement(i)));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    double currentDisplacement = _calculateDisplacement(currentAmp);
    List<FlSpot> chartSpots = _generateGraphData();

    double absMaxY = chartSpots.map((s) => s.y.abs()).reduce(max);
    double yLimit = absMaxY < 1.0 ? 1.0 : absMaxY * 1.25;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: AppBar(
        // FIXED: Changed text color to a crisp, readable white
        title: const Text(
          "Quincke's Fluid Lab Framework",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF161622),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFluidSelectorCard(),
              const SizedBox(height: 16),
              _buildLiveMetricsDisplay(currentDisplacement),
              const SizedBox(height: 16),
              _buildControlSliders(),
              const SizedBox(height: 24),
              _buildAnalysisGraph(chartSpots, yLimit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFluidSelectorCard() {
    return Card(
      color: const Color(0xFF161622),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SELECT CHEMICAL SAMPLE FLUID",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white10, // Swapped to a darker adaptive backdrop
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<FluidSample>(
                  value: selectedFluid,
                  dropdownColor: const Color(0xFF161622),
                  isExpanded: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  items: fluidCatalog
                      .map(
                        (f) => DropdownMenuItem(
                          value: f,
                          child: Text(
                            f.name,
                            overflow: TextOverflow.ellipsis,
                          ), // FIXED: Prevents text clipping
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => selectedFluid = val);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveMetricsDisplay(double displacementMm) {
    bool isParamagnetic = selectedFluid.susceptibility > 0;

    return Card(
      color: const Color(0xFF161622),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // FIXED: Wrapped items inside Expanded widgets to dynamically scale across narrow widths
                Expanded(
                  child: _buildMiniMetric(
                    "Density (ρ)",
                    "${selectedFluid.density.toInt()} kg/m³",
                  ),
                ),
                Expanded(
                  child: _buildMiniMetric(
                    "Susceptibility (χm)",
                    selectedFluid.susceptibility.toStringAsExponential(2),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white12, height: 24),
            const Text(
              "Calculated Column Displacement (Δh)",
              style: TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "${displacementMm.toStringAsFixed(4)} mm",
              style: TextStyle(
                color: selectedFluid.themeColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              isParamagnetic
                  ? "Column Rises ↑ (Attracted)"
                  : "Column Depresses ↓ (Repelled)",
              style: TextStyle(
                color: isParamagnetic
                    ? Colors.tealAccent
                    : Colors.lightBlueAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniMetric(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 12),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow
              .ellipsis, // FIXED: Safeguards against long metric labels
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildControlSliders() {
    return Card(
      color: const Color(0xFF161622),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Electromagnet Current (I)",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  "${currentAmp.toStringAsFixed(2)} Amps",
                  style: TextStyle(
                    color: selectedFluid.themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: currentAmp,
              min: 0.0,
              max: 5.0,
              activeColor: selectedFluid.themeColor,
              inactiveColor: Colors.white12,
              onChanged: (val) => setState(() => currentAmp = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisGraph(List<FlSpot> spots, double yLimit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "  Displacement Graph Bounds (Δh in mm vs Current in A)",
          style: TextStyle(color: Colors.white60, fontSize: 12),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minX: 0.0,
              maxX: 5.0,
              minY: selectedFluid.susceptibility < 0 ? -yLimit : 0.0,
              maxY: selectedFluid.susceptibility < 0 ? 0.0 : yLimit,
              gridData: const FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: _getGridLine,
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    getTitlesWidget: (val, meta) => Text(
                      val.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (val, meta) => Text(
                      "${val.toStringAsFixed(1)}A",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
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
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.15,
                  color: selectedFluid.themeColor,
                  barWidth: 3.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: selectedFluid.themeColor.withOpacity(0.06),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static FlLine _getGridLine(double value) =>
      const FlLine(color: Colors.white, strokeWidth: 1);
}
