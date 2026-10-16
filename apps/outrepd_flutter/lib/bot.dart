/// A stand-in opponent for filming: a name, a face, and exactly when each of
/// their reps lands across the minute.
///
/// A real duel needs a second phone and a server. A marketing video needs a
/// rival that counts up the way a person does, on a clock the person holding
/// the camera controls. This is that rival, and nothing more: it is not a
/// player, it is not on the ladder, and it exists only where the person filming
/// put it — see [kBotDemo].
///
/// The count and the timeline are one thing, not two: [BotOpponent.reps] is
/// simply how many landing times there are. Splitting them would let the screen
/// promise a number the bar never reaches, which is the one way this could look
/// wrong in a recording.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Whether this build carries the demo-opponent tools at all.
///
/// Off unless built with `--dart-define=BOT_DEMO=true`. A real build must not
/// offer a match against somebody who does not exist: the store listing
/// promises real people, and the whole ladder stands on both sides being real.
/// This is the same door as `kSeedPreview` in preview_seed.dart — a flag that
/// rides along on a build made for looking at, and is absent from the one that
/// ships.
const kBotDemo = bool.fromEnvironment('BOT_DEMO');

/// The length of a duel's round, milliseconds: the same sixty seconds every
/// other match runs, so a demo sits on the real timeline.
const kBotRoundMs = 60000;

/// Where an even spread of reps starts and ends. Short of both ends so the
/// first dot is not stuck against the whistle and the last is not hidden under
/// the finish.
const kBotFirstMs = 4000;
const kBotLastMs = 56000;

/// The most reps a demo opponent may be given. Past this the dots on the
/// timeline overlap into one smear, and no push-up set reads as more anyway.
const kBotMaxReps = 100;

const _kBotStore = 'botOpponent';

/// Who the camera is racing in a demo match.
class BotOpponent {
  BotOpponent({
    required this.name,
    this.photoPath,
    required List<int> repTimesMs,
  }) : repTimesMs = _ascending(repTimesMs);

  /// Shown everywhere an opponent's name is: the versus card, the score card,
  /// the result.
  String name;

  /// A picture from the phone, copied into the app's own storage, or null for
  /// the drawn initial — the same rule every other avatar in the app follows.
  String? photoPath;

  /// When each rep lands, milliseconds from the whistle, ascending and inside
  /// `[0, kBotRoundMs]`. Its length is the opponent's final count: the number
  /// and the timeline are one value, so they can never disagree.
  final List<int> repTimesMs;

  /// The opponent's final count. The camera spreads the bar across the clock
  /// from the same list, so the count is always reachable.
  int get reps => repTimesMs.length;

  /// The landing times, ascending and unmodifiable.
  ///
  /// The camera's bar walks the list and stops at the first time past the
  /// clock, so an unsorted list would undercount. [repTimesMs] is kept sorted
  /// on the way in; this hands it out without letting a caller break that.
  List<int> get repTimesSorted => List.unmodifiable(repTimesMs);

  /// [count] reps spread evenly across the round, the starting shape a demo
  /// opponent opens on — then dragged into whatever the recording needs.
  factory BotOpponent.spreadEvenly({
    required String name,
    String? photoPath,
    int count = 18,
    int firstMs = kBotFirstMs,
    int lastMs = kBotLastMs,
  }) {
    return BotOpponent(
      name: name,
      photoPath: photoPath,
      repTimesMs: spreadRepTimes(
        count: count,
        firstMs: firstMs,
        lastMs: lastMs,
      ),
    );
  }

  BotOpponent copyWith({
    String? name,
    String? photoPath,
    List<int>? repTimesMs,
  }) {
    return BotOpponent(
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      repTimesMs: repTimesMs ?? this.repTimesMs,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    if (photoPath != null) 'photo': photoPath,
    'times': repTimesMs,
  };

  factory BotOpponent.fromJson(Map<String, dynamic> json) {
    final times = (json['times'] as List?)
        ?.whereType<num>()
        .map((n) => n.toInt())
        .toList();
    final name = (json['name'] as String?)?.trim() ?? '';
    return BotOpponent(
      name: name.isEmpty ? 'iron_mike' : name,
      photoPath: json['photo'] as String?,
      // A stored bot with no reps at all would be a match nobody can win or
      // lose; fall back to the default shape rather than an empty minute.
      repTimesMs: (times == null || times.isEmpty)
          ? spreadRepTimes(count: 18)
          : times,
    );
  }

  static List<int> _ascending(List<int> times) =>
      [for (final t in times) t.clamp(0, kBotRoundMs).toInt()]..sort();
}

/// Evenly spaced landing times for [count] reps, ascending and inside the
/// round. One rep sits in the middle of the window rather than at its start.
List<int> spreadRepTimes({
  required int count,
  int firstMs = kBotFirstMs,
  int lastMs = kBotLastMs,
}) {
  if (count <= 0) return const [];
  final n = count > kBotMaxReps ? kBotMaxReps : count;
  var lo = firstMs.clamp(0, kBotRoundMs).toInt();
  var hi = lastMs.clamp(0, kBotRoundMs).toInt();
  if (lo > hi) {
    final swap = lo;
    lo = hi;
    hi = swap;
  }
  if (n == 1) return [(lo + hi) ~/ 2];
  return [
    for (var i = 0; i < n; i++)
      (lo + ((hi - lo) * i / (n - 1)).round()).clamp(0, kBotRoundMs).toInt(),
  ];
}

/// The bot a demo build opens on before anybody has set one up.
BotOpponent defaultBot() => BotOpponent.spreadEvenly(name: 'iron_mike');

/// The stored demo opponent, or the default one.
Future<BotOpponent> loadBot() async {
  final store = await SharedPreferences.getInstance();
  final raw = store.getString(_kBotStore);
  if (raw == null) return defaultBot();
  try {
    return BotOpponent.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } on Object {
    // A stored value this build cannot read is not worth a broken screen: the
    // default opponent opens instead and the next save overwrites it.
    return defaultBot();
  }
}

/// Writes the demo opponent down, so the next take is set up the same way.
Future<void> saveBot(BotOpponent bot) async {
  final store = await SharedPreferences.getInstance();
  await store.setString(_kBotStore, jsonEncode(bot.toJson()));
}
