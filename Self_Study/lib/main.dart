import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_study/features/lhc_control/lhc_control_screen.dart';

void main() {
  runApp(const ProviderScope(child: LHCMainControlApp()));
}

class LHCMainControlApp extends StatelessWidget {
  const LHCMainControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LHC Control Deck',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: LHCControlScreen(),
    );
  }
}
