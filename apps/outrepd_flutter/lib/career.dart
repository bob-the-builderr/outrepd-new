/// Everything this account has done, and the one door that changes it.
///
/// Before this existed the app had no memory: a duel ended, the screen popped,
/// and the LP, the record, the rep total, the history and the placements were
/// all exactly where they had been. Every screen was a careful view of numbers
/// that could not move.
///
/// So there is one entry point — [recordDuel] — and it does the whole job in
/// one place: rank, record, totals, history, the day log, the streak and the
/// titles. Spreading those across the screens that happen to display them is
/// how an account ends up with a win in its history and no LP for it.
///
/// [recordSettledDuel] is the same job for a duel the server has already
/// decided. It exists so a real opponent's result is never run back through
/// the local arithmetic [recordDuel] uses for practice and for the demo
/// opponents — a second computation of the same rule is exactly how two
/// numbers end up disagreeing.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart'
    show RemoteProfile, ServerDuel, SettledDuel, backend;
import 'data.dart';
import 'health_sync.dart';
import 'ranking.dart';
import 'rewards.dart';
import 'xp.dart';

/// Overwrites this account's ladder identity with the server's.
///
/// [Career] otherwise only ever learns about the ladder from a duel this
/// device itself just played, persisted to this device's own storage — so a
/// fresh install, a second phone, or storage the OS cleared all open on the
/// hardcoded sample profile with no way back to the real one. Signing in
/// does know the real one; this is the one place it is allowed to overwrite
/// what local storage restored, because the server is the one holding the
/// row [applyServerProfile] is copying from.
///
/// Left alone on purpose: the match history and the day-by-day rep log. The
/// server has no view of either — it settles duels, it does not keep a diary
/// — so there is nothing truer than what this device already has for them.
void applyServerProfile(RemoteProfile me) {
  demoProfile
    ..tierIdx = me.tierIdx
    ..divIdx = me.divIdx
    ..lp = me.lp
    ..friendCode = me.friendCode
    ..peakTierIdx = me.peakTierIdx
    ..wins = me.wins
    ..losses = me.losses
    ..winStreak = me.winStreak
    ..bestStreak = me.bestStreak
    ..placementsDone = me.placementsDone
    ..placementWins = me.placementWins
    ..totalReps = me.totalReps
    ..bestSet = me.bestSet
    ..xp = me.xp;
  if (me.country case final code?) demoProfile.country = code;
}

/// What one duel did, so the screen after it can say what happened.
class DuelOutcome {
  const DuelOutcome({
    required this.won,
    required this.rank,
    required this.record,
    required this.placementsFinished,
    required this.newBest,
    this.madeFriendly = false,
    this.todayBefore = 0,
    this.todayAfter = 0,
    this.savedToHealth,
  });

  final bool won;

  /// Completes true once this set is in Apple Health or Health Connect;
  /// false, or null, when it was not saved there.
  final Future<bool>? savedToHealth;

  /// Today's push-ups before this duel and after it, every format counted:
  /// what tells the result screen this was the set that met today's goal.
  final int todayBefore;
  final int todayAfter;

  /// Played as ranked, settled as friendly: the server's two-a-day rule with
  /// the same lifter. The result screen says so instead of showing a rank
  /// card that moved nothing.
  final bool madeFriendly;

  /// How the rank moved. Null while the account is still in placements —
  /// there is no rank to move yet, which is the whole point of placements.
  final RankChange? rank;

  final MatchRecord record;

  /// This duel was the last placement, and a tier has just been set.
  final bool placementsFinished;

  /// The set beat the lifter's previous best.
  final bool newBest;
}

/// How many days of rep counts are kept.
///
/// The chart shows seven. A month is held anyway because it costs a few dozen
/// bytes and it is the difference between being able to add a longer view
/// later and asking everybody to start their history again.
const _kDaysKept = 31;

/// How many duels stay in the history.
const _kHistoryKept = 50;

class Career extends ChangeNotifier {
  Career._();

  static final instance = Career._();

  static const _kProfile = 'career.profile';
  static const _kHistory = 'career.history';
  static const _kDays = 'career.days';
  static const _kDuelIds = 'career.duelIds';
  static const _kHistorySynced = 'career.historySynced';

  /// The server's duels that are already in the history, by id, so each one
  /// is written down once — by the screen that watched it, or by
  /// [syncHistory] when no screen did.
  final Set<String> _inHistory = {};

  /// False only on a phone updated from before the history came from the
  /// server, until [syncHistory] first runs: the history it kept holds its
  /// own duels already, without their ids.
  bool _historySynced = true;
  Future<void>? _syncing;

  /// Reps counted on each day, keyed by date. The key is a plain `yyyy-mm-dd`
  /// so it survives a timezone change without turning into a different day.
  final Map<String, int> _days = {};

  bool _loaded = false;
  bool get loaded => _loaded;

  // ─────────────────────────────── reading ───────────────────────────────

  /// Reps for each of the last seven days, oldest first, ending today.
  ///
  /// Always seven entries, zeros included: a rest day is part of the answer to
  /// "did I train this week", and a chart that skips it is a chart that lies
  /// by omission.
  List<int> get weekReps {
    final today = DateTime.now();
    return [
      for (var back = 6; back >= 0; back--)
        _days[_key(today.subtract(Duration(days: back)))] ?? 0,
    ];
  }

  int get repsToday => _days[_key(DateTime.now())] ?? 0;

  Rank get rank => Rank(
    tierIdx: demoProfile.tierIdx,
    divIdx: demoProfile.divIdx,
    lp: demoProfile.lp,
  );

  // ─────────────────────────────── writing ───────────────────────────────

  /// Records a finished duel and returns what it changed.
  ///
  /// [opponentTier] no longer prices the result — LP is exactly the gap in
  /// reps now — but it still decides titles like Giant Slayer, which are
  /// about who was raced rather than by how much. [forfeit] means they left
  /// rather than lost.
  Future<DuelOutcome> recordDuel({
    required int yourReps,
    required int theirReps,
    required String opponent,
    required int opponentTier,
    bool forfeit = false,
    bool clean = false,
    bool surrendered = false,
    bool ranked = true,
  }) async {
    final p = demoProfile;
    final todayBefore = repsToday;
    // Captured before either branch below can move it — Giant Slayer asks
    // about the gap at the moment this account was racing them, not after
    // this duel's own result has already shifted it.
    final beforeTierIdx = p.tierIdx;

    // Walking out is a loss, whatever the count said at the moment you left.
    // Otherwise the way to protect a rank is to quit while ahead of somebody
    // who is still going — which is not a thing a ladder can allow.
    final won = surrendered ? false : (forfeit || yourReps >= theirReps);

    // ── the rank ────────────────────────────────────────────────────────
    RankChange? change;
    var placementsFinished = false;

    // A friend room is a real opponent and a real result, and it moves
    // nothing: not the ladder, not the placements, not the win record the
    // ladder is built on. Reps still count — those were done.
    if (!ranked) {
      // Captured before _countReps moves it — that call sets bestSet to
      // yourReps on exactly the sets that just beat it, which would make a
      // comparison taken afterwards always false.
      final previousBest = p.bestSet;
      _countReps(yourReps);
      p.xp += kXpPerMatch;
      final record = MatchRecord(
        won: won,
        userReps: yourReps,
        opponentReps: theirReps,
        opponent: opponent,
        lpChange: 0,
        at: DateTime.now(),
      );
      matchHistory.insert(0, record);
      if (matchHistory.length > _kHistoryKept) {
        matchHistory.removeRange(_kHistoryKept, matchHistory.length);
      }
      await _checkMomentTitles(
        won: won,
        myTierBefore: beforeTierIdx,
        opponentTier: opponentTier,
        opponent: opponent,
      );
      await _afterSession(clean: clean);
      return DuelOutcome(
        won: won,
        rank: null,
        record: record,
        placementsFinished: false,
        newBest: yourReps > previousBest,
        todayBefore: todayBefore,
        todayAfter: repsToday,
        savedToHealth: _lastHealthSave,
      );
    }

    if (!p.isRanked) {
      // Placements do not move a rank, because there is not one yet. They
      // only count towards the tier that will be set at the end.
      p.placementsDone += 1;
      if (won) p.placementWins += 1;

      if (p.isRanked) {
        final placed = placementRank(p.placementWins);
        p
          ..tierIdx = placed.tierIdx
          ..divIdx = placed.divIdx
          ..lp = placed.lp
          ..peakTierIdx = placed.tierIdx;
        placementsFinished = true;
      }
    } else {
      // A forfeit has no reps to compare, so it pays flat. Everything else is
      // exactly the gap in reps, signed by [won] rather than by the reps
      // alone — walking out while still ahead must stay a loss, and quitting
      // early already costs more of its own accord besides, since it means
      // fewer reps of your own on the board.
      final delta = forfeit
          ? kForfeitLp
          : lpFor(won: won, yourReps: yourReps, theirReps: theirReps);

      change = applyLp(rank, delta, floorTierIdx: p.peakTierIdx);
      p
        ..tierIdx = change.after.tierIdx
        ..divIdx = change.after.divIdx
        ..lp = change.after.lp;
      // The peak only ever climbs. It is what the floor rule stands on.
      if (p.tierIdx > p.peakTierIdx) p.peakTierIdx = p.tierIdx;
    }

    // ── the record ──────────────────────────────────────────────────────
    if (won) {
      p.wins += 1;
      p.winStreak += 1;
    } else {
      p.losses += 1;
      p.winStreak = 0;
    }
    if (p.winStreak > p.bestStreak) p.bestStreak = p.winStreak;

    final newBest = yourReps > p.bestSet;
    _countReps(yourReps);
    p.xp += kXpPerMatch;

    final record = MatchRecord(
      won: won,
      userReps: yourReps,
      opponentReps: theirReps,
      opponent: opponent,
      lpChange: change?.lpDelta ?? 0,
      at: DateTime.now(),
    );
    matchHistory.insert(0, record);
    if (matchHistory.length > _kHistoryKept) {
      matchHistory.removeRange(_kHistoryKept, matchHistory.length);
    }

    await _checkMomentTitles(
      won: won,
      myTierBefore: beforeTierIdx,
      opponentTier: opponentTier,
      opponent: opponent,
    );
    await _afterSession(clean: clean);

    return DuelOutcome(
      won: won,
      rank: change,
      record: record,
      placementsFinished: placementsFinished,
      newBest: newBest,
      todayBefore: todayBefore,
      todayAfter: repsToday,
      savedToHealth: _lastHealthSave,
    );
  }

  /// Records a duel `settle_duel` has already decided.
  ///
  /// Every number [recordDuel] would otherwise compute — who won, what it
  /// paid, the record, the placements — was already decided on the row the
  /// server read the reps from, including the surrender rule and the depth
  /// bonus, because those travelled up on the set itself. Recomputing any of
  /// it here would just be a second copy of `settle_duel`'s own logic, kept
  /// nowhere near it and free to drift.
  ///
  /// [ranked] only decides what the result screen is shown: a friend duel is
  /// still fully settled (the server pays it out at zero either way), but it
  /// is not a rung, so it gets no [RankChange] here — matching what a friend
  /// duel already shows when [recordDuel] handles one locally.
  Future<DuelOutcome> recordSettledDuel({
    required SettledDuel settled,
    required int yourReps,
    required int theirReps,
    required String opponent,
    required int opponentTier,
    required bool ranked,
    bool clean = false,
  }) async {
    final p = demoProfile;
    final todayBefore = repsToday;
    final wasRanked = p.isRanked;
    final previousBest = p.bestSet;
    final before = Rank(tierIdx: p.tierIdx, divIdx: p.divIdx, lp: p.lp);
    // What the server settled, which can be less than what was asked for.
    final madeFriendly = ranked && !settled.ranked;
    final counted = ranked && settled.ranked;

    p
      ..tierIdx = settled.tierIdx
      ..divIdx = settled.divIdx
      ..lp = settled.lp
      ..wins = settled.wins
      ..losses = settled.losses
      ..winStreak = settled.winStreak
      ..bestStreak = settled.bestStreak
      ..placementsDone = settled.placementsDone
      ..placementWins = settled.placementWins;
    // The floor a local change would have kept can't drift behind a rank the
    // server just gave this account.
    if (p.peakTierIdx < p.tierIdx) p.peakTierIdx = p.tierIdx;

    final newBest = yourReps > previousBest;
    _countReps(yourReps);
    // What xp_for_duel pays on the server, which the next read of the
    // profile brings back anyway.
    p.xp += kXpPerMatch;

    final record = MatchRecord(
      won: settled.won,
      userReps: yourReps,
      opponentReps: theirReps,
      opponent: opponent,
      lpChange: settled.lpDelta,
      at: DateTime.now(),
    );
    // Once: syncHistory may have read it from the server first, when its
    // answer and this screen's crossed.
    if (_inHistory.add(settled.duelId)) {
      _recordedSinceSync.add(settled.duelId);
      matchHistory.insert(0, record);
      if (matchHistory.length > _kHistoryKept) {
        matchHistory.removeRange(_kHistoryKept, matchHistory.length);
      }
    }

    await _checkMomentTitles(
      won: settled.won,
      myTierBefore: before.tierIdx,
      opponentTier: opponentTier,
      opponent: opponent,
    );
    await _afterSession(clean: clean);

    return DuelOutcome(
      won: settled.won,
      // No rank change while placements are still open, matching the local
      // path — even on the placement that just finished them, [recordDuel]
      // reports no RankChange either, so this stays consistent with it.
      rank: (counted && wasRanked)
          ? RankChange(
              before: before,
              after: Rank(
                tierIdx: settled.tierIdx,
                divIdx: settled.divIdx,
                lp: settled.lp,
              ),
              lpDelta: settled.lpDelta,
            )
          : null,
      record: record,
      placementsFinished: counted && !wasRanked && p.isRanked,
      newBest: newBest,
      madeFriendly: madeFriendly,
      todayBefore: todayBefore,
      todayAfter: repsToday,
      savedToHealth: _lastHealthSave,
    );
  }

  /// Writes into the history every duel of this account's that no screen on
  /// this phone wrote down, and takes the rank they moved from the server.
  ///
  /// The screens write down what they watch happen. Not everything does:
  ///   * a ranked match with nobody live and no saved set to race puts the
  ///     set in the pool, and its result comes when somebody races it — on
  ///     their phone;
  ///   * a live result can land after its screen was closed;
  ///   * a result can be settled on the server and its answer lost on the
  ///     way back.
  /// Each of those moved the rank and reached no history. Nothing is counted
  /// again here: the reps were counted when the set was lifted, and the
  /// record and placements are the server's, read back whole.
  ///
  /// On a phone that kept a history before this existed, the first run takes
  /// only what that history could never have had — the sets raced while
  /// away — because the rest is already in it, without ids to tell. On an
  /// empty one (a new phone, another account) it takes everything.
  Future<void> syncHistory() =>
      _syncing ??= _syncHistory().whenComplete(() => _syncing = null);

  Future<void> _syncHistory() async {
    if (!backend.available || backend.me == null) return;
    final List<ServerDuel> duels;
    try {
      duels = await backend.myDuels();
    } on Object catch (error) {
      debugPrint('Could not read the duels for the history: $error');
      return;
    }

    final firstOnAKeptHistory = !_historySynced && matchHistory.isNotEmpty;
    final fresh = <ServerDuel>[];
    for (final d in duels) {
      if (_inHistory.contains(d.duelId)) continue;
      if (firstOnAKeptHistory && !d.racedWhileAway) {
        _inHistory.add(d.duelId);
        continue;
      }
      fresh.add(d);
    }
    // Only what the server still lists, plus whatever a screen wrote down
    // since it asked: an id older than the last fifty is never handed back
    // again, so it need not be remembered either.
    final listed = {for (final d in duels) d.duelId};
    _inHistory.retainWhere(
      (id) => listed.contains(id) || _recordedSinceSync.contains(id),
    );
    _recordedSinceSync.clear();
    _inHistory.addAll(fresh.map((d) => d.duelId));
    _historySynced = true;

    if (fresh.isNotEmpty) {
      for (final d in fresh) {
        matchHistory.add(
          MatchRecord(
            won: d.won,
            userReps: d.yourReps,
            opponentReps: d.theirReps,
            opponent: d.opponentName,
            lpChange: d.lpDelta,
            at: d.at,
          ),
        );
      }
      matchHistory.sort((a, b) => b.at.compareTo(a.at));
      if (matchHistory.length > _kHistoryKept) {
        matchHistory.removeRange(_kHistoryKept, matchHistory.length);
      }
      // The rank, the record and the placements those duels moved.
      try {
        if (await backend.refreshMe() case final me?) applyServerProfile(me);
      } on Object catch (error) {
        debugPrint('Could not read the profile back: $error');
      }
    }
    await save();
    if (fresh.isNotEmpty) notifyListeners();
  }

  /// Duel ids a screen wrote down while [syncHistory] was waiting on the
  /// server, so its answer — read before they existed — does not forget them.
  final Set<String> _recordedSinceSync = {};

  /// Asks the server again a few times over the next couple of minutes: for
  /// a live result whose screen was closed before it came, which the server
  /// settles once the round is long overdue.
  void syncHistorySoon() {
    for (final wait in const [
      Duration(seconds: 20),
      Duration(seconds: 70),
      Duration(seconds: 150),
    ]) {
      Timer(wait, () => unawaited(syncHistory()));
    }
  }

  /// Records a solo set. Reps and the streak count; nothing else does.
  ///
  /// Practice deliberately cannot move a rank. If it could, the ladder would
  /// measure who was willing to farm an empty room.
  Future<void> recordPractice(int reps, {bool clean = false}) async {
    if (reps <= 0) {
      // Nothing happened. Not even a streak day — showing up and doing none
      // is not a day of training, and pretending otherwise makes the streak
      // mean nothing. Nor anything for Health, whatever went before.
      _lastHealthSave = Future.value(false);
      return;
    }
    _countReps(reps);
    await _afterSession(clean: clean);
  }

  void _countReps(int reps) {
    final p = demoProfile;
    p.totalReps += reps;
    p.xp += reps;
    if (reps > p.bestSet) p.bestSet = reps;

    final key = _key(DateTime.now());
    _days[key] = (_days[key] ?? 0) + reps;
    _trimDays();
    // Copied to Apple Health or Health Connect, if the lifter asked for it.
    // Not waited on; the result screen hears whether it went from here.
    _lastHealthSave = HealthSync.recordSet(reps);
  }

  /// Whether the last set counted reached Apple Health or Health Connect —
  /// what a result screen says under the count.
  Future<bool> get lastHealthSave => _lastHealthSave;
  Future<bool> _lastHealthSave = Future.value(false);

  /// Titles only the duel that just happened can judge — the server does not
  /// grade them and there is no running total to check them against, so this
  /// is the one place they are decided, right where the result already is.
  Future<void> _checkMomentTitles({
    required bool won,
    required int myTierBefore,
    required int opponentTier,
    required String opponent,
  }) async {
    if (!won) return;

    if (opponentTier - myTierBefore >= 2) {
      await rewards.award('giant_slayer');
    }

    // The three matches right before this one — [matchHistory] already holds
    // this one at index 0, so the streak being asked about starts at 1.
    if (matchHistory.length >= 4 &&
        matchHistory.skip(1).take(3).every((m) => !m.won)) {
      await rewards.award('comeback');
    }

    final winsAgainst =
        matchHistory.where((m) => m.opponent == opponent && m.won).length;
    if (winsAgainst >= 5) await rewards.award('nemesis');
  }

  /// The bookkeeping every session shares: the day streak, the titles it may
  /// have unlocked, and writing all of it down.
  ///
  /// [clean] is this session's own set — whether every rep in it counted —
  /// not a running total; [Rewards] is the one that keeps the tally.
  Future<void> _afterSession({bool clean = false}) async {
    final p = demoProfile;

    await rewards.recordSession(
      matches: p.totalMatches,
      wins: p.wins,
      reps: p.totalReps,
      tierIdx: p.tierIdx,
      friends: await currentFriendCount(),
      clean: clean,
    );
    // One streak, one owner. The profile's card and the home screen's pill
    // both read this field, and `rewards` is what actually understands rest
    // days — so it is the source and this is a copy, not a second opinion.
    p.dayStreak = rewards.streak;

    await save();
    notifyListeners();
  }

  void _trimDays() {
    if (_days.length <= _kDaysKept) return;
    final keys = _days.keys.toList()..sort();
    for (final key in keys.take(_days.length - _kDaysKept)) {
      _days.remove(key);
    }
  }

  static String _key(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';

  // ───────────────────────────── persistence ─────────────────────────────

  Future<void> save() async {
    final p = demoProfile;
    final store = await SharedPreferences.getInstance();

    await store.setString(
      _kProfile,
      jsonEncode({
        'tier': p.tierIdx,
        'div': p.divIdx,
        'lp': p.lp,
        'peak': p.peakTierIdx,
        'wins': p.wins,
        'losses': p.losses,
        'winStreak': p.winStreak,
        'bestStreak': p.bestStreak,
        'totalReps': p.totalReps,
        'bestSet': p.bestSet,
        'placementsDone': p.placementsDone,
        'placementWins': p.placementWins,
        'xp': p.xp,
      }),
    );
    await store.setString(
      _kHistory,
      jsonEncode([for (final m in matchHistory) m.toJson()]),
    );
    await store.setString(_kDays, jsonEncode(_days));
    await store.setStringList(_kDuelIds, _inHistory.toList());
    await store.setBool(_kHistorySynced, _historySynced);
  }

  /// Reads the account back.
  ///
  /// Every branch of this can fail on a file somebody else wrote — an older
  /// version, a half-finished write, a hand-edited preferences file — and none
  /// of it is worth refusing to launch over. A career that cannot be read is
  /// replaced by a fresh one rather than taking the app down with it.
  Future<void> load() async {
    _loaded = true;
    final store = await SharedPreferences.getInstance();

    try {
      final raw = store.getString(_kProfile);
      if (raw != null) {
        final json = jsonDecode(raw) as Map<String, Object?>;
        int read(String key, int fallback) =>
            (json[key] as num?)?.toInt() ?? fallback;

        final p = demoProfile;
        p
          ..tierIdx = read('tier', p.tierIdx).clamp(0, kTopTier)
          ..divIdx = read('div', p.divIdx).clamp(0, kTopDivision)
          ..lp = read('lp', p.lp).clamp(0, 99)
          ..peakTierIdx = read('peak', p.peakTierIdx).clamp(0, kTopTier)
          ..wins = read('wins', p.wins)
          ..losses = read('losses', p.losses)
          ..winStreak = read('winStreak', p.winStreak)
          ..bestStreak = read('bestStreak', p.bestStreak)
          ..totalReps = read('totalReps', p.totalReps)
          ..bestSet = read('bestSet', p.bestSet)
          ..placementsDone = read('placementsDone', p.placementsDone)
          ..placementWins = read('placementWins', p.placementWins)
          // Kept from before there was experience: what those reps and
          // matches would have paid, until the server's own number arrives.
          ..xp = read('xp', p.totalReps + kXpPerMatch * p.totalMatches);

        // A stored peak below the stored tier would let the floor rule hand
        // back a tier the account has earned.
        if (p.peakTierIdx < p.tierIdx) p.peakTierIdx = p.tierIdx;
      }
    } on Object catch (error) {
      debugPrint('Could not read the stored rank: $error');
    }

    try {
      final raw = store.getString(_kHistory);
      if (raw != null) {
        final list = jsonDecode(raw) as List<Object?>;
        matchHistory
          ..clear()
          ..addAll([
            for (final entry in list)
              if (entry is Map<String, Object?>) ?MatchRecord.fromJson(entry),
          ]);
      }
    } on Object catch (error) {
      debugPrint('Could not read the match history: $error');
    }
    _inHistory
      ..clear()
      ..addAll(store.getStringList(_kDuelIds) ?? const []);
    // Unset on a phone updated from before the history came from the server:
    // whatever history it kept holds its own duels without their ids.
    _historySynced =
        store.getBool(_kHistorySynced) ?? matchHistory.isEmpty;

    try {
      final raw = store.getString(_kDays);
      if (raw != null) {
        final map = jsonDecode(raw) as Map<String, Object?>;
        _days
          ..clear()
          ..addEntries([
            for (final entry in map.entries)
              if (entry.value case final num reps)
                MapEntry(entry.key, reps.toInt()),
          ]);
        _trimDays();
      }
    } on Object catch (error) {
      debugPrint('Could not read the training days: $error');
    }

    // `rewards` owns the streak and understands rest days; the profile field
    // is a copy for the screens to read. Syncing here keeps them from
    // disagreeing on the first frame after a launch.
    demoProfile.dayStreak = rewards.streak;

    notifyListeners();
  }

  /// Starts an account from nothing.
  ///
  /// Called when onboarding finishes. Without it a new install inherits the
  /// seed profile's rank and record — a first-time lifter opening the app to
  /// find eighteen wins and a Gold badge they did not earn.
  Future<void> startFresh() async {
    demoProfile
      ..tierIdx = 0
      ..divIdx = 0
      ..lp = 0
      ..peakTierIdx = 0
      ..wins = 0
      ..losses = 0
      ..winStreak = 0
      ..dayStreak = 0
      ..bestStreak = 0
      ..totalReps = 0
      ..bestSet = 0
      ..placementsDone = 0
      ..placementWins = 0
      ..xp = 0;
    matchHistory.clear();
    _days.clear();
    _forgetServerDuels();
    await save();
    notifyListeners();
  }

  /// A history started again holds none of the server's duels, and the next
  /// [syncHistory] takes them all: everything written into it from here on
  /// carries its id.
  void _forgetServerDuels() {
    _inHistory.clear();
    _recordedSinceSync.clear();
    _historySynced = true;
  }

  /// Switches this device onto a different real account — signing into one
  /// that already exists, not the one anonymous to this install.
  ///
  /// The match history and the day-by-day rep log are this *device's* own
  /// record of what it watched happen, and none of it happened to the
  /// account just signed into — carrying it over would show somebody a
  /// training log for sessions that were not theirs. [applyServerProfile]
  /// supplies the real ladder identity in their place.
  Future<void> adoptServerProfile(RemoteProfile me) async {
    matchHistory.clear();
    _days.clear();
    // Their duels come from the server instead, on the next syncHistory.
    _forgetServerDuels();
    applyServerProfile(me);
    await save();
    notifyListeners();
  }

  /// Wipes the account. Used by tests, and by whatever ends up offering a
  /// "start over" in settings.
  @visibleForTesting
  Future<void> reset() async {
    matchHistory.clear();
    _days.clear();
    _forgetServerDuels();
    final store = await SharedPreferences.getInstance();
    await store.remove(_kProfile);
    await store.remove(_kHistory);
    await store.remove(_kDays);
    await store.remove(_kDuelIds);
    await store.remove(_kHistorySynced);
    notifyListeners();
  }
}
