/// The title somebody wears, drawn the one way it appears beside a name.
library;

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'rewards.dart';
import 'theme.dart';

class WornTitle extends StatelessWidget {
  const WornTitle({super.key, required this.title});

  final EarnedTitle title;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colour = title.colour ?? context.colors.brand;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(title.icon, size: 12, color: colour),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            title.name(l),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colour,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
