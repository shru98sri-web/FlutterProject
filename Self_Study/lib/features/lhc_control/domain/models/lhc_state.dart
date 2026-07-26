import 'sector_telemetry.dart';

enum LHCStatus { injection, ramping, stable, dumped }

class LHCState {
  final double beam1Energy;
  final double beam2Energy;
  final double luminosity;
  final LHCStatus status;
  final List<SectorTelemetry> sectors;
  final List<double> historyPoints;

  const LHCState({
    required this.beam1Energy,
    required this.beam2Energy,
    required this.luminosity,
    required this.status,
    required this.sectors,
    required this.historyPoints,
  });

  LHCState copyWith({
    double? beam1Energy,
    double? beam2Energy,
    double? luminosity,
    LHCStatus? status,
    List<SectorTelemetry>? sectors,
    List<double>? historyPoints,
  }) {
    return LHCState(
      beam1Energy: beam1Energy ?? this.beam1Energy,
      beam2Energy: beam2Energy ?? this.beam2Energy,
      luminosity: luminosity ?? this.luminosity,
      status: status ?? this.status,
      sectors: sectors ?? this.sectors,
      historyPoints: historyPoints ?? this.historyPoints,
    );
  }
}
