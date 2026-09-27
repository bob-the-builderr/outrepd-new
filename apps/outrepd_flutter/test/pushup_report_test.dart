/// Prints what the counter saw, rep by rep, with times.
///
/// Built so somebody with the video open can check the answer in a minute
/// instead of counting a whole clip from scratch: scrub to a listed second and
/// see whether a rep is happening there. It is the cheapest way to turn
/// footage with no stated count into ground truth, and ground truth is the one
/// thing this counter has never had.
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

/// Where the video for each set of poses lives, so the report can name a file
/// to open rather than leaving somebody to guess.
const _video = <String, String>{
  'pu_veterans22': 'pu_veterans22.webm',
  'pu_veterans22b': 'pu_veterans22b.webm',
  'pu_acft_hrp': 'pu_acft_hrp.webm',
  'pu_seal_c': 'pu_seal_c.mp4',
  'pu_tanzania_c': 'pu_tanzania_c.mp4',
  'pu_challenge': 'pu_challenge.webm',
  'pu_kettlebell': 'pu_kettlebell.webm',
  'pu_kbcombo': 'pu_kbcombo.webm',
};

void main() {
  test('a report somebody can check against the footage', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) {
      // ignore: avoid_print
      print('No pose recordings at $_folder.');
      return;
    }

    final out = StringBuffer();

    for (final entry in _video.entries) {
      final file = File('$_folder/${entry.key}.json');
      if (!file.existsSync()) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final frames = recording.frames;

      final result = countPushups(frames);
      final seconds = frames.isEmpty ? 0 : frames.last.atMs ~/ 1000;

      out.writeln('');
      out.writeln('━' * 62);
      out.writeln('${entry.value}   (${seconds}s)');
      out.writeln('  D:/pushup-videos/${entry.value}');
      out.writeln('');
      out.writeln('  I counted: ${result.reps}'
          '${result.confident ? '   (sure)' : '   (a close call in the set — treat as a guess)'}');
      out.writeln('  per signal: ${result.perSignal}');

      // When each rep completed — the body back up at the top — which is the
      // moment to scrub to.
      final times = result.repTimes;
      if (times.isNotEmpty) {
        final pretty = times
            .map((ms) => '${(ms / 1000).toStringAsFixed(1)}s')
            .join(', ');
        out.writeln('  each rep completed at: $pretty');
      }
    }

    // ignore: avoid_print
    print(out.toString());
    expect(out.length, greaterThan(0));
  });
}
