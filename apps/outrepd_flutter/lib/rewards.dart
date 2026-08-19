/// Titles worth wearing, and a streak that understands rest days.
///
/// Frames come from rank, which means only the strong ever get one. These are
/// the other half: things a beginner can earn in their first week, and things
/// that say something about *how* someone trains rather than how much they
/// lift. Every one of them is visible to other people — a reward nobody else
/// can see does not motivate anyone.
library;

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What a title asks of you. Kept as plain numbers so the condition can be
/// checked against a profile without each title carrying its own code.
enum TitleKind {
  matches,
  wins,
  reps,
  streakDays,
  volumeKg,
  tier,
  crewWeeks,
  cleanSet,
  giantSlayer,
  comeback,
  earlyBird,
  nightOwl,
  exercises,
  holdSeconds,
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
const kTitles = <EarnedTitle>[
  // ---- getting started -------------------------------------------------
  T.of('first_blood', 'First Blood', 'Finish your first match', TitleKind.matches, 1, Icons.flag),
  T.of('found_footing', 'Found Your Footing', 'Finish five matches', TitleKind.matches, 5, Icons.directions_walk),
  T.of('regular', 'Regular', 'Twenty matches', TitleKind.matches, 20, Icons.event_repeat),
  T.of('fifty', 'Fifty Deep', 'Fifty matches', TitleKind.matches, 50, Icons.filter_5),
  T.of('century', 'Century', 'A hundred matches', TitleKind.matches, 100, Icons.emoji_events, gold),
  T.of('veteran', 'Veteran', 'Two hundred and fifty matches', TitleKind.matches, 250, Icons.shield_moon, purple),
  T.of('thousand_matches', 'Old Guard', 'A thousand matches', TitleKind.matches, 1000, Icons.workspace_premium, purple),

  // ---- winning ---------------------------------------------------------
  T.of('first_win', 'Winner', 'Win a match', TitleKind.wins, 1, Icons.check_circle),
  T.of('on_a_roll', 'On a Roll', 'Win three in a row', TitleKind.wins, 3, Icons.trending_up),
  T.of('five_straight', 'Five Straight', 'Win five in a row', TitleKind.wins, 5, Icons.stacked_line_chart),
  T.of('unstoppable', 'Unstoppable', 'Win ten in a row', TitleKind.wins, 10, Icons.rocket_launch, cyan),
  T.of('untouchable', 'Untouchable', 'Win twenty in a row', TitleKind.wins, 20, Icons.auto_awesome, gold),
  T.of('giant_slayer', 'Giant Slayer', 'Beat someone two tiers above you', TitleKind.giantSlayer, 1, Icons.bolt, purple),
  T.of('comeback', 'Comeback', 'Win straight after three losses', TitleKind.comeback, 1, Icons.replay),
  T.of('nemesis', 'Nemesis', 'Beat the same lifter five times', TitleKind.comeback, 5, Icons.gps_fixed),

  // ---- reps ------------------------------------------------------------
  T.of('hundred_reps', 'Off the Mark', 'A hundred counted reps', TitleKind.reps, 100, Icons.play_arrow),
  T.of('five_hundred', 'Warmed Up', 'Five hundred counted reps', TitleKind.reps, 500, Icons.whatshot),
  T.of('the_machine', 'The Machine', 'A thousand counted reps', TitleKind.reps, 1000, Icons.settings),
  T.of('five_thousand', 'Relentless', 'Five thousand counted reps', TitleKind.reps, 5000, Icons.repeat),
  T.of('ten_thousand', 'Ten Thousand', 'Ten thousand counted reps', TitleKind.reps, 10000, Icons.all_inclusive, cyan),
  T.of('fifty_thousand', 'Beyond Counting', 'Fifty thousand counted reps', TitleKind.reps, 50000, Icons.blur_on, purple),

  // ---- weight moved ----------------------------------------------------
  T.of('first_tonne', 'A Tonne', 'Move a thousand kilos in total', TitleKind.volumeKg, 1000, Icons.scale),
  T.of('ten_tonnes', 'Ten Tonnes', 'Move ten thousand kilos', TitleKind.volumeKg, 10000, Icons.fitness_center),
  T.of('six_figures', 'Six Figures', 'Move a hundred thousand kilos', TitleKind.volumeKg, 100000, Icons.savings),
  T.of('half_million', 'Half a Million', 'Move five hundred thousand kilos', TitleKind.volumeKg, 500000, Icons.terrain, cyan),
  T.of('million_kg', 'Million Kilo Club', 'Move a million kilos', TitleKind.volumeKg, 1000000, Icons.public, gold),

  // ---- showing up ------------------------------------------------------
  T.of('two_days', 'Back Again', 'Train two days running', TitleKind.streakDays, 2, Icons.replay_circle_filled),
  T.of('no_days_off', 'No Days Off', 'Train seven days running', TitleKind.streakDays, 7, Icons.local_fire_department),
  T.of('fortnight', 'Fortnight', 'A fourteen day streak', TitleKind.streakDays, 14, Icons.calendar_view_week),
  T.of('unbroken', 'Unbroken', 'A thirty day streak', TitleKind.streakDays, 30, Icons.whatshot, orange),
  T.of('sixty_days', 'Habit', 'A sixty day streak', TitleKind.streakDays, 60, Icons.psychology, orange),
  T.of('hundred_days', 'Hundred Days', 'A hundred day streak', TitleKind.streakDays, 100, Icons.emoji_flags, gold),
  T.of('year_round', 'Year Round', 'A three hundred and sixty five day streak', TitleKind.streakDays, 365, Icons.brightness_7, gold),
  T.of('perfect_week', 'Perfect Week', 'Train every day of one week', TitleKind.perfectWeek, 1, Icons.done_all),
  T.of('perfect_month', 'Perfect Month', 'Four perfect weeks', TitleKind.perfectWeek, 4, Icons.verified_user, cyan),

  // ---- rank ------------------------------------------------------------
  T.of('bronze_tier', 'Out of the Stone', 'Reach Bronze', TitleKind.tier, 1, Icons.trending_up),
  T.of('silver_tier', 'Silverside', 'Reach Silver', TitleKind.tier, 2, Icons.star_border),
  T.of('golden_era', 'Golden Era', 'Reach Gold', TitleKind.tier, 3, Icons.star, gold),
  T.of('platinum_tier', 'Platinum', 'Reach Platinum', TitleKind.tier, 4, Icons.ac_unit),
  T.of('diamond_tier', 'Diamond Hands', 'Reach Diamond', TitleKind.tier, 5, Icons.diamond, cyan),
  T.of('master_tier', 'Master', 'Reach Master', TitleKind.tier, 6, Icons.local_police, red),
  T.of('mythic_tier', 'Mythic', 'Reach Mythic', TitleKind.tier, 7, Icons.volcano, orange),
  T.of('legend_tier', 'Legend', 'Reach Legend', TitleKind.tier, 8, Icons.military_tech, purple),

  // ---- form ------------------------------------------------------------
  T.of('clean_hands', 'Clean Hands', 'A full set with every rep counted', TitleKind.cleanSet, 1, Icons.verified, green),
  T.of('spotless', 'Spotless', 'Ten clean sets', TitleKind.cleanSet, 10, Icons.cleaning_services, green),
  T.of('textbook', 'Textbook', 'Fifty clean sets', TitleKind.cleanSet, 50, Icons.menu_book, green),
  T.of('iron_hold', 'Iron Hold', 'Hold a plank for two minutes', TitleKind.holdSeconds, 120, Icons.horizontal_rule),
  T.of('statue', 'Statue', 'Hold a plank for five minutes', TitleKind.holdSeconds, 300, Icons.self_improvement, cyan),

  // ---- range ------------------------------------------------------------
  T.of('all_rounder', 'All Rounder', 'Count five different exercises', TitleKind.exercises, 5, Icons.grid_view),
  T.of('explorer', 'Explorer', 'Count fifteen different exercises', TitleKind.exercises, 15, Icons.explore),
  T.of('encyclopedia', 'Encyclopedia', 'Count forty different exercises', TitleKind.exercises, 40, Icons.library_books, purple),

  // ---- hours -------------------------------------------------------------
  T.of('early_bird', 'Early Shift', 'Ten sessions before seven in the morning', TitleKind.earlyBird, 10, Icons.wb_twilight),
  T.of('sunrise_club', 'Sunrise Club', 'Fifty sessions before seven', TitleKind.earlyBird, 50, Icons.wb_sunny, orange),
  T.of('night_owl', 'Night Shift', 'Ten sessions after ten at night', TitleKind.nightOwl, 10, Icons.nights_stay),
  T.of('graveyard', 'Graveyard Shift', 'Fifty sessions after ten', TitleKind.nightOwl, 50, Icons.dark_mode, purple),

  // ---- crew --------------------------------------------------------------
  T.of('joined_up', 'Joined Up', 'Be in a crew', TitleKind.crewWeeks, 1, Icons.groups_2),
  T.of('backbone', 'Backbone', 'Top your crew four weeks running', TitleKind.crewWeeks, 4, Icons.shield),
  T.of('cornerstone', 'Cornerstone', 'Top your crew twelve weeks running', TitleKind.crewWeeks, 12, Icons.castle, gold),

  // ---- people ------------------------------------------------------------
  T.of('not_alone', 'Not Alone', 'Add your first friend', TitleKind.friends, 1, Icons.person_add),
  T.of('well_connected', 'Well Connected', 'Ten friends', TitleKind.friends, 10, Icons.diversity_3),
  T.of('the_gym_knows', 'The Gym Knows You', 'Fifty friends', TitleKind.friends, 50, Icons.connect_without_contact, cyan),
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

  /// Titles unlocked, and the one being worn.
  final Set<String> earned = {};
  String? wearing;

  EarnedTitle? get worn {
    if (wearing == null) return null;
    for (final title in kTitles) {
      if (title.id == wearing) return title;
    }
    return null;
  }

  bool has(String id) => earned.contains(id);

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    streak = store.getInt('streak') ?? 0;
    bestStreak = store.getInt('bestStreak') ?? 0;
    restUsedThisWeek = store.getInt('restUsed') ?? 0;
    wearing = store.getString('wearingTitle');

    final stamp = store.getInt('lastSession');
    lastSession = stamp == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(stamp);

    earned
      ..clear()
      ..addAll(store.getStringList('earnedTitles') ?? const []);
  }

  /// Titles are a statement about what you have already done, so they are
  /// checked against the record on every launch rather than only at the moment
  /// a session ends. Otherwise someone who qualified before this existed would
  /// never be given what they had plainly earned.
  Future<List<EarnedTitle>> syncWithProfile({
    required int matches,
    required int wins,
    required int reps,
    int volumeKg = 0,
    int tierIdx = 0,
    int friends = 0,
  }) async {
    final unlocked = _check(
      matches: matches,
      wins: wins,
      reps: reps,
      volumeKg: volumeKg,
      tierIdx: tierIdx,
      friends: friends,
    );
    if (unlocked.isNotEmpty) await _save();
    return unlocked;
  }

  /// Called when a session finishes. Returns any titles unlocked by it, so the
  /// UI can celebrate rather than leave someone to find it later.
  Future<List<EarnedTitle>> recordSession({
    required int matches,
    required int wins,
    required int reps,
    int volumeKg = 0,
    int tierIdx = 0,
    int friends = 0,
  }) async {
    final today = DateTime.now();
    final last = lastSession;

    if (last == null) {
      streak = 1;
    } else {
      final gap = DateTime(today.year, today.month, today.day)
          .difference(DateTime(last.year, last.month, last.day))
          .inDays;

      if (gap == 0) {
        // Already counted today. Training twice does not count twice.
      } else if (gap == 1) {
        streak++;
      } else if (gap - 1 <= kRestDaysPerWeek - restUsedThisWeek) {
        // Rest days cover the gap, so the streak carries on.
        restUsedThisWeek += gap - 1;
        streak++;
      } else {
        streak = 1;
        restUsedThisWeek = 0;
      }
    }

    lastSession = today;
    if (streak > bestStreak) bestStreak = streak;

    final unlocked = _check(
      matches: matches,
      wins: wins,
      reps: reps,
      volumeKg: volumeKg,
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
    int volumeKg = 0,
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
        TitleKind.volumeKg => volumeKg >= title.threshold,
        TitleKind.tier => tierIdx >= title.threshold,
        TitleKind.friends => friends >= title.threshold,
        // The rest describe a single moment — a clean set, an early start,
        // beating someone above you. Only the thing that watched it happen can
        // report it, so those come in through award().
        _ => false,
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

  Future<void> _save() async {
    final store = await SharedPreferences.getInstance();
    await store.setInt('streak', streak);
    await store.setInt('bestStreak', bestStreak);
    await store.setInt('restUsed', restUsedThisWeek);
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
        'mythic_tier' => l.ttl_mythic_tier,
        'legend_tier' => l.ttl_legend_tier,
        'clean_hands' => l.ttl_clean_hands,
        'spotless' => l.ttl_spotless,
        'textbook' => l.ttl_textbook,
        'iron_hold' => l.ttl_iron_hold,
        'statue' => l.ttl_statue,
        'all_rounder' => l.ttl_all_rounder,
        'explorer' => l.ttl_explorer,
        'encyclopedia' => l.ttl_encyclopedia,
        'early_bird' => l.ttl_early_bird,
        'sunrise_club' => l.ttl_sunrise_club,
        'night_owl' => l.ttl_night_owl,
        'graveyard' => l.ttl_graveyard,
        'joined_up' => l.ttl_joined_up,
        'backbone' => l.ttl_backbone,
        'cornerstone' => l.ttl_cornerstone,
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
        'mythic_tier' => l.tdesc_mythic_tier,
        'legend_tier' => l.tdesc_legend_tier,
        'clean_hands' => l.tdesc_clean_hands,
        'spotless' => l.tdesc_spotless,
        'textbook' => l.tdesc_textbook,
        'iron_hold' => l.tdesc_iron_hold,
        'statue' => l.tdesc_statue,
        'all_rounder' => l.tdesc_all_rounder,
        'explorer' => l.tdesc_explorer,
        'encyclopedia' => l.tdesc_encyclopedia,
        'early_bird' => l.tdesc_early_bird,
        'sunrise_club' => l.tdesc_sunrise_club,
        'night_owl' => l.tdesc_night_owl,
        'graveyard' => l.tdesc_graveyard,
        'joined_up' => l.tdesc_joined_up,
        'backbone' => l.tdesc_backbone,
        'cornerstone' => l.tdesc_cornerstone,
        'not_alone' => l.tdesc_not_alone,
        'well_connected' => l.tdesc_well_connected,
        'the_gym_knows' => l.tdesc_the_gym_knows,
        _ => hint,
      };
}
