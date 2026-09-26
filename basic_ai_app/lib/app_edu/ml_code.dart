import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ML Algo Demo')),
        body: const MLResultWidget(),
      ),
    );
  }
}

class MLResultWidget extends StatefulWidget {
  const MLResultWidget({super.key});

  @override
  State<MLResultWidget> createState() => _MLResultWidgetState();
}

class _MLResultWidgetState extends State<MLResultWidget> {
  late Future<String> _mlTask;

  @override
  void initState() {
    super.initState();
    _mlTask = runMachineLearning();
  }

  Future<String> runMachineLearning() async {
    try {
      // 1. Load data from assets
      String rawCsvContent =
          await rootBundle.loadString('assets/datasets/housing.csv');

      // Clean up extra spaces in the file so columns parse correctly
      rawCsvContent = rawCsvContent.replaceAll(RegExp(r'[ \t]+'), ' ').trim();

      // 2. Parse DataFrame
      final samples =
          DataFrame.fromRawCsv(rawCsvContent, fieldDelimiter: ' ').shuffle();
      final targetName = 'col_13';

      // 3. Split data
      final splits = splitData(samples, [0.8]);
      final trainData = splits[0];
      final testData = splits[1];

      // ==========================================
      // 🔥 THE MATHEMATICAL FIX
      // ==========================================
      // We configure the regressor to use a safe, small learning rate
      // and force fit an intercept (bias) to prevent it from collapsing to 0.
      final model = LinearRegressor(
        trainData,
        targetName,
        optimizerType: LinearOptimizerType.gradient,
        iterationsLimit: 100,
        initialLearningRate:
            0.000001, // Small rate prevents numbers from blowing up
        fitIntercept: true,
      );

      // 5. Evaluate Model
      final error = model.assess(testData, MetricType.mape);
      return 'Model trained successfully!\nError (MAPE): ${error.toStringAsFixed(4)}';
    } catch (e) {
      return 'Error running ML: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<String>(
        future: _mlTask,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                snapshot.data ?? 'No data found',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}
