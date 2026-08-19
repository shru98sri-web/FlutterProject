import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/event_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authControllerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.blur_on_rounded,
                size: 90, color: Colors.deepPurple),
            const SizedBox(height: 16),
            const Text('EventHub Pro',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              icon: const Icon(Icons.fingerprint),
              label: const Text('Unlock with Biometrics',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              onPressed: () async {
                final authed = await controller.authenticateBiometrics();
                if (authed) {
                  await controller.signInWithGoogle();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Biometric verification failed or declined.')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
