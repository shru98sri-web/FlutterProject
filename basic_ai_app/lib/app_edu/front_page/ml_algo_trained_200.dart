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

  // Generate 500 mock student records for training
  String _generateStudentCsvData() {
    final buffer = StringBuffer();
    buffer.writeln('StudyHours,Attendance,Passed');

    for (int i = 0; i < 500; i++) {
      // Mock simple rules with random variance
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
    });

    try {
      // 1. Load CSV data into a DataFrame
      final csvContent = _generateStudentCsvData();
      final samples = DataFrame.fromRawCsv(csvContent);

      // 2. Split dataset: 80% Training (400 students), 20% Test (100 students)
      final splits = splitData(samples, [0.8]);
      final trainData = splits[0];
      final testData = splits[1];

      // 3. Train the model using Logistic Regression
      final targetColumn = 'Passed';
      final classifier = LogisticRegressor(
        trainData,
        targetColumn,
        iterationsLimit: 100,
        learningRateType: LearningRateType.constant,
      );

      // 4. Assess performance against the test dataset
      final score = classifier.assess(testData, MetricType.accuracy);

      setState(() {
        _classifier = classifier;
        _accuracy = score * 100;
        _status = 'Training Completed successfully!';
      });
    } catch (e) {
      setState(() {
        _status = 'Error during training: $e';
      });
    }
  }

  void _predictSample() {
    if (_classifier == null) return;

    // Test prediction for a single student: 12 Study Hours, 85% Attendance
    final unlabelledStudent = DataFrame([
      ['StudyHours', 'Attendance'],
      [12.0, 85.0]
    ]);

    final prediction = _classifier!.predict(unlabelledStudent);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sample Prediction Result'),
        content: Text('Predicted Rows: ${prediction.rows.toList()}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ML Algo Student Trainer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_accuracy != null) ...[
              const SizedBox(height: 10),
              Text(
                'Model Accuracy: ${_accuracy!.toStringAsFixed(2)}%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _trainModel,
              child: const Text('Start Training (500 Students)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _classifier != null ? _predictSample : null,
              child: const Text('Test Single Prediction'),
            ),
          ],
        ),
      ),
    );
  }
}
