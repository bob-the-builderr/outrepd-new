/// Measures the counter against sets that were actually performed.
///
/// Every tuning change until now has been argued for rather than measured:
/// someone reports "it counted nine when I did ten", a likely cause gets
/// guessed at, and a new build goes out. That loop is slow and it cannot tell
/// a real improvement from a lucky one.
///
/// This replays recorded sessions through the engine and prints how close the
/// count came. Recordings are produced by the app itself — finish a session and
/// it writes one — so the numbers here come from real bodies in real rooms.
///
/// Put the recordings somewhere and point RECORDINGS at it:
///
///   D:/outrepd-recordings/
///     rep-pushup-1737.json
///     truth.json          {"rep-pushup-1737.json": 12}
///
/// Then: flutter test test/accuracy_test.dart --dart-define=RECORDINGS=D:/outrepd-recordings
///
/// With no recordings present the test passes and says so, so an empty folder
/// never fails the suite for someone who has not collected any yet.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/driver_finder.dart';
import 'package:outrepd/reps/exercise.dart';
import 'package:outrepd/reps/recording.dart';
import 'package:outrepd/reps/rep_engine.dart';

const _folder = String.fromEnvironment(
  'RECORDINGS',
  defaultValue: 'D:/outrepd-recordings',
);

class _Result {
  _Result(this.name, this.expected, this.counted, this.derived);

  final String name;
  final int expected;
  final int counted;

  /// True when the movement was worked out rather than read from the catalogue.
  final bool derived;

  int get miss => (counted - expected).abs();

  /// How much of the set it got right, floored at zero so a wild overcount
  /// cannot drag the average below nothing.
  double get accuracy =>
      expected == 0 ? 0 : (1 - miss / expected).clamp(0.0, 1.0);
}

/// Runs a recording through the engine exactly as a live session would.
int countOf(PoseRecording recording) {
  final known = kExercises.where((e) => e.id == recording.exerciseId);
  final poses = [for (final f in recording.frames) f.pose];

  final ExerciseDef definition;
  if (known.isNotEmpty) {
    definition = known.first;
  } else {
    final guess = findDriver(poses);
    if (guess == null) return 0;
    definition = guess.toDefinition(id: 'learned', name: 'Learned');
  }

  final engine = RepEngine(definition);
  for (final frame in recording.frames) {
    engine.update(frame.pose, Duration(milliseconds: frame.atMs));
  }
  return engine.reps;
}

/// The count the lifter reported when they finished the set.
String? noteOf(File file) {
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return json['note'] as String?;
}

void main() {
  test('the counter is measured against sets that were actually performed', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) {
      printOnFailure('');
      // ignore: avoid_print
      print('No recordings at $_folder — nothing to measure yet.\n'
          'Record a few sets in the app, note the real counts in truth.json, '
          'and run this again.');
      return;
    }

    final truthFile = File('$_folder/truth.json');
    final truth = truthFile.existsSync()
        ? (jsonDecode(truthFile.readAsStringSync()) as Map<String, dynamic>)
        : <String, dynamic>{};

    final results = <_Result>[];

    for (final file in dir.listSync().whereType<File>()) {
      final name = file.uri.pathSegments.last;
      if (!name.endsWith('.json') || name == 'truth.json') continue;

      // The app writes the real count into the recording itself now; the
      // truth file stays as a fallback for anything recorded before that.
      final expected = int.tryParse(noteOf(file) ?? '') ?? truth[name];
      if (expected is! int) {
        // ignore: avoid_print
        print('skipping $name — no true count in truth.json');
        continue;
      }

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final derived = !kExercises.any((e) => e.id == recording.exerciseId);
      results.add(
        _Result(name, expected, countOf(recording), derived),
      );
    }

    if (results.isEmpty) {
      // ignore: avoid_print
      print('No recordings had a true count to compare against.');
      return;
    }

    results.sort((a, b) => a.accuracy.compareTo(b.accuracy));

    final buffer = StringBuffer('\n  set${' ' * 28}real  counted  off\n');
    for (final r in results) {
      final label = r.name.padRight(30).substring(0, 30);
      buffer.writeln('  $label${r.expected.toString().padLeft(4)}'
          '${r.counted.toString().padLeft(9)}'
          '${r.miss.toString().padLeft(5)}'
          '${r.derived ? '  (learned)' : ''}');
    }

    final mean =
        results.map((r) => r.accuracy).reduce((a, b) => a + b) / results.length;
    // The worst set matters more than the average. An app that averages well
    // but fails badly for one person in ten loses those people for good.
    final worst = results.first;

    buffer
      ..writeln('\n  sets measured   ${results.length}')
      ..writeln('  average         ${(mean * 100).toStringAsFixed(1)}%')
      ..writeln('  worst set       ${(worst.accuracy * 100).toStringAsFixed(1)}%'
          '  (${worst.name})')
      ..writeln('  exact matches   '
          '${results.where((r) => r.miss == 0).length} of ${results.length}');

    // ignore: avoid_print
    print(buffer.toString());

    // No threshold is asserted yet. The first run establishes where we stand;
    // once that number is known a floor goes here, so a change that makes
    // counting worse fails instead of shipping.
    expect(results, isNotEmpty);
  });
}
