/// Where the app talks to the server, and the seam that lets it not.
///
/// The ladder needs four calls: make me an account, store the set I just did,
/// find me somebody to race, settle it. The social side adds the reading that
/// makes a ladder feel like one — the board, and the people on it you know.
/// They live behind one interface so the rest of the app never learns which
/// backend is underneath — and so the app keeps running with none.
///
/// That last part is not a nicety. Until the server is proven the local
/// implementation is what people use, and a build that cannot open without a
/// network is a build nobody can test on a train.
library;

import 'dart:typed_data';

/// Who may be handed this account's stored sets to race.
enum Challengeable { everyone, friends, nobody }

/// The settings that are kept on the server rather than on the phone.
///
/// They live there because the server is what enforces them: hiding somebody
/// from a board, refusing to hand their set to a stranger, and declining to
/// write a notice they said they did not want are all decisions made where
/// the phone cannot reach. A copy on the phone would be a copy of a promise
/// somebody else has to keep.
class RemotePrefs {
  const RemotePrefs({
    this.challengeable = Challengeable.everyone,
    this.showOnBoard = true,
    this.showCountry = true,
    this.notifyRaced = true,
    this.notifyChallenged = true,
    this.notifyLiveInvite = true,
    this.notifyFriendRequest = true,
    this.notifyFriendOk = true,
  });

  final Challengeable challengeable;
  final bool showOnBoard;
  final bool showCountry;
  final bool notifyRaced;

  /// A rematch set waiting with this account's name on it.
  final bool notifyChallenged;

  /// A friend asking to go live now. The invite still shows in the app with
  /// this off; it only stops buzzing the phone.
  final bool notifyLiveInvite;
  final bool notifyFriendRequest;
  final bool notifyFriendOk;

  RemotePrefs copyWith({
    Challengeable? challengeable,
    bool? showOnBoard,
    bool? showCountry,
    bool? notifyRaced,
    bool? notifyChallenged,
    bool? notifyLiveInvite,
    bool? notifyFriendRequest,
    bool? notifyFriendOk,
  }) => RemotePrefs(
    challengeable: challengeable ?? this.challengeable,
    showOnBoard: showOnBoard ?? this.showOnBoard,
    showCountry: showCountry ?? this.showCountry,
    notifyRaced: notifyRaced ?? this.notifyRaced,
    notifyChallenged: notifyChallenged ?? this.notifyChallenged,
    notifyLiveInvite: notifyLiveInvite ?? this.notifyLiveInvite,
    notifyFriendRequest: notifyFriendRequest ?? this.notifyFriendRequest,
    notifyFriendOk: notifyFriendOk ?? this.notifyFriendOk,
  );

  /// How many of the notification switches are on, for the row that says so
  /// without making anybody open the screen.
  int get noticesOn =>
      (notifyRaced ? 1 : 0) +
      (notifyChallenged ? 1 : 0) +
      (notifyLiveInvite ? 1 : 0) +
      (notifyFriendRequest ? 1 : 0) +
      (notifyFriendOk ? 1 : 0);

  static const noticeCount = 5;
}

/// A lifter, as the server knows them.
class RemoteProfile {
  const RemoteProfile({
    required this.id,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.friendCode,
    this.country,
    this.prefs = const RemotePrefs(),
    this.avatarUrl,
    this.lifter,
    this.usernameChangedAt,
    this.countryChangedAt,
    this.peakTierIdx = 0,
    this.wins = 0,
    this.losses = 0,
    this.winStreak = 0,
    this.bestStreak = 0,
    this.placementsDone = 0,
    this.placementWins = 0,
    this.totalReps = 0,
    this.bestSet = 0,
    this.xp = 0,
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;

  /// Experience: every rep and every match played (xp.dart).
  final int xp;

  /// Assigned by the server once, at sign-up — see the comment on the
  /// friend_code column in schema.sql.
  final String friendCode;

  /// The highest tier this account has ever held — the floor a losing streak
  /// cannot cost it.
  final int peakTierIdx;

  final int wins;
  final int losses;
  final int winStreak;
  final int bestStreak;

  /// Placement duels won so far. Only meaningful while [placementsDone] is
  /// under 5 — it is what decides the starting tier.
  final int placementsDone;
  final int placementWins;

  final int totalReps;
  final int bestSet;

  /// Two-letter code, or null on a phone that would not say. What the
  /// country board filters on.
  final String? country;

  final RemotePrefs prefs;

  /// Null until this account has uploaded a photo or made its lifter. The
  /// lifter its name gives is the fallback everywhere this is shown, not a
  /// broken image.
  final String? avatarUrl;

  /// The parts of the lifter this account made (Lifter.toJson), or null
  /// before it made one: how a second phone gets it back to edit.
  final Map<String, dynamic>? lifter;

  /// When the username was last chosen, or null when it never was. For
  /// fourteen days after it, [Backend.renameUsername] answers
  /// [RenameResult.alreadyChanged].
  final DateTime? usernameChangedAt;

  /// When this lifter last chose their country, or null when it was never
  /// chosen. Like the name, it can change again fourteen days after, once the
  /// account has an email ([Backend.setMyCountry]).
  final DateTime? countryChangedAt;

  /// Everything but the field or two an update actually changed. A backend
  /// method rebuilding this by hand, one field at a time, is exactly how a
  /// new field here goes missing from an update that has no reason to touch
  /// it — this happened more than once before this existed.
  RemoteProfile copyWith({
    String? username,
    int? tierIdx,
    int? divIdx,
    int? lp,
    String? country,
    RemotePrefs? prefs,
    String? avatarUrl,
    Map<String, dynamic>? lifter,
    DateTime? usernameChangedAt,
    DateTime? countryChangedAt,
    int? peakTierIdx,
    int? wins,
    int? losses,
    int? winStreak,
    int? bestStreak,
    int? placementsDone,
    int? placementWins,
    int? totalReps,
    int? bestSet,
    int? xp,
    // A null [avatarUrl] keeps the one there; this is how it goes.
    bool clearAvatar = false,
  }) => RemoteProfile(
    id: id,
    username: username ?? this.username,
    tierIdx: tierIdx ?? this.tierIdx,
    divIdx: divIdx ?? this.divIdx,
    lp: lp ?? this.lp,
    friendCode: friendCode,
    country: country ?? this.country,
    prefs: prefs ?? this.prefs,
    avatarUrl: clearAvatar ? null : avatarUrl ?? this.avatarUrl,
    lifter: lifter ?? this.lifter,
    usernameChangedAt: usernameChangedAt ?? this.usernameChangedAt,
    countryChangedAt: countryChangedAt ?? this.countryChangedAt,
    peakTierIdx: peakTierIdx ?? this.peakTierIdx,
    wins: wins ?? this.wins,
    losses: losses ?? this.losses,
    winStreak: winStreak ?? this.winStreak,
    bestStreak: bestStreak ?? this.bestStreak,
    placementsDone: placementsDone ?? this.placementsDone,
    placementWins: placementWins ?? this.placementWins,
    totalReps: totalReps ?? this.totalReps,
    bestSet: bestSet ?? this.bestSet,
    xp: xp ?? this.xp,
  );
}

/// Somebody this account has blocked.
class BlockedLifter {
  const BlockedLifter({
    required this.id,
    required this.username,
    required this.at,
  });

  final String id;
  final String username;
  final DateTime at;
}

/// Somebody this account has muted — stopped being offered as an opponent,
/// without the block's other effects.
class MutedLifter {
  const MutedLifter({
    required this.id,
    required this.username,
    required this.at,
  });

  final String id;
  final String username;
  final DateTime at;
}

/// Why somebody is being reported. The server takes these names and no
/// others, so a new one here needs the check constraint to learn it too.
enum ReportReason { cheating, harassment, content, impersonation, other }

/// What is about to be lost, for the screen that asks whether you are sure.
class AccountSummary {
  const AccountSummary({
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.placementsDone,
    required this.totalReps,
    required this.bestSet,
    required this.friends,
  });

  final int tierIdx;
  final int divIdx;
  final int lp;
  final int placementsDone;
  final int totalReps;
  final int bestSet;
  final int friends;

  bool get ranked => placementsDone >= 5;
}

/// One row of the board.
///
/// Placed accounts only. An account still in placements has a `tierIdx` of 0
/// because the column has to hold something, not because it is at the bottom
/// of the ladder — putting that on a board would rank somebody the app has
/// deliberately not ranked yet.
class BoardRow {
  const BoardRow({
    required this.id,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.wins,
    required this.losses,
    this.avatarUrl,
    this.xp = 0,
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;
  final int wins;
  final int losses;
  final String? avatarUrl;
  final int xp;
}

/// How somebody looks (account.sql, pro_looks): whether they are Pro, the
/// lifter they made, and the cover over their profile, which is only ever
/// given while they are Pro.
class ProLook {
  const ProLook({required this.id, this.pro = false, this.lifter, this.cover});

  final String id;
  final bool pro;

  /// Lifter.toJson of the lifter they made; null before they made one.
  final Map<String, dynamic>? lifter;

  /// One of the moving scenes by id, or the URL of their own cover photo.
  final String? cover;
}

/// One row of this month's board.
///
/// [points] is the LP won in ranked duels since the 1st, less the LP lost —
/// the month's race, separate from the rank, which never comes down.
class MonthRow {
  const MonthRow({
    required this.place,
    required this.id,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.points,
    required this.wins,
    required this.played,
    this.avatarUrl,
    this.xp = 0,
  });

  final int place;
  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int points;
  final int wins;
  final int played;
  final String? avatarUrl;
  final int xp;
}

/// Where this account stands in the month that is running, and when it ends.
class MonthPlace {
  const MonthPlace({
    required this.season,
    required this.endsAt,
    required this.place,
    required this.ofTotal,
    required this.points,
    required this.wins,
    required this.played,
  });

  /// The 1st of the month, UTC.
  final DateTime season;
  final DateTime endsAt;

  /// Null until a ranked duel this month puts the account on the board.
  final int? place;
  final int ofTotal;
  final int points;
  final int wins;
  final int played;
}

/// The last month to close and its top ten as it finished: what the month's
/// board shows while the new month has nobody on it yet.
class MonthWinners {
  const MonthWinners({required this.season, required this.rows});

  /// The 1st of that month, UTC.
  final DateTime season;

  /// First place first. [MonthRow.wins] is not kept with an award, so it is
  /// always 0 here.
  final List<MonthRow> rows;
}

/// What the end of a month gives out: a place in the top ten, or the badge
/// for twenty ranked duels.
enum SeasonAwardKind { champion, podium, top10, regular }

/// The ranked duels in one month that earn [SeasonAwardKind.regular].
const kRegularDuels = 20;

/// One award from one finished month.
class SeasonAward {
  const SeasonAward({
    required this.season,
    required this.kind,
    this.place,
    this.points = 0,
    this.played = 0,
    this.seen = true,
  });

  final DateTime season;
  final SeasonAwardKind kind;

  /// The place on the board; null for the badge, which is not one.
  final int? place;
  final int points;
  final int played;

  /// Whether the app has told this account about it yet. Only meaningful for
  /// the account's own awards.
  final bool seen;
}

/// Everything a profile card needs about somebody else, in one read: their
/// own totals, where they stand on the board, and the head-to-head with the
/// account asking.
class LifterProfile {
  const LifterProfile({
    required this.id,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.placementsDone,
    required this.totalReps,
    required this.bestSet,
    required this.wins,
    required this.losses,
    required this.winStreak,
    this.globalPlace,
    this.country,
    this.countryPlace,
    required this.isFriend,
    required this.winsVsYou,
    required this.lossesVsYou,
    this.yourBestVsThem,
    this.lastDuelAt,
    this.lastYourReps,
    this.lastTheirReps,
    this.avatarUrl,
    this.title,
    this.xp = 0,
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;
  final int placementsDone;
  final int totalReps;
  final int bestSet;
  final int wins;
  final int losses;
  final int winStreak;

  /// Null when they are not placed, or have asked to be left off the board.
  final int? globalPlace;
  final String? country;
  final int? countryPlace;

  final bool isFriend;

  /// Counted from the duels the two actually played. [winsVsYou] is theirs.
  final int winsVsYou;
  final int lossesVsYou;

  /// The most reps you have ever put up against this specific opponent.
  /// Null before the two have played.
  final int? yourBestVsThem;

  /// The most recent duel between the two, if there has been one.
  final DateTime? lastDuelAt;
  final int? lastYourReps;
  final int? lastTheirReps;

  final String? avatarUrl;

  /// The id of the title they wear, or null for none.
  final String? title;

  final int xp;

  bool get ranked => placementsDone >= 5;
  bool get hasPlayedThem => lastDuelAt != null;
}

/// Somebody this account is friends with.
class RemoteFriend {
  const RemoteFriend({
    required this.id,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.placementsDone,
    required this.lastSeen,
    required this.winsVsYou,
    required this.lossesVsYou,
    this.avatarUrl,
    this.xp = 0,
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;
  final int xp;

  /// Below five they have no rank yet, and a row must say "Unranked" rather
  /// than read their placeholder tier as a rank.
  final int placementsDone;

  /// When they last had the app open. There is no presence service behind
  /// this — "online" is a recent enough timestamp, which is the question the
  /// screen is really asking.
  final DateTime lastSeen;

  /// Counted from the duels the two actually played. [winsVsYou] is theirs.
  final int winsVsYou;
  final int lossesVsYou;

  final String? avatarUrl;

  /// The window that counts as being around. Long enough to survive a phone
  /// locking mid-scroll, short enough that "online" means something.
  static const around = Duration(minutes: 5);

  bool get online => DateTime.now().difference(lastSeen) < around;
}

/// A friend request waiting on an answer from this account.
class FriendRequest {
  const FriendRequest({
    required this.id,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    this.askedAt,
    this.placementsDone = 0,
    this.bestSet = 0,
    this.wins = 0,
    this.losses = 0,
    this.avatarUrl,
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;

  /// When they asked.
  final DateTime? askedAt;

  /// Below five they have no rank yet: the card says Unranked rather than
  /// read their placeholder tier as one.
  final int placementsDone;

  final int bestSet;
  final int wins;
  final int losses;
  final String? avatarUrl;
}

/// The friend code in what somebody typed to add a friend, or null when it
/// reads as a username.
///
/// The profile shows a code as "#123456", and people type it back every way:
/// with the '#', without it, with a space in the middle. Only '#' used to
/// count, so a code typed without one was looked up as a name and found
/// nobody.
String? friendCodeIn(String typed) {
  final compact = typed.replaceAll(RegExp(r'\s'), '');
  if (compact.startsWith('#')) {
    final code = compact.substring(1);
    return code.isEmpty ? null : code;
  }
  return RegExp(r'^\d{6}$').hasMatch(compact) ? compact : null;
}

/// Somebody found by name, who may or may not be anybody's friend yet.
class FoundLifter {
  const FoundLifter({
    required this.id,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.placementsDone,
    this.avatarUrl,
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int placementsDone;
  final String? avatarUrl;
}

/// What happened while this lifter was not looking.
enum NoticeKind {
  /// Somebody raced a set this account had stored. The one that makes an
  /// async duel a duel: without it, the person being raced never finds out.
  raced,

  /// Somebody asked to be friends.
  friendRequest,

  /// Somebody said yes.
  friendAccepted,

  /// Somebody wants a rematch. Their half is already stored and waiting —
  /// see [Backend.findTargetedOpponent].
  challenged,

  /// A friend asked to go live. The invite itself lasts a minute; the notice
  /// stays as a record that they asked. See [Backend.liveInvites].
  liveInvite,

  /// A friend passed this account on this week's board (notify.sql,
  /// notify_passed).
  passed,

  /// Somebody took this account's challenge by link (challenge.sql):
  /// [Notice.theirReps] against [Notice.yourReps], and [Notice.youWon] when
  /// this account's count held. Opens [Notice.challengeCode].
  challengeTaken,

  /// Somebody who took this account's challenge sent one back: their minute,
  /// [Notice.theirReps], to race at [Notice.challengeCode].
  challengeBack,
}

// ──────────────────────────────── live matches ────────────────────────────────

/// Who is on the other side of a live match.
class LiveOpponent {
  const LiveOpponent({
    required this.id,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    this.avatarUrl,
    this.xp = 0,
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;

  /// Their uploaded picture, or null for the drawn initial.
  final String? avatarUrl;
  final int xp;
}

/// A live match this account is in: both lifters on camera at once.
class LiveMatch {
  const LiveMatch({
    required this.id,
    required this.ranked,
    required this.opponent,
  });

  final String id;

  /// Ranked matches come from the live queue and move the ladder; a match
  /// with a friend is friendly and moves nothing; a rematch is whatever the
  /// match before it was.
  final bool ranked;
  final LiveOpponent opponent;
}

/// A friend's invite waiting on this account.
class LiveInvite {
  const LiveInvite({
    required this.matchId,
    required this.from,
    required this.expiresIn,
    this.ranked = false,
  });

  final String matchId;
  final LiveOpponent from;

  /// A friend's invite is friendly; a rematch is as ranked as the match
  /// before it.
  final bool ranked;

  /// How long it has left, from when it was read.
  final Duration expiresIn;
}

enum LiveStatus {
  /// Asked, not answered.
  invited,

  /// Both in; getting into position.
  ready,

  /// Both in position; the round has a start.
  live,

  done,
  cancelled,
  declined,
  expired;

  static LiveStatus parse(String? value) => LiveStatus.values.firstWhere(
    (s) => s.name == value,
    orElse: () => LiveStatus.cancelled,
  );

  /// Over without a round ever being played.
  bool get calledOff =>
      this == cancelled || this == declined || this == expired;
}

/// Where a live match stands, from this account's side.
class LiveState {
  const LiveState({
    required this.status,
    required this.ranked,
    required this.opponent,
    required this.theyAreReady,
    required this.theirReps,
    this.startsIn,
    this.expiresIn,
  });

  final LiveStatus status;
  final bool ranked;
  final LiveOpponent opponent;
  final bool theyAreReady;

  /// The last count their phone reported to the server.
  final int theirReps;

  /// How far away the round's start is, once both are in position. Relative
  /// on purpose: the two phones' clocks do not have to agree for the round
  /// to start at the same moment on both.
  final Duration? startsIn;

  /// How long an invite has left.
  final Duration? expiresIn;
}

/// The end of a live match: the result once the server has both sets, or
/// nothing yet while it waits for the other phone.
class LiveFinish {
  const LiveFinish({this.settled, this.theirReps});

  final SettledDuel? settled;

  /// Their count as the server settled it.
  final int? theirReps;

  bool get done => settled != null;
}

/// Who else is around while the live search waits. Counts only.
class LiveOnline {
  const LiveOnline({required this.searching, required this.online});

  /// In the live queue right now, besides this account.
  final int searching;

  /// Had the app open in the last few minutes, besides this account.
  final int online;
}

/// Where the other lifter is, after a live match, as their result screen
/// reports it.
enum RematchPresence {
  /// On the result screen now.
  here,

  /// Not there yet: still finishing the round on their side.
  waiting,

  /// Gone from it, or silent too long to still be there.
  left,
}

/// Where a live rematch stands, from the side that asked for it.
class LiveRematch {
  const LiveRematch({
    required this.matchId,
    required this.status,
    required this.ranked,
  });

  final String matchId;

  /// [LiveStatus.invited] while waiting on the other side,
  /// [LiveStatus.ready] once both have asked.
  final LiveStatus status;
  final bool ranked;
}

/// One message between the two phones during a round.
class LiveMessage {
  const LiveMessage({required this.reps, this.gaveUp = false});

  final int reps;

  /// They pressed Give up: their count will not move again.
  final bool gaveUp;

  Map<String, dynamic> toJson() => {'reps': reps, 'gave_up': gaveUp};

  static LiveMessage? fromJson(Map<String, dynamic> json) {
    final reps = json['reps'];
    if (reps is! num) return null;
    return LiveMessage(reps: reps.toInt(), gaveUp: json['gave_up'] == true);
  }
}

/// The line between the two phones while a round runs. Only for showing the
/// other count as it moves — the result is settled from the two sets.
abstract interface class LiveLink {
  Stream<LiveMessage> get messages;
  Future<void> send(LiveMessage message);
  Future<void> close();
}

/// One of this account's duels as the server holds it, from this account's
/// side: what the history is made of.
class ServerDuel {
  const ServerDuel({
    required this.duelId,
    required this.at,
    required this.opponentName,
    required this.opponentTier,
    required this.won,
    required this.yourReps,
    required this.theirReps,
    required this.lpDelta,
    this.racedWhileAway = false,
  });

  final String duelId;
  final DateTime at;
  final String opponentName;
  final int opponentTier;
  final bool won;
  final int yourReps;
  final int theirReps;
  final int lpDelta;

  /// Somebody raced this account's stored set while it was away — the other
  /// half of "your set is in the pool". The one kind of duel a phone never
  /// wrote down itself before the history came from the server.
  final bool racedWhileAway;
}

/// One thing the server has to tell somebody.
class Notice {
  const Notice({
    required this.id,
    required this.kind,
    required this.at,
    required this.unread,
    required this.actorName,
    this.actorId,
    this.youWon,
    this.yourReps,
    this.theirReps,
    this.lpDelta,
    this.challengeCode,
  });

  final String id;
  final NoticeKind kind;
  final DateTime at;
  final bool unread;

  /// Who caused it, by the name they went by at the time. Kept beside the
  /// id, because the account may be gone and a notice that has forgotten who
  /// it was about is worse than none.
  final String actorName;

  /// Who caused it, when that account still exists. Null does not mean
  /// nobody did it — see [actorName] — it means there is nobody left to act
  /// on, which matters for [NoticeKind.challenged]: no id, no rematch to find.
  final String? actorId;

  /// Only for [NoticeKind.raced].
  final bool? youWon;
  final int? yourReps;
  final int? theirReps;

  /// Only for [NoticeKind.raced]: what the duel did to this account's LP.
  /// Null for an unranked duel, and for notices from before it was kept.
  final int? lpDelta;

  /// Only for [NoticeKind.challengeTaken] and [NoticeKind.challengeBack]:
  /// the challenge the notice opens.
  final String? challengeCode;
}

// ───────────────────────────── a challenge by link ────────────────────────────

/// A whole minute of this account's own, with the times of its reps
/// (plan.sql, my_best_minute): what "last week's you" lifted, and how.
class BestMinute {
  const BestMinute({required this.reps, required this.repTimes, this.at});

  final int reps;

  /// When each rep landed, in milliseconds from the start of the minute.
  final List<int> repTimes;

  final DateTime? at;

  static BestMinute? fromJson(Object? json) {
    if (json is! Map) return null;
    final reps = (json['reps'] as num?)?.toInt() ?? 0;
    if (reps <= 0) return null;
    return BestMinute(
      reps: reps,
      repTimes: [
        for (final t in json['rep_times'] as List? ?? const [])
          if (t is num) t.toInt(),
      ],
      at: DateTime.tryParse(json['at'] as String? ?? '')?.toLocal(),
    );
  }
}

/// A link made for a set (challenge.sql): outrepd.com/c/<code>.
class ChallengeLink {
  const ChallengeLink({required this.code, required this.reps});

  final String code;

  /// The set's count: the number the card dares people to beat.
  final int reps;

  static ChallengeLink? fromJson(Object? json) {
    if (json is! Map) return null;
    final code = json['code'];
    if (code is! String) return null;
    return ChallengeLink(code: code, reps: (json['reps'] as num?)?.toInt() ?? 0);
  }
}

/// One line of a challenge's board: the one who set it, or one try.
class ChallengeEntry {
  const ChallengeEntry({
    required this.id,
    required this.username,
    required this.reps,
    required this.at,
    this.takeId,
    this.avatarUrl,
    this.owner = false,
    this.beat = false,
    this.canBack = false,
  });

  /// The try, for taking it back; null for the one who set it.
  final String? takeId;
  final String id;
  final String username;
  final String? avatarUrl;
  final int reps;
  final DateTime at;

  /// The one who set the challenge.
  final bool owner;

  /// More than the challenge's count.
  final bool beat;

  /// Whether the try's own minute can be raced back: a whole one.
  final bool canBack;

  factory ChallengeEntry.fromJson(Map<String, dynamic> json) => ChallengeEntry(
    takeId: json['take_id'] as String?,
    id: json['id'] as String? ?? '',
    username: json['username'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String?,
    reps: (json['reps'] as num?)?.toInt() ?? 0,
    at: DateTime.tryParse(json['at'] as String? ?? '')?.toLocal() ??
        DateTime.now(),
    owner: json['owner'] as bool? ?? false,
    beat: json['beat'] as bool? ?? false,
    canBack: json['can_back'] as bool? ?? false,
  );
}

/// Who a challenge belongs to.
class ChallengeOwner {
  const ChallengeOwner({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.tierIdx = 0,
    this.divIdx = 0,
    this.xp = 0,
  });

  final String id;
  final String username;
  final String? avatarUrl;
  final int tierIdx;
  final int divIdx;
  final int xp;
}

/// A challenge as a link opens it.
class ChallengeView {
  const ChallengeView({
    required this.code,
    required this.reps,
    required this.owner,
    required this.expiresAt,
    this.repTimes = const [],
    this.open = true,
    this.mine = false,
    this.taken,
    this.takeId,
    this.board = const [],
  });

  final String code;
  final int reps;

  /// When each rep of the set landed, for the bar the taker races.
  final List<int> repTimes;
  final ChallengeOwner owner;
  final DateTime expiresAt;

  /// Still taking tries. A closed one still shows its board.
  final bool open;

  /// This account's own.
  final bool mine;

  /// This account's try, when it has had one.
  final int? taken;
  final String? takeId;

  /// Everybody on it, best first.
  final List<ChallengeEntry> board;

  /// Where [id] is on the board, from 1; null when not on it.
  int? placeOf(String id) {
    final at = board.indexWhere((e) => e.id == id && !e.owner);
    return at < 0 ? null : at + 1;
  }

  static ChallengeView? fromJson(Object? json) {
    if (json is! Map) return null;
    final owner = json['owner'] as Map? ?? const {};
    return ChallengeView(
      code: json['code'] as String? ?? '',
      reps: (json['reps'] as num?)?.toInt() ?? 0,
      repTimes: [
        for (final t in json['rep_times'] as List? ?? const []) (t as num).toInt(),
      ],
      owner: ChallengeOwner(
        id: owner['id'] as String? ?? '',
        username: owner['username'] as String? ?? '',
        avatarUrl: owner['avatar_url'] as String?,
        tierIdx: (owner['tier_idx'] as num?)?.toInt() ?? 0,
        divIdx: (owner['div_idx'] as num?)?.toInt() ?? 0,
        xp: (owner['xp'] as num?)?.toInt() ?? 0,
      ),
      expiresAt:
          DateTime.tryParse(json['expires_at'] as String? ?? '')?.toLocal() ??
          DateTime.now(),
      open: json['open'] as bool? ?? false,
      mine: json['mine'] as bool? ?? false,
      taken: (json['taken'] as num?)?.toInt(),
      takeId: json['take_id'] as String?,
      board: [
        for (final row in json['board'] as List? ?? const [])
          ChallengeEntry.fromJson(Map<String, dynamic>.from(row as Map)),
      ],
    );
  }
}

/// One of this account's challenges, for the list on the profile.
class MyChallenge {
  const MyChallenge({
    required this.code,
    required this.reps,
    required this.createdAt,
    required this.expiresAt,
    this.open = true,
    this.takes = 0,
    this.beat = 0,
  });

  final String code;
  final int reps;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool open;

  /// How many took it, and how many of them beat it.
  final int takes;
  final int beat;

  factory MyChallenge.fromJson(Map<String, dynamic> json) => MyChallenge(
    code: json['code'] as String? ?? '',
    reps: (json['reps'] as num?)?.toInt() ?? 0,
    createdAt:
        DateTime.tryParse(json['created_at'] as String? ?? '')?.toLocal() ??
        DateTime.now(),
    expiresAt:
        DateTime.tryParse(json['expires_at'] as String? ?? '')?.toLocal() ??
        DateTime.now(),
    open: json['open'] as bool? ?? false,
    takes: (json['takes'] as num?)?.toInt() ?? 0,
    beat: (json['beat'] as num?)?.toInt() ?? 0,
  );
}

/// What came of asking somebody to be friends.
enum AskResult {
  /// The request is in, waiting on them.
  asked,

  /// They had already asked, so asking back settled it.
  friends,

  /// Nobody goes by that name.
  noSuchLifter,

  /// That name is this account's own.
  thatIsYou,
}

/// What happened to a rename.
/// Where an Apple or Google identity comes from.
enum SocialProvider { apple, google }

/// Why the last Apple or Google sign-in failed, in the words it failed
/// with, for the message on the screen. Null when it did not.
String? lastSocialSignInError;

/// What signing in with Apple or Google did.
enum SocialSignInResult {
  /// A new account: this phone's guest, now carrying the identity and
  /// everything it had already earned. It still has to choose a name.
  newAccount,

  /// An account that already had this identity, now signed in to.
  existingAccount,

  failed,
  offline,
}

enum RenameResult {
  ok,

  /// Somebody else already has it. Checked again on the server even though
  /// the rename screen already asked — the gap between the two is exactly
  /// long enough for that somebody else to have just taken it.
  taken,

  /// Too short, too long, empty, or not just letters, digits and
  /// underscores with at least one letter or digit.
  invalid,

  /// This account already spent its one rename.
  alreadyChanged,

  /// A name the server refuses to show on a board: abuse, or one that would
  /// pass for the app itself.
  notAllowed,
}

enum CountryResult {
  ok,

  /// Chosen less than fourteen days ago, on an account with an email.
  tooSoon,

  /// Not a two-letter code, or asked too often in an hour.
  invalid,
}

/// What happened trying to attach an email to this account.
enum EmailSignUpResult {
  ok,

  /// Somebody else already has this email — not necessarily them; theirs
  /// might just be a different device that reached it first.
  taken,

  /// Not a real address.
  invalid,

  /// Too many codes sent to this address too quickly. Not a mistake in
  /// what was typed, so it earns its own message rather than [invalid]'s.
  rateLimited,

  /// The server could not be reached. Nothing is wrong with the address, so
  /// this must never read as [invalid].
  offline,
}

/// The account App Review signs in with, from "I already have an account".
/// Its inbox is nobody's: no code is sent to it, and what is typed in the
/// code boxes is the account's own six-digit password instead. The account
/// is added by hand in the Supabase dashboard; the app never makes it.
const kReviewEmail = 'appreview@outrepd.com';

/// What happened trying to send a sign-in code to an email.
enum EmailLoginCodeResult {
  ok,

  /// No account holds this email. Unlike [EmailSignUpResult], signing in
  /// never creates one, so an address nobody owns is its own answer rather
  /// than a code sent into the void.
  notFound,

  /// Too many codes sent to this address too quickly.
  rateLimited,

  /// The server could not be reached. Said as such, never as [notFound]:
  /// telling somebody with no signal that their account does not exist is
  /// how people end up making a second one.
  offline,
}

/// Somebody else's minute, waiting to be raced.
class OpponentSet {
  const OpponentSet({
    required this.setId,
    required this.profileId,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.reps,
    this.repTimes = const [],
    this.avatarUrl,
    this.xp = 0,
  });

  /// Their uploaded picture, or null for the drawn initial.
  final String? avatarUrl;
  final int xp;

  final String setId;
  final String profileId;
  final String username;
  final int tierIdx;
  final int divIdx;

  /// What they did. Shown on the VS card, which is the whole point of racing
  /// a stored set rather than a number the app made up.
  final int reps;

  /// When each of their reps landed, in milliseconds from the start of their
  /// minute. It is what lets their bar move at their pace instead of their
  /// total spread evenly — which is a lie, and one that feels like racing a
  /// progress bar rather than a person.
  final List<int> repTimes;
}

/// What the server made of a duel. The rank in here is the rank — the client
/// does not compute it, because a client that computes its own rank can type
/// itself to the top of the board.
class SettledDuel {
  const SettledDuel({
    required this.duelId,
    required this.won,
    required this.lpDelta,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.wins,
    required this.losses,
    required this.winStreak,
    required this.bestStreak,
    required this.placementsDone,
    required this.placementWins,
    this.ranked = true,
  });

  final String duelId;
  final bool won;
  final int lpDelta;

  /// Whether it moved the ladder. The phone asks for ranked; the server can
  /// still make a duel friendly — a third in a day with the same lifter —
  /// and the result screen has to say so rather than show a rank card for
  /// nothing.
  final bool ranked;
  final int tierIdx;
  final int divIdx;
  final int lp;

  /// The record and the placements, as they stand on this account right
  /// after this duel. Not recomputed locally: `settle_duel` already updated
  /// every one of these on the same row it read the reps from, and copying
  /// them out is the only way the app can never disagree with it.
  final int wins;
  final int losses;
  final int winStreak;
  final int bestStreak;
  final int placementsDone;
  final int placementWins;
}

/// One set, on its way up.
///
/// Both counts travel: what the camera scored and what the lifter confirmed.
/// Keeping only the confirmed one would throw away the only measurement of the
/// counter this project will ever have; keeping only the camera's would mean
/// overruling somebody about their own set.
class SetUpload {
  const SetUpload({
    required this.reps,
    required this.repsCamera,
    required this.depth,
    required this.confident,
    required this.durationMs,
    this.gaveUp = false,
    this.repTimes = const [],
    this.challengeTarget,
    this.practice = false,
  });

  /// When each rep landed, milliseconds from the start of the set. Read off
  /// the same signal the count is scored from, so the two cannot disagree
  /// about how many there were.
  final List<int> repTimes;

  final int reps;
  final int repsCamera;
  final double depth;
  final bool confident;
  final int durationMs;
  final bool gaveUp;

  /// Set only for a rematch: this set is reserved for exactly this lifter to
  /// find with [Backend.findTargetedOpponent], not for the open pool
  /// [Backend.findOpponent] hands out from.
  final String? challengeTarget;

  /// A practice minute: stored for the totals and the experience it adds,
  /// never offered to anybody to race.
  final bool practice;
}

abstract interface class Backend {
  /// Whether there is a server at all. False means every screen that needs one
  /// should say so rather than spin.
  bool get available;

  /// Who is signed in, or null.
  RemoteProfile? get me;

  /// Signs in and makes sure a profile row exists.
  Future<RemoteProfile> signIn({required String username});

  /// The signed-in account's profile as this phone last read it from the
  /// server, made [me] at once; null on a first launch, or when what is kept
  /// belongs to another account. For a launch that should open without
  /// waiting on the network: [signIn] still reads the fresh one.
  Future<RemoteProfile?> cachedMe();

  /// This account's row read again, or null when nobody is signed in.
  /// Unlike [signIn], never starts an account of its own.
  Future<RemoteProfile?> refreshMe();

  /// Stores a finished set and returns its id.
  Future<String> uploadSet(SetUpload set);

  /// Somebody near this lifter's level whose set has not been raced.
  Future<OpponentSet?> findOpponent();

  /// The specific set [theirId] reserved for this account with a rematch
  /// challenge. Null if there is not one — already raced, or never sent.
  Future<OpponentSet?> findTargetedOpponent(String theirId);

  /// Compares the two sets and moves both ranks. The server does the
  /// arithmetic; this returns what it decided.
  ///
  /// [ranked] false is a friend room: a real duel with a real result, and one
  /// that moves nothing on the ladder — not the rank, not the record, not the
  /// placements. Reps still land, because those were done regardless.
  Future<SettledDuel> settle({
    required String mySetId,
    required String theirSetId,
    bool ranked = true,
  });

  /// The board, best first. [country] limits it to one country's board, which
  /// is the only one most people can realistically move. [tierIdx]/[divIdx]
  /// limit it to one rung of the ladder instead — everybody who currently
  /// shares it, ranked against each other rather than the whole game.
  Future<List<BoardRow>> leaderboard({
    int limit = 100,
    String? country,
    int? tierIdx,
    int? divIdx,
  });

  /// Where this account sits on that board, counting from 1.
  ///
  /// Null when there is no answer: not placed yet, or not signed in. A
  /// position is the one number somebody looks for themselves, so it is
  /// either the real one or nothing.
  Future<int?> boardPosition({String? country});

  /// This month's board, best first: everyone placed who has lifted in a
  /// ranked duel since the 1st, by the LP that won them.
  Future<List<MonthRow>> monthBoard({int limit = 100, String? country});

  /// Where this account stands this month. Also closes any month that has
  /// ended, so it is what hands out last month's awards. Null with no
  /// account to ask about.
  Future<MonthPlace?> myMonthPlace({String? country});

  /// The last month to close, with its top ten. Null before any month has
  /// closed with somebody on it.
  Future<MonthWinners?> lastMonthWinners();

  /// How the accounts [ids] look, by id: Pro, lifter, cover. Accounts the
  /// server does not know are left out.
  Future<Map<String, ProLook>> proLooks(List<String> ids);

  /// Sets this account's cover: a scene's id, or null for none. A photo
  /// goes through [uploadCover].
  Future<void> saveCover(String? cover);

  /// Uploads [bytes] as this account's cover photo and makes it the cover;
  /// returns its URL.
  Future<String> uploadCover(Uint8List bytes);

  /// The week's board (supabase/seasons.sql): the month's points since
  /// Monday, 00:00 UTC. Rows and the caller's place come back in the month's
  /// shapes, [MonthPlace.season] being the Monday.
  Future<List<MonthRow>> weekBoard({int limit = 100, String? country});
  Future<MonthPlace?> myWeekPlace({String? country});

  /// The week's board, or with [month] the month's, among this account and
  /// its friends only (supabase/seasons.sql friends_board; pick B,
  /// 2026-11-02): the whole board's rules, but everyone in the circle on
  /// it, a friend with no ranked duel yet at 0.
  Future<List<MonthRow>> friendsBoard({bool month = false});

  /// The rating board among this account and its friends only.
  Future<List<BoardRow>> friendsLeaderboard();

  /// This account's awards from finished months, newest first.
  Future<List<SeasonAward>> mySeasonAwards();

  /// Marks every award this account has as told, so it is shown once.
  Future<void> markSeasonAwardsSeen();

  /// Somebody else's awards, for their profile card.
  Future<List<SeasonAward>> lifterSeasonAwards(String theirId);

  /// Everything a profile card needs about somebody else. Null when there is
  /// no such account.
  Future<LifterProfile?> lifterProfile(String theirId);

  /// Everybody this account is friends with, and the head-to-head with each.
  Future<List<RemoteFriend>> friends();

  /// Requests waiting on an answer from this account.
  Future<List<FriendRequest>> friendRequests();

  /// People whose name starts with [query]. Under two characters this
  /// returns nothing rather than most of the userbase.
  Future<List<FoundLifter>> findLifters(String query);

  /// Ask somebody, by the name they go by or by their `#`-prefixed friend
  /// code.
  Future<AskResult> askFriend(String identifier);

  /// Answer a request waiting on this account. Declining forgets it, so they
  /// are free to ask again.
  Future<void> answerFriend(String theirId, {required bool accept});

  /// Says this account is around. Cheap, and the only thing behind the
  /// online dot on a friends list.
  Future<void> touch();

  /// The title this account wears, by id, for other people to see. Null
  /// takes it off.
  Future<void> setTitle(String? id);

  /// What happened while this lifter was away, newest first.
  Future<List<Notice>> notices();

  /// This account's last fifty duels, newest first, for the history.
  Future<List<ServerDuel>> myDuels();

  /// This account's push-ups day by day over the last [lastDays], keyed
  /// `yyyy-mm-dd` in this phone's own days: every set it uploaded. For a
  /// phone that has not kept them — a new one, or one signed out and back in.
  Future<Map<String, int>> myDays({int lastDays = 31});

  /// How many of those have not been seen. What the dot on the bell counts.
  Future<int> unreadNotices();

  /// Marks them all seen, which is what opening the screen means.
  Future<void> readNotices();

  // ───────────────────────── settings and safety ──────────────────────────

  /// Changes one or more of the server-kept preferences, and returns what
  /// the account now holds.
  Future<RemotePrefs> savePrefs(RemotePrefs prefs);

  /// Stop being friends, without blocking: they are not told, and either can
  /// ask again.
  Future<void> removeFriend(String theirId);

  /// Block somebody. Ends the friendship, and they are not told.
  Future<void> block(String theirId);

  Future<void> unblock(String theirId);

  /// Who this account has blocked, newest first.
  Future<List<BlockedLifter>> blocked();

  /// Mute somebody: stop being offered their stored sets to race. Lighter
  /// than [block] — the friendship stands, the profile stays visible, and
  /// they are not told either way.
  Future<void> mute(String theirId);

  Future<void> unmute(String theirId);

  /// Who this account has muted, newest first.
  Future<List<MutedLifter>> muted();

  /// File a report. Write-only: nothing reads these back.
  Future<void> report({
    String? aboutId,
    required ReportReason reason,
    String details = '',
  });

  /// Whether [name] is free to take, for the rename screen to show live as
  /// somebody types.
  Future<bool> usernameAvailable(String name);

  /// Renames this account.
  Future<RenameResult> renameUsername(String name);

  /// Sets this account's country, by its two-letter code.
  Future<CountryResult> setMyCountry(String code);

  /// The adventure's stars on this account, one per level from the first,
  /// 0 for a level not won.
  Future<List<int>> myAdventure();

  /// Writes [stars] onto the account. The server keeps the best of what it
  /// had and what it is sent on every level, so two phones never take stars
  /// off each other; it hands back what it now holds.
  Future<List<int>> saveAdventure(List<int> stars);

  /// The titles earned, the one worn and the streak, as the account holds
  /// them (supabase/adventure.sql, rewards): an empty map for nothing yet.
  Future<Map<String, dynamic>> myRewards();

  /// This phone's copy, merged into the account's: every title either side
  /// has, the larger tally, the streak of whichever trained last. Returns
  /// the merged one, with whatever another phone added.
  Future<Map<String, dynamic>> saveRewards(Map<String, dynamic> state);

  /// Signs in with an identity token from Apple or Google. On this phone's
  /// guest the identity is linked to it, so the guest becomes the account
  /// and keeps what it has — unless the identity already belongs to an
  /// account, which is then signed in to instead.
  Future<SocialSignInResult> signInWithIdToken({
    required SocialProvider provider,
    required String idToken,
    String? accessToken,
    String? nonce,
  });

  /// Uploads a new avatar photo and returns its public URL, already saved
  /// as this account's [RemoteProfile.avatarUrl]. A JPEG from the gallery,
  /// or the PNG of the account's lifter.
  Future<String> uploadAvatar(
    Uint8List bytes, {
    String contentType = 'image/jpeg',
  });

  /// Keeps the parts of this account's lifter on the account
  /// ([RemoteProfile.lifter]).
  Future<void> saveLifter(Map<String, Object> lifter);

  /// Takes this account's photo down: the link on the profile and the file,
  /// so every screen draws the lifter again.
  Future<void> removeAvatar();

  /// True once this account has a real email on it — not just an anonymous
  /// session tied to this one install, with nothing to sign back into if
  /// this phone is lost or this app is reinstalled.
  bool get hasRealAccount;

  /// The email on the account once [hasRealAccount] is true; null before
  /// then.
  String? get accountEmail;

  /// Attaches [email] to the current session without losing anything
  /// already on it — same id, same profile, same progress. A code is sent
  /// to [email]; nothing about the account changes until [verifyEmailCode]
  /// confirms it.
  Future<EmailSignUpResult> startEmailSignUp({required String email});

  /// Confirms the code [startEmailSignUp] or [resendEmailCode] sent. True
  /// once the account genuinely has this email; false for a wrong or
  /// expired code, never for anything else.
  Future<bool> verifyEmailCode({required String email, required String code});

  /// Sends a new code, for when the first one expired or never arrived.
  Future<void> resendEmailCode(String email);

  /// Sends a sign-in code to an existing account's email — a different
  /// account than whatever this device held before, if any. Unlike
  /// [startEmailSignUp], this never creates one:
  /// [EmailLoginCodeResult.notFound] answers an address with nothing
  /// behind it.
  Future<EmailLoginCodeResult> requestLoginCode(String email);

  /// Confirms the code [requestLoginCode] sent and signs into that
  /// account. True once signed in; false for a wrong or expired code.
  Future<bool> verifyLoginCode({required String email, required String code});

  /// What deleting this account would cost, read from the server rather
  /// than from whatever the phone happens to be showing.
  Future<AccountSummary?> accountSummary();

  /// Everything the server holds about this account, as it would be
  /// exported. The same shape the email attaches.
  Future<Map<String, dynamic>> myData();

  /// Sends the export to an address. The key that lets it send lives on the
  /// server; the app never sees it.
  Future<void> emailMyData(String address);

  /// Deletes the account and everything hanging off it. Irreversible.
  Future<void> deleteAccount();

  /// This account signs in with Apple: deleting it must revoke that. Asked
  /// of the server, not read off the session on the phone, which can be
  /// older than the account's last sign-in.
  Future<bool> signedInWithApple();

  /// Ends the app's access to the Apple ID, with a fresh authorization code
  /// from Apple's sheet (App Store guideline 5.1.1(v)). Throws when Apple or
  /// the server would not.
  Future<void> revokeAppleSignIn(String authorizationCode);

  /// Leaves the account on the server as it is and forgets it on this
  /// phone. [me] is null afterwards; [signIn] starts a fresh one.
  Future<void> signOut();

  /// Has the server read this account's subscription from RevenueCat now,
  /// rather than wait for RevenueCat's webhook: called the moment the store
  /// says it is active, so the first duel after a purchase is not turned
  /// down while the webhook is still on its way.
  Future<void> syncSubscription();

  /// Where the signed-in account's pushes go: this phone's address with
  /// Firebase, and the language to write them in. A phone that moves to
  /// another account moves with it.
  Future<void> registerPushToken(
    String token, {
    required String platform,
    required String language,
  });

  /// This phone gets no more of the signed-in account's pushes.
  Future<void> forgetPushToken(String token);

  // ── Live matches (supabase/live.sql) ──

  /// One step of the ranked live search: the match once somebody is found,
  /// null while this account waits in the queue. Called every second or so.
  Future<LiveMatch?> findLiveOpponent();

  /// The search is over without a live opponent.
  Future<void> leaveLiveQueue();

  /// How many are searching and how many are around, for the search screen.
  /// Null when there is nobody to ask.
  Future<LiveOnline?> liveOnline();

  /// Asks a friend to go live now. Returns the match's id.
  Future<String> inviteLive(String friendId);

  /// Invites waiting on this account.
  Future<List<LiveInvite>> liveInvites();

  /// Yes or no to an invite; what the invite is now.
  Future<LiveStatus> answerLiveInvite(String matchId, {required bool accept});

  Future<void> cancelLiveInvite(String matchId);

  /// Asks for another match with whoever [afterMatchId] was against, straight
  /// after it. When they have already asked, this is the yes and it starts.
  Future<LiveRematch> rematchLive(String afterMatchId);

  /// Says this phone is on [afterMatchId]'s result screen — or, with
  /// [leaving], that it has just left it — and answers where the other one
  /// is.
  Future<RematchPresence> liveResultPresence(
    String afterMatchId, {
    bool leaving = false,
  });

  Future<LiveState> liveState(String matchId);

  /// This lifter is in position. How far away the round's start is once both
  /// are; null while the other is not yet.
  Future<Duration?> liveReady(String matchId);

  /// This lifter's count so far, kept on the server in case the phone drops.
  Future<void> reportLiveCount(String matchId, int reps);

  /// This lifter's set, at the end of the round.
  Future<LiveFinish> finishLive(String matchId, SetUpload set);

  /// The result, for the one who finished first.
  Future<LiveFinish> liveResult(String matchId);

  /// The phone-to-phone line for a round.
  LiveLink openLiveLink(String matchId);

  /// A link for one of this account's sets: [setId], or the latest whole
  /// minute from the last day when null. Null when there is none to send.
  Future<ChallengeLink?> makeChallenge({String? setId});

  /// A link for this account's best whole minute, for the home card.
  Future<ChallengeLink?> challengeBest();

  /// What a link opens; null for a code that leads nowhere.
  Future<ChallengeView?> openChallenge(String code);

  /// This account's one try, with the set it just lifted for it.
  Future<ChallengeView> takeChallenge(String code, String setId);

  /// A challenge on one try's minute: sent back by the one who took it, or
  /// taken back by the owner. Null when there is none to make.
  Future<ChallengeLink?> backChallenge(String takeId);

  /// This account's challenges from the last month.
  Future<List<MyChallenge>> myChallenges();

  /// A won duel's experience paid again after a rewarded video
  /// (rewarded.sql, double_duel_xp): what was added, 0 when nothing was.
  Future<int> doubleDuelXp(String duelId);

  /// A Pro part worn for a day after a rewarded video: [key] in the
  /// lifter's parts, the part's [id], and what it replaced. The day's end.
  Future<DateTime> startProTrial(String key, String id, String? was);

  /// This account's six-week plan as the account keeps it (plan.sql), or
  /// null when it is on none.
  Future<Map<String, dynamic>?> myPlan();

  /// Keeps [plan] as this account's plan, or stops it when null. What was
  /// kept, cleaned the server's way.
  Future<Map<String, dynamic>?> savePlan(Map<String, Object?>? plan);

  /// This account's best whole minute lifted from [since] up to [before],
  /// with its pace. Null when there is none.
  Future<BestMinute?> myBestMinute(DateTime since, DateTime before);
}

/// The app with no server behind it.
///
/// Not a stub that throws — the app is usable this way today, and was for
/// months. It says plainly that there is nobody to race, which is the truth,
/// and everything that does not need an opponent keeps working.
class NoBackend implements Backend {
  const NoBackend();

  @override
  bool get available => false;

  @override
  RemoteProfile? get me => null;

  @override
  Future<RemoteProfile> signIn({required String username}) =>
      throw StateError('no server configured');

  @override
  Future<RemoteProfile?> cachedMe() async => null;

  @override
  Future<RemoteProfile?> refreshMe() async => null;

  @override
  Future<String> uploadSet(SetUpload set) =>
      throw StateError('no server configured');

  @override
  Future<OpponentSet?> findOpponent() async => null;

  @override
  Future<OpponentSet?> findTargetedOpponent(String theirId) async => null;

  @override
  Future<SettledDuel> settle({
    required String mySetId,
    required String theirSetId,
    bool ranked = true,
  }) => throw StateError('no server configured');

  // Empty rather than an error: a board with nobody on it is a true answer
  // when there is no server, and the screen already knows how to say so.
  @override
  Future<List<BoardRow>> leaderboard({
    int limit = 100,
    String? country,
    int? tierIdx,
    int? divIdx,
  }) async => const [];

  @override
  Future<int?> boardPosition({String? country}) async => null;

  @override
  Future<List<MonthRow>> monthBoard({int limit = 100, String? country}) async =>
      const [];

  @override
  Future<MonthPlace?> myMonthPlace({String? country}) async => null;

  @override
  Future<MonthWinners?> lastMonthWinners() async => null;

  @override
  Future<Map<String, ProLook>> proLooks(List<String> ids) async => const {};

  @override
  Future<void> saveCover(String? cover) =>
      throw StateError('no server configured');

  @override
  Future<String> uploadCover(Uint8List bytes) =>
      throw StateError('no server configured');

  @override
  Future<List<MonthRow>> weekBoard({int limit = 100, String? country}) async =>
      const [];

  @override
  Future<MonthPlace?> myWeekPlace({String? country}) async => null;

  @override
  Future<List<MonthRow>> friendsBoard({bool month = false}) async => const [];

  @override
  Future<List<BoardRow>> friendsLeaderboard() async => const [];

  @override
  Future<List<SeasonAward>> mySeasonAwards() async => const [];

  @override
  Future<void> markSeasonAwardsSeen() async {}

  @override
  Future<List<SeasonAward>> lifterSeasonAwards(String theirId) async =>
      const [];

  @override
  Future<LifterProfile?> lifterProfile(String theirId) async => null;

  @override
  Future<List<RemoteFriend>> friends() async => const [];

  @override
  Future<List<FriendRequest>> friendRequests() async => const [];

  @override
  Future<List<FoundLifter>> findLifters(String query) async => const [];

  // Asking throws rather than answering, because these are the calls a
  // button is wired to: silently pretending an invitation was sent would be
  // worse than the screen saying it needs a server.
  @override
  Future<AskResult> askFriend(String username) =>
      throw StateError('no server configured');

  @override
  Future<void> answerFriend(String theirId, {required bool accept}) =>
      throw StateError('no server configured');

  @override
  Future<void> touch() async {}

  @override
  Future<void> setTitle(String? id) async {}

  @override
  Future<List<Notice>> notices() async => const [];

  @override
  Future<List<ServerDuel>> myDuels() async => const [];

  @override
  Future<Map<String, int>> myDays({int lastDays = 31}) async => const {};

  @override
  Future<int> unreadNotices() async => 0;

  @override
  Future<void> readNotices() async {}

  // Reading answers with "nothing"; anything that changes something on a
  // server throws, because a button that silently does nothing is worse
  // than one that says there is no server.
  @override
  Future<RemotePrefs> savePrefs(RemotePrefs prefs) =>
      throw StateError('no server configured');

  @override
  Future<void> removeFriend(String theirId) =>
      throw StateError('no server configured');

  @override
  Future<void> block(String theirId) =>
      throw StateError('no server configured');

  @override
  Future<void> unblock(String theirId) =>
      throw StateError('no server configured');

  @override
  Future<List<BlockedLifter>> blocked() async => const [];

  @override
  Future<void> mute(String theirId) => throw StateError('no server configured');

  @override
  Future<void> unmute(String theirId) =>
      throw StateError('no server configured');

  @override
  Future<List<MutedLifter>> muted() async => const [];

  @override
  Future<void> report({
    String? aboutId,
    required ReportReason reason,
    String details = '',
  }) => throw StateError('no server configured');

  @override
  Future<bool> usernameAvailable(String name) async => true;

  @override
  Future<SocialSignInResult> signInWithIdToken({
    required SocialProvider provider,
    required String idToken,
    String? accessToken,
    String? nonce,
  }) async => SocialSignInResult.failed;

  @override
  Future<RenameResult> renameUsername(String name) =>
      throw StateError('no server configured');

  /// No server: nothing to refuse it, and the caller keeps it on the phone.
  @override
  Future<CountryResult> setMyCountry(String code) async => CountryResult.ok;

  @override
  Future<List<int>> myAdventure() => throw StateError('no server configured');

  @override
  Future<List<int>> saveAdventure(List<int> stars) =>
      throw StateError('no server configured');

  @override
  Future<Map<String, dynamic>> myRewards() =>
      throw StateError('no server configured');

  @override
  Future<Map<String, dynamic>> saveRewards(Map<String, dynamic> state) =>
      throw StateError('no server configured');

  @override
  Future<String> uploadAvatar(
    Uint8List bytes, {
    String contentType = 'image/jpeg',
  }) => throw StateError('no server configured');

  @override
  Future<void> saveLifter(Map<String, Object> lifter) =>
      throw StateError('no server configured');

  @override
  Future<void> removeAvatar() => throw StateError('no server configured');

  @override
  bool get hasRealAccount => false;

  @override
  String? get accountEmail => null;

  @override
  Future<EmailSignUpResult> startEmailSignUp({required String email}) =>
      throw StateError('no server configured');

  @override
  Future<bool> verifyEmailCode({required String email, required String code}) =>
      throw StateError('no server configured');

  @override
  Future<void> resendEmailCode(String email) =>
      throw StateError('no server configured');

  @override
  Future<EmailLoginCodeResult> requestLoginCode(String email) =>
      throw StateError('no server configured');

  @override
  Future<bool> verifyLoginCode({required String email, required String code}) =>
      throw StateError('no server configured');

  @override
  Future<AccountSummary?> accountSummary() async => null;

  @override
  Future<Map<String, dynamic>> myData() =>
      throw StateError('no server configured');

  @override
  Future<void> emailMyData(String address) =>
      throw StateError('no server configured');

  @override
  Future<void> deleteAccount() => throw StateError('no server configured');

  @override
  Future<bool> signedInWithApple() async => false;

  @override
  Future<void> revokeAppleSignIn(String authorizationCode) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> syncSubscription() async {}

  /// Nobody to push from.
  @override
  Future<void> registerPushToken(
    String token, {
    required String platform,
    required String language,
  }) async {}

  @override
  Future<void> forgetPushToken(String token) async {}

  /// Nobody live without a server: the search goes straight to the fallback.
  @override
  Future<LiveMatch?> findLiveOpponent() async => null;

  @override
  Future<void> leaveLiveQueue() async {}

  @override
  Future<LiveOnline?> liveOnline() async => null;

  @override
  Future<String> inviteLive(String friendId) =>
      throw StateError('no server configured');

  @override
  Future<List<LiveInvite>> liveInvites() async => const [];

  @override
  Future<LiveStatus> answerLiveInvite(
    String matchId, {
    required bool accept,
  }) => throw StateError('no server configured');

  @override
  Future<void> cancelLiveInvite(String matchId) async {}

  @override
  Future<LiveRematch> rematchLive(String afterMatchId) =>
      throw StateError('no server configured');

  /// No server, no other phone to have left.
  @override
  Future<RematchPresence> liveResultPresence(
    String afterMatchId, {
    bool leaving = false,
  }) async => RematchPresence.here;

  @override
  Future<LiveState> liveState(String matchId) =>
      throw StateError('no server configured');

  @override
  Future<Duration?> liveReady(String matchId) =>
      throw StateError('no server configured');

  @override
  Future<void> reportLiveCount(String matchId, int reps) async {}

  @override
  Future<LiveFinish> finishLive(String matchId, SetUpload set) =>
      throw StateError('no server configured');

  @override
  Future<LiveFinish> liveResult(String matchId) =>
      throw StateError('no server configured');

  @override
  LiveLink openLiveLink(String matchId) =>
      throw StateError('no server configured');

  @override
  Future<ChallengeLink?> makeChallenge({String? setId}) async => null;

  @override
  Future<ChallengeLink?> challengeBest() async => null;

  @override
  Future<ChallengeView?> openChallenge(String code) async => null;

  @override
  Future<ChallengeView> takeChallenge(String code, String setId) =>
      throw StateError('no server configured');

  @override
  Future<ChallengeLink?> backChallenge(String takeId) async => null;

  @override
  Future<List<MyChallenge>> myChallenges() async => const [];

  @override
  Future<int> doubleDuelXp(String duelId) async => 0;

  @override
  Future<DateTime> startProTrial(String key, String id, String? was) async =>
      DateTime.now().add(const Duration(days: 1));

  @override
  Future<Map<String, dynamic>?> myPlan() async => null;

  @override
  Future<Map<String, dynamic>?> savePlan(Map<String, Object?>? plan) async =>
      plan == null ? null : Map<String, dynamic>.from(plan);

  @override
  Future<BestMinute?> myBestMinute(DateTime since, DateTime before) async =>
      null;
}

/// The one the app uses. Replaced at startup when keys are supplied.
Backend backend = const NoBackend();
