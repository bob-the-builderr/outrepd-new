import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'screens/onboarding.dart';
import 'screens/crew.dart';
import 'screens/crew_create.dart';
import 'screens/roadmap.dart';
import 'screens/settings.dart';
import 'screens/shell.dart';
import 'screens/trainer.dart';
import 'screens/user_onboarding.dart';
import 'screens/welcome.dart';
import 'settings.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Read stored preferences before the first frame, so the app opens in the
  // theme and units the lifter chose instead of flashing the defaults first.
  await settings.load();
  await loadProfileStats();
  runApp(const OutrepdApp());
}

class OutrepdApp extends StatefulWidget {
  const OutrepdApp({super.key});

  @override
  State<OutrepdApp> createState() => _OutrepdAppState();
}

class _OutrepdAppState extends State<OutrepdApp> with WidgetsBindingObserver {
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
      title: 'OUTREPD',
      debugShowCheckedModeBanner: false,
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
      initialRoute: '/',
      routes: {
        '/': (_) => const WelcomeScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/questions': (_) => const UserOnboardingScreen(),
        '/home': (_) => const AppShell(),
        '/friends': (_) => const AppShell(initialIndex: 0),
        '/ranks': (_) => const AppShell(initialIndex: 1),
        '/crewtab': (_) => const AppShell(initialIndex: 3),
        '/profile': (_) => const AppShell(initialIndex: 4),
        '/road': (_) => RoadmapScreen(profile: demoProfile),
        '/crew': (_) => const CrewScreen(),
        '/crewnew': (_) => const CreateCrewScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/trainer': (_) => const TrainerScreen(),
        '/counter': (_) => const TrainerScreen(autoStart: true),
      },
      // '/home/2' opens the shell on a specific tab.
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        if (name.startsWith('/home/')) {
          final index = int.tryParse(name.substring(6)) ?? 0;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AppShell(initialIndex: index.clamp(0, 4)),
          );
        }
        return null;
      },
    );
  }
}
