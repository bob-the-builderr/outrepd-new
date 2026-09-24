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

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../career.dart';
import '../ranking.dart';
import '../connection.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
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

  const MatchFlowScreen({
    super.key,
    this.mode = MatchMode.ranked,
    this.targetId,
    this.targetUsername,
    this.targetTierIdx,
    this.targetDivIdx,
  }) : assert(
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
}

class _MatchFlowScreenState extends State<MatchFlowScreen> {
  late _Stage _stage;

  // Seeded with a demo opponent in initState and overwritten in _search if a
  // real one is found. Never left unset: practice reaches _Stage.result too,
  // by way of _ResultView's constructor, without ever calling _search.
  late Opponent _opponent;
  late int _theirReps;

  /// Somebody else's actual stored set, when [_search] found one. Null means
  /// [_opponent] is the local stand-in — there was nobody real to race yet,
  /// or there is no server at all — and the result is worked out locally
  /// exactly as it always was.
  OpponentSet? _realOpponent;

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

  /// Nobody real was found, so the name on the other side is a local
  /// stand-in wearing a real lifter's shape. A challenge is never this —
  /// either the named target's set turns up, or the screen says outright
  /// that it did not.
  bool get _simulated =>
      _realOpponent == null && !widget.isChallenge && !widget.isChallengeAccept;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _opponent = demoOpponents[rng.nextInt(demoOpponents.length)];
    // A believable minute of push-ups.
    _theirReps = 18 + rng.nextInt(26);

    _stage = widget.practice ? _Stage.live : _Stage.searching;
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
    super.dispose();
  }

  bool get _won =>
      widget.practice || (_outcome?.won ?? (_myReps >= _theirReps));

  /// A forfeit is a flat win: you did not have to close the gap, so the gap
  /// pays nothing.
  /// What a win pays and what a loss costs, before either has happened.
  ///
  /// The same two functions the result is paid out of. They used to be
  /// written twice — once here for the promise and once for the payment — and
  /// two copies of a rule is two rules. The card says what the account will
  /// actually receive because it is asking the thing that will pay it.
  int get _lpOnOffer => lpForWin(demoProfile.tierIdx, _opponent.tierIdx);

  int get _lpAtRisk => lpForLoss(demoProfile.tierIdx, _opponent.tierIdx).abs();

  Future<void> _search() async {
    _timer?.cancel();

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
    _goVersus();
  }

  /// The countdown from "found somebody" to "on camera", shared by every mode
  /// that reaches it.
  void _goVersus() {
    // A challenge already knows exactly who it is with — there is nothing to
    // search for, so nothing to fake the look of searching for either.
    // Everyone else gets a wait somewhere inside the window the design
    // allows, so it never feels scripted whether what was found is a real
    // set or the stand-in seeded in initState.
    final wait = (widget.isChallenge || widget.isChallengeAccept)
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
          duel: (widget.practice || widget.isChallenge)
              ? null
              : DuelContext(
                  opponentName: _opponent.username,
                  opponentReps: _theirReps,
                  opponentRepTimes: _realOpponent?.repTimes ?? const [],
                  opponentTierIdx: _opponent.tierIdx,
                  opponentDivIdx: _opponent.divIdx,
                  rankLabel: tierLabel(
                    L.of(context),
                    demoProfile.tierIdx,
                    demoProfile.divIdx,
                  ),
                  lpGain: _lpOnOffer,
                  lpRisk: _lpAtRisk,
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
    if (widget.practice) {
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
        // The same door as the back gesture: leaving from here still forfeits
        // if a real opponent already turned up while this screen searched.
        return _SearchingView(onCancel: _confirmQuit);

      case _Stage.versus:
        return _VersusView(
          opponent: _opponent,
          lpGain: _lpOnOffer,
          lpRisk: _lpAtRisk,
          simulated: _simulated,
        );

      // The camera is a pushed route, so this stage has nothing of its own on
      // screen underneath it.
      case _Stage.live:
        return const SizedBox.shrink();

      case _Stage.promoted:
        return PromotionView(
          tierIdx: demoProfile.tierIdx,
          divIdx: demoProfile.divIdx,
          // A tier nobody in this account has ever held before.
          highest: _outcome?.rank?.changedTier ?? false,
          onContinue: () => setState(() => _stage = _Stage.result),
        );

      case _Stage.result:
        return _ResultView(
          practice: widget.practice,
          won: _won,
          volume: _myReps.toDouble(),
          opponentVolume: widget.practice ? 0 : _theirReps.toDouble(),
          opponent: _opponent,
          // Null for a local stand-in: nobody real is on the other end to
          // send a challenge to, so the button can only honestly go back.
          realOpponentId: _realOpponent?.profileId,
          outcome: _outcome,
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

    // Nothing was ever attempted: practice keeps no record to lose, and a
    // challenge not yet sent has nobody on the other end to forfeit to.
    if (widget.practice || widget.isChallenge) {
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
                style: TextStyle(color: context.colors.text, fontSize: 15),
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
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      formatClock(context, seconds),
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 12,
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
                        fontSize: 13,
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

// ────────────────────────── stage 2: opponent found ──────────────────────────

/// Who you drew, and what it is worth. On screen for a second and a half, so
/// it carries three facts and no more.
class _VersusView extends StatelessWidget {
  const _VersusView({
    required this.opponent,
    required this.lpGain,
    required this.lpRisk,
    required this.simulated,
  });

  final Opponent opponent;
  final int lpGain;
  final int lpRisk;
  final bool simulated;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final me = demoProfile;

    return Column(
      children: [
        const Spacer(flex: 2),
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
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ),
            _Fighter(
              initial: opponent.username,
              name: opponent.username,
              tierIdx: opponent.tierIdx,
              divIdx: opponent.divIdx,
              ring: context.colors.rival,
            ),
          ],
        ),
        if (simulated) ...[
          const SizedBox(height: 10),
          Text(
            l.simulatedOpponent,
            style: TextStyle(color: context.colors.faint, fontSize: 11),
          ),
        ],
        const SizedBox(height: 24),
        // What is at stake, before it is at stake. Seeing the downside up
        // front is what makes the upside mean anything.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child: Text(
            l.lpSwing(
              localNumber(context, lpGain),
              localNumber(context, lpRisk),
            ),
            style: TextStyle(
              color: context.colors.text,
              fontSize: 12,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          l.rankedTerms(localNumber(context, kDuelLength.inSeconds)),
          style: TextStyle(color: context.colors.muted, fontSize: 11),
        ),
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
              style: TextStyle(color: context.colors.text, fontSize: 21),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.text, fontSize: 12),
          ),
          Text(
            tierLabel(L.of(context), tierIdx, divIdx),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: kTiers[tierIdx.clamp(0, kTiers.length - 1)].color,
              fontSize: 10,
            ),
          ),
        ],
      ),
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
            child: FilledButton(
              onPressed: onDone,
              child: Text(l.backToHome),
            ),
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

