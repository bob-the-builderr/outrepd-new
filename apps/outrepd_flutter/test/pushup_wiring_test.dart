/// The counter over the internet clips, printed rather than asserted.
///
/// These are side-on tripod videos of strangers, which is not how the app is
/// used — the ground truth that thresholds are set from lives in
/// `test/recordings/`, filmed on the phone where it actually sits. These are
/// kept because they are long, varied and free, and a wild change in what the
/// counter makes of them is worth seeing.
///
/// What this file used to be: a comparison of the three counters that existed
/// in this repo at once, run to settle which one the app should use. On the
/// only clip with a known count — 22 push-ups — the live engine scored **2**,
/// the set scorer scored **1** and refused 124 cycles, and `countPushups`
/// scored **22**. The app was wired to the first two. Both are deleted now,
/// and this is what is left of the experiment.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/pushup_counter.dart';
import 'package:outrepd/reps/recording.dart';

const _folder = String.fromEnvironment(
  'PUSHUPS',
  defaultValue: 'D:/pushup-poses',
);

/// What the source says, where it says anything.
const _truth = <String, int?>{
  'pu_veterans22.json': 22,
  'pu_veterans22b.json': 22,
  'pu_acft_hrp.json': null,
  'pu_seal_c.json': null,
  'pu_tanzania_c.json': null,
  'pu_challenge.json': null,
  'pu_kettlebell.json': null,
  'pu_kbcombo.json': null,
};

void main() {
  test('what the counter makes of the internet clips', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) {
      // ignore: avoid_print
      print('no recordings at $_folder — nothing to measure');
      return;
    }

    final rows = <String>[];
    for (final entry in _truth.entries) {
      final file = File('$_folder/${entry.key}');
      if (!file.existsSync()) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final counted = countPushups(recording.frames);

      rows.add('${entry.key.padRight(22)}'
          'frames ${recording.frames.length.toString().padLeft(5)}   '
          'truth ${(entry.value?.toString() ?? '?').padLeft(3)}   '
          'counted ${counted.reps.toString().padLeft(3)}'
          '${counted.confident ? ' ' : '?'}  '
          '${counted.perSignal}');
    }

    // ignore: avoid_print
    print('\n--- the counter, over side-on footage ---\n${rows.join('\n')}\n');
  });
}
