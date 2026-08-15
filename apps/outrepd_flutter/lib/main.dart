import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'screens/onboarding.dart';
import 'screens/roadmap.dart';
import 'screens/shell.dart';
import 'screens/user_onboarding.dart';
import 'screens/welcome.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const OutrepdApp());
}

class OutrepdApp extends StatelessWidget {
  const OutrepdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OUTREPD',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
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
        '/train': (_) => const AppShell(initialIndex: 3),
        '/profile': (_) => const AppShell(initialIndex: 4),
        '/road': (_) => RoadmapScreen(profile: demoProfile),
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
