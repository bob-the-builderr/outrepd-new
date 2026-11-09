/// The ads that keep the app free: one full-screen ad as a result screen is
/// left, for any account without Pro.
///
/// The rules are the user's (2026-10-28, changed 2026-11-01):
///
/// * After every game — ranked, live, a friend's, a saved set, Adventure —
///   as its result screen is left, from the very first game. Not between a
///   rematch and the next one: both lifters are still there, and the ad
///   waits until one of them goes.
/// * The ask comes before any of that, the first time the main screen opens
///   ([prepare]): on an iPhone why there are ads (lib/screens/ad_ask.dart),
///   then, where the law asks, Google's consent form, then Apple's tracking
///   question — so the first game's ad is already loaded when it ends.
/// * Pro (lib/subscription.dart) takes them all out. It is offered after
///   every [proEvery]th game, as that game's ad closes; besides, it waits
///   beside the bell and in Settings, never under a result.
/// * The app is for 13 and over (2026-10-28: the user wants a 13+ rating, so
///   the ads can be the ordinary kind); the onboarding turns away anybody
///   younger. AdMob's ads are capped at the teen rating.
///
/// The ads come from Unity LevelPlay first (the user's pick, 2026-11-01, for
/// more money per ad than AdMob alone): an auction on every ad between
/// Unity's networks. When LevelPlay has no ad to give, Google AdMob's is
/// shown instead. (AppLovin MAX was tried the same day and dropped: it was
/// taking no new publishers.) Both read the consent form's answer and
/// Apple's from the phone; nothing is passed to them by hand.
///
/// A build with neither network's ids — the tests, the web preview, a build
/// made without them — has no ads at all, the way a build with no
/// RevenueCat key has no paywall. A build with one of them has that one's.
///
/// Rewarded videos (the user's pick, 2026-11-09): a short video the player
/// chooses to watch, for something that never touches the ladder — the
/// match's XP again, a streak back once a week, a Pro part for a day. Pro
/// gets each reward with no video. LevelPlay's only, no AdMob behind it;
/// with no video loaded the offer is not shown at all ([rewardOffered]).
/// Watching one after a match means no ad as that match is left.
library;

import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart'
    show
        LevelPlay,
        LevelPlayAdError,
        LevelPlayAdInfo,
        LevelPlayConfiguration,
        LevelPlayInitError,
        LevelPlayInitListener,
        LevelPlayInitRequest,
        LevelPlayInterstitialAd,
        LevelPlayInterstitialAdListener,
        LevelPlayReward,
        LevelPlayRewardedAd,
        LevelPlayRewardedAdListener;

import 'screens/ad_ask.dart';
import 'screens/paywall.dart';
import 'subscription.dart';

/// Supplied at build time, never committed: from the LevelPlay account the
/// app key and the interstitial ad unit, from the AdMob account the
/// interstitial ad unit, one of each per store. Not secrets — they ship
/// inside the app — but the accounts' to hand out.
const kLevelPlayIosAppKey = String.fromEnvironment('LEVELPLAY_IOS_APP_KEY');
const kLevelPlayAndroidAppKey = String.fromEnvironment(
  'LEVELPLAY_ANDROID_APP_KEY',
);
const kLevelPlayIosInterstitial = String.fromEnvironment(
  'LEVELPLAY_IOS_INTERSTITIAL',
);
const kLevelPlayAndroidInterstitial = String.fromEnvironment(
  'LEVELPLAY_ANDROID_INTERSTITIAL',
);
/// LevelPlay's rewarded ad units (Rewarded_iOS, Rewarded_Android).
const kLevelPlayIosRewarded = String.fromEnvironment('LEVELPLAY_IOS_REWARDED');
const kLevelPlayAndroidRewarded = String.fromEnvironment(
  'LEVELPLAY_ANDROID_REWARDED',
);
const kAdMobIosInterstitial = String.fromEnvironment('ADMOB_IOS_INTERSTITIAL');
const kAdMobAndroidInterstitial = String.fromEnvironment(
  'ADMOB_ANDROID_INTERSTITIAL',
);

class Ads extends ChangeNotifier {
  Ads._();

  static final instance = Ads._();

  /// Pro is offered after every this many games (the user's call,
  /// 2026-11-01).
  static const proEvery = 5;

  /// Taps on the version in Settings that open [openTestSuite].
  static const testSuiteTaps = 7;

  static const _sinceOfferKey = 'adsGamesSinceProOffer';
  static const _askedKey = 'adsAsked';

  /// Games since Pro was last offered.
  int _sinceOffer = 0;
  bool _asked = false;

  bool _started = false;

  /// Completes with whether LevelPlay's SDK started; null before it is
  /// asked to, and again after it failed, so that it can be asked again.
  Completer<bool>? _levelPlayUp;

  /// LevelPlay's ad: null until its SDK has started.
  LevelPlayInterstitialAd? _levelPlay;
  bool _levelPlayLoading = false;
  bool _levelPlayReady = false;

  /// LevelPlay had nothing to give the last time it was asked, or did not
  /// start at all: AdMob's ad is fetched in its place.
  bool _levelPlayEmpty = false;

  /// Completes as LevelPlay's ad on screen closes (true), or fails to show
  /// (false).
  Completer<bool>? _levelPlayClosing;

  bool _loading = false;
  InterstitialAd? _ad;

  /// LevelPlay's rewarded video: null until its SDK has started, and in a
  /// build without the rewarded ad unit.
  LevelPlayRewardedAd? _rewarded;
  bool _rewardedLoading = false;
  bool _rewardedReady = false;

  /// Completes as the rewarded video closes, or fails to show.
  Completer<void>? _rewardedClosing;

  /// The video was watched far enough for its reward.
  bool _rewardEarned = false;

  /// A rewarded video was watched after a match: that match's ad is skipped.
  bool _skipNextAd = false;

  /// For tests and screenshots: whether a reward is on offer, and whether
  /// watching for it earns it. Null in the app.
  @visibleForTesting
  static bool? debugRewarded;

  String _forStore({required String ios, required String android}) {
    if (kIsWeb) return '';
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => ios,
      TargetPlatform.android => android,
      _ => '',
    };
  }

  String get _levelPlayKey =>
      _forStore(ios: kLevelPlayIosAppKey, android: kLevelPlayAndroidAppKey);
  String get _levelPlayUnit => _forStore(
    ios: kLevelPlayIosInterstitial,
    android: kLevelPlayAndroidInterstitial,
  );
  String get _unit =>
      _forStore(ios: kAdMobIosInterstitial, android: kAdMobAndroidInterstitial);
  String get _rewardedUnit => _forStore(
    ios: kLevelPlayIosRewarded,
    android: kLevelPlayAndroidRewarded,
  );

  bool get _hasLevelPlay => _levelPlayKey.isNotEmpty && _levelPlayUnit.isNotEmpty;
  bool get _hasAdMob => _unit.isNotEmpty;

  /// Whether this build shows ads at all.
  bool get configured => _hasLevelPlay || _hasAdMob;

  bool get _pro => Subscription.instance.active;

  /// Whether a reward can be offered now: always to Pro, who gets it with
  /// no video; to anybody else only while a rewarded video is loaded. A
  /// button for a video that is not there is a button that does nothing.
  bool get rewardOffered {
    if (debugRewarded case final offered?) return offered;
    if (_pro) return true;
    return _hasLevelPlay && _rewardedUnit.isNotEmpty && _rewardedReady;
  }

  /// Whether the reward comes after a video: not for Pro.
  bool get rewardNeedsVideo => debugRewarded != null || !_pro;

  /// Plays a rewarded video, and says whether it was watched far enough to
  /// earn its reward. Pro earns it at once. [afterMatch]: watched on a
  /// result screen, so that match is left with no ad.
  Future<bool> watchForReward({bool afterMatch = false}) async {
    if (debugRewarded case final offered?) {
      if (offered && afterMatch) _skipNextAd = true;
      return offered;
    }
    if (_pro) return true;
    final ad = _rewarded;
    if (ad == null || !_rewardedReady) return false;
    _rewardedReady = false;
    notifyListeners();
    if (!await ad.isAdReady()) {
      _loadRewarded();
      return false;
    }
    _rewardEarned = false;
    final closed = _rewardedClosing = Completer<void>();
    try {
      await ad.showAd();
    } on Object catch (error) {
      debugPrint('The rewarded video would not show: $error');
      _rewardedClosed();
    }
    await closed.future;
    final earned = _rewardEarned;
    if (earned && afterMatch) _skipNextAd = true;
    _loadRewarded();
    return earned;
  }

  /// Reads what this phone has already been through. At launch; an account
  /// that has had the ask gets its consent checked and its first ad loaded.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _sinceOffer = prefs.getInt(_sinceOfferKey) ?? 0;
    _asked = prefs.getBool(_askedKey) ?? false;
    if (!configured || !_asked) return;
    // Started once the store has said whether this account has Pro. Not
    // awaited: this runs before the first screen, and the store is first
    // asked by the first screen (shell.dart) — awaited here, the launch
    // waited on an answer nothing had asked for yet (2026-11-04: "it takes
    // a long time to open").
    unawaited(
      _storeKnown().then((_) {
        if (!_pro) unawaited(_start());
      }),
    );
  }

  /// Once the store has said whether this account has Pro: a subscriber's
  /// phone has no business loading an ad, or showing a consent form for one.
  Future<void> _storeKnown() {
    final subscription = Subscription.instance;
    final known = Completer<void>();
    void whenKnown() {
      if (subscription.enabled && !subscription.known) return;
      subscription.removeListener(whenKnown);
      if (!known.isCompleted) known.complete();
    }

    subscription.addListener(whenKnown);
    whenKnown();
    return known.future;
  }

  /// The ask, the first time the main screen opens, from [context] — that
  /// screen's: on an iPhone why there are ads, then Google's consent form
  /// where the law asks for one, then Apple's question; then the first ad is
  /// loaded, ready for the first game. Once per phone.
  Future<void> prepare(BuildContext context) async {
    if (!configured || _asked) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    await _storeKnown();
    if (_pro || _asked || !navigator.mounted) return;
    await _ask(navigator);
  }

  Future<void> _ask(NavigatorState navigator) async {
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
  }

  /// A game is over and its result screen is being left, from [context] —
  /// that screen's, still mounted. Waits for the ad, and anything shown after
  /// it, to close, so whatever comes next does not start behind it.
  ///
  /// [rematch] when the next thing is a rematch with the same person: the
  /// game counts, and nothing comes between the two — no ad, no Pro.
  Future<void> afterGame(BuildContext context, {bool rematch = false}) async {
    if (_pro) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    _sinceOffer++;
    unawaited(_save());
    if (rematch) return;
    // A rewarded video was watched on this result screen: the promise under
    // its button was no ad after this match, and nothing else either.
    if (_skipNextAd) {
      _skipNextAd = false;
      return;
    }

    if (configured) {
      if (!_asked) {
        // The main screen did not get to ask (an old install, a match
        // straight from a link): asked now, and the ad is the next game's.
        await _ask(navigator);
      } else {
        await _showAd();
      }
    }

    // Every few games, as the ad closes: the way to never see another, and
    // the Pro look.
    if (_sinceOffer >= proEvery && navigator.mounted && Subscription.instance.enabled) {
      _sinceOffer = 0;
      unawaited(_save());
      await openPro(navigator.context);
    }
  }

  /// Shows the ad in hand, LevelPlay's if it has one and AdMob's if not, and
  /// waits for it to close. Without either — no fill, no network — there is
  /// no ad this time, and another is fetched for the next.
  Future<void> _showAd() async {
    if (!await _showLevelPlay()) await _showAdMob();
    _load();
  }

  /// Whether LevelPlay had an ad and showed it.
  Future<bool> _showLevelPlay() async {
    final ad = _levelPlay;
    if (ad == null || !_levelPlayReady) return false;
    _levelPlayReady = false;
    if (!await ad.isAdReady()) return false;
    notifyListeners();
    final closed = _levelPlayClosing = Completer<bool>();
    try {
      await ad.showAd();
    } on Object catch (error) {
      debugPrint('The LevelPlay ad would not show: $error');
      _levelPlayClosed(shown: false);
    }
    return closed.future;
  }

  Future<void> _showAdMob() async {
    final ad = _ad;
    if (ad == null) return;
    _ad = null;
    notifyListeners();
    final closed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('The ad would not show: $error');
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
      },
    );
    await ad.show();
    await closed.future;
  }

  /// Consent where the law asks for it, Apple's question when [askTracking],
  /// then the SDKs and the first ad.
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
      if (_hasLevelPlay) {
        unawaited(_startLevelPlay());
      } else {
        _levelPlayEmpty = true;
      }
      if (_hasAdMob) {
        // Nothing past the teen rating, for an app rated 13+.
        await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(maxAdContentRating: MaxAdContentRating.t),
        );
        await MobileAds.instance.initialize();
      }
      _load();
    } on Object catch (error) {
      debugPrint('Ads did not start: $error');
      _started = false;
    }
  }

  /// Starts LevelPlay's SDK, once; true when it has. Its ad is made, and
  /// loaded, as it says it has started.
  Future<bool> _startLevelPlay() {
    final starting = _levelPlayUp;
    if (starting != null) return starting.future;
    final up = _levelPlayUp = Completer<bool>();
    unawaited(() async {
      try {
        await LevelPlay.setMetaData({
          // Not an app for children: 13 and over.
          'is_child_directed': ['false'],
          // Lets LevelPlay's test screen open ([openTestSuite]).
          'is_test_suite': ['enable'],
        });
        await LevelPlay.init(
          initRequest: LevelPlayInitRequest(appKey: _levelPlayKey),
          initListener: _LevelPlayStart(this),
        );
      } on Object catch (error) {
        _levelPlayDidNotStart('$error');
      }
    }());
    return up.future;
  }

  void _levelPlayStarted() {
    if (_levelPlay != null) return;
    _levelPlay = LevelPlayInterstitialAd(adUnitId: _levelPlayUnit)
      ..setListener(_LevelPlayEvents(this));
    if (_rewardedUnit.isNotEmpty) {
      _rewarded = LevelPlayRewardedAd(adUnitId: _rewardedUnit)
        ..setListener(_RewardedEvents(this));
    }
    final up = _levelPlayUp;
    if (up != null && !up.isCompleted) up.complete(true);
    _load();
  }

  void _levelPlayDidNotStart(String error) {
    debugPrint('LevelPlay did not start: $error');
    final up = _levelPlayUp;
    _levelPlayUp = null;
    if (up != null && !up.isCompleted) up.complete(false);
    _levelPlayEmpty = true;
    _loadAdMob();
  }

  /// LevelPlay's own test screen, for whoever builds the app: whether its
  /// SDK and each network bidding through it made it into the build, with a
  /// test ad from each. Opened by tapping the version in Settings
  /// [testSuiteTaps] times; there is nothing on screen to find it by. Starts
  /// LevelPlay first if this phone has not — a Pro account's never does —
  /// after the consent form where the law asks for one, but loads no ad.
  /// False when this build has no LevelPlay, or it would not start.
  Future<bool> openTestSuite() async {
    if (!_hasLevelPlay) return false;
    if (_levelPlay == null) {
      await _consent();
      if (!await ConsentInformation.instance.canRequestAds()) return false;
      if (!await _startLevelPlay()) return false;
    }
    try {
      await LevelPlay.launchTestSuite();
      return true;
    } on Object catch (error) {
      debugPrint('LevelPlay test screen: $error');
      return false;
    }
  }

  void _levelPlayLoaded() {
    _levelPlayLoading = false;
    _levelPlayReady = true;
    _levelPlayEmpty = false;
    notifyListeners();
  }

  void _levelPlayFailed(LevelPlayAdError error) {
    // Tried again after the next game, not in a loop: a phone with no fill
    // would otherwise ask for ads it is never going to get. AdMob is asked
    // in its place.
    debugPrint('No LevelPlay ad: ${error.errorCode} ${error.errorMessage}');
    _levelPlayLoading = false;
    _levelPlayReady = false;
    _levelPlayEmpty = true;
    _loadAdMob();
  }

  void _rewardedLoaded() {
    _rewardedLoading = false;
    _rewardedReady = true;
    notifyListeners();
  }

  void _rewardedFailed(LevelPlayAdError error) {
    // Asked again after the next game, as the interstitial is: the offer
    // stays hidden meanwhile.
    debugPrint('No rewarded video: ${error.errorCode} ${error.errorMessage}');
    _rewardedLoading = false;
    _rewardedReady = false;
    notifyListeners();
  }

  /// The rewarded video closed, or never showed. A network may say the
  /// reward was earned a moment after it says the video closed, so the
  /// answer waits that moment.
  void _rewardedClosed() {
    final closing = _rewardedClosing;
    _rewardedClosing = null;
    if (closing == null || closing.isCompleted) return;
    Timer(const Duration(milliseconds: 800), () {
      if (!closing.isCompleted) closing.complete();
    });
  }

  void _loadRewarded() {
    final ad = _rewarded;
    if (!_started || _pro || ad == null || _rewardedReady || _rewardedLoading) {
      return;
    }
    _rewardedLoading = true;
    unawaited(ad.loadAd());
  }

  /// LevelPlay's ad on screen closed ([shown]), or never showed.
  void _levelPlayClosed({required bool shown}) {
    final closing = _levelPlayClosing;
    _levelPlayClosing = null;
    if (closing != null && !closing.isCompleted) closing.complete(shown);
  }

  /// Fetches the next ad: LevelPlay's, and AdMob's while LevelPlay has none
  /// to give.
  void _load() {
    if (!_started || _pro) return;
    final levelPlay = _levelPlay;
    if (levelPlay != null && !_levelPlayReady && !_levelPlayLoading) {
      _levelPlayLoading = true;
      unawaited(levelPlay.loadAd());
    }
    if (_levelPlayEmpty) _loadAdMob();
    _loadRewarded();
  }

  void _loadAdMob() {
    if (!_started || !_hasAdMob || _loading || _ad != null || _pro) return;
    _loading = true;
    InterstitialAd.load(
      adUnitId: _unit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loading = false;
          _ad = ad;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          // Tried again after the next game, as LevelPlay's is.
          debugPrint('No AdMob ad: $error');
          _loading = false;
        },
      ),
    );
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

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_sinceOfferKey, _sinceOffer);
      await prefs.setBool(_askedKey, _asked);
    } on Object catch (error) {
      debugPrint('Could not keep the ad count: $error');
    }
  }
}

class _LevelPlayStart implements LevelPlayInitListener {
  _LevelPlayStart(this._ads);

  final Ads _ads;

  @override
  void onInitSuccess(LevelPlayConfiguration configuration) =>
      _ads._levelPlayStarted();

  @override
  void onInitFailed(LevelPlayInitError error) =>
      _ads._levelPlayDidNotStart('${error.errorCode} ${error.errorMessage}');
}

class _LevelPlayEvents implements LevelPlayInterstitialAdListener {
  _LevelPlayEvents(this._ads);

  final Ads _ads;

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) => _ads._levelPlayLoaded();

  @override
  void onAdLoadFailed(LevelPlayAdError error) => _ads._levelPlayFailed(error);

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) => _ads._levelPlayClosed(shown: true);

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) {
    debugPrint('The LevelPlay ad would not show: ${error.errorMessage}');
    _ads._levelPlayClosed(shown: false);
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {}

  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {}

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {}
}

class _RewardedEvents implements LevelPlayRewardedAdListener {
  _RewardedEvents(this._ads);

  final Ads _ads;

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) => _ads._rewardedLoaded();

  @override
  void onAdLoadFailed(LevelPlayAdError error) => _ads._rewardedFailed(error);

  @override
  void onAdRewarded(LevelPlayReward reward, LevelPlayAdInfo adInfo) =>
      _ads._rewardEarned = true;

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) => _ads._rewardedClosed();

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) {
    debugPrint('The rewarded video would not show: ${error.errorMessage}');
    _ads._rewardedClosed();
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {}

  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {}

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {}
}
