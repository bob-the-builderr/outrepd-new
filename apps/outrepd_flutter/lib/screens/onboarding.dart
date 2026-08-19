import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'shell.dart';
import 'user_onboarding.dart';

class _Slide {
  const _Slide(this.image, this.title, this.body);
  final String image;

  /// Read out of the translations at build time, so the slides follow the
  /// language the same way the rest of the app does.
  final String Function(L) title;
  final String Function(L) body;
}

final _slides = <_Slide>[
  _Slide('assets/images/workout-battle.png',
      (l) => l.ob1Title, (l) => l.ob1Body),
  _Slide('assets/images/challenge-friends.png',
      (l) => l.ob2Title, (l) => l.ob2Body),
  _Slide('assets/images/mountain.png',
      (l) => l.ob3Title, (l) => l.ob3Body),
  _Slide('assets/images/effort-alone.png',
      (l) => l.ob4Title, (l) => l.ob4Body),
  _Slide('assets/images/legend.png',
      (l) => l.ob5Title, (l) => l.ob5Body),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The intro carousel hands off to the personalised questionnaire.
  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const UserOnboardingScreen()),
    );
  }

  /// "Skip" jumps past setup entirely and lands in the app.
  void _skipAll() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AppShell()),
      (_) => false,
    );
  }

  void _next() {
    if (_page == _slides.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _skipAll,
                child: Text(
                  L.of(context).skip,
                  style: TextStyle(color: context.colors.muted),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset(slide.image, fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          slide.title(L.of(context)),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.2,
                            fontWeight: FontWeight.w900,
                            color: context.colors.text,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.body(L.of(context)),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: context.colors.muted,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? context.colors.brand : context.colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: FilledButton(
                onPressed: _next,
                child: Text(isLast
                    ? L.of(context).letsGo
                    : L.of(context).continueLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
