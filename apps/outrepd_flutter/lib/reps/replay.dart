/// Re-runs saved sessions through the counter and reports what it got.
///
/// This is the bench the counter has never had. Every previous attempt to
/// improve it compared one guess against another: recordings with no known
/// rep count, scored by an engine whose output was the only thing available to
/// check it against. Nothing measured that way can be said to have improved.
///
/// A labelled recording breaks the circle. The lifter said what the set was,
/// in the moment they were best placed to know, and the frames are on disk —
/// so a change to a threshold can be judged in milliseconds against every set
/// anybody has ever done, instead of by doing fifty more push-ups and arguing
/// about the result.
library;

import 'dart:convert';
import 'dart:io';

import 'pushup_counter.dart';
import 'recording.dart';

/// One labelled set, replayed.
class ReplayResult {
  const ReplayResult({
    required this.name,
    required this.trueCount,
    required this.counted,
    required this.frames,
    this.confident = true,
  });

  /// Whether the three body signals agreed on this one. A disagreement is the
  /// counter saying so, and a set it was unsure about is worth reading
  /// differently from one it was certain and wrong about.
  final bool confident;

  /// The file it came from, for when one of them needs looking at.
  final String name;

  /// What the lifter said it was.
  final int trueCount;

  /// What the counter says now.
  final int counted;

  final int frames;

  int get error => counted - trueCount;
  bool get exact => error == 0;
}

/// What a whole run says.
class ReplayReport {
  const ReplayReport(this.results);

  final List<ReplayResult> results;

  int get sets => results.length;
  bool get empty => results.isEmpty;

  int get exact => results.where((r) => r.exact).length;
  int get withinOne => results.where((r) => r.error.abs() <= 1).length;

  double get exactRate => sets == 0 ? 0 : exact / sets;
  double get withinOneRate => sets == 0 ? 0 : withinOne / sets;

  double get meanAbsoluteError => sets == 0
      ? 0
      : results.map((r) => r.error.abs()).reduce((a, b) => a + b) / sets;

  /// Positive means the counter runs high.
  double get bias => sets == 0
      ? 0
      : results.map((r) => r.error).reduce((a, b) => a + b) / sets;

  /// The sets it got most wrong, worst first. These are the ones worth
  /// watching back — an average hides the set that lost somebody a match.
  List<ReplayResult> get worst {
    final sorted = [...results]
      ..sort((a, b) => b.error.abs().compareTo(a.error.abs()));
    return sorted.where((r) => !r.exact).toList();
  }

  /// A plain-text summary, because the place this gets read is a test log.
  String describe() {
    if (empty) {
      return 'No labelled sessions found. Do a few sets, confirm the count, '
          'and pull the files off the device.';
    }
    final lines = <String>[
      'sets            $sets',
      'exact           $exact  (${(exactRate * 100).toStringAsFixed(0)}%)',
      'within 1        $withinOne  (${(withinOneRate * 100).toStringAsFixed(0)}%)',
      'mean |error|    ${meanAbsoluteError.toStringAsFixed(2)} reps',
      'bias            ${bias >= 0 ? '+' : ''}${bias.toStringAsFixed(2)} reps',
    ];
    if (worst.isNotEmpty) {
      lines.add('');
      lines.add('misses, worst first:');
      for (final r in worst.take(10)) {
        lines.add('  ${r.error > 0 ? '+' : ''}${r.error}  '
            'counted ${r.counted}${r.confident ? '' : ' (unsure)'}, '
            'lifter said ${r.trueCount}   ${r.name}');
      }
    }
    return lines.join('\n');
  }
}

/// Reads a labelled recording, or null when it carries no true count.
///
/// An unlabelled recording is not a failure, it is just not evidence. It gets
/// skipped rather than counted as a zero, which would drag every figure down
/// and make the counter look far worse than it is.
({PoseRecording recording, int trueCount})? readLabelled(File file) {
  try {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final explicit = (json['trueCount'] as num?)?.toInt();
    final fromNote = int.tryParse((json['note'] as String? ?? '').trim());
    final trueCount = explicit ?? fromNote;
    if (trueCount == null) return null;
    return (recording: PoseRecording.fromJson(json), trueCount: trueCount);
  } on Object {
    return null;
  }
}

/// Replays every labelled recording in [directory].
///
/// Scored with [countPushups] — the same tracker the screen runs live. A
/// bench that measures something else measures nothing: the counter wired
/// into the screen used to be a different one, and it scored a clip of
/// twenty-two known push-ups as one while this bench reported on code no
/// lifter was running.
ReplayReport replayDirectory(Directory directory) {
  if (!directory.existsSync()) return const ReplayReport([]);

  final results = <ReplayResult>[];

  final files = directory
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    final labelled = readLabelled(file);
    if (labelled == null) continue;

    final frames = labelled.recording.frames;
    if (frames.isEmpty) continue;

    final counted = countPushups(
      frames,
      startMs: labelled.recording.startMs,
    );
    results.add(ReplayResult(
      name: file.uri.pathSegments.last,
      trueCount: labelled.trueCount,
      counted: counted.reps,
      confident: counted.confident,
      frames: frames.length,
    ));
  }

  return ReplayReport(results);
}
