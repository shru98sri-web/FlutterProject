import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';

void main() {
  runApp(const MyApp());
}

// ============================================================
// APPLICATION
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile ML Engine',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyanAccent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0E15),
        useMaterial3: true,
      ),
      home: const StudentTrainingScreen(),
    );
  }
}

// ============================================================
// STUDENT TRAINING SCREEN
// ============================================================

class StudentTrainingScreen extends StatefulWidget {
  const StudentTrainingScreen({super.key});

  @override
  State<StudentTrainingScreen> createState() => _StudentTrainingScreenState();
}

class _StudentTrainingScreenState extends State<StudentTrainingScreen> {
  String _status = 'Ready to train';

  double? _accuracy;

  List<FlSpot> _lossHistory = <FlSpot>[];

  int _touchedIteration = -1;

  double _touchedLossValue = -1.0;

  bool _isTraining = false;

// ==========================================================
// GENERATE CSV DATA
// ==========================================================

  String _generateStudentCsvData() {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln(
      'StudyHours,Attendance,Passed',
    );

    for (int i = 0; i < 500; i++) {
      final double hours = (i % 15) + 2.0;

      final double attendance = 50.0 + (i % 51);

      final int passed = (hours > 8.0 && attendance > 75.0) ? 1 : 0;

      buffer.writeln(
        '$hours,$attendance,$passed',
      );
    }

    return buffer.toString();
  }

// ==========================================================
// TRAIN MODEL
// ==========================================================

  void _trainModel() {
    if (_isTraining) {
      return;
    }

    setState(() {
      _isTraining = true;

      _status = 'Training 500 students...';

      _accuracy = null;

      _lossHistory = <FlSpot>[];

      _touchedIteration = -1;

      _touchedLossValue = -1.0;
    });

// Let Flutter render the training state first.
    Future<void>.delayed(
      const Duration(milliseconds: 100),
      () {
        try {
// ==================================================
// CREATE CSV
// ==================================================

          final String csvContent = _generateStudentCsvData();

// ==================================================
// CREATE DATAFRAME
// ==================================================

          final DataFrame samples = DataFrame.fromRawCsv(
            csvContent,
          );

// ==================================================
// SPLIT DATA
// ==================================================

          final List<DataFrame> splits = splitData(
            samples,
            <double>[0.8],
          );

          final DataFrame trainData = splits[0];

          final DataFrame testData = splits[1];

// ==================================================
// TARGET COLUMN
// ==================================================

          const String targetColumn = 'Passed';

// ==================================================
// LOGISTIC REGRESSION
// ==================================================

          final LogisticRegressor classifier = LogisticRegressor(
            trainData,
            targetColumn,
            iterationsLimit: 40,
            learningRateType: LearningRateType.constant,
            collectLearningData: true,
            initialLearningRate: 0.1,
          );

// ==================================================
// GET TRAINING LOSS
// ==================================================

          final List<num>? costHistory = classifier.costPerIteration;

          final List<FlSpot> spots = <FlSpot>[];

          if (costHistory != null) {
            for (int i = 0; i < costHistory.length; i++) {
              final double loss = costHistory[i].toDouble();

              if (loss.isFinite && loss >= 0) {
                spots.add(
                  FlSpot(
                    i.toDouble(),
                    loss,
                  ),
                );
              }
            }
          }

// ==================================================
// MODEL ACCURACY
// ==================================================

          final double score = classifier.assess(
            testData,
            MetricType.accuracy,
          );

// ==================================================
// UPDATE UI
// ==================================================

          if (!mounted) {
            return;
          }

          setState(() {
            _lossHistory = spots;

            _accuracy = score * 100.0;

            _status = 'Training Completed!';

            _isTraining = false;
          });
        } catch (error) {
          if (!mounted) {
            return;
          }

          setState(() {
            _status = 'Error during training:\n$error';

            _isTraining = false;
          });
        }
      },
    );
  }

// ==========================================================
// MAXIMUM Y VALUE FOR GRAPH
// ==========================================================

  double _getMaxY() {
    if (_lossHistory.isEmpty) {
      return 1.0;
    }

    double maxValue = 0.0;

    for (final FlSpot spot in _lossHistory) {
      if (spot.y > maxValue) {
        maxValue = spot.y;
      }
    }

    if (!maxValue.isFinite || maxValue <= 0) {
      return 1.0;
    }

    return maxValue * 1.2;
  }

// ==========================================================
// BUILD
// ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E15),

// ======================================================
// APP BAR
// ======================================================

      appBar: AppBar(
        title: const Text(
          'Mobile ML Engine Dashboard',
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF151622),
      ),

// ======================================================
// BODY
// ======================================================

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
// =================================================
// TRAINING STATUS CARD
// =================================================

              Card(
                color: const Color(0xFF151622),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Text(
                        _status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      if (_isTraining)
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 12,
                          ),
                          child: LinearProgressIndicator(),
                        ),
                      if (_accuracy != null) ...<Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Validation Accuracy: '
                          '${_accuracy!.toStringAsFixed(2)}%',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 14,
              ),

// =================================================
// TOUCH INFORMATION
// =================================================

              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _touchedIteration != -1
                      ? Colors.cyanAccent.withAlpha(20)
                      : const Color(
                          0xFF151622,
                        ),
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                  border: Border.all(
                    color: _touchedIteration != -1
                        ? Colors.cyanAccent.withAlpha(
                            100,
                          )
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
// ------------------------------------------
// ITERATION
// ------------------------------------------

                    Column(
                      children: <Widget>[
                        const Text(
                          'ITERATION (X)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          _touchedIteration != -1 ? '$_touchedIteration' : '--',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white10,
                    ),

// ------------------------------------------
// LOSS
// ------------------------------------------

                    Column(
                      children: <Widget>[
                        const Text(
                          'LOSS AMPLITUDE (Y)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          _touchedLossValue != -1.0
                              ? _touchedLossValue.toStringAsFixed(
                                  5,
                                )
                              : '--',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

// =================================================
// GRAPH
// =================================================

              Expanded(
                child: _lossHistory.isEmpty
                    ? const Center(
                        child: Text(
                          'No computational data generated.\n'
                          'Press the action engine trigger below.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white30,
                            height: 1.5,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          right: 24,
                          left: 6,
                          top: 10,
                        ),
                        child: LineChart(
                          LineChartData(
                            minX: 0,

                            maxX: (_lossHistory.length - 1).toDouble().clamp(
                                  1.0,
                                  double.infinity,
                                ),

                            minY: 0,

                            maxY: _getMaxY(),

// --------------------------------
// GRID
// --------------------------------

                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              getDrawingHorizontalLine: (double value) {
                                return FlLine(
                                  color: Colors.white.withAlpha(
                                    13,
                                  ),
                                  strokeWidth: 1,
                                );
                              },
                              getDrawingVerticalLine: (double value) {
                                return FlLine(
                                  color: Colors.white.withAlpha(
                                    13,
                                  ),
                                  strokeWidth: 1,
                                );
                              },
                            ),

// --------------------------------
// TITLES
// --------------------------------

                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                axisNameWidget: const Padding(
                                  padding: EdgeInsets.only(
                                    top: 4,
                                  ),
                                  child: Text(
                                    'Epoch / Iterations Steps',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  interval: 10,
                                  getTitlesWidget: (
                                    double value,
                                    TitleMeta meta,
                                  ) {
                                    return SideTitleWidget(
                                      meta: meta,
                                      child: Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                axisNameWidget: const Text(
                                  'Objective Function Loss',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 46,
                                  getTitlesWidget: (
                                    double value,
                                    TitleMeta meta,
                                  ) {
                                    return SideTitleWidget(
                                      meta: meta,
                                      child: Text(
                                        value.toStringAsFixed(2),
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
// --------------------------------
// BORDER
// --------------------------------

                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.white12,
                                width: 1,
                              ),
                            ),

// --------------------------------
// TOUCH
// --------------------------------

                            lineTouchData: LineTouchData(
                              handleBuiltInTouches: true,
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (
                                  LineBarSpot touchedSpot,
                                ) {
                                  return const Color(
                                    0xFF1E2030,
                                  );
                                },
                                tooltipRoundedRadius: 8,
                                tooltipBorder: const BorderSide(
                                  color: Colors.cyanAccent,
                                  width: 1,
                                ),
                                getTooltipItems: (
                                  List<LineBarSpot> touchedSpots,
                                ) {
                                  return touchedSpots.map(
                                    (
                                      LineBarSpot spot,
                                    ) {
                                      return LineTooltipItem(
                                        'Iter: '
                                        '${spot.x.toInt()}\n'
                                        'Loss: '
                                        '${spot.y.toStringAsFixed(4)}',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ).toList();
                                },
                              ),
                              touchCallback: (
                                FlTouchEvent event,
                                LineTouchResponse? response,
                              ) {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.lineBarSpots == null ||
                                    response.lineBarSpots!.isEmpty) {
                                  if (mounted) {
                                    setState(() {
                                      _touchedIteration = -1;

                                      _touchedLossValue = -1.0;
                                    });
                                  }

                                  return;
                                }

                                final LineBarSpot spot =
                                    response.lineBarSpots!.first;

                                if (mounted) {
                                  setState(() {
                                    _touchedIteration = spot.x.toInt();

                                    _touchedLossValue = spot.y;
                                  });
                                }
                              },
                            ),

// --------------------------------
// LINE
// --------------------------------

                            lineBarsData: <LineChartBarData>[
                              LineChartBarData(
                                spots: _lossHistory,
                                isCurved: true,
                                curveSmoothness: 0.25,
                                barWidth: 3.5,
                                color: Colors.cyanAccent,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.cyanAccent.withAlpha(
                                    20,
                                  ),
                                ),
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (
                                    FlSpot spot,
                                    double percent,
                                    LineChartBarData barData,
                                    int index,
                                  ) {
                                    final bool selected =
                                        _touchedIteration == spot.x.toInt();

                                    return FlDotCirclePainter(
                                      radius: selected ? 6 : 0,
                                      color: Colors.orangeAccent,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),

              const SizedBox(
                height: 24,
              ),

// =================================================
// TRAIN BUTTON
// =================================================

              ElevatedButton.icon(
                onPressed: _isTraining ? null : _trainModel,
                icon: Icon(
                  _isTraining ? Icons.hourglass_top : Icons.bolt,
                  size: 22,
                ),
                label: Text(
                  _isTraining
                      ? 'TRAINING MODEL...'
                      : 'EXECUTE COGNITIVE GRADIENT DESCENT',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.cyanAccent.withAlpha(100),
                  disabledForegroundColor: Colors.black54,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
