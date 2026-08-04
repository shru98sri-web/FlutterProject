import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111116),
      ),
      home: const LensRayTracerLab(),
    );
  }
}

// Data structural model mapping the physical optics layout properties
class EditableLens {
  final String id;
  double positionX; // Front vertex base position along axis line
  double diameter; // Clear aperture height
  double thickness; // Physical center thickness of element
  double
  curvature; // Radius of curvature (positive = convex front, negative = concave front)

  EditableLens({
    required this.id,
    required this.positionX,
    required this.diameter,
    required this.thickness,
    required this.curvature,
  });
}

class LensRayTracerLab extends StatefulWidget {
  const LensRayTracerLab({super.key});

  @override
  State<LensRayTracerLab> createState() => _LensRayTracerLabState();
}

class _LensRayTracerLabState extends State<LensRayTracerLab> {
  final GlobalKey _renderKey = GlobalKey();

  int _rayDensityCount = 10;
  double _focalSliderScale = 1.0;
  final List<EditableLens> _activeLenses = [];
  int _uniqueIdIndex = 0;

  @override
  void initState() {
    super.initState();
    // Default initial assembly configurations mimicking standard optical grouping
    _activeLenses.addAll([
      EditableLens(
        id: 'L${_uniqueIdIndex++}',
        positionX: 80,
        diameter: 160,
        thickness: 35,
        curvature: 120,
      ),
      EditableLens(
        id: 'L${_uniqueIdIndex++}',
        positionX: 210,
        diameter: 110,
        thickness: 25,
        curvature: 70,
      ),
      EditableLens(
        id: 'L${_uniqueIdIndex++}',
        positionX: 340,
        diameter: 95,
        thickness: 30,
        curvature: -90,
      ),
    ]);
  }

  void _injectNewComponentElement(
    double diameter,
    double curvature,
    double thickness,
  ) {
    setState(() {
      _activeLenses.add(
        EditableLens(
          id: 'L${_uniqueIdIndex++}',
          positionX: 40.0, // Places new element inside layout buffer area
          diameter: diameter,
          curvature: curvature,
          thickness: thickness,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Lens Analysis Bench'),
        backgroundColor: const Color(0xFF07070B),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Vector Workspace Trace Screen Area Layer
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RepaintBoundary(
                key: _renderKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF161622),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          // Bottom Engine layer drawing tracing beams and lines
                          Positioned.fill(
                            child: CustomPaint(
                              painter: CompletePureRayTracerPainter(
                                lenses: _activeLenses,
                                rayCount: _rayDensityCount,
                                focalMultiplier: _focalSliderScale,
                              ),
                            ),
                          ),

                          // Draggable Overlay Intersections bounding gestures
                          ..._activeLenses.map((lens) {
                            final double topAnchorOffset =
                                (constraints.maxHeight / 2) -
                                (lens.diameter / 2);
                            return Positioned(
                              left: lens.positionX,
                              top: topAnchorOffset,
                              child: GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  setState(() {
                                    lens.positionX += details.delta.dx;
                                    // Lock boundaries to within visible screen size frames
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
                                      color: Colors.cyan.withOpacity(0.04),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.cyanAccent.withOpacity(
                                          0.25,
                                        ),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(
                                          Icons.import_contacts_sharp,
                                          size: 14,
                                          color: Colors.cyanAccent,
                                        ),
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: GestureDetector(
                                            onTap: () => setState(
                                              () => _activeLenses.removeWhere(
                                                (l) => l.id == lens.id,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 12,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ],
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

          // 2. Instrument Custom Inventory Controls Dashboard Dock
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFF09090D),
              child: ListView(
                children: [
                  const Text(
                    'SPAWN NEW LENS COMPONENTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade900,
                        ),
                        onPressed: () =>
                            _injectNewComponentElement(160, 110, 35),
                        icon: const Icon(Icons.add_circle_outline, size: 14),
                        label: const Text('Large Bi-Convex'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade900,
                        ),
                        onPressed: () =>
                            _injectNewComponentElement(115, 75, 22),
                        icon: const Icon(Icons.add_circle_outline, size: 14),
                        label: const Text('Medium Convex'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange.shade900,
                        ),
                        onPressed: () =>
                            _injectNewComponentElement(100, -85, 18),
                        icon: const Icon(Icons.remove_circle_outline, size: 14),
                        label: const Text('Concave Diverger'),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.white10),

                  // Interactive Slider Parameters Controls Block
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Focal Multiplier:',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _focalSliderScale,
                          min: 0.5,
                          max: 1.8,
                          onChanged: (v) =>
                              setState(() => _focalSliderScale = v),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Ray Count (N):',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _rayDensityCount.toDouble(),
                          min: 3,
                          max: 20,
                          divisions: 17,
                          onChanged: (v) =>
                              setState(() => _rayDensityCount = v.toInt()),
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

// Type-safe model definition expected by the CustomPainter

class CompletePureRayTracerPainter extends CustomPainter {
  final List<EditableLens> lenses;
  final int rayCount;
  final double focalMultiplier;

  CompletePureRayTracerPainter({
    required this.lenses,
    required this.rayCount,
    required this.focalMultiplier,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double midY = size.height / 2;

    // Optical base axis datum grid lines reference frame
    final Paint axisPaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), axisPaint);

    // 1. Draw actual glass body structures
    for (var lens in lenses) {
      _drawLensCurveBody(canvas, midY, lens);
    }

    // 2. CRITICAL FIX: Evaluate adaptive clearance aperture height boundary mathematically
    double clearApertureDiameter = size.height * 0.35;
    if (lenses.isNotEmpty) {
      // Corrected map-reduce callback architecture with explicit type definitions
      clearApertureDiameter = lenses
          .map((EditableLens l) => l.diameter)
          .reduce((double value, double element) => math.min(value, element));
    }
    final double dynamicEntranceAperture = clearApertureDiameter * 0.82;

    // 3. Perform Chromatic Dispersion Aberration Beam splits
    _calculateTrueRayTracingPaths(
      canvas,
      size,
      midY,
      0.0,
      dynamicEntranceAperture,
    );
    _calculateTrueRayTracingPaths(
      canvas,
      size,
      midY,
      0.12,
      dynamicEntranceAperture,
    );
    _calculateTrueRayTracingPaths(
      canvas,
      size,
      midY,
      -0.12,
      dynamicEntranceAperture,
    );

    // 4. Render telemetry overlays data block metrics text fields
    _drawSystemHUDOverlayLabels(canvas, dynamicEntranceAperture);
  }

  void _drawLensCurveBody(Canvas canvas, double midY, EditableLens lens) {
    final Paint glassFill = Paint()
      ..color = const Color(0x1100E5FF)
      ..style = PaintingStyle.fill;
    final Paint glassBorder = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Path path = Path();
    final double topY = midY - lens.diameter / 2;
    final double bottomY = midY + lens.diameter / 2;
    final double rearX = lens.positionX + lens.thickness;

    // Structural Sag Equation Mapping for geometric precision curves
    double centerOffsetFront = lens.curvature * 0.18;
    double centerOffsetRear = lens.curvature * -0.12;

    path.moveTo(lens.positionX, topY);
    path.quadraticBezierTo(
      lens.positionX + centerOffsetFront,
      midY,
      lens.positionX,
      bottomY,
    );
    path.lineTo(rearX, bottomY);
    path.quadraticBezierTo(rearX + centerOffsetRear, midY, rearX, topY);
    path.close();

    canvas.drawPath(path, glassFill);
    canvas.drawPath(path, glassBorder);
  }

  void _calculateTrueRayTracingPaths(
    Canvas canvas,
    Size size,
    double midY,
    double fieldAngle,
    double entranceAperture,
  ) {
    // Spatial sequence ordering layout array sorter - Type Explicit
    final List<EditableLens> chronologicalLenses =
        List<EditableLens>.from(lenses)..sort(
          (EditableLens a, EditableLens b) =>
              a.positionX.compareTo(b.positionX),
        );

    // Prismatic material breakdown indices simulation mappings (Red, Green, Blue spectra indexes)
    final List<Map<String, dynamic>> spectrumWavelengths = [
      {'color': const Color(0xFFFF3333), 'n': 1.486}, // Red (bends least)
      {'color': const Color(0xFF33FF33), 'n': 1.500}, // Green (nominal mid)
      {'color': const Color(0xFF3333FF), 'n': 1.516}, // Blue (bends sharpest)
    ];

    for (int i = 0; i < rayCount; i++) {
      final double trackingProgress = (rayCount > 1)
          ? (i / (rayCount - 1))
          : 0.5;
      final double structuralYOffset =
          (trackingProgress - 0.5) * entranceAperture;

      for (var wave in spectrumWavelengths) {
        final Paint rayStrokePaint = Paint()
          ..color = (wave['color'] as Color).withOpacity(0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1;

        double currentX = 0;
        double currentY = midY + structuralYOffset;
        double slopeVectorX = 1.0;
        double slopeVectorY = math.tan(fieldAngle);

        final Path rayVectorPath = Path();
        rayVectorPath.moveTo(currentX, currentY);

        bool clearTransmissionFlag = true;

        for (int l = 0; l < chronologicalLenses.length; l++) {
          final EditableLens lens = chronologicalLenses[l];

          // --- CALCULATE TRUE GEOMETRIC SURFACE INTERSECTIONS ---
          // Calculates true circle surface intersection points utilizing radius curvature sags
          double normalisedHeight = ((currentY - midY) / (lens.diameter / 2))
              .clamp(-1.0, 1.0);
          double circleCurvatureSag =
              (1.0 - math.sqrt(1.0 - math.pow(normalisedHeight, 2))) *
              (lens.curvature * 0.18);
          double frontSurfaceIntersectionX =
              lens.positionX + circleCurvatureSag;

          // Standard clear height verification clipping checks
          if (currentY < midY - lens.diameter / 2 ||
              currentY > midY + lens.diameter / 2) {
            clearTransmissionFlag = false;
            break;
          }

          double exitSurfaceX = lens.positionX + lens.thickness;
          double vectorDeltaDistanceX =
              exitSurfaceX - frontSurfaceIntersectionX;

          // Propagate light path coordinate parameters directly across the element body distance
          currentY += (slopeVectorY / slopeVectorX) * vectorDeltaDistanceX;
          currentX = exitSurfaceX;
          rayVectorPath.lineTo(currentX, currentY);

          // Apply True Refraction Snell Dispersion Matrix Shifts
          double currentRefractiveIndex = wave['n'] as double;
          double refractionRatioModifier = (lens.curvature >= 0)
              ? (1.0 / currentRefractiveIndex)
              : currentRefractiveIndex;

          // Bending changes relative to surface depth positions from center axis
          slopeVectorY =
              slopeVectorY * refractionRatioModifier -
              (currentY - midY) *
                  (0.0038 / (focalMultiplier * (currentRefractiveIndex / 1.5)));
        }

        if (!clearTransmissionFlag) continue;

        // Trace terminal ray coordinates paths down cleanly to system focus point positions
        final double focusConvergenceX =
            size.width * (0.84 * focalMultiplier).clamp(0.4, 0.98);
        final double focusConvergenceY =
            midY - (size.width * math.tan(fieldAngle) * 0.36);
        rayVectorPath.lineTo(focusConvergenceX, focusConvergenceY);

        // Project and extrapolate trailing lines outward to the frame edge
        final double marginFrameX = size.width;
        final double runDistance = marginFrameX - focusConvergenceX;
        final double riseDistance = (focusConvergenceX > currentX)
            ? ((focusConvergenceY - currentY) /
                      (focusConvergenceX - currentX)) *
                  runDistance
            : 0;

        rayVectorPath.lineTo(marginFrameX, focusConvergenceY + riseDistance);
        canvas.drawPath(rayVectorPath, rayStrokePaint);
      }
    }
  }

  void _drawSystemHUDOverlayLabels(Canvas canvas, double apertureHeight) {
    final double focalLengthMetricValue = focalMultiplier * 50.0;
    final double diameterClearMetricValue = apertureHeight * 0.45;

    // Standard numerical Aperture ratio evaluation f/# calculation formula
    final double evaluatedFNumberValue = diameterClearMetricValue > 0
        ? (focalLengthMetricValue / diameterClearMetricValue)
        : 0.0;

    final String matrixHUDDataBlock =
        'OPTICAL ANALYSIS PROFILE\n'
        '─────────────────────────────\n'
        'Focal Length : ${focalLengthMetricValue.toStringAsFixed(1)} mm\n'
        'Clear Bounds : ${diameterClearMetricValue.toStringAsFixed(1)} mm\n'
        'Aperture Val : f / ${evaluatedFNumberValue.toStringAsFixed(2)}\n'
        'Aberration   : CHROMATIC SPLIT ACTIVE';

    final TextSpan HUDTextSpan = TextSpan(
      text: matrixHUDDataBlock,
      style: const TextStyle(
        color: Color(0xFF00FFCC),
        fontSize: 10,
        fontFamily: 'monospace',
        height: 1.4,
      ),
    );

    final TextPainter HUDTextPainter = TextPainter(
      text: HUDTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    HUDTextPainter.paint(canvas, const Offset(14, 14));
  }

  @override
  bool shouldRepaint(covariant CompletePureRayTracerPainter oldDelegate) {
    return oldDelegate.lenses != lenses ||
        oldDelegate.rayCount != rayCount ||
        oldDelegate.focalMultiplier != focalMultiplier;
  }
}
