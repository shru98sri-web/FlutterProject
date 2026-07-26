import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const LHCCentralControlApp());
}

class LHCCentralControlApp extends StatelessWidget {
  const LHCCentralControlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LHC Central Control',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E6FF),
          secondary: Color(0xFF00FF66),
          surface: Color(0xFF141D33),
          error: Color(0xFFFF3366),
        ),
      ),
      home: const LHCDashboardPage(),
    );
  }
}

class LHCDashboardPage extends StatefulWidget {
  const LHCDashboardPage({Key? key}) : super(key: key);

  @override
  State<LHCDashboardPage> createState() => _LHCDashboardPageState();
}

class _LHCDashboardPageState extends State<LHCDashboardPage> {
  late Timer _telemetryTimer;
  final Random _rand = Random();

  final List<Map<String, dynamic>> _sectors = [
    {'name': 'Sector 1-2 (ATLAS)', 'temp': 1.9, 'status': 'Stable'},
    {'name': 'Sector 2-3 (ALICE)', 'temp': 1.9, 'status': 'Stable'},
    {'name': 'Sector 3-4 (RF Cav)', 'temp': 4.5, 'status': 'Ramping'},
    {'name': 'Sector 4-5 (CMS)', 'temp': 1.85, 'status': 'Stable'},
    {'name': 'Sector 5-6 (TOTEM)', 'temp': 1.9, 'status': 'Stable'},
    {'name': 'Sector 6-7 (LHCb)', 'temp': 1.91, 'status': 'Stable'},
    {'name': 'Sector 7-8 (Collim)', 'temp': 2.1, 'status': 'Stable'},
    {'name': 'Sector 8-1 (Injection)', 'temp': 1.9, 'status': 'Stable'},
  ];

  double _beam1Energy = 0.0;
  double _beam2Energy = 0.0;
  double _luminosity = 0.0;
  final List<FlSpot> _energyHistory = [];
  int _tickCount = 0;
  String _lhcStatusText = "INJECTION PROT";
  Color _statusColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 20; i++) {
      _energyHistory.add(FlSpot(i.toDouble(), 0.45));
    }
    _startSimulatedStream();
  }

  void _startSimulatedStream() {
    _telemetryTimer = Timer.periodic(const Duration(milliseconds: 800), (
      timer,
    ) {
      if (!mounted) return;
      setState(() {
        _tickCount++;

        if (_tickCount % 60 < 20) {
          _lhcStatusText = "RAMPING BEAM";
          _statusColor = const Color(0xFF00E6FF);
          _beam1Energy = min(6.8, _beam1Energy + _rand.nextDouble() * 0.4);
          _beam2Energy = min(6.8, _beam2Energy + _rand.nextDouble() * 0.4);
          _luminosity = max(0.0, _luminosity - 5.0);
        } else if (_tickCount % 60 < 50) {
          _lhcStatusText = "STABLE BEAMS";
          _statusColor = const Color(0xFF00FF66);
          _beam1Energy = 6.8 + (_rand.nextDouble() * 0.002 - 0.001);
          _beam2Energy = 6.8 + (_rand.nextDouble() * 0.002 - 0.001);
          _luminosity = 18000.0 + _rand.nextDouble() * 1500.0;
        } else {
          _lhcStatusText = "BEAM DUMP CYCLE";
          _statusColor = const Color(0xFFFF3366);
          _beam1Energy = max(0.45, _beam1Energy - 1.5);
          _beam2Energy = max(0.45, _beam2Energy - 1.5);
          _luminosity = 0.0;
        }

        for (var sector in _sectors) {
          double fluctuation = (_rand.nextDouble() - 0.5) * 0.04;
          sector['temp'] = (sector['temp'] + fluctuation).clamp(1.8, 4.8);
        }

        _energyHistory.removeAt(0);
        for (int i = 0; i < _energyHistory.length; i++) {
          _energyHistory[i] = FlSpot(i.toDouble(), _energyHistory[i].y);
        }
        _energyHistory.add(FlSpot(19.0, _beam1Energy));
      });
    });
  }

  @override
  void dispose() {
    _telemetryTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LHC CONTROL ROOM'),
        backgroundColor: const Color(0xFF0D1424),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _statusColor, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              _lhcStatusText,
              style: TextStyle(
                color: _statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildPrimaryDashboardPanel()),
                Expanded(flex: 2, child: _buildCryogenicSectorGrid()),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildPrimaryDashboardPanel(),
                  _buildCryogenicSectorGrid(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPrimaryDashboardPanel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ACCELERATOR SYNC TELEMETRY",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTelemetryCard(
                  "BEAM 1 ENERGY",
                  "${_beam1Energy.toStringAsFixed(2)} TeV",
                  const Color(0xFF00E6FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTelemetryCard(
                  "BEAM 2 ENERGY",
                  "${_beam2Energy.toStringAsFixed(2)} TeV",
                  const Color(0xFFFFB300),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTelemetryCard(
                  "INST. LUMINOSITY",
                  "${_luminosity.toStringAsFixed(1)} Hz/ub",
                  const Color(0xFF00FF66),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTelemetryCard(
                  "RING VACUUM STABILITY",
                  "1.3 x 10^-10 mbar",
                  Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "MAIN RING RAMP PROFILE (BEAM 1)",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 220,
            padding: const EdgeInsets.fromLTRB(12, 24, 24, 8),
            decoration: BoxDecoration(
              color: const Color(0xFF141D33),
              borderRadius: BorderRadius.circular(8),
            ),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                titlesData: const FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 8,
                lineBarsData: [
                  LineChartBarData(
                    spots: _energyHistory,
                    isCurved: true,
                    color: const Color(0xFF00E6FF),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF00E6FF).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryogenicSectorGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SUPERCONDUCTING MAGNET CRYOGENICS (HELIUM)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sectors.length,
            itemBuilder: (context, index) {
              final sector = _sectors[index];
              final double temp = sector['temp'];
              final bool isOverheating =
                  temp > 4.0 && !sector['name'].contains('RF Cav');

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(
                    Icons.ac_unit,
                    color: isOverheating
                        ? Colors.redAccent
                        : const Color(0xFF00FF66),
                  ),
                  title: Text(
                    sector['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: const Text(
                    "Core Temperature validation check active",
                  ),
                  trailing: Text(
                    "${temp.toStringAsFixed(2)} K",
                    style: TextStyle(
                      color: isOverheating
                          ? Colors.redAccent
                          : const Color(0xFF00E6FF),
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryCard(String label, String value, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141D33),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
