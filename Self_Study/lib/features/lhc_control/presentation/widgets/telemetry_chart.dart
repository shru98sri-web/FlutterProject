import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TelemetryChart extends StatelessWidget {
  final List<double> historyPoints;

  const TelemetryChart({super.key, required this.historyPoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey[800]!)),
          lineBarsData: [
            LineChartBarData(
              spots: historyPoints.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: Colors.cyanAccent,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.cyanAccent.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }
}
