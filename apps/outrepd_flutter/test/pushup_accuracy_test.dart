/// The push-up counter, measured.
///
/// Two of these clips carry their rep count in the title — "22 pushups for 22
/// veterans" — which makes them the only internet footage in this project with
/// ground truth attached. Everything else is judged on whether the counter
/// was sure of the set — no rep only just deep enough, no dip only just short
/// — which is weaker evidence and is reported as such rather than dressed up.
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
      final result = countPushups(recording.frames);

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
          '  ${result.confident ? 'sure    ' : 'UNSURE  '}'
          '  [$detail]$verdict');
    }

    // ignore: avoid_print
    print('\n${rows.join('\n')}\n'
        'clips read: $read   sure of: $agreed/$read'
        '${scored == 0 ? '' : '   within one of truth: $withinOne/$scored'}\n');

    expect(read, greaterThan(0), reason: 'no pose recordings to measure');
  });
}
