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

import '../backend/backend.dart';
import '../career.dart';
import '../connection.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../live.dart';
import '../player_avatar.dart';
import '../reps/recording.dart';
import '../reps/pushup_counter.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../widgets.dart';
import '../reps/count_accuracy.dart';
import 'confirm_count.dart';
import 'match_entry.dart';
import 'post_match.dart';
import 'trainer.dart';

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

  const MatchFlowScreen({
    super.key,
    this.mode = MatchMode.ranked,
    this.targetId,
    this.targetUsername,
    this.targetTierIdx,
    this.targetDivIdx,
    this.liveMatch,
  }) : assert(
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

  @override
  State<MatchFlowScreen> createState() => _MatchFlowScreenState();
}

enum _Stage {
  searching,
  versus,
  live,

  /// Shown before the result when the duel moved the lifter up a division.
  /// It is the news; the breakdown behind it is the detail, and the detail
  /// reads better once the headline has landed.
  promoted,

  result,

  /// [MatchMode.challenge] ends here instead of at [result] — reps landed,
  /// but nobody has raced them yet.
  sent,

  /// The ranked search found nobody live in fifteen seconds and a saved set
  /// instead. Shown, not skipped past: racing a set is a different thing
  /// from racing somebody now, and the lifter starts it themselves.
  nobodyLive,

  /// Live: this set is in, and the other phone's is not yet.
  waitingResult,

  /// Live: the other lifter never got into position. Nothing was recorded.
  calledOff,

  /// Live: the server could not be reached to settle it.
  liveFailed,
}

class _MatchFlowScreenState extends State<MatchFlowScreen> {
  late _Stage _stage;

  // Seeded with this lifter in initState and overwritten in _search if a real
  // opponent is found. Never left unset: practice reaches _Stage.result too,
  // by way of _ResultView's constructor, without ever calling _search.
  late Opponent _opponent;
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

  int _myReps = 0;
  Timer? _timer;

  /// What the duel did to the account, once it has been recorded.
  DuelOutcome? _outcome;

  /// The live match, when there is one: found by the ranked search, or the
  /// friend's invite or rematch this screen was opened for.
  LiveMatch? _live;

  /// This account's place on the month's board before the duel and after
  /// it, for the result screen's "#14 → #11". Null when not known.
  int? _monthBefore;
  int? _monthAfter;
  LiveSession? _session;

  /// How long the ranked search looks for somebody live before it races a
  /// saved set instead.
  static const liveSearchFor = Duration(seconds: 15);

  /// When the live search began, for the ring on the search screen. Null
  /// when this search is not looking for anybody live.
  DateTime? _liveSearchFrom;

  /// Whether this search went looking for somebody live at all — and so
  /// whether a saved set found after it is a fallback worth saying so about.
  bool _searchedLive = false;

  /// Left while still looking, so the queue is left too.
  bool _searchCancelled = false;

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
      !widget.isChallengeAccept;

  @override
  void initState() {
    super.initState();
    final me = demoProfile;
    _opponent = Opponent(me.username, me.tierIdx, me.divIdx);
    _theirReps = 0;

    _stage = widget.practice ? _Stage.live : _Stage.searching;
    if (!widget.practice) {
      unawaited(_readMonthPlace().then((place) => _monthBefore = place));
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

    // A friend's live match: both already said yes, so there is nobody to
    // look for — straight to meeting them.
    if (widget.liveMatch case final match? when widget.isLiveFriend) {
      setState(() {
        _live = match;
        _opponent = Opponent(
          match.opponent.username,
          match.opponent.tierIdx,
          match.opponent.divIdx,
        );
        _theirReps = 0;
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
          _opponent = Opponent(found.username, found.tierIdx, found.divIdx);
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
            _opponent = Opponent(found.username, found.tierIdx, found.divIdx);
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
    } else if (_searchedLive) {
      // Nobody live, and a saved set instead: say so first.
      setState(() => _stage = _Stage.nobodyLive);
      return;
    }
    // Fifteen seconds were already spent looking; no need to look longer.
    _goVersus(quick: _searchedLive);
  }

  /// The countdown from "found somebody" to "on camera", shared by every mode
  /// that reaches it.
  void _goVersus({bool quick = false}) {
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
            widget.isLiveFriend)
        ? const Duration(milliseconds: 600)
        : Duration(milliseconds: 2200 + Random().nextInt(3400));
    _timer = Timer(wait, () {
      if (!mounted) return;
      setState(() => _stage = _Stage.versus);
      _timer = Timer(const Duration(milliseconds: 1500), () {
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
          limit: kDuelLength,
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
                  opponentName: _vsBest
                      ? L.of(context).yourBest
                      : _opponent.username,
                  opponentReps: _theirReps,
                  opponentRepTimes: _realOpponent?.repTimes ?? const [],
                  opponentTierIdx: _opponent.tierIdx,
                  opponentDivIdx: _opponent.divIdx,
                  rankLabel: tierLabel(
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
    if (widget.practice) {
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

    await _settleAndRecord(
      reps: settled,
      gaveUp: scored?.gaveUp ?? false,
      // A camera session that never came back with a count never went onto
      // the server either — exactly what this screen has always done when
      // there was nothing to upload.
      attempted: scored != null,
      repsCamera: scored?.reps ?? 0,
      depth: scored?.depth ?? 0,
      confident: scored?.confident ?? false,
      durationMs: scored?.durationMs ?? 1,
      repTimes: scored?.repTimes ?? const [],
    );
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
    // Onto the server, if there is one to reach: the set is stored regardless
    // of whether today's opponent was real, so whoever searches next finds
    // one. Raced against a real opponent, the upload is also this lifter's
    // half of the duel — `settle_duel` reads everything it decides from the
    // two rows, so the set has to exist before the result can.
    //
    // Never fatal. A dropped connection here must not cost a finished set —
    // it falls back to exactly what this screen has always done locally.
    SettledDuel? settledDuel;
    if (attempted &&
        !widget.practice &&
        backend.available &&
        backend.me != null) {
      try {
        final mySetId = await backend.uploadSet(
          SetUpload(
            reps: reps,
            repsCamera: repsCamera,
            depth: depth,
            confident: confident,
            durationMs: durationMs,
            gaveUp: gaveUp,
            repTimes: repTimes,
          ),
        );
        _pooled = _vsBest;
        if (_realOpponent case final opponentSet?) {
          settledDuel = await backend.settle(
            mySetId: mySetId,
            theirSetId: opponentSet.setId,
            ranked: widget.ranked,
          );
        }
      } on Object catch (error) {
        debugPrint('Could not reach the server to record this set: $error');
      }
    }
    if (!mounted) return;

    // Written down before the result is shown, so what the screen reports and
    // what the account holds are the same thing. Showing first and saving
    // afterwards is how a duel ends with a win on screen and nothing in the
    // history behind it.
    if (widget.practice || _vsBest) {
      await Career.instance.recordPractice(reps, clean: depth >= kCleanDepth);
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
    if (!mounted) return;

    setState(() {
      _myReps = reps;
      // A promotion is announced on its own screen first.
      _stage = (_outcome?.rank?.promoted ?? false)
          ? _Stage.promoted
          : _Stage.result;
    });
    unawaited(_afterMonthPlace());
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
      return;
    }
    _theirReps = finish?.theirReps ?? theirs;
    _outcome = await Career.instance.recordSettledDuel(
      settled: settled,
      yourReps: scored.reps,
      theirReps: _theirReps,
      opponent: _opponent.username,
      opponentTier: _opponent.tierIdx,
      ranked: live.ranked,
      clean: scored.depth >= kCleanDepth,
    );
    if (!mounted) return;
    setState(() {
      _stage = (_outcome?.rank?.promoted ?? false)
          ? _Stage.promoted
          : _Stage.result;
    });
    unawaited(_afterMonthPlace());
  }

  /// Where this account stands on the month's board, or null when there is
  /// no answer. Only ranked duels move it, so only they ask.
  Future<int?> _readMonthPlace() async {
    if (!backend.available || backend.me == null) return null;
    try {
      return (await backend.myMonthPlace())?.place;
    } on Object catch (error) {
      debugPrint('Could not read the month place: $error');
      return null;
    }
  }

  Future<void> _afterMonthPlace() async {
    if (_outcome?.rank == null) return;
    final place = await _readMonthPlace();
    if (mounted && place != null) setState(() => _monthAfter = place);
  }

  /// Backing out before the camera ever opened — [_confirmQuit] below. No
  /// reps landed, but the rule is the one the camera's own "give up" already
  /// enforces mid-round: walking away is a loss whatever the count says, and
  /// a real account on the other end of a real set is owed the win it pays.
  Future<void> _forfeit() async {
    _timer?.cancel();
    await _settleAndRecord(reps: 0, gaveUp: true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Leaving mid-match would silently forfeit, so confirm first. A gone
      // challenge never started a match to forfeit.
      canPop:
          _stage == _Stage.result ||
          _stage == _Stage.promoted ||
          _stage == _Stage.sent ||
          _stage == _Stage.calledOff ||
          _stage == _Stage.liveFailed ||
          // The set is in; the server settles it whether or not this screen
          // waits to see it.
          _stage == _Stage.waitingResult ||
          _challengeGone,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
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
            secondaryLabel: L.of(context).practiceOffline,
            // A real alternative, not a dismissal: the camera works with no
            // network at all.
            secondaryProminent: true,
            onSecondary: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const MatchFlowScreen(mode: MatchMode.practice),
              ),
            ),
          );
        }
        // Ranked: the ring, counting up to the moment a saved set takes over.
        if (_liveSearchFrom case final from?) {
          return _LiveSearchView(
            from: from,
            total: liveSearchFor,
            onCancel: _confirmQuit,
          );
        }
        // The same door as the back gesture: leaving from here still forfeits
        // if a real opponent already turned up while this screen searched.
        return _SearchingView(onCancel: _confirmQuit);

      case _Stage.versus:
        return _VersusView(
          opponent: _opponent,
          vsBest: _vsBest,
          best: _theirReps,
          live: _live,
        );

      case _Stage.nobodyLive:
        return _NobodyLiveView(
          opponent: _opponent,
          reps: _theirReps,
          onRace: () => _goVersus(quick: true),
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

      case _Stage.promoted:
        return PromotionView(
          tierIdx: demoProfile.tierIdx,
          divIdx: demoProfile.divIdx,
          fromTierIdx: _outcome?.rank?.before.tierIdx,
          fromDivIdx: _outcome?.rank?.before.divIdx,
          // A tier nobody in this account has ever held before.
          highest: _outcome?.rank?.changedTier ?? false,
          onContinue: () => setState(() => _stage = _Stage.result),
        );

      case _Stage.result:
        if (_vsBest) {
          return _BestResultView(
            reps: _myReps,
            bestBefore: _bestBefore,
            pooled: _pooled,
            onAgain: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MatchFlowScreen()),
            ),
            onDone: () => Navigator.of(context).pop(),
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
          realOpponentId: _realOpponent?.profileId ?? _live?.opponent.id,
          outcome: _outcome,
          live: _live,
          monthBefore: _monthBefore,
          monthAfter: _monthAfter,
          onDone: () => Navigator.of(context).pop(),
        );

      case _Stage.sent:
        return _ChallengeSentView(
          sent: _challengeSent,
          reps: _myReps,
          opponent: _opponent,
          onDone: () => Navigator.of(context).pop(),
        );
    }
  }

  Future<void> _confirmQuit() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(L.of(context).forfeitQ),
        content: Text(L.of(context).forfeitBody),
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

    // Nothing was ever attempted: practice keeps no record to lose, a
    // challenge not yet sent has nobody on the other end to forfeit to, and
    // neither does a search that has not found anybody. A saved set offered
    // in place of a live match has not been agreed to yet, and a live match
    // that has not started is called off for the other phone rather than
    // lost: the round never began.
    if (widget.practice ||
        widget.isChallenge ||
        _vsBest ||
        _live != null ||
        _stage == _Stage.nobodyLive) {
      Navigator.of(context).pop();
      return;
    }
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
  const _SearchingView({required this.onCancel});

  final VoidCallback onCancel;

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
    final p = demoProfile;
    final seconds = _elapsed.elapsed.inSeconds;
    // Three dots cycling, so the card is visibly alive between clock ticks.
    final lit = (_elapsed.elapsedMilliseconds ~/ 400) % 3;

    return Column(
      children: [
        const Spacer(flex: 2),
        Opacity(
          opacity: 0.55,
          child: Column(
            children: [
              TierBadge(tierIndex: p.tierIdx, size: 58),
              const SizedBox(height: 6),
              Text(
                tierLabel(l, p.tierIdx, p.divIdx),
                style: TextStyle(color: context.colors.text, fontSize: 17),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colors.border, width: 0.5),
                ),
                child: Column(
                  children: [
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
                    const SizedBox(height: 7),
                    Text(
                      l.searchingForOpponent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      formatClock(context, seconds),
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 14,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: widget.onCancel,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: context.colors.border,
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      l.cancel,
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
  });

  final DateTime from;
  final Duration total;
  final VoidCallback onCancel;

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

    return Column(
      children: [
        const SizedBox(height: 28),
        Text(
          l.rankedLive,
          style: TextStyle(color: context.colors.muted, fontSize: 15),
        ),
        const Spacer(flex: 2),
        SizedBox(
          width: 230,
          height: 230,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  key: const Key('liveSearchRing'),
                  value: share,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: context.colors.surfaceRaised,
                  color: context.colors.brand,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatClock(context, seconds),
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    l.ofTime(end),
                    style: TextStyle(color: context.colors.muted, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l.lookingForLive,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            l.liveFallbackAt(end),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.muted,
              fontSize: 15,
              height: 1.4,
            ),
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

/// Fifteen seconds and nobody live: who the saved set belongs to and what
/// they did, and a button to race it. The rank points are the same as a live
/// match's, and the screen says so — a fallback that paid less would be a
/// reason to cancel and search again.
class _NobodyLiveView extends StatelessWidget {
  const _NobodyLiveView({
    required this.opponent,
    required this.reps,
    required this.onRace,
  });

  final Opponent opponent;
  final int reps;
  final VoidCallback onRace;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      children: [
        const Spacer(flex: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l.nobodyLiveTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.nobodyLiveBody,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.muted, fontSize: 16),
        ),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child: Row(
            children: [
              PlayerAvatar(
                name: opponent.username,
                tierIdx: opponent.tierIdx,
                size: 60,
                textColour: context.colors.rival,
                ringColour: context.colors.surface,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opponent.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.colors.rival,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      tierLabel(l, opponent.tierIdx, opponent.divIdx),
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l.didRepsIn(localNumber(context, reps)),
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l.sameRankPoints,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.muted, fontSize: 14),
          ),
        ),
        const Spacer(flex: 3),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
          child: Material(
            color: context.colors.brand,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              key: const Key('raceSavedSet'),
              onTap: onRace,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Center(
                  child: Text(
                    l.raceIt,
                    style: TextStyle(
                      color: context.colors.background,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
              initial: me.username,
              name: l.you,
              tierIdx: me.tierIdx,
              divIdx: me.divIdx,
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
                initial: opponent.username,
                name: opponent.username,
                tierIdx: opponent.tierIdx,
                divIdx: opponent.divIdx,
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
    required this.initial,
    required this.name,
    required this.tierIdx,
    required this.divIdx,
    required this.ring,
  });

  final String initial;
  final String name;
  final int tierIdx;
  final int divIdx;
  final Color ring;

  @override
  Widget build(BuildContext context) {
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
              border: Border.all(color: ring, width: 2),
            ),
            child: Text(
              initial.isEmpty ? '?' : initial.characters.first.toUpperCase(),
              style: TextStyle(color: context.colors.text, fontSize: 23),
            ),
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
  });

  final int reps;
  final int bestBefore;
  final bool pooled;
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

  /// Who to send a rematch challenge to. Null when [opponent] was a local
  /// stand-in rather than somebody real — there was nobody to actually race,
  /// so there is nobody a rematch could honestly reach either.
  final String? realOpponentId;

  /// What the duel did to the account. Null only for practice, which does
  /// nothing to it by design.
  final DuelOutcome? outcome;

  /// The live match this was, if it was one: its rematch is asked of the
  /// other phone instead of recorded for later.
  final LiveMatch? live;

  final int? monthBefore;
  final int? monthAfter;

  final VoidCallback onDone;

  const _ResultView({
    this.practice = false,
    required this.won,
    required this.volume,
    required this.opponentVolume,
    required this.opponent,
    required this.realOpponentId,
    required this.outcome,
    required this.onDone,
    this.live,
    this.monthBefore,
    this.monthAfter,
  });

  @override
  Widget build(BuildContext context) {
    if (practice) return _PracticeResult(reps: volume.round(), onDone: onDone);

    return DuelResultView(
      won: won,
      yourReps: volume.round(),
      theirReps: opponentVolume.round(),
      opponent: opponent,
      outcome: outcome,
      live: live,
      monthBefore: monthBefore,
      monthAfter: monthAfter,
      // Both asked: the new match replaces this result, so finishing it
      // lands where this one started.
      onLiveRematch: (match) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              MatchFlowScreen(mode: MatchMode.liveFriend, liveMatch: match),
        ),
      ),
      closestYet:
          !won && _closestLossYet(volume.round(), opponentVolume.round()),
      // Real opponent: replace this screen with a fresh challenge naming
      // them, so finishing it lands back where this duel started rather than
      // on this now-stale result. Stand-in: going back to the match tab is
      // the only honest thing the button can do.
      onRematch: realOpponentId == null
          ? onDone
          : () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => MatchFlowScreen(
                  mode: MatchMode.challenge,
                  targetId: realOpponentId,
                  targetUsername: opponent.username,
                  targetTierIdx: opponent.tierIdx,
                  targetDivIdx: opponent.divIdx,
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
  const _PracticeResult({required this.reps, required this.onDone});

  final int reps;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
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
