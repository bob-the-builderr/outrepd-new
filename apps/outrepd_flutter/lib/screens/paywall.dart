/// The paywall, and the gate that puts it in front of the app.
///
/// The whole app is behind it, by decision: after onboarding and signing up,
/// an account without the subscription sees this screen and nothing else.
/// There is no skip. What it must still offer — the stores check for each —
/// is restoring an earlier purchase, the terms and the privacy policy, the
/// price and how it renews, and a way to delete the account without paying.
library;

import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../subscription.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../widgets.dart';
import 'settings_account.dart';

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
    });
    try {
      final plans = await widget.store.plans();
      if (!mounted) return;
      setState(() {
        _plans = plans;
        _loadFailed = plans.isEmpty;
        if (plans.isNotEmpty && !plans.any((p) => p.period == _chosen)) {
          _chosen = plans.first.period;
        }
      });
    } on Object catch (error) {
      debugPrint('Could not load the plans: $error');
      if (mounted) setState(() => _loadFailed = true);
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
      ),
    );
  }

  /// The crests, the promise, and what it buys.
  Widget _pitch(BuildContext context, L l) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _TierArc(),
        const SizedBox(height: 28),
        Text(
          l.paywallTitle,
          key: const Key('paywallTitle'),
          textAlign: TextAlign.center,
          style: context.type.title.copyWith(
            fontSize: 32,
            height: 1.12,
            color: context.colors.text,
          ),
        ),
        const SizedBox(height: 26),
        _Perk(icon: Icons.videocam_outlined, text: l.paywallPerkDuels),
        _Perk(icon: Icons.emoji_events_outlined, text: l.paywallPerkLadder),
        _Perk(icon: Icons.group_outlined, text: l.paywallPerkFriends),
        _Perk(icon: Icons.insights_outlined, text: l.paywallPerkHistory),
      ],
    );
  }

  Widget _purchaseArea(BuildContext context, L l) {
    final colors = context.colors;
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
              Text(
                l.paywallLoadFailed,
                textAlign: TextAlign.center,
                style: context.type.body.copyWith(color: colors.muted),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (yearly != null)
                Expanded(
                  child: _PlanCard(
                    key: const Key('planYearly'),
                    label: l.paywallYearly,
                    price: yearly.priceString,
                    detail: l.paywallPerWeek(yearly.perWeek()),
                    badge: saving == null
                        ? null
                        : l.paywallSave(localNumber(context, saving)),
                    selected: _chosen == PlanPeriod.yearly,
                    onTap: () => setState(() => _chosen = PlanPeriod.yearly),
                  ),
                ),
              if (yearly != null && weekly != null) const SizedBox(width: 10),
              if (weekly != null)
                Expanded(
                  child: _PlanCard(
                    key: const Key('planWeekly'),
                    label: l.paywallWeekly,
                    price: weekly.priceString,
                    detail: l.paywallEveryWeek,
                    selected: _chosen == PlanPeriod.weekly,
                    onTap: () => setState(() => _chosen = PlanPeriod.weekly),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
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
                      l.paywallStart,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 17,
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
            style: context.type.label.copyWith(color: AppColors.loss),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          apple ? l.paywallRenewsApple : l.paywallRenewsPlay,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.muted, fontSize: 11, height: 1.4),
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

/// The seven crests, Iron to Master, rising to the middle — the whole ladder
/// the subscription is the way onto.
class _TierArc extends StatelessWidget {
  const _TierArc();

  /// Each crest's size against the middle one's.
  static const _scale = [0.72, 0.84, 0.94, 1.12, 0.94, 0.84, 0.72];
  static const _gap = 6.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final total = _scale.reduce((a, b) => a + b);
        final unit =
            ((constraints.maxWidth - _gap * (_scale.length - 1)) / total)
                .clamp(24.0, 70.0)
                .toDouble();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < _scale.length; i++) ...[
              if (i > 0) const SizedBox(width: _gap),
              _GlowingCrest(tierIndex: i, size: unit * _scale[i]),
            ],
          ],
        );
      },
    );
  }
}

/// A crest with its own colour bleeding out past its edges — a blurred,
/// tinted copy of the same silhouette behind it, not a ring.
class _GlowingCrest extends StatelessWidget {
  const _GlowingCrest({required this.tierIndex, required this.size});

  final int tierIndex;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tint = kTiers[tierIndex.clamp(0, kTiers.length - 1)].color;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: size * 0.16,
              sigmaY: size * 0.16,
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                tint.withValues(alpha: 0.75),
                BlendMode.srcIn,
              ),
              child: TierBadge(tierIndex: tierIndex, size: size),
            ),
          ),
          TierBadge(tierIndex: tierIndex, size: size),
        ],
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  const _Perk({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colors.surfaceRaised,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 21, color: context.colors.brand),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: context.type.body.copyWith(
                fontSize: 16,
                color: context.colors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
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
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? colors.brand : colors.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The same height whether or not there is a badge, so the two
                // cards line up.
                SizedBox(
                  height: 22,
                  child: badge == null
                      ? null
                      : Align(
                          alignment: AlignmentDirectional.centerStart,
                          // A pill the size of its text, shrunk rather than
                          // cut when a language runs long.
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                badge!,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Color(0xFF2A1E05),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.type.label.copyWith(color: colors.muted),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    price,
                    style: context.type.statValue.copyWith(
                      fontSize: 26,
                      color: colors.text,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.muted, fontSize: 12),
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
            fontSize: 12,
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
  Widget build(BuildContext context) =>
      Text('·', style: TextStyle(color: context.colors.faint, fontSize: 12));
}
