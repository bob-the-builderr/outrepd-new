/// What the camera said, against what the lifter said.
///
/// Every attempt to improve the counter has run into the same wall: there was
/// no ground truth. Fourteen recordings, no known rep counts, and every number
/// measured against another number that was also a guess. Tuning under those
/// conditions is not engineering.
///
/// The confirmation step ends that. A lifter correcting 12 to 10 has just
/// labelled a set, for free, in the moment they were best placed to know. This
/// keeps those pairs so accuracy becomes something read rather than argued
/// about — per exercise, so it is obvious which movements the counter handles
/// and which it does not.
///
/// It stays on the device. Nothing here is sent anywhere; there is no server
/// to send it to, and a person's training is not telemetry.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const _key = 'countAccuracy';

/// The record for one exercise: how often the camera was taken as-is, and how
/// far out it was when it was not.
class ExerciseAccuracy {
  ExerciseAccuracy({
    this.sets = 0,
    this.agreed = 0,
    this.cameraTotal = 0,
    this.lifterTotal = 0,
  });

  int sets;

  /// Sets where the lifter accepted the number unchanged.
  int agreed;

  int cameraTotal;
  int lifterTotal;

  /// Share of sets the camera got right, as the lifter judged it.
  double get agreement => sets == 0 ? 0 : agreed / sets;

  /// Positive when the camera counts high, negative when it counts low. The
  /// direction matters as much as the size: a counter that reliably
  /// undercounts is a different fix from one that scatters.
  double get bias =>
      sets == 0 ? 0 : (cameraTotal - lifterTotal) / sets;

  Map<String, dynamic> toJson() => {
        'sets': sets,
        'agreed': agreed,
        'camera': cameraTotal,
        'lifter': lifterTotal,
      };

  static ExerciseAccuracy fromJson(Map<String, dynamic> j) => ExerciseAccuracy(
        sets: j['sets'] as int? ?? 0,
        agreed: j['agreed'] as int? ?? 0,
        cameraTotal: j['camera'] as int? ?? 0,
        lifterTotal: j['lifter'] as int? ?? 0,
      );
}

final countAccuracy = <String, ExerciseAccuracy>{};

Future<void> loadCountAccuracy() async {
  final store = await SharedPreferences.getInstance();
  final raw = store.getString(_key);
  if (raw == null) return;
  try {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    map.forEach((exercise, value) {
      countAccuracy[exercise] =
          ExerciseAccuracy.fromJson(value as Map<String, dynamic>);
    });
  } on FormatException {
    // A record that cannot be read is a record not worth keeping. Losing it
    // costs a little history; throwing here would cost the app its launch.
  }
}

/// Notes one set. Called whether or not the lifter changed anything — a set
/// the camera got right is as much a measurement as one it got wrong.
void recordCountCorrection({
  required String exercise,
  required int camera,
  required int lifter,
}) {
  final row = countAccuracy.putIfAbsent(exercise, ExerciseAccuracy.new)
    ..sets += 1
    ..cameraTotal += camera
    ..lifterTotal += lifter;
  if (camera == lifter) row.agreed += 1;

  // Fire and forget: the round moves on immediately, and a write that lands a
  // moment later is fine. Losing one row to a kill mid-write costs nothing.
  _persist();
}

Future<void> _persist() async {
  final store = await SharedPreferences.getInstance();
  await store.setString(
    _key,
    jsonEncode(countAccuracy.map((k, v) => MapEntry(k, v.toJson()))),
  );
}
