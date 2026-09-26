// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs, use_build_context_synchronously

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  static const int _snakeRows = 20;
  static const int _snakeColumns = 20;
  static const double _snakeCellSize = 10.0;

  UserAccelerometerEvent? _userAccelerometerEvent;
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;
  BarometerEvent? _barometerEvent;

  DateTime? _userAccelerometerUpdateTime;
  DateTime? _accelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  DateTime? _magnetometerUpdateTime;
  DateTime? _barometerUpdateTime;

  int? _userAccelerometerLastInterval;
  int? _accelerometerLastInterval;
  int? _gyroscopeLastInterval;
  int? _magnetometerLastInterval;
  int? _barometerLastInterval;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensors Plus Example'), elevation: 4),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
              ),
              child: SizedBox(
                height: _snakeRows * _snakeCellSize,
                width: _snakeColumns * _snakeCellSize,
                child: Snake(
                  rows: _snakeRows,
                  columns: _snakeColumns,
                  cellSize: _snakeCellSize,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                4: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  children: [
                    SizedBox.shrink(),
                    Text('X'),
                    Text('Y'),
                    Text('Z'),
                    Text('Interval'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('UserAccelerometer'),
                    ),
                    Text(_userAccelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_userAccelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_userAccelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text(
                      '${_userAccelerometerLastInterval?.toString() ?? '?'} ms',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Accelerometer'),
                    ),
                    Text(_accelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_accelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_accelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text('${_accelerometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Gyroscope'),
                    ),
                    Text(_gyroscopeEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_gyroscopeEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_gyroscopeEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text('${_gyroscopeLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Magnetometer'),
                    ),
                    Text(_magnetometerEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_magnetometerEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_magnetometerEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text('${_magnetometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  children: [
                    SizedBox.shrink(),
                    Text('Pressure'),
                    Text('Interval'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Barometer'),
                    ),
                    Text(
                      '${_barometerEvent?.pressure.toStringAsFixed(1) ?? '?'} hPa',
                    ),
                    Text('${_barometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Update Interval:'),
              SegmentedButton(
                segments: [
                  ButtonSegment(
                    value: SensorInterval.gameInterval,
                    label: Text(
                      'Game\n'
                      '(${SensorInterval.gameInterval.inMilliseconds}ms)',
                    ),
                  ),
                  ButtonSegment(
                    value: SensorInterval.uiInterval,
                    label: Text(
                      'UI\n'
                      '(${SensorInterval.uiInterval.inMilliseconds}ms)',
                    ),
                  ),
                  ButtonSegment(
                    value: SensorInterval.normalInterval,
                    label: Text(
                      'Normal\n'
                      '(${SensorInterval.normalInterval.inMilliseconds}ms)',
                    ),
                  ),
                  const ButtonSegment(
                    value: Duration(milliseconds: 500),
                    label: Text('500ms'),
                  ),
                  const ButtonSegment(
                    value: Duration(seconds: 1),
                    label: Text('1s'),
                  ),
                ],
                selected: {sensorInterval},
                showSelectedIcon: false,
                onSelectionChanged: (value) {
                  setState(() {
                    sensorInterval = value.first;
                    userAccelerometerEventStream(
                      samplingPeriod: sensorInterval,
                    );
                    accelerometerEventStream(samplingPeriod: sensorInterval);
                    gyroscopeEventStream(samplingPeriod: sensorInterval);
                    magnetometerEventStream(samplingPeriod: sensorInterval);
                    barometerEventStream(samplingPeriod: sensorInterval);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _userAccelerometerEvent = event;
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _userAccelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                  "It seems that your device doesn't support User Accelerometer Sensor",
                ),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _accelerometerEvent = event;
            if (_accelerometerUpdateTime != null) {
              final interval = now.difference(_accelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _accelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _accelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                  "It seems that your device doesn't support Accelerometer Sensor",
                ),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = event.timestamp;
          setState(() {
            _gyroscopeEvent = event;
            if (_gyroscopeUpdateTime != null) {
              final interval = now.difference(_gyroscopeUpdateTime!);
              if (interval > _ignoreDuration) {
                _gyroscopeLastInterval = interval.inMilliseconds;
              }
            }
          });
          _gyroscopeUpdateTime = now;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                  "It seems that your device doesn't support Gyroscope Sensor",
                ),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: sensorInterval).listen(
        (MagnetometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _magnetometerEvent = event;
            if (_magnetometerUpdateTime != null) {
              final interval = now.difference(_magnetometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _magnetometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _magnetometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                  "It seems that your device doesn't support Magnetometer Sensor",
                ),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      barometerEventStream(samplingPeriod: sensorInterval).listen(
        (BarometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _barometerEvent = event;
            if (_barometerUpdateTime != null) {
              final interval = now.difference(_barometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _barometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _barometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                  "It seems that your device doesn't support Barometer Sensor",
                ),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
  }
}

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class Snake extends StatefulWidget {
  const Snake({
    super.key,
    required this.rows,
    required this.columns,
    required this.cellSize,
  });

  final int rows;
  final int columns;
  final double cellSize;

  @override
  State<Snake> createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
  late GameState _gameState;
  AccelerometerEvent? _acceleration;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _gameState = GameState(widget.rows, widget.columns);

    // Wire up localized background movement vectors
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      setState(() {
        _acceleration = event;
      });
    });

    // Frame scheduler driving coordinate ticks
    _timer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      _step();
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _step() {
    final accel = _acceleration;
    if (accel == null) return;

    // Evaluate gravity inclination data vectors
    // Accelerometer X targets horizontal plane drift vectors
    // Accelerometer Y targets vertical plane tilt drift vectors
    if (accel.x.abs() > accel.y.abs()) {
      if (accel.x > 1.5) {
        _gameState.direction = math.Point(-1, 0); // Drift Left
      } else if (accel.x < -1.5) {
        _gameState.direction = math.Point(1, 0); // Drift Right
      }
    } else {
      if (accel.y > 1.5) {
        _gameState.direction = math.Point(0, 1); // Drift Down
      } else if (accel.y < -1.5) {
        _gameState.direction = math.Point(0, -1); // Drift Up
      }
    }

    setState(() {
      _gameState.step();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SnakeBoardPainter(state: _gameState, cellSize: widget.cellSize),
    );
  }
}

class GameState {
  GameState(this.rows, this.columns) {
    _reset();
  }

  final int rows;
  final int columns;

  late List<math.Point<int>> body;
  late math.Point<int> food;
  late math.Point<int> direction;

  void _reset() {
    final midX = columns ~/ 2;
    final midY = rows ~/ 2;

    body = [
      math.Point(midX, midY),
      math.Point(midX, midY + 1),
      math.Point(midX, midY + 2),
    ];
    direction = const math.Point(0, -1); // Start traveling upward
    _generateFood();
  }

  void _generateFood() {
    final rand = math.Random();
    while (true) {
      final newFood = math.Point(rand.nextInt(columns), rand.nextInt(rows));
      if (!body.contains(newFood)) {
        food = newFood;
        break;
      }
    }
  }

  void step() {
    // Determine target vector coordinate offset adjustments
    final head = body.first;
    var nextX = head.x + direction.x;
    var nextY = head.y + direction.y;

    // Wrap around game frame limits automatically
    if (nextX < 0) nextX = columns - 1;
    if (nextX >= columns) nextX = 0;
    if (nextY < 0) nextY = rows - 1;
    if (nextY >= rows) nextY = 0;

    final nextHead = math.Point(nextX, nextY);

    // Reset layout configuration if body boundaries intersect
    if (body.contains(nextHead)) {
      _reset();
      return;
    }

    // Append new layout head item position
    body.insert(0, nextHead);

    // Check item collection overlapping states
    if (nextHead == food) {
      _generateFood();
    } else {
      body.removeLast();
    }
  }
}

class SnakeBoardPainter extends CustomPainter {
  SnakeBoardPainter({required this.state, required this.cellSize});

  final GameState state;
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = Colors.black;
    final redPaint = Paint()..color = Colors.red;

    // 1. Render target food positions onto the canvas layout map
    canvas.drawRect(
      Rect.fromLTWH(
        state.food.x * cellSize,
        state.food.y * cellSize,
        cellSize,
        cellSize,
      ),
      redPaint,
    );

    // 2. Clear segment positions loop for rendering snake segments
    for (final segment in state.body) {
      canvas.drawRect(
        Rect.fromLTWH(
          segment.x * cellSize,
          segment.y * cellSize,
          cellSize - 1.0, // Subtraction creates pixel grid lines
          cellSize - 1.0,
        ),
        blackPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SnakeBoardPainter oldDelegate) {
    return true; // Continuously redraw framework frames
  }
}
