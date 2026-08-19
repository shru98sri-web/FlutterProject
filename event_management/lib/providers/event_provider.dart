import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';

import '../models/event_model.dart';

final firestoreProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  return firestore;
});

final authProvider = Provider((ref) => FirebaseAuth.instance);
final biometricAuthProvider = Provider((ref) => LocalAuthentication());

final authStateProvider =
    StreamProvider<User?>((ref) => ref.watch(authProvider).authStateChanges());
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');
final currentLanguageProvider =
    StateProvider<Locale>((ref) => const Locale('en'));

final eventsStreamProvider = StreamProvider<List<Event>>((ref) {
  try {
    final firestore = ref.watch(firestoreProvider);
    final category = ref.watch(selectedCategoryProvider);

    Query query = firestore.collection('events');
    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snap) {
      if (snap.docs.isEmpty) return _getSandboxFallbackEvents();
      return snap.docs.map((doc) => Event.fromFirestore(doc)).toList();
    });
  } catch (_) {
    // If offline or missing indexes, serve offline data structures instantly
    return Stream.value(_getSandboxFallbackEvents());
  }
});

List<Event> _getSandboxFallbackEvents() {
  return [
    Event(
      id: 'mock_1',
      title: 'Tech Innovators Summit 2026',
      description:
          'Enterprise structural solutions, state machine testing setups and UI architecture configurations.',
      location: 'Silicon Valley Convention Center, CA',
      date: DateTime(2026, 09, 15),
      imageUrl:
          'https://media.licdn.com/dms/image/v2/D4D12AQFxuo8CWk6qIg/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1681980612057?e=2147483647&v=beta&t=f9M7hoyYpXFYlLmwfvzCWg4qyzF6ixX36j3jIOnCfa0',
      price: 99.00,
      category: 'Technology',
      latitude: 37.7749,
      longitude: -122.4194,
    ),
  ];
}

final authControllerProvider = Provider((ref) => AuthController(ref));

class AuthController {
  final Ref _ref;
  AuthController(this._ref);

  Future<bool> authenticateBiometrics() async {
    final localAuth = _ref.read(biometricAuthProvider);
    final canCheck = await localAuth.canCheckBiometrics ||
        await localAuth.isDeviceSupported();
    if (!canCheck) return false;

    try {
      return await localAuth.authenticate(
        localizedReason:
            'Please authenticate via biometrics to enter EventHub Pro.',
        options:
            const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (_) {
      return false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _ref.read(authProvider).signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _ref.read(authProvider).signOut();
  }
}
