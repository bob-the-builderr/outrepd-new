/// Pro, which takes the ads out of a free app: opened over the app and closed
/// again, the ways into it — paying, restoring — and what the stores ask it to
/// show, each checked here against a fake store.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
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

// The same two plans with the 3-day free trial set up on them in the stores.
const _weeklyTrial = Plan(
  period: PlanPeriod.weekly,
  price: 4.99,
  priceString: r'$4.99',
  currencyCode: 'USD',
  trialDays: 3,
);
const _yearlyTrial = Plan(
  period: PlanPeriod.yearly,
  price: 39.99,
  priceString: r'$39.99',
  currencyCode: 'USD',
  pricePerWeekString: r'$0.77',
  trialDays: 3,
);

class _FakeStore implements Storefront {
  _FakeStore({this.active = false});

  bool active;
  bool failPlans = false;
  List<Plan> plansGiven = const [_weekly, _yearly];
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
  Future<bool> checkFresh() async => active;

  /// Plans the store is still fetching, until the test completes it.
  Completer<List<Plan>>? plansPending;

  @override
  Future<List<Plan>> plans() async {
    planLoads++;
    if (failPlans) throw StateError('offline');
    if (plansPending case final pending?) return pending.future;
    return plansGiven;
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

  int forgets = 0;

  @override
  Future<void> forget() async {
    forgets++;
    active = false;
  }
}

/// Counts the calls that catch the server up on the subscription.
class _SyncCounter extends NoBackend {
  int syncs = 0;

  @override
  Future<void> syncSubscription() async {
    syncs++;
  }
}

/// The app, free, with the one way into Pro the tests need: a button that
/// does what "Remove ads" under a result does.
class _Host extends StatelessWidget {
  const _Host();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('inside the app'),
          TextButton(
            onPressed: () => openPro(context),
            child: const Text('open pro'),
          ),
        ],
      ),
    ),
  );
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
      home: const _Host(),
    );

/// A small phone: Pro has to fit the way to pay on one without scrolling
/// to it.
void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(360 * 3, 720 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Lets the store answer and the plans load. Not pumpAndSettle: a spinner is
/// on screen while either is pending and it never settles.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// The app, and Pro opened over it.
Future<void> _openPro(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  double scale = 1,
}) async {
  await tester.pumpWidget(_app(locale: locale, scale: scale));
  await tester.tap(find.text('open pro'));
  await _settle(tester);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => Subscription.instance.use(null));

  group('a free app', () {
    testWidgets('nothing stands in front of it', (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await tester.pumpWidget(_app());
      await _settle(tester);
      expect(find.text('inside the app'), findsOneWidget);
      expect(find.byKey(const Key('paywallTitle')), findsNothing);
    });

    testWidgets('Pro says what it is, and closes again', (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await _openPro(tester);

      expect(find.text('No ads.\nJust push-ups.'), findsOneWidget);
      expect(
        find.text(
          'Every match stays free. Pro takes the ads out of all of them.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('proClose')));
      await _settle(tester);
      expect(find.byKey(const Key('paywallTitle')), findsNothing);
      expect(find.text('inside the app'), findsOneWidget);
    });

    testWidgets('a build with no store has nothing to open', (tester) async {
      Subscription.instance.use(null);
      _phone(tester);
      await _openPro(tester);
      expect(find.byKey(const Key('paywallTitle')), findsNothing);
    });

    testWidgets('an account with Pro is not offered it again',
        (tester) async {
      final store = _FakeStore(active: true);
      Subscription.instance.use(store);
      await Subscription.instance.refresh(null);
      _phone(tester);
      await _openPro(tester);
      expect(find.byKey(const Key('paywallTitle')), findsNothing);
    });
  });

  group('the free trial', () {
    testWidgets('says the first days are free and what comes after',
        (tester) async {
      Subscription.instance.use(
        _FakeStore()..plansGiven = const [_weeklyTrial, _yearlyTrial],
      );
      _phone(tester);
      await _openPro(tester);

      expect(find.text('3 days free'), findsNWidgets(2));
      expect(find.text('Start my 3-day free trial'), findsOneWidget);
      expect(
        find.text(r'No payment now · then $39.99/year'),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('planWeekly')));
      await tester.pump();
      expect(find.text(r'No payment now · then $4.99/week'), findsOneWidget);
    });

    testWidgets('a plan this account has no trial on promises no free days',
        (tester) async {
      // The yearly plan, chosen first, without a trial; the weekly with one.
      Subscription.instance.use(
        _FakeStore()..plansGiven = const [_weeklyTrial, _yearly],
      );
      _phone(tester);
      await _openPro(tester);

      expect(find.text('Remove ads'), findsOneWidget);
      expect(find.byKey(const Key('trialThen')), findsNothing);
      expect(find.text('3 days free'), findsOneWidget);

      await tester.tap(find.byKey(const Key('planWeekly')));
      await tester.pump();
      expect(find.text('Start my 3-day free trial'), findsOneWidget);
    });

    testWidgets('no free days are claimed before the store has said',
        (tester) async {
      final plans = Completer<List<Plan>>();
      Subscription.instance.use(_FakeStore()..plansPending = plans);
      _phone(tester);
      await _openPro(tester);

      expect(find.text('3 days free'), findsNothing);
      expect(find.text('Start my 3-day free trial'), findsNothing);

      plans.complete(const [_weeklyTrial, _yearlyTrial]);
      await _settle(tester);
      expect(find.text('Start my 3-day free trial'), findsOneWidget);
    });
  });

  group('the plans', () {
    testWidgets('both prices, the saving, and the yearly plan chosen',
        (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await _openPro(tester);

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
      await _openPro(tester);

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
      await _openPro(tester);

      expect(find.byKey(const Key('paywallRetry')), findsOneWidget);
      // The store's own words stay out of sight until somebody asks for
      // them: they help whoever answers a support email, not a subscriber.
      expect(find.byKey(const Key('paywallLoadError')), findsNothing);
      await tester.longPress(find.byKey(const Key('paywallLoadFailed')));
      await tester.pump();
      expect(find.byKey(const Key('paywallLoadError')), findsOneWidget);
      expect(find.textContaining('offline'), findsOneWidget);
      // Still Pro, saying what it is.
      expect(find.byKey(const Key('paywallTitle')), findsOneWidget);
      store.failPlans = false;
      await tester.tap(find.byKey(const Key('paywallRetry')));
      await _settle(tester);
      expect(find.text(r'$39.99'), findsOneWidget);
      expect(store.planLoads, 2);
    });
  });

  group('buying', () {
    testWidgets('a purchase closes Pro and says the ads are off',
        (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await _openPro(tester);

      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(find.byKey(const Key('paywallTitle')), findsNothing);
      expect(find.text('inside the app'), findsOneWidget);
      expect(find.text('Ads are off. Thanks for going Pro.'), findsOneWidget);
      expect(Subscription.instance.active, isTrue);
    });

    testWidgets('a purchase has the server catch up at once', (tester) async {
      // RevenueCat's webhook fills in the server's copy of the subscription,
      // but seconds late.
      final server = _SyncCounter();
      backend = server;
      addTearDown(() => backend = const NoBackend());
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await _openPro(tester);
      expect(server.syncs, 0, reason: 'nothing bought yet');

      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(server.syncs, 1);
    });

    testWidgets('backing out of the store says nothing and stays',
        (tester) async {
      final store = _FakeStore()..nextOutcome = BuyOutcome.cancelled;
      Subscription.instance.use(store);
      _phone(tester);
      await _openPro(tester);

      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(find.byKey(const Key('paywallTitle')), findsOneWidget);
      expect(find.byKey(const Key('paywallNote')), findsNothing);
    });

    testWidgets('a failed purchase says so', (tester) async {
      final store = _FakeStore()..nextOutcome = BuyOutcome.failed;
      Subscription.instance.use(store);
      _phone(tester);
      await _openPro(tester);

      await tester.tap(find.byKey(const Key('paywallBuy')));
      await _settle(tester);
      expect(find.text("The purchase didn't go through. Try again."),
          findsOneWidget);
      expect(find.byKey(const Key('paywallTitle')), findsOneWidget);
    });

    testWidgets('a pending payment says it is pending', (tester) async {
      final store = _FakeStore()..nextOutcome = BuyOutcome.pending;
      Subscription.instance.use(store);
      _phone(tester);
      await _openPro(tester);

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
      await _openPro(tester);

      await tester.tap(find.byKey(const Key('paywallRestore')));
      await _settle(tester);
      expect(find.byKey(const Key('paywallTitle')), findsNothing);
      expect(Subscription.instance.active, isTrue);
    });

    testWidgets('restore with nothing to restore says so', (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await _openPro(tester);

      await tester.tap(find.byKey(const Key('paywallRestore')));
      await _settle(tester);
      expect(find.text('No subscription found to restore.'), findsOneWidget);
    });

    testWidgets('the terms and the privacy policy are there', (tester) async {
      Subscription.instance.use(_FakeStore());
      _phone(tester);
      await _openPro(tester);

      expect(find.text('Terms'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
    });
  });

  group('layout', () {
    for (final code in [
      'en', 'es', 'fr', 'de', 'pt', 'it', //
      'ru', 'tr', 'id', 'hi', 'ja', 'ko', 'zh',
    ]) {
      for (final trial in [false, true]) {
        testWidgets('fits a small phone in $code at 1.3x text'
            '${trial ? ', with the trial' : ''}', (tester) async {
          Subscription.instance.use(
            _FakeStore()
              ..plansGiven = trial
                  ? const [_weeklyTrial, _yearlyTrial]
                  : const [_weekly, _yearly],
          );
          _phone(tester);
          await _openPro(tester, locale: Locale(code), scale: 1.3);
          expect(tester.takeException(), isNull);

          // The button is on screen without scrolling.
          final buy = tester.getRect(find.byKey(const Key('paywallBuy')));
          expect(buy.bottom, lessThanOrEqualTo(720));
        });
      }
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
