/// The paywall: the whole app is behind it, so the ways through it — paying,
/// restoring — and the things it must offer without payment are each
/// checked here against a fake store.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/paywall.dart';
import 'package:outrepd/subscription.dart';
import 'package:outrepd/theme.dart';

const _weekly = Plan(
  period: PlanPeriod.weekly,
  price: 4.99,
  priceString: r'$4.99',
  currencyCode: 'USD',
);
const _yearly = Plan(
  period: PlanPeriod.yearly,
  price: 39.99,
  priceString: r'$39.99',
  currencyCode: 'USD',
  pricePerWeekString: r'$0.77',
);

class _FakeStore implements Storefront {
  _FakeStore({this.active = false});

  bool active;
  bool failPlans = false;
  BuyOutcome nextOutcome = BuyOutcome.bought;
  bool restoreFinds = false;
  Plan? bought;
  int planLoads = 0;
  int starts = 0;

  @override
  Future<bool> start(String? userId) async {
    starts++;
    return active;
  }

  @override
  Future<bool> identify(String userId) async => active;

  @override
  Future<bool> check() async => active;

  @override
  Future<List<Plan>> plans() async {
    planLoads++;
    if (failPlans) throw StateError('offline');
    return const [_weekly, _yearly];
  }

  @override
  Future<({BuyOutcome outcome, bool active})> buy(Plan plan) async {
    bought = plan;
    if (nextOutcome == BuyOutcome.bought) active = true;
    return (outcome: nextOutcome, active: active);
  }

  @override
  Future<bool> restore() async {
    if (restoreFinds) active = true;
    return active;
  }

  @override
  void onChange(void Function(bool active) listener) {}
}

Widget _app({Locale locale = const Locale('en'), double scale = 1}) =>
    MaterialApp(
      theme: buildTheme(Brightness.dark),
      locale: locale,
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(scale),
        ),
        child: child!,
      ),
      home: const PaywallGate(child: Text('inside the app')),
    );

/// A small phone: the paywall has to fit the way to pay on one without
/// scrolling to it.
void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(360 * 3, 720 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Lets the gate hear from the store and the plans load. Not pumpAndSettle:
/// a spinner is on screen while either is pending and it never settles.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => Subscription.instance.use(null));

  group('the gate', () {
    testWidgets('a build with no store has no paywall', (tester) async {
      Subscription.instance.use(null);
      await tester.pumpWidget(_app());
      expect(find.text('inside the app'), findsOneWidget);
      expect(find.byKey(const Key('paywallTitle')), findsNothing);
    });

    testWidgets('an account with the subscription goes straight in',
        (tester) async {
      Subscription.instance.use(_FakeStore(active: true));
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);
      expect(find.text('inside the app'), findsOneWidget);
      expect(find.byKey(const Key('paywallTitle')), findsNothing);
    });

    testWidgets('an account without it sees only the paywall', (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);
      expect(find.text('inside the app'), findsNothing);
      expect(find.text('Climb from Iron to Master'), findsOneWidget);
      // No way past it: no close button, no skip.
      expect(find.byType(CloseButton), findsNothing);
      expect(find.byType(BackButton), findsNothing);
      expect(find.textContaining('Skip'), findsNothing);
    });

    testWidgets('the store is started once, however often the gate is built',
        (tester) async {
      final store = _FakeStore();
      Subscription.instance.use(store);
      _phone(tester);
      await tester.pumpWidget(_app());
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_app());
      await _settle(tester);
      expect(store.starts, 1);
    });
  });

  group('the plans', () {
    testWidgets('both prices, the saving, and the yearly plan chosen',
        (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      expect(find.text(r'$39.99'), findsOneWidget);
      expect(find.text(r'$4.99'), findsOneWidget);
      expect(find.text(r'$0.77/week'), findsOneWidget);
      expect(find.text('per week'), findsOneWidget);
      // 39.99 a year against 4.99 a week for 52 weeks.
      expect(find.text('Save 85%'), findsOneWidget);
      expect(
        find.text('Renews automatically until you cancel. '
            'Cancel anytime in Google Play.'),
        findsOneWidget,
      );
    });

    testWidgets('the button buys the yearly plan unless weekly is picked',
        (tester) async {
      final store = _FakeStore()..nextOutcome = BuyOutcome.cancelled;
      Subscription.instance.use(store);
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(store.bought?.period, PlanPeriod.yearly);

      await tester.tap(find.byKey(const Key('planWeekly')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(store.bought?.period, PlanPeriod.weekly);
    });

    testWidgets('plans that cannot load say so and can be tried again',
        (tester) async {
      final store = _FakeStore()..failPlans = true;
      Subscription.instance.use(store);
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      expect(find.byKey(const Key('paywallRetry')), findsOneWidget);
      store.failPlans = false;
      await tester.tap(find.byKey(const Key('paywallRetry')));
      await _settle(tester);
      expect(find.text(r'$39.99'), findsOneWidget);
      expect(store.planLoads, 2);
    });
  });

  group('buying', () {
    testWidgets('a purchase opens the app', (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(find.text('inside the app'), findsOneWidget);
    });

    testWidgets('backing out of the store says nothing and stays',
        (tester) async {
      final store = _FakeStore()..nextOutcome = BuyOutcome.cancelled;
      Subscription.instance.use(store);
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(find.text('inside the app'), findsNothing);
      expect(find.byKey(const Key('paywallNote')), findsNothing);
    });

    testWidgets('a failed purchase says so', (tester) async {
      final store = _FakeStore()..nextOutcome = BuyOutcome.failed;
      Subscription.instance.use(store);
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(find.text("The purchase didn't go through. Try again."),
          findsOneWidget);
      expect(find.text('inside the app'), findsNothing);
    });

    testWidgets('a pending payment says it is pending', (tester) async {
      final store = _FakeStore()..nextOutcome = BuyOutcome.pending;
      Subscription.instance.use(store);
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(find.textContaining('pending'), findsOneWidget);
    });
  });

  group('without paying', () {
    testWidgets('restore finds an earlier subscription', (tester) async {
      final store = _FakeStore()..restoreFinds = true;
      Subscription.instance.use(store);
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      await tester.tap(find.byKey(const Key('paywallRestore')));
      await _settle(tester);
      expect(find.text('inside the app'), findsOneWidget);
    });

    testWidgets('restore with nothing to restore says so', (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      await tester.tap(find.byKey(const Key('paywallRestore')));
      await _settle(tester);
      expect(find.text('No subscription found to restore.'), findsOneWidget);
    });

    testWidgets('the terms, the privacy policy and account deletion are there',
        (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);

      expect(find.text('Terms'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      await tester.tap(find.byKey(const Key('paywallAccount')));
      await _settle(tester);
      expect(find.byKey(const Key('paywallDeleteAccount')), findsOneWidget);
    });
  });

  group('layout', () {
    for (final code in [
      'en', 'es', 'fr', 'de', 'pt', 'it', //
      'ru', 'tr', 'id', 'hi', 'ja', 'ko', 'zh',
    ]) {
      testWidgets('fits a small phone in $code at 1.3x text', (tester) async {
        Subscription.instance.use(_FakeStore());
        _phone(tester);
        await tester.pumpWidget(_app(locale: Locale(code), scale: 1.3));
        await _settle(tester);
        expect(tester.takeException(), isNull);

        // The button is on screen without scrolling.
        final buy = tester.getRect(find.byKey(const Key('paywallBuy')));
        expect(buy.bottom, lessThanOrEqualTo(720));
      });
    }
  });

  group('the numbers', () {
    test('the saving is against paying weekly for a year', () {
      expect(yearlySaving(_weekly, _yearly), 85);
    });

    test('no saving is claimed across two currencies', () {
      const euros = Plan(
        period: PlanPeriod.yearly,
        price: 39.99,
        priceString: '39,99 €',
        currencyCode: 'EUR',
      );
      expect(yearlySaving(_weekly, euros), isNull);
    });

    test('a yearly plan without a store per-week price works one out', () {
      const plain = Plan(
        period: PlanPeriod.yearly,
        price: 52,
        priceString: r'$52.00',
        currencyCode: 'USD',
      );
      expect(plain.perWeek(), r'$1.00');
    });
  });
}
