import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: CelestialCatalogPage()));

class CelestialCatalogPage extends StatefulWidget {
  const CelestialCatalogPage({super.key});

  @override
  State<CelestialCatalogPage> createState() => _CelestialCatalogPageState();
}

class _CelestialCatalogPageState extends State<CelestialCatalogPage> {
  bool _showRashis = true; // Toggle between Rashis and Nakshatras

  // 12 Rashis with distinct custom relative star node maps (x, y offsets between -1 and 1)
  final List<CelestialItem> _rashis = [
    CelestialItem('Mesha (Aries)', [const Offset(-0.6, -0.2), const Offset(0.0, 0.2), const Offset(0.6, 0.0)]),
    CelestialItem('Vrishabha (Taurus)', [const Offset(-0.6, -0.6), const Offset(-0.1, -0.1), const Offset(0.5, 0.1), const Offset(-0.2, 0.4), const Offset(0.4, -0.5)]),
    CelestialItem('Mithuna (Gemini)', [const Offset(-0.4, -0.5), const Offset(-0.4, 0.5), const Offset(0.4, -0.5), const Offset(0.4, 0.5), const Offset(-0.4, 0.0), const Offset(0.4, 0.0)]),
    CelestialItem('Karka (Cancer)', [const Offset(0.0, -0.6), const Offset(0.0, 0.0), const Offset(-0.5, 0.5), const Offset(0.5, 0.5)]),
    CelestialItem('Simha (Leo)', [const Offset(0.6, 0.4), const Offset(0.2, 0.2), const Offset(0.0, -0.3), const Offset(-0.5, -0.4), const Offset(-0.6, 0.1), const Offset(-0.2, 0.5)]),
    CelestialItem('Kanya (Virgo)', [const Offset(-0.6, 0.4), const Offset(-0.2, 0.1), const Offset(0.1, -0.3), const Offset(0.6, -0.4), const Offset(0.0, 0.5), const Offset(0.4, 0.3)]),
    CelestialItem('Tula (Libra)', [const Offset(0.0, -0.6), const Offset(-0.5, 0.0), const Offset(0.5, 0.0), const Offset(0.0, 0.6)]),
    CelestialItem('Vrishchika (Scorpio)', [const Offset(-0.6, -0.4), const Offset(-0.2, -0.3), const Offset(0.2, 0.0), const Offset(0.4, 0.4), const Offset(0.1, 0.6), const Offset(-0.2, 0.5)]),
    CelestialItem('Dhanu (Sagittarius)', [const Offset(-0.5, -0.5), const Offset(0.0, -0.6), const Offset(0.5, -0.3), const Offset(0.2, 0.2), const Offset(-0.3, 0.5)]),
    CelestialItem('Makara (Capricorn)', [const Offset(-0.6, -0.4), const Offset(0.6, -0.4), const Offset(0.2, 0.5), const Offset(-0.4, 0.3)]),
    CelestialItem('Kumbha (Aquarius)', [const Offset(-0.6, 0.5), const Offset(-0.2, 0.1), const Offset(0.2, 0.2), const Offset(0.5, -0.4), const Offset(0.1, -0.5)]),
    CelestialItem('Meena (Pisces)', [const Offset(-0.6, -0.5), const Offset(-0.2, -0.1), const Offset(0.4, 0.1), const Offset(0.6, 0.6), const Offset(0.1, 0.4)]),
  ];

  // 27 Nakshatras with unique structural vector paths
  final List<CelestialItem> _nakshatras = [
    CelestialItem('Ashwini', [const Offset(-0.5, 0.0), const Offset(0.5, 0.0)]),
    CelestialItem('Bharani', [const Offset(-0.5, -0.4), const Offset(0.5, -0.4), const Offset(0.0, 0.5)]),
    CelestialItem('Krittika', [const Offset(-0.5, -0.3), const Offset(-0.2, 0.2), const Offset(0.1, -0.4), const Offset(0.5, 0.3)]),
    CelestialItem('Rohini', [const Offset(0.0, -0.5), const Offset(-0.5, 0.2), const Offset(0.5, 0.2), const Offset(0.0, 0.6)]),
    CelestialItem('Mrigashira', [const Offset(-0.4, -0.4), const Offset(0.4, -0.4), const Offset(0.4, 0.4), const Offset(-0.4, 0.4)]),
    CelestialItem('Ardra', [const Offset(0.0, 0.0)]),
    CelestialItem('Punarvasu', [const Offset(-0.5, -0.2), const Offset(0.0, 0.4), const Offset(0.5, -0.2)]),
    CelestialItem('Pushya', [const Offset(-0.4, 0.3), const Offset(0.0, -0.4), const Offset(0.4, 0.3)]),
    CelestialItem('Ashlesha', [const Offset(-0.6, -0.2), const Offset(-0.2, 0.3), const Offset(0.2, -0.3), const Offset(0.6, 0.2)]),
    CelestialItem('Magha', [const Offset(-0.5, 0.5), const Offset(-0.2, -0.1), const Offset(0.3, -0.4), const Offset(0.5, 0.2)]),
    CelestialItem('Purva Phalguni', [const Offset(-0.4, -0.3), const Offset(0.4, -0.3), const Offset(0.0, 0.4)]),
    CelestialItem('Uttara Phalguni', [const Offset(-0.3, 0.4), const Offset(0.3, 0.4), const Offset(0.0, -0.4)]),
    CelestialItem('Hasta', [const Offset(-0.5, -0.5), const Offset(0.5, -0.5), const Offset(0.5, 0.3), const Offset(-0.5, 0.3), const Offset(0.0, 0.7)]),
    CelestialItem('Chitra', [const Offset(0.0, 0.0)]),
    CelestialItem('Swati', [const Offset(0.0, 0.0)]),
    CelestialItem('Vishakha', [const Offset(-0.4, -0.4), const Offset(0.4, -0.4), const Offset(-0.2, 0.4), const Offset(0.2, 0.4)]),
    CelestialItem('Anuradha', [const Offset(-0.5, 0.0), const Offset(0.0, 0.0), const Offset(0.5, 0.0)]),
    CelestialItem('Jyeshtha', [const Offset(-0.5, -0.5), const Offset(0.0, 0.0), const Offset(0.5, 0.5)]),
    CelestialItem('Mula', [const Offset(-0.4, -0.4), const Offset(0.0, -0.2), const Offset(0.4, 0.2), const Offset(0.2, 0.6)]),
    CelestialItem('Purva Ashadha', [const Offset(-0.3, -0.3), const Offset(0.3, -0.3), const Offset(0.0, 0.4)]),
    CelestialItem('Uttara Ashadha', [const Offset(-0.3, 0.4), const Offset(0.3, 0.4), const Offset(0.0, -0.4)]),
    CelestialItem('Shravana', [const Offset(-0.5, 0.0), const Offset(0.0, 0.4), const Offset(0.5, 0.0)]),
    CelestialItem('Dhanishta', [const Offset(0.0, -0.5), const Offset(-0.4, 0.0), const Offset(0.4, 0.0), const Offset(0.0, 0.5)]),
    CelestialItem('Shatabhisha', [const Offset(0.0, 0.0)]), // Large cluster represented simply
    CelestialItem('Purva Bhadrapada', [const Offset(-0.4, -0.4), const Offset(0.4, -0.4)]),
    CelestialItem('Uttara Bhadrapada', [const Offset(-0.4, 0.4), const Offset(0.4, 0.4)]),
    CelestialItem('Revati', [const Offset(-0.6, -0.4), const Offset(-0.2, 0.1), const Offset(0.3, -0.1), const Offset(0.6, 0.5)]),
  ];

  @override
  Widget build(BuildContext context) {
    final activeList = _showRashis ? _rashis : _nakshatras;

    return Scaffold(
      backgroundColor: const Color(0xFF02020D),
      appBar: AppBar(
        title: const Text('Celestial Star Formations', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF0A0A23),
        elevation: 0,
        actions: [
          Row(
            children: [
              const Text("Nakshatras", style: TextStyle(color: Colors.white70, fontSize: 12)),
              Switch(
                value: _showRashis,
                activeColor: Colors.cyanAccent,
                inactiveTrackColor: Colors.indigo.shade900,
                onChanged: (val) => setState(() => _showRashis = val),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Text("Rashis", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: activeList.length,
        itemBuilder: (context, index) {
          final item = activeList[index];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A23),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withValues(alpha: 0.3), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CustomPaint(
                      painter: ConstellationGraphPainter(stars: item.stars),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CelestialItem {
  final String name;
  final List<Offset> stars;
  CelestialItem(this.name, this.stars);
}

class ConstellationGraphPainter extends CustomPainter {
final List<Offset> stars;
ConstellationGraphPainter({required this.stars});

@override
void paint(Canvas canvas, Size size) {
final center = Offset(size.width / 2, size.height / 2);
final radius = math.min(size.width, size.height) / 2;

// Background Subtle Coordinate Grid lines
final gridPaint = Paint()
..color = Colors.white10
..style = PaintingStyle.stroke
..strokeWidth = 0.5;
canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), gridPaint);
canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), gridPaint);
canvas.drawCircle(center, radius * 0.5, gridPaint);

if (stars.isEmpty) return;

// Convert relative coordinates (-1 to 1) to canvas layout pixel spacing
List<Offset> points = stars.map((offset) {
return Offset(
center.dx + (offset.dx * radius),
center.dy + (offset.dy * radius),
);
}).toList();

// Painting paths connecting star coordinates
final pathPaint = Paint()
..color = Colors.cyan.withValues(alpha: 0.5)
..style = PaintingStyle.stroke
..strokeWidth = 1.2;

if (points.length > 1) {
for (int i = 0; i < points.length - 1; i++) {
canvas.drawLine(points[i], points[i + 1], pathPaint);
}
}

// Painting individual star nodes
final starPaint = Paint()
..color = Colors.amberAccent
..style = PaintingStyle.fill;

for (var point in points) {
// Outer glow
canvas.drawCircle(point, 4.0, Paint()..color = Colors.amber.withValues(alpha: 0.3));// Core star point
 canvas.drawCircle(point, 1.8, starPaint);}}
@override
bool shouldRepaint(covariant ConstellationGraphPainter oldDelegate) => false;}