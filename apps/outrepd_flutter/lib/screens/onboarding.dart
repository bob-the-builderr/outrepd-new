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

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../reps/pose.dart';
import '../reps/pose_source.dart';
import '../reps/pushup_counter.dart';
import '../reps/skeleton.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../widgets.dart';
import 'auth_entry.dart';
import 'match_flow.dart';
import 'paywall.dart';
import 'shell.dart';
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

enum _Step {
  welcome,
  howItWorks,
  duel,
  ladder,
  before,
  camera,
  placement,
  framing,
  calibration,
  calibrated,
  placements,
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  _Step _step = _Step.welcome;

  bool? _over16;
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

  /// The step before this one, for the system back gesture. Without it, back
  /// on any step closed the app, and opening it again started over at the
  /// welcome screen.
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
    //
    // Behind the paywall, which comes straight after signing up: the welcome
    // is to the app, and the app is the subscription. The shell's own gate
    // then lets a subscriber straight through.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PaywallGate(
          child: WelcomeInsideScreen(
            onDone: (inner) => Navigator.of(inner).pushReplacement(
              MaterialPageRoute(builder: (_) => const AppShell()),
            ),
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
    final outcome = await Navigator.of(context).push<AuthOutcome>(
      MaterialPageRoute(builder: (_) => const AuthEntryScreen()),
    );
    switch (outcome) {
      case AuthOutcome.signedUp:
        await _finish();
      case AuthOutcome.signedIn:
        await _finishAfterSignIn();
      case null:
      // Backed all the way out without finishing either. Stay on
      // placements rather than assume which one was meant.
    }
  }

  /// The welcome screen's "I already have an account" — a returning lifter
  /// has no reason to redo a camera check or a calibration set for an
  /// account that already has its own range on file, so this skips straight
  /// to signing in rather than joining the rest of the flow at its end.
  Future<void> _directLogIn() async {
    final outcome = await Navigator.of(
      context,
    ).push<AuthOutcome>(MaterialPageRoute(builder: (_) => const LoginScreen()));
    if (outcome == AuthOutcome.signedIn) await _finishAfterSignIn();
  }

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
              if (_showsProgress)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: _Progress(
                    done: _step.index,
                    of: _Step.values.length - 1,
                  ),
                ),
              Expanded(
                child: switch (_step) {
                  _Step.welcome => _Welcome(
                    onStart: () => _go(_Step.howItWorks),
                    onSignIn: _directLogIn,
                  ),
                  _Step.howItWorks => _HowItWorks(
                    onNext: () => _go(_Step.duel),
                  ),
                  _Step.duel => _DuelExplainer(onNext: () => _go(_Step.ladder)),
                  _Step.ladder => _Ladder(onNext: () => _go(_Step.before)),
                  _Step.before => _BeforeYouStart(
                    over16: _over16,
                    healthAccepted: _healthAccepted,
                    onAge: (v) => setState(() => _over16 = v),
                    onHealth: (v) => setState(() => _healthAccepted = v),
                    onNext: () => _go(_Step.camera),
                  ),
                  _Step.camera => _CameraAsk(
                    onNext: () => _go(_Step.placement),
                  ),
                  _Step.placement => _Placement(
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
                    onNext: () => _go(_Step.placements),
                  ),
                  _Step.placements => _Placements(
                    onStart: _openAuthGate,
                    onPractice: _openAuthGate,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── shared furniture ──────────────────────────────

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
    return SizedBox(
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
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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
            style: TextStyle(color: context.colors.muted, fontSize: 13),
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

class _Title extends StatelessWidget {
  const _Title(this.text, {this.body});

  final String text;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: context.colors.text,
            fontSize: 20,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (body case final body?) ...[
          const SizedBox(height: 9),
          Text(
            body,
            style: TextStyle(
              color: context.colors.muted,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
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

class _Tick extends StatelessWidget {
  const _Tick(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 14, color: context.colors.brand),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: context.colors.text, fontSize: 12),
            ),
          ),
        ],
      ),
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
            Image.asset(
              'assets/images/logo-wordmark.png',
              width: 240,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 18),
            Text(
              l.obTagline,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 15,
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

// ────────────────────────────── 2 how it works ───────────────────────────────

class _HowItWorks extends StatelessWidget {
  const _HowItWorks({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _Step0(
      centred: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.obHowTitle,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 24,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            _Numbered(1, l.obHow1, l.obHow1Body),
            _Numbered(2, l.obHow2, l.obHow2Body),
            _Numbered(3, l.obHow3, l.obHow3Body),
          ],
        ),
      ),
      actions: _Primary(label: l.continueLabel, onTap: onNext),
    );
  }
}

class _Numbered extends StatelessWidget {
  const _Numbered(this.n, this.title, this.body);

  final int n;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.surfaceRaised,
            ),
            child: Text(
              localNumber(context, n),
              style: TextStyle(color: context.colors.text, fontSize: 13),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────── 3 before you start ────────────────────────────

class _BeforeYouStart extends StatelessWidget {
  const _BeforeYouStart({
    required this.over16,
    required this.healthAccepted,
    required this.onAge,
    required this.onHealth,
    required this.onNext,
  });

  final bool? over16;
  final bool healthAccepted;
  final ValueChanged<bool> onAge;
  final ValueChanged<bool> onHealth;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final blocked = over16 == false;
    final ready = over16 == true && healthAccepted;

    return _Step0(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title(l.obTwoThings),
            const SizedBox(height: 22),
            _Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.obAgeQuestion,
                    style: TextStyle(color: context.colors.text, fontSize: 13),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      Expanded(
                        child: _Choice(
                          label: l.obUnder16,
                          selected: over16 == false,
                          onTap: () => onAge(false),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _Choice(
                          label: l.obOver16,
                          selected: over16 == true,
                          onTap: () => onAge(true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (blocked) ...[
              const SizedBox(height: 11),
              // Said plainly and without a way around it. An age gate with a
              // "continue anyway" under it is not an age gate.
              Text(
                l.obUnder16Blocked,
                style: TextStyle(
                  color: context.colors.rival,
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ] else ...[
              const SizedBox(height: 11),
              _Panel(
                child: InkWell(
                  onTap: () => onHealth(!healthAccepted),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 19,
                        height: 19,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: healthAccepted
                              ? context.colors.brand
                              : Colors.transparent,
                          border: Border.all(
                            color: healthAccepted
                                ? context.colors.brand
                                : context.colors.border,
                          ),
                        ),
                        child: healthAccepted
                            ? Icon(
                                Icons.check,
                                size: 13,
                                color: context.colors.background,
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l.obHealthConsent,
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 12,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 11,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(text: '${l.obTermsIntro} '),
                    TextSpan(
                      text: l.obTerms,
                      style: TextStyle(color: context.colors.text),
                    ),
                    TextSpan(text: ' ${l.obAnd} '),
                    TextSpan(
                      text: l.obPrivacy,
                      style: TextStyle(color: context.colors.text),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: _Primary(label: l.continueLabel, onTap: ready ? onNext : null),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: selected ? context.colors.brand : null,
          border: selected
              ? null
              : Border.all(color: context.colors.border, width: 0.5),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? context.colors.background
                  : context.colors.muted,
              fontSize: 12,
            ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 30, 22, 0),
            child: Column(
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  size: 38,
                  color: context.colors.brand,
                ),
                const SizedBox(height: 18),
                Text(
                  l.obCameraTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 20,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 11),
                Text(
                  l.obCameraBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 12,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            // The answer to the question everybody actually has when an app
            // wants their camera, on the screen that asks for it rather than
            // in a policy nobody opens.
            child: _Panel(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: context.colors.brand,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.obCameraPrivateTitle,
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.obCameraPrivateBody,
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 11,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: Column(
        children: [
          _Primary(label: l.allowCamera, onTap: onNext),
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

class _Placement extends StatelessWidget {
  const _Placement({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _Step0(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title(l.obPlacementTitle, body: l.obPlacementBody),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 220 / 130,
              child: CustomPaint(
                painter: _PlacementPainter(
                  line: context.colors.border,
                  body: context.colors.brand,
                  fill: context.colors.surfaceRaised,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.obOneMetre,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.muted, fontSize: 9),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l.obFullBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.muted, fontSize: 9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _Tick(l.obCheckHandsFeet),
            _Tick(l.obCheckFacing),
            _Tick(l.obCheckLight),
          ],
        ),
      ),
      actions: _Primary(label: l.obImSetUp, onTap: onNext),
    );
  }
}

/// A phone leaning on a wall, a gap, and somebody in a push-up.
class _PlacementPainter extends CustomPainter {
  const _PlacementPainter({
    required this.line,
    required this.body,
    required this.fill,
  });

  final Color line;
  final Color body;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 220;
    Offset p(double x, double y) => Offset(x * s, y * s);

    final flat = Paint()..color = line;
    // Floor and wall.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 104 * s, 220 * s, 3 * s),
        Radius.circular(1.5 * s),
      ),
      flat,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(6 * s, 52 * s, 4 * s, 54 * s),
        Radius.circular(2 * s),
      ),
      flat,
    );

    // The phone.
    final phone = RRect.fromRectAndRadius(
      Rect.fromLTWH(14 * s, 66 * s, 22 * s, 40 * s),
      Radius.circular(4 * s),
    );
    canvas.drawRRect(phone, Paint()..color = fill);
    canvas.drawRRect(
      phone,
      Paint()
        ..color = body
        ..strokeWidth = 1.5 * s
        ..style = PaintingStyle.stroke,
    );

    final limb = Paint()
      ..color = body
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Head, then the body in a push-up seen from the side.
    canvas.drawCircle(p(112, 70), 8 * s, limb);
    final path = Path()
      ..moveTo(p(92, 88).dx, p(92, 88).dy)
      ..lineTo(p(150, 88).dx, p(150, 88).dy)
      ..moveTo(p(92, 88).dx, p(92, 88).dy)
      ..lineTo(p(80, 104).dx, p(80, 104).dy)
      ..moveTo(p(150, 88).dx, p(150, 88).dy)
      ..lineTo(p(162, 104).dx, p(162, 104).dy)
      ..moveTo(p(100, 88).dx, p(100, 88).dy)
      ..lineTo(p(108, 100).dx, p(108, 100).dy)
      ..moveTo(p(142, 88).dx, p(142, 88).dy)
      ..lineTo(p(134, 100).dx, p(134, 100).dy)
      ..moveTo(p(108, 100).dx, p(108, 100).dy)
      ..lineTo(p(134, 100).dx, p(134, 100).dy);
    canvas.drawPath(path, limb);

    // The gap between phone and lifter.
    final dash = Paint()
      ..color = line
      ..strokeWidth = 1 * s
      ..style = PaintingStyle.stroke;
    for (var x = 40.0; x < 74; x += 6) {
      canvas.drawLine(
        p(x, 86 - (x - 40) * 0.23),
        p(x + 3, 86 - (x + 3 - 40) * 0.23),
        dash,
      );
      canvas.drawLine(
        p(x, 86 + (x - 40) * 0.29),
        p(x + 3, 86 + (x + 3 - 40) * 0.29),
        dash,
      );
    }
  }

  @override
  bool shouldRepaint(_PlacementPainter old) =>
      old.line != line || old.body != body || old.fill != fill;
}

// ─────────────────────── 6 and 7: the camera is open ─────────────────────────

/// The camera, the skeleton, and whatever the step needs on top of it.
class _CameraStage extends StatefulWidget {
  const _CameraStage({
    required this.builder,
    required this.onPose,
    this.poseSource,
  });

  /// Drawn over the preview.
  final Widget Function(BuildContext context, BodyPose pose) builder;
  final void Function(BodyPose pose) onPose;
  final PoseSource Function()? poseSource;

  @override
  State<_CameraStage> createState() => _CameraStageState();
}

class _CameraStageState extends State<_CameraStage> {
  PoseSource? _source;
  StreamSubscription<BodyPose>? _sub;
  BodyPose _pose = BodyPose.empty;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    _sub?.cancel();
    _source?.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final source = widget.poseSource?.call() ?? createPoseSource();
    try {
      await source.start();
    } on Object {
      // The camera screen owns the refusal states; here the step simply has
      // nothing to draw, and the checklist stays unticked.
      return;
    }
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
            good: true,
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
  bool get _ankles => _sees(_pose, [Joint.leftAnkle, Joint.rightAnkle]);
  bool get _ready => _core && _wrists && _ankles;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _CameraStage(
      poseSource: widget.poseSource,
      onPose: (pose) => setState(() => _pose = pose),
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
                    style: TextStyle(color: context.colors.text, fontSize: 13),
                  ),
                  // Three ticks rather than one verdict: somebody whose feet
                  // are out of shot is told which end to move.
                  _Mark(l.obFramingShoulders, on: _core),
                  _Mark(l.obFramingWrists, on: _wrists),
                  _Mark(l.obFramingAnkles, on: _ankles),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 22,
            child: _Primary(
              label: l.obLooksGood,
              onTap: _ready ? widget.onNext : null,
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
                fontSize: 11,
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

  void _onPose(BodyPose pose) {
    if (_done) return;
    if (!mounted) return;

    final reading = _tracker.add(_clock.elapsedMilliseconds, pose);
    if (reading.counted) {
      _reps = reading.reps;
      _depth = _tracker.depth;
    }

    setState(() => _progress = reading.progress ?? _progress);

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
    final left = (kCalibrationReps - _reps).clamp(0, kCalibrationReps);

    return _CameraStage(
      poseSource: widget.poseSource,
      onPose: _onPose,
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
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    localNumber(context, _reps),
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 34,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < kCalibrationReps; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        Container(
                          width: 30,
                          height: 5,
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
                  const SizedBox(height: 8),
                  Text(
                    left == 1 ? l.obOneMoreRep : l.obCalibrationHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            start: 11,
            top: 200,
            child: Container(
              width: 10,
              height: 150,
              decoration: BoxDecoration(
                color: context.colors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: _progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.win,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                  style: TextStyle(color: context.colors.text, fontSize: 15),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 38, 22, 0),
            child: Column(
              children: [
                Text(
                  l.obCalibrated,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.obCalibratedBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: _Panel(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          l.obRepsCounted,
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Text(
                        localNumber(context, result.reps),
                        style: TextStyle(
                          color: context.colors.brand,
                          fontSize: 28,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 13, 0, 11),
                    child: Divider(height: 0.5, color: context.colors.border),
                  ),
                  _Line(
                    l.obAverageDepth,
                    '${localNumber(context, (result.averageDepth * 100).round())}%',
                  ),
                  const SizedBox(height: 6),
                  _Line(l.obForm, result.clean ? l.obFormClean : l.obFormMixed),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: _Primary(label: l.continueLabel, onTap: onNext),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: context.colors.muted, fontSize: 11),
          ),
        ),
        Text(value, style: TextStyle(color: context.colors.text, fontSize: 11)),
      ],
    );
  }
}

// ────────────────────────────── 9 placements ─────────────────────────────────

class _Placements extends StatelessWidget {
  const _Placements({required this.onStart, required this.onPractice});

  final VoidCallback onStart;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return _Step0(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 26, 30, 0),
        child: Column(
          children: [
            TierBadge.unranked(size: 78),
            const SizedBox(height: 12),
            Text(
              l.unranked,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              l.obPlacementsBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 12,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < kPlacementDuels; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Container(
                    width: 28,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: context.colors.surfaceRaised,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 9),
            Text(
              l.placementsTerms(
                localNumber(context, 0),
                localNumber(context, kPlacementDuels),
                localNumber(context, kDuelLength.inSeconds),
              ),
              style: TextStyle(color: context.colors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
      actions: Column(
        children: [
          _Primary(label: l.obFindFirstOpponent, onTap: onStart),
          const SizedBox(height: 6),
          _Secondary(label: l.practiceFirst, onTap: onPractice),
        ],
      ),
    );
  }
}

// ─────────────────────────── 3 what a duel is ────────────────────────────────

/// A duel, played out once in miniature: two counts climbing against one
/// clock, the bar between them, and what the gap pays.
///
/// Runs once and stops on the finished score rather than looping. A screen
/// that never stops moving is a screen nobody finishes reading.
class _DuelExplainer extends StatefulWidget {
  const _DuelExplainer({required this.onNext});

  final VoidCallback onNext;

  @override
  State<_DuelExplainer> createState() => _DuelExplainerState();
}

class _DuelExplainerState extends State<_DuelExplainer>
    with SingleTickerProviderStateMixin {
  /// An illustration, not an account. The name is somebody the reader has
  /// never met, which is exactly who the first duel will be against.
  static const _theirName = 'squat_queen';
  static const _yours = 18;
  static const _theirs = 11;

  late final AnimationController _run = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_run.isAnimating || _run.isCompleted) return;
    if (MediaQuery.of(context).disableAnimations) {
      _run.value = 1;
    } else {
      _run.forward();
    }
  }

  @override
  void dispose() {
    _run.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final gap = _yours - _theirs;

    return _Step0(
      centred: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BigTitle(l.obDuelTitle),
            const SizedBox(height: 10),
            _Lead(l.obDuelBody),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _run,
              builder: (context, _) {
                final t = Curves.easeOut.transform(_run.value);
                final mine = (_yours * t).floor();
                final theirs = (_theirs * t).floor();
                final left = (kDuelLength.inSeconds * (1 - _run.value)).ceil();
                return _MiniScore(
                  you: l.you,
                  them: _theirName,
                  mine: mine,
                  theirs: theirs,
                  seconds: left,
                );
              },
            ),
            const SizedBox(height: 14),
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _run,
                curve: const Interval(0.85, 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.obDuelWinBy(localNumber(context, gap)),
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '+${localNumber(context, gap)} LP',
                    style: TextStyle(
                      color: context.colors.brand,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Lead(l.obDuelLpRule),
          ],
        ),
      ),
      actions: _Primary(label: l.continueLabel, onTap: widget.onNext),
    );
  }
}

/// The camera screen's score card, drawn small and without a camera.
class _MiniScore extends StatelessWidget {
  const _MiniScore({
    required this.you,
    required this.them,
    required this.mine,
    required this.theirs,
    required this.seconds,
  });

  final String you;
  final String them;
  final int mine;
  final int theirs;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    Widget side(String name, int count, Color colour) => Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.surfaceRaised,
            ),
            child: Text(
              name.characters.first.toUpperCase(),
              style: TextStyle(color: colour, fontSize: 16),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.muted, fontSize: 12),
          ),
          Text(
            localNumber(context, count),
            style: TextStyle(
              color: colour,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );

    final total = mine + theirs;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              side(you, mine, context.colors.text),
              Text(
                formatClock(context, seconds),
                style: TextStyle(
                  color: context.colors.muted,
                  fontSize: 20,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              side(them, theirs, context.colors.rival),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              height: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: total == 0 ? 1 : mine,
                    child: ColoredBox(color: context.colors.brand),
                  ),
                  Expanded(
                    flex: total == 0 ? 1 : theirs,
                    child: ColoredBox(color: context.colors.rival),
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

// ─────────────────────────────── 4 the ladder ────────────────────────────────

/// All seven tiers, top to bottom, with the badge each one wears.
class _Ladder extends StatelessWidget {
  const _Ladder({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final divisions = '${kDivisions.first}–${kDivisions.last}';

    return _Step0(
      centred: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BigTitle(l.obLadderTitle),
            const SizedBox(height: 20),
            for (var i = kTiers.length - 1; i >= 0; i--)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    TierBadge(tierIndex: i, size: 34),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        tierName(l, i),
                        style: TextStyle(
                          color: kTiers[i].color,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Master is one rung, not five.
                    if (i < kTiers.length - 1)
                      Text(
                        divisions,
                        style: TextStyle(
                          color: context.colors.faint,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            _Lead(l.obLadderBody),
          ],
        ),
      ),
      actions: _Primary(label: l.continueLabel, onTap: onNext),
    );
  }
}

/// The heading size the reading steps share.
class _BigTitle extends StatelessWidget {
  const _BigTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: context.colors.text,
        fontSize: 24,
        height: 1.3,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// The body size the reading steps share.
class _Lead extends StatelessWidget {
  const _Lead(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: context.colors.muted, fontSize: 14, height: 1.5),
    );
  }
}
