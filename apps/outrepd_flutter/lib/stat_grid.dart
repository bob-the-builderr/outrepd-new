/// Six numbers in one card, a hairline between them (direction B,
/// 2026-11-02): your own profile's, and the same card on anybody else's
/// (pick A, 2026-11-07). They were six cards of their own.
library;

import 'package:flutter/material.dart';

import 'theme.dart';

class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.top, required this.bottom});

  /// Three cells each.
  final List<Widget> top;
  final List<Widget> bottom;

  @override
  Widget build(BuildContext context) {
    final line = context.colors.border;

    // A row of three, the hairlines between them stopping short of the
    // card's edge and meeting the one across the middle.
    Widget row(List<Widget> cells, {required bool first}) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, cell) in cells.indexed) ...[
            if (i > 0)
              VerticalDivider(
                width: 1,
                thickness: 0.5,
                color: line,
                indent: first ? 14 : 0,
                endIndent: first ? 0 : 14,
              ),
            Expanded(child: cell),
          ],
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          row(top, first: true),
          Divider(
            height: 1,
            thickness: 0.5,
            color: line,
            indent: 14,
            endIndent: 14,
          ),
          row(bottom, first: false),
        ],
      ),
    );
  }
}

/// One of the six: its label, then the number.
class StatCell extends StatelessWidget {
  const StatCell({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.value2,
    this.suffix2,
    this.colour,
  });

  final String label;
  final String value;

  /// A unit worn by the number — "W", "L", "d". Set smaller and in the muted
  /// colour, so the figure still reads as the figure.
  final String? suffix;
  final String? value2;
  final String? suffix2;

  final Color? colour;

  @override
  Widget build(BuildContext context) {
    final big = TextStyle(
      color: colour ?? context.colors.text,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.2,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final small = TextStyle(color: context.colors.muted, fontSize: 13);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 15, 10, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CardLabel(label),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: value, style: big),
                  if (suffix case final s?) TextSpan(text: s, style: small),
                  if (value2 case final v?) ...[
                    const TextSpan(text: ' '),
                    TextSpan(text: v, style: big),
                  ],
                  if (suffix2 case final s?) TextSpan(text: s, style: small),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The small label a card or a number is titled with: as written, not
/// shouted (direction B, 2026-11-02).
class CardLabel extends StatelessWidget {
  const CardLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: context.colors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
