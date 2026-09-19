/// The push-up counter, measured.
///
/// Two of these clips carry their rep count in the title — "22 pushups for 22
/// veterans" — which makes them the only internet footage in this project with
/// ground truth attached. Everything else is judged on whether the three
/// signals agree with each other, which is weaker evidence and is reported as
/// such rather than dressed up.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/pushup_counter.dart';
import 'package:outrepd/reps/recording.dart';

const _folder = String.fromEnvironment(
  'PUSHUPS',
  defaultValue: 'D:/pushup-poses',
);

/// Known counts, where the source states one — and it states very few.
///
/// "22 pushups for 22 veterans" is the name of an awareness campaign, not a
/// promise about what is on camera, so even these two are weak evidence and
/// are reported separately from the agreement figure rather than folded into
/// an accuracy claim.
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
  test('how much smoothing the fast sets can stand', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    // The 22-second clip is 22 reps at a rep a second. A filter tuned for a
    // slow set flattens an oscillation that fast, shrinking the swings until
    // turns merge — so the weight is swept rather than assumed.
    for (final weight in [0.3, 0.4, 0.55, 0.7, 0.85, 1.0]) {
      kSmoothing = weight;
      final line = StringBuffer('smoothing ${weight.toStringAsFixed(2)}  ');
      for (final name in ['pu_veterans22', 'pu_veterans22b']) {
        final file = File('$_folder/$name.json');
        if (!file.existsSync()) continue;
        final recording = PoseRecording.fromJson(
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
        );
        final r = countPushups([for (final f in recording.frames) f.pose]);
        line.write('$name=${r.reps} ${r.perSignal} ');
      }
      // ignore: avoid_print
      print(line.toString());
    }
    kSmoothing = 0.4;
  });

  test('push-ups counted against what the footage says', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) {
      // ignore: avoid_print
      print('No pose recordings at $_folder yet.');
      return;
    }

    final rows = <String>[];
    var scored = 0;
    var withinOne = 0;
    var agreed = 0;
    var read = 0;

    for (final entry in _truth.entries) {
      final file = File('$_folder/${entry.key}');
      if (!file.existsSync()) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final poses = <BodyPose>[for (final f in recording.frames) f.pose];
      final result = countPushups(poses);

      read++;
      if (result.confident) agreed++;

      final truth = entry.value;
      final verdict = switch (truth) {
        null => '',
        _ when (result.reps - truth).abs() <= 1 => '   ✓ within one of $truth',
        _ => '   ✗ truth $truth',
      };
      if (truth != null) {
        scored++;
        if ((result.reps - truth).abs() <= 1) withinOne++;
      }

      final detail = result.perSignal.entries
          .map((e) => '${e.key}=${e.value}')
          .join(' ');

      rows.add('${entry.key.replaceAll('.json', '').padRight(16)}'
          ' counted ${result.reps.toString().padLeft(3)}'
          '  ${result.confident ? 'agreed  ' : 'DISPUTED'}'
          '  [$detail]$verdict');
    }

    // ignore: avoid_print
    print('\n${rows.join('\n')}\n'
        'clips read: $read   signals agreed: $agreed/$read'
        '${scored == 0 ? '' : '   within one of truth: $withinOne/$scored'}\n');

    expect(read, greaterThan(0), reason: 'no pose recordings to measure');
  });
}
