/// The few sounds the app makes: the countdown, each counted rep, and the
/// end of a round.
///
/// For a lifter who is not looking at the screen. The phone is on the floor
/// and the lifter is facing it from a push-up — or looking at the floor —
/// so "3, 2, 1, go" and a tick per rep are how they know the round started
/// and that the camera is counting, without breaking form to look.
///
/// Mixed with whatever else is playing, never instead of it: plenty of
/// people lift to music, and a beep that paused their playlist would be the
/// first thing they turned off.
library;

import 'dart:io' show Platform;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'settings.dart';

enum Cue {
  /// Each of 3, 2, 1.
  count('count.wav'),

  /// The round has started.
  go('go.wav'),

  /// A rep was counted.
  rep('rep.wav'),

  /// The round is over.
  end('end.wav');

  const Cue(this.file);
  final String file;
}

class Sounds {
  Sounds._();

  static final instance = Sounds._();

  /// A test has no audio to play through, and the web preview does not need
  /// any. Everywhere else, a phone.
  static bool get _available =>
      !kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST');

  final _players = <Cue, AudioPlayer>{};
  bool _ready = false;

  Future<void> _prepare() async {
    if (_ready) return;
    _ready = true;
    await AudioPlayer.global.setAudioContext(
      AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build(),
    );
  }

  /// Plays [cue], unless the lifter turned sounds off. Never throws: a phone
  /// that will not play a beep must still count.
  Future<void> play(Cue cue) async {
    if (!settings.sounds || !_available) return;
    try {
      await _prepare();
      var player = _players[cue];
      if (player == null) {
        player = AudioPlayer();
        await player.setPlayerMode(PlayerMode.lowLatency);
        _players[cue] = player;
      }
      await player.stop();
      await player.play(AssetSource('sounds/${cue.file}'));
    } on Object catch (error) {
      debugPrint('Could not play ${cue.name}: $error');
    }
  }
}
