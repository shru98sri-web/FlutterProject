import 'dart:math';

import 'package:self_study/features/lhc_control/domain/models/lhc_state.dart';
import 'package:self_study/features/lhc_control/domain/models/sector_telemetry.dart';

abstract class LHCRemoteDataSource {
  Future<LHCState> getLatestControlRoomData();
}

class LHCRemoteDataSourceImpl implements LHCRemoteDataSource {
  @override
  Future<LHCState> getLatestControlRoomData() async {
    // Simulating remote HTTP REST API / WebSocket connection delay to CERN infrastructure
    await Future.delayed(const Duration(seconds: 2));

    // Simulate a hardware database network exception occasionally for verification (e.g., 10% chance)
    if (Random().nextDouble() < 0.1) {
      throw Exception(
        "CRITICAL: Failed to establish handshake with main cryogenic instrumentation bus.",
      );
    }

    return LHCState(
      beam1Energy: 450.0, // Injection starting energy in GeV
      beam2Energy: 450.0,
      luminosity: 0.0,
      status: LHCStatus.injection,
      historyPoints: [450.0],
      sectors: List.generate(
        8,
        (index) => SectorTelemetry(
          sectorName: 'Sector ${index + 1}',
          temperature: 1.9,
          magneticField: 0.58,
        ),
      ),
    );
  }
}
