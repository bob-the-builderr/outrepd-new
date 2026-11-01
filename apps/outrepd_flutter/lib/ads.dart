/// The ads that keep the app free: one full-screen ad as a result screen is
/// left, for any account without Pro.
///
/// The rules are the user's (2026-10-28):
///
/// * After every game — ranked, live, a friend's, a saved set, Adventure —
///   as its result screen is left. Not between a rematch and the next one:
///   both lifters are still there, and the ad waits until one of them goes.
/// * Never in an account's first [freeGames] games. Leaving the last of them
///   is where the ask comes instead (lib/screens/ad_ask.dart): why there are
///   ads, then, where the law asks, Google's consent form, and on an iPhone
///   Apple's tracking question. The first ad is the next game's.
/// * Pro (lib/subscription.dart) takes them all out. It is offered once on
///   its own, as the first ad closes; after that it waits beside the bell
///   and in Settings, never under a result (2026-11-01).
/// * The app is for 13 and over (2026-10-28: the user wants a 13+ rating, so
///   the ads can be the ordinary kind); the onboarding turns away anybody
///   younger. Ads are capped at the teen rating.
///
/// The ads come from AppLovin MAX (the user's pick, 2026-11-01, after a week
/// in which AdMob served none): an auction on every ad between AppLovin and
/// the networks it brings, the highest paying. The consent before them is
/// still Google's form, where the law asks for one, and Apple's question;
/// MAX reads both answers from the phone. The AdMob package stays only for
/// that form.
///
/// A build with no AppLovin key or ad unit — the tests, the web preview, a
/// build made without them — has no ads at all, the way a build with no
/// RevenueCat key has no paywall.
library;

import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:applovin_max/applovin_max.dart' show AppLovinMAX, InterstitialListener;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Only for Google's consent form, the one the law asks for in Europe.
import 'package:google_mobile_ads/google_mobile_ads.dart'
    show ConsentForm, ConsentInformation, ConsentRequestParameters;
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/ad_ask.dart';
import 'screens/paywall.dart';
import 'subscription.dart';

/// Supplied at build time from the AppLovin account, never committed: the
/// SDK key, and the interstitial ad units, one per store. Not secrets — they
/// ship inside the app — but the account's to hand out.
const kAppLovinSdkKey = String.fromEnvironment('APPLOVIN_SDK_KEY');
const kMaxIosInterstitial = String.fromEnvironment('APPLOVIN_IOS_INTERSTITIAL');
const kMaxAndroidInterstitial = String.fromEnvironment(
  'APPLOVIN_ANDROID_INTERSTITIAL',
);

class Ads extends ChangeNotifier {
  Ads._();

  static final instance = Ads._();

  /// Games a new account plays before its first ad.
  static const freeGames = 3;

  static const _gamesKey = 'adsGamesPlayed';
  static const _askedKey = 'adsAsked';
  static const _offeredKey = 'adsProOffered';

  int _games = 0;
  bool _asked = false;
  bool _offered = false;

  bool _started = false;
  bool _loading = false;

  /// An ad is loaded and waiting to be shown.
  bool _ready = false;

  /// Completes as the ad on screen closes, or fails to show.
  Completer<void>? _closing;

  String get _unit {
    if (kIsWeb) return '';
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => kMaxIosInterstitial,
      TargetPlatform.android => kMaxAndroidInterstitial,
      _ => '',
    };
  }

  /// Whether this build shows ads at all.
  bool get configured => kAppLovinSdkKey.isNotEmpty && _unit.isNotEmpty;

  bool get _pro => Subscription.instance.active;

  /// Reads what this phone has already been through. At launch; an account
  /// that has had the ask gets its consent checked and its first ad loaded.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _games = prefs.getInt(_gamesKey) ?? 0;
    _asked = prefs.getBool(_askedKey) ?? false;
    _offered = prefs.getBool(_offeredKey) ?? false;
    if (!configured || !_asked) return;
    // Once the store has said whether this account has Pro: a subscriber's
    // phone has no business loading an ad, or showing a consent form for one.
    final subscription = Subscription.instance;
    void whenKnown() {
      if (subscription.enabled && !subscription.known) return;
      subscription.removeListener(whenKnown);
      if (!_pro) unawaited(_start());
    }

    subscription.addListener(whenKnown);
    whenKnown();
  }

  /// A game is over and its result screen is being left, from [context] —
  /// that screen's, still mounted. Waits for the ad, and anything shown after
  /// it, to close, so whatever comes next does not start behind it.
  ///
  /// [rematch] when the next thing is a rematch with the same person: the
  /// game counts towards the free ones, and there is no ad.
  Future<void> afterGame(BuildContext context, {bool rematch = false}) async {
    if (!configured) return;
    _games++;
    unawaited(_save());
    if (_pro || rematch || _games < freeGames) return;
    final navigator = Navigator.of(context, rootNavigator: true);

    if (!_asked) {
      _asked = true;
      unawaited(_save());
      // The ask is about Apple's question, so an Android phone goes straight
      // to the consent form, where the law asks for one.
      final apple = defaultTargetPlatform == TargetPlatform.iOS;
      if (apple) {
        await navigator.push<bool>(
          MaterialPageRoute(builder: (_) => const AdAskScreen()),
        );
      }
      if (!_pro) await _start(askTracking: apple);
      return;
    }

    if (!_ready || !(await AppLovinMAX.isInterstitialReady(_unit) ?? false)) {
      // Nothing in hand — no fill, no network: no ad this time, and another
      // is fetched for the next.
      _ready = false;
      _load();
      return;
    }
    _ready = false;
    notifyListeners();
    final closed = _closing = Completer<void>();
    AppLovinMAX.showInterstitial(_unit);
    await closed.future;
    _load();

    // Once, as the first ad closes: the way to never see another.
    if (!_offered && navigator.mounted) {
      _offered = true;
      unawaited(_save());
      await openPro(navigator.context);
    }
  }

  /// Consent where the law asks for it, Apple's question when [askTracking],
  /// then AppLovin and the first ad. AppLovin reads the consent form's answer
  /// and Apple's from the phone; nothing is passed to it by hand.
  Future<void> _start({bool askTracking = false}) async {
    if (_started) return;
    _started = true;
    try {
      await _consent();
      if (askTracking) {
        final status = await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      }
      if (!await ConsentInformation.instance.canRequestAds()) {
        _started = false;
        return;
      }
      AppLovinMAX.setInterstitialListener(
        InterstitialListener(
          onAdLoadedCallback: (_) {
            _loading = false;
            _ready = true;
            notifyListeners();
          },
          onAdLoadFailedCallback: (_, error) {
            // Tried again after the next game, not in a loop: a phone with
            // no fill would otherwise ask for ads it is never going to get.
            debugPrint('No ad: ${error.message}');
            _loading = false;
          },
          onAdDisplayedCallback: (_) {},
          onAdDisplayFailedCallback: (_, error) {
            debugPrint('The ad would not show: ${error.message}');
            _closed();
          },
          onAdClickedCallback: (_) {},
          onAdHiddenCallback: (_) => _closed(),
        ),
      );
      if (await AppLovinMAX.initialize(kAppLovinSdkKey) == null) {
        _started = false;
        return;
      }
      _load();
    } on Object catch (error) {
      debugPrint('Ads did not start: $error');
      _started = false;
    }
  }

  /// Google's consent form, for the places that require one (the EEA, the
  /// UK, Switzerland); nothing anywhere else. Done when the form is closed,
  /// or when there was nothing to show.
  Future<void> _consent() {
    final done = Completer<void>();
    void finish([Object? error]) {
      if (error != null) debugPrint('Consent: $error');
      if (!done.isCompleted) done.complete();
    }

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => ConsentForm.loadAndShowConsentFormIfRequired(
        (error) => finish(error?.message),
      ),
      (error) => finish(error.message),
    );
    return done.future;
  }

  void _load() {
    if (!_started || _loading || _ready || _pro) return;
    _loading = true;
    AppLovinMAX.loadInterstitial(_unit);
  }

  /// The ad on screen closed, or never showed: whatever waits on it goes on.
  void _closed() {
    final closing = _closing;
    _closing = null;
    if (closing != null && !closing.isCompleted) closing.complete();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_gamesKey, _games);
      await prefs.setBool(_askedKey, _asked);
      await prefs.setBool(_offeredKey, _offered);
    } on Object catch (error) {
      debugPrint('Could not keep the ad count: $error');
    }
  }
}

