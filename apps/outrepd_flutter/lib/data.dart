/// Sample data the UI runs on. No network, no accounts — everything here is
/// held in memory so the whole app is browsable straight after install.
///
/// The one exception is the three body measurements a lifter types in: those
/// are theirs, not sample data, so they survive a restart.
library;

import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  Profile({
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.wins,
    required this.losses,
    required this.winStreak,
    required this.bestStreak,
    required this.totalVolumeKg,
    required this.heightCm,
    required this.weightKg,
    required this.age,
  });

  String username;
  int tierIdx;
  int divIdx;
  int lp;
  int wins;
  int losses;
  int winStreak;
  int bestStreak;
  int totalVolumeKg;
  int heightCm;
  int weightKg;
  int age;

  int get totalMatches => wins + losses;
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
  bestStreak: 7,
  totalVolumeKg: 184320,
  heightCm: 178,
  weightKg: 82,
  age: 25,
);

/// Restore the measurements the lifter set by hand. Everything else about the
/// profile is demo data and stays as written above.
Future<void> loadProfileStats() async {
  final s = await SharedPreferences.getInstance();
  demoProfile
    ..heightCm = s.getInt('profileHeightCm') ?? demoProfile.heightCm
    ..weightKg = s.getInt('profileWeightKg') ?? demoProfile.weightKg
    ..age = s.getInt('profileAge') ?? demoProfile.age;
}

Future<void> saveProfileStats() async {
  final s = await SharedPreferences.getInstance();
  await s.setInt('profileHeightCm', demoProfile.heightCm);
  await s.setInt('profileWeightKg', demoProfile.weightKg);
  await s.setInt('profileAge', demoProfile.age);
}

class MatchRecord {
  const MatchRecord({
    required this.muscleGroup,
    required this.won,
    required this.userVolume,
    required this.opponentVolume,
    required this.opponent,
    required this.lpChange,
    required this.daysAgo,
  });

  final String muscleGroup;
  final bool won;
  final int userVolume;
  final int opponentVolume;
  final String opponent;
  final int lpChange;
  final int daysAgo;
}

const demoMatches = <MatchRecord>[
  MatchRecord(
    muscleGroup: 'Chest',
    won: true,
    userVolume: 7420,
    opponentVolume: 6890,
    opponent: 'benchgod',
    lpChange: 18,
    daysAgo: 1,
  ),
  MatchRecord(
    muscleGroup: 'Back',
    won: false,
    userVolume: 8100,
    opponentVolume: 9240,
    opponent: 'iron_mike',
    lpChange: -14,
    daysAgo: 3,
  ),
  MatchRecord(
    muscleGroup: 'Legs',
    won: true,
    userVolume: 12650,
    opponentVolume: 11020,
    opponent: 'cardio_hater',
    lpChange: 21,
    daysAgo: 6,
  ),
  MatchRecord(
    muscleGroup: 'Shoulders',
    won: true,
    userVolume: 4380,
    opponentVolume: 3910,
    opponent: 'delt_destroyer',
    lpChange: 16,
    daysAgo: 8,
  ),
  MatchRecord(
    muscleGroup: 'Arms',
    won: false,
    userVolume: 3260,
    opponentVolume: 3540,
    opponent: 'curl_king',
    lpChange: -12,
    daysAgo: 11,
  ),
];

class LeaderboardEntry {
  const LeaderboardEntry(
    this.username,
    this.tierIdx,
    this.divIdx,
    this.lp,
    this.wins,
    this.losses,
  );
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;
  final int wins;
  final int losses;
}

const demoLeaderboard = <LeaderboardEntry>[
  LeaderboardEntry('iron_mike', 5, 1, 88, 41, 12),
  LeaderboardEntry('squat_queen', 4, 3, 72, 35, 15),
  LeaderboardEntry('demo_lifter', 3, 2, 64, 18, 9),
  LeaderboardEntry('benchgod', 3, 1, 51, 22, 20),
  LeaderboardEntry('cardio_hater', 2, 4, 39, 14, 17),
  LeaderboardEntry('delt_destroyer', 2, 2, 33, 11, 14),
  LeaderboardEntry('newbie_gains', 1, 2, 21, 6, 11),
];

class Achievement {
  const Achievement(this.name, this.description, this.earned);
  final String name;
  final String description;
  final bool earned;
}

const demoAchievements = <Achievement>[
  Achievement('First Blood', 'Complete your first match', true),
  Achievement('On a Roll', 'Win 3 matches in a row', true),
  Achievement('Six Figures', 'Lift 100,000 kg in total', true),
  Achievement('Rivalry', 'Beat the same opponent 3 times', true),
  Achievement('Unstoppable', 'Win 10 matches in a row', false),
  Achievement('Golden Era', 'Reach Gold tier', false),
  Achievement('Century', 'Complete 100 matches', false),
];

class Friend {
  const Friend(this.username, this.tierIdx, this.lp, this.online);
  final String username;
  final int tierIdx;
  final int lp;
  final bool online;
}

const demoFriends = <Friend>[
  Friend('iron_mike', 5, 88, true),
  Friend('squat_queen', 4, 72, false),
  Friend('benchgod', 3, 51, true),
  Friend('newbie_gains', 1, 21, false),
];

class AppNotification {
  const AppNotification(this.title, this.body, this.daysAgo, this.unread);
  final String title;
  final String body;
  final int daysAgo;
  final bool unread;
}

const demoNotifications = <AppNotification>[
  AppNotification('You won!', 'You beat benchgod on Chest day', 1, true),
  AppNotification('New friend request', 'squat_queen wants to connect', 2, true),
  AppNotification('Achievement unlocked', 'On a Roll — 3 wins in a row', 5, false),
  AppNotification('Rank up!', 'You reached Gold III', 9, false),
];

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

class Crew {
  const Crew(this.name, this.tag, this.members, this.weeklyVolume,
      {this.weeklyReps = 0});

  final String name;
  /// Short badge shown in lists.
  final String tag;
  final int members;
  /// Combined volume the crew logged this week, in kg.
  final int weeklyVolume;

  /// Reps this week. Crews are ranked on this divided by their size, so a big
  /// crew cannot coast to the top on numbers alone.
  final int weeklyReps;

  int get repsPerMember => members == 0 ? 0 : weeklyReps ~/ members;
}

const demoCrews = <Crew>[
  Crew('Iron Temple', 'IRN', 8, 412500, weeklyReps: 6240),
  Crew('Night Shift', 'NGT', 6, 366200, weeklyReps: 5100),
  Crew('Barbell Bros', 'BBB', 10, 341800, weeklyReps: 7300),
  Crew('Quiet Reps', 'QRP', 5, 208400, weeklyReps: 3850),
  Crew('Dawn Patrol', 'DWN', 12, 455000, weeklyReps: 8400),
  Crew('Last Set', 'LST', 7, 291000, weeklyReps: 4550),
];

/// A crew the player belongs to. Held in memory for now — there is no backend
/// yet, so a crew lasts for the session.
class MyCrew {
  MyCrew({
    required this.name,
    required this.country,
    required this.emblemIcon,
    required this.emblemColor,
    required this.inviteCode,
    required this.members,
    this.description = '',
    this.privacy = 0,
    this.minTierIdx = 0,
  });

  String name;
  String country;
  int emblemIcon;
  int emblemColor;
  final String inviteCode;
  final List<CrewMember> members;

  String description;

  /// Index into CrewPrivacy.values.
  int privacy;

  /// Lowest tier allowed to join; 0 means anyone.
  int minTierIdx;

  static const maxMembers = 20;

  /// What the crew is chasing together this week, in reps. A crew without a
  /// shared target is just a list of names — the goal is what makes anyone
  /// chase up the member who has not trained since Monday.
  int weeklyGoal = 8000;

  int get weeklyReps =>
      members.fold(0, (sum, member) => sum + member.weeklyReps);

  double get goalProgress =>
      weeklyGoal == 0 ? 0 : (weeklyReps / weeklyGoal).clamp(0.0, 1.0);

  /// Ranking runs on this, not the total. A crew of twenty would beat a crew
  /// of eight on volume alone however hard the eight worked.
  int get repsPerMember =>
      members.isEmpty ? 0 : weeklyReps ~/ members.length;

  String get inviteLink => 'https://outrepd.app/crew/$inviteCode';
}

class CrewMember {
  const CrewMember(this.username, this.tierIdx, this.divIdx, this.weeklyVolume,
      {this.isOwner = false, this.weeklyReps = 0});

  final String username;
  final int tierIdx;
  final int divIdx;
  final int weeklyVolume;
  final bool isOwner;

  /// Reps this week — what the crew goal and the ranking are both built on.
  final int weeklyReps;
}

/// The player's crew, or null when they have not joined one.
MyCrew? myCrew;
