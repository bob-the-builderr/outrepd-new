/// The lifter has the last word on their own count.
///
/// A camera counting reps from 2D pose at whatever angle a phone happens to be
/// propped at will sometimes be wrong. That is not a bug to be closed before
/// shipping — it is the nature of the problem, and pretending otherwise means
/// shipping a competition whose scores nobody can trust.
///
/// So the count is proposed, not imposed. The camera does the work, the number
/// comes up, and the lifter says yes or corrects it before it enters the match.
/// Which makes the score right on day one, with the counter still improving
/// underneath — and every correction is a measured error, which is the one
/// thing the counter has never had.
library;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';

/// Shows [counted] and returns the number the lifter settled on.
///
/// Returns null only if the sheet is dismissed without an answer, which the
/// caller should read as "keep what the camera said" rather than as zero.
Future<int?> confirmCount(
  BuildContext context, {
  required int counted,
  bool unverified = false,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _ConfirmSheet(
      counted: counted,
      unverified: unverified,
    ),
  );
}

class _ConfirmSheet extends StatefulWidget {
  const _ConfirmSheet({
    required this.counted,
    required this.unverified,
  });

  final int counted;

  /// True when the count is movement the signature could not vouch for. Saying
  /// so is the difference between asking somebody to check and quietly hoping
  /// they do.
  final bool unverified;

  @override
  State<_ConfirmSheet> createState() => _ConfirmSheetState();
}

class _ConfirmSheetState extends State<_ConfirmSheet> {
  late int _value = widget.counted;

  void _nudge(int by) {
    final next = (_value + by).clamp(0, 999);
    if (next == _value) return;
    tap();
    setState(() => _value = next);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final corrected = _value != widget.counted;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.surfaceRaised,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // No movement named. There is one, everybody doing this knows
            // which, and a label saying PUSH-UPS over a push-up count is
            // furniture.
            Text(
              l.countedThat,
              textAlign: TextAlign.center,
              style: context.type.body.copyWith(color: context.colors.muted),
            ),
            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Nudge(icon: Icons.remove, onTap: () => _nudge(-1)),
                const SizedBox(width: 26),
                SizedBox(
                  width: 130,
                  child: PopOnChange(
                    value: _value,
                    child: Text(
                      localNumber(context, _value),
                      textAlign: TextAlign.center,
                      style: context.type.display.copyWith(
                        fontSize: 68,
                        color: corrected
                            ? context.colors.brand
                            : context.colors.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 26),
                _Nudge(icon: Icons.add, onTap: () => _nudge(1)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l.reps,
              style: context.type.label.copyWith(color: context.colors.muted),
            ),
            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_value),
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.brand,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  corrected ? l.useMyCount : l.thatIsRight,
                  style: context.type.heading.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.unverified ? l.unsureMovement : l.confirmHint,
              textAlign: TextAlign.center,
              style: context.type.label.copyWith(
                color: widget.unverified
                    ? AppColors.gold
                    : context.colors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Nudge extends StatelessWidget {
  const _Nudge({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Deliberately large. This is tapped with tired hands, sometimes sweaty
    // ones, by somebody who has just finished ninety seconds of work.
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.surfaceRaised,
        ),
        child: Icon(icon, size: 26, color: context.colors.text),
      ),
    );
  }
}
