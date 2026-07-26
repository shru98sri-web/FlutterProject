class SectorTelemetry {
  final String sectorName;
  final double temperature; // Target ~1.9 Kelvin
  final double magneticField; // Tesla

  const SectorTelemetry({
    required this.sectorName,
    required this.temperature,
    required this.magneticField,
  });

  SectorTelemetry copyWith({
    String? sectorName,
    double? temperature,
    double? magneticField,
  }) {
    return SectorTelemetry(
      sectorName: sectorName ?? this.sectorName,
      temperature: temperature ?? this.temperature,
      magneticField: magneticField ?? this.magneticField,
    );
  }
}
