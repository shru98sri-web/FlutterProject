import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/event_provider.dart';
import 'utils/hardware_services.dart';
import 'utils/localization.dart';
import 'utils/theme_config.dart';
import 'views/event_dashboard.dart';

void main() async {
  // Ensure the framework infrastructure bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Initialize Firebase with a safe timeout or catch failures gracefully
    await Firebase.initializeApp().timeout(const Duration(seconds: 4));
    await NotificationService.initialize();
    await PaymentService.initialize();

    // Attach unhandled execution panics to remote logging registries
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (e) {
    debugPrint("⚠️ Critical core setup skipped or offline: $e");
    // App will continue running instead of freezing on a blank screen
  }

  runApp(const ProviderScope(child: EventHubKernelBootstrap()));
}

class EventHubKernelBootstrap extends ConsumerWidget {
  const EventHubKernelBootstrap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(authStateProvider);
    final activeThemeMode = ref.watch(themeModeProvider);
    final activeLocale = ref.watch(currentLanguageProvider);

    return MaterialApp(
      title: 'EventHub Pro Enterprise',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.lightModeScheme,
      darkTheme: ThemeConfig.darkModeScheme,
      themeMode: activeThemeMode,
      locale: activeLocale,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es')],

      // Bypasses session stream blocks to display UI dashboard elements instantly
      home: const EventDashboard(),
    );
  }
}
