import 'package:flutter/material.dart';
import 'package:self_study/features/lhc_control/domain/models/sector_telemetry.dart';

class SectorGridView extends StatelessWidget {
  final List<SectorTelemetry> sectors;

  const SectorGridView({super.key, required this.sectors});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: sectors.length,
      itemBuilder: (context, index) {
        final sector = sectors[index];
        final bool isOverheated = sector.temperature > 2.1;
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isOverheated ? Colors.redAccent : Colors.grey[800]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sector.sectorName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${sector.temperature.toStringAsFixed(2)} K',
                    style: TextStyle(
                      color: isOverheated
                          ? Colors.redAccent
                          : Colors.greenAccent,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    '${sector.magneticField.toStringAsFixed(2)} T',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
