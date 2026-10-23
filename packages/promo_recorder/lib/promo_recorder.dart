/// Films the app itself while a take runs, and saves the film to Photos.
///
/// The phone's own screen recorder squeezes what it records hard, adds the
/// status bar, and drops frames when the phone is busy. This asks iOS for the
/// app's own frames (ReplayKit) and writes them at the screen's full
/// resolution and a high bitrate, with the app's sound and nothing else.
library;

import 'package:flutter/services.dart';

abstract final class PromoRecorder {
  static const _channel = MethodChannel('outrepd/promo_recorder');

  /// Starts filming. iOS asks the first time in a while; a refusal throws.
  static Future<void> start() => _channel.invokeMethod<void>('start');

  /// Stops, and saves what was filmed to Photos. True once it is there.
  static Future<bool> stop() async =>
      await _channel.invokeMethod<bool>('stop') ?? false;
}
