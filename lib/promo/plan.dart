/// What one promo match is made of: who is on each side, and how the
/// opponent's count moves. Kept between launches, so a take can be filmed
/// again without filling the form in again.
library;

import 'dart:convert';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

import '../xp.dart';

/// How the opponent's count moves through the minute.
enum OpponentMode {
  /// Follows yours, always [PromoPlan.behindBy] behind: you win by that much.
  behind,

  /// Ends on [PromoPlan.finalCount], paced like a real set: quicker at the
  /// start, slower as the minute wears on.
  finalCount,

  /// Every rep at the second given for it in [PromoPlan.customSeconds].
  custom,
}

class PromoPlan {
  PromoPlan({
    this.myName = 'You',
    this.myPhoto,
    this.myTier = 3,
    this.myDiv = 2,
    this.myLp = 64,
    this.oppName = 'iron_mike',
    this.oppPhoto,
    this.oppTier = 5,
    this.oppDiv = 1,
    this.mode = OpponentMode.behind,
    this.behindBy = 2,
    this.finalCount = 20,
    this.customSeconds = '2, 4, 6, 8, 10, 13, 16, 19, 22, 25',
    this.countdownSeconds = 10,
    this.myLevel = 12,
    this.oppLevel = 27,
    this.levelUp = false,
    this.record = true,
    this.camera4k = false,
    this.film916 = true,
  });

  String myName;
  String? myPhoto;
  int myTier;
  int myDiv;
  int myLp;

  String oppName;
  String? oppPhoto;
  int oppTier;
  int oppDiv;

  OpponentMode mode;
  int behindBy;
  int finalCount;

  /// "2, 4.5, 7 …": the second of the round each of the opponent's reps
  /// lands on, as typed.
  String customSeconds;

  /// From both lifters being on the camera screen to the round starting:
  /// ten in the real app.
  int countdownSeconds;

  /// The level beside each name, as the app shows it (xp.dart).
  int myLevel;
  int oppLevel;

  /// Whether this take ends on the level-up screen: the match pays just
  /// enough to reach the next level.
  bool levelUp;

  /// Film each take into Photos from inside the app, rather than with the
  /// phone's own screen recorder.
  bool record;

  /// The camera at the most the lens gives (4K) rather than 1080p.
  bool camera4k;

  /// Film in 9:16, the shape TikTok and Reels show: the take is drawn in a
  /// 9:16 frame across the screen, and only the frame is kept.
  bool film916;

  /// Experience at the very start of [level].
  static int xpAt(int level) {
    var xp = 0;
    for (var n = 1; n < level; n++) {
      xp += xpToLevelUp(n);
    }
    return xp;
  }

  /// Where the experience stood before a take that paid [gained]: just short
  /// of the next level when the plan asks for a level-up, a third of the way
  /// into this one when not.
  int myXpBefore(int gained) {
    final start = xpAt(myLevel);
    final span = xpToLevelUp(myLevel);
    if (levelUp) return start + math.max(0, span - gained + 3);
    return start + math.max(0, math.min(span ~/ 3, span - gained - 1));
  }

  static const roundMs = 60000;

  /// When each of the opponent's reps lands, in milliseconds from the start
  /// of the round. Empty for [OpponentMode.behind], which follows yours.
  List<int> repTimesMs() => switch (mode) {
    OpponentMode.behind => const [],
    OpponentMode.finalCount => paced(finalCount),
    OpponentMode.custom => parseSeconds(customSeconds),
  };

  /// [count] reps across the minute the way a lifter does them: the first a
  /// second and a half in, the gaps widening as they tire, the last a couple
  /// of seconds before the end — with a little unevenness, the same every
  /// time for the same count so a retake matches.
  static List<int> paced(int count) {
    if (count <= 0) return const [];
    final jitter = math.Random(count);
    final out = <int>[];
    for (var k = 1; k <= count; k++) {
      final share = math.pow(k / count, 1.18).toDouble();
      final ms = 1500 + share * 56500 + (jitter.nextDouble() - 0.5) * 400;
      out.add(ms.clamp(500, roundMs - 500).round());
    }
    out.sort();
    return out;
  }

  /// Seconds as typed — commas, spaces or new lines between them, decimals
  /// allowed — into sorted milliseconds inside the round. Anything that is
  /// not a number, or falls outside the minute, is left out.
  static List<int> parseSeconds(String text) {
    final out = <int>[];
    for (final part in text.split(RegExp(r'[\s,;]+'))) {
      final value = double.tryParse(part.trim());
      if (value == null || value < 0 || value > 60) continue;
      out.add((value * 1000).round());
    }
    out.sort();
    return out;
  }

  // ─────────────────────────────── kept ───────────────────────────────

  static const _key = 'promo.plan';

  Map<String, Object?> toJson() => {
    'myName': myName,
    'myPhoto': myPhoto,
    'myTier': myTier,
    'myDiv': myDiv,
    'myLp': myLp,
    'oppName': oppName,
    'oppPhoto': oppPhoto,
    'oppTier': oppTier,
    'oppDiv': oppDiv,
    'mode': mode.name,
    'behindBy': behindBy,
    'finalCount': finalCount,
    'customSeconds': customSeconds,
    'countdownSeconds': countdownSeconds,
    'myLevel': myLevel,
    'oppLevel': oppLevel,
    'levelUp': levelUp,
    'record': record,
    'camera4k': camera4k,
    'film916': film916,
  };

  static PromoPlan fromJson(Map<String, Object?> j) {
    int read(String k, int fallback) => (j[k] as num?)?.toInt() ?? fallback;
    final plan = PromoPlan();
    return plan
      ..myName = j['myName'] as String? ?? plan.myName
      ..myPhoto = j['myPhoto'] as String?
      ..myTier = read('myTier', plan.myTier)
      ..myDiv = read('myDiv', plan.myDiv)
      ..myLp = read('myLp', plan.myLp)
      ..oppName = j['oppName'] as String? ?? plan.oppName
      ..oppPhoto = j['oppPhoto'] as String?
      ..oppTier = read('oppTier', plan.oppTier)
      ..oppDiv = read('oppDiv', plan.oppDiv)
      ..myLevel = read('myLevel', plan.myLevel).clamp(1, 99)
      ..oppLevel = read('oppLevel', plan.oppLevel).clamp(1, 99)
      ..levelUp = j['levelUp'] as bool? ?? plan.levelUp
      ..record = j['record'] as bool? ?? plan.record
      ..camera4k = j['camera4k'] as bool? ?? plan.camera4k
      ..film916 = j['film916'] as bool? ?? plan.film916
      ..mode = OpponentMode.values.firstWhere(
        (m) => m.name == j['mode'],
        orElse: () => plan.mode,
      )
      ..behindBy = read('behindBy', plan.behindBy)
      ..finalCount = read('finalCount', plan.finalCount)
      ..customSeconds = j['customSeconds'] as String? ?? plan.customSeconds
      ..countdownSeconds = read('countdownSeconds', plan.countdownSeconds);
  }

  static Future<PromoPlan> load() async {
    try {
      final store = await SharedPreferences.getInstance();
      final raw = store.getString(_key);
      if (raw != null) {
        return fromJson(jsonDecode(raw) as Map<String, Object?>);
      }
    } on Object catch (_) {
      // A plan that cannot be read is replaced by the defaults.
    }
    return PromoPlan();
  }

  Future<void> save() async {
    final store = await SharedPreferences.getInstance();
    await store.setString(_key, jsonEncode(toJson()));
  }
}
