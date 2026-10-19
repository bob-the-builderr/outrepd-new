/// OUTREPD Promo Studio: the app's live match screen, staged for filming.
///
/// A separate app with nothing of the real one's server in it. Both lifters,
/// their pictures and ranks, and how the opponent's count moves are chosen on
/// the first screen; the round is the app's own camera screen, counting for
/// real; the result is the app's own result screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'promo/plan.dart';
import 'promo/setup_screen.dart';
import 'settings.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await settings.load();
  final plan = await PromoPlan.load();
  runApp(PromoApp(plan: plan));
}

class PromoApp extends StatelessWidget {
  const PromoApp({super.key, required this.plan});

  final PromoPlan plan;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OUTREPD Promo',
      debugShowCheckedModeBanner: false,
      // English, whatever the phone: the videos are for the store.
      locale: const Locale('en'),
      supportedLocales: L.supportedLocales,
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // The app's dark theme, which is what it ships in.
      theme: buildTheme(Brightness.dark),
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
      home: SetupScreen(plan: plan),
    );
  }
}
