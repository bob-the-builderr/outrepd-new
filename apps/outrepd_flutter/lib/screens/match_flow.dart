/// The duel, from tapping the button to seeing the result.
///
/// Four stages and no questions: search, meet the opponent, lift, see who won.
/// There used to be a fifth at the front where you picked three exercises out
/// of eighty, and a card of six alternating rounds built from the two players'
/// choices. The app counts push-ups. There is nothing to choose, so the
/// fastest route into a duel is the one with no screen in front of it.
library;

import 'dart:async';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../ads.dart';
import '../adventure/adventure.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../connection.dart';
import '../data.dart';
import '../face.dart';
import '../l10n/app_localizations.dart';
import '../live.dart';
import '../moments.dart';
import '../plan.dart';
import '../avatar.dart';
import '../lifter/lifter_view.dart';
import '../lifter/looks.dart';
import '../player_avatar.dart' show PhotoOrLifter, decodedAt;
import '../ranking.dart';
import '../reps/recording.dart';
import '../reps/pushup_counter.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';
import '../xp.dart';
import '../reps/count_accuracy.dart';
import '../review_prompt.dart';
import '../settings.dart';
import 'adventure_fight.dart';
import 'adventure_map.dart';
import 'challenge.dart';
import 'confirm_count.dart';
import 'daily_goal.dart';
import 'level.dart';
import 'vs_screen.dart';
import 'match_entry.dart';
import 'moments_view.dart';
import 'plan_screen.dart';
import 'post_match.dart';
import 'trainer.dart';
import 'vs_search.dart';

/// One bout, both lifters, same clock. Short enough that it is a sprint rather
/// than a test of endurance, and short enough to fit in a gym doorway.
const kDuelLength = Duration(seconds: 60);

class MatchFlowScreen extends StatefulWidget {
  /// What kind of duel this is. It decides two things that nothing else may
  /// decide: whether there is somebody on the other side, and whether the
  /// result is allowed to move the rank.
  final MatchMode mode;

  /// Who [MatchMode.challenge] and [MatchMode.challengeAccept] are with.
  /// Unused otherwise — matchmaking decides that for every other mode.
  final String? targetId;

  /// Shown before the camera. Only [MatchMode.challenge] needs these up
  /// front — [MatchMode.challengeAccept] fetches the real ones the moment it
  /// finds the reserved set, from a notification that never had them to give.
  final String? targetUsername;
  final int? targetTierIdx;
  final int? targetDivIdx;

  /// The friend's live match [MatchMode.liveFriend] was opened for, already
  /// accepted by both. Ranked live matches are found by the search instead.
  final LiveMatch? liveMatch;

  /// An adventure fight: practice, with this level's monster on the camera
  /// instead of a clock and a count, and its own ending.
  final AdventureLevel? adventure;

  /// The challenge [MatchMode.link] races, opened from its link.
  final ChallengeView? linkChallenge;

  /// Last week's you, whom [MatchMode.pastSelf] races.
  final PastSelf? pastSelf;

  /// A practice set that is one of the day's sets on the plan: counted onto
  /// it when it reaches the day's number.
  final bool planSet;

  const MatchFlowScreen({
    super.key,
    this.mode = MatchMode.ranked,
    this.targetId,
    this.targetUsername,
    this.targetTierIdx,
    this.targetDivIdx,
    this.liveMatch,
    this.adventure,
    this.linkChallenge,
    this.pastSelf,
    this.planSet = false,
  }) : assert(
         adventure == null || mode == MatchMode.practice,
         'an adventure fight is practice: it moves no rank',
       ),
       assert(
         mode != MatchMode.liveFriend || liveMatch != null,
         'a live match with a friend needs the match',
       ),
       assert(
         mode != MatchMode.challenge ||
             (targetId != null &&
                 targetUsername != null &&
                 targetTierIdx != null &&
                 targetDivIdx != null),
         'sending a challenge needs to know who it is with',
       ),
       assert(
         mode != MatchMode.challengeAccept || targetId != null,
         'accepting a challenge needs to know whose it is',
       ),
       assert(
         mode != MatchMode.link || linkChallenge != null,
         'a challenge by link needs the challenge',
       ),
       assert(
         mode != MatchMode.pastSelf || pastSelf != null,
         'racing last week\'s you needs last week\'s minute',
       );

  /// Nobody on the other side. The same clock and the same counting, with
  /// nothing at stake.
  bool get practice => mode == MatchMode.practice;

  /// Only a ranked duel moves the ladder.
  ///
  /// A friend room is a real opponent and a real result, and it is *not* a
  /// rung: a rank people can arrange between themselves is not a rank. The
  /// record follows the same line — a profile showing forty wins where thirty
  /// were arranged with a friend tells the same lie the LP would.
  ///
  /// A rematch is the same story a second time: `find_opponent_set` already
  /// refuses to pair two people who have already faced each other, so a
  /// rematch that moved the ladder would be the one way around that rule.
  bool get ranked => mode == MatchMode.ranked;

  /// Sending a fresh challenge at [targetId]. There is nobody to search for —
  /// the challenge does not exist until the set this lifter is about to
  /// record uploads naming them.
  bool get isChallenge => mode == MatchMode.challenge;

  /// Racing the set [targetId] reserved for this account with their own
  /// challenge.
  bool get isChallengeAccept => mode == MatchMode.challengeAccept;

  /// Live with a friend, from an accepted invite.
  bool get isLiveFriend => mode == MatchMode.liveFriend;

  /// Racing a challenge by link.
  bool get isLink => mode == MatchMode.link;

  /// The week's race against last week's you.
  bool get isPastSelf => mode == MatchMode.pastSelf;

  bool get isAdventure => adventure != null;

  @override
  State<MatchFlowScreen> createState() => _MatchFlowScreenState();
}

enum _Stage {
  searching,
  versus,
  live,

  /// The placement just put the account on the ladder: shown first, before
  /// anything else this session earned, because it is the bigger news.
  placed,

  /// Shown before the result when the duel moved the lifter up a division.
  /// It is the news; the breakdown behind it is the detail, and the detail
  /// reads better once the headline has landed.
  promoted,

  /// After the promotion, if there was one, and before the result: the
  /// session crossed a level. Once, here, and never again for that level.
  levelUp,

  result,

  /// [MatchMode.challenge] ends here instead of at [result] — reps landed,
  /// but nobody has raced them yet.
  sent,

  /// Live: this set is in, and the other phone's is not yet.
  waitingResult,

  /// A saved set raced: this set going to the server and the duel being
  /// settled there, before anything is shown.
  saving,

  /// Live: the other lifter never got into position. Nothing was recorded.
  calledOff,

  /// The server could not be reached to settle it — live, or a saved set.
  liveFailed,

  /// An adventure fight just earned the stars for a new weapon: shown once,
  /// after the level and before the result.
  weapon,

  /// A challenge by link: the try is in, and here is how it went.
  challengeResult,

  /// The week's race against last week's you, and the road so far.
  pastSelfResult,

  /// A new personal best or a milestone this match's set made, each on a
  /// screen of its own before the result (lib/moments.dart).
  moment,
}

class _MatchFlowScreenState extends State<MatchFlowScreen> {
  late _Stage _stage;

  // Seeded with this lifter in initState and overwritten in _search if a real
  // opponent is found. Never left unset: practice reaches _Stage.result too,
  // by way of _ResultView's constructor, without ever calling _search.
  late Opponent _opponent;

  /// [_opponent]'s face, as every screen draws it (face.dart).
  Face get _opponentFace => faceOf(
    id: _opponent.id,
    name: _opponent.username,
    avatarUrl: _opponent.avatarUrl,
  );

  /// Whether [_opponent] is somebody found rather than the stand-in the
  /// screen starts with: the search's seat lands on them once it is.
  bool _matched = false;
  late int _theirReps;

  /// Somebody else's actual stored set, when [_search] found one. Null means
  /// there was nobody real to race yet, or there is no server at all, and the
  /// round is raced against this lifter's own best instead — see [_vsBest].
  OpponentSet? _realOpponent;

  /// This lifter's best set when the round started: the number [_vsBest]
  /// races, and the one the result screen measures the new count against.
  int _bestBefore = 0;

  /// Whether the set reached the pool, where the next lifter near this rank
  /// can race it for real.
  bool _pooled = false;

  /// [MatchMode.challengeAccept] found no reserved set waiting — already
  /// raced, or the challenge was withdrawn. A real answer, not a "nobody's
  /// free yet" the way the open pool's silence is.
  bool _challengeGone = false;

  /// Whether [MatchMode.challenge]'s set actually reached the server. Shown
  /// on [_Stage.sent] instead of assumed, because there is no local fallback
  /// for "tell somebody else about this" the way an ordinary duel has one.
  bool _challengeSent = false;

  /// The challenge by link once this try is on it, from the server.
  ChallengeView? _linkAfter;

  int _myReps = 0;

  /// When each of this lifter's reps landed, for the result's race chart.
  List<int> _myRepTimes = const [];
  Timer? _timer;

  /// Once the result has been on screen a moment: the rating prompt, when
  /// this was a good moment for it (ReviewPrompt).
  Timer? _ratingTimer;

  /// What the duel did to the account, once it has been recorded.
  DuelOutcome? _outcome;

  /// What the session added to the level, once it has been recorded.
  XpGain? _xp;

  /// The weapon an adventure fight is fought with: the best unlocked when it
  /// started, so stars earned by this fight arm the next one, not this one.
  final Weapon _weapon = Adventure.instance.weapon;

  /// How the adventure fight went, once the camera has handed back its count.
  FightOutcome? _fight;

  /// The weapon that fight unlocked, if it unlocked one.
  Weapon? _unlocked;

  /// The live match, when there is one: found by the ranked search, or the
  /// friend's invite or rematch this screen was opened for.
  LiveMatch? _live;

  /// This account's place on the month's board before the duel and after
  /// it, for the result screen's "#14 → #11". Null when not known.
  MonthPlace? _weekBefore;
  MonthPlace? _weekAfter;
  LiveSession? _session;

  /// How long the ranked search looks for somebody live before it races a
  /// saved set instead.
  static const liveSearchFor = Duration(seconds: 15);

  /// When the live search began, for the ring on the search screen. Null
  /// when this search is not looking for anybody live.
  DateTime? _liveSearchFrom;

  /// Whether this search went looking for somebody live at all: fifteen
  /// seconds were spent, so what it found goes up without another wait.
  bool _searchedLive = false;

  /// Left while still looking, so the queue is left too.
  bool _searchCancelled = false;

  /// Who the VS screen faces this account with: the lifter on camera, the one
  /// whose saved set this is, or the one a rematch is with. Null when the
  /// round races this lifter's own best — there is nobody to face, and the
  /// plain versus view says whose best it is.
  String? get _vsOpponentId =>
      _live?.opponent.id ??
      _realOpponent?.profileId ??
      (widget.isChallenge ? widget.targetId : null) ??
      widget.linkChallenge?.owner.id ??
      (widget.isPastSelf ? (backend.me?.id ?? 'me') : null);

  /// Nobody real was found, so the round is raced against this lifter's own
  /// best set and moves nothing on the ladder.
  ///
  /// There used to be a stand-in here: a made-up name and a random count,
  /// with the rank moved on this phone only, until the next launch put the
  /// server's rank back. An opponent who does not exist and a result that
  /// quietly disappears are both lies, and the store listing promises real
  /// people. The set still goes into the pool, so the next lifter near this
  /// rank races it for real and both ranks move then, on the server.
  ///
  /// A challenge is never this: either the named target's set turns up, or
  /// the screen says outright that it did not.
  bool get _vsBest =>
      !widget.practice &&
      _realOpponent == null &&
      _live == null &&
      !widget.isLiveFriend &&
      !widget.isChallenge &&
      !widget.isChallengeAccept &&
      !widget.isLink &&
      !widget.isPastSelf;

  @override
  void initState() {
    super.initState();
    Moments.instance.clear();
    final me = demoProfile;
    _opponent = Opponent(me.username, me.tierIdx, me.divIdx);
    _theirReps = 0;

    _stage = widget.practice ? _Stage.live : _Stage.searching;
    if (!widget.practice) {
      unawaited(_readWeekPlace().then((place) => _weekBefore = place));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.practice) {
        _lift();
      } else {
        _search();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ratingTimer?.cancel();
    // Gone mid-search: out of the queue, so nobody is paired with a lifter
    // who has already left.
    if (_liveSearchFrom != null && _live == null && !_searchCancelled) {
      _searchCancelled = true;
      unawaited(
        backend.leaveLiveQueue().catchError(
          (Object error) => debugPrint('Could not leave the queue: $error'),
        ),
      );
    }
    _session?.dispose();
    // Left before the result came, or without one: the server settles it
    // regardless, and the history picks it up from there.
    // ([_Stage.liveFailed] already asked, when it was reached.)
    if (_stage == _Stage.waitingResult || _stage == _Stage.saving) {
      Career.instance.syncHistorySoon();
    }
    super.dispose();
  }

  /// One step at a time for up to [liveSearchFor]: the live match once
  /// somebody is found, or null — and out of the queue — once nobody was.
  Future<LiveMatch?> _searchLive() async {
    _searchedLive = true;
    final from = clock.now();
    setState(() => _liveSearchFrom = from);
    final until = from.add(liveSearchFor);
    while (mounted && !_searchCancelled && clock.now().isBefore(until)) {
      try {
        final found = await backend.findLiveOpponent();
        if (found != null) return found;
      } on Object catch (error) {
        debugPrint('Could not look for a live opponent: $error');
      }
      await Future<void>.delayed(const Duration(milliseconds: 1500));
    }
    if (!_searchCancelled) {
      _searchCancelled = true;
      try {
        await backend.leaveLiveQueue();
      } on Object catch (error) {
        debugPrint('Could not leave the queue: $error');
      }
    }
    return null;
  }

  bool get _won =>
      widget.practice || (_outcome?.won ?? (_myReps >= _theirReps));

  Future<void> _search() async {
    _timer?.cancel();
    _matched = false;

    // A friend's live match: both already said yes, so there is nobody to
    // look for — straight to meeting them.
    if (widget.liveMatch case final match? when widget.isLiveFriend) {
      setState(() {
        _live = match;
        _opponent = Opponent(
          match.opponent.username,
          match.opponent.tierIdx,
          match.opponent.divIdx,
          avatarUrl: match.opponent.avatarUrl,
          xp: match.opponent.xp,
          id: match.opponent.id,
        );
        _theirReps = 0;
      });
      _goVersus();
      return;
    }

    // A challenge by link: the owner's minute came with the link, so there
    // is nobody to look for — straight to meeting them.
    if (widget.linkChallenge case final challenge? when widget.isLink) {
      final owner = challenge.owner;
      setState(() {
        _opponent = Opponent(
          owner.username,
          owner.tierIdx,
          owner.divIdx,
          avatarUrl: owner.avatarUrl,
          xp: owner.xp,
          id: owner.id,
        );
        _theirReps = challenge.reps;
      });
      _goVersus();
      return;
    }

    // Last week's you: the minute came with the plan, so there is nobody to
    // look for either — this lifter, across from themself.
    if (widget.pastSelf case final past? when widget.isPastSelf) {
      final me = demoProfile;
      setState(() {
        _opponent = Opponent(
          me.username,
          me.tierIdx,
          me.divIdx,
          xp: me.xp,
          id: backend.me?.id ?? '',
        );
        _theirReps = past.reps;
      });
      _goVersus();
      return;
    }

    // Sending a challenge: there is nobody to look for. The point of this
    // mode is that it does not exist on the other end until the set about to
    // be recorded uploads naming them, so the opponent shown is simply who
    // this screen was told it is with.
    if (widget.isChallenge) {
      setState(() {
        _opponent = Opponent(
          widget.targetUsername!,
          widget.targetTierIdx!,
          widget.targetDivIdx!,
          id: widget.targetId ?? '',
        );
        _theirReps = 0;
      });
      _goVersus();
      return;
    }

    // Accepting a challenge: not the open pool, one specific reserved set.
    // Missing is a real answer here — already raced, or the challenge was
    // withdrawn — not a "nobody's free yet" that a local stand-in can paper
    // over the way the open pool's silence can.
    if (widget.isChallengeAccept) {
      try {
        final found = await backend.findTargetedOpponent(widget.targetId!);
        if (!mounted) return;
        if (found == null) {
          setState(() => _challengeGone = true);
          return;
        }
        setState(() {
          _realOpponent = found;
          _opponent = Opponent(
            found.username,
            found.tierIdx,
            found.divIdx,
            avatarUrl: found.avatarUrl,
            xp: found.xp,
            id: found.profileId,
          );
          _theirReps = found.reps;
        });
      } on Object catch (error) {
        debugPrint('Could not reach the server for the challenge: $error');
        if (!mounted) return;
        setState(() => _challengeGone = true);
        return;
      }
      _goVersus();
      return;
    }

    // A real stored set, if there is a server, this account is signed in,
    // and somebody near this level has left one unraced. Any of those being
    // untrue is not an error — it is most launches today, before the pool of
    // stored sets has anybody in it — so it falls back to the local stand-in
    // exactly as this screen always has.
    if (backend.available && backend.me != null) {
      // Ranked looks for somebody live first: two people on camera at once
      // is the match. Fifteen seconds, then a saved set, so the button
      // always ends in a match whoever else is around.
      if (widget.ranked) {
        final live = await _searchLive();
        if (!mounted) return;
        if (live != null) {
          setState(() {
            _live = live;
            _opponent = Opponent(
              live.opponent.username,
              live.opponent.tierIdx,
              live.opponent.divIdx,
              avatarUrl: live.opponent.avatarUrl,
              xp: live.opponent.xp,
              id: live.opponent.id,
            );
            _theirReps = 0;
          });
          _goVersus(quick: true);
          return;
        }
      }
      try {
        final found = await backend.findOpponent();
        if (found != null && mounted) {
          setState(() {
            _realOpponent = found;
            _opponent = Opponent(
            found.username,
            found.tierIdx,
            found.divIdx,
            avatarUrl: found.avatarUrl,
            xp: found.xp,
            id: found.profileId,
          );
            _theirReps = found.reps;
          });
        }
      } on Object catch (error) {
        debugPrint('Could not reach the server for an opponent: $error');
      }
    }
    if (!mounted) return;
    if (_realOpponent == null) {
      _bestBefore = demoProfile.bestSet;
      _theirReps = _bestBefore;
    }
    // Fifteen seconds and nobody live: straight on to the saved set, its VS
    // screen saying it is one (the user, 2026-11-04: the screen between,
    // with its own button to race it, went).
    _goVersus(quick: _searchedLive);
  }

  /// The countdown from "found somebody" to "on camera", shared by every mode
  /// that reaches it.
  void _goVersus({bool quick = false}) {
    // Found: the seat on the search screen slows and lands on them while
    // the wait below runs. Not when the round races this lifter's own best:
    // nobody was found, and the seat keeps looking until the VS screen says
    // whose best it is.
    if (mounted && !_vsBest) setState(() => _matched = true);
    // How the other lifter looks, for the VS screen: asked now, drawn when
    // it arrives.
    if (_vsOpponentId case final id?) unawaited(Looks.instance.fetch([id]));
    // A challenge already knows exactly who it is with — there is nothing to
    // search for, so nothing to fake the look of searching for either.
    // Everyone else gets a wait somewhere inside the window the design
    // allows, so it never feels scripted whether what was found is a real
    // set or the stand-in seeded in initState. A live opponent is waiting on
    // the other phone, and a search that already ran its fifteen seconds has
    // been seen to be real.
    final wait =
        (quick ||
            widget.isChallenge ||
            widget.isChallengeAccept ||
            widget.isLiveFriend ||
            widget.isLink ||
            widget.isPastSelf)
        ? const Duration(milliseconds: 600)
        : Duration(milliseconds: 2200 + Random().nextInt(3400));
    _timer = Timer(wait, () {
      if (!mounted) return;
      setState(() => _stage = _Stage.versus);
      // The VS screen counts its three seconds down at its foot, so it gets
      // all three; racing your own best, the plain one, a second and a half.
      _timer = Timer(_vsOpponentId == null ? const Duration(milliseconds: 1500) : kVsTime, () {
        if (!mounted) return;
        setState(() => _stage = _Stage.live);
        _lift();
      });
    });
  }

  /// Hands over to the camera, and takes back a count the lifter has agreed to.
  Future<void> _lift() async {
    if (_live case final live?) {
      await _liftLive(live);
      return;
    }
    final scored = await Navigator.of(context).push<PushupCount>(
      MaterialPageRoute(
        builder: (_) => TrainerScreen(
          autoStart: true,
          forMatch: true,
          limit: widget.adventure?.time ?? kDuelLength,
          game: switch (widget.adventure) {
            final level? => FightGame(level: level, weapon: _weapon),
            null => null,
          },
          // Practice has nobody on the other side, so the camera shows a
          // clock and a count and nothing else. Sending a challenge is the
          // same: there is no pace to race yet, because the other half of
          // this duel has not been lifted.
          //
          // Racing your own best is a pace like any other, except on a very
          // first round, when there is no best yet and only the clock.
          duel:
              (widget.practice ||
                  widget.isChallenge ||
                  (_vsBest && _theirReps == 0))
              ? null
              : DuelContext(
                  opponentName: widget.isPastSelf
                      ? L.of(context).planLastWeeksYou
                      : _vsBest
                      ? L.of(context).yourBest
                      : _opponent.username,
                  opponentReps: _theirReps,
                  opponentRepTimes:
                      _realOpponent?.repTimes ??
                      widget.linkChallenge?.repTimes ??
                      widget.pastSelf?.repTimes ??
                      const [],
                  opponentTierIdx: _opponent.tierIdx,
                  opponentDivIdx: _opponent.divIdx,
                  // Racing your own best: your own picture across from you.
                  opponentImage: _vsBest || widget.isPastSelf
                      ? avatar.picture
                      : imageOf(_opponentFace),
                  opponentXp: _vsBest || widget.isPastSelf
                      ? demoProfile.xp
                      : _opponent.xp,
                  rankLabel: widget.isLink || widget.isPastSelf
                      ? L.of(context).friendlyNoRank
                      : tierLabel(
                          L.of(context),
                          demoProfile.tierIdx,
                          demoProfile.divIdx,
                        ),
                ),
        ),
      ),
    );
    if (!mounted) return;

    // A match settles on the camera's own count, unedited — a number a
    // ranked result rides on cannot also be a number the lifter is free to
    // raise. Practice is the one place this is still asked: nothing is at
    // stake to protect, and it is where the gap between what the camera saw
    // and what actually happened is worth measuring at all.
    final int settled;
    // An adventure fight is judged on the camera's count like a match: the
    // monster went down on the reps it saw, and a number edited afterwards
    // would be a fight won on paper.
    if (widget.practice && !widget.isAdventure) {
      final agreed = await confirmCount(
        context,
        counted: scored?.reps ?? 0,
        unverified: !(scored?.confident ?? false),
      );
      if (!mounted) return;

      settled = agreed ?? scored?.reps ?? 0;
      recordCountCorrection(camera: scored?.reps ?? 0, lifter: settled);

      // And onto the recording itself. A saved session with no known count is
      // a minute of joint positions and no answer — which is what every
      // recording used to be, because the camera closed before anybody had
      // said what the real number was.
      if (scored?.recordingPath case final path?) {
        await labelRecording(path, settled);
      }
    } else {
      settled = scored?.reps ?? 0;
    }

    // A challenge by link is its own ending too: the set goes up and onto the
    // challenge as this account's one try.
    if (widget.linkChallenge case final challenge? when widget.isLink) {
      await _takeLink(challenge, scored, settled);
      return;
    }

    // The week's race: kept on the plan, the set stored as practice so it
    // can be next week's you.
    if (widget.pastSelf case final past? when widget.isPastSelf) {
      await _racePast(past, scored, settled);
      return;
    }

    // Sending a challenge is its own ending: the set is uploaded naming the
    // target rather than settled against anyone, because nobody has raced it
    // yet. There is no local fallback for "tell somebody else about this",
    // so whether the upload actually reached the server is tracked rather
    // than swallowed.
    if (widget.isChallenge) {
      var challengeSent = false;
      if (backend.available && backend.me != null && scored != null) {
        try {
          await backend.uploadSet(
            SetUpload(
              reps: settled,
              repsCamera: scored.reps,
              depth: scored.depth,
              confident: scored.confident,
              durationMs: scored.durationMs,
              gaveUp: scored.gaveUp,
              repTimes: scored.repTimes,
              challengeTarget: widget.targetId,
            ),
          );
          challengeSent = true;
        } on Object catch (error) {
          debugPrint('Could not reach the server to record this set: $error');
        }
      }
      if (!mounted) return;
      // Reps landed, but there is no win or loss yet — that waits for the
      // other half, raced from their notification. A separate, honest screen
      // rather than a made-up result: with nobody real to compare against,
      // "you won" would be a promise this account cannot keep for them.
      setState(() {
        _myReps = settled;
        _challengeSent = challengeSent;
        _stage = _Stage.sent;
      });
      return;
    }

    // The fight's verdict and its stars, written down before anything is
    // shown — the same rule as a duel's result.
    if (widget.adventure case final level?) {
      final gaveUp = scored?.gaveUp ?? true;
      final usedMs = scored?.durationMs ?? level.time.inMilliseconds;
      final fight = FightOutcome(
        level: level,
        weapon: _weapon,
        // Walking out leaves the monster standing whatever was counted.
        reps: gaveUp ? 0 : settled,
        timeLeft: gaveUp
            ? Duration.zero
            : level.time - Duration(milliseconds: usedMs),
        starsBefore: Adventure.instance.starsAt(level.number),
      );
      _fight = fight;
      if (fight.won) {
        _unlocked = await Adventure.instance.record(level.number, fight.stars);
      }
      if (!mounted) return;
    }

    await _settleAndRecord(
      reps: settled,
      // A camera that came back with no count at all was walked away from.
      gaveUp: scored?.gaveUp ?? true,
      // Against a real set it still goes onto the server, as the loss
      // walking away is — the same as backing out before the camera
      // ([_forfeit]); a local result the server never heard of is a rank on
      // this phone that the next launch takes back. With nobody real, a
      // session with no count has nothing to upload.
      attempted: scored != null || _realOpponent != null,
      repsCamera: scored?.reps ?? 0,
      depth: scored?.depth ?? 0,
      confident: scored?.confident ?? false,
      durationMs: scored?.durationMs ?? 1,
      repTimes: scored?.repTimes ?? const [],
    );
  }

  /// The week's race against last week's you: the set up as practice, so
  /// next week races it in turn, then onto the plan and recorded like any
  /// practice minute. The race is the plan's, not the server's: a set that
  /// could not be stored still counts on this phone. Walked out before the
  /// round began: nothing was lifted, and the screen simply closes.
  Future<void> _racePast(PastSelf past, PushupCount? scored, int reps) async {
    if (scored == null) {
      Navigator.of(context).pop();
      return;
    }
    _myRepTimes = scored.repTimes;
    setState(() => _stage = _Stage.saving);
    if (backend.available && backend.me != null) {
      for (var attempt = 0; attempt < 3 && mounted; attempt++) {
        if (attempt > 0) {
          await Future<void>.delayed(Duration(seconds: 2 * attempt));
          if (!mounted) return;
        }
        try {
          await backend.uploadSet(
            SetUpload(
              reps: reps,
              repsCamera: scored.reps,
              depth: scored.depth,
              confident: scored.confident,
              durationMs: scored.durationMs,
              gaveUp: scored.gaveUp,
              repTimes: scored.repTimes,
              practice: true,
            ),
          );
          break;
        } on Object catch (error) {
          debugPrint('Could not store the race against last week: $error');
        }
      }
    }
    if (!mounted) return;
    await trainingPlan.recordRace(reps);
    final xpBefore = demoProfile.xp;
    await Career.instance.recordPractice(
      reps,
      clean: scored.depth >= kCleanDepth,
    );
    final gain = XpGain(before: xpBefore, after: demoProfile.xp, reps: reps);
    _xp = gain.total > 0 ? gain : null;
    if (!mounted) return;
    setState(() {
      _myReps = reps;
      _theirReps = past.reps;
      _stage = _withMoments(_Stage.pastSelfResult);
    });
  }

  /// A try at a challenge by link: the set up as practice — friendly, and
  /// never offered to the open pool — and onto the challenge, tried again
  /// for a while as a duel's set is, then the reps recorded like any
  /// practice minute's. Walked out before the round began: nothing was
  /// lifted, so the one try is still there and the screen simply closes.
  Future<void> _takeLink(
    ChallengeView challenge,
    PushupCount? scored,
    int reps,
  ) async {
    if (scored == null) {
      Navigator.of(context).pop();
      return;
    }
    _myRepTimes = scored.repTimes;
    setState(() => _stage = _Stage.saving);
    String? setId;
    ChallengeView? after;
    for (var attempt = 0; attempt < 4 && mounted; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(Duration(seconds: 3 * attempt));
        if (!mounted) return;
      }
      try {
        setId ??= await backend.uploadSet(
          SetUpload(
            reps: reps,
            repsCamera: scored.reps,
            depth: scored.depth,
            confident: scored.confident,
            durationMs: scored.durationMs,
            gaveUp: scored.gaveUp,
            repTimes: scored.repTimes,
            practice: true,
          ),
        );
        after = await backend.takeChallenge(challenge.code, setId);
        break;
      } on Object catch (error) {
        debugPrint('Could not put the try on the challenge: $error');
      }
    }
    if (!mounted) return;
    if (after == null) {
      setState(() => _stage = _Stage.liveFailed);
      return;
    }
    final xpBefore = demoProfile.xp;
    await Career.instance.recordPractice(
      reps,
      clean: scored.depth >= kCleanDepth,
    );
    final gain = XpGain(before: xpBefore, after: demoProfile.xp, reps: reps);
    _xp = gain.total > 0 ? gain : null;
    if (!mounted) return;
    setState(() {
      _myReps = reps;
      _theirReps = challenge.reps;
      _linkAfter = after;
      _stage = _withMoments(_Stage.challengeResult);
    });
  }

  /// Uploads the set, settles it against a real opponent if there is one,
  /// and records the result. Shared by a round finishing on camera and by
  /// [_forfeit] giving one up before it ever reached the camera — both end
  /// the same way, a set that either raced somebody or is stored to wait.
  Future<void> _settleAndRecord({
    required int reps,
    required bool gaveUp,
    bool attempted = true,
    int repsCamera = 0,
    double depth = 0,
    bool confident = false,
    int durationMs = 1,
    List<int> repTimes = const [],
  }) async {
    _myRepTimes = repTimes;
    // Onto the server, if there is one to reach: the set is stored regardless
    // of whether today's opponent was real, so whoever searches next finds
    // one. Raced against a real opponent, the upload is also this lifter's
    // half of the duel — `settle_duel` reads everything it decides from the
    // two rows, so the set has to exist before the result can.
    //
    // A set with nobody real against it is never held up by a dropped
    // connection: it is practice either way. A duel against a real set is
    // tried again for a while — a dropped request is the usual reason it
    // fails — and never stood in for with a result worked out here: the
    // server is the one that moves both ranks, and a result it never settled
    // would be a rank on this phone that the next launch takes back.
    SettledDuel? settledDuel;
    var unsettled = false;
    // Practice goes up too, when it counted anything: never to be raced,
    // but its reps are on the profile and in the level like any others.
    if (attempted &&
        (!widget.practice || reps > 0) &&
        backend.available &&
        backend.me != null) {
      final opponentSet = _realOpponent;
      if (opponentSet != null) setState(() => _stage = _Stage.saving);
      String? mySetId;
      // Waits of 3, 6 and 9 seconds: past the 8 the server keeps between
      // one lifter's sets, should the first upload have landed unanswered.
      final tries = opponentSet == null ? 1 : 4;
      for (var attempt = 0; attempt < tries && mounted; attempt++) {
        if (attempt > 0) {
          await Future<void>.delayed(Duration(seconds: 3 * attempt));
          if (!mounted) return;
        }
        try {
          final setId = mySetId ??= await backend.uploadSet(
            SetUpload(
              reps: reps,
              repsCamera: repsCamera,
              depth: depth,
              confident: confident,
              durationMs: durationMs,
              gaveUp: gaveUp,
              repTimes: repTimes,
              practice: widget.practice,
            ),
          );
          _pooled = _vsBest;
          if (opponentSet != null) {
            settledDuel = await backend.settle(
              mySetId: setId,
              theirSetId: opponentSet.setId,
              ranked: widget.ranked,
            );
          }
          break;
        } on Object catch (error) {
          debugPrint('Could not reach the server to record this set: $error');
        }
      }
      unsettled = opponentSet != null && settledDuel == null;
    }
    if (!mounted) return;

    // Not settled, as far as this phone heard. The answer may only have been
    // lost on the way back, so the history asks the server again shortly.
    if (unsettled) {
      setState(() => _stage = _Stage.liveFailed);
      Career.instance.syncHistorySoon();
      return;
    }

    // Written down before the result is shown, so what the screen reports and
    // what the account holds are the same thing. Showing first and saving
    // afterwards is how a duel ends with a win on screen and nothing in the
    // history behind it.
    final xpBefore = demoProfile.xp;
    if (widget.practice || _vsBest) {
      await Career.instance.recordPractice(reps, clean: depth >= kCleanDepth);
      // One of the day's sets on the plan, when it reached the number.
      if (widget.planSet) await trainingPlan.recordSet(reps);
    } else if (settledDuel case final settledResult?) {
      // A real opponent, settled by the server. Nothing here is guessed —
      // see recordSettledDuel for why.
      _outcome = await Career.instance.recordSettledDuel(
        settled: settledResult,
        yourReps: reps,
        theirReps: _theirReps,
        opponent: _opponent.username,
        opponentTier: _opponent.tierIdx,
        ranked: widget.ranked,
        clean: depth >= kCleanDepth,
      );
    } else {
      _outcome = await Career.instance.recordDuel(
        yourReps: reps,
        theirReps: _theirReps,
        opponent: _opponent.username,
        opponentTier: _opponent.tierIdx,
        // Walking out mid-round — or never reaching it at all — is a loss
        // whatever the count said.
        surrendered: gaveUp,
        // A friend room is a real duel and not a rung on the ladder.
        ranked: widget.ranked,
        // Depth held against the lifter's own deepest rep. Not a judgement of
        // their technique — the camera cannot make one — but it can see
        // whether the reps got shallower as the minute wore on.
        clean: depth >= kCleanDepth,
      );
    }
    final gain = XpGain(before: xpBefore, after: demoProfile.xp, reps: reps);
    // A lost match pays no experience, and the result does not dwell on it.
    _xp = gain.total > 0 ? gain : null;
    if (!mounted) return;

    setState(() {
      _myReps = reps;
      // A promotion is announced on its own screen first.
      _stage = _afterRecorded;
    });
    unawaited(_afterWeekPlace());
  }

  /// Both on camera at once. The other lifter's count comes from their phone
  /// while the round runs; at the end both sets go to the server, which
  /// settles them exactly as it settles any duel.
  Future<void> _liftLive(LiveMatch live) async {
    final session = LiveSession(live);
    _session = session;
    final l = L.of(context);

    final scored = await Navigator.of(context).push<PushupCount>(
      MaterialPageRoute(
        builder: (_) => TrainerScreen(
          autoStart: true,
          forMatch: true,
          limit: kDuelLength,
          live: session,
          duel: DuelContext(
            opponentName: _opponent.username,
            opponentReps: 0,
            opponentTierIdx: _opponent.tierIdx,
            opponentDivIdx: _opponent.divIdx,
            opponentImage: imageOf(_opponentFace),
            opponentXp: _opponent.xp,
            rankLabel: live.ranked
                ? tierLabel(l, demoProfile.tierIdx, demoProfile.divIdx)
                : l.friendlyNoRank,
          ),
        ),
      ),
    );
    final theirs = session.opponentReps;
    await session.close();
    if (!mounted) return;

    // The other lifter never got into position, or this one left before the
    // round began: nothing was lifted, so nothing is recorded.
    if (session.calledOff || scored == null || session.startedAt == null) {
      setState(() => _stage = _Stage.calledOff);
      return;
    }

    setState(() {
      _myReps = scored.reps;
      _myRepTimes = scored.repTimes;
      _theirReps = theirs;
      _stage = _Stage.waitingResult;
    });

    final set = SetUpload(
      reps: scored.reps,
      repsCamera: scored.reps,
      depth: scored.depth,
      confident: scored.confident,
      durationMs: scored.durationMs,
      gaveUp: scored.gaveUp,
      repTimes: scored.repTimes,
    );

    // The set, sent until it lands; then the result, asked for until the
    // other set is in. The server settles a phone that vanished on its last
    // reported count once it is long overdue, so this ends either way.
    LiveFinish? finish;
    var sent = false;
    final giveUpAt = clock.now().add(const Duration(minutes: 3));
    while (mounted && clock.now().isBefore(giveUpAt)) {
      try {
        finish = sent
            ? await backend.liveResult(live.id)
            : await backend.finishLive(live.id, set);
        sent = true;
        if (finish.done) break;
      } on Object catch (error) {
        debugPrint('Could not settle the live match yet: $error');
      }
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    if (!mounted) return;

    final settled = finish?.settled;
    if (settled == null) {
      setState(() => _stage = _Stage.liveFailed);
      // The server settles it on the last count it heard once the round is
      // long overdue; the history takes it from there.
      Career.instance.syncHistorySoon();
      return;
    }
    _theirReps = finish?.theirReps ?? theirs;
    final xpBefore = demoProfile.xp;
    _outcome = await Career.instance.recordSettledDuel(
      settled: settled,
      yourReps: scored.reps,
      theirReps: _theirReps,
      opponent: _opponent.username,
      opponentTier: _opponent.tierIdx,
      ranked: live.ranked,
      clean: scored.depth >= kCleanDepth,
    );
    final gain = XpGain(
      before: xpBefore,
      after: demoProfile.xp,
      reps: scored.reps,
    );
    _xp = gain.total > 0 ? gain : null;
    if (!mounted) return;
    setState(() => _stage = _afterRecorded);
    unawaited(_afterWeekPlace());
  }

  /// A win, a new level or a new best, with the result in front of them: the
  /// moment to ask for a rating, if it has not been asked lately.
  void _askForRating() {
    if (!mounted || _stage != _Stage.result) return;
    final won = !widget.practice && !_vsBest && _won;
    final best = _outcome?.newBest ?? (_vsBest && _myReps > _bestBefore);
    unawaited(
      ReviewPrompt.maybeAsk(
        goodMoment: won || best || (_xp?.leveledUp ?? false),
        matchesPlayed: demoProfile.totalMatches,
      ),
    );
  }

  /// What follows a recorded session: the placement or the promotion, then
  /// the level, then the result — each news before the detail behind it.
  _Stage get _afterRecorded => (_outcome?.placementsFinished ?? false)
      ? _Stage.placed
      : (_outcome?.rank?.promoted ?? false)
      ? _Stage.promoted
      : _afterPromotion;

  _Stage get _afterPromotion =>
      (_xp?.leveledUp ?? false) ? _Stage.levelUp : _afterLevel;

  /// After the level: a weapon the fight unlocked, then the result.
  _Stage get _afterLevel =>
      _unlocked != null ? _Stage.weapon : _withMoments(_Stage.result);

  /// Where the moments go on to once they have all been seen.
  _Stage _afterMoment = _Stage.result;

  /// [next], or first whatever moments this match's set made.
  _Stage _withMoments(_Stage next) {
    if (Moments.instance.next == null) return next;
    _afterMoment = next;
    return _Stage.moment;
  }

  /// Where this account stands on the week's board, or null when there is
  /// no answer: read before the duel and after it, so the result can say
  /// what it added and where it moved you. Only ranked duels move it.
  Future<MonthPlace?> _readWeekPlace() async {
    if (!backend.available || backend.me == null) return null;
    try {
      return await backend.myWeekPlace();
    } on Object catch (error) {
      debugPrint('Could not read the week place: $error');
      return null;
    }
  }

  Future<void> _afterWeekPlace() async {
    if (_outcome?.rank == null) return;
    final place = await _readWeekPlace();
    if (mounted && place != null) setState(() => _weekAfter = place);
  }

  /// Backing out before the camera ever opened — [_confirmQuit] below. No
  /// reps landed, but the rule is the one the camera's own "give up" already
  /// enforces mid-round: walking away is a loss whatever the count says, and
  /// a real account on the other end of a real set is owed the win it pays.
  Future<void> _forfeit() async {
    _timer?.cancel();
    await _settleAndRecord(reps: 0, gaveUp: true);
  }

  /// Whether this screen's game is over: its result, the screens on the way
  /// to it, or the set in and on its way to the server — which settles it
  /// whether or not this screen waits to see it, the history taking it from
  /// there (dispose).
  bool get _gameOver => switch (_stage) {
    _Stage.result ||
    _Stage.placed ||
    _Stage.promoted ||
    _Stage.levelUp ||
    _Stage.weapon ||
    _Stage.sent ||
    _Stage.challengeResult ||
    _Stage.pastSelfResult ||
    _Stage.moment ||
    _Stage.waitingResult ||
    _Stage.saving => true,
    _ => false,
  };

  bool _leaving = false;

  /// Leaves a finished game: its ad first (lib/ads.dart), then [go]. With
  /// [rematch] when [go] is a rematch with the same person, which counts the
  /// game but keeps the ad for when one of them leaves.
  Future<void> _leave(VoidCallback go, {bool rematch = false}) async {
    if (_leaving) return;
    _leaving = true;
    await Ads.instance.afterGame(context, rematch: rematch);
    if (mounted) go();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Leaving mid-match would silently forfeit, so confirm first. A
      // finished game is left through [_leave], the back gesture too, so its
      // ad comes before whatever is underneath. Called off, failed or gone,
      // there was no game to leave.
      canPop:
          !_gameOver &&
          (_stage == _Stage.calledOff ||
              _stage == _Stage.liveFailed ||
              _challengeGone),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_gameOver) {
          _leave(() => Navigator.of(context).pop());
        } else {
          _confirmQuit();
        }
      },
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: ListenableBuilder(
            listenable: Connection.instance,
            builder: (context, _) => _buildStage(),
          ),
        ),
      ),
    );
  }

  Widget _buildStage() {
    switch (_stage) {
      case _Stage.searching:
        // A withdrawn or already-raced challenge. Nothing to retry: the
        // set this screen was sent to find is simply not there any more.
        if (_challengeGone) {
          return BlockingNotice(
            icon: Icons.search_off,
            title: L.of(context).challengeGoneTitle,
            body: L.of(context).challengeGoneBody,
            actionLabel: L.of(context).backToHome,
            onAction: () => Navigator.of(context).pop(),
          );
        }
        // Searching is the first thing that needs a server, so it is the first
        // thing that can fail this way. Blocking here rather than at the
        // button means somebody whose connection drops while the search spins
        // is told, instead of watching it spin forever.
        if (!Connection.instance.online) {
          return BlockingNotice(
            icon: Icons.wifi_off,
            title: L.of(context).noConnection,
            body: L.of(context).noConnectionBody,
            actionLabel: L.of(context).retry,
            onAction: _search,
            secondaryLabel: L.of(context).adventure,
            // A real alternative, not a dismissal: the camera works with no
            // network at all, and so does the adventure.
            secondaryProminent: true,
            onSecondary: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AdventureMapScreen()),
            ),
          );
        }
        // Ranked: the ring, counting up to the moment a saved set takes over.
        if (_liveSearchFrom case final from?) {
          return _LiveSearchView(
            from: from,
            total: liveSearchFor,
            onCancel: _confirmQuit,
            found: _matched ? _opponent : null,
          );
        }
        // The same door as the back gesture: leaving from here still forfeits
        // if a real opponent already turned up while this screen searched.
        return _SearchingView(
          onCancel: _confirmQuit,
          found: _matched ? _opponent : null,
        );

      case _Stage.versus:
        if (_vsOpponentId case final id?) {
          return VsScreen(
            opponentId: id,
            opponentName: _opponent.username,
            opponentTierIdx: _opponent.tierIdx,
            opponentDivIdx: _opponent.divIdx,
            opponentXp: _opponent.xp,
            opponentAvatarUrl: _opponent.avatarUrl,
            ranked: _live?.ranked ?? !(widget.isLink || widget.isPastSelf),
            pastReps: widget.isPastSelf ? _theirReps : null,
            pastAt: widget.pastSelf?.at,
            week: trainingPlan.plan?.weekOf(trainingPlan.today),
            kind: _live != null
                ? VsKind.live
                : widget.isPastSelf
                ? VsKind.pastSelf
                : widget.isLink
                ? VsKind.challenge
                : widget.isChallenge || widget.isChallengeAccept
                ? VsKind.rematch
                : VsKind.saved,
          );
        }
        return _VersusView(
          opponent: _opponent,
          vsBest: _vsBest,
          best: _theirReps,
          live: _live,
        );

      case _Stage.waitingResult:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: context.colors.brand),
                const SizedBox(height: 18),
                Text(
                  L.of(context).waitingForFinal(_opponent.username),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.text, fontSize: 17),
                ),
              ],
            ),
          ),
        );

      // Usually a second or two; only a dropped connection makes it longer.
      case _Stage.saving:
        return Center(
          child: CircularProgressIndicator(color: context.colors.brand),
        );

      case _Stage.calledOff:
        return BlockingNotice(
          icon: Icons.timer_off_outlined,
          title: L.of(context).calledOffTitle,
          body: L.of(context).calledOffBody(_opponent.username),
          actionLabel: L.of(context).backToHome,
          onAction: () => Navigator.of(context).pop(),
        );

      case _Stage.liveFailed:
        return BlockingNotice(
          icon: Icons.wifi_off,
          title: L.of(context).noConnection,
          body: L.of(context).needsServer,
          actionLabel: L.of(context).backToHome,
          onAction: () => Navigator.of(context).pop(),
        );

      // The camera is a pushed route, so this stage has nothing of its own on
      // screen underneath it.
      case _Stage.live:
        return const SizedBox.shrink();

      case _Stage.placed:
        return PlacedView(
          rank: Rank(
            tierIdx: demoProfile.tierIdx,
            divIdx: demoProfile.divIdx,
            lp: demoProfile.lp,
          ),
          onFindMatch: () => _leave(
            () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MatchFlowScreen()),
            ),
          ),
          onContinue: () => setState(() => _stage = _afterPromotion),
        );

      case _Stage.promoted:
        return PromotionView(
          tierIdx: demoProfile.tierIdx,
          divIdx: demoProfile.divIdx,
          fromTierIdx: _outcome?.rank?.before.tierIdx,
          fromDivIdx: _outcome?.rank?.before.divIdx,
          // A tier nobody in this account has ever held before.
          highest: _outcome?.rank?.changedTier ?? false,
          onContinue: () => setState(() => _stage = _afterPromotion),
        );

      case _Stage.levelUp:
        return LevelUpView(
          gain:
              _xp ??
              XpGain(before: demoProfile.xp, after: demoProfile.xp, reps: 0),
          onContinue: () => setState(() => _stage = _afterLevel),
        );

      case _Stage.weapon:
        return WeaponUnlockedView(
          weapon: _unlocked ?? Adventure.instance.weapon,
          previous: _weapon,
          onContinue: () => setState(() => _stage = _withMoments(_Stage.result)),
        );

      case _Stage.moment:
        final moment = Moments.instance.next;
        if (moment == null) return const SizedBox.shrink();
        return MomentView(
          key: ObjectKey(moment),
          moment: moment,
          onContinue: () {
            Moments.instance.done();
            setState(() => _stage = Moments.instance.next != null ? _Stage.moment : _afterMoment);
          },
        );

      case _Stage.result:
        _ratingTimer ??= Timer(const Duration(seconds: 2), _askForRating);
        if (_fight case final fight?) {
          final level = fight.level;
          void fightAgain(AdventureLevel next) =>
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => MatchFlowScreen(
                    mode: MatchMode.practice,
                    adventure: next,
                  ),
                ),
              );
          return AdventureResultView(
            outcome: fight,
            xp: _xp,
            onNext: level.isLast
                ? null
                : () => _leave(
                    () => fightAgain(AdventureLevel.of(level.number + 1)),
                  ),
            onAgain: () => _leave(() => fightAgain(level)),
            onMap: () => _leave(() => Navigator.of(context).pop()),
          );
        }
        if (_vsBest) {
          return _BestResultView(
            reps: _myReps,
            bestBefore: _bestBefore,
            pooled: _pooled,
            xp: _xp,
            onAgain: () => _leave(
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MatchFlowScreen()),
              ),
            ),
            onDone: () => _leave(() => Navigator.of(context).pop()),
          );
        }
        return _ResultView(
          practice: widget.practice,
          won: _won,
          volume: _myReps.toDouble(),
          opponentVolume: widget.practice ? 0 : _theirReps.toDouble(),
          opponent: _opponent,
          // Null for a local stand-in: nobody real is on the other end to
          // send a challenge to, so the button can only honestly go back.
          outcome: _outcome,
          live: _live,
          weekBefore: _weekBefore,
          weekAfter: _weekAfter,
          xp: _xp,
          yourRepTimes: _myRepTimes,
          theirRepTimes:
              _session?.opponentRepTimes ??
              _realOpponent?.repTimes ??
              const [],
          leave: _leave,
          onDone: () => _leave(() => Navigator.of(context).pop()),
        );

      case _Stage.pastSelfResult:
        return PastSelfResultView(
          mine: _myReps,
          theirs: _theirReps,
          xp: _xp,
          onDone: () => _leave(() => Navigator.of(context).pop()),
        );

      case _Stage.challengeResult:
        return ChallengeResultView(
          view: _linkAfter!,
          reps: _myReps,
          xp: _xp,
          onDone: () => _leave(() => Navigator.of(context).pop()),
        );

      case _Stage.sent:
        return _ChallengeSentView(
          sent: _challengeSent,
          reps: _myReps,
          opponent: _opponent,
          onDone: () => _leave(() => Navigator.of(context).pop()),
        );
    }
  }

  /// Leaving costs nothing yet. Practice keeps no record to lose, a challenge
  /// not yet sent has nobody on the other end to forfeit to, and neither does
  /// a search that has not found anybody. A live match that has not started
  /// is called off for the other phone rather than lost: the round never
  /// began.
  bool get _leavesFree =>
      widget.practice ||
      widget.isChallenge ||
      widget.isLink ||
      widget.isPastSelf ||
      _vsBest ||
      _live != null;

  Future<void> _confirmQuit() async {
    // Nothing to lose: straight out, with no warning about rank points that
    // would not be lost (the user, 2026-11-04: cancelling a search still
    // looking for somebody said leaving would cost LP).
    if (_leavesFree) {
      Navigator.of(context).pop();
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(L.of(context).forfeitQ),
        // A rematch moves no rank (duel.sql): it is a loss, and only that.
        content: Text(
          widget.isChallengeAccept
              ? L.of(context).forfeitRematchBody
              : L.of(context).forfeitBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(L.of(context).stay),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(
              L.of(context).forfeit,
              style: TextStyle(color: context.colors.rival),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await _forfeit();
  }
}

// ─────────────────────────── stage 1: searching ──────────────────────────────

/// Your rank, dimmed, over a card saying what is happening and how long it has
/// been happening for.
///
/// The elapsed clock is the point. A spinner with no number is
/// indistinguishable from a hung app after about four seconds, and this search
/// can honestly take eight.
class _SearchingView extends StatefulWidget {
  const _SearchingView({required this.onCancel, this.found});

  final VoidCallback onCancel;

  /// Who was found, once somebody was: the seat lands on them.
  final Opponent? found;

  @override
  State<_SearchingView> createState() => _SearchingViewState();
}

class _SearchingViewState extends State<_SearchingView> {
  final _elapsed = Stopwatch()..start();
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final seconds = _elapsed.elapsed.inSeconds;
    // Three dots cycling, so the card is visibly alive between clock ticks.
    final lit = (_elapsed.elapsedMilliseconds ~/ 400) % 3;
    final found = widget.found;

    return Column(
      children: [
        const Spacer(flex: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: VsSearchCard(
            found: found,
            children: [
              if (found == null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 3; i++) ...[
                      if (i > 0) const SizedBox(width: 5),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == lit
                              ? context.colors.brand
                              : context.colors.faint,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l.searchingForOpponent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  formatClock(context, seconds),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 14,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ] else
                Text(
                  l.opponentFound,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: widget.onCancel,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.colors.border, width: 0.5),
              ),
              child: Center(
                child: Text(
                  l.cancel,
                  style: TextStyle(color: context.colors.text, fontSize: 15),
                ),
              ),
            ),
          ),
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}

// ─────────────────────────── ranked: the live search ─────────────────────────

/// A ring filling to fifteen seconds, the time inside it, and what happens
/// when it is full. The time is the point, as it is on [_SearchingView]: a
/// wait with a number and an end is a wait people sit through.
class _LiveSearchView extends StatefulWidget {
  const _LiveSearchView({
    required this.from,
    required this.total,
    required this.onCancel,
    this.found,
  });

  final DateTime from;
  final Duration total;
  final VoidCallback onCancel;

  /// Who was found, once somebody was: the seat lands on them.
  final Opponent? found;

  @override
  State<_LiveSearchView> createState() => _LiveSearchViewState();
}

class _LiveSearchViewState extends State<_LiveSearchView> {
  Timer? _tick;
  Timer? _countPoll;

  /// Who else is around, once the server has said.
  LiveOnline? _around;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => setState(() {}),
    );
    _count();
    _countPoll = Timer.periodic(const Duration(seconds: 3), (_) => _count());
  }

  @override
  void dispose() {
    _tick?.cancel();
    _countPoll?.cancel();
    super.dispose();
  }

  Future<void> _count() async {
    if (!backend.available) return;
    try {
      final around = await backend.liveOnline();
      if (mounted) setState(() => _around = around);
    } on Object catch (error) {
      debugPrint('Could not count who is online: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final elapsed = clock.now().difference(widget.from);
    final total = widget.total;
    final share = (elapsed.inMilliseconds / total.inMilliseconds).clamp(
      0.0,
      1.0,
    );
    final seconds = elapsed.inSeconds.clamp(0, total.inSeconds);
    final end = formatClock(context, total.inSeconds);

    final found = widget.found;

    return Column(
      children: [
        const SizedBox(height: 28),
        Text(
          l.rankedLive,
          style: TextStyle(color: context.colors.muted, fontSize: 15),
        ),
        const Spacer(flex: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: VsSearchCard(
            found: found,
            children: [
              Text(
                found == null ? l.lookingForLive : l.opponentFound,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (found == null) ...[
                const SizedBox(height: 12),
                // The fifteen seconds, filling, and the time on them.
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: SizedBox(
                    height: 6,
                    child: LinearProgressIndicator(
                      key: const Key('liveSearchRing'),
                      value: share,
                      backgroundColor: context.colors.surfaceRaised,
                      color: context.colors.brand,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${formatClock(context, seconds)} ${l.ofTime(end)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 14,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.liveFallbackAt(end),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
        // Only once there is somebody to count: "0 online" tells a lifter
        // waiting on a search nothing worth reading.
        if (_around case final around? when around.online > 0) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
            key: const Key('liveOnline'),
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  [
                    l.liveOnlineNow(localNumber(context, around.online)),
                    if (around.searching > 0)
                      l.liveSearchingNow(
                        localNumber(context, around.searching),
                      ),
                  ].join(' · '),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.text, fontSize: 15),
                ),
              ),
            ],
          ),
          ),
        ],
        const Spacer(flex: 3),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
          child: InkWell(
            onTap: widget.onCancel,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.colors.border),
              ),
              child: Center(
                child: Text(
                  l.cancel,
                  style: TextStyle(color: context.colors.text, fontSize: 17),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────── stage 2: opponent found ──────────────────────────

/// Who you drew, and what it is worth. On screen for a second and a half, so
/// it carries three facts and no more.
class _VersusView extends StatelessWidget {
  const _VersusView({
    required this.opponent,
    required this.vsBest,
    required this.best,
    this.live,
  });

  final Opponent opponent;

  /// Nobody was free: the other side is this lifter's own [best], or just
  /// the clock when there is no best yet.
  final bool vsBest;
  final int best;

  /// A live match: the other lifter is about to be on camera too.
  final LiveMatch? live;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final me = demoProfile;
    final live = this.live;

    return Column(
      children: [
        const Spacer(flex: 2),
        if (live != null) ...[
          const LiveTag(),
          const SizedBox(height: 28),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Fighter(
              mine: true,
              initial: me.username,
              name: l.you,
              tierIdx: me.tierIdx,
              divIdx: me.divIdx,
              xp: me.xp,
              ring: context.colors.brand,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                l.vs,
                style: TextStyle(
                  color: context.colors.faint,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ),
            if (vsBest)
              _Pace(best: best)
            else
              _Fighter(
                id: opponent.id,
                avatarUrl: opponent.avatarUrl,
                initial: opponent.username,
                name: opponent.username,
                tierIdx: opponent.tierIdx,
                divIdx: opponent.divIdx,
                xp: opponent.xp,
                ring: context.colors.rival,
              ),
          ],
        ),
        if (live != null) ...[
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l.liveFoundBody(opponent.username),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 17,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            live.ranked ? l.lpMovesWithGap : l.friendlyNoRank,
            style: TextStyle(color: context.colors.muted, fontSize: 14),
          ),
        ] else if (vsBest) ...[
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              best > 0 ? l.nobodyFreeRaceBest : l.nobodyFreeFirstScore,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 24),
          // No number to promise any more — LP is exactly the rep gap, which
          // nothing about the round has decided yet. What can be said now is
          // the rule itself.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: context.colors.border, width: 0.5),
            ),
            child: Text(
              l.lpMovesWithGap,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.text, fontSize: 14),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            l.rankedTerms(localNumber(context, kDuelLength.inSeconds)),
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
        ],
        const Spacer(flex: 3),
      ],
    );
  }
}

class _Fighter extends StatelessWidget {
  const _Fighter({
    this.id = '',
    this.avatarUrl,
    this.mine = false,
    required this.initial,
    required this.name,
    required this.tierIdx,
    required this.divIdx,
    required this.ring,
    this.xp,
  });

  /// Who they are, for their face (face.dart): this account's own when
  /// [mine].
  final String id;
  final String? avatarUrl;
  final bool mine;

  final String initial;
  final String name;
  final int tierIdx;
  final int divIdx;
  final Color ring;

  /// For the level under the rank; null when not known.
  final int? xp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        children: [
          ListenableBuilder(
            listenable: Looks.instance,
            builder: (context, _) {
              final face = faceOf(
                id: id,
                name: initial,
                avatarUrl: avatarUrl,
                mine: mine,
              );
              final circle = LifterCircle(
                name: initial,
                size: 62,
                lifter: face.lifter,
                border: Border.all(color: ring, width: 2),
              );
              final photo = face.photo;
              if (photo == null) return circle;
              return Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ring, width: 2),
                ),
                child: ClipOval(
                  child: PhotoOrLifter(
                    image: decodedAt(context, photo, 62),
                    size: 62,
                    lifter: circle,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 7),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.text, fontSize: 14),
          ),
          Text(
            tierLabel(L.of(context), tierIdx, divIdx),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: kTiers[tierIdx.clamp(0, kTiers.length - 1)].color,
              fontSize: 12,
            ),
          ),
          if (xp case final xp?) ...[
            const SizedBox(height: 4),
            FittedBox(fit: BoxFit.scaleDown, child: LevelChip(xp: xp)),
          ],
        ],
      ),
    );
  }
}

/// The other side of a round with nobody to race: this lifter's own best, or
/// the clock when there is none yet. Drawn in the fighter's place and size,
/// with a faint ring, so it reads as a pace rather than a person.
class _Pace extends StatelessWidget {
  const _Pace({required this.best});

  final int best;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return SizedBox(
      width: 88,
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.surfaceRaised,
              border: Border.all(color: context.colors.faint, width: 2),
            ),
            child: best > 0
                ? Text(
                    localNumber(context, best),
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Icon(Icons.timer_outlined, color: context.colors.muted),
          ),
          const SizedBox(height: 7),
          Text(
            best > 0 ? l.yourBest : l.theClock,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.text, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// Where a round against your own best ends: the count, whether it beat the
/// best, and where the set went.
///
/// No win and no LP. The only thing raced was a number this lifter already
/// owned, and the ladder is for racing people.
class _BestResultView extends StatelessWidget {
  const _BestResultView({
    required this.reps,
    required this.bestBefore,
    required this.pooled,
    required this.onAgain,
    required this.onDone,
    this.xp,
  });

  final int reps;
  final int bestBefore;
  final bool pooled;
  final XpGain? xp;
  final VoidCallback onAgain;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final newBest = reps > bestBefore;

    return Column(
      children: [
        Expanded(
          // Centred when it fits, scrolling when a large text size means it
          // does not.
          child: LayoutBuilder(
            builder: (context, box) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: box.maxHeight - 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      newBest
                          ? l.newPersonalBest
                          : l.bestStillIs(localNumber(context, bestBefore)),
                      textAlign: TextAlign.center,
                      style: context.type.heading.copyWith(
                        color: newBest
                            ? context.colors.brand
                            : context.colors.text,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      localNumber(context, reps),
                      style: context.type.display.copyWith(
                        color: context.colors.text,
                        fontSize: 88,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l
                          .pushUpsInSeconds(
                            localNumber(context, kDuelLength.inSeconds),
                          )
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: context.type.micro.copyWith(
                        color: context.colors.muted,
                      ),
                    ),
                    SavedToHealthChip(saved: Career.instance.lastHealthSave),
                    if (xp case final gain?) ...[
                      const SizedBox(height: 24),
                      XpGainCard(gain: gain),
                    ],
                    if (pooled) ...[
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: context.colors.border,
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.setInPoolTitle,
                              style: TextStyle(
                                color: context.colors.text,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l.setInPoolBody,
                              style: TextStyle(
                                color: context.colors.muted,
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: onAgain, child: Text(l.rematch)),
              ),
              const SizedBox(height: 11),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onDone,
                  child: Text(l.doneAction),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  final bool practice;
  final bool won;
  final double volume;
  final double opponentVolume;
  final Opponent opponent;

  /// What the duel did to the account. Null only for practice, which does
  /// nothing to it by design.
  final DuelOutcome? outcome;

  /// The live match this was, if it was one: its rematch is asked of the
  /// other phone instead of recorded for later.
  final LiveMatch? live;

  final MonthPlace? weekBefore;
  final MonthPlace? weekAfter;

  /// What the session added to the level.
  final XpGain? xp;

  final VoidCallback onDone;

  /// The screen's way out of a finished game: the ad, then where to.
  final Future<void> Function(VoidCallback go, {bool rematch}) leave;

  const _ResultView({
    this.practice = false,
    required this.won,
    required this.volume,
    required this.opponentVolume,
    required this.opponent,
    required this.outcome,
    required this.onDone,
    required this.leave,
    this.live,
    this.weekBefore,
    this.weekAfter,
    this.xp,
    this.yourRepTimes = const [],
    this.theirRepTimes = const [],
  });

  /// For the race chart: see [DuelResultView.yourRepTimes].
  final List<int> yourRepTimes;
  final List<int> theirRepTimes;

  @override
  Widget build(BuildContext context) {
    if (practice) {
      return _PracticeResult(reps: volume.round(), xp: xp, onDone: onDone);
    }

    return DuelResultView(
      won: won,
      yourReps: volume.round(),
      theirReps: opponentVolume.round(),
      opponent: opponent,
      outcome: outcome,
      live: live,
      weekBefore: weekBefore,
      weekAfter: weekAfter,
      xp: xp,
      yourRepTimes: yourRepTimes,
      theirRepTimes: theirRepTimes,
      // Both asked: the new match replaces this result, so finishing it
      // lands where this one started.
      // The same two, straight back in: no ad between them.
      onLiveRematch: (match) => leave(
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                MatchFlowScreen(mode: MatchMode.liveFriend, liveMatch: match),
          ),
        ),
        rematch: true,
      ),
      closestYet:
          !won && _closestLossYet(volume.round(), opponentVolume.round()),
      // Not live: the set raced was somebody's saved minute, and racing it
      // again — its number now known — would only hand its owner another
      // loss. So no rematch: a new search, which never pairs two who have
      // already met. It replaces this screen, so finishing it lands where
      // this duel started.
      rematchLabel: L.of(context).findMatch,
      onRematch: () => leave(
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MatchFlowScreen(mode: MatchMode.ranked),
          ),
        ),
      ),
      onDone: onDone,
    );
  }
}

/// Whether this defeat is the narrowest on record.
///
/// Read off the history, not guessed at. The match just played is already in
/// it, so it is compared against every *other* loss — and with nothing to
/// compare against, a first loss is not "the closest yet", it is just a loss.
bool _closestLossYet(int yourReps, int theirReps) {
  final margin = (theirReps - yourReps).abs();
  var seen = 0;
  for (final m in matchHistory.skip(1)) {
    if (m.won) continue;
    seen++;
    if ((m.opponentReps - m.userReps).abs() <= margin) return false;
  }
  return seen > 0;
}

// ─────────────────────────── shared header ────────────────────────────────────

/// What practice ends on: the count, and no verdict.
///
/// There was nobody to beat, so there is nothing to win or lose and no LP to
/// hand out. Dressing a solo set up as a victory would make the word "win"
/// mean nothing on the screen where it has to mean something.
/// Where [MatchMode.challenge] ends: reps landed, but no verdict — that
/// waits for the other half, raced from the notification this sends.
class _ChallengeSentView extends StatelessWidget {
  const _ChallengeSentView({
    required this.sent,
    required this.reps,
    required this.opponent,
    required this.onDone,
  });

  final bool sent;
  final int reps;
  final Opponent opponent;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            sent ? Icons.send_rounded : Icons.error_outline,
            size: 48,
            color: sent ? context.colors.brand : AppColors.loss,
          ),
          const SizedBox(height: 18),
          Text(
            sent ? l.challengeSentTitle : l.challengeNotSentTitle,
            textAlign: TextAlign.center,
            style: context.type.heading.copyWith(color: context.colors.text),
          ),
          const SizedBox(height: 8),
          Text(
            sent
                ? l.challengeSentBody(opponent.username)
                : l.challengeNotSentBody,
            textAlign: TextAlign.center,
            style: context.type.body.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 12),
          Text(
            l.repsRecordedLine(localNumber(context, reps)),
            style: context.type.label.copyWith(color: context.colors.muted),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onDone, child: Text(l.backToHome)),
          ),
        ],
      ),
    );
  }
}

class _PracticeResult extends StatelessWidget {
  const _PracticeResult({required this.reps, required this.onDone, this.xp});

  final int reps;
  final XpGain? xp;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    // The set is already counted by the time this shows, so today's total
    // includes it and the total before it is that less these reps.
    final after = Career.instance.repsToday;
    final goal = settings.dailyGoal;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            L.of(context).practiceComplete,
            style: context.type.label.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 12),
          Text(
            localNumber(context, reps),
            style: context.type.display.copyWith(color: context.colors.text),
          ),
          const SizedBox(height: 4),
          Text(
            L.of(context).totalReps.toUpperCase(),
            style: context.type.micro.copyWith(color: context.colors.muted),
          ),
          SavedToHealthChip(saved: Career.instance.lastHealthSave),
          if (xp case final gain? when gain.total > 0) ...[
            const SizedBox(height: 24),
            XpGainCard(gain: gain),
          ],
          if (GoalDoneCard.passed(after - reps, after, goal)) ...[
            const SizedBox(height: 28),
            GoalDoneCard(done: after, goal: goal),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onDone,
              child: Text(L.of(context).backToHome),
            ),
          ),
        ],
      ),
    );
  }
}
