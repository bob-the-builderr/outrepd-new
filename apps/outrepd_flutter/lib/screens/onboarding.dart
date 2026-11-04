/// Everything between installing the app and the first duel.
///
/// The order is the argument: the app asks for the camera only after it has
/// said what the camera is for, and asks somebody to place the phone only
/// after it has the camera. Every request comes after the thing that makes
/// it worth granting — except the account, which comes last of all, because
/// nobody can be asked to commit to something they have not tried yet.
///
/// The account is not optional, though — no duel is playable without one,
/// this device's own placements included. It sits at the very end so that
/// trying the app costs nothing, and keeping what was just built here costs
/// one screen.
///
/// The old flow was a carousel of pictures followed by a twelve-question
/// survey. Nothing read the answers, and the camera — the one permission the
/// app cannot work without — was asked for much later, cold, on a screen with
/// a barbell on it.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../adventure/adventure.dart';
import '../adventure/golem.dart';
import '../career.dart';
import '../data.dart';
import '../keep_awake.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../ranking.dart';
import '../reps/pose.dart';
import '../reps/pose_source.dart';
import '../reps/posture.dart';
import '../reps/pushup_counter.dart';
import '../reps/skeleton.dart';
import '../sounds.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../widgets.dart';
import 'auth_entry.dart';
import 'legal_line.dart';
import 'shell.dart';
import 'trainer.dart' show DepthBar;
import 'welcome_inside.dart';

/// Reps asked for before the app claims to know somebody's range.
///
/// Three, because one is a fluke and five is a set. It is the smallest number
/// from which a range can be read, and it has to be small: this is asked of
/// somebody who has had the app for ninety seconds.
const kCalibrationReps = 3;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.poseSource});

  /// Where poses come from during the framing check and the calibration set.
  /// A test hands in a scripted stream; everything else gets the camera.
  final PoseSource Function()? poseSource;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

/// Eleven steps to signing up: the idea's four cards each a step of its own
/// (the user, 2026-10-30), and no page about placements before there is an
/// account to place — the home screen says it when it matters. The camera and
/// the three-rep calibration stay before the account, on purpose: seeing the
/// camera count your own push-ups is what makes the subscription worth it.
enum _Step {
  welcome,
  race,
  reps,
  climb,
  fight,
  before,
  camera,
  placement,
  framing,
  calibration,
  calibrated,
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  _Step _step = _Step.welcome;

  bool? _over13;
  bool _healthAccepted = false;
  CalibrationResult _calibration = const CalibrationResult(
    reps: 0,
    averageDepth: 0,
    clean: true,
  );

  void _go(_Step next) => setState(() => _step = next);

  /// The bar is for the steps a lifter reads. The welcome screen has not
  /// started anything yet, and the two camera steps need the whole screen
  /// for the body being framed and counted.
  bool get _showsProgress =>
      _step != _Step.welcome &&
      _step != _Step.framing &&
      _step != _Step.calibration;

  /// The step before this one, for the back button and the system back
  /// gesture. Without it, back on any step closed the app, and opening it
  /// again started over at the welcome screen.
  void _back() {
    if (_step.index == 0) return;
    _go(_Step.values[_step.index - 1]);
  }

  Future<void> _finish() async {
    // No tier, no record, no history. A new account has earned none of it.
    //
    // Guarded, because this one line is destructive and the screen it sits
    // on is still reachable directly — the preview opens routes by name, and
    // `/` is one of them. An account that already exists keeps everything;
    // there is nothing here worth clearing it for.
    if (!onboarded) await Career.instance.startFresh();

    // The calibration set was still push-ups the lifter actually did, so it
    // counts towards their totals and their streak even though it was not a
    // duel.
    await Career.instance.recordPractice(_calibration.reps);
    await markOnboarded();

    if (!mounted) return;
    // A brand-new account sees what else there is before its first duel:
    // titles, and a friend code that is real now that the account exists.
    // Nothing to pay first: the app is free, and Pro only takes the ads out.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WelcomeInsideScreen(
          onDone: (inner) => Navigator.of(inner).pushReplacement(
            MaterialPageRoute(builder: (_) => const AppShell()),
          ),
        ),
      ),
    );
  }

  /// Where signing into an existing account ends, instead of [_finish].
  ///
  /// That account already has a rank, a record and a history — everything
  /// [_finish] exists to set up from nothing, and everything [startFresh]
  /// would zero right back out if this went through the same door. Only the
  /// calibration set just done on this device, if any, is genuinely new.
  Future<void> _finishAfterSignIn() async {
    await Career.instance.recordPractice(_calibration.reps);
    await markOnboarded();

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AppShell()));
  }

  /// The gate at the end of the flow: no duel, this device's own placements
  /// included, is reachable without going through it.
  Future<void> _openAuthGate() async {
    // Made already, with Apple or Google from the welcome screen's log-in:
    // nothing to sign up for at the end.
    if (_accountMade) {
      await _finish();
      return;
    }
    final outcome = await Navigator.of(context).push<AuthOutcome>(
      MaterialPageRoute(builder: (_) => const AuthEntryScreen()),
    );
    switch (outcome) {
      case AuthOutcome.signedUp:
        await _finish();
      case AuthOutcome.signedIn:
        await _finishAfterSignIn();
      case null:
      // Backed all the way out without finishing either. Stay on the
      // calibration result rather than assume which one was meant.
    }
  }

  /// The welcome screen's "I already have an account" — a returning lifter
  /// has no reason to redo a camera check or a calibration set for an
  /// account that already has its own range on file, so this skips straight
  /// to signing in rather than joining the rest of the flow at its end.
  Future<void> _directLogIn() async {
    // The same Apple and Google buttons the end of the flow offers: they sign
    // an existing account back in, or make a new one.
    final outcome = await Navigator.of(context).push<AuthOutcome>(
      MaterialPageRoute(builder: (_) => const AuthEntryScreen()),
    );
    switch (outcome) {
      case AuthOutcome.signedIn:
        await _finishAfterSignIn();
      case AuthOutcome.signedUp:
        // Apple or Google made a new account from the log-in page. It still
        // needs what every new account does — the age check, the camera,
        // the calibration — so the flow carries on from the welcome, and its
        // end skips the sign-up it no longer needs. It used to land back on
        // the welcome as if nothing had happened.
        setState(() => _accountMade = true);
        _go(_Step.race);
      case null:
        break;
    }
  }

  /// A new account was made from the welcome screen's log-in.
  bool _accountMade = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == _Step.welcome,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Back on every step but the first, the camera steps included:
              // the system gesture did this already, but nothing on the
              // screen said it could be done, and an iPhone has no back key.
              if (_step != _Step.welcome)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(4, 2, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        key: const Key('onboardingBack'),
                        onPressed: _back,
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).backButtonTooltip,
                        color: context.colors.text,
                        icon: const BackButtonIcon(),
                      ),
                      if (_showsProgress)
                        Expanded(
                          child: _Progress(
                            done: _step.index,
                            of: _Step.values.length - 1,
                          ),
                        ),
                    ],
                  ),
                ),
              Expanded(
                child: _StepArrives(
                  key: ValueKey(_step),
                  child: switch (_step) {
                  _Step.welcome => _Welcome(
                    onStart: () => _go(_Step.race),
                    onSignIn: _directLogIn,
                  ),
                  _Step.race => _Idea(card: 0, onNext: () => _go(_Step.reps)),
                  _Step.reps => _Idea(card: 1, onNext: () => _go(_Step.climb)),
                  _Step.climb => _Idea(
                    card: 2,
                    onNext: () => _go(_Step.fight),
                  ),
                  _Step.fight => _Idea(
                    card: 3,
                    onNext: () => _go(_Step.before),
                  ),
                  _Step.before => _BeforeYouStart(
                    over13: _over13,
                    healthAccepted: _healthAccepted,
                    onAge: (v) => setState(() => _over13 = v),
                    onHealth: (v) => setState(() => _healthAccepted = v),
                    onNext: () => _go(_Step.camera),
                  ),
                  _Step.camera => _CameraAsk(
                    onNext: () => _go(_Step.placement),
                  ),
                  _Step.placement => PlacementStep(
                    onNext: () => _go(_Step.framing),
                  ),
                  _Step.framing => _FramingCheck(
                    poseSource: widget.poseSource,
                    onNext: () => _go(_Step.calibration),
                  ),
                  _Step.calibration => _Calibration(
                    poseSource: widget.poseSource,
                    onDone: (result) {
                      setState(() => _calibration = result);
                      _go(_Step.calibrated);
                    },
                  ),
                  _Step.calibrated => _Calibrated(
                    result: _calibration,
                    // Straight on to the account: the calibration set was the
                    // last thing the app had to show before asking for one.
                    onNext: _openAuthGate,
                  ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── shared furniture ──────────────────────────────

/// A step coming on: in from the side and up to full strength, so moving on
/// reads as moving on rather than as the screen being swapped.
class _StepArrives extends StatelessWidget {
  const _StepArrives({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(28 * (1 - t), 0),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

/// How far through the steps this is: one thin segment per step, lit up to
/// and including the current one.
class _Progress extends StatelessWidget {
  const _Progress({required this.done, required this.of});

  final int done;
  final int of;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$done / $of',
      child: Row(
        children: [
          for (var i = 1; i <= of; i++) ...[
            if (i > 1) const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i <= done
                      ? context.colors.brand
                      : context.colors.border,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The filled button every step ends on.
class _Primary extends StatelessWidget {
  const _Primary({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final on = onTap != null;
    return PressScale(
      child: SizedBox(
      width: double.infinity,
      child: Material(
        color: on ? context.colors.brand : context.colors.surfaceRaised,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: on ? context.colors.background : context.colors.faint,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

/// The quieter second way off a step.
class _Secondary extends StatelessWidget {
  const _Secondary({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(color: context.colors.muted, fontSize: 15),
          ),
        ),
      ),
    );
  }
}

/// A step's scrolling body with its actions pinned underneath.
///
/// Pinned rather than trailing the scroll: at 1.6x text every one of these
/// steps is taller than a phone, and a Continue button that has to be scrolled
/// to reads as a dead end.
class _Step0 extends StatelessWidget {
  const _Step0({
    required this.body,
    required this.actions,
    this.centred = false,
  });

  final Widget body;
  final Widget actions;

  /// Sits in the middle of the space above the buttons instead of at the
  /// top. For the steps with little to say, which otherwise left two thirds
  /// of the screen empty under a few lines. Still scrolls when a large text
  /// size makes it taller than the screen.
  final bool centred;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: centred
              ? LayoutBuilder(
                  builder: (context, box) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: box.maxHeight),
                      child: Center(child: body),
                    ),
                  ),
                )
              : SingleChildScrollView(child: body),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
          child: actions,
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: child,
    );
  }
}

// ──────────────────────────────── 1 welcome ──────────────────────────────────

class _Welcome extends StatelessWidget {
  const _Welcome({required this.onStart, required this.onSignIn});

  final VoidCallback onStart;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _Step0(
      centred: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(34, 24, 34, 24),
        child: Column(
          children: [
            // The brand asset, mark and wordmark together, rather than a
            // drawn copy of them. Transparent, so it sits on the page in
            // either theme rather than carrying its own black square.
            PopIn(
              child: Image.asset(
                'assets/images/logo-wordmark.png',
                width: 240,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 18),
            TypeOut(
              l.obTagline,
              delay: const Duration(milliseconds: 350),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 17,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
      actions: Column(
        children: [
          _Primary(label: l.obGetStarted, onTap: onStart),
          const SizedBox(height: 8),
          _Secondary(label: l.obHaveAccount, onTap: onSignIn),
        ],
      ),
    );
  }
}

// ──────────────────────────────── 2 the idea ─────────────────────────────────

/// What the app is, as three cards swiped through on one step: who you race,
/// what counts as a rep, and what winning is for. The first shows a live
/// match the way it looks; the second the depth bar's two lines, the one rule
/// a new lifter needs before their first set; the third the ladder and, for
/// training alone, Adventure. It used to be three lines of text beside icons,
/// which said what the app was without showing any of it.
///
/// One step still, so the bar above does not grow by three.
/// One of the idea's four cards, a step of its own: who you race, what
/// counts, what you climb, and the Adventure. Next on the first three,
/// Continue on the last.
class _Idea extends StatelessWidget {
  const _Idea({required this.card, required this.onNext});

  static const _count = 4;

  final int card;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      children: [
        Expanded(
          child: switch (card) {
              0 => _IdeaPage(
                title: l.obRaceTitle,
                body: l.obRaceBody,
                // A live match as it looks from the floor: both counts, the
                // clock, the depth bar and the line over the lifter's arms.
                picture: const _Screenshot('assets/images/onboarding_live.jpg'),
              ),
              1 => _IdeaPage(
                title: l.obRepsTitle,
                body: l.obRepsBody,
                picture: const _RepRule(),
                footer: _Panel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '+1',
                        style: TextStyle(
                          color: context.colors.text,
                          fontSize: 40,
                          height: 1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          l.obRepsBoth,
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 14.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              2 => _IdeaPage(
                title: l.obClimbTitle,
                body: l.obClimbBody,
                // The two cards of the picked design (B2, 2026-11-03): the
                // seven tiers' badges, Iron to Master, each a step higher; and what a
                // match does to the rating. Every number is the ranking
                // code's own. Scaled down, not cut, where the page is short.
                picture: LayoutBuilder(
                  builder: (context, box) => FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: box.maxWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ClimbCard(
                            title: l.obSevenTiers,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var tier = 0; tier < kTiers.length; tier++)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height:
                                                (kTiers.length - 1 - tier) * 9.0,
                                          ),
                                          // The tier's own badge (the user's
                                          // pick, 2026-11-04), wider than its
                                          // column so the wings overlap the
                                          // next one's, as on the ladder.
                                          SizedBox(
                                            height: 56,
                                            child: OverflowBox(
                                              maxWidth: 64,
                                              maxHeight: 64,
                                              child: TierBadge(
                                                tierIndex: tier,
                                                size: 64,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              tierName(l, tier),
                                              style: TextStyle(
                                                color: context.colors.muted,
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          _ClimbCard(
                            title: l.obRatingPerMatch,
                            child: Column(
                              children: [
                                _ClimbRow(
                                  label: l.obWinLabel,
                                  value: l.obWinRating(
                                    localNumber(context, kWinRating),
                                  ),
                                  colour: AppColors.success,
                                ),
                                Divider(height: 1, color: context.colors.border),
                                _ClimbRow(
                                  label: l.obLossLabel,
                                  value: l.obLossRating(
                                    localNumber(context, kLossRating),
                                  ),
                                  colour: context.colors.rival,
                                ),
                                Divider(height: 1, color: context.colors.border),
                                _ClimbRow(
                                  label: l.obFloorLabel,
                                  value: l.obNeverBelow(
                                    localNumber(context, kRatingStart),
                                  ),
                                  colour: context.colors.text,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                footer: Center(
                  child: Text(
                    l.obDivisionLine(
                      localNumber(context, kRatingPerDivision),
                      localNumber(
                        context,
                        kRatingPerDivision * kDivisions.length,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.muted,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
              // Adventure, its own card (the user, 2026-10-28, mockup A): a
              // fight under way, the seven worlds' Kings, and what stars buy.
              _ => _IdeaPage(
                title: l.obFightTitle,
                body: l.obFightBody,
                // The fight as the camera shows it: the lifter in the black
                // t-shirt under the new skeleton, the weapon just landing.
                picture: const _Screenshot(
                  'assets/images/onboarding_adventure.jpg',
                ),
                footer: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.obSevenWorlds(
                        tierName(l, 0),
                        tierName(l, kTiers.length - 1),
                      ),
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (var world = 0; world < kWorlds; world++) ...[
                          if (world > 0) const SizedBox(width: 6),
                          Expanded(child: _WorldKing(world: world)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: _Panel(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.obWeaponsTitle,
                              style: TextStyle(
                                color: context.colors.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l.obWeaponsBody,
                              style: TextStyle(
                                color: context.colors.muted,
                                fontSize: 14.5,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          child: _Primary(
            label: card == _count - 1 ? l.continueLabel : l.obNext,
            onTap: onNext,
          ),
        ),
      ],
    );
  }
}

/// One card: its title and its line, the picture under them taking whatever
/// height is left, and anything that goes beneath. It scrolls only when a
/// large text size needs the room.
/// One of the climb page's two cards: a small coloured heading over what it
/// holds.
class _ClimbCard extends StatelessWidget {
  const _ClimbCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: context.colors.rival,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// A line of the rating card: what happens, and what it does to the rating.
class _ClimbRow extends StatelessWidget {
  const _ClimbRow({
    required this.label,
    required this.value,
    required this.colour,
  });

  final String label;
  final String value;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: context.colors.text, fontSize: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                value,
                style: TextStyle(
                  color: colour,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdeaPage extends StatelessWidget {
  const _IdeaPage({
    required this.title,
    required this.body,
    required this.picture,
    this.footer,
  });

  final String title;
  final String body;
  final Widget picture;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final after = TypeOut.lengthOf(title);

    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypeOut(
                    title,
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 34,
                      height: 1.18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RiseIn(
                    delay: after,
                    child: Text(
                      body,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: _Fill(
                      child: RiseIn(
                        delay: after + const Duration(milliseconds: 120),
                        child: picture,
                      ),
                    ),
                  ),
                  if (footer case final footer?) ...[
                    const SizedBox(height: 18),
                    RiseIn(
                      delay: after + const Duration(milliseconds: 240),
                      child: footer,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Takes the height it is given and asks for none of its own, so a card's
/// picture shrinks to fit rather than making the card scroll — a photo's own
/// height, asked for, is the whole height of the photo. A layout delegate's
/// box has no size of its own until it is handed one, so asked, it says none.
class _Fill extends StatelessWidget {
  const _Fill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      CustomSingleChildLayout(delegate: const _FillLayout(), child: child);
}

/// All the room there is, for the box and for what is in it.
class _FillLayout extends SingleChildLayoutDelegate {
  const _FillLayout();

  @override
  bool shouldRelayout(_FillLayout oldDelegate) => false;
}

/// One of the idea's pictures: a screen of the app as a phone shows it,
/// whole, rounded, in the brand's glow. 880 × 1912, as both are drawn.
class _Screenshot extends StatelessWidget {
  const _Screenshot(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 880 / 1912,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: context.colors.border),
            boxShadow: [
              BoxShadow(
                color: context.colors.brand.withValues(alpha: 0.25),
                blurRadius: 36,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Image.asset(
              asset,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
        ),
      ),
    );
  }
}

/// One world's King, small, on its world's sky: the seven in a row are the
/// whole of the Adventure.
class _WorldKing extends StatelessWidget {
  const _WorldKing({required this.world});

  final int world;

  @override
  Widget build(BuildContext context) {
    final look = WorldLook.of(world);
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [look.sky, context.colors.surface],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: CustomPaint(
            painter: GolemPainter(
              level: AdventureLevel.of((world + 1) * kLevelsPerWorld),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

/// The match screen's depth bar, large, going through a rep on a loop: empty
/// on the way down, green and filling on the way back up, full is a rep. The
/// two steps are named at the ends of the bar they belong to, the one it is
/// working towards lit, and the bar's three colours under it (the user's pick
/// B, 2026-11-04 — it had two lines across it, as the match's bar once did).
class _RepRule extends StatefulWidget {
  const _RepRule();

  @override
  State<_RepRule> createState() => _RepRuleState();
}

class _RepRuleState extends State<_RepRule>
    with SingleTickerProviderStateMixin {
  late final _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3000),
  );

  /// Four reps, then the bar rests at the top: enough to read the rule by,
  /// and one that never stopped would keep the screen redrawing for as long
  /// as somebody sat on it.
  static const _reps = 4;
  int _repsShown = 0;

  @override
  void initState() {
    super.initState();
    _loop.addStatusListener((status) {
      if (status == AnimationStatus.completed && ++_repsShown < _reps) {
        _loop.forward(from: 0);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!reduceMotion(context) && _repsShown == 0 && !_loop.isAnimating) {
      _loop.forward();
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  /// Where the lifter is, as a share of lockout, and whether the bottom line
  /// has been passed on the way to the top one. The rep takes the first 2.2
  /// seconds; the bar rests at the top for the rest.
  (double, bool) _at(double t) {
    final move = (t * 3000 / 2200).clamp(0.0, 1.0);
    final dip = math.sin(math.pi * move);
    final share = 1 - 0.65 * dip * dip;
    // Down to the bottom line at 0.341 of the rep, up to the top one at 0.787.
    return (share, move > 0.341 && move < 0.787);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        // Still, part way down, for anybody who asked for less motion.
        final (share, pastBottom) =
            reduceMotion(context) ? (0.42, false) : _at(_loop.value);
        return LayoutBuilder(
          builder: (context, box) {
            // Room under the bar for the line of its colours.
            // Never less than nothing: the card can be squeezed to almost no
            // height (large text on a small phone).
            const legend = 40.0;
            final height = (box.maxHeight - legend).clamp(0.0, 380.0);
            final top = math.max(0.0, (box.maxHeight - legend - height) / 2);

            Widget step(double y, int n, String text, Color mark, bool next) {
              return Positioned(
                left: 76,
                right: 0,
                top: y - 20,
                height: 40,
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mark,
                      ),
                      child: Text(
                        '$n',
                        style: TextStyle(
                          color: context.colors.background,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: next
                                ? context.colors.text
                                : context.colors.muted,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            Widget colour(Color c, String text) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.colors.muted, fontSize: 13),
                  ),
                ),
              ],
            );

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 20,
                  top: top,
                  child: DepthBar(
                    progress: share,
                    good: true,
                    pastBottom: pastBottom,
                    height: height,
                  ),
                ),
                step(
                  top + 16,
                  2,
                  l.obRepsUp,
                  pastBottom ? AppColors.win : context.colors.muted,
                  pastBottom,
                ),
                step(
                  top + height - 16,
                  1,
                  l.obRepsDown,
                  pastBottom ? AppColors.win : AppColors.gold,
                  !pastBottom,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: top + height + 18,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      colour(context.colors.brand, l.obBarGoingDown),
                      colour(AppColors.win, l.obBarComingUp),
                      colour(context.colors.rival, l.obBarHandOff),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ───────────────────────────── 3 before you start ────────────────────────────

/// The age, and the health line. outrepd is for 13 and over (the user,
/// 2026-10-28: a 13+ rating, so the ads can be the ordinary kind), so the
/// question is Under 13 or 13 and over, as two big tiles; under 13 is told
/// so plainly and goes no further.
class _BeforeYouStart extends StatelessWidget {
  const _BeforeYouStart({
    required this.over13,
    required this.healthAccepted,
    required this.onAge,
    required this.onHealth,
    required this.onNext,
  });

  final bool? over13;
  final bool healthAccepted;
  final ValueChanged<bool> onAge;
  final ValueChanged<bool> onHealth;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final blocked = over13 == false;
    final ready = over13 == true && healthAccepted;
    final thirteen = localNumber(context, 13);
    final heading = TextStyle(
      color: colors.text,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );

    return _Step0(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypeOut(
              l.obTwoThings,
              style: TextStyle(
                color: colors.text,
                fontSize: 30,
                height: 1.18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            Text(l.obAgeQuestion, style: heading),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _AgeTile(
                      big: '<$thirteen',
                      label: l.obUnder13,
                      selected: over13 == false,
                      onTap: () => onAge(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AgeTile(
                      big: '$thirteen+',
                      label: l.obOver13,
                      selected: over13 == true,
                      onTap: () => onAge(true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (blocked)
              // Said plainly and without a way around it. An age gate with a
              // "continue anyway" under it is not an age gate.
              Text(
                l.obUnder13Blocked,
                style: TextStyle(color: colors.rival, fontSize: 16, height: 1.6),
              )
            else ...[
              Text(
                l.obFor13,
                style: TextStyle(color: colors.muted, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 30),
              Text(l.obBeforeYouLift, style: heading),
              const SizedBox(height: 12),
              Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => onHealth(!healthAccepted),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: healthAccepted ? colors.brand : colors.border,
                        width: healthAccepted ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: healthAccepted
                                ? colors.brand
                                : Colors.transparent,
                            border: Border.all(
                              color: healthAccepted
                                  ? colors.brand
                                  : colors.muted,
                              width: 1.5,
                            ),
                          ),
                          child: healthAccepted
                              ? Icon(
                                  Icons.check,
                                  size: 20,
                                  color: colors.background,
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            l.obHealthConsent,
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 16,
                              height: 1.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              LegalLine(
                style: TextStyle(
                  color: colors.muted,
                  fontSize: 13,
                  height: 1.6,
                ),
                linkStyle: TextStyle(color: colors.text),
              ),
            ],
          ],
        ),
      ),
      actions: _Primary(label: l.continueLabel, onTap: ready ? onNext : null),
    );
  }
}

/// One answer to the age question: the age large, and in words under it.
class _AgeTile extends StatelessWidget {
  const _AgeTile({
    required this.big,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String big;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.brand : colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: selected ? null : Border.all(color: colors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  big,
                  style: TextStyle(
                    color: selected ? colors.background : colors.text,
                    fontSize: 34,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? colors.background : colors.muted,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────── 4 camera ───────────────────────────────────

class _CameraAsk extends StatelessWidget {
  const _CameraAsk({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _Step0(
      centred: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 14),
        child: Column(
          children: [
            // The camera, lit: what is being asked for, before the words
            // that say why. A picture of a set sat here; the user took it
            // out (2026-10-28).
            Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.surfaceRaised,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.brand.withValues(alpha: 0.22),
                    blurRadius: 60,
                  ),
                ],
              ),
              child: Icon(
                Icons.photo_camera,
                size: 64,
                color: context.colors.brand,
              ),
            ),
            const SizedBox(height: 32),
            TypeOut(
              l.obCameraTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 30,
                height: 1.18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l.obCameraBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 16,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 26),
            // The answer to the question everybody actually has when an app
            // wants their camera, on the screen that asks for it rather than
            // in a policy nobody opens.
            _Panel(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: context.colors.brand,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.obCameraPrivateTitle,
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l.obCameraPrivateBody,
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 14,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: Column(
        children: [
          // "Continue", not "Allow": the system asks the question, this
          // screen only says why (App Review, guideline 5.1.1(iv), 1.1.5).
          _Primary(label: l.continueLabel, onTap: onNext),
          const SizedBox(height: 6),
          _Secondary(
            label: l.obWhyNeeded,
            onTap: () => showDialog<void>(
              context: context,
              builder: (c) => AlertDialog(
                backgroundColor: context.colors.surface,
                // More than the line already on the screen behind it: the
                // question is asked by somebody that line did not convince.
                content: Text(
                  l.obWhyNeededBody,
                  style: TextStyle(color: context.colors.text),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: Text(l.obGotIt),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── 5 placement ─────────────────────────────────

/// Public only so tool/screenshots can draw this one step on its own.
class PlacementStep extends StatelessWidget {
  const PlacementStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _Step0(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypeOut(
              l.obPlacementTitle,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 30,
                height: 1.18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l.obPlacementBody,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 16,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 18),
            // What the phone should see from the floor: a lifter, head to
            // hands, inside the frame's corners. It used to be a drawing of
            // a stick figure on a side view, which said where the phone goes
            // but not what it is looking for.
            AspectRatio(
              aspectRatio: 1104 / 991,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: context.colors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/onboarding_view.jpg',
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 50, 16, 14),
                        child: CustomPaint(
                          painter: _Corners(context.colors.brand),
                        ),
                      ),
                      PositionedDirectional(
                        start: 12,
                        top: 12,
                        end: 12,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.background.withValues(
                                alpha: 0.82,
                              ),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Text(
                              l.obPhoneSees,
                              style: TextStyle(
                                color: context.colors.text,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l.obPhoneSeesBody,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 14.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            _Check(icon: Icons.accessibility_new, label: l.obCheckHandsFeet),
            _Check(icon: Icons.face_outlined, label: l.obCheckFacing),
            _Check(icon: Icons.lightbulb_outline, label: l.obCheckLight),
          ],
        ),
      ),
      actions: _Primary(label: l.obImSetUp, onTap: onNext),
    );
  }
}

/// One thing to check before the camera opens: its icon in a disc, and the
/// line, under a hairline.
class _Check extends StatelessWidget {
  const _Check({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.colors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.surfaceRaised,
            ),
            child: Icon(icon, size: 20, color: context.colors.brand),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: context.colors.text, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// The four corners of a camera's frame, in the app's cream.
class _Corners extends CustomPainter {
  const _Corners(this.colour);

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    const arm = 26.0;
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(0, arm)
      ..lineTo(0, 0)
      ..lineTo(arm, 0)
      ..moveTo(w - arm, 0)
      ..lineTo(w, 0)
      ..lineTo(w, arm)
      ..moveTo(w, h - arm)
      ..lineTo(w, h)
      ..lineTo(w - arm, h)
      ..moveTo(arm, h)
      ..lineTo(0, h)
      ..lineTo(0, h - arm);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = colour,
    );
  }

  @override
  bool shouldRepaint(_Corners old) => old.colour != colour;
}

// ─────────────────────── 6 and 7: the camera is open ─────────────────────────

/// The camera, the skeleton, and whatever the step needs on top of it.
class _CameraStage extends StatefulWidget {
  const _CameraStage({
    required this.builder,
    required this.onPose,
    this.poseSource,
    this.good = true,
  });

  /// Drawn over the preview.
  final Widget Function(BuildContext context, BodyPose pose) builder;
  final void Function(BodyPose pose) onPose;
  final PoseSource Function()? poseSource;

  /// The skeleton bright, or faint while the step is still waiting on the
  /// lifter — as on the camera screen.
  final bool good;

  @override
  State<_CameraStage> createState() => _CameraStageState();
}

class _CameraStageState extends State<_CameraStage>
    with WidgetsBindingObserver {
  PoseSource? _source;
  StreamSubscription<BodyPose>? _sub;
  BodyPose _pose = BodyPose.empty;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Nobody touches the phone while it watches them.
    keepScreenOn(true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    keepScreenOn(false);
    _sub?.cancel();
    _source?.dispose();
    super.dispose();
  }

  /// The camera does not come back by itself after the app has been away —
  /// a call, the notification shade — so it is let go on the way out and
  /// opened again on the way back, as on the camera screen.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive || AppLifecycleState.paused:
        final source = _source;
        if (source == null) return;
        _sub?.cancel();
        _sub = null;
        _source = null;
        source.dispose();
        if (mounted) setState(() {});
      case AppLifecycleState.resumed:
        if (_source == null && _sub == null && !_starting) _start();
      default:
        break;
    }
  }

  /// True while a camera is being opened, so a resume arriving mid-start
  /// does not open a second one.
  bool _starting = false;

  Future<void> _start() async {
    if (_starting) return;
    _starting = true;
    final source = widget.poseSource?.call() ?? createPoseSource();
    try {
      await source.start();
    } on Object {
      // The camera screen owns the refusal states; here the step simply has
      // nothing to draw, and the checklist stays unticked.
      _starting = false;
      return;
    }
    _starting = false;
    if (!mounted) {
      await source.dispose();
      return;
    }
    _sub = source.poses.listen((pose) {
      if (!mounted) return;
      setState(() => _pose = pose);
      widget.onPose(pose);
    });
    setState(() => _source = source);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _source?.buildPreview(context) ??
            ColoredBox(color: context.colors.surfaceRaised),
        CustomPaint(
          painter: SkeletonPainter(
            pose: _pose,
            good: widget.good,
            mirror: _source?.isLive ?? false,
            sourceSize: _source?.sourceSize,
          ),
        ),
        widget.builder(context, _pose),
      ],
    );
  }
}

/// Whether the camera can see the joints a push-up is measured between.
bool _sees(BodyPose pose, List<Joint> joints) =>
    joints.any((j) => pose.confident(j) != null);

class _FramingCheck extends StatefulWidget {
  const _FramingCheck({required this.onNext, this.poseSource});

  final VoidCallback onNext;
  final PoseSource Function()? poseSource;

  @override
  State<_FramingCheck> createState() => _FramingCheckState();
}

class _FramingCheckState extends State<_FramingCheck> {
  BodyPose _pose = BodyPose.empty;

  bool get _core =>
      _sees(_pose, [Joint.leftShoulder, Joint.rightShoulder]) &&
      _sees(_pose, [Joint.leftHip, Joint.rightHip]);
  bool get _wrists => _sees(_pose, [Joint.leftWrist, Joint.rightWrist]);

  /// What the counter reads, and nothing it does not: not the ankles, which
  /// a phone on the floor facing the lifter hides in most frames, so asking
  /// for them only sent people backing the phone away to get their feet in.
  bool get _ready => _core && _wrists;

  /// Since when the whole body has been in view without a break.
  DateTime? _readySince;
  bool _movedOn = false;

  /// How long the whole body has to stay in view before the step moves on by
  /// itself. The lifter is on the floor a metre from the phone; reaching over
  /// to press a button means getting up and coming back. A moment of it, not
  /// the first frame, so a body passing through the frame on its way down
  /// does not skip the check.
  static const _hold = Duration(milliseconds: 1200);

  void _onPose(BodyPose pose) {
    setState(() => _pose = pose);
    if (_movedOn) return;
    if (!_ready) {
      _readySince = null;
      return;
    }
    final now = clock.now();
    _readySince ??= now;
    if (now.difference(_readySince!) >= _hold) _moveOn();
  }

  void _moveOn() {
    if (_movedOn) return;
    _movedOn = true;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _CameraStage(
      poseSource: widget.poseSource,
      onPose: _onPose,
      good: _ready,
      builder: (context, _) => Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.background.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.obFramingTitle,
                    style: TextStyle(color: context.colors.text, fontSize: 15),
                  ),
                  // Two ticks rather than one verdict: somebody whose hands
                  // are out of shot is told which part to bring in.
                  _Mark(l.obFramingShoulders, on: _core),
                  _Mark(l.obFramingWrists, on: _wrists),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 22,
            // Still there for anybody who would rather not wait the moment.
            child: _Primary(
              label: l.obLooksGood,
              onTap: _ready ? _moveOn : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Mark extends StatelessWidget {
  const _Mark(this.label, {required this.on});

  final String label;
  final bool on;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          Icon(
            on ? Icons.check : Icons.remove,
            size: 14,
            color: on ? AppColors.win : context.colors.faint,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: on ? context.colors.text : context.colors.muted,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────── 7 calibration ─────────────────────────────────

/// What the calibration set measured.
///
/// Read off the set rather than written down: the screen after this one
/// reports a depth and a verdict on form, and those have to come from the reps
/// the lifter just did. A fixed "94%" on that card is a number the app made up
/// about somebody's body.
class CalibrationResult {
  const CalibrationResult({
    required this.reps,
    required this.averageDepth,
    required this.clean,
  });

  final int reps;

  /// Mean of how far down each counted rep went, where 1 is the bottom of the
  /// range the set itself established.
  final double averageDepth;

  /// Whether every rep passed the form rules.
  final bool clean;
}

class _Calibration extends StatefulWidget {
  const _Calibration({required this.onDone, this.poseSource});

  final ValueChanged<CalibrationResult> onDone;
  final PoseSource Function()? poseSource;

  @override
  State<_Calibration> createState() => _CalibrationState();
}

class _CalibrationState extends State<_Calibration> {
  /// The same tracker the camera screen runs, for the count and the bar both.
  /// One counter for the whole app: a calibration that counted differently
  /// from the match would be teaching the lifter the wrong thing about their
  /// own reps before they ever got to one.
  final _tracker = PushupTracker();

  /// Time since the camera opened. Poses carry no timestamp of their own, and
  /// the tracker judges everything in milliseconds, not frames.
  final _clock = clock.stopwatch()..start();

  int _reps = 0;
  double _depth = 0;
  double _progress = 0;
  bool _done = false;

  /// This rep has been down past the bottom line, so the top one is next:
  /// the bar goes green for the way back up, as it does in a match.
  bool _pastBottom = false;

  /// The hands are on the floor, by the tracker's own test.
  bool _planted = false;

  /// The match screen's own "ready", for the bar and the skeleton: down in
  /// position until the count starts, then the one thing the count itself
  /// requires — the hands on the floor. Red on the bar when they are not.
  bool get _ready => _counting ? _planted : downInPosition(_recent);

  /// The count has started. Until then the tracker only watches — as on the
  /// camera screen before its countdown ends — learning where the hands are
  /// planted and how high this lifter's lockout is, so the first rep is
  /// judged against them and not against a guess. It used to count from the
  /// camera's first frame, which judged the first rep blind and was why the
  /// three here read worse than a match did.
  bool _counting = false;

  /// The last second or so of poses, for whether the lifter is down in
  /// position — the camera screen's own check.
  final _recent = <BodyPose>[];

  /// Since when a whole body has been in shot, in [_clock] milliseconds.
  int? _framedSince;

  /// How long a framed body waits for the position check before the count
  /// starts anyway: the camera screen's grace, so an angle where the position
  /// never registers cannot leave a new lifter stuck here.
  static const _positionGrace = Duration(seconds: 8);

  void _onPose(BodyPose pose) {
    if (_done) return;
    if (!mounted) return;

    final atMs = _clock.elapsedMilliseconds;
    final reading = _tracker.add(atMs, pose);
    _recent.add(pose);
    if (_recent.length > 40) _recent.removeAt(0);

    if (!_counting) {
      if (framedForPushUp(pose)) {
        _framedSince ??= atMs;
      } else {
        _framedSince = null;
      }
      final waited =
          _framedSince != null &&
          atMs - _framedSince! >= _positionGrace.inMilliseconds;
      if (downInPosition(_recent) || waited) {
        // From nothing, keeping all it has learned; a rep already on its way
        // up does not count.
        _tracker.restartCount(atMs);
        tap();
        Sounds.instance.play(Cue.go);
        _counting = true;
      }
      setState(() {
        _progress = reading.progress ?? _progress;
        _planted = reading.planted;
      });
      return;
    }

    if (reading.counted) {
      _reps = reading.reps;
      _depth = _tracker.depth;
      tap(heavy: true);
      Sounds.instance.play(Cue.rep);
    }

    setState(() {
      _progress = reading.progress ?? _progress;
      _pastBottom = reading.pastBottom;
      _planted = reading.planted;
    });

    if (_reps >= kCalibrationReps) {
      _done = true;
      widget.onDone(
        CalibrationResult(
          reps: _reps,
          averageDepth: _depth,
          // Clean means the reps were the same depth as each other, which is
          // something this can actually see. The old rule asked a form gate
          // about a knee, and on a phone on the floor the knee is visible in a
          // quarter of frames.
          clean: _depth >= 0.8,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _CameraStage(
      poseSource: widget.poseSource,
      onPose: _onPose,
      good: _ready,
      builder: (context, _) => Stack(
        children: [
          Positioned(
            top: 14,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: context.colors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.colors.border, width: 0.5),
              ),
              child: Column(
                children: [
                  Text(
                    l.obCalibrating.toUpperCase(),
                    style: TextStyle(
                      color: context.colors.muted,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    localNumber(context, _reps),
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 46,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < kCalibrationReps; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        Container(
                          width: 40,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: i < _reps
                                ? context.colors.brand
                                : context.colors.surfaceRaised,
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Until the count starts, the position. Then nothing: the
                  // bar and the cue under it say what to do, as in a match.
                  if (!_counting) ...[
                    const SizedBox(height: 10),
                    Text(
                      l.getIntoPosition,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.colors.muted, fontSize: 15),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // The match's own bar, where the match has it — once the count is
          // on: empty at the bottom of a rep, full at the top, green on the
          // way back up, red with a hand off the floor (the user, 2026-11-04:
          // the same bar as the live match, counting only real push-ups).
          if (_counting)
            PositionedDirectional(
              start: 8,
              top: 220,
              child: DepthBar(
                key: const Key('depthBar'),
                progress: _progress,
                good: _ready,
                pastBottom: _pastBottom,
              ),
            ),
          // The cue to go down or up, once there is a count for it to serve.
          if (_counting)
          Positioned(
            left: 0,
            right: 0,
            bottom: 22,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: context.colors.background.withValues(alpha: 0.68),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Text(
                  _progress < 0.5 ? l.goUp : l.goDown,
                  style: TextStyle(color: context.colors.text, fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────── 8 it works ───────────────────────────────────

class _Calibrated extends StatelessWidget {
  const _Calibrated({required this.result, required this.onNext});

  final CalibrationResult result;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _Step0(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 40, 22, 0),
        child: Column(
          children: [
            PopIn(
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.brand,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.brand.withValues(alpha: 0.35),
                      blurRadius: 50,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 76,
                  color: context.colors.background,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l.obCalibrated,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l.obCalibratedBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 16,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 28),
            // Three numbers side by side, the same height whatever wraps.
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Stat(localNumber(context, result.reps), l.obRepsCounted),
                  const SizedBox(width: 10),
                  _Stat(
                    '${localNumber(context, (result.averageDepth * 100).round())}%',
                    l.obAverageDepth,
                  ),
                  const SizedBox(width: 10),
                  _Stat(
                    result.clean ? l.obFormClean : l.obFormMixed,
                    l.obForm,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: _Primary(label: l.continueLabel, onTap: onNext),
    );
  }
}


/// One number of the calibration's three, large, with what it is under it.
class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _Panel(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 30,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
