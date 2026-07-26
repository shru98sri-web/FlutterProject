import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/lhc_remote_data_source.dart';
import '../../data/repositories/lhc_repository_impl.dart';
import '../../domain/models/lhc_state.dart';
import '../../domain/models/sector_telemetry.dart';
import '../../domain/repositories/lhc_repository.dart';

final lhcRepositoryProvider = Provider<LHCRepository>((ref) {
  return LHCRepositoryImpl(LHCRemoteDataSourceImpl());
});

final lhcControllerProvider = AsyncNotifierProvider.autoDispose<LHCController, LHCState>(() {
  return LHCController();
});

class LHCController extends AutoDisposeAsyncNotifier<LHCState> {
  Timer? _telemetryTicker;
  final Random _rand = Random();

  @override
  FutureOr<LHCState> build() async {
    final repo = ref.watch(lhcRepositoryProvider);
    final initialState = await repo.fetchInitialControlState();

    // Once initialization succeeds, kick off the live hardware telemetry stream loop
    _startLiveTelemetryStream();

    return initialState;
  }

  void _startLiveTelemetryStream() {
    _telemetryTicker?.cancel();
    _telemetryTicker = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      _updatePhysicsTick();
    });

    ref.onDispose(() => _telemetryTicker?.cancel());
  }

  void _updatePhysicsTick() {
    state.whenData((current) {
      if (current.status == LHCStatus.dumped) return;

      double b1 = current.beam1Energy;
      double b2 = current.beam2Energy;
      double lumi = current.luminosity;
      LHCStatus status = current.status;

      // Handle structural physics cycle transitions
      if (status == LHCStatus.injection) {
        status = LHCStatus.ramping;
      } else if (status == LHCStatus.ramping) {
        b1 += 400 + _rand.nextDouble() * 100;
        b2 += 400 + _rand.nextDouble() * 100;
        if (b1 >= 6800) {
          b1 = 6800.0;
          b2 = 6800.0;
          status = LHCStatus.stable;
        }
      } else if (status == LHCStatus.stable) {
        lumi = 14.0 + _rand.nextDouble() * 2.5;
      }

      // Update magnet metrics
      final updatedSectors = current.sectors.map((s) {
        return s.copyWith(
          temperature: 1.9 + (_rand.nextDouble() - 0.5) * 0.05,
          magneticField: (b1 / 6800.0) * 8.33,
        );
      }).toList();

      final hist = List<double>.from(current.historyPoints)..add(b1);
      if (hist.length > 30) hist.removeAt(0);

      state = AsyncValue.data(current.copyWith(
        beam1Energy: b1,
        beam2Energy: b2,
        luminosity: lumi,
        status: status,
        sectors: updatedSectors,
        historyPoints: hist,
      ));
    });
  }

  void triggerEmergencyDump() {
    state.whenData((current) {
      state = AsyncValue.data(current.copyWith(
        beam1Energy: 0.0,
        beam2Energy: 0.0,
        luminosity: 0.0,
        status: LHCStatus.dumped,
        historyPoints: List.from(current.historyPoints)..add(0.0),
      ));
    });
  }

  void resetAccelerator() {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }
}
