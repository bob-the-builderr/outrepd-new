/// What the camera said, against what the lifter said.
///
/// Every attempt to improve the counter has run into the same wall: there was
/// no ground truth. Fourteen recordings, no known rep counts, and every number
/// measured against another number that was also a guess. Tuning under those
/// conditions is not engineering, it is redecorating.
///
/// The confirmation step ends that. A lifter correcting 12 to 10 has just
/// labelled a set, for free, in the moment they were best placed to know —
/// right after doing it, at the angle they actually train at, on their own
/// phone. Those pairs are the only ground truth this app will ever have that
/// costs nobody anything.
///
/// So each one is kept whole rather than folded into a running total. Totals
/// can tell you the counter is out by two on average; they cannot tell you
/// whether that is every set out by two or one set out by forty, and those are
/// completely different faults with completely different fixes.
///
/// It stays on the device. Nothing here is sent anywhere; there is no server
/// to send it to, and a person's training is not telemetry.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'exercise_type.dart';

const _key = 'countAccuracy.samples';

/// How many sets are kept.
///
/// Enough to see a trend and to notice a change for the worse after tuning;
/// few enough that the record stays a few kilobytes. The oldest fall off, so
/// the number always describes the counter as it behaves now rather than as
/// it behaved six versions ago.
const kAccuracySamplesKept = 200;

/// One set: what the camera counted, and what the lifter said it was.
@immutable
class CountSample {
  const CountSample({
    required this.camera,
    required this.lifter,
    required this.at,
    this.exercise = ExerciseType.pushUp,
  });

  final int camera;
  final int lifter;
  final DateTime at;
  final ExerciseType exercise;

  /// Signed. Positive means the camera counted reps that were not there.
  int get error => camera - lifter;

  bool get exact => camera == lifter;

  Map<String, Object?> toJson() => {
        'c': camera,
        'l': lifter,
        'at': at.millisecondsSinceEpoch,
        'e': exercise.wireName,
      };

  static CountSample? fromJson(Map<String, Object?> json) {
    final camera = (json['c'] as num?)?.toInt();
    final lifter = (json['l'] as num?)?.toInt();
    final at = (json['at'] as num?)?.toInt();
    if (camera == null || lifter == null || at == null) return null;
    return CountSample(
      camera: camera,
      lifter: lifter,
      at: DateTime.fromMillisecondsSinceEpoch(at),
      exercise: ExerciseType.fromWireName(json['e'] as String? ?? ''),
    );
  }
}

/// What a set of samples says about the counter.
///
/// Deliberately several numbers rather than one. "87% accurate" is the kind of
/// figure that ends an investigation; knowing that it is exact on 87%, within
/// one on 96%, and biased half a rep high tells you what to go and fix.
@immutable
class AccuracyReport {
  const AccuracyReport({
    required this.sets,
    required this.exact,
    required this.withinOne,
    required this.meanAbsoluteError,
    required this.bias,
    required this.worst,
    required this.totalCamera,
    required this.totalLifter,
  });

  final int sets;

  /// Sets the camera got exactly right.
  final int exact;

  /// Sets the camera was out by at most one. A counter that is never more than
  /// one rep out is usable; one that is occasionally ten out is not, however
  /// good its average.
  final int withinOne;

  /// Mean |camera − lifter|, in reps.
  final double meanAbsoluteError;

  /// Mean signed error. Positive means it counts high. Direction matters as
  /// much as size: a counter that reliably overcounts is one fix, a counter
  /// that scatters is another.
  final double bias;

  /// The largest single miss, signed. This is the number that loses matches.
  final int worst;

  final int totalCamera;
  final int totalLifter;

  double get exactRate => sets == 0 ? 0 : exact / sets;
  double get withinOneRate => sets == 0 ? 0 : withinOne / sets;

  bool get empty => sets == 0;

  static const none = AccuracyReport(
    sets: 0,
    exact: 0,
    withinOne: 0,
    meanAbsoluteError: 0,
    bias: 0,
    worst: 0,
    totalCamera: 0,
    totalLifter: 0,
  );

  static AccuracyReport of(Iterable<CountSample> samples) {
    final list = samples.toList();
    if (list.isEmpty) return none;

    var exact = 0;
    var withinOne = 0;
    var absolute = 0;
    var signed = 0;
    var worst = 0;
    var camera = 0;
    var lifter = 0;

    for (final s in list) {
      if (s.exact) exact++;
      if (s.error.abs() <= 1) withinOne++;
      absolute += s.error.abs();
      signed += s.error;
      if (s.error.abs() > worst.abs()) worst = s.error;
      camera += s.camera;
      lifter += s.lifter;
    }

    return AccuracyReport(
      sets: list.length,
      exact: exact,
      withinOne: withinOne,
      meanAbsoluteError: absolute / list.length,
      bias: signed / list.length,
      worst: worst,
      totalCamera: camera,
      totalLifter: lifter,
    );
  }
}

/// Every labelled set this device has produced, newest last.
final countSamples = <CountSample>[];

/// The measurement over everything recorded.
AccuracyReport get countAccuracy => AccuracyReport.of(countSamples);

/// The measurement over the most recent [n] sets.
///
/// Worth having next to the lifetime figure: after a change to the counter,
/// the recent window moves first and the lifetime average lags behind it for
/// a long time.
AccuracyReport recentAccuracy([int n = 20]) =>
    AccuracyReport.of(countSamples.reversed.take(n));

Future<void> loadCountAccuracy() async {
  final store = await SharedPreferences.getInstance();
  final raw = store.getString(_key);
  if (raw == null) return;
  try {
    final list = jsonDecode(raw) as List<Object?>;
    countSamples
      ..clear()
      ..addAll([
        for (final entry in list)
          if (entry is Map<String, Object?>) ?CountSample.fromJson(entry),
      ]);
  } on Object catch (error) {
    // A record that cannot be read is a record not worth keeping. Losing it
    // costs a little history; throwing here would cost the app its launch.
    debugPrint('Could not read the accuracy record: $error');
  }
}

/// Notes one set. Called whether or not the lifter changed anything — a set
/// the camera got right is as much a measurement as one it got wrong, and a
/// record of only the failures would make the counter look far worse than it
/// is.
void recordCountCorrection({
  required int camera,
  required int lifter,
}) {
  countSamples.add(CountSample(
    camera: camera,
    lifter: lifter,
    at: DateTime.now(),
  ));
  if (countSamples.length > kAccuracySamplesKept) {
    countSamples.removeRange(0, countSamples.length - kAccuracySamplesKept);
  }

  // Fire and forget: the round moves on immediately, and a write that lands a
  // moment later is fine. Losing one row to a kill mid-write costs nothing.
  unawaited(_persist());
}

@visibleForTesting
void clearCountAccuracy() => countSamples.clear();

Future<void> _persist() async {
  final store = await SharedPreferences.getInstance();
  await store.setString(
    _key,
    jsonEncode([for (final s in countSamples) s.toJson()]),
  );
}

void unawaited(Future<void> future) {
  future.catchError((Object error) {
    debugPrint('Could not save the accuracy record: $error');
  });
}

/// Rounds a rate to whole percent for display.
int percent(double rate) => (rate * 100).round().clamp(0, 100);

/// One decimal place, for the error figures, which are rarely whole.
String reps(double value) => value.abs() < 0.05
    ? '0'
    : value.toStringAsFixed(1);

/// The fewest sets worth drawing any conclusion from.
///
/// Under about ten sets the numbers move wildly with each new one, and a
/// screen that shows "100% exact" after two sets invites exactly the wrong
/// conclusion. The accuracy screen says so rather than hiding the figure.
const kMinimumUsefulSamples = 10;
