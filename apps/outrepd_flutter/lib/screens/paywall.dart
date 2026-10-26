/// The paywall, and the gate that puts it in front of the app.
///
/// The whole app is behind it, by decision: after onboarding and signing up,
/// an account without the subscription sees this screen and nothing else.
/// There is no skip. What it must still offer — the stores check for each —
/// is restoring an earlier purchase, the terms and the privacy policy, the
/// price and how it renews, and a way to delete the account without paying.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../reminders.dart';
import '../subscription.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../widgets.dart';
import 'settings_account.dart';

/// The paywall's sizes, between two ends. A short phone keeps the sizes the
/// paywall was laid out at, because the way to pay has to fit on one without
/// scrolling to it. A tall phone gets the app's own, two steps larger, and
/// more room between the lines, so the pitch fills the screen rather than
/// floating in the middle of it. Phones in between get sizes in between.
class _Sizes {
  const _Sizes._(this.t);

  factory _Sizes.of(BuildContext context) =>
      _Sizes._(((MediaQuery.sizeOf(context).height - 720) / 160).clamp(0, 1));

  /// 0 on a phone 720 tall or shorter, 1 on one 880 tall or taller.
  final double t;

  double _lerp(double short, double tall) => short + (tall - short) * t;

  // The pitch.
  double get headline => _lerp(32, 36);
  double get headlineGap => _lerp(30, 42);
  double get stepTitle => _lerp(17, 19);
  double get stepBody => _lerp(14, 16);
  double get stepIcon => _lerp(22, 26);
  double get stepGap => _lerp(22, 34);

  // The plans.
  double get planName => _lerp(16, 18);
  double get planBadge => _lerp(11, 13);
  double get planDetail => _lerp(12, 14);
  double get planPrice => _lerp(20, 22);
  double get planFree => _lerp(12, 14);
  double get planPadding => _lerp(12, 15);
  double get planGap => _lerp(8, 10);

  // The button and the small print.
  double get button => _lerp(56, 60);
  double get buttonText => _lerp(17, 19);
  double get body => _lerp(15, 17);
  double get note => _lerp(13, 15);
  double get renews => _lerp(11, 13);
  double get link => _lerp(12, 14);
  double get why => _lerp(10, 12);
}

const kTermsUrl = 'https://www.outrepd.com/terms';
const kPrivacyUrl = 'https://www.outrepd.com/privacy';

/// Shows [child] to an account with the subscription, and the paywall to
/// anybody else.
///
/// A build with no storefront (the web preview, the tests, a build made
/// without the RevenueCat key) has no paywall, and [child] shows as it
/// always did.
class PaywallGate extends StatefulWidget {
  const PaywallGate({super.key, required this.child});

  final Widget child;

  @override
  State<PaywallGate> createState() => _PaywallGateState();
}

class _PaywallGateState extends State<PaywallGate> {
  final _subscription = Subscription.instance;

  @override
  void initState() {
    super.initState();
    _subscription.addListener(_changed);
    // Asked every time the gate is built: the account may have changed
    // since launch — signing up or logging in happens just before this.
    if (_subscription.enabled) _subscription.refresh(backend.me?.id);
  }

  @override
  void dispose() {
    _subscription.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final store = _subscription.store;
    if (store == null || _subscription.active) return widget.child;
    // Nothing until the answer is in, rather than flash the paywall at
    // somebody who has paid. The store answers from its cache, so this is a
    // moment, not a wait.
    if (!_subscription.known) {
      return Scaffold(
        backgroundColor: context.colors.background,
        body: Center(
          child: CircularProgressIndicator(color: context.colors.brand),
        ),
      );
    }
    return PaywallScreen(store: store, onUnlocked: _subscription.settle);
  }
}

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({
    super.key,
    required this.store,
    required this.onUnlocked,
  });

  final Storefront store;

  /// Called with true once a purchase or a restore has unlocked the app.
  final ValueChanged<bool> onUnlocked;

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  List<Plan>? _plans;
  bool _loadFailed = false;

  /// Why the plans did not load, in the store's own words. Not shown unless
  /// asked for — a long press on the message — because "10: Error performing
  /// request" tells somebody who wants to subscribe nothing they can act on,
  /// while the message above it does. It is for whoever is setting the store
  /// up or answering a support email: an agreement not yet in effect, a
  /// product the store will not hand out, a phone whose private DNS blocks
  /// the store — and it is the one place on a phone that reason can be read.
  String? _loadError;
  bool _showLoadError = false;
  PlanPeriod _chosen = PlanPeriod.yearly;
  bool _busy = false;

  /// One line under the button: a failed or pending purchase, a restore that
  /// found nothing. Null when there is nothing to say.
  String? _note;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _plans = null;
      _loadFailed = false;
      _loadError = null;
    });
    try {
      final plans = await widget.store.plans();
      if (!mounted) return;
      setState(() {
        _plans = plans;
        _loadFailed = plans.isEmpty;
        _loadError = plans.isEmpty
            ? 'The current offering has no weekly or annual package.'
            : null;
        if (plans.isNotEmpty && !plans.any((p) => p.period == _chosen)) {
          _chosen = plans.first.period;
        }
      });
    } on Object catch (error) {
      debugPrint('Could not load the plans: $error');
      if (mounted) {
        setState(() {
          _loadFailed = true;
          _loadError = switch (error) {
            PlatformException(:final code, :final message) =>
              '$code: ${message ?? ''}',
            _ => '$error',
          };
        });
      }
    }
  }

  Plan? _plan(PlanPeriod period) {
    for (final plan in _plans ?? const <Plan>[]) {
      if (plan.period == period) return plan;
    }
    return null;
  }

  Future<void> _buy() async {
    final plan = _plan(_chosen);
    if (plan == null || _busy) return;
    final l = L.of(context);
    setState(() {
      _busy = true;
      _note = null;
    });
    ({BuyOutcome outcome, bool active}) result;
    try {
      result = await widget.store.buy(plan);
    } on Object catch (error) {
      debugPrint('Purchase failed: $error');
      result = (outcome: BuyOutcome.failed, active: false);
    }
    // A trial just began: the reminder the timeline promised, the day
    // before the first charge.
    final trialDays = plan.trialDays;
    if (result.active && trialDays != null) {
      unawaited(Reminders.instance.trialStarted(Duration(days: trialDays)));
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _note = switch (result.outcome) {
        BuyOutcome.bought || BuyOutcome.cancelled => null,
        BuyOutcome.pending => l.paywallPending,
        BuyOutcome.failed => l.paywallBuyFailed,
      };
    });
    if (result.active) widget.onUnlocked(true);
  }

  Future<void> _restore() async {
    if (_busy) return;
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _busy = true;
      _note = null;
    });
    bool active;
    String? note;
    try {
      active = await widget.store.restore();
      note = active ? null : l.paywallNothingToRestore;
    } on Object catch (error) {
      debugPrint('Restore failed: $error');
      active = false;
      note = l.cantReachServer;
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _note = note;
    });
    if (active) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.paywallRestored),
          behavior: SnackBarBehavior.floating,
        ),
      );
      widget.onUnlocked(true);
    }
  }

  Future<void> _open(String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = L.of(context);
    try {
      final opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!opened) throw StateError('launchUrl returned false');
    } on Object catch (error) {
      debugPrint('Could not open $url: $error');
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.couldNotOpenLink),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// The account, reachable without paying: the stores require that an
  /// account can be deleted from inside the app, whatever else is locked.
  void _account() {
    final l = L.of(context);
    final email = backend.accountEmail;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.accountSection,
                style: sheet.type.heading.copyWith(color: sheet.colors.text),
              ),
              if (email != null) ...[
                const SizedBox(height: 6),
                Text(
                  l.paywallSignedInAs(email),
                  style: sheet.type.body.copyWith(color: sheet.colors.muted),
                ),
              ],
              const SizedBox(height: 14),
              ListTile(
                key: const Key('paywallDeleteAccount'),
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.delete_outline, color: AppColors.loss),
                title: Text(
                  l.deleteAccount,
                  style: sheet.type.body.copyWith(color: AppColors.loss),
                ),
                onTap: () {
                  Navigator.of(sheet).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DeleteAccountScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // The pitch scrolls on a short phone; the way to pay never does.
            // On a tall one it sits in the middle of the space it has, not at
            // the top of it with a gap underneath.
            Expanded(
              child: LayoutBuilder(
                builder: (context, viewport) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 12),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // Less the scroll padding above and below.
                      minHeight: math.max(0.0, viewport.maxHeight - 42),
                    ),
                    child: Center(
                      // Nothing while the plans load: whether this account
                      // can still have the free days comes with them, and a
                      // headline that changed its mind a moment later would
                      // be one paywall swapped for another in front of it.
                      child: _plans == null && !_loadFailed
                          ? const SizedBox.shrink()
                          : switch (_plan(_chosen)?.trialDays) {
                              final days? => _trialPitch(context, l, days),
                              null => _pitch(context, l),
                            },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: _purchaseArea(context, l),
            ),
          ],
        ),
      ),
    );
  }

  /// What the subscription opens, down the same rail as the trial's days:
  /// for an account that has had its free days, a plan without any, or plans
  /// that would not load. The same paywall either way. There used to be a
  /// second one here, of crests and perks, and picking the other plan
  /// switched from one to the other.
  Widget _pitch(BuildContext context, L l) {
    final sizes = _Sizes.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AccentHeadline(key: const Key('paywallTitle'), text: l.paywallTitle),
        SizedBox(height: sizes.headlineGap),
        _Rail(
          steps: [
            (Icons.videocam_outlined, l.paywallPerkDuels, null),
            (Icons.emoji_events_outlined, l.paywallPerkLadder, null),
            (Icons.group_outlined, l.paywallPerkFriends, null),
            (Icons.insights_outlined, l.paywallPerkHistory, null),
          ],
        ),
      ],
    );
  }

  /// While the chosen plan has a trial: what the subscription opens, as four
  /// tiles, and the trial told as what happens when — today everything
  /// opens, the day before it ends the app says so, and the day it ends the
  /// plan starts. The free days are on the plan and the button as well.
  Widget _trialPitch(BuildContext context, L l, int days) {
    final sizes = _Sizes.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AccentHeadline(
          key: const Key('paywallTitle'),
          text: l.paywallTitle,
          scale: 0.88,
        ),
        SizedBox(height: sizes.headlineGap * 0.45),
        const _PerkGrid(),
        SizedBox(height: sizes.headlineGap * 0.55),
        _TrialTimeline(
          key: const Key('trialTimeline'),
          days: days,
          compact: true,
        ),
      ],
    );
  }

  Widget _purchaseArea(BuildContext context, L l) {
    final colors = context.colors;
    final sizes = _Sizes.of(context);
    final weekly = _plan(PlanPeriod.weekly);
    final yearly = _plan(PlanPeriod.yearly);
    final saving =
        weekly != null && yearly != null ? yearlySaving(weekly, yearly) : null;
    final ready = _plans != null && !_loadFailed;
    final apple = defaultTargetPlatform == TargetPlatform.iOS;
    final chosen = _plan(_chosen);
    final trial = chosen?.trialDays;
    String? tag(Plan? plan) => switch (plan?.trialDays) {
      final days? => l.trialTag(localNumber(context, days)),
      null => null,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_loadFailed)
          Column(
            children: [
              GestureDetector(
                key: const Key('paywallLoadFailed'),
                onLongPress: () => setState(() => _showLoadError = true),
                child: Text(
                  l.paywallLoadFailed,
                  textAlign: TextAlign.center,
                  style: kType.body.copyWith(
                    fontSize: sizes.body,
                    color: colors.muted,
                  ),
                ),
              ),
              if (_loadError case final why? when _showLoadError)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    why,
                    key: const Key('paywallLoadError'),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colors.faint, fontSize: sizes.why),
                  ),
                ),
              TextButton(
                key: const Key('paywallRetry'),
                onPressed: _load,
                child: Text(l.retry, style: TextStyle(color: colors.brand)),
              ),
            ],
          )
        else if (!ready)
          SizedBox(
            height: 128,
            child: Center(
              child: CircularProgressIndicator(color: colors.brand),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (yearly != null)
                _PlanRow(
                  key: const Key('planYearly'),
                  label: l.paywallYearly,
                  price: yearly.priceString,
                  detail: l.paywallPerWeek(yearly.perWeek()),
                  badge: saving == null
                      ? null
                      : l.paywallSave(localNumber(context, saving)),
                  trial: tag(yearly),
                  selected: _chosen == PlanPeriod.yearly,
                  onTap: () => setState(() => _chosen = PlanPeriod.yearly),
                ),
              if (yearly != null && weekly != null)
                SizedBox(height: sizes.planGap),
              if (weekly != null)
                _PlanRow(
                  key: const Key('planWeekly'),
                  label: l.paywallWeekly,
                  price: weekly.priceString,
                  detail: l.paywallEveryWeek,
                  trial: tag(weekly),
                  selected: _chosen == PlanPeriod.weekly,
                  onTap: () => setState(() => _chosen = PlanPeriod.weekly),
                ),
            ],
          ),
        const SizedBox(height: 12),
        SizedBox(
          height: sizes.button,
          child: FilledButton(
            key: const Key('paywallBuy'),
            onPressed: ready && !_busy ? _buy : null,
            style: FilledButton.styleFrom(
              backgroundColor: colors.brand,
              foregroundColor: colors.background,
              disabledBackgroundColor: colors.surfaceRaised,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: _busy
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colors.muted,
                    ),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      trial == null
                          ? l.paywallStart
                          : l.trialCta(localNumber(context, trial)),
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: sizes.buttonText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
          ),
        ),
        if (_note case final note?) ...[
          const SizedBox(height: 8),
          Text(
            note,
            key: const Key('paywallNote'),
            textAlign: TextAlign.center,
            style: kType.label.copyWith(
              fontSize: sizes.note,
              color: AppColors.loss,
            ),
          ),
        ],
        // What a trial costs, said plainly where the button is: nothing now,
        // and exactly what after. The stores ask for the price after a free
        // trial to be as clear as the trial itself.
        if (trial != null && chosen != null) ...[
          const SizedBox(height: 10),
          Text(
            chosen.period == PlanPeriod.yearly
                ? l.trialThenYearly(chosen.priceString)
                : l.trialThenWeekly(chosen.priceString),
            key: const Key('trialThen'),
            textAlign: TextAlign.center,
            style: kType.label.copyWith(
              fontSize: sizes.note,
              color: colors.text,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          apple ? l.paywallRenewsApple : l.paywallRenewsPlay,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.muted,
            fontSize: sizes.renews,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 2),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _SmallLink(
              key: const Key('paywallRestore'),
              label: l.paywallRestore,
              onTap: _restore,
            ),
            const _Dot(),
            _SmallLink(label: l.paywallTerms, onTap: () => _open(kTermsUrl)),
            const _Dot(),
            _SmallLink(label: l.paywallPrivacy, onTap: () => _open(kPrivacyUrl)),
            const _Dot(),
            _SmallLink(
              key: const Key('paywallAccount'),
              label: l.accountSection,
              onTap: _account,
            ),
          ],
        ),
      ],
    );
  }
}

/// A headline with one stretch of it in the accent: the part between the two
/// asterisks in the translation ("Your first 3 days are *free*"). Marked in
/// the string rather than split into pieces, because where the word falls in
/// the sentence is different in every language.
class _AccentHeadline extends StatelessWidget {
  const _AccentHeadline({super.key, required this.text, this.scale = 1});

  final String text;

  /// Of the usual headline size: less than one where the pitch is fuller.
  final double scale;

  @override
  Widget build(BuildContext context) {
    final parts = text.split('*');
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(
              text: parts[i],
              style: i.isOdd ? TextStyle(color: context.colors.rival) : null,
            ),
        ],
      ),
      textAlign: TextAlign.center,
      style: kType.title.copyWith(
        fontSize: _Sizes.of(context).headline * scale,
        height: 1.15,
        color: context.colors.text,
      ),
    );
  }
}

/// What the subscription opens, as two rows of two tiles: the same four
/// things the rail says when there is no trial, small enough to leave the
/// trial's days room under them.
class _PerkGrid extends StatelessWidget {
  const _PerkGrid();

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final sizes = _Sizes.of(context);
    Widget tile(IconData icon, String text) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.border, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: sizes.stepIcon * 0.8, color: colors.brand),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: kType.body.copyWith(
                  fontSize: sizes.stepBody,
                  height: 1.25,
                  color: colors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Widget row(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [a, const SizedBox(width: 8), b],
      ),
    );
    return Column(
      key: const Key('perkGrid'),
      children: [
        row(
          tile(Icons.videocam_outlined, l.paywallPerkDuels),
          tile(Icons.emoji_events_outlined, l.paywallPerkLadder),
        ),
        const SizedBox(height: 8),
        row(
          tile(Icons.group_outlined, l.paywallPerkFriends),
          tile(Icons.insights_outlined, l.paywallPerkHistory),
        ),
      ],
    );
  }
}

/// Today, the reminder, the first charge — down a bar that is lit for the
/// part already under way.
class _TrialTimeline extends StatelessWidget {
  const _TrialTimeline({super.key, required this.days, this.compact = false});

  final int days;

  /// The days closer together, beside the perks.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final steps = <(IconData, String, String?)>[
      (Icons.lock_open_rounded, l.trialToday, l.trialTodayBody),
      // A one-day trial has no day before its last to remind on.
      if (days >= 2)
        (
          Icons.notifications_active_outlined,
          l.trialDay(localNumber(context, days - 1)),
          l.trialReminderBody,
        ),
      (
        Icons.workspace_premium_outlined,
        l.trialDay(localNumber(context, days)),
        l.trialEndBody,
      ),
    ];

    return _Rail(steps: steps, fades: true, compact: compact);
  }
}

/// Steps down a bar, each an icon, a line and, if it needs one, a sentence
/// under it — the shape the whole paywall is told in, trial or not.
class _Rail extends StatelessWidget {
  const _Rail({required this.steps, this.fades = false, this.compact = false});

  /// Steps closer together, for a rail sharing the pitch with the perks.
  final bool compact;

  final List<(IconData, String, String?)> steps;

  /// Lit for the part under way and dimming after it, for the days of a
  /// trial; otherwise lit the whole way down, for what opens all at once.
  final bool fades;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sizes = _Sizes.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: fades ? null : colors.brand,
              gradient: fades
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.brand,
                        colors.brand,
                        colors.faint,
                        colors.faint,
                        colors.surfaceRaised,
                      ],
                      stops: const [0, 0.3, 0.38, 0.62, 0.72],
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  if (i > 0)
                    SizedBox(
                      height: compact ? sizes.stepGap * 0.45 : sizes.stepGap,
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        steps[i].$1,
                        size: sizes.stepIcon,
                        color: colors.brand,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              steps[i].$2,
                              style: kType.heading.copyWith(
                                fontSize: sizes.stepTitle,
                                color: colors.text,
                              ),
                            ),
                            if (steps[i].$3 case final more?) ...[
                              const SizedBox(height: 3),
                              Text(
                                more,
                                style: kType.body.copyWith(
                                  fontSize: sizes.stepBody,
                                  height: 1.4,
                                  color: colors.muted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A plan as one row: the name and what it saves on the left, the price and
/// any free days on the right.
class _PlanRow extends StatelessWidget {
  const _PlanRow({
    super.key,
    required this.label,
    required this.price,
    required this.detail,
    required this.selected,
    required this.onTap,
    this.badge,
    this.trial,
  });

  final String label;
  final String price;
  final String detail;
  final bool selected;
  final VoidCallback onTap;

  /// "Save 85%", on the plan that saves.
  final String? badge;

  /// "3 days free", on a plan with a trial this account can still have.
  final String? trial;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sizes = _Sizes.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: sizes.planPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? colors.brand : colors.border,
                width: selected ? 2 : 1,
              ),
            ),
            // Three parts to the left side and two to the right, each shrunk
            // rather than cut when a language or a large text size runs long:
            // the name and its saving, and the price and its free days, are
            // each read as one, so neither half loses its end.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              maxLines: 1,
                              style: kType.heading.copyWith(
                                fontSize: sizes.planName,
                                color: colors.text,
                              ),
                            ),
                            if (badge case final saving?) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gold,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  saving,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: const Color(0xFF2A1E05),
                                    fontSize: sizes.planBadge,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.muted,
                          fontSize: sizes.planDetail,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: context.type.statValue.copyWith(
                            fontSize: sizes.planPrice,
                            color: colors.text,
                          ),
                        ),
                        if (trial case final free?) ...[
                          const SizedBox(height: 2),
                          Text(
                            free,
                            style: TextStyle(
                              color: colors.rival,
                              fontSize: sizes.planFree,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallLink extends StatelessWidget {
  const _SmallLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        // Tall enough to hit with a thumb, though the text is small.
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Text(
          label,
          style: TextStyle(
            color: context.colors.muted,
            fontSize: _Sizes.of(context).link,
            decoration: TextDecoration.underline,
            decorationColor: context.colors.faint,
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) => Text(
    '·',
    style: TextStyle(
      color: context.colors.faint,
      fontSize: _Sizes.of(context).link,
    ),
  );
}
