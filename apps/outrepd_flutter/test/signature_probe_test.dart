/// Prints what the channels actually read on a recording, so a signature that
/// refuses real reps can be argued with rather than guessed at.
///
/// Not an assertion — a window. Run it when a clip counts zero and the numbers
/// say which rule is the wall.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/movement_signature.dart';
import 'package:outrepd/reps/recording.dart';

const _folder = String.fromEnvironment(
  'RECORDINGS',
  defaultValue: 'D:/outrepd-recordings',
);

void main() {
  test('what each channel reads across every clip', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    final lines = <String>[];
    for (final file in dir.listSync().whereType<File>()) {
      final name = file.uri.pathSegments.last;
      if (!name.endsWith('.json') || name == 'truth.json') continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );

      lines.add(name);
      for (final channel in Channel.values) {
        final values = <double>[];
        for (final frame in recording.frames) {
          final v = readChannel(frame.pose, channel);
          if (v != null) values.add(v);
        }
        if (values.isEmpty) {
          lines.add('  ${channel.name.padRight(13)} not visible');
          continue;
        }
        final sorted = [...values]..sort();
        final lo = sorted.first;
        final hi = sorted.last;
        final median = sorted[sorted.length ~/ 2];
        lines.add('  ${channel.name.padRight(13)}'
            ' min ${lo.toStringAsFixed(1).padLeft(7)}'
            '  max ${hi.toStringAsFixed(1).padLeft(7)}'
            '  median ${median.toStringAsFixed(1).padLeft(7)}'
            '  range ${(hi - lo).toStringAsFixed(1).padLeft(7)}');
      }
      lines.add('');
    }

    // ignore: avoid_print
    print('\n${lines.join('\n')}');
    expect(math.max(0, lines.length), greaterThan(0));
  });
}
