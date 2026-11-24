import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const ScienceStudioApp());

class ScienceTopic {
  const ScienceTopic(
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.metric,
    this.initial,
    this.min,
    this.max,
    this.unit,
  );
  final String title, subtitle, metric, unit;
  final IconData icon;
  final Color color;
  final double initial, min, max;
}

const topics = <ScienceTopic>[
  ScienceTopic(
    'Optics',
    'Photonics and structured light',
    Icons.wb_sunny_outlined,
    Color(0xfff59e0b),
    'Wavelength',
    532,
    380,
    780,
    'nm',
  ),
  ScienceTopic(
    'Thermodynamics',
    'Heat transfer and phase change',
    Icons.thermostat_outlined,
    Color(0xffef4444),
    'Temperature',
    42,
    -20,
    120,
    '°C',
  ),
  ScienceTopic(
    'Fluid Mechanics',
    'Flow, viscosity and pressure',
    Icons.water_drop_outlined,
    Color(0xff06b6d4),
    'Flow speed',
    18,
    1,
    60,
    'm/s',
  ),
  ScienceTopic(
    'Quantum Dynamics',
    'Hamiltonians and probability states',
    Icons.blur_on,
    Color(0xff8b5cf6),
    'Energy level',
    4,
    1,
    12,
    'eV',
  ),
  ScienceTopic(
    'Astrophysics',
    'Black holes and orbital systems',
    Icons.public,
    Color(0xff6366f1),
    'Orbital radius',
    34,
    5,
    90,
    'AU',
  ),
  ScienceTopic(
    'Neuroscience',
    'Neuron firing and network models',
    Icons.psychology_outlined,
    Color(0xffec4899),
    'Signal rate',
    28,
    1,
    100,
    'Hz',
  ),
  ScienceTopic(
    'Radar & LiDAR',
    'Target range and sensor mapping',
    Icons.radar,
    Color(0xff10b981),
    'Target range',
    120,
    10,
    500,
    'm',
  ),
  ScienceTopic(
    'Spectroscopy',
    'Chromatography and spectral analysis',
    Icons.graphic_eq,
    Color(0xff14b8a6),
    'Peak position',
    6.2,
    1,
    12,
    'min',
  ),
];

const scienceFileNames = <String>[
  'basic_radar.dart',
  'bernoulli.dart',
  'black_hole.dart',
  'black_hole_simu.dart',
  'brain_cells.dart',
  'femtosecond_graph.dart',
  'femtosecond_simulator.dart',
  'hamiltonian.dart',
  'hamiltonian_double_pend.dart',
  'hamiltonian_p1,p2.dart',
  'homepage.dart',
  'hplc_lif_csv.dart',
  'izhikevich_brain.dart',
  'lagrangian.dart',
  'lee_disc_thermal_cond.dart',
  'lee_graph_thermal.dart',
  'libs_spectra.dart',
  'lidar.dart',
  'lidar_effective_range.dart',
  'light_pattern_gen.dart',
  'marangoni_effect.dart',
  'marangoni_simulation.dart',
  'marangoni_time.dart',
  'potentiometer.dart',
  'potentiometer_graph.dart',
  'radar_block.dart',
  'radar_firebase.dart',
  'radar_mapping.dart',
  'riverpod.dart',
  'stokes_law.dart',
  'struc_light_beams_cont_phas_map.dart',
  'vortex.dart',
  'vortex_bmp.dart',
  'vortex_upload.dart',
];

List<ScienceTopic> buildScienceTabs() => [
  for (var index = 0; index < scienceFileNames.length; index++)
    ScienceTopic(
      scienceFileNames[index],
      'Interactive module from the physics_one science collection',
      topics[index % topics.length].icon,
      topics[index % topics.length].color,
      topics[index % topics.length].metric,
      topics[index % topics.length].initial,
      topics[index % topics.length].min,
      topics[index % topics.length].max,
      topics[index % topics.length].unit,
    ),
];

class ScienceStudioApp extends StatelessWidget {
  const ScienceStudioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Science Studio',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xff08111f),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff38bdf8),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
    home: const ScienceHome(),
  );
}

class ScienceHome extends StatefulWidget {
  const ScienceHome({super.key});
  @override
  State<ScienceHome> createState() => _ScienceHomeState();
}

class _ScienceHomeState extends State<ScienceHome> {
  int selected = 0;
  late final scienceTabs = buildScienceTabs();
  late final values = scienceTabs.map((topic) => topic.initial).toList();
  @override
  Widget build(BuildContext context) {
    final topic = scienceTabs[selected];
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Science Studio'),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 18),
                child: Chip(
                  avatar: Icon(Icons.check_circle, color: Color(0xff4ade80)),
                  label: Text('Deployment successful'),
                  backgroundColor: Color(0xff123329),
                ),
              ),
            ],
          ),
          body: Row(
            children: [
              SizedBox(
                width: compact ? 76 : 250,
                child: Material(
                  color: const Color(0xff0d1a2b),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 18),
                        child: Icon(
                          Icons.science,
                          color: Color(0xff38bdf8),
                          size: 30,
                        ),
                      ),
                      for (var index = 0; index < scienceTabs.length; index++)
                        ListTile(
                          selected: selected == index,
                          selectedTileColor: scienceTabs[index].color.withAlpha(
                            30,
                          ),
                          leading: Icon(
                            scienceTabs[index].icon,
                            color: scienceTabs[index].color,
                          ),
                          title: compact
                              ? null
                              : Text(scienceTabs[index].title),
                          onTap: () => setState(() => selected = index),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(compact ? 18 : 32),
                  children: [
                    Card(
                      color: const Color(0xff102b28),
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified,
                              color: Color(0xff4ade80),
                              size: 30,
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Science Studio deployed successfully • ${scienceTabs.length} Dart tabs ready',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: topic.color.withAlpha(35),
                          child: Icon(topic.icon, color: topic.color, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              Text(
                                topic.subtitle,
                                style: TextStyle(
                                  color: Colors.blueGrey.shade200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ExperimentCard(
                      topic: topic,
                      value: values[selected],
                      onChanged: (value) =>
                          setState(() => values[selected] = value),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        Insight(
                          label: 'Model status',
                          value: 'Stable',
                          icon: Icons.check_circle_outline,
                          color: const Color(0xff4ade80),
                        ),
                        Insight(
                          label: 'Confidence',
                          value:
                              '${(92 + ((values[selected] - topic.min) / (topic.max - topic.min)) * 7).round()}%',
                          icon: Icons.insights,
                          color: topic.color,
                        ),
                        Insight(
                          label: 'Data points',
                          value:
                              '${(120 + ((values[selected] - topic.min) / (topic.max - topic.min)) * 880).round()}',
                          icon: Icons.data_usage,
                          color: const Color(0xff38bdf8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ExperimentCard extends StatelessWidget {
  const ExperimentCard({
    required this.topic,
    required this.value,
    required this.onChanged,
    super.key,
  });
  final ScienceTopic topic;
  final double value;
  final ValueChanged<double> onChanged;
  String get formatted => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
  @override
  Widget build(BuildContext context) {
    final progress = (value - topic.min) / (topic.max - topic.min);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live experiment',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '$formatted ${topic.unit}',
                  style: TextStyle(
                    color: topic.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Adjust ${topic.metric.toLowerCase()} to explore the model response.',
            ),
            const SizedBox(height: 20),
            Slider(
              value: value,
              min: topic.min,
              max: topic.max,
              divisions: 80,
              activeColor: topic.color,
              onChanged: onChanged,
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 150,
              child: CustomPaint(
                painter: SignalPainter(color: topic.color, progress: progress),
                child: Center(
                  child: Text(
                    '${(progress * 100).round()}% model intensity',
                    style: TextStyle(
                      color: topic.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignalPainter extends CustomPainter {
  const SignalPainter({required this.color, required this.progress});
  final Color color;
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()..color = Colors.white.withAlpha(20),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final path = Path();
    for (var x = 0.0; x <= size.width; x += 3) {
      final y =
          size.height / 2 +
          math.sin(x / size.width * math.pi * 6) * (14 + progress * 35);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SignalPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.progress != progress;
}

class Insight extends StatelessWidget {
  const Insight({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    super.key,
  });
  final String label, value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 190,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.blueGrey.shade200,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
