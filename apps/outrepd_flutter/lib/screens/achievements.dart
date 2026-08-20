import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final earned = demoAchievements.where((a) => a.earned).length;

    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).achievements)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Panel(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L.of(context).unlocked,
                      style: TextStyle(
                        color: context.colors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '$earned / ${demoAchievements.length}',
                      style: TextStyle(
                        color: context.colors.brand,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: earned / demoAchievements.length,
                    minHeight: 8,
                    backgroundColor: context.colors.surfaceRaised,
                    valueColor:
                        AlwaysStoppedAnimation(context.colors.brand),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...demoAchievements.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Opacity(
                opacity: a.earned ? 1 : 0.45,
                child: Panel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (a.earned ? AppColors.gold : context.colors.muted)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          a.earned ? Icons.emoji_events : Icons.lock_outline,
                          color: a.earned ? AppColors.gold : context.colors.muted,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.label(L.of(context)),
                              style: context.type.body.copyWith(color: context.colors.text),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              a.hint(L.of(context)),
                              style: context.type.label.copyWith(color: context.colors.muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
