/// Firebase, for push notifications and crash reports.
///
/// Optional in every build. `google-services.json` is written by CI from a
/// secret; a build without it — a local one, or the paywall test build —
/// never starts Firebase and behaves exactly as it did before either existed.
library;

import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

bool _started = false;

/// Whether Firebase is running in this build.
bool get firebaseReady => _started;

/// Starts Firebase if this build carries its config, and from then on sends
/// errors to Crashlytics. Never throws: a phone that cannot report a crash
/// must still open.
Future<void> startFirebase() async {
  if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) return;
  if (!Platform.isAndroid && !Platform.isIOS) return;
  try {
    await Firebase.initializeApp();
    _started = true;
  } on Object catch (error) {
    debugPrint('Firebase is not set up in this build: $error');
    return;
  }

  try {
    final crashlytics = FirebaseCrashlytics.instance;
    // A debug build is somebody at a desk with the stack trace in front of
    // them; only the builds testers and players run report.
    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    // Reported, not fatal: a Flutter error draws a broken widget and the app
    // carries on, and a crash report that says otherwise sends whoever reads
    // it after the wrong thing. Native crashes are caught by Crashlytics
    // itself, as crashes.
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      crashlytics.recordFlutterError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack);
      return true;
    };
  } on Object catch (error) {
    debugPrint('Crash reports are off: $error');
  }
}
