import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StudentTrainingScreen(),
    );
  }
}

class StudentTrainingScreen extends StatefulWidget {
  const StudentTrainingScreen({super.key});

  @override
  State<StudentTrainingScreen> createState() => _StudentTrainingScreenState();
}

class _StudentTrainingScreenState extends State<StudentTrainingScreen> {
  String _status = 'Ready to train';
  double? _accuracy;
  LogisticRegressor? _classifier;
  List<FlSpot> _lossHistory = [];

  String _generateStudentCsvData() {
    final buffer = StringBuffer();
    buffer.writeln('StudyHours,Attendance,Passed');

    for (int i = 0; i < 500; i++) {
      double hours = (i % 15) + 2.0;
      double attendance = 50.0 + (i % 51);
      int passed = (hours > 8 && attendance > 75) ? 1 : 0;

      buffer.writeln('$hours,$attendance,$passed');
    }
    return buffer.toString();
  }

  void _trainModel() {
    setState(() {
      _status = 'Training 500 students...';
      _lossHistory.clear();
    });

    try {
      final csvContent = _generateStudentCsvData();
      final samples = DataFrame.fromRawCsv(csvContent);

      final splits = splitData(samples, [0.8]);
      final trainData = splits[0];
      final testData = splits[1];

      final targetColumn = 'Passed';

      // FIX 1: Pass collectLearningData: true to populate the cost matrix history
      final classifier = LogisticRegressor(
        trainData,
        targetColumn,
        iterationsLimit: 40,
        learningRateType: LearningRateType.constant,
        collectLearningData: true,
      );

      // FIX 2: Safely extract the nullable List<num>? structure
      final List<num>? costHistory = classifier.costPerIteration;
      final List<FlSpot> spots = [];

      if (costHistory != null) {
        for (int i = 0; i < costHistory.length; i++) {
          final double lossValue = costHistory[i].toDouble();
          if (lossValue.isFinite) {
            spots.add(FlSpot(i.toDouble(), lossValue));
          }
        }
      }

      final score = classifier.assess(testData, MetricType.accuracy);

      setState(() {
        _classifier = classifier;
        _lossHistory = spots;
        _accuracy = score * 100;
        _status = 'Training Completed!';
      });
    } catch (e) {
      setState(() {
        _status = 'Error during training: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ML Model Training & Evaluation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status and Accuracy Indicators
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _status,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (_accuracy != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Model Accuracy: ${_accuracy!.toStringAsFixed(2)}%',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Convergence Graph Display Panel
            Expanded(
              child: _lossHistory.isEmpty
                  ? const Center(
                      child: Text(
                          'No data trained yet. Click below to generate the graph.'))
                  : Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 20.0),
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Text('Iterations'),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 10,
                                getTitlesWidget: (value, meta) =>
                                    Text(value.toInt().toString()),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text('Loss Value'),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) =>
                                    Text(value.toStringAsFixed(2)),
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.grey)),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _lossHistory,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.blue,
                              dotData: const FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _trainModel,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Train Model & Display Graph'),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
