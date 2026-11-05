/// The accuracy bench, and a check that the bench itself works.
///
/// Two jobs. The first is to prove the measuring instrument is sound: a
/// synthetic set of a known size goes in, and the chain — frames, JSON, the
/// scorer, the report — has to come back with that number. An instrument
/// nobody has checked is not evidence, and this whole exercise exists because
/// the counter was tuned for months against numbers that were themselves
/// guesses.
///
/// The second is to run every real recording anybody has pulled off a phone
/// into `test/recordings/` and print what the counter scored against what the
/// lifter said. That is the measurement. It prints rather than asserts while
/// there is nothing there, and guards against a regression once there is.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/recording.dart';
import 'package:outrepd/reps/replay.dart';

import 'support/synthetic_poses.dart';

void main() {
  group('the bench measures what it is given', () {
    late Directory dir;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('outrepd-replay');
    });

    tearDown(() {
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    });

    test('a synthetic set of known size is counted and compared', () {
      // Twelve full cycles, written the way the app writes them.
      _writeSession(dir, name: 'a', cycles: 12, trueCount: 12);

      final report = replayDirectory(dir);

      expect(report.sets, 1);
      final result = report.results.single;
      expect(result.trueCount, 12);
      // The point is not that it scores exactly twelve — that is the counter's
      // job and this file does not assert it. The point is that the bench read
      // the file, ran the set and produced a comparable number rather than a
      // zero or a crash.
      expect(result.frames, greaterThan(100));
      expect(result.counted, greaterThan(0),
          reason: 'the bench scored nothing on a clean synthetic set, so it '
              'is measuring its own plumbing rather than the counter');
    });

    test('a clean set of a known size is counted exactly', () {
      // The first thing the bench found, within minutes of existing: every
      // set was one rep short. A turn is only recognised once the signal
      // reverses away from it, and the turn a set *ends* on never gets that —
      // the recording stops — so the closing rep of every count this app had
      // ever produced was thrown away.
      //
      // One rep is the margin most sixty-second duels come down to.
      for (final cycles in [3, 8, 12, 25]) {
        final one = Directory.systemTemp.createTempSync('outrepd-exact');
        addTearDown(() => one.deleteSync(recursive: true));
        _writeSession(one, name: '$cycles', cycles: cycles, trueCount: cycles);

        final report = replayDirectory(one);
        expect(report.results.single.counted, cycles,
            reason: 'a mathematically clean set of $cycles scored '
                '${report.results.single.counted}');
      }
    });

    test('an unlabelled session is skipped, not scored as nothing', () {
      _writeSession(dir, name: 'labelled', cycles: 8, trueCount: 8);
      _writeSession(dir, name: 'bare', cycles: 8, trueCount: null);

      final report = replayDirectory(dir);

      // Counting it as a miss would drag every figure down and make the
      // counter look far worse than it is. It is not evidence either way.
      expect(report.sets, 1);
      expect(report.results.single.name, contains('labelled'));
    });

    test('a corrupt file is stepped over', () {
      _writeSession(dir, name: 'good', cycles: 6, trueCount: 6);
      File('${dir.path}/rubbish.json').writeAsStringSync('{ not json');

      final report = replayDirectory(dir);
      expect(report.sets, 1);
    });

    test('the summary reports error, direction and the worst miss', () {
      // Two sets the lifter labelled well under what any counter would score,
      // so the report has something to describe.
      _writeSession(dir, name: 'a', cycles: 10, trueCount: 4);
      _writeSession(dir, name: 'b', cycles: 10, trueCount: 5);

      final report = replayDirectory(dir);
      expect(report.sets, 2);
      expect(report.meanAbsoluteError, greaterThan(0));
      expect(report.worst, isNotEmpty);

      final text = report.describe();
      expect(text, contains('sets'));
      expect(text, contains('mean |error|'));
      expect(text, contains('bias'));
      expect(text, contains('misses, worst first'));
    });

    test('an empty folder says so instead of claiming perfection', () {
      final report = replayDirectory(dir);
      expect(report.empty, isTrue);
      // Zero sets scored zero wrong is not 100% accurate. A report that reads
      // as a pass on no evidence is worse than no report.
      expect(report.exactRate, 0);
      expect(report.describe(), contains('No labelled sessions'));
    });
  });

  group('real sessions', () {
    test('every recording in test/recordings is scored', () {
      final dir = Directory('test/recordings');
      final report = replayDirectory(dir);

      // Always printed: this is the number the whole exercise is for, and a
      // test that only prints on failure hides it exactly when it is good.
      // ignore: avoid_print
      print('\n--- push-up counter, measured against labelled sets ---\n'
          '${report.describe()}\n');

      if (report.empty) {
        // Nothing to measure yet. Not a failure — the recordings are made by a
        // person doing push-ups, and there is no way to fake that here.
        return;
      }

      // The floor, set from what the counter measured when it was rebuilt:
      // fourteen labelled sets, thirteen exact and the last one out by one
      // (fifteen since the phone's own 26, 2026-11-05).
      // The old counter managed half of them exact. A change that drops below
      // this has made the counter worse on sets somebody actually did.
      expect(report.withinOneRate, 1.0,
          reason: 'a labelled set is now more than one rep out:\n'
              '${report.describe()}');
      expect(report.exactRate, greaterThanOrEqualTo(0.9),
          reason: 'fewer than nine in ten labelled sets are exact:\n'
              '${report.describe()}');
    });

    test('a set the counter gets wrong, it says it is unsure of', () {
      // No set on the bench is missed today, so this guards the next one: a
      // miss must come flagged, so the confirm screen asks instead of
      // recording a guess as fact. A confident miss is the worst thing this
      // counter can produce: nobody checks a number presented as certain.
      final report = replayDirectory(Directory('test/recordings'));
      for (final r in report.results) {
        if (!r.exact) {
          expect(r.confident, isFalse,
              reason: '${r.name}: counted ${r.counted} for ${r.trueCount}, '
                  'and said it was sure');
        }
      }
    });

    test('the lifter\'s own two sessions still score right', () {
      // Filmed on the phone where it actually sits during a set — on the
      // floor, a metre away, front camera — which is the only footage in this
      // project shot the way the app is used. Every threshold in
      // `posture.dart` was measured from these two, so if either of them ever
      // stops scoring exactly, the thresholds moved out from under the
      // evidence rather than onto better evidence.
      const sets = {
        'pushups-10-floor-frontcam.json': 10,
        // Standing in front of the camera moving up and down. Zero is the
        // answer, and it used to score eight.
        'standing-bob-0.json': 0,
        // Recorded by the app itself on the lifter's phone (2026-11-05): the
        // knee rule must not take a rep from a real set.
        'phone-mlkit-26.json': 26,
      };

      final dir = Directory('test/recordings');
      if (!dir.existsSync()) return;

      final report = replayDirectory(dir);
      for (final entry in sets.entries) {
        final result =
            report.results.where((r) => r.name == entry.key).firstOrNull;
        if (result == null) continue;
        expect(result.counted, entry.value,
            reason: '${entry.key} scored ${result.counted}, '
                'and the lifter did ${entry.value}');
      }
    });

    test('push-ups on the knees are refused', () {
      // The lifter's own sets on the knees, recorded by the app on their
      // phone (2026-11-05): the match counted 75 before kKneeBentDegrees. Not
      // every rep is caught — at the top a knee the camera reads straight is
      // given the benefit — but most are, and none of a real set is (the
      // test above and the labelled sets).
      final dir = Directory('test/recordings_knees');
      final report = replayDirectory(dir);
      const most = {'phone-mlkit-knees-6.json': 0, 'phone-mlkit-knees-75.json': 25};
      for (final entry in most.entries) {
        final result =
            report.results.where((r) => r.name == entry.key).firstOrNull;
        expect(result, isNotNull, reason: '${entry.key} is missing');
        expect(result!.counted, lessThanOrEqualTo(entry.value),
            reason: '${entry.key} counted ${result.counted} reps done on the knees');
      }
    });
  });
}

/// Writes a session the way the app writes one: a moment at the top, the
/// set, a moment at the top afterwards, thirty poses a second.
void _writeSession(
  Directory dir, {
  required String name,
  required int cycles,
  required int? trueCount,
}) {
  final json = PoseRecording(
    exerciseId: 'pushup',
    frames: timed(pushUpSet(cycles)),
    note: trueCount?.toString(),
  ).toJson();
  if (trueCount != null) json['trueCount'] = trueCount;

  File('${dir.path}/rep-pushup-$name.json').writeAsStringSync(jsonEncode(json));
}
