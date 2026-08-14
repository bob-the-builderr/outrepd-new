import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      home: const WelcomeScreen(),
    );
  }
}
