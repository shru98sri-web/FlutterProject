import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_study/features/lhc_control/domain/models/lhc_state.dart';
import 'package:self_study/features/lhc_control/presentation/controllers/lhc_controller.dart';
import 'package:self_study/features/lhc_control/presentation/widgets/beam_status_card.dart';
import 'package:self_study/features/lhc_control/presentation/widgets/sector_grid_view.dart';
import 'package:self_study/features/lhc_control/presentation/widgets/telemetry_chart.dart';

class LHCControlScreen extends ConsumerWidget {
  const LHCControlScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lhcAsync = ref.watch(lhcControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[950],
      appBar: AppBar(
        title: const Text(
          'LHC MAIN RING CONTROL ENGINE',
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          lhcAsync.when(
            data: (state) => IconButton(
              icon: const Icon(Icons.refresh, color: Colors.blue),
              onPressed: () =>
                  ref.read(lhcControllerProvider.notifier).resetAccelerator(),
            ),
            error: (_, __) => IconButton(
              icon: const Icon(Icons.bolt, color: Colors.amber),
              onPressed: () =>
                  ref.read(lhcControllerProvider.notifier).resetAccelerator(),
            ),
            loading: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: lhcAsync.when(
        data: (lhcState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  color: _getStatusColor(lhcState.status),
                  child: Text(
                    'SYSTEM OPERATIONAL STATE: ${lhcState.status.name.toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BeamStatusCard(
                        title: "BEAM 1 ENERGY",
                        value: "${lhcState.beam1Energy.toStringAsFixed(1)} GeV",
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: BeamStatusCard(
                        title: "BEAM 2 ENERGY",
                        value: "${lhcState.beam2Energy.toStringAsFixed(1)} GeV",
                        color: Colors.purpleAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                BeamStatusCard(
                  title: "LUMINOSITY PERFORMANCE INDICES",
                  value:
                      "${lhcState.luminosity.toStringAsFixed(2)} × 10³⁴ cm⁻²s⁻¹",
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  "BEAM 1 ENERGY RAMP HISTORY PROFILE",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TelemetryChart(historyPoints: lhcState.historyPoints),
                const SizedBox(height: 16),
                const Text(
                  "CRYOGENIC MAGNET SECTOR NODES",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SectorGridView(sectors: lhcState.sectors),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key('emergency_dump_btn'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    ref
                        .read(lhcControllerProvider.notifier)
                        .triggerEmergencyDump();
                  },
                  child: const Text(
                    "EXECUTE INTERLOCK SYSTEM BEAM DUMP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  err.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref
                      .read(lhcControllerProvider.notifier)
                      .resetAccelerator(),
                  child: const Text("RETRY INSTRUMENTATION LINK"),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.cyanAccent),
              const SizedBox(height: 16),
              Text(
                "CONNECTING TO CERN BEAM CONTROL BUS...",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(dynamic status) {
    switch (status) {
      case LHCStatus.injection:
        return Colors.amberAccent;
      case LHCStatus.ramping:
        return Colors.orangeAccent;
      case LHCStatus.stable:
        return Colors.greenAccent;
      case LHCStatus.dumped:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
