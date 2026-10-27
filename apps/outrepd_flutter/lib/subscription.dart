/// The subscription: whether this account has paid, and the way to pay.
///
/// Pro takes the ads out (lib/ads.dart). The app itself is free since
/// 2026-10-28; until then the whole of it sat behind this, with no way past
/// but paying or restoring. Pro is offered from screens/paywall.dart.
///
/// RevenueCat does the store work. Everything the rest of the app touches goes
/// through [Storefront], so the screens and their tests never see a store SDK:
/// a test hands in a fake, and a build with no RevenueCat key has no
/// storefront at all — which leaves the app open, the same way a build with no
/// Supabase keys runs with no server. The release workflow warns about that
/// build rather than let it go out unnoticed.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'backend/backend.dart';

/// Supplied at build time, never committed — the same file as the Supabase
/// keys (`supabase/keys.env`). These are RevenueCat's *public* SDK keys; they
/// ship inside the app by design.
const kRevenueCatAndroidKey = String.fromEnvironment('REVENUECAT_ANDROID_KEY');
const kRevenueCatAppleKey = String.fromEnvironment('REVENUECAT_APPLE_KEY');

/// The entitlement both plans unlock, as named in the RevenueCat dashboard.
const kProEntitlement = 'pro';

enum PlanPeriod { weekly, yearly }

/// One way to pay, as the store prices it — in the buyer's own currency.
class Plan {
  const Plan({
    required this.period,
    required this.price,
    required this.priceString,
    required this.currencyCode,
    this.pricePerWeekString,
    this.trialDays,
    this.handle,
  });

  final PlanPeriod period;
  final double price;

  /// How long the free trial runs before the first charge, in days — or null
  /// when this plan has none, or this account has already had one. The
  /// store decides both: the trial is an introductory offer set up on the
  /// product in App Store Connect and Play Console, and each store gives it
  /// once per account.
  final int? trialDays;

  /// Formatted by the store: "$39.99", "39,99 €", "EGP 1,999.99".
  final String priceString;
  final String currencyCode;

  /// Formatted by the store where it offers one.
  final String? pricePerWeekString;

  /// The store's own object for this plan, handed back to [Storefront.buy].
  final Object? handle;

  /// What a week costs on this plan, formatted in its currency.
  String perWeek() {
    if (period == PlanPeriod.weekly) return priceString;
    final given = pricePerWeekString;
    if (given != null && given.isNotEmpty) return given;
    return NumberFormat.simpleCurrency(name: currencyCode).format(price / 52);
  }
}

/// The free trial on [product], in days, or null when it has none.
///
/// The App Store reports it as an introductory price of nothing; Google Play
/// as a free phase on the product's default offer. Weeks and months are
/// turned into days so the paywall can count to the first charge.
int? freeTrialDays(StoreProduct product) {
  int? days(PeriodUnit unit, int count) => switch (unit) {
    PeriodUnit.day => count,
    PeriodUnit.week => count * 7,
    PeriodUnit.month => count * 30,
    PeriodUnit.year => count * 365,
    _ => null,
  };

  final intro = product.introductoryPrice;
  if (intro != null && intro.price == 0) {
    final length = days(intro.periodUnit, intro.periodNumberOfUnits);
    if (length != null && length > 0) {
      return length * (intro.cycles > 0 ? intro.cycles : 1);
    }
  }
  final period = product.defaultOption?.freePhase?.billingPeriod;
  if (period != null) {
    final length = days(period.unit, period.value);
    if (length != null && length > 0) return length;
  }
  return null;
}

/// How much the yearly plan saves against paying weekly for a year, as a
/// whole percentage, or null when it saves nothing or the plans cannot be
/// compared.
int? yearlySaving(Plan weekly, Plan yearly) {
  if (weekly.currencyCode != yearly.currencyCode) return null;
  final weeklyForAYear = weekly.price * 52;
  if (weeklyForAYear <= 0) return null;
  final saving = ((1 - yearly.price / weeklyForAYear) * 100).round();
  return saving > 0 ? saving : null;
}

enum BuyOutcome {
  bought,

  /// The buyer backed out of the store's sheet. Not an error.
  cancelled,

  /// The store took the order but has not confirmed payment (some Google
  /// Play payment methods). Access follows when it does.
  pending,

  failed,
}

/// The store, as the app needs it.
abstract class Storefront {
  /// Starts the store for [userId] (null when there is no account yet) and
  /// says whether that account has Pro.
  Future<bool> start(String? userId);

  /// Switches to [userId] — a sign-in to a different account — and says
  /// whether that one has Pro.
  Future<bool> identify(String userId);

  /// Whether the current account has Pro, from the store's cache when it is
  /// offline.
  Future<bool> check();

  /// The same, asked of the store afresh: for a grant made on the server —
  /// a friend's code — which the store's cache has not heard of yet.
  Future<bool> checkFresh();

  /// The weekly and yearly plans, weekly first.
  Future<List<Plan>> plans();

  Future<({BuyOutcome outcome, bool active})> buy(Plan plan);

  /// Brings back a subscription bought on another phone or before a
  /// reinstall. Says whether the account has Pro afterwards.
  Future<bool> restore();

  /// Called whenever the store learns something new — a renewal, an
  /// expiry, a purchase finishing in the background.
  void onChange(void Function(bool active) listener);

  /// Forgets the account — signing out. A purchase made after this belongs
  /// to whoever signs in next, not to the account that left.
  Future<void> forget();
}

/// The app's one view of the subscription.
class Subscription extends ChangeNotifier {
  Subscription._();

  static final instance = Subscription._();

  Storefront? _store;
  bool _started = false;
  String? _userId;
  bool? _active;
  bool _failed = false;

  /// Whether this build has a paywall at all.
  bool get enabled => _store != null;

  /// Whether the answer is in. Until it is, the gate shows nothing rather
  /// than flash the paywall at somebody who has paid.
  bool get known => _active != null || _failed;

  bool get active => _active ?? false;

  Storefront? get store => _store;

  /// The storefront this build can use: RevenueCat on a phone with its key
  /// compiled in, and none anywhere else — the web preview, the tests, or a
  /// build made without the key.
  static Storefront? forThisBuild() {
    if (kIsWeb) return null;
    final key = switch (defaultTargetPlatform) {
      TargetPlatform.android => kRevenueCatAndroidKey,
      TargetPlatform.iOS => kRevenueCatAppleKey,
      _ => '',
    };
    return key.isEmpty ? null : RevenueCatStorefront(key);
  }

  /// Chooses the storefront. Called once at launch, and by tests.
  void use(Storefront? store) {
    _store = store;
    _started = false;
    _userId = null;
    _active = null;
    _failed = false;
    notifyListeners();
  }

  /// Makes sure the store is running and knows whose account this is, then
  /// reads whether it has Pro.
  ///
  /// Never throws. A store that cannot be reached leaves the answer at "no"
  /// — the paywall then says it could not load and offers to try again —
  /// because an app this one's whole business sits behind cannot open on a
  /// network error.
  Future<void> refresh(String? userId) async {
    // One at a time: two gates built back to back must not start the store
    // twice.
    while (_inFlight != null) {
      await _inFlight;
    }
    final run = _refresh(userId);
    _inFlight = run;
    try {
      await run;
    } finally {
      if (identical(_inFlight, run)) _inFlight = null;
    }
  }

  Future<void>? _inFlight;

  Future<void> _refresh(String? userId) async {
    final store = _store;
    if (store == null) return;
    try {
      final bool active;
      if (!_started) {
        active = await store.start(userId);
        _started = true;
        _userId = userId;
        store.onChange(_set);
      } else if (userId != null && userId != _userId) {
        active = await store.identify(userId);
        _userId = userId;
      } else {
        active = await store.check();
      }
      _failed = false;
      _set(active);
    } on Object catch (error) {
      debugPrint('Could not read the subscription: $error');
      _failed = true;
      notifyListeners();
    }
  }

  /// Records a purchase or a restore the paywall just finished.
  void settle(bool active) => _set(active);

  /// Signing out: the store lets go of the account, and nothing is known
  /// about the next one until the gate asks.
  Future<void> forget() async {
    final store = _store;
    if (store != null && _started) {
      try {
        await store.forget();
      } on Object catch (error) {
        debugPrint('Could not sign the store out: $error');
      }
    }
    _userId = null;
    _active = null;
    _failed = false;
    notifyListeners();
  }

  void _set(bool active) {
    if (_active == active && !_failed) return;
    final became = active && _active != true;
    _active = active;
    _failed = false;
    notifyListeners();
    // The store has said yes — a purchase, a restore, or an app opened by a
    // subscriber. The server hears it from RevenueCat's webhook too, but that
    // can be seconds behind, and the server is what lets a duel be played.
    // Not awaited: the app opens on the store's word; this only catches the
    // server up.
    if (became) unawaited(_catchUpServer());
  }

  Future<void> _catchUpServer() async {
    try {
      await backend.syncSubscription();
    } on Object catch (error) {
      // The webhook still gets there; this was only the faster way.
      debugPrint('Could not sync the subscription to the server: $error');
    }
  }
}

/// [Storefront] over RevenueCat.
class RevenueCatStorefront implements Storefront {
  RevenueCatStorefront(this.apiKey);

  final String apiKey;

  static bool _hasPro(CustomerInfo info) =>
      info.entitlements.active.containsKey(kProEntitlement);

  @override
  Future<bool> start(String? userId) async {
    final configuration = PurchasesConfiguration(apiKey);
    if (userId != null) configuration.appUserID = userId;
    await Purchases.configure(configuration);
    return _hasPro(await Purchases.getCustomerInfo());
  }

  @override
  Future<bool> identify(String userId) async =>
      _hasPro((await Purchases.logIn(userId)).customerInfo);

  @override
  Future<bool> check() async => _hasPro(await Purchases.getCustomerInfo());

  @override
  Future<bool> checkFresh() async {
    await Purchases.invalidateCustomerInfoCache();
    return _hasPro(await Purchases.getCustomerInfo());
  }

  @override
  Future<List<Plan>> plans() async {
    final offering = (await Purchases.getOfferings()).current;
    if (offering == null) {
      throw StateError('No current offering in RevenueCat');
    }
    Package? find(PackageType type) {
      for (final package in offering.availablePackages) {
        if (package.packageType == type) return package;
      }
      return null;
    }

    final weekly = offering.weekly ?? find(PackageType.weekly);
    final yearly = offering.annual ?? find(PackageType.annual);
    final eligible = await _trialEligibility([
      for (final package in [weekly, yearly])
        if (package != null) package.storeProduct.identifier,
    ]);
    return [
      if (weekly != null) _plan(PlanPeriod.weekly, weekly, eligible),
      if (yearly != null) _plan(PlanPeriod.yearly, yearly, eligible),
    ];
  }

  /// Which products this account may still have a free trial on.
  ///
  /// Asked of the App Store, which offers a trial once per subscription
  /// group however many times the paywall shows it. Google Play leaves an
  /// ineligible offer out of the product altogether and answers "unknown"
  /// here, so unknown counts as eligible — as does a check that fails, since
  /// the store's own purchase sheet states the real terms either way.
  static Future<Set<String>> _trialEligibility(List<String> ids) async {
    try {
      final answers =
          await Purchases.checkTrialOrIntroductoryPriceEligibility(ids);
      return {
        for (final id in ids)
          if (answers[id]?.status !=
                  IntroEligibilityStatus.introEligibilityStatusIneligible &&
              answers[id]?.status !=
                  IntroEligibilityStatus
                      .introEligibilityStatusNoIntroOfferExists)
            id,
      };
    } on Object catch (error) {
      debugPrint('Could not check trial eligibility: $error');
      return ids.toSet();
    }
  }

  static Plan _plan(PlanPeriod period, Package package, Set<String> eligible) {
    final product = package.storeProduct;
    return Plan(
      period: period,
      price: product.price,
      priceString: product.priceString,
      currencyCode: product.currencyCode,
      pricePerWeekString: product.pricePerWeekString,
      trialDays: eligible.contains(product.identifier)
          ? freeTrialDays(product)
          : null,
      handle: package,
    );
  }

  @override
  Future<({BuyOutcome outcome, bool active})> buy(Plan plan) async {
    final package = plan.handle;
    if (package is! Package) {
      return (outcome: BuyOutcome.failed, active: false);
    }
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      final active = _hasPro(result.customerInfo);
      return (
        outcome: active ? BuyOutcome.bought : BuyOutcome.pending,
        active: active,
      );
    } on PlatformException catch (error) {
      final outcome = switch (PurchasesErrorHelper.getErrorCode(error)) {
        PurchasesErrorCode.purchaseCancelledError => BuyOutcome.cancelled,
        PurchasesErrorCode.paymentPendingError => BuyOutcome.pending,
        _ => BuyOutcome.failed,
      };
      if (outcome == BuyOutcome.failed) {
        debugPrint('Purchase failed: ${error.code} ${error.message}');
      }
      return (outcome: outcome, active: false);
    }
  }

  @override
  Future<bool> restore() async =>
      _hasPro(await Purchases.restorePurchases());

  @override
  void onChange(void Function(bool active) listener) =>
      Purchases.addCustomerInfoUpdateListener(
        (info) => listener(_hasPro(info)),
      );

  @override
  Future<void> forget() async {
    // logOut throws for an anonymous RevenueCat user, who has nothing to
    // let go of.
    if (!await Purchases.isAnonymous) await Purchases.logOut();
  }
}
