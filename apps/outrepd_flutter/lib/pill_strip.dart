/// A row of choices, the chosen one filled: Week · Month · Overall on Ranks
/// (pick A, 2026-11-02), Friends · Ranks on Friends (pick B, 2026-11-07).
library;

import 'package:flutter/material.dart';

import 'theme.dart';

class PillStrip<T> extends StatelessWidget {
  const PillStrip({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;

  /// Each choice, its words, and the key a test finds it by.
  final List<(T, String, Key)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget pill(T choice, String label, Key key) {
      final selected = value == choice;
      return Expanded(
        child: InkWell(
          key: key,
          onTap: () => onChanged(choice),
          borderRadius: BorderRadius.circular(11),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
            decoration: BoxDecoration(
              color: selected ? context.colors.brand : null,
              borderRadius: BorderRadius.circular(11),
            ),
            // Side by side, so a long name shrinks to fit rather than
            // wrapping one pill to twice the height of its neighbours.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? context.colors.background
                      : context.colors.muted,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (final (i, (choice, label, key)) in options.indexed) ...[
            if (i > 0) const SizedBox(width: 4),
            pill(choice, label, key),
          ],
        ],
      ),
    );
  }
}
