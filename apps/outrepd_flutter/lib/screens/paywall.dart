/// Pro: the subscription that takes the ads out.
///
/// The app is free (since 2026-10-28, the user's call): every match, live,
/// ranked and Adventure, is played without paying, and an ad plays when a
/// result screen is left (lib/ads.dart). Pro is the same two plans the
/// paywall sold when the whole app sat behind it, and what they buy now is
/// no ads. So this screen opens on top of the app and closes again — from
/// "Remove ads" under a result, from the ask before the first ad, and once
/// on its own after the first ad. What it must still offer, the stores check
/// for: restoring an earlier purchase, the terms and the privacy policy, and
/// the price and how it renews.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../reminders.dart';
import '../subscription.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../widgets.dart';

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
  double get mark => _lerp(140, 190);
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

/// Opens Pro over whatever is on screen, and closes it again once a purchase
/// or a restore has taken the ads out. Nothing happens in a build with no
/// storefront: there is nothing there to buy.
Future<void> openPro(BuildContext context) async {
  final subscription = Subscription.instance;
  final store = subscription.store;
  if (store == null || subscription.active) return;
  final messenger = ScaffoldMessenger.maybeOf(context);
  final thanks = L.of(context).proThanks;
  await Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (pro) => PaywallScreen(
        store: store,
        onUnlocked: (active) {
          subscription.settle(active);
          if (!active) return;
          Navigator.of(pro).pop();
          messenger?.showSnackBar(
            SnackBar(content: Text(thanks), behavior: SnackBarBehavior.floating),
          );
        },
      ),
    ),
  );
}

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({
    super.key,
    required this.store,
    required this.onUnlocked,
  });

  final Storefront store;

  /// Called with true once a purchase or a restore has taken the ads out.
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
    if (active) widget.onUnlocked(true);
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

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // The pitch scrolls on a short phone; the way to pay never
                // does. On a tall one it sits in the middle of the space it
                // has, not at the top of it with a gap underneath. It starts
                // under the close button, which lies over it.
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, viewport) => SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 48, 20, 12),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          // Less the scroll padding above and below.
                          minHeight: math.max(0.0, viewport.maxHeight - 60),
                        ),
                        child: Center(child: _pitch(context, l)),
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
            // The way out: the app is free, and this is an offer, not a gate.
            PositionedDirectional(
              top: 0,
              start: 4,
              child: IconButton(
                key: const Key('proClose'),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                color: context.colors.muted,
                icon: const Icon(Icons.close, size: 26),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// What Pro is, said once: an ad struck through, and the two lines under
  /// it. The same whatever the plans turn out to hold — the free days are on
  /// the plans and the button.
  Widget _pitch(BuildContext context, L l) {
    final sizes = _Sizes.of(context);
    final colors = context.colors;
    final title = kType.title.copyWith(
      fontSize: sizes.headline,
      height: 1.15,
      color: colors.text,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NoAdMark(size: sizes.mark),
        SizedBox(height: sizes.headlineGap * 0.5),
        Text(
          '${l.proTitleTop}\n${l.proTitleBottom}',
          key: const Key('paywallTitle'),
          textAlign: TextAlign.center,
          style: title,
        ),
        const SizedBox(height: 12),
        Text(
          l.proBody,
          textAlign: TextAlign.center,
          style: kType.body.copyWith(
            fontSize: sizes.stepBody,
            height: 1.5,
            color: colors.muted,
          ),
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
          ],
        ),
      ],
    );
  }
}

/// An ad, struck through: the one picture Pro needs. A label marked AD in the
/// app's cream, and across it a bar in the rival's colour, ringed in the
/// page's black so it reads as lying on top.
class _NoAdMark extends StatelessWidget {
  const _NoAdMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                colors.brand.withValues(alpha: 0.16),
                colors.brand.withValues(alpha: 0),
              ],
              stops: const [0, 0.7],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size * 0.62,
                height: size * 0.42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size * 0.08),
                  border: Border.all(color: colors.brand, width: size * 0.035),
                ),
                child: Text(
                  'AD',
                  style: TextStyle(
                    color: colors.brand,
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Transform.rotate(
                angle: -35 * math.pi / 180,
                child: Container(
                  width: size * 0.82,
                  height: size * 0.05,
                  decoration: BoxDecoration(
                    color: colors.rival,
                    borderRadius: BorderRadius.circular(size * 0.03),
                    border: Border.all(
                      color: colors.background,
                      width: size * 0.025,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
