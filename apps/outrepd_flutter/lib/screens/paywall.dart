/// Pro: the subscription that takes the ads out and gives the Pro look.
///
/// The screen is the user's pick A (2026-11-01): the player's own lifter
/// small as it is, and big as Pro on a holo card; five rows of what Pro
/// gives, each with a picture of it; the two plans side by side; and a
/// button that says the price, because the stores charge from the first day
/// (there is no free trial). The same screen is a step of sign-up, right
/// after the lifter is made, with "Not now" in place of the close button.
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

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/backend.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../lifter/catalog.dart';
import '../lifter/covers.dart';
import '../lifter/lifter_art.dart';
import '../lifter/lifter_view.dart';
import '../lifter/my_lifter.dart';
import '../subscription.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../widgets.dart';
import 'pro_parts.dart';

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
  double get hero => _lerp(150, 190);
  double get perkTile => _lerp(40, 46);
  double get perkTitle => _lerp(15, 17);
  double get perkBody => _lerp(12.5, 14);
  double get perkGap => _lerp(6, 9);
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
/// storefront: there is nothing there to buy. [onboarding] is the sign-up
/// step: "Not now" instead of the close button, and the lifter just made.
Future<void> openPro(BuildContext context, {bool onboarding = false}) async {
  final subscription = Subscription.instance;
  final store = subscription.store;
  if (store == null) return;
  // Right after signing in, the store has not been asked about this account
  // yet — the main screen asks once it opens — so a subscriber was offered
  // what they already have (the user saw it, 2026-11-04). Asked first, for
  // a few seconds at most: a store that has not answered by then counts as
  // no, as it does everywhere else.
  final me = backend.me?.id;
  if (!subscription.answeredFor(me)) {
    await subscription
        .refresh(me)
        .timeout(const Duration(seconds: 4), onTimeout: () {});
    if (!context.mounted) return;
  }
  if (subscription.active) return;
  final messenger = ScaffoldMessenger.maybeOf(context);
  final thanks = L.of(context).proThanks;
  await Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (pro) => PaywallScreen(
        store: store,
        onboarding: onboarding,
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
    this.onboarding = false,
  });

  final Storefront store;

  /// Shown as a step of sign-up rather than opened from the app.
  final bool onboarding;

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
          // RevenueCat's own reason goes with its code: "10: Error performing
          // request" alone could be the phone, Google Play or RevenueCat
          // (a new account's plans, the user, 2026-11-05).
          _loadError = switch (error) {
            PlatformException(:final code, :final message, :final details) => [
              '$code: ${message ?? ''}',
              if (details case {'underlyingErrorMessage': final String why} when why.isNotEmpty) why,
            ].join(' — '),
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

  /// What Pro is: the player's lifter before and after, the line under it,
  /// and the five things Pro gives, each with a picture of it.
  Widget _pitch(BuildContext context, L l) {
    final sizes = _Sizes.of(context);
    final colors = context.colors;
    final mine = MyLifter.instance.current(demoProfile.username);
    final perk = sizes.perkTile;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Hero(mine: mine, size: sizes.hero, onboarding: widget.onboarding),
        SizedBox(height: sizes.headlineGap * 0.4),
        Text(
          widget.onboarding ? l.proOnboardTitle : l.proGoTitle,
          key: const Key('paywallTitle'),
          textAlign: TextAlign.center,
          style: kType.title.copyWith(
            fontSize: sizes.headline,
            height: 1.1,
            fontWeight: FontWeight.w900,
            color: colors.text,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.proSubtitle,
          textAlign: TextAlign.center,
          style: kType.body.copyWith(
            fontSize: sizes.stepBody,
            height: 1.4,
            color: colors.muted,
          ),
        ),
        SizedBox(height: sizes.headlineGap * 0.4),
        _Perk(
          tile: _NoAdTile(size: perk),
          title: l.proPerkNoAds,
          body: l.proPerkNoAdsBody,
        ),
        _Perk(
          tile: _BoardTile(size: perk),
          title: l.proPerkBoard,
          body: l.proPerkBoardBody,
        ),
        _Perk(
          tile: _VsTile(size: perk),
          title: l.proPerkEntrance,
          body: l.proPerkEntranceBody,
        ),
        _Perk(
          // Still here: the cover itself moves on the profile.
          tile: const CoverScene('neon_city', moving: false),
          title: l.proPerkCovers,
          body: l.proPerkCoversBody,
        ),
        _Perk(
          tile: LifterImage(_samples[0], view: LifterView.head, size: perk),
          title: l.proPerkItems,
          body: l.proPerkItemsBody,
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
          // Room above for the saving, which sits on the yearly plan's edge.
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (yearly != null)
                    Expanded(
                      child: _PlanTile(
                        key: const Key('planYearly'),
                        label: l.paywallYearly,
                        price: yearly.priceString,
                        detail: l.paywallPerWeek(yearly.perWeek()),
                        badge: saving == null
                            ? null
                            : l.paywallSave(localNumber(context, saving)),
                        selected: _chosen == PlanPeriod.yearly,
                        onTap: () =>
                            setState(() => _chosen = PlanPeriod.yearly),
                      ),
                    ),
                  if (yearly != null && weekly != null)
                    SizedBox(width: sizes.planGap),
                  if (weekly != null)
                    Expanded(
                      child: _PlanTile(
                        key: const Key('planWeekly'),
                        label: l.paywallWeekly,
                        price: weekly.priceString,
                        detail: l.paywallEveryWeek,
                        selected: _chosen == PlanPeriod.weekly,
                        onTap: () =>
                            setState(() => _chosen = PlanPeriod.weekly),
                      ),
                    ),
                ],
              ),
            ),
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
                      switch (_plan(_chosen)) {
                        final plan? when plan.period == PlanPeriod.yearly =>
                          l.proBuyYearly(plan.priceString),
                        final plan? => l.proBuyWeekly(plan.priceString),
                        null => l.proGo,
                      },
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: sizes.buttonText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
          ),
        ),
        // The way out, under the button: the app is free, and this is an offer,
        // not a gate. In sign-up it says so where the next step would be.
        if (widget.onboarding) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: sizes.button,
            child: FilledButton(
              key: const Key('proNotNow'),
              onPressed: () => Navigator.maybePop(context),
              style: FilledButton.styleFrom(
                backgroundColor: colors.surfaceRaised,
                foregroundColor: colors.text,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                l.notNow,
                style: TextStyle(
                  fontSize: sizes.buttonText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
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

/// A plan as a tile, the two side by side: the name, the price, and what a
/// week of it costs. The saving sits on the yearly tile's top edge.
class _PlanTile extends StatelessWidget {
  const _PlanTile({
    super.key,
    required this.label,
    required this.price,
    required this.detail,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String label;
  final String price;
  final String detail;
  final bool selected;
  final VoidCallback onTap;

  /// "Save 85%", on the plan that saves.
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sizes = _Sizes.of(context);
    final tile = Semantics(
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
            padding: EdgeInsets.fromLTRB(14, sizes.planPadding + 2, 10, sizes.planPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? colors.brand : colors.border,
                width: selected ? 2 : 1,
              ),
            ),
            // Each line shrunk rather than cut when a language or a large
            // text size runs long.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: kType.heading.copyWith(
                      fontSize: sizes.planName,
                      color: colors.text,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    price,
                    maxLines: 1,
                    style: context.type.statValue.copyWith(
                      fontSize: sizes.planPrice + 2,
                      color: colors.text,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
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
        ),
      ),
    );
    final saving = badge;
    if (saving == null) return tile;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        tile,
        PositionedDirectional(
          top: -10,
          end: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              saving.toUpperCase(),
              maxLines: 1,
              style: TextStyle(
                color: const Color(0xFF2A1E05),
                fontSize: sizes.planBadge,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The player's own lifter twice: small as it is now, and big as Pro on a
/// holo card with the shine passing over it, an arrow from one to the other.
class _Hero extends StatelessWidget {
  const _Hero({
    required this.mine,
    required this.size,
    required this.onboarding,
  });

  final Lifter mine;
  final double size;
  final bool onboarding;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final thumb = size * 0.4;
    return ExcludeSemantics(
      child: SizedBox(
        height: size + 8,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _ArrowPainter(
                  color: colors.brand,
                  thumb: thumb,
                  card: size,
                  rtl: Directionality.of(context) == TextDirection.rtl,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  HoloEdge(
                    radius: 26,
                    width: 4,
                    child: ShineBand(
                      child: LifterImage(proLook(mine), size: size - 8),
                    ),
                  ),
                  const PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: ProChip(height: 22),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: 0,
              bottom: 0,
              child: Column(
                children: [
                  Container(
                    width: thumb,
                    height: thumb,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: LifterImage(mine, size: thumb),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    onboarding ? l.proYoursNow : l.proFree,
                    style: TextStyle(
                      color: colors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A curved arrow from the top of the small lifter to the card's edge.
class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({
    required this.color,
    required this.thumb,
    required this.card,
    required this.rtl,
  });

  final Color color;
  final double thumb;
  final double card;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    double x(double v) => rtl ? size.width - v : v;
    final from = Offset(x(thumb * 0.5), size.height - thumb - 30);
    final to = Offset(x((size.width - card) / 2 - 8), size.height * 0.28);
    final bend = Offset(x(thumb * 0.55), to.dy);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(from.dx, from.dy)
        ..quadraticBezierTo(bend.dx, bend.dy, to.dx, to.dy),
      paint,
    );
    final back = rtl ? 7.0 : -7.0;
    canvas.drawPath(
      Path()
        ..moveTo(to.dx + back, to.dy - 6)
        ..lineTo(to.dx, to.dy)
        ..lineTo(to.dx + back, to.dy + 6),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter old) =>
      old.color != color || old.thumb != thumb || old.card != card || old.rtl != rtl;
}

/// One thing Pro gives: its picture, its name, a line about it.
class _Perk extends StatelessWidget {
  const _Perk({required this.tile, required this.title, required this.body});

  final Widget tile;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sizes = _Sizes.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sizes.perkGap),
      child: Row(
        children: [
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox.square(dimension: sizes.perkTile, child: tile),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kType.heading.copyWith(
                    fontSize: sizes.perkTitle,
                    fontWeight: FontWeight.w800,
                    color: colors.text,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  body,
                  style: TextStyle(
                    color: colors.muted,
                    fontSize: sizes.perkBody,
                    height: 1.3,
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

/// Pro lifters for the perks' pictures: one in Pro-only things, one on a
/// board.
final _samples = () {
  int at(List<LifterPart> list, String id) =>
      list.indexWhere((p) => p.id == id);
  return [
    Lifter(
      skin: at(kSkins, 'obsidian'),
      hair: 16,
      hairColor: 5,
      eyes: 6,
      beard: 8,
      top: at(kTops, 'tie_dye_hoodie'),
      gear: at(kGear, 'cyber_visor'),
      background: 3,
      pattern: at(kPatterns, 'holo_foil'),
    ),
    Lifter(
      skin: at(kSkins, 'neon'),
      hair: 7,
      hairColor: 9,
      mouth: 1,
      beard: 0,
      top: at(kTops, 'pro_tracksuit'),
      gear: at(kGear, 'gold_headphones'),
      background: 7,
      pattern: at(kPatterns, 'aurora'),
    ),
  ];
}();

class _NoAdTile extends StatelessWidget {
  const _NoAdTile({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.surface,
    child: Center(child: _NoAdMark(size: size * 1.25)),
  );
}

/// A holo row on a board, its lifter's head out of the frame.
class _BoardTile extends StatelessWidget {
  const _BoardTile({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      color: colors.surface,
      child: Stack(
        children: [
          Positioned(
            left: size * 0.1,
            right: size * 0.1,
            bottom: size * 0.18,
            height: size * 0.38,
            child: HoloEdge(
              radius: 6,
              width: 1.5,
              child: ColoredBox(
                color: colors.surface,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: size * 0.36, end: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 3, width: size * 0.3, color: colors.faint),
                      const SizedBox(height: 3),
                      Container(height: 3, width: size * 0.2, color: colors.surfaceRaised),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: size * 0.12,
            bottom: size * 0.22,
            width: size * 0.34,
            height: size * 0.5,
            child: LifterImage(_samples[1], view: LifterView.noBackground, size: size * 0.5),
          ),
        ],
      ),
    );
  }
}

/// VS in gold, lightning either side: the Pro entrance.
class _VsTile extends StatelessWidget {
  const _VsTile({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFF1B1640),
    child: Stack(
      alignment: Alignment.center,
      children: [
        PositionedDirectional(
          top: 2,
          start: 2,
          child: Icon(Icons.bolt, size: size * 0.42, color: const Color(0xFFFFE04A)),
        ),
        PositionedDirectional(
          bottom: 2,
          end: 2,
          child: Icon(Icons.bolt, size: size * 0.38, color: const Color(0xFFFFE04A)),
        ),
        Transform.rotate(
          angle: -0.14,
          child: Text(
            'VS',
            style: TextStyle(
              color: const Color(0xFFF2C14E),
              fontSize: size * 0.42,
              fontWeight: FontWeight.w900,
              height: 1,
              shadows: const [Shadow(color: Color(0xFF121110), blurRadius: 0, offset: Offset(1.5, 1.5))],
            ),
          ),
        ),
      ],
    ),
  );
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
