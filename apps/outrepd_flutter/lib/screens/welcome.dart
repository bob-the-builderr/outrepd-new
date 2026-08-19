import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'onboarding.dart';
import 'shell.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/images/logo.png', width: 160, height: 160),
              const SizedBox(height: 28),
              // Shrink rather than wrap: the name must stay on one line even
              // on narrow screens, where 48px + letter spacing overflows.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'OUTREPD',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: context.colors.text,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                L.of(context).dontGetOutrepd,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.colors.brand,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                ),
                child: Text(L.of(context).getStarted),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AppShell()),
                ),
                child: Text(L.of(context).skipToApp),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
