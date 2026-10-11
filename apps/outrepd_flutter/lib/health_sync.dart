/// Push-ups saved to Apple Health or Health Connect, when the lifter asks.
///
/// Off until it is turned on in Settings, which is when the phone asks for
/// permission. After that every set — a duel's, a friend room's, a practice
/// set — is saved as a strength workout ending when it ended. Nothing is
/// read back: the app only adds to the lifter's own record.
library;

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

import 'settings.dart';

abstract final class HealthSync {
  static final _health = Health();
  static bool _configured = false;
  static const _types = [HealthDataType.WORKOUT];

  static bool get _onPhone =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  static Future<bool> _configure() async {
    if (_configured) return true;
    try {
      await _health.configure();
      _configured = true;
    } on Object catch (error) {
      debugPrint('Could not reach Health: $error');
    }
    return _configured;
  }

  /// Asks the phone for permission to save workouts. True when it may.
  ///
  /// On an Android phone without Health Connect, opens the store page to
  /// install it and answers false: there is nowhere to save to yet.
  static Future<bool> connect() async {
    if (!_onPhone || !await _configure()) return false;
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status != HealthConnectSdkStatus.sdkAvailable) {
          await _health.installHealthConnect();
          return false;
        }
      }
      return await _health.requestAuthorization(
        _types,
        permissions: [HealthDataAccess.WRITE],
      );
    } on Object catch (error) {
      debugPrint('Could not ask for Health permission: $error');
      return false;
    }
  }

  /// One set, saved as a strength workout that ended now. A duel's round is
  /// a minute, which is what a set is taken to have lasted.
  static Future<void> recordSet(
    int reps, {
    Duration length = const Duration(seconds: 60),
  }) async {
    if (!_onPhone || !settings.saveToHealth || reps <= 0) return;
    if (!await _configure()) return;
    final end = DateTime.now();
    final iPhone = defaultTargetPlatform == TargetPlatform.iOS;
    try {
      await _health.writeWorkoutData(
        activityType: iPhone
            ? HealthWorkoutActivityType.FUNCTIONAL_STRENGTH_TRAINING
            : HealthWorkoutActivityType.STRENGTH_TRAINING,
        start: end.subtract(length),
        end: end,
        title: 'OUTREPD · $reps push-ups',
        // Tracked while lifting, by the camera. Apple Health takes only
        // manual or automatic, and automatic is the nearer of the two.
        recordingMethod:
            iPhone ? RecordingMethod.automatic : RecordingMethod.active,
      );
    } on Object catch (error) {
      // Permission taken back in the Health app, or Health Connect removed:
      // the set still counts here, it is only not copied there.
      debugPrint('Could not save the set to Health: $error');
    }
  }
}
