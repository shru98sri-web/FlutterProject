import 'package:flutter/material.dart';

void main() {
  runApp(const QuantumCommutationApp());
}

class QuantumCommutationApp extends StatelessWidget {
  const QuantumCommutationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Mechanics Visualizer',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
      ),
      home: const CommutationVisualizer(),
    );
  }
}

class CommutationVisualizer extends StatefulWidget {
  const CommutationVisualizer({super.key});

  @override
  State<CommutationVisualizer> createState() => _CommutationVisualizerState();
}

class _CommutationVisualizerState extends State<CommutationVisualizer> {
  bool _commutes = true;
  String _currentSystem =
      'Compatible Observables (e.g., Position X & Position Y)';

  // Mock state vectors representing the wavefunction transformation
  final List<double> _initialWave = [0.1, 0.3, 0.7, 0.9, 0.7, 0.3, 0.1];
  List<double> _qhResult = [0.1, 0.3, 0.7, 0.9, 0.7, 0.3, 0.1];
  List<double> _hqResult = [0.1, 0.3, 0.7, 0.9, 0.7, 0.3, 0.1];

  void _updateSystem(bool commutes) {
    setState(() {
      _commutes = commutes;
      if (_commutes) {
        _currentSystem =
            'Compatible Observables (e.g., Position X & Position Y)';
        _qhResult = List.from(_initialWave);
        _hqResult = List.from(_initialWave);
      } else {
        _currentSystem =
            'Incompatible Observables (e.g., Position X & Momentum P)';
        // Simulate quantum uncertainty shift when operators don't commute
        _qhResult = [0.0, 0.2, 0.5, 0.8, 0.8, 0.5, 0.2];
        _hqResult = [0.2, 0.5, 0.8, 0.8, 0.5, 0.2, 0.0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quantum Commutation: [Q̂, Ĥ] = 0'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Equation Display Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      _commutes ? 'Q̂Ĥ = ĤQ̂' : 'Q̂Ĥ ≠ ĤQ̂',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Courier',
                        color: _commutes
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _commutes
                          ? 'The order of measurement does not matter.'
                          : 'Order matters! Measurement alters the state.',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _updateSystem(true),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Compatible (Commute)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _commutes
                        ? Colors.green.shade800
                        : Colors.grey.shade800,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _updateSystem(false),
                  icon: const Icon(Icons.error),
                  label: const Text('Incompatible (No Commute)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_commutes
                        ? Colors.red.shade800
                        : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Interactive Explanation Panel
            Text(
              'Current Setup: $_currentSystem',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Visualizing the paths
            Row(
              children: [
                Expanded(
                  child: _buildPathCard(
                    'Path 1: Q̂ inside Ĥ',
                    'Apply Ĥ first, then Q̂',
                    _qhResult,
                    Colors.cyan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPathCard(
                    'Path 2: Ĥ inside Q̂',
                    'Apply Q̂ first, then Ĥ',
                    _hqResult,
                    Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Summary text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _commutes
                    ? 'Because [Q̂, Ĥ] = 0, both physical properties can be known simultaneously with absolute precision. They share a common set of eigenstates.'
                    : 'Because [Q̂, Ĥ] ≠ 0, measuring one property destroys the information about the other. This gives rise to the Heisenberg Uncertainty Principle.',
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathCard(
    String title,
    String subtitle,
    List<double> values,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: values.map((val) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 14,
                    height: val * 100,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Wavefunction Profile',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
