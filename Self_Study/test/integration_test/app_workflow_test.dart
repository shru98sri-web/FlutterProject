import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// ✅ FIXED: Changed relative path imports to absolute package path imports
import 'package:self_study/features/lhc_control/domain/models/lhc_state.dart';
import 'package:self_study/features/lhc_control/domain/models/sector_telemetry.dart';
import 'package:self_study/features/lhc_control/domain/repositories/lhc_repository.dart';
import 'package:self_study/features/lhc_control/presentation/controllers/lhc_controller.dart';
import 'package:self_study/main.dart';

class MockLHCRepository implements LHCRepository {
  @override
  Future<LHCState> fetchInitialControlState() async {
    return LHCState(
      beam1Energy: 450.0,
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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('LHC Main Ring Control Integration Operational Flows', () {
    testWidgets(
      'Verify database initialization, stream transitions, and manual beam dumps',
      (tester) async {
        // 🟢 2. Override the real repository with your Mock Repository inside the ProviderScope
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              lhcRepositoryProvider.overrideWithValue(MockLHCRepository()),
            ],
            child: const LHCMainControlApp(),
          ),
        );

        // 3. Validate initialization state layout is displayed instantly
        expect(
          find.text("CONNECTING TO CERN BEAM CONTROL BUS..."),
          findsOneWidget,
        );

        // 4. Wait for mock network initialization cycle to conclude (Crucial for AsyncValue)
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // 5. Assert that control deck is rendering physics status metrics
        expect(
          find.textContaining("SYSTEM OPERATIONAL STATE:"),
          findsOneWidget,
        );

        // 6. Fire Interlock Emergency safety breaker system manually via automation tap
        final Finder dumpButton = find.byKey(const Key('emergency_dump_btn'));
        expect(dumpButton, findsOneWidget);
        await tester.ensureVisible(dumpButton);
        await tester.tap(dumpButton);

        // Re-render UI to update matching tracking configurations
        await tester.pumpAndSettle();

        // 7. Confirm that the application caught the action and dropped beam metrics safely to zero
        expect(find.text("SYSTEM OPERATIONAL STATE: DUMPED"), findsOneWidget);
      },
    );
  });
}
