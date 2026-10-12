/// Today's goal: a number of push-ups for the day, and how far along it is.
///
/// Every rep counts toward it — a duel's, a friend room's, a practice set's
/// — because the point is the push-ups, not the format. The goal is the
/// lifter's to pick, from three, and it is the same every day until changed.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../career.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../settings.dart';
import '../theme.dart';
import '../widgets.dart';

/// The goals there are to pick from.
const kDailyGoals = [25, 50, 100];

class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({super.key});

  Future<void> _pick(BuildContext context) async {
    final l = L.of(context);
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: context.colors.surface,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.dailyGoalPick,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              for (final goal in kDailyGoals)
                ListTile(
                  key: Key('goal$goal'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(
                    l.dailyGoalOption(localNumber(context, goal)),
                    style: TextStyle(color: context.colors.text, fontSize: 17),
                  ),
                  trailing: settings.dailyGoal == goal
                      ? Icon(Icons.check, color: context.colors.brand)
                      : null,
                  onTap: () => Navigator.of(sheet).pop(goal),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) settings.update(() => settings.dailyGoal = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    // The reps as well as the goal: listening to settings alone left the card
    // on the count from before a match until something else redrew it.
    return ListenableBuilder(
      listenable: Listenable.merge([settings, Career.instance]),
      builder: (context, _) {
        final goal = settings.dailyGoal;
        final done = Career.instance.repsToday;
        final complete = done >= goal;
        final progress =
            '${localNumber(context, math.min(done, goal))} / ${localNumber(context, goal)}';

        return PressScale(
          scale: 0.98,
          child: Material(
            key: const Key('dailyGoal'),
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: complete ? context.colors.brand : context.colors.border,
                width: complete ? 1 : 0.5,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _pick(context),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    _GoalRing(done: done, goal: goal),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            complete ? l.dailyGoalDone : l.dailyGoalTitle,
                            style: TextStyle(
                              color: complete
                                  ? context.colors.brand
                                  : context.colors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            complete
                                ? l.dailyGoalProgress(progress)
                                : '${l.dailyGoalProgress(progress)} · '
                                      '${l.dailyGoalLeft(localNumber(context, goal - done))}',
                            style: TextStyle(
                              color: context.colors.muted,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l.dailyGoalChange,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The ring: fills from empty each time it is drawn, to today's share of the
/// goal, with the count inside — or a tick once the goal is met.
class _GoalRing extends StatelessWidget {
  const _GoalRing({required this.done, required this.goal});

  final int done;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final share = goal <= 0 ? 0.0 : (done / goal).clamp(0.0, 1.0);
    final complete = done >= goal;
    return SizedBox(
      width: 64,
      height: 64,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: share),
        duration: reduceMotion(context)
            ? Duration.zero
            : const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, filled, _) => CustomPaint(
          painter: _RingPainter(
            filled: filled,
            track: context.colors.surfaceRaised,
            fill: context.colors.brand,
          ),
          child: Center(
            child: complete
                ? PopIn(
                    child: Icon(
                      Icons.check_rounded,
                      size: 30,
                      color: context.colors.brand,
                    ),
                  )
                : Text(
                    localNumber(context, done),
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.filled,
    required this.track,
    required this.fill,
  });

  final double filled;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 7.0;
    final rect = Offset.zero & size;
    final arc = rect.deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arc, 0, math.pi * 2, false, paint..color = track);
    if (filled > 0) {
      canvas.drawArc(
        arc,
        -math.pi / 2,
        math.pi * 2 * filled,
        false,
        paint..color = fill,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.filled != filled || old.track != track || old.fill != fill;
}
