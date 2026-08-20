import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).notifications)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: demoNotifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final n = demoNotifications[i];
          return Panel(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: BoxDecoration(
                    color: n.unread ? context.colors.brand : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.heading(L.of(context)),
                        style: context.type.body.copyWith(color: context.colors.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        n.detail(L.of(context)),
                        style: context.type.label.copyWith(color: context.colors.muted),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        relativeDays(context, n.daysAgo),
                        style: context.type.label.copyWith(color: context.colors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
