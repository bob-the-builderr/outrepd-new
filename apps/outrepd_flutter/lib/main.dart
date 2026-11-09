import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';

import 'ads.dart';
import 'adventure/adventure.dart';
import 'app_bottom_nav.dart' show registerIconLicences;
import 'avatar.dart';
import 'backend/backend.dart';
import 'backend/supabase_backend.dart';
import 'career.dart';
import 'connection.dart';
import 'data.dart';
import 'deep_links.dart';
import 'firebase.dart';
import 'home_widgets.dart';
import 'lifter/looks.dart';
import 'lifter/my_lifter.dart';
import 'lifter/pro_trial.dart';
import 'reminders.dart';
import 'rewards.dart';
import 'screens/auth_entry.dart';
import 'screens/avatar_picker.dart';
import 'screens/match_flow.dart';
import 'screens/onboarding.dart';
import 'screens/post_match.dart';
import 'screens/awards.dart';
import 'screens/counter_accuracy.dart';
import 'screens/other_profile.dart';
import 'screens/progression.dart';
import 'screens/settings.dart';
import 'screens/settings_account.dart';
import 'screens/settings_notices.dart';
import 'screens/settings_privacy.dart';
import 'screens/share_card.dart';
import 'screens/shell.dart';
import 'screens/welcome_inside.dart';
import 'screens/tier_gallery.dart';
import 'screens/trainer.dart';
import 'reps/count_accuracy.dart';
import 'preview_seed.dart';
import 'settings.dart';
import 'subscription.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  registerIconLicences();
  // First, so a crash anywhere after it is reported. Quick — it reads config
  // already on the phone — and a build without Firebase skips it entirely.
  await startFirebase();
  // Not awaited: the first frame can open on the default "online" guess,
  // and this corrects it within a moment rather than delaying startup for a
  // network check nothing else here depends on.
  unawaited(Connection.instance.start());
  // Read stored preferences before the first frame, so the app opens in the
  // theme and units the lifter chose instead of flashing the defaults first.
  //
  // Guarded because this runs before there is any UI to report a problem with:
  // if storage is unavailable the app must still open on its defaults rather
  // than die on the launcher with nothing to show for it.
  try {
    // With keys supplied this opens the connection; without them the app
    // runs exactly as it did — on this phone, against nobody.
    await startBackend();
    // Which store this build sells through, if any. Only chosen here: the
    // shell starts it, once it knows whose account it is.
    Subscription.instance.use(Subscription.forThisBuild());
    if (kSeedPreview && !backend.available) await seedPreviewHistory();
    await settings.load();
    await loadProfileStats();

    // Signs in once the username above has been read back, so a returning
    // lifter's account is found rather than a fresh one made under the
    // 'demo_lifter' default. Kept out of the try this call sits inside would
    // otherwise be part of: a lost connection here is routine, not a reason
    // to skip loading everything that follows.
    //
    // A returning account opens on the profile this phone last read and takes
    // the server's when it answers: the launch waited on that trip to the
    // server — one or two on a weak signal, seconds — before anything was
    // drawn (the user, 2026-11-04: "it takes a long time to open"). Only a
    // first launch, with nothing kept, still waits for it.
    RemoteProfile? me;
    Future<RemoteProfile?>? fresh;
    if (backend.available) {
      fresh = backend.signIn(username: demoProfile.username).then<RemoteProfile?>(
        (signedIn) {
          // Says this account is around, which is the whole of what the
          // online dot on a friends list means. If it fails, the worst
          // outcome is a friend seeing us as offline.
          unawaited(
            backend.touch().catchError((Object error) {
              debugPrint('Could not say we are around: $error');
            }),
          );
          return signedIn;
        },
        onError: (Object error) {
          debugPrint('Could not sign in: $error');
          return null;
        },
      );
      if (await backend.cachedMe() == null) me = await fresh;
    }

    await loadCountAccuracy();
    // The lifter before the photo: the picture getter reads both.
    await MyLifter.instance.load();
    await MyCover.instance.load();
    unawaited(MyCover.instance.adopt());
    await avatar.load();
    await rewards.load();
    await Adventure.instance.load();
    await Ads.instance.load();
    // A Pro part worn for a day comes off once the day is over.
    await ProTrial.instance.load();
    unawaited(ProTrial.instance.endIfOver());
    // After settings and rewards: the reminder's time is one, and whether
    // today is already trained is the other.
    await Reminders.instance.start();
    // After rewards, because the career copies the streak out of it, and
    // before the title sync below, which reads the totals it restores.
    await Career.instance.load();
    // After Career, on purpose: local storage just restored whatever this
    // device saved from its own last session, and the server's row is what
    // overwrites it, not the other way round — the one place a fresh
    // install or a second phone gets back to the ladder it has actually
    // been racing on.
    if (me case final signedIn?) {
      applyServerProfile(signedIn);
    } else if (fresh != null) {
      // Opened on what this phone had: the server's own once it answers,
      // onto the screens already up.
      unawaited(
        fresh.then((signedIn) async {
          if (signedIn != null) await Career.instance.takeServerProfile(signedIn);
        }),
      );
    }
    // The adventure's stars: this phone's and the account's, the best of
    // each. Not awaited, like the history below.
    unawaited(Adventure.instance.sync());
    // Duels no screen on this phone wrote down: raced while away, or settled
    // after their screen was closed. Not awaited: the history fills in a
    // moment later rather than holding the launch on the network.
    unawaited(Career.instance.syncHistory());
    // The titles the totals earn. In the background: the friend count is a
    // trip to the server, and the first screen waited on it (2026-11-04).
    unawaited(() async {
      try {
        await rewards.syncWithProfile(
          matches: demoProfile.totalMatches,
          wins: demoProfile.bestStreak,
          // The real count, not a guess divided out of a weight total. Reps
          // are what this app actually records, so a rep title is now the
          // only kind that can be earned honestly.
          reps: demoProfile.totalReps,
          tierIdx: demoProfile.tierIdx,
          friends: await currentFriendCount(),
        );
      } on Object catch (error) {
        debugPrint('Could not sync the titles: $error');
      }
    }());
  } on Object catch (error, stack) {
    debugPrint('Could not read saved settings: $error\n$stack');
  }
  deepLinksEnabled = !kIsWeb;
  // After the career and settings are loaded: the widgets show both.
  unawaited(HomeWidgets.start());
  runApp(const OutrepdApp());
}

class OutrepdApp extends StatefulWidget {
  const OutrepdApp({super.key});

  @override
  State<OutrepdApp> createState() => _OutrepdAppState();
}

class _OutrepdAppState extends State<OutrepdApp> with WidgetsBindingObserver {
  // A global key rather than a local Navigator, because the reset screen is
  // pushed from a stream listener that has no BuildContext of its own — the
  // link that triggers it can be tapped from wherever the app happens to be.
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    settings.addListener(_refresh);
  }

  @override
  void dispose() {
    settings.removeListener(_refresh);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _refresh() => setState(() {});

  /// Only matters on ThemeMode.system, but it costs nothing to always follow.
  @override
  void didChangePlatformBrightness() => _refresh();

  @override
  Widget build(BuildContext context) {
    final platform =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final brightness = settings.resolveBrightness(platform);
    // One theme, built for the resolved brightness. Handing MaterialApp both a
    // light and a dark theme would run buildTheme twice and leave the global
    // palette set by whichever ran last, not by the one on screen.
    final theme = buildTheme(brightness);
    final dark = brightness == Brightness.dark;

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'OUTREPD',
      debugShowCheckedModeBanner: false,
      // Null follows the phone. Flutter then picks the nearest language it has
      // and falls back to English — which is what an Arabic phone now gets.
      locale: settings.language.locale,
      supportedLocales: L.supportedLocales,
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: theme,
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: dark ? Brightness.dark : Brightness.light,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
      // Named routes let the web preview jump straight to a screen
      // (e.g. /#/home) while reviewing layout, instead of tapping through.
      // No initialRoute: naming one here overrides the URL, which silently
      // sends every /#/… preview link back to onboarding.
      routes: {
        // Onboarding is for accounts that do not exist yet. Anybody who has
        // been here before goes straight in — finishing onboarding calls
        // startFresh() only for a phone not yet set up, so going through it
        // again never erases a career.
        //
        // Straight in means with an account: a phone set up before but
        // holding only a guest session — no email behind it — goes back
        // through the welcome and the sign-up, because inside is the paywall,
        // and a subscription bought by a guest belongs to no account anybody
        // can sign back into.
        '/': (_) => onboarded && (!backend.available || backend.hasRealAccount)
            ? const AppShell()
            : const OnboardingScreen(),
        '/home': (_) => const AppShell(),
        // The preview opens on home; this is the way back to the first run.
        '/onboarding': (_) => const OnboardingScreen(),
        '/inside': (_) => WelcomeInsideScreen(onDone: (_) {}),
        '/friends': (_) => const AppShell(initialIndex: 1),
        '/ranks': (_) => const AppShell(initialIndex: 2),
        '/profile': (_) => const AppShell(initialIndex: 3),
        '/road': (_) => ProgressionScreen(profile: demoProfile),
        '/awards': (_) => const AwardsScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/auth': (_) => const AuthEntryScreen(),
        // The settings tree, one route per screen. They are reached by
        // tapping through in the app; the preview cannot tap, so each gets
        // a name.
        '/notices': (_) => const NoticeSettingsScreen(),
        '/privacy': (_) => const PrivacyScreen(),
        '/blocked': (_) => const BlockedScreen(),
        '/report': (_) => const ReportScreen(),
        '/download': (_) => const DownloadDataScreen(),
        '/deleteme': (_) => const DeleteAccountScreen(),
        '/trainer': (_) => const TrainerScreen(),
        '/counter': (_) => const TrainerScreen(autoStart: true),
        // The camera screen as it looks inside a duel: two lifters on the
        // score card rather than one. Clicks do not reach the canvas in the
        // web preview, so the state worth inspecting gets its own route.
        '/duel': (_) => TrainerScreen(
          autoStart: true,
          limit: kDuelLength,
          duel: DuelContext(
            opponentName: demoOpponents.first.username,
            opponentReps: 11,
            opponentTierIdx: demoOpponents.first.tierIdx,
            opponentDivIdx: demoOpponents.first.divIdx,
            rankLabel: 'Gold III',
          ),
        ),
        // The three screens a duel can end on. Each needs an outcome that
        // only a finished match produces, so the preview builds one.
        '/won': (_) => Scaffold(
          backgroundColor: buildTheme(Brightness.dark).colorScheme.surface,
          body: DuelResultView(
            won: true,
            yourReps: 18,
            theirReps: 11,
            opponent: demoOpponents.first,
            outcome: demoOutcome(won: true, newBest: true),
            onRematch: () {},
            onDone: () {},
          ),
        ),
        '/lost': (_) => Scaffold(
          backgroundColor: buildTheme(Brightness.dark).colorScheme.surface,
          body: DuelResultView(
            won: false,
            yourReps: 14,
            theirReps: 19,
            opponent: demoOpponents[1],
            outcome: demoOutcome(won: false),
            onRematch: () {},
            onDone: () {},
            closestYet: true,
          ),
        ),
        '/promoted': (_) => Scaffold(
          backgroundColor: buildTheme(Brightness.dark).colorScheme.surface,
          body: PromotionView(
            tierIdx: demoProfile.tierIdx,
            divIdx: demoProfile.divIdx,
            highest: true,
            onContinue: () {},
          ),
        ),
        // Every rank badge at once, for checking the drawing.
        '/tiers': (_) => const TierGalleryScreen(),
        '/accuracy': (_) => const CounterAccuracyScreen(),
        // The screen is only worth looking at once it has sets in it, and a
        // browser has never done a push-up.
        '/accuracydemo': (_) =>
            CounterAccuracyScreen(samples: demoAccuracySamples()),
        // Somebody else's card, with a history to show — the preview cannot
        // reach this by tapping a friend row, because the demo data behind
        // those rows has no real id to fetch a profile with.
        '/otherprofile': (_) => OtherProfileScreen(
          id: 'preview',
          username: demoOpponents.first.username,
          initial: LifterProfile(
            id: 'preview',
            username: demoOpponents.first.username,
            tierIdx: demoOpponents.first.tierIdx,
            divIdx: demoOpponents.first.divIdx,
            lp: 72,
            placementsDone: 5,
            totalReps: 3140,
            bestSet: 31,
            wins: 41,
            losses: 12,
            winStreak: 22,
            globalPlace: 3,
            country: 'US',
            countryPlace: 1,
            isFriend: true,
            winsVsYou: 3,
            lossesVsYou: 1,
            yourBestVsThem: 16,
            lastDuelAt: DateTime.now().subtract(const Duration(days: 2)),
            lastYourReps: 14,
            lastTheirReps: 19,
            title: 'giant_slayer',
          ),
        ),
        // A bottom sheet has to sit over a page, so this one opens itself as
        // soon as the page beneath it exists.
        '/sharecard': (_) => _SharePreviewScreen(),
        '/avatarpicker': (_) => _AvatarPickerPreviewScreen(),
      },
      // '/home/2' opens the shell on a specific tab.
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        if (name.startsWith('/home/')) {
          final index = int.tryParse(name.substring(6)) ?? 0;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AppShell(initialIndex: index),
          );
        }
        return null;
      },
    );
  }
}

/// Opens the share sheet over a plain scaffold, for the preview — the app
/// itself only ever opens it from a page that is already showing.
class _SharePreviewScreen extends StatefulWidget {
  @override
  State<_SharePreviewScreen> createState() => _SharePreviewScreenState();
}

class _SharePreviewScreenState extends State<_SharePreviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showShareCardSheet(
        context,
        data: ShareCardData(
          username: demoProfile.username,
          tierIdx: demoProfile.tierIdx,
          divIdx: demoProfile.divIdx,
          lp: demoProfile.lp,
          wins: demoProfile.wins,
          losses: demoProfile.losses,
          bestSet: demoProfile.bestSet,
          winStreak: demoProfile.winStreak,
          globalPlace: demoProfile.globalRank,
          country: demoProfile.country,
          countryPlace: demoProfile.localRank,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}

/// Opens the avatar picker sheet over a plain scaffold, for the preview — the
/// app itself only ever opens it from the profile page that is already
/// showing.
class _AvatarPickerPreviewScreen extends StatefulWidget {
  @override
  State<_AvatarPickerPreviewScreen> createState() =>
      _AvatarPickerPreviewScreenState();
}

class _AvatarPickerPreviewScreenState
    extends State<_AvatarPickerPreviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showAvatarPicker(context, demoProfile.tierIdx);
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
