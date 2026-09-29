/// Sample data the UI runs on. No network, no accounts — everything here is
/// held in memory so the whole app is browsable straight after install.
///
/// The one exception is the three body measurements a lifter types in: those
/// are theirs, not sample data, so they survive a restart.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart';
import 'l10n/app_localizations.dart';
import 'reps/exercise_type.dart';

class Profile {
  Profile({
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.wins,
    required this.losses,
    required this.winStreak,
    required this.dayStreak,
    required this.bestStreak,
    required this.totalVolumeKg,
    required this.totalReps,
    required this.bestSet,
    this.peakTierIdx = 0,
    this.placementWins = 0,
    required this.globalRank,
    required this.localRank,
    required this.country,
    this.placementsDone = kPlacementDuels,
    required this.heightCm,
    required this.weightKg,
    required this.age,
    this.friendCode = '000000',
  });

  String username;

  /// A short number that names this account without being the name shown on
  /// the ladder — see the comment on `friend_code` in schema.sql. Assigned by
  /// the server; the sample value here is never a real account's.
  String friendCode;
  int tierIdx;
  int divIdx;
  int lp;
  int wins;
  int losses;

  /// Duels won in a row.
  int winStreak;

  /// Days trained in a row.
  ///
  /// A different number from [winStreak] and it has to stay one: the home
  /// screen's pill and the profile's STREAK card are both about showing up,
  /// not about winning, and wiring one of them to the win streak made two
  /// screens disagree about the same word.
  int dayStreak;

  int bestStreak;
  int totalVolumeKg;

  /// Every push-up ever counted for this account.
  int totalReps;

  /// The most ever counted in one bout. The number people quote at each other,
  /// and the only stat here that a single good session can move.
  int bestSet;

  /// Where this account sits on the whole board, and on its country's.
  ///
  /// Both are shown because they answer different questions. Global says how
  /// far there is to go; local is the one somebody can realistically move, and
  /// for most people it is the only one that ever feels within reach.
  int globalRank;
  int localRank;

  /// The country whose board [localRank] is on, as its two-letter code.
  /// Screens turn it into a name in the reader's language with countryName().
  String country;

  /// The highest tier this account has ever held.
  ///
  /// The floor rule reads this: a tier once reached is kept, which is what the
  /// progression screen promises in words. Storing the peak rather than
  /// deriving it means a bad month cannot quietly erase it.
  int peakTierIdx;

  /// Placement duels won so far. Only meaningful while [isRanked] is false —
  /// it is what decides the starting tier.
  int placementWins;

  /// How many of the placement duels are behind you.
  ///
  /// A new account has no tier at all rather than a bad one: being handed the
  /// bottom rank before anybody has seen you lift is a judgement, and it is the
  /// judgement people quit over. Until these are done the app says "Unranked",
  /// which is a statement about the app's knowledge, not about the lifter.
  int placementsDone;
  int heightCm;
  int weightKg;
  int age;

  int get totalMatches => wins + losses;

  /// Whether this account has a tier yet. Everything that shows a rank has to
  /// ask first — an unranked account's [tierIdx] is a placeholder, not a rank.
  bool get isRanked => placementsDone >= kPlacementDuels;

  int get placementsLeft =>
      (kPlacementDuels - placementsDone).clamp(0, kPlacementDuels);
  double get winRate => totalMatches == 0 ? 0 : wins / totalMatches;
}

final demoProfile = Profile(
  username: 'demo_lifter',
  tierIdx: 3,
  divIdx: 2,
  lp: 64,
  wins: 18,
  losses: 9,
  winStreak: 4,
  dayStreak: 5,
  bestStreak: 7,
  totalVolumeKg: 184320,
  totalReps: 412,
  bestSet: 24,
  peakTierIdx: 3,
  globalRank: 1842,
  localRank: 64,
  country: 'US',
  placementsDone: kPlacementDuels,
  heightCm: 178,
  weightKg: 82,
  age: 25,
  friendCode: '482910',
);

/// Duels a new account plays before it is given a tier. Five is enough to see
/// past one bad session and few enough that nobody is grinding for a week to
/// find out where they stand.
const kPlacementDuels = 5;

/// Restore the measurements the lifter set by hand. Everything else about the
/// profile is demo data and stays as written above.
Future<void> loadProfileStats() async {
  final s = await SharedPreferences.getInstance();
  demoProfile
    ..heightCm = s.getInt('profileHeightCm') ?? demoProfile.heightCm
    ..weightKg = s.getInt('profileWeightKg') ?? demoProfile.weightKg
    ..age = s.getInt('profileAge') ?? demoProfile.age
    ..username = s.getString('username') ?? demoProfile.username;

  // A stored career counts as set up even with no flag beside it. The flag
  // is newer than the installs it has to protect, and reading its absence as
  // "new account" would send exactly the people with something to lose back
  // through the screen that clears it.
  onboarded = s.getBool('onboarded') ?? (s.getString('career.profile') != null);
}

/// What the onboarding questionnaire learned. Nothing reads it yet — the
/// suggestions it will feed need the match and counter work first — but a
/// person who answered twelve questions about themselves should not have to
/// answer them again because the app forgot on the way to the home screen.
Future<void> saveOnboardingAnswers(Map<String, String?> answers) async {
  final s = await SharedPreferences.getInstance();
  for (final entry in answers.entries) {
    final value = entry.value;
    if (value == null) continue;
    await s.setString('onboarding.${entry.key}', value);
  }
  await s.setBool('onboarding.done', true);
}

Future<void> saveProfileStats() async {
  final s = await SharedPreferences.getInstance();
  await s.setInt('profileHeightCm', demoProfile.heightCm);
  await s.setInt('profileWeightKg', demoProfile.weightKg);
  await s.setInt('profileAge', demoProfile.age);
}

/// Whether this install has been set up already.
///
/// Read at launch, and it decides the one thing nothing else may decide:
/// whether the app opens on onboarding. Onboarding ends by calling
/// `Career.startFresh()`, which zeroes the rank, the record, the rep total
/// and the history — correct for a new account, and the loss of everything
/// for anybody else. Before this flag existed the app opened on onboarding
/// *every* launch, so finishing it a second time wiped a real career.
bool onboarded = false;

/// Marks the account as set up. Called once, at the end of onboarding.
Future<void> markOnboarded() async {
  onboarded = true;
  final s = await SharedPreferences.getInstance();
  await s.setBool('onboarded', true);
}

/// Undoes [markOnboarded], for signing out: the phone opens on the welcome
/// screen again, where "I already have an account" signs back in.
Future<void> markNotOnboarded() async {
  onboarded = false;
  final s = await SharedPreferences.getInstance();
  await s.setBool('onboarded', false);
}

class MatchRecord {
  const MatchRecord({
    this.exerciseType = ExerciseType.pushUp,
    required this.won,
    required this.userReps,
    required this.opponentReps,
    required this.opponent,
    required this.lpChange,
    required this.at,
  });

  /// What was counted. One value today; stored anyway, because a record that
  /// does not say what it measured cannot be read once a second movement
  /// exists.
  final ExerciseType exerciseType;

  final bool won;

  /// What the duel came down to.
  final int userReps;
  final int opponentReps;

  final String opponent;
  final int lpChange;

  /// When it finished.
  ///
  /// An instant, not an age. The old record stored "1 day ago" as the number
  /// one, which was true on the day it was written and wrong every day after.
  final DateTime at;

  int get daysAgo {
    final now = DateTime.now();
    final then = DateTime(at.year, at.month, at.day);
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(then).inDays;
  }

  /// Hours since it finished, while that is still the more useful unit.
  int? get hoursAgo {
    final hours = DateTime.now().difference(at).inHours;
    return hours < 24 ? hours : null;
  }

  Map<String, Object?> toJson() => {
    'exercise': exerciseType.wireName,
    'won': won,
    'you': userReps,
    'them': opponentReps,
    'opponent': opponent,
    'lp': lpChange,
    'at': at.toIso8601String(),
  };

  static MatchRecord? fromJson(Map<String, Object?> json) {
    final at = DateTime.tryParse(json['at'] as String? ?? '');
    if (at == null) return null;
    return MatchRecord(
      exerciseType: ExerciseType.fromWireName(
        json['exercise'] as String? ?? '',
      ),
      won: json['won'] as bool? ?? false,
      userReps: (json['you'] as num?)?.toInt() ?? 0,
      opponentReps: (json['them'] as num?)?.toInt() ?? 0,
      opponent: json['opponent'] as String? ?? '',
      lpChange: (json['lp'] as num?)?.toInt() ?? 0,
      at: at,
    );
  }
}

/// Every duel this account has finished, newest first.
///
/// Mutable and owned by [Career], which is the only thing that appends to it.
final matchHistory = <MatchRecord>[];

class LeaderboardEntry {
  const LeaderboardEntry(
    this.username,
    this.tierIdx,
    this.divIdx,
    this.lp,
    this.wins,
    this.losses, {
    this.id = '',
    this.avatarUrl,
  });

  /// Empty for the sample board, which has nobody real behind it to open a
  /// profile on.
  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;
  final int wins;
  final int losses;
  final String? avatarUrl;
}

// Other lifters only. "You" already has a pinned row of your own at the
// bottom of the board (see ranks.dart's _myPosition) — a demo account also
// appearing as an ordinary row here, at a rank that disagrees with that
// pinned number, said two different things about the same lifter on one
// screen.
const demoLeaderboard = <LeaderboardEntry>[
  LeaderboardEntry('iron_mike', 5, 1, 88, 41, 12),
  LeaderboardEntry('squat_queen', 4, 3, 72, 35, 15),
  LeaderboardEntry('benchgod', 3, 2, 51, 22, 20),
  LeaderboardEntry('cardio_hater', 2, 4, 39, 14, 17),
  LeaderboardEntry('delt_destroyer', 2, 2, 33, 11, 14),
  LeaderboardEntry('newbie_gains', 1, 2, 21, 6, 11),
];

class Friend {
  const Friend(
    this.username,
    this.tierIdx,
    this.divIdx,
    this.lp,
    this.online, {
    this.id = '',
    this.winsVsYou = 0,
    this.lossesVsYou = 0,
    this.avatarUrl,
  });

  /// Empty for the sample data, which has nobody real behind it to open a
  /// profile on.
  final String id;
  final String username;
  final int tierIdx;

  /// Their division within the tier, so a row can say "Gold III" rather than
  /// just "Gold" — which is five ranks wide and tells you nothing.
  final int divIdx;
  final int lp;
  final bool online;

  /// What they have done against *you*: [winsVsYou] times they beat you,
  /// [lossesVsYou] times you beat them.
  ///
  /// This pair is the reason anybody taps a row. A rank says how good someone
  /// is in general; a record says whether there is something to settle.
  final int winsVsYou;
  final int lossesVsYou;

  final String? avatarUrl;

  bool get hasPlayedYou => winsVsYou + lossesVsYou > 0;
}

const demoFriends = <Friend>[
  Friend('iron_mike', 5, 2, 88, true, winsVsYou: 3, lossesVsYou: 1),
  Friend('benchgod', 3, 2, 51, true, winsVsYou: 1, lossesVsYou: 2),
  Friend('squat_queen', 4, 0, 72, false, winsVsYou: 2, lossesVsYou: 2),
  Friend('newbie_gains', 1, 3, 21, false),
  Friend('delt_destroyer', 3, 4, 64, false, winsVsYou: 0, lossesVsYou: 4),
];

/// The card a sample row opens, so the profile peek can be tried without a
/// server. Built from whatever the sample board and friends list already say
/// about [username]; the numbers neither of them carries are made up from
/// those, never random, so the same row always opens the same card.
LifterProfile demoLifterProfile(String username) {
  final board = demoLeaderboard.where((e) => e.username == username).firstOrNull;
  final friend = demoFriends.where((f) => f.username == username).firstOrNull;
  final wins = board?.wins ?? 10;
  final losses = board?.losses ?? 10;
  final played = friend?.hasPlayedYou ?? false;
  final place = board == null ? null : demoLeaderboard.indexOf(board) + 1;
  return LifterProfile(
    id: '',
    username: username,
    tierIdx: board?.tierIdx ?? friend?.tierIdx ?? 1,
    divIdx: board?.divIdx ?? friend?.divIdx ?? 0,
    lp: board?.lp ?? friend?.lp ?? 0,
    placementsDone: 5,
    totalReps: (wins + losses) * 45,
    bestSet: 12 + wins ~/ 2,
    wins: wins,
    losses: losses,
    winStreak: wins ~/ 4,
    globalPlace: place,
    country: 'US',
    countryPlace: place,
    isFriend: friend != null,
    winsVsYou: friend?.winsVsYou ?? 0,
    lossesVsYou: friend?.lossesVsYou ?? 0,
    yourBestVsThem: played ? 18 : null,
    lastDuelAt: played ? DateTime.now().subtract(const Duration(days: 2)) : null,
    lastYourReps: played ? 15 : null,
    lastTheirReps: played ? 17 : null,
    title: _demoTitles[username],
  );
}

/// What the sample lifters wear, so the title beside a name can be seen
/// without a server. Not everyone wears one, and neither do real accounts.
const _demoTitles = <String, String>{
  'iron_mike': 'giant_slayer',
  'squat_queen': 'unstoppable',
  'benchgod': 'the_machine',
  'cardio_hater': 'night_owl',
};

/// How many friends this account actually has, for the friend-count awards
/// in [Rewards]. [demoFriends] is sample data for browsing the Friends tab
/// offline — a signed-in account's real count has to come from the server,
/// or the "Not Alone" title unlocks for everybody's first session regardless
/// of whether they have ever added anybody.
Future<int> currentFriendCount() async {
  if (!backend.available) return demoFriends.length;
  try {
    return (await backend.friends()).length;
  } on Object catch (error) {
    debugPrint('Could not read friend count for awards: $error');
    return 0;
  }
}

class AppNotification {
  const AppNotification(this.title, this.body, this.daysAgo, this.unread);
  final String title;
  final String body;
  final int daysAgo;
  final bool unread;
}

const demoNotifications = <AppNotification>[
  AppNotification('won', 'benchgod', 1, true),
  AppNotification('friend', 'squat_queen', 2, true),
  AppNotification('achievement', '', 5, false),
  AppNotification('rank', 'Gold III', 9, false),
];

extension AppNotificationText on AppNotification {
  String heading(L l) => switch (title) {
    'won' => l.nWonTitle,
    'friend' => l.nFriendTitle,
    'achievement' => l.nAchTitle,
    _ => l.nRankTitle,
  };

  String detail(L l) => switch (title) {
    'won' => l.nWonBody(body, l.mgChest),
    'friend' => l.nFriendBody(body),
    'achievement' => l.nAchBody(l.ttl_on_a_roll, l.tdesc_on_a_roll),
    _ => l.nRankBody(body),
  };
}

/// The words a person reads. The list below stays English because those
/// strings are ids: they match recorded matches and exercise definitions.
String muscleGroupLabel(L l, String group) => switch (group) {
  'Chest' => l.mgChest,
  'Back' => l.mgBack,
  'Legs' => l.mgLegs,
  'Shoulders' => l.mgShoulders,
  'Arms' => l.mgArms,
  'Core' => l.mgCore,
  _ => group,
};

const muscleGroups = <String>[
  'Chest',
  'Back',
  'Legs',
  'Shoulders',
  'Arms',
  'Core',
];

/// Stand-ins for real players until matchmaking is wired to a server.
class Opponent {
  const Opponent(this.username, this.tierIdx, this.divIdx);

  final String username;
  final int tierIdx;
  final int divIdx;
}

const demoOpponents = <Opponent>[
  Opponent('iron_mike', 5, 1),
  Opponent('squat_queen', 4, 3),
  Opponent('benchgod', 3, 1),
  Opponent('cardio_hater', 2, 4),
  Opponent('deadlift_dan', 3, 3),
  Opponent('pr_hunter', 4, 1),
];

/// The version shown at the bottom of settings.
///
/// A constant rather than a package lookup, because the only two ways to get
/// it at runtime are a plugin dependency for one string, or reading an asset.
/// It is kept honest by `test/version_test.dart`, which fails if this and
/// `pubspec.yaml` ever disagree — a version number that quietly lags the
/// build is worse than none, since it is the first thing anybody quotes in a
/// bug report.
const kAppVersion = '1.0.0+1';

/// Where "Contact support" writes to, and what the privacy policy and terms
/// give as the contact address.
const kSupportEmail = 'support@outrepd.com';

/// The Play Store listing's id — `applicationId` in android/app/build.gradle.kts.
const kAndroidPackage = 'com.outrepd.outrepd';

/// The App Store's number for the app ("Apple ID" in App Store Connect).
/// Empty until the first submission creates one; "Rate the app" stays off
/// the iPhone until it is filled in.
const kAppStoreId = '';
