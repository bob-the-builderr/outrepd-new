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
    this.notifyFriendRequest = true,
    this.notifyFriendOk = true,
  });

  final Challengeable challengeable;
  final bool showOnBoard;
  final bool showCountry;
  final bool notifyRaced;
  final bool notifyFriendRequest;
  final bool notifyFriendOk;

  RemotePrefs copyWith({
    Challengeable? challengeable,
    bool? showOnBoard,
    bool? showCountry,
    bool? notifyRaced,
    bool? notifyFriendRequest,
    bool? notifyFriendOk,
  }) => RemotePrefs(
    challengeable: challengeable ?? this.challengeable,
    showOnBoard: showOnBoard ?? this.showOnBoard,
    showCountry: showCountry ?? this.showCountry,
    notifyRaced: notifyRaced ?? this.notifyRaced,
    notifyFriendRequest: notifyFriendRequest ?? this.notifyFriendRequest,
    notifyFriendOk: notifyFriendOk ?? this.notifyFriendOk,
  );

  /// How many of the notification switches are on, for the row that says so
  /// without making anybody open the screen.
  int get noticesOn =>
      (notifyRaced ? 1 : 0) +
      (notifyFriendRequest ? 1 : 0) +
      (notifyFriendOk ? 1 : 0);

  static const noticeCount = 3;
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
    this.usernameChangedAt,
    this.peakTierIdx = 0,
    this.wins = 0,
    this.losses = 0,
    this.winStreak = 0,
    this.bestStreak = 0,
    this.placementsDone = 0,
    this.placementWins = 0,
    this.totalReps = 0,
    this.bestSet = 0,
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;

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

  /// Null until this account has uploaded a photo. The drawn initial is the
  /// fallback everywhere this is shown, not a broken image.
  final String? avatarUrl;

  /// Null until this account has used its one username change. Not null
  /// means [Backend.renameUsername] will only ever answer
  /// [RenameResult.alreadyChanged] from here on.
  final DateTime? usernameChangedAt;

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
    DateTime? usernameChangedAt,
    int? peakTierIdx,
    int? wins,
    int? losses,
    int? winStreak,
    int? bestStreak,
    int? placementsDone,
    int? placementWins,
    int? totalReps,
    int? bestSet,
  }) => RemoteProfile(
    id: id,
    username: username ?? this.username,
    tierIdx: tierIdx ?? this.tierIdx,
    divIdx: divIdx ?? this.divIdx,
    lp: lp ?? this.lp,
    friendCode: friendCode,
    country: country ?? this.country,
    prefs: prefs ?? this.prefs,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    usernameChangedAt: usernameChangedAt ?? this.usernameChangedAt,
    peakTierIdx: peakTierIdx ?? this.peakTierIdx,
    wins: wins ?? this.wins,
    losses: losses ?? this.losses,
    winStreak: winStreak ?? this.winStreak,
    bestStreak: bestStreak ?? this.bestStreak,
    placementsDone: placementsDone ?? this.placementsDone,
    placementWins: placementWins ?? this.placementWins,
    totalReps: totalReps ?? this.totalReps,
    bestSet: bestSet ?? this.bestSet,
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
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;
  final int wins;
  final int losses;
  final String? avatarUrl;
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
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;

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
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
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
}

// ──────────────────────────────── live matches ────────────────────────────────

/// Who is on the other side of a live match.
class LiveOpponent {
  const LiveOpponent({
    required this.id,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
  });

  final String id;
  final String username;
  final int tierIdx;
  final int divIdx;
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
  /// with a friend is friendly and moves nothing.
  final bool ranked;
  final LiveOpponent opponent;
}

/// A friend's invite waiting on this account.
class LiveInvite {
  const LiveInvite({
    required this.matchId,
    required this.from,
    required this.expiresIn,
  });

  final String matchId;
  final LiveOpponent from;

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
enum RenameResult {
  ok,

  /// Somebody else already has it. Checked again on the server even though
  /// the rename screen already asked — the gap between the two is exactly
  /// long enough for that somebody else to have just taken it.
  taken,

  /// Too short, too long, empty, or not just letters and digits.
  invalid,

  /// This account already spent its one rename.
  alreadyChanged,

  /// A name the server refuses to show on a board: abuse, or one that would
  /// pass for the app itself.
  notAllowed,
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
  });

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
  });

  final String duelId;
  final bool won;
  final int lpDelta;
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
}

abstract interface class Backend {
  /// Whether there is a server at all. False means every screen that needs one
  /// should say so rather than spin.
  bool get available;

  /// Who is signed in, or null.
  RemoteProfile? get me;

  /// Signs in and makes sure a profile row exists.
  Future<RemoteProfile> signIn({required String username});

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

  /// How many of those have not been seen. What the dot on the bell counts.
  Future<int> unreadNotices();

  /// Marks them all seen, which is what opening the screen means.
  Future<void> readNotices();

  // ───────────────────────── settings and safety ──────────────────────────

  /// Changes one or more of the server-kept preferences, and returns what
  /// the account now holds.
  Future<RemotePrefs> savePrefs(RemotePrefs prefs);

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

  /// Uploads a new avatar photo and returns its public URL, already saved
  /// as this account's [RemoteProfile.avatarUrl].
  Future<String> uploadAvatar(Uint8List bytes);

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

  /// Leaves the account on the server as it is and forgets it on this
  /// phone. [me] is null afterwards; [signIn] starts a fresh one.
  Future<void> signOut();

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

  /// Asks a friend to go live now. Returns the match's id.
  Future<String> inviteLive(String friendId);

  /// Invites waiting on this account.
  Future<List<LiveInvite>> liveInvites();

  /// Yes or no to an invite; what the invite is now.
  Future<LiveStatus> answerLiveInvite(String matchId, {required bool accept});

  Future<void> cancelLiveInvite(String matchId);

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
  Future<RenameResult> renameUsername(String name) =>
      throw StateError('no server configured');

  @override
  Future<String> uploadAvatar(Uint8List bytes) =>
      throw StateError('no server configured');

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
  Future<void> signOut() async {}

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
}

/// The one the app uses. Replaced at startup when keys are supplied.
Backend backend = const NoBackend();
