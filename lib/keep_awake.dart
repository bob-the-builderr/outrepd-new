/// Keeps the screen on while the camera is counting.
///
/// The phone is on the floor for the whole of a round and nobody touches it:
/// getting into position, the countdown, sixty seconds of push-ups. Plenty of
/// phones turn the screen off after thirty seconds of that, and a screen that
/// goes dark takes the camera with it — the count stops in the middle of a
/// duel the clock is still running on.
library;

import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Turns keeping the screen on on or off. Never throws: a phone that will not
/// hold the screen on must still count, and a test has no platform to ask.
Future<void> keepScreenOn(bool on) async {
  try {
    if (on) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
  } on Object catch (error) {
    debugPrint('Could not ${on ? 'keep' : 'release'} the screen: $error');
  }
}
