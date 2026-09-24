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
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/recording.dart';
import 'package:outrepd/reps/replay.dart';

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

      // Once there is evidence, this is the floor. It is deliberately low: the
      // first honest number is whatever it is, and the job of this line is to
      // catch a change that makes things worse, not to assert a target nobody
      // has measured yet.
      expect(report.withinOneRate, greaterThan(0.5),
          reason: 'the counter is more than one rep out on over half of the '
              'recorded sets:\n${report.describe()}');
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
  });
}

/// Writes a session the way the app writes one.
///
/// The body is horizontal with the elbow sweeping the range a push-up covers,
/// which is what the counter reads. Everything else is held still so the only
/// thing moving is the thing being measured.
void _writeSession(
  Directory dir, {
  required String name,
  required int cycles,
  required int? trueCount,
}) {
  const framesPerCycle = 30;
  final frames = <RecordedFrame>[];
  var at = 0;

  void add(double up) {
    frames.add(RecordedFrame(at, _pushUpPose(up)));
    at += 33;
  }

  // Half a second of lead-in at the top. The camera is running before anybody
  // starts, and a signal that begins exactly on an extreme gives the detector
  // nothing to recognise that extreme against. It also gives the position
  // check the frames it needs to see that the hands are staying put.
  for (var i = 0; i < 15; i++) {
    add(1);
  }

  for (var cycle = 0; cycle < cycles; cycle++) {
    for (var i = 0; i < framesPerCycle; i++) {
      // Starts at the top, like a push-up: down, then back up. Smooth, so
      // turning points are turning points rather than a sawtooth the
      // smoothing would round off.
      add((1 + math.cos(i / framesPerCycle * 2 * math.pi)) / 2);
    }
  }

  // And a moment at the top afterwards, the same way.
  for (var i = 0; i < 10; i++) {
    add(1);
  }

  final json = PoseRecording(
    exerciseId: 'pushup',
    frames: frames,
    note: trueCount?.toString(),
  ).toJson();
  if (trueCount != null) json['trueCount'] = trueCount;

  File('${dir.path}/rep-pushup-$name.json').writeAsStringSync(jsonEncode(json));
}

/// A body in a push-up, [up] running 1 at the top to 0 at the bottom.
///
/// The body travels and the hands stay where they were put. An earlier version
/// swung the wrist around a fixed shoulder, which is not a push-up — it is a
/// person waving — and the position check was right to refuse it.
BodyPose _pushUpPose(double up) {
  PosePoint at(double x, double y) => PosePoint(x, y, 0.95);
  final drop = (1 - up) * 90;

  return BodyPose({
    Joint.nose: at(150, 190 + drop),
    Joint.leftShoulder: at(200, 200 + drop),
    Joint.rightShoulder: at(205, 215 + drop),
    Joint.leftElbow: at(175, 265 + drop * 0.4),
    Joint.rightElbow: at(180, 275 + drop * 0.4),
    // Planted on the floor.
    Joint.leftWrist: at(190, 330),
    Joint.rightWrist: at(195, 336),
    // A body in a plank: hips, knees and ankles behind the shoulders and
    // level with them, travelling less the further they are from the hands.
    Joint.leftHip: at(330, 214 + drop * 0.7),
    Joint.rightHip: at(335, 228 + drop * 0.7),
    Joint.leftKnee: at(430, 218 + drop * 0.4),
    Joint.rightKnee: at(435, 232 + drop * 0.4),
    Joint.leftAnkle: at(520, 222),
    Joint.rightAnkle: at(525, 236),
  });
}
