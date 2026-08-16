/// Captures the pose stream of a session so it can be replayed later.
///
/// Tuning a counter needs the same set run again and again against different
/// thresholds, and nobody is going to do fifty push-ups once per experiment.
/// One recorded set turns that into a test that runs in milliseconds.
///
/// It stores joint positions, not video: a few hundred numbers a second, no
/// picture of anybody, and small enough to pull off the phone over a cable.
library;

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'pose.dart';

class RecordedFrame {
  const RecordedFrame(this.atMs, this.pose);

  final int atMs;
  final BodyPose pose;

  Map<String, dynamic> toJson() => {
        't': atMs,
        'p': {
          for (final entry in pose.points.entries)
            entry.key.name: [
              _round(entry.value.x),
              _round(entry.value.y),
              _round(entry.value.z),
              _round(entry.value.confidence),
            ],
        },
      };

  static RecordedFrame fromJson(Map<String, dynamic> json) {
    final points = <Joint, PosePoint>{};
    (json['p'] as Map<String, dynamic>).forEach((name, value) {
      final joint = Joint.values.firstWhere(
        (j) => j.name == name,
        orElse: () => Joint.nose,
      );
      final v = (value as List).cast<num>();
      points[joint] = PosePoint(
        v[0].toDouble(),
        v[1].toDouble(),
        v[3].toDouble(),
        v[2].toDouble(),
      );
    });
    return RecordedFrame(json['t'] as int, BodyPose(points));
  }

  /// Four decimals is finer than the tracker's own precision and keeps the
  /// file small enough to move around.
  static double _round(double v) => (v * 10000).roundToDouble() / 10000;
}

class PoseRecording {
  PoseRecording({required this.exerciseId, required this.frames, this.note});

  final String exerciseId;
  final List<RecordedFrame> frames;

  /// What actually happened, written by whoever recorded it — "10 push-ups".
  /// Without it a recording proves nothing, because there is no truth to
  /// compare the count against.
  final String? note;

  Map<String, dynamic> toJson() => {
        'exercise': exerciseId,
        if (note != null) 'note': note,
        'frames': frames.map((f) => f.toJson()).toList(),
      };

  static PoseRecording fromJson(Map<String, dynamic> json) => PoseRecording(
        exerciseId: json['exercise'] as String,
        note: json['note'] as String?,
        frames: (json['frames'] as List)
            .map((f) => RecordedFrame.fromJson(f as Map<String, dynamic>))
            .toList(),
      );

  /// Saved where `adb pull` can reach it without root or permissions.
  Future<String> save() async {
    final dir = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/rep-$exerciseId-$stamp.json');
    await file.writeAsString(jsonEncode(toJson()));
    return file.path;
  }
}
