/// Titles worth wearing, and a streak that understands rest days.
///
/// Frames come from rank, which means only the strong ever get one. These are
/// the other half: things a beginner can earn in their first week, and things
/// that say something about *how* someone trains rather than how much they
/// lift. Every one of them is visible to other people — a reward nobody else
/// can see does not motivate anyone.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import 'backend/backend.dart';

import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What a title asks of you. Kept as plain numbers so the condition can be
/// checked against a profile without each title carrying its own code.
enum TitleKind {
  matches,
  wins,
  reps,
  streakDays,
  tier,
  cleanSet,
  giantSlayer,
  comeback,
  earlyBird,
  nightOwl,
  friends,
  perfectWeek,
}

class EarnedTitle {
  const EarnedTitle.of(
    this.id,
    this.title,
    this.hint,
    this.kind,
    this.threshold,
    this.icon, [
    this.colour,
  ]);

  const EarnedTitle({
    required this.id,
    required this.title,
    required this.hint,
    required this.kind,
    required this.threshold,
    required this.icon,
    this.colour,
  });

  final String id;

  /// What it says beside your name.
  final String title;

  /// What you have to do, in words a lifter would use.
  final String hint;

  final TitleKind kind;
  final int threshold;
  final IconData icon;

  /// Rare titles carry their own colour so they stand out in a list of names.
  final Color? colour;
}

const gold = Color(0xFFFFD700);
const cyan = Color(0xFF00E5FF);
const purple = Color(0xFF9B59B6);
const orange = Color(0xFFFF8C00);
const green = Color(0xFF22C55E);
const red = Color(0xFFFF4444);

/// Shorthand for the list below. Sixty titles written out in full would be
/// unreadable, and a list nobody can read is a list nobody adds to.
typedef T = EarnedTitle;

/// Written to be worth wanting. A title people would rather not wear is the
/// same as no title at all, so each one is a small boast: something you would
/// say out loud about how you train.
/// The title with this id, or null for none or one this build does not know
/// (a newer version of the app may have added it).
EarnedTitle? titleById(String? id) {
  if (id == null) return null;
  for (final title in kTitles) {
    if (title.id == id) return title;
  }
  return null;
}

const kTitles = <EarnedTitle>[
  // ---- getting started -------------------------------------------------
  T.of(
    'first_blood',
    'First Blood',
    'Finish your first match',
    TitleKind.matches,
    1,
    Icons.flag,
  ),
  T.of(
    'found_footing',
    'Found Your Footing',
    'Finish five matches',
    TitleKind.matches,
    5,
    Icons.directions_walk,
  ),
  T.of(
    'regular',
    'Regular',
    'Twenty matches',
    TitleKind.matches,
    20,
    Icons.event_repeat,
  ),
  T.of(
    'fifty',
    'Fifty Deep',
    'Fifty matches',
    TitleKind.matches,
    50,
    Icons.filter_5,
  ),
  T.of(
    'century',
    'Century',
    'A hundred matches',
    TitleKind.matches,
    100,
    Icons.emoji_events,
    gold,
  ),
  T.of(
    'veteran',
    'Veteran',
    'Two hundred and fifty matches',
    TitleKind.matches,
    250,
    Icons.shield_moon,
    purple,
  ),
  T.of(
    'thousand_matches',
    'Old Guard',
    'A thousand matches',
    TitleKind.matches,
    1000,
    Icons.workspace_premium,
    purple,
  ),

  // ---- winning ---------------------------------------------------------
  T.of(
    'first_win',
    'Winner',
    'Win a match',
    TitleKind.wins,
    1,
    Icons.check_circle,
  ),
  T.of(
    'on_a_roll',
    'On a Roll',
    'Win three in a row',
    TitleKind.wins,
    3,
    Icons.trending_up,
  ),
  T.of(
    'five_straight',
    'Five Straight',
    'Win five in a row',
    TitleKind.wins,
    5,
    Icons.stacked_line_chart,
  ),
  T.of(
    'unstoppable',
    'Unstoppable',
    'Win ten in a row',
    TitleKind.wins,
    10,
    Icons.rocket_launch,
    cyan,
  ),
  T.of(
    'untouchable',
    'Untouchable',
    'Win twenty in a row',
    TitleKind.wins,
    20,
    Icons.auto_awesome,
    gold,
  ),
  T.of(
    'giant_slayer',
    'Giant Slayer',
    'Beat someone two tiers above you',
    TitleKind.giantSlayer,
    1,
    Icons.bolt,
    purple,
  ),
  T.of(
    'comeback',
    'Comeback',
    'Win straight after three losses',
    TitleKind.comeback,
    1,
    Icons.replay,
  ),
  T.of(
    'nemesis',
    'Nemesis',
    'Beat the same lifter five times',
    TitleKind.comeback,
    5,
    Icons.gps_fixed,
  ),

  // ---- reps ------------------------------------------------------------
  T.of(
    'hundred_reps',
    'Off the Mark',
    'A hundred counted reps',
    TitleKind.reps,
    100,
    Icons.play_arrow,
  ),
  T.of(
    'five_hundred',
    'Warmed Up',
    'Five hundred counted reps',
    TitleKind.reps,
    500,
    Icons.whatshot,
  ),
  T.of(
    'the_machine',
    'The Machine',
    'A thousand counted reps',
    TitleKind.reps,
    1000,
    Icons.settings,
  ),
  T.of(
    'five_thousand',
    'Relentless',
    'Five thousand counted reps',
    TitleKind.reps,
    5000,
    Icons.repeat,
  ),
  T.of(
    'ten_thousand',
    'Ten Thousand',
    'Ten thousand counted reps',
    TitleKind.reps,
    10000,
    Icons.all_inclusive,
    cyan,
  ),
  T.of(
    'fifty_thousand',
    'Beyond Counting',
    'Fifty thousand counted reps',
    TitleKind.reps,
    50000,
    Icons.blur_on,
    purple,
  ),

  // There is no weight ladder. Nothing in this app weighs anything — a match
  // is a count of reps the camera saw, so a kilo total would be a number
  // nobody could earn and nobody could check.

  // ---- showing up ------------------------------------------------------
  T.of(
    'two_days',
    'Back Again',
    'Train two days running',
    TitleKind.streakDays,
    2,
    Icons.replay_circle_filled,
  ),
  T.of(
    'no_days_off',
    'No Days Off',
    'Train seven days running',
    TitleKind.streakDays,
    7,
    Icons.local_fire_department,
  ),
  T.of(
    'fortnight',
    'Fortnight',
    'A fourteen day streak',
    TitleKind.streakDays,
    14,
    Icons.calendar_view_week,
  ),
  T.of(
    'unbroken',
    'Unbroken',
    'A thirty day streak',
    TitleKind.streakDays,
    30,
    Icons.whatshot,
    orange,
  ),
  T.of(
    'sixty_days',
    'Habit',
    'A sixty day streak',
    TitleKind.streakDays,
    60,
    Icons.psychology,
    orange,
  ),
  T.of(
    'hundred_days',
    'Hundred Days',
    'A hundred day streak',
    TitleKind.streakDays,
    100,
    Icons.emoji_flags,
    gold,
  ),
  T.of(
    'year_round',
    'Year Round',
    'A three hundred and sixty five day streak',
    TitleKind.streakDays,
    365,
    Icons.brightness_7,
    gold,
  ),
  T.of(
    'perfect_week',
    'Perfect Week',
    'Train every day of one week',
    TitleKind.perfectWeek,
    1,
    Icons.done_all,
  ),
  T.of(
    'perfect_month',
    'Perfect Month',
    'Four perfect weeks',
    TitleKind.perfectWeek,
    4,
    Icons.verified_user,
    cyan,
  ),

  // ---- rank ------------------------------------------------------------
  // Master is the top of the ladder, so it is the last title here. Mythic and
  // Legend sat above it until the ladder settled at seven tiers, and a title
  // whose threshold is past the ceiling can never be earned — two permanent
  // blanks on the awards screen.
  T.of(
    'bronze_tier',
    'Out of the Iron',
    'Reach Bronze',
    TitleKind.tier,
    1,
    Icons.trending_up,
  ),
  T.of(
    'silver_tier',
    'Silverside',
    'Reach Silver',
    TitleKind.tier,
    2,
    Icons.star_border,
  ),
  T.of(
    'golden_era',
    'Golden Era',
    'Reach Gold',
    TitleKind.tier,
    3,
    Icons.star,
    gold,
  ),
  T.of(
    'platinum_tier',
    'Platinum',
    'Reach Platinum',
    TitleKind.tier,
    4,
    Icons.ac_unit,
  ),
  T.of(
    'diamond_tier',
    'Diamond Hands',
    'Reach Diamond',
    TitleKind.tier,
    5,
    Icons.diamond,
    cyan,
  ),
  T.of(
    'master_tier',
    'Master',
    'Reach Master',
    TitleKind.tier,
    6,
    Icons.local_police,
    red,
  ),

  // ---- form ------------------------------------------------------------
  T.of(
    'clean_hands',
    'Clean Hands',
    'A full set with every rep counted',
    TitleKind.cleanSet,
    1,
    Icons.verified,
    green,
  ),
  T.of(
    'spotless',
    'Spotless',
    'Ten clean sets',
    TitleKind.cleanSet,
    10,
    Icons.cleaning_services,
    green,
  ),
  T.of(
    'textbook',
    'Textbook',
    'Fifty clean sets',
    TitleKind.cleanSet,
    50,
    Icons.menu_book,
    green,
  ),

  // ---- hours -------------------------------------------------------------
  T.of(
    'early_bird',
    'Early Shift',
    'Ten sessions before seven in the morning',
    TitleKind.earlyBird,
    10,
    Icons.wb_twilight,
  ),
  T.of(
    'sunrise_club',
    'Sunrise Club',
    'Fifty sessions before seven',
    TitleKind.earlyBird,
    50,
    Icons.wb_sunny,
    orange,
  ),
  T.of(
    'night_owl',
    'Night Shift',
    'Ten sessions after ten at night',
    TitleKind.nightOwl,
    10,
    Icons.nights_stay,
  ),
  T.of(
    'graveyard',
    'Graveyard Shift',
    'Fifty sessions after ten',
    TitleKind.nightOwl,
    50,
    Icons.dark_mode,
    purple,
  ),

  // ---- people ------------------------------------------------------------
  T.of(
    'not_alone',
    'Not Alone',
    'Add your first friend',
    TitleKind.friends,
    1,
    Icons.person_add,
  ),
  T.of(
    'well_connected',
    'Well Connected',
    'Ten friends',
    TitleKind.friends,
    10,
    Icons.diversity_3,
  ),
  T.of(
    'the_gym_knows',
    'The Gym Knows You',
    'Fifty friends',
    TitleKind.friends,
    50,
    Icons.connect_without_contact,
    cyan,
  ),
];

/// A streak that counts training days but does not punish rest.
///
/// Resting is part of lifting. An app that wipes a month's streak because
/// someone took a Sunday off is teaching a bad habit and, worse, is the moment
/// most people stop opening it — once the number is gone there is nothing left
/// to protect. So a couple of rest days a week are simply allowed.
const kRestDaysPerWeek = 2;

class Rewards extends ChangeNotifier {
  int streak = 0;
  int bestStreak = 0;

  /// Days since the last session, used to decide whether a rest was taken or a
  /// streak was dropped.
  DateTime? lastSession;

  int restUsedThisWeek = 0;

  /// When a broken streak was last brought back with a rewarded video: once
  /// a week (the user's pick, 2026-11-09, B).
  DateTime? streakSaved;

  /// Whether the streak has just ended and may be brought back: there was
  /// one, training today would no longer carry it on, and none was brought
  /// back in the last week.
  bool get streakRestorable {
    if (streak <= 0 || lastSession == null || streakAlive) return false;
    final saved = streakSaved;
    return saved == null ||
        DateTime.now().difference(saved) >= const Duration(days: 7);
  }

  /// Brings the streak back: the days missed are forgiven, as if the last
  /// session were yesterday with the week's rest days spent. Today's
  /// session then carries it on.
  Future<void> restoreStreak() async {
    if (!streakRestorable) return;
    final now = DateTime.now();
    lastSession = DateTime(now.year, now.month, now.day - 1, 12);
    restUsedThisWeek = kRestDaysPerWeek;
    streakSaved = now;
    await _save();
    notifyListeners();
  }

  /// Whole days between the last session and today, or null before the first.
  int? get _daysSinceSession {
    final last = lastSession;
    if (last == null) return null;
    final now = DateTime.now();
    // Dates as UTC midnights, so every day is 24 hours: local midnights a
    // clock change apart are 23 hours apart, which is no whole day at all.
    return DateTime.utc(now.year, now.month, now.day)
        .difference(DateTime.utc(last.year, last.month, last.day))
        .inDays;
  }

  /// A session has already counted today.
  bool get trainedToday => _daysSinceSession == 0;

  /// Whether training today would carry [streak] on: the days missed since
  /// the last session are still within the rest days it forgives. False once
  /// they are not — the number on record is then one the next session resets.
  bool get streakAlive {
    final gap = _daysSinceSession;
    if (gap == null || streak <= 0) return false;
    return gap <= 1 || gap - 1 <= kRestDaysPerWeek - restUsedThisWeek;
  }

  /// Sets confirmed with every rep counted — [TitleKind.cleanSet]'s tally.
  int cleanSets = 0;

  /// Sessions started before seven in the morning, or after ten at night —
  /// [TitleKind.earlyBird] and [TitleKind.nightOwl]'s tallies.
  int earlySessions = 0;
  int lateSessions = 0;

  /// Consecutive calendar days trained with no rest day used at all — unlike
  /// [streak], which forgives [kRestDaysPerWeek] of them. A rest that leaves
  /// the forgiving streak untouched still breaks this one, because a week
  /// with a day off is not the perfect week [TitleKind.perfectWeek] asks for.
  int perfectDayRun = 0;

  /// How many complete 7-day blocks [perfectDayRun] has run through —
  /// [TitleKind.perfectWeek]'s tally. A 28-day perfect run reads as 4, which
  /// is exactly what "Perfect Month" asks for.
  int perfectWeeksCount = 0;

  /// Titles unlocked, and the one being worn.
  final Set<String> earned = {};
  String? wearing;

  EarnedTitle? get worn => titleById(wearing);

  /// What [wearing] the server last heard. Kept so every save does not turn
  /// into a network write, since most saves do not change the title.
  String? _pushedWearing;
  bool _pushedOnce = false;

  /// Tells the server which title this account wears, so it shows beside the
  /// name on other people's screens too. Best effort: a failure only means
  /// they see the old one until the next save.
  void _pushWorn() {
    if (!backend.available) return;
    if (_pushedOnce && _pushedWearing == wearing) return;
    final id = wearing;
    backend.setTitle(id).then((_) {
      _pushedWearing = id;
      _pushedOnce = true;
    }, onError: (Object error) => debugPrint('Could not share title: $error'));
  }

  bool has(String id) => earned.contains(id);

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    streak = store.getInt('streak') ?? 0;
    bestStreak = store.getInt('bestStreak') ?? 0;
    restUsedThisWeek = store.getInt('restUsed') ?? 0;
    cleanSets = store.getInt('cleanSets') ?? 0;
    earlySessions = store.getInt('earlySessions') ?? 0;
    lateSessions = store.getInt('lateSessions') ?? 0;
    perfectDayRun = store.getInt('perfectDayRun') ?? 0;
    perfectWeeksCount = store.getInt('perfectWeeksCount') ?? 0;
    wearing = store.getString('wearingTitle');
    final saved = store.getInt('streakSaved');
    streakSaved = saved == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(saved);

    final stamp = store.getInt('lastSession');
    lastSession = stamp == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(stamp);

    earned
      ..clear()
      ..addAll(store.getStringList('earnedTitles') ?? const []);

    // Once per launch, after sign-in: the server may be behind this phone,
    // from a title picked while offline or on an account just signed into.
    _pushWorn();
  }

  /// Titles are a statement about what you have already done, so they are
  /// checked against the record on every launch rather than only at the moment
  /// a session ends. Otherwise someone who qualified before this existed would
  /// never be given what they had plainly earned.
  Future<List<EarnedTitle>> syncWithProfile({
    required int matches,
    required int wins,
    required int reps,
    int tierIdx = 0,
    int friends = 0,
  }) async {
    final unlocked = _check(
      matches: matches,
      wins: wins,
      reps: reps,
      tierIdx: tierIdx,
      friends: friends,
    );
    if (unlocked.isNotEmpty) await _save();
    return unlocked;
  }

  /// Called when a session finishes. Returns any titles unlocked by it, so the
  /// UI can celebrate rather than leave someone to find it later.
  ///
  /// [clean] is this session's own set, not a running total — whether every
  /// rep in it counted, the same measure [TitleKind.cleanSet] tallies.
  ///
  /// [at] is the moment the session happened, [DateTime.now] unless a test
  /// needs an hour of its own choosing — [TitleKind.earlyBird] and
  /// [TitleKind.nightOwl] read the clock, and a test cannot pick what time it
  /// runs at.
  Future<List<EarnedTitle>> recordSession({
    required int matches,
    required int wins,
    required int reps,
    int tierIdx = 0,
    int friends = 0,
    bool clean = false,
    DateTime? at,
  }) async {
    final today = at ?? DateTime.now();
    final last = lastSession;
    // A gap of zero — already trained today — leaves both runs exactly where
    // they were; anything else is decided below, once each on its own rule.
    var gap = 0;

    if (last == null) {
      streak = 1;
      perfectDayRun = 1;
    } else {
      gap = DateTime.utc(
        today.year,
        today.month,
        today.day,
      ).difference(DateTime.utc(last.year, last.month, last.day)).inDays;

      if (gap == 0) {
        // Already counted today. Training twice does not count twice.
      } else if (gap == 1) {
        streak++;
        perfectDayRun++;
      } else if (gap - 1 <= kRestDaysPerWeek - restUsedThisWeek) {
        // Rest days cover the gap, so the forgiving streak carries on — but a
        // perfect week has no rest days to forgive, so this one breaks here.
        restUsedThisWeek += gap - 1;
        streak++;
        perfectDayRun = 1;
      } else {
        streak = 1;
        perfectDayRun = 1;
        restUsedThisWeek = 0;
      }
    }

    lastSession = today;
    if (streak > bestStreak) bestStreak = streak;
    if (gap == 1 && perfectDayRun > 0 && perfectDayRun % 7 == 0) {
      perfectWeeksCount++;
    }

    if (clean) cleanSets++;
    if (today.hour < 7) earlySessions++;
    if (today.hour >= 22) lateSessions++;

    final unlocked = _check(
      matches: matches,
      wins: wins,
      reps: reps,
      tierIdx: tierIdx,
      friends: friends,
    );
    await _save();
    notifyListeners();
    return unlocked;
  }

  List<EarnedTitle> _check({
    required int matches,
    required int wins,
    required int reps,
    int tierIdx = 0,
    int friends = 0,
  }) {
    final unlocked = <EarnedTitle>[];

    for (final title in kTitles) {
      if (earned.contains(title.id)) continue;

      final reached = switch (title.kind) {
        TitleKind.matches => matches >= title.threshold,
        TitleKind.wins => wins >= title.threshold,
        TitleKind.reps => reps >= title.threshold,
        TitleKind.streakDays => streak >= title.threshold,
        TitleKind.tier => tierIdx >= title.threshold,
        TitleKind.friends => friends >= title.threshold,
        TitleKind.cleanSet => cleanSets >= title.threshold,
        TitleKind.earlyBird => earlySessions >= title.threshold,
        TitleKind.nightOwl => lateSessions >= title.threshold,
        TitleKind.perfectWeek => perfectWeeksCount >= title.threshold,
        // Beating someone well above you, or straight after three losses, or
        // the same lifter five times over — each reads a single duel's own
        // history rather than a tally kept here, so only the thing that
        // watched it happen can report it, through award().
        TitleKind.giantSlayer || TitleKind.comeback => false,
      };

      if (reached) {
        earned.add(title.id);
        unlocked.add(title);
      }
    }

    // Wearing the first thing you earn beats an empty space beside your name.
    if (wearing == null && earned.isNotEmpty) wearing = earned.first;

    return unlocked;
  }

  /// Unlocks a title that only a match or a set can judge.
  Future<void> award(String id) async {
    if (!earned.add(id)) return;
    wearing ??= id;
    await _save();
    notifyListeners();
  }

  Future<void> wear(String? id) async {
    wearing = id;
    await _save();
    notifyListeners();
  }

  // ── on the account ──────────────────────────────────────────────────────

  /// Everything above, as the account holds it (supabase/adventure.sql,
  /// rewards). On the phone alone, a new phone — or this one signed out and
  /// back in to another account — started them all again (the user,
  /// 2026-10-29).
  Map<String, Object?> toServer() => {
    'streak': streak,
    'bestStreak': bestStreak,
    'restUsed': restUsedThisWeek,
    'cleanSets': cleanSets,
    'earlySessions': earlySessions,
    'lateSessions': lateSessions,
    'perfectDayRun': perfectDayRun,
    'perfectWeeks': perfectWeeksCount,
    'earned': earned.toList()..sort(),
    if (wearing != null) 'wearing': wearing,
    if (lastSession case final last?) 'lastSession': last.millisecondsSinceEpoch,
    if (streakSaved case final saved?) 'streakSaved': saved.millisecondsSinceEpoch,
  };

  /// Takes in [held], the account's copy, the way the server merges: every
  /// title either side has, the larger of each tally, and the streak — with
  /// its rest days, its perfect run and the title worn — of whichever side
  /// trained last. True when anything here changed.
  bool _absorb(Map<String, dynamic> held) {
    int number(String key) => (held[key] as num?)?.toInt() ?? 0;
    var changed = false;
    int larger(int mine, int theirs) {
      if (theirs <= mine) return mine;
      changed = true;
      return theirs;
    }

    bestStreak = larger(bestStreak, number('bestStreak'));
    cleanSets = larger(cleanSets, number('cleanSets'));
    earlySessions = larger(earlySessions, number('earlySessions'));
    lateSessions = larger(lateSessions, number('lateSessions'));
    perfectWeeksCount = larger(perfectWeeksCount, number('perfectWeeks'));
    final theirSaved = (held['streakSaved'] as num?)?.toInt();
    if (theirSaved != null &&
        theirSaved > (streakSaved?.millisecondsSinceEpoch ?? 0)) {
      streakSaved = DateTime.fromMillisecondsSinceEpoch(theirSaved);
      changed = true;
    }
    final titles = (held['earned'] as List?)?.whereType<String>();
    for (final id in titles ?? const <String>[]) {
      if (earned.add(id)) changed = true;
    }

    final theirLast = (held['lastSession'] as num?)?.toInt();
    final myLast = lastSession?.millisecondsSinceEpoch;
    if (theirLast != null && (myLast == null || theirLast > myLast)) {
      streak = number('streak');
      restUsedThisWeek = number('restUsed');
      perfectDayRun = number('perfectDayRun');
      lastSession = DateTime.fromMillisecondsSinceEpoch(theirLast);
      if (held['wearing'] case final String id) wearing = id;
      changed = true;
    } else if (wearing == null && held['wearing'] is String) {
      wearing = held['wearing'] as String;
      changed = true;
    }
    return changed;
  }

  bool _pushing = false;
  bool _pushAgain = false;

  /// Sends this copy after a change. A session saves a few times over: one
  /// write at a time, and one more after it for whatever changed meanwhile.
  void _pushSoon() {
    if (!backend.available || backend.me == null) return;
    if (_pushing) {
      _pushAgain = true;
      return;
    }
    unawaited(push());
  }

  /// This copy to the account now, and back whatever another phone added.
  Future<void> push() async {
    if (!backend.available || backend.me == null) return;
    _pushing = true;
    try {
      final merged = await backend.saveRewards(toServer());
      if (_absorb(merged)) {
        await _store();
        notifyListeners();
      }
    } on Object catch (error) {
      debugPrint('Could not keep the titles on the account: $error');
    } finally {
      _pushing = false;
    }
    if (_pushAgain) {
      _pushAgain = false;
      await push();
    }
  }

  /// On entering the app: the account's copy and this phone's, made one on
  /// both.
  Future<void> sync() async {
    if (!backend.available || backend.me == null) return;
    try {
      if (_absorb(await backend.myRewards())) {
        await _store();
        notifyListeners();
      }
    } on Object catch (error) {
      debugPrint('Could not read the titles from the account: $error');
      return;
    }
    await push();
  }

  /// A log-in to an account that already existed: its titles and streak,
  /// not the ones this phone was keeping for whoever was here before.
  Future<void> adopt() async {
    await forget();
    await sync();
  }

  /// Nothing on this phone: signed out, or about to take another account's.
  /// The account keeps its own (see [push], done before signing out).
  Future<void> forget() async {
    streak = 0;
    bestStreak = 0;
    restUsedThisWeek = 0;
    cleanSets = 0;
    earlySessions = 0;
    lateSessions = 0;
    perfectDayRun = 0;
    perfectWeeksCount = 0;
    lastSession = null;
    earned.clear();
    wearing = null;
    _pushedWearing = null;
    _pushedOnce = false;
    final store = await SharedPreferences.getInstance();
    await store.remove('lastSession');
    await _store();
    notifyListeners();
  }

  Future<void> _save() async {
    _pushWorn();
    _pushSoon();
    await _store();
  }

  /// This phone's copy, written down here only.
  Future<void> _store() async {
    final store = await SharedPreferences.getInstance();
    await store.setInt('streak', streak);
    await store.setInt('bestStreak', bestStreak);
    await store.setInt('restUsed', restUsedThisWeek);
    await store.setInt('cleanSets', cleanSets);
    await store.setInt('earlySessions', earlySessions);
    await store.setInt('lateSessions', lateSessions);
    await store.setInt('perfectDayRun', perfectDayRun);
    await store.setInt('perfectWeeksCount', perfectWeeksCount);
    if (streakSaved case final saved?) {
      await store.setInt('streakSaved', saved.millisecondsSinceEpoch);
    }
    await store.setStringList('earnedTitles', earned.toList());

    if (wearing == null) {
      await store.remove('wearingTitle');
    } else {
      await store.setString('wearingTitle', wearing!);
    }

    final last = lastSession;
    if (last != null) {
      await store.setInt('lastSession', last.millisecondsSinceEpoch);
    }
  }
}

final rewards = Rewards();

extension EarnedTitleText on EarnedTitle {
  /// What it says beside your name, in the reader's language. The English in
  /// [title] stays put: it is the fallback, and it documents the list.
  String name(L l) => switch (id) {
    'first_blood' => l.ttl_first_blood,
    'found_footing' => l.ttl_found_footing,
    'regular' => l.ttl_regular,
    'fifty' => l.ttl_fifty,
    'century' => l.ttl_century,
    'veteran' => l.ttl_veteran,
    'thousand_matches' => l.ttl_thousand_matches,
    'first_win' => l.ttl_first_win,
    'on_a_roll' => l.ttl_on_a_roll,
    'five_straight' => l.ttl_five_straight,
    'unstoppable' => l.ttl_unstoppable,
    'untouchable' => l.ttl_untouchable,
    'giant_slayer' => l.ttl_giant_slayer,
    'comeback' => l.ttl_comeback,
    'nemesis' => l.ttl_nemesis,
    'hundred_reps' => l.ttl_hundred_reps,
    'five_hundred' => l.ttl_five_hundred,
    'the_machine' => l.ttl_the_machine,
    'five_thousand' => l.ttl_five_thousand,
    'ten_thousand' => l.ttl_ten_thousand,
    'fifty_thousand' => l.ttl_fifty_thousand,
    'first_tonne' => l.ttl_first_tonne,
    'ten_tonnes' => l.ttl_ten_tonnes,
    'six_figures' => l.ttl_six_figures,
    'half_million' => l.ttl_half_million,
    'million_kg' => l.ttl_million_kg,
    'two_days' => l.ttl_two_days,
    'no_days_off' => l.ttl_no_days_off,
    'fortnight' => l.ttl_fortnight,
    'unbroken' => l.ttl_unbroken,
    'sixty_days' => l.ttl_sixty_days,
    'hundred_days' => l.ttl_hundred_days,
    'year_round' => l.ttl_year_round,
    'perfect_week' => l.ttl_perfect_week,
    'perfect_month' => l.ttl_perfect_month,
    'bronze_tier' => l.ttl_bronze_tier,
    'silver_tier' => l.ttl_silver_tier,
    'golden_era' => l.ttl_golden_era,
    'platinum_tier' => l.ttl_platinum_tier,
    'diamond_tier' => l.ttl_diamond_tier,
    'master_tier' => l.ttl_master_tier,
    'clean_hands' => l.ttl_clean_hands,
    'spotless' => l.ttl_spotless,
    'textbook' => l.ttl_textbook,
    'all_rounder' => l.ttl_all_rounder,
    'explorer' => l.ttl_explorer,
    'encyclopedia' => l.ttl_encyclopedia,
    'early_bird' => l.ttl_early_bird,
    'sunrise_club' => l.ttl_sunrise_club,
    'night_owl' => l.ttl_night_owl,
    'graveyard' => l.ttl_graveyard,
    'not_alone' => l.ttl_not_alone,
    'well_connected' => l.ttl_well_connected,
    'the_gym_knows' => l.ttl_the_gym_knows,
    _ => title,
  };

  /// What you have to do to earn it.
  String hintText(L l) => switch (id) {
    'first_blood' => l.tdesc_first_blood,
    'found_footing' => l.tdesc_found_footing,
    'regular' => l.tdesc_regular,
    'fifty' => l.tdesc_fifty,
    'century' => l.tdesc_century,
    'veteran' => l.tdesc_veteran,
    'thousand_matches' => l.tdesc_thousand_matches,
    'first_win' => l.tdesc_first_win,
    'on_a_roll' => l.tdesc_on_a_roll,
    'five_straight' => l.tdesc_five_straight,
    'unstoppable' => l.tdesc_unstoppable,
    'untouchable' => l.tdesc_untouchable,
    'giant_slayer' => l.tdesc_giant_slayer,
    'comeback' => l.tdesc_comeback,
    'nemesis' => l.tdesc_nemesis,
    'hundred_reps' => l.tdesc_hundred_reps,
    'five_hundred' => l.tdesc_five_hundred,
    'the_machine' => l.tdesc_the_machine,
    'five_thousand' => l.tdesc_five_thousand,
    'ten_thousand' => l.tdesc_ten_thousand,
    'fifty_thousand' => l.tdesc_fifty_thousand,
    'first_tonne' => l.tdesc_first_tonne,
    'ten_tonnes' => l.tdesc_ten_tonnes,
    'six_figures' => l.tdesc_six_figures,
    'half_million' => l.tdesc_half_million,
    'million_kg' => l.tdesc_million_kg,
    'two_days' => l.tdesc_two_days,
    'no_days_off' => l.tdesc_no_days_off,
    'fortnight' => l.tdesc_fortnight,
    'unbroken' => l.tdesc_unbroken,
    'sixty_days' => l.tdesc_sixty_days,
    'hundred_days' => l.tdesc_hundred_days,
    'year_round' => l.tdesc_year_round,
    'perfect_week' => l.tdesc_perfect_week,
    'perfect_month' => l.tdesc_perfect_month,
    'bronze_tier' => l.tdesc_bronze_tier,
    'silver_tier' => l.tdesc_silver_tier,
    'golden_era' => l.tdesc_golden_era,
    'platinum_tier' => l.tdesc_platinum_tier,
    'diamond_tier' => l.tdesc_diamond_tier,
    'master_tier' => l.tdesc_master_tier,
    'clean_hands' => l.tdesc_clean_hands,
    'spotless' => l.tdesc_spotless,
    'textbook' => l.tdesc_textbook,
    'all_rounder' => l.tdesc_all_rounder,
    'explorer' => l.tdesc_explorer,
    'encyclopedia' => l.tdesc_encyclopedia,
    'early_bird' => l.tdesc_early_bird,
    'sunrise_club' => l.tdesc_sunrise_club,
    'night_owl' => l.tdesc_night_owl,
    'graveyard' => l.tdesc_graveyard,
    'not_alone' => l.tdesc_not_alone,
    'well_connected' => l.tdesc_well_connected,
    'the_gym_knows' => l.tdesc_the_gym_knows,
    _ => hint,
  };
}
