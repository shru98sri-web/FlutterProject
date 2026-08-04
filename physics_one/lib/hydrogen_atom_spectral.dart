import 'package:flutter/material.dart';

class SpectralLine {
  final int n1;
  final int n2;
  final double wavelengthNm;
  final String seriesName;
  final String spectralRegion;

  SpectralLine({
    required this.n1,
    required this.n2,
    required this.wavelengthNm,
    required this.seriesName,
    required this.spectralRegion,
  });
}

class HydrogenService {
  // Rydberg Constant in m^-1
  static const double rydbergConstant = 1.0973731568508e7;

  static final Map<int, Map<String, String>> seriesMeta = {
    1: {'name': 'Lyman', 'region': 'Ultraviolet'},
    2: {'name': 'Balmer', 'region': 'Visible'},
    3: {'name': 'Paschen', 'region': 'Infrared'},
    4: {'name': 'Brackett', 'region': 'Far Infrared'},
    5: {'name': 'Pfund', 'region': 'Far Infrared'},
  };

  // Calculates wavelength in nanometers
  double calculateWavelength(int n1, int n2) {
    if (n1 >= n2 || n1 < 1) return 0.0;

    double invWavelength =
        rydbergConstant * ((1 / (n1 * n1)) - (1 / (n2 * n2)));
    double wavelengthMeters = 1 / invWavelength;

    return wavelengthMeters * 1e9; // Convert to nanometers
  }

  // Generates lines for a specified series up to maxN2
  List<SpectralLine> generateSeriesLines(int n1, {int maxN2 = 10}) {
    List<SpectralLine> lines = [];
    final meta = seriesMeta[n1] ?? {'name': 'Unknown', 'region': 'Unknown'};

    for (int n2 = n1 + 1; n2 <= maxN2; n2++) {
      double wl = calculateWavelength(n1, n2);
      lines.add(
        SpectralLine(
          n1: n1,
          n2: n2,
          wavelengthNm: wl,
          seriesName: meta['name']!,
          spectralRegion: meta['region']!,
        ),
      );
    }
    return lines;
  }
}

class SpectrumPainter extends CustomPainter {
  final List<SpectralLine> lines;
  final int selectedSeries;

  SpectrumPainter({required this.lines, required this.selectedSeries});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background boundary container
    final bgPaint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    if (lines.isEmpty) return;

    // Dynamically set min/max scaling range depending on selected spectrum series
    double minWl = lines.first.wavelengthNm;
    double maxWl = lines.last.wavelengthNm;

    // Add extra padding to edges for aesthetics if range is tiny
    if ((maxWl - minWl).abs() < 10) {
      minWl -= 20;
      maxWl += 20;
    }

    for (var line in lines) {
      // Normalize wavelength position to fit horizontal space (0.0 to 1.0)
      double normalizedX = (line.wavelengthNm - minWl) / (maxWl - minWl);
      double xPos = normalizedX * size.width;

      final linePaint = Paint()
        ..color = _getColorForLine(line)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(xPos, 0), Offset(xPos, size.height), linePaint);
    }
  }

  // Approximate physics color representation for the display spectrum
  Color _getColorForLine(SpectralLine line) {
    if (selectedSeries == 1) return Colors.purpleAccent.withOpacity(0.8); // UV
    if (selectedSeries >= 3) return Colors.red.withOpacity(0.4); // IR Spectrum

    // Balmer Series approximations (Visible spectrum)
    double wl = line.wavelengthNm;
    if (wl >= 620 && wl <= 750) return Colors.red;
    if (wl >= 495 && wl < 620) return Colors.cyan;
    if (wl >= 450 && wl < 495) return Colors.blue;
    if (wl >= 380 && wl < 450) return Colors.purple;
    return Colors.purpleAccent;
  }

  @override
  bool shouldRepaint(covariant SpectrumPainter oldDelegate) =>
      oldDelegate.lines != lines ||
      oldDelegate.selectedSeries != selectedSeries;
}

void main() => runApp(const MaterialApp(home: HydrogenSpectrumApp()));

class HydrogenSpectrumApp extends StatefulWidget {
  const HydrogenSpectrumApp({super.key});

  @override
  State<HydrogenSpectrumApp> createState() => _HydrogenSpectrumAppState();
}

class _HydrogenSpectrumAppState extends State<HydrogenSpectrumApp> {
  final HydrogenService _service = HydrogenService();
  int _selectedN1 = 2; // Default to Balmer Series (Visible)
  List<SpectralLine> _currentLines = [];

  @override
  void initState() {
    super.initState();
    _updateSpectrum();
  }

  void _updateSpectrum() {
    setState(() {
      _currentLines = _service.generateSeriesLines(
        _selectedN1,
        maxN2: _selectedN1 + 6,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hydrogen Line Spectra Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dropdown control selector
              DropdownButtonFormField<int>(
                value: _selectedN1,
                decoration: const InputDecoration(
                  labelText: 'Select Spectral Series(n1) ',
                ),
                items: HydrogenService.seriesMeta.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(
                      '${entry.value['name']} Series (To n=${entry.key})',
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    _selectedN1 = val;
                    _updateSpectrum();
                  }
                },
              ),
              const SizedBox(height: 20),

              // Custom Painter Visualization Box
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomPaint(
                  size: const Size(double.infinity, 120),
                  painter: SpectrumPainter(
                    lines: _currentLines,
                    selectedSeries: _selectedN1,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Output Data List
              const Text(
                'Calculated Line Transitions:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _currentLines.length,
                  itemBuilder: (context, index) {
                    final line = _currentLines[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${line.n2}')),
                        title: Text('Transition: n=${line.n2} ➔ n=${line.n1}'),
                        subtitle: Text('Region: ${line.spectralRegion}'),
                        trailing: Text(
                          '${line.wavelengthNm.toStringAsFixed(2)} nm',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
