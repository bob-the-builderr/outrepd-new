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

/// The Pro subscriptions as each store knows them (App Store Connect; Play
/// Console, where each is a subscription with one base plan, `weekly` or
/// `yearly`), weekly first. RevenueCat's offering hands out the same ones;
/// these are read from the store itself when RevenueCat cannot be reached.
const kProProducts = <TargetPlatform, Map<PlanPeriod, String>>{
  TargetPlatform.iOS: {
    PlanPeriod.weekly: 'com.outrepd.outrepd.pro.weekly',
    PlanPeriod.yearly: 'com.outrepd.outrepd.pro.yearly',
  },
  TargetPlatform.android: {
    PlanPeriod.weekly: 'pro_weekly',
    PlanPeriod.yearly: 'pro_yearly',
  },
};

/// One way to pay, as the store prices it — in the buyer's own currency.
class Plan {
  const Plan({
    required this.period,
    required this.price,
    required this.priceString,
    required this.currencyCode,
    this.pricePerWeekString,
    this.handle,
  });

  final PlanPeriod period;
  final double price;

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

  /// Whether the store has said, for [userId], whether it has Pro: not
  /// before the gate first asks, and not right after signing in to an
  /// account it has not been asked about yet.
  bool answeredFor(String? userId) =>
      _active != null && (userId == null || userId == _userId);

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
    _inFlight = null;
    _serverPro = false;
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
    await _run(_refresh(userId));
  }

  Future<void>? _inFlight;

  Future<void> _run(Future<void> run) async {
    _inFlight = run;
    try {
      await run;
    } finally {
      if (identical(_inFlight, run)) _inFlight = null;
    }
  }

  /// Waits, for [limit] at most, for the store to finish starting or
  /// changing accounts. Pro opens a few seconds into a sign-in at the
  /// latest, and the plans it read while the store was still moving to the
  /// new account did not load (the user, twice, 2026-11-04 and -05).
  Future<void> settled({Duration limit = const Duration(seconds: 15)}) async {
    final run = _inFlight;
    if (run == null) return;
    try {
      await run.timeout(limit);
    } on TimeoutException {
      // Read anyway: the store may still answer.
    }
  }

  Future<void> _refresh(String? userId) async {
    final store = _store;
    if (store == null) return;
    try {
      final bool active;
      if (!_started) {
        active = await store.start(userId);
        _started = true;
        _userId = userId;
        store.onChange((now) => _set(now || _serverPro));
      } else if (userId != null && userId != _userId) {
        active = await store.identify(userId);
        _userId = userId;
      } else {
        active = await store.check();
      }
      if (!active) _serverPro = await _askServer(userId ?? _userId);
      _failed = false;
      _set(active || _serverPro);
    } on Object catch (error) {
      debugPrint('Could not read the subscription: $error');
      // The store could not be reached: the server's word stands in, so a
      // subscriber keeps Pro — the cover, no ads — while RevenueCat does not
      // answer (the user's Pro account showed no cover, 2026-11-05).
      _serverPro = await _askServer(userId ?? _userId);
      if (_serverPro) {
        _failed = false;
        _set(true);
        return;
      }
      _failed = true;
      notifyListeners();
    }
  }

  /// What the server last said of this account's Pro: RevenueCat's webhook
  /// keeps it (pro_looks), whether or not RevenueCat answers this phone.
  /// Counted as well as the store's word, never instead of a yes from it.
  bool _serverPro = false;

  Future<bool> _askServer(String? userId) async {
    if (userId == null || userId.isEmpty) return false;
    try {
      final looks = await backend.proLooks([userId]).timeout(const Duration(seconds: 6));
      return looks[userId]?.pro ?? false;
    } on Object catch (error) {
      debugPrint('Could not ask the server about Pro: $error');
      return _serverPro;
    }
  }

  /// Records a purchase or a restore the paywall just finished.
  void settle(bool active) => _set(active || _serverPro);

  /// Signing out: the store lets go of the account, and nothing is known
  /// about the next one until the gate asks.
  Future<void> forget() async {
    // Not across a start or a sign-in still going on: the store would be
    // let go of while it was still being given the account. A few seconds
    // at most, though; signing out does not wait on a dead connection.
    await settled(limit: const Duration(seconds: 10));
    await _run(_forget());
  }

  Future<void> _forget() async {
    _serverPro = false;
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

  /// Pro is the entitlement, active, with its payment gone through. A store's
  /// billing grace period — access kept while it retries a declined card —
  /// counts for nothing here, by the user's call (2026-10-28): the ads come
  /// back the day a payment fails, not days later.
  static bool _hasPro(CustomerInfo info) {
    final pro = info.entitlements.active[kProEntitlement];
    return pro != null && pro.billingIssueDetectedAt == null;
  }

  @override
  Future<bool> start(String? userId) async {
    final configuration = PurchasesConfiguration(apiKey);
    if (userId != null) configuration.appUserID = userId;
    await Purchases.configure(configuration);
    return _hasPro(await Purchases.getCustomerInfo());
  }

  @override
  Future<bool> identify(String userId) async {
    // The plans first, while RevenueCat still has them on the phone: a new
    // account's sign-in clears its copy, and on a weak connection the Pro
    // screen then could not read them again (the user, 2026-11-04).
    try {
      _lastPlans ??= await _readPlans();
    } on Object catch (error) {
      debugPrint('Could not read the plans before signing in: $error');
    }
    return _hasPro((await Purchases.logIn(userId)).customerInfo);
  }

  @override
  Future<bool> check() async => _hasPro(await Purchases.getCustomerInfo());

  @override
  Future<bool> checkFresh() async {
    await Purchases.invalidateCustomerInfoCache();
    return _hasPro(await Purchases.getCustomerInfo());
  }

  /// The plans last read, for when RevenueCat cannot be reached: a price
  /// does not change between one read and the next.
  List<Plan>? _lastPlans;

  /// RevenueCat's offering first, read again a moment apart when the request
  /// never got an answer. When it still has not — or has no plans in it —
  /// the plans come from the store itself, Google Play or the App Store,
  /// which RevenueCat's servers have no part in; and the last plans read
  /// when the store cannot say either. On a new account the Pro screen said
  /// it could not load the plans, "10: Error performing request" (the user,
  /// 2026-11-04, and again on 2026-11-05 after reading them again had not
  /// been enough).
  @override
  Future<List<Plan>> plans() async {
    Object? failure;
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final plans = await _readPlans();
        if (plans.isNotEmpty) return _lastPlans = plans;
        break;
      } on PlatformException catch (error) {
        failure = error;
        final network = PurchasesErrorHelper.getErrorCode(error) ==
            PurchasesErrorCode.networkError;
        if (!network) break;
        if (attempt < 2) await Future<void>.delayed(Duration(seconds: 1 << attempt));
      } on StateError catch (error) {
        failure = error;
        break;
      }
    }
    try {
      final direct = await _readProducts();
      if (direct.isNotEmpty) return _lastPlans = direct;
    } on Object catch (error) {
      debugPrint('Could not read the plans from the store itself: $error');
    }
    final kept = _lastPlans;
    if (kept != null) return kept;
    if (failure != null) throw failure;
    return const [];
  }

  /// The plans as the store itself prices them, by [kProProducts].
  Future<List<Plan>> _readProducts() async {
    final ids = kProProducts[defaultTargetPlatform];
    if (ids == null) return const [];
    final products = await Purchases.getProducts(ids.values.toList());
    // Google Play names each by its subscription and base plan,
    // "pro_weekly:weekly"; the App Store by the product alone.
    StoreProduct? find(String id) {
      for (final product in products) {
        if (product.identifier == id || product.identifier.startsWith('$id:')) {
          return product;
        }
      }
      return null;
    }

    final plans = <Plan>[];
    for (final entry in ids.entries) {
      final product = find(entry.value);
      if (product != null) plans.add(_fromProduct(entry.key, product));
    }
    return plans;
  }

  Future<List<Plan>> _readPlans() async {
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
    return [
      if (weekly != null) _plan(PlanPeriod.weekly, weekly),
      if (yearly != null) _plan(PlanPeriod.yearly, yearly),
    ];
  }

  static Plan _plan(PlanPeriod period, Package package) =>
      _fromProduct(period, package.storeProduct, package);

  /// [handle] is what [buy] is given back: RevenueCat's package, or the
  /// store's product itself when the plans were read from the store.
  static Plan _fromProduct(PlanPeriod period, StoreProduct product, [Object? handle]) => Plan(
    period: period,
    price: product.price,
    priceString: product.priceString,
    currencyCode: product.currencyCode,
    pricePerWeekString: product.pricePerWeekString,
    handle: handle ?? product,
  );

  @override
  Future<({BuyOutcome outcome, bool active})> buy(Plan plan) async {
    final params = switch (plan.handle) {
      final Package package => PurchaseParams.package(package),
      final StoreProduct product => PurchaseParams.storeProduct(product),
      _ => null,
    };
    if (params == null) {
      return (outcome: BuyOutcome.failed, active: false);
    }
    try {
      final result = await Purchases.purchase(params);
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
