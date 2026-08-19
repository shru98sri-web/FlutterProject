import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utils/advanced_services.dart';

class AdminAnalyticsPanel extends StatelessWidget {
  const AdminAnalyticsPanel({super.key});

  void _triggerCsvReportExport() async {
    final List<List<dynamic>> analyticsMatrixDataset = [
      [
        'Metric Segment Header',
        'Target Unit Key Metric ID',
        'Calculated Conversion Ratio'
      ],
      ['Q1 Ticket Conversion Log', 1250, '84.2%'],
      ['Q2 Tech Innovators Summit', 3420, '91.8%'],
      ['Q3 Global Food Festival Passes', 1980, '76.4%'],
    ];
    await CsvFileGeneratorService.exportAndShareMetricsReport(
        analyticsMatrixDataset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Executive Monitoring Analytics'),
        actions: [
          IconButton(
              icon: const Icon(Icons.file_download_outlined,
                  color: Colors.deepPurple),
              tooltip: 'Export CSV Report',
              onPressed: _triggerCsvReportExport)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Ticket Sales Performance Log',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles()),
                  barGroups: [
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                          toY: 8, color: Colors.deepPurple, width: 16)
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(
                          toY: 14, color: Colors.deepPurple, width: 16)
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(
                          toY: 11, color: Colors.deepPurple, width: 16)
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
