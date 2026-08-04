import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF13131A),
      ),
      home: const CompleteOpticsLabBench(),
    );
  }
}

class EditableLens {
  final String id;
  double positionX;
  double diameter;
  double thickness;
  double curvature;

  EditableLens({
    required this.id,
    required this.positionX,
    required this.diameter,
    required this.thickness,
    required this.curvature,
  });
}

class CompleteOpticsLabBench extends StatefulWidget {
  const CompleteOpticsLabBench({super.key});

  @override
  State<CompleteOpticsLabBench> createState() => _CompleteOpticsLabBenchState();
}

class _CompleteOpticsLabBenchState extends State<CompleteOpticsLabBench> {
  final GlobalKey _globalRenderKey = GlobalKey();

  int _rayCount = 12;
  double _focalMultiplier = 1.0;
  bool _isAntiReflectiveCoated = false;
  String _activePresetName = "Custom Setup";

  final List<EditableLens> _lensList = [];
  int _idCounter = 0;

  @override
  void initState() {
    super.initState();
    _apply50mmPrimePreset();
  }

  // --- LENS PRESETS SYSTEM ---

  void _apply50mmPrimePreset() {
    setState(() {
      _activePresetName = "50mm f/1.4 Prime";
      _focalMultiplier = 1.0;
      _lensList.clear();
      _lensList.addAll([
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 60,
          diameter: 160,
          thickness: 35,
          curvature: 120,
        ),
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 180,
          diameter: 120,
          thickness: 25,
          curvature: 70,
        ),
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 300,
          diameter: 110,
          thickness: 30,
          curvature: -80,
        ),
      ]);
    });
  }

  void _apply24_70mmZoomPreset() {
    setState(() {
      _activePresetName = "24-70mm Mid-Zoom";
      _focalMultiplier = 1.3;
      _lensList.clear();
      _lensList.addAll([
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 40,
          diameter: 170,
          thickness: 25,
          curvature: 140,
        ),
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 120,
          diameter: 130,
          thickness: 15,
          curvature: -100,
        ),
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 220,
          diameter: 110,
          thickness: 35,
          curvature: 80,
        ),
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 340,
          diameter: 125,
          thickness: 20,
          curvature: 90,
        ),
      ]);
    });
  }

  void _apply200mmTelephotoPreset() {
    setState(() {
      _activePresetName = "200mm Telephoto";
      _focalMultiplier = 1.8;
      _lensList.clear();
      _lensList.addAll([
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 30,
          diameter: 180,
          thickness: 45,
          curvature: 200,
        ),
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 110,
          diameter: 170,
          thickness: 20,
          curvature: 160,
        ),
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 260,
          diameter: 90,
          thickness: 15,
          curvature: -50,
        ),
        EditableLens(
          id: 'L${_idCounter++}',
          positionX: 360,
          diameter: 80,
          thickness: 15,
          curvature: 60,
        ),
      ]);
    });
  }

  // --- EXPORT HANDLING SYSTEM ---
  Future<void> _exportBenchAsImage() async {
    try {
      RenderRepaintBoundary? boundary =
          _globalRenderKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Layout saved successfully! (${pngBytes.length} bytes extracted)',
            ),
            backgroundColor: Colors.green.shade800,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Optical Preset Studio'),
        backgroundColor: const Color(0xFF09090E),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.greenAccent),
            onPressed: _exportBenchAsImage,
            tooltip: 'Export Design Layout',
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Preset Lens Selector Tray (Top Horizontal Bar)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFF181824),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: _apply50mmPrimePreset,
                  icon: const Icon(
                    Icons.camera,
                    size: 16,
                    color: Colors.blueAccent,
                  ),
                  label: const Text('50mm Prime'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _activePresetName.contains("50mm")
                          ? Colors.blueAccent
                          : Colors.white24,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _apply24_70mmZoomPreset,
                  icon: const Icon(
                    Icons.shutter_speed,
                    size: 16,
                    color: Colors.tealAccent,
                  ),
                  label: const Text('24-70mm Zoom'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _activePresetName.contains("24-70mm")
                          ? Colors.tealAccent
                          : Colors.white24,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _apply200mmTelephotoPreset,
                  icon: const Icon(
                    Icons.center_focus_strong,
                    size: 16,
                    color: Colors.amberAccent,
                  ),
                  label: const Text('200mm Telephoto'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _activePresetName.contains("200mm")
                          ? Colors.amberAccent
                          : Colors.white24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Core Ray-Tracing Workspace
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RepaintBoundary(
                key: _globalRenderKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A26),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: PureRayTracerPainter(
                                lenses: _lensList,
                                rayCount: _rayCount,
                                focalMultiplier: _focalMultiplier,
                                enableArCoating: _isAntiReflectiveCoated,
                                activePresetLabel: _activePresetName,
                              ),
                            ),
                          ),
                          ..._lensList.map((lens) {
                            final double topOffset =
                                (constraints.maxHeight / 2) -
                                (lens.diameter / 2);
                            return Positioned(
                              left: lens.positionX,
                              top: topOffset,
                              child: GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  setState(() {
                                    _activePresetName =
                                        "Custom Setup (Modified)";
                                    lens.positionX += details.delta.dx;
                                    lens.positionX = lens.positionX.clamp(
                                      10.0,
                                      constraints.maxWidth -
                                          lens.thickness -
                                          10.0,
                                    );
                                  });
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.resizeLeftRight,
                                  child: Container(
                                    width: lens.thickness,
                                    height: lens.diameter,
                                    decoration: BoxDecoration(
                                      color: Colors.cyan.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.cyanAccent.withOpacity(
                                          0.3,
                                        ),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.drag_indicator,
                                        size: 14,
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // 3. Control Deck Console Panel
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF0E0E14),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Anti-Reflective Coating Filter:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: _isAntiReflectiveCoated,
                        activeColor: Colors.purpleAccent,
                        onChanged: (val) =>
                            setState(() => _isAntiReflectiveCoated = val),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Fine Focus Shifter: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Slider(
                          value: _focalMultiplier,
                          min: 0.4,
                          max: 2.2,
                          onChanged: (val) => setState(() {
                            _activePresetName = "Custom Setup (Modified)";
                            _focalMultiplier = val;
                          }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Ray Quantity: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Slider(
                          value: _rayCount.toDouble(),
                          min: 3,
                          max: 25,
                          divisions: 22,
                          onChanged: (val) =>
                              setState(() => _rayCount = val.toInt()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PureRayTracerPainter extends CustomPainter {
  final List lenses;
  final int rayCount;
  final double focalMultiplier;
  final bool enableArCoating;
  final String activePresetLabel;
  PureRayTracerPainter({
    required this.lenses,
    required this.rayCount,
    required this.focalMultiplier,
    required this.enableArCoating,
    required this.activePresetLabel,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final double midY = size.height / 2;
    final Paint axisPaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), axisPaint);
    for (var lens in lenses) {
      _drawLensCurveBody(canvas, midY, lens);
    }
    double clearApertureDiameter = size.height * 0.35;
    if (lenses.isNotEmpty) {
      clearApertureDiameter = lenses
          .map((l) => l.diameter)
          .reduce((a, b) => math.min(a, b));
    }
    final double entranceApertureHeight = clearApertureDiameter * 0.82;
    _traceChromaticLightBundles(
      canvas,
      size,
      midY,
      0.0,
      entranceApertureHeight,
    );
    _traceChromaticLightBundles(
      canvas,
      size,
      midY,
      0.12,
      entranceApertureHeight,
    );
    _traceChromaticLightBundles(
      canvas,
      size,
      midY,
      -0.12,
      entranceApertureHeight,
    );
    _drawOpticalTelemetryOverlay(canvas, entranceApertureHeight);
  }

  void _drawLensCurveBody(Canvas canvas, double midY, EditableLens lens) {
    final Paint glassPaint = Paint()
      ..color = enableArCoating
          ? const Color(0x2A6200EE)
          : const Color(0x1A00E5FF)
      ..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()
      ..color = enableArCoating
          ? Colors.purpleAccent.withOpacity(0.5)
          : Colors.cyanAccent.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final Path path = Path();
    final double topY = midY - lens.diameter / 2;
    final double bottomY = midY + lens.diameter / 2;
    final double endX = lens.positionX + lens.thickness;
    path.moveTo(lens.positionX, topY);
    path.quadraticBezierTo(
      lens.positionX + (lens.curvature * 0.15),
      midY,
      lens.positionX,
      bottomY,
    );
    path.lineTo(endX, bottomY);
    path.quadraticBezierTo(endX + (lens.curvature * -0.10), midY, endX, topY);
    path.close();
    canvas.drawPath(path, glassPaint);
    canvas.drawPath(path, borderPaint);
  }

  void _traceChromaticLightBundles(
    Canvas canvas,
    Size size,
    double midY,
    double fieldAngle,
    double apertureHeight,
  ) {
    final List sortedLenses = List.from(lenses)
      ..sort((a, b) => a.positionX.compareTo(b.positionX));
    final List<Map<String, dynamic>> waveWavelengths = [
      {
        'color': const Color(0xFFFF3B30),
        'refractiveIndex': enableArCoating ? 1.500 : 1.485,
      },
      {'color': const Color(0xFF34C759), 'refractiveIndex': 1.500},
      {
        'color': const Color(0xFF007AFF),
        'refractiveIndex': enableArCoating ? 1.500 : 1.515,
      },
    ];
    for (int i = 0; i < rayCount; i++) {
      final double progress = (rayCount > 1) ? (i / (rayCount - 1)) : 0.5;
      final double verticalOffset = (progress - 0.5) * apertureHeight;
      for (var wave in waveWavelengths) {
        final Paint rayPaint = Paint()
          ..color = (wave['color'] as Color).withOpacity(
            enableArCoating ? 0.80 : 0.45,
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = enableArCoating ? 1.4 : 1.0;
        double currentX = 0;
        double currentY = midY + verticalOffset;
        double slopeX = 1.0;
        double slopeY = math.tan(fieldAngle);
        final Path rayPath = Path();
        rayPath.moveTo(currentX, currentY);
        bool unclipped = true;
        for (int l = 0; l < sortedLenses.length; l++) {
          var lens = sortedLenses[l];
          double intersectX = lens.positionX;
          double heightFromAxis = (currentY - midY).abs();
          double normalizationFactor = (heightFromAxis / (lens.diameter / 2))
              .clamp(0.0, 1.0);
          double curveSag =
              (1.0 - math.sqrt(1.0 - math.pow(normalizationFactor, 2))) *
              (lens.curvature * 0.2);
          intersectX += curveSag;
          if (currentY < midY - lens.diameter / 2 ||
              currentY > midY + lens.diameter / 2) {
            unclipped = false;
            break;
          }
          double exitX = lens.positionX + lens.thickness;
          double travelDistanceX = exitX - intersectX;
          currentY += (slopeY / slopeX) * travelDistanceX;
          currentX = exitX;
          rayPath.lineTo(currentX, currentY);
          double indexRatio = wave['refractiveIndex'] as double;
          double bendModifier = (lens.curvature >= 0)
              ? (1.0 / indexRatio)
              : indexRatio;
          slopeY =
              slopeY * bendModifier -
              (currentY - midY) *
                  (0.0036 / (focalMultiplier * (indexRatio / 1.50)));
        }
        if (!unclipped) continue;
        final double focusPointX =
            size.width * (0.82 * focalMultiplier).clamp(0.4, 0.98);
        final double focusPointY =
            midY - (size.width * math.tan(fieldAngle) * 0.38);
        rayPath.lineTo(focusPointX, focusPointY);
        final double edgeX = size.width;
        final double run = edgeX - focusPointX;
        final double rise = (focusPointX > currentX)
            ? ((focusPointY - currentY) / (focusPointX - currentX)) * run
            : 0;
        rayPath.lineTo(edgeX, focusPointY + rise);
        canvas.drawPath(rayPath, rayPaint);
      }
    }
  }

  void _drawOpticalTelemetryOverlay(Canvas canvas, double entranceAperture) {
    final double dynamicFocalLengthMm = focalMultiplier * 50.0;
    final double clearApertureMm = entranceAperture * 0.4;
    final double fNumber = clearApertureMm > 0
        ? (dynamicFocalLengthMm / clearApertureMm)
        : 0.0;
    final String telemetryString =
        'ACTIVE PROFILE: $activePresetLabel\n'
        '───────────────────────────────────\n'
        'Focal Length   : ${dynamicFocalLengthMm.toStringAsFixed(1)} mm\n'
        'Clear Aperture : ${clearApertureMm.toStringAsFixed(1)} mm\n'
        'Aperture Ratio : f / ${fNumber.toStringAsFixed(2)}\n'
        'AR Filter State: ${enableArCoating ? "ACTIVE" : "OFF"}';
    final TextSpan textSpan = TextSpan(
      text: telemetryString,
      style: TextStyle(
        color: enableArCoating ? Colors.purpleAccent : Colors.greenAccent,
        fontSize: 11,
        fontFamily: 'monospace',
        height: 1.4,
      ),
    );
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, const Offset(12, 12));
  }

  @override
  bool shouldRepaint(covariant PureRayTracerPainter oldDelegate) {
    return oldDelegate.lenses != lenses ||
        oldDelegate.rayCount != rayCount ||
        oldDelegate.focalMultiplier != focalMultiplier ||
        oldDelegate.enableArCoating != enableArCoating ||
        oldDelegate.activePresetLabel != activePresetLabel;
  }
}
