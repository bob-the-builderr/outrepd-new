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
import '../plan.dart';
import '../settings.dart';
import '../theme.dart';
import '../widgets.dart';
import 'plan_screen.dart';

/// The goals there are to pick from.
const kDailyGoals = [25, 50, 100];

/// What the sheet hands back for the six-week plan instead of a number.
const _plan = -1;

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
              // Or a plan instead of a number (the user's pick, 2026-11-09):
              // the goal becomes the day's sets, and a race each Sunday.
              const Divider(height: 20),
              ListTile(
                key: const Key('goalPlan'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Icon(Icons.trending_up_rounded, color: context.colors.brand),
                title: Text(
                  l.planOffer,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l.planOfferSub,
                  style: TextStyle(color: context.colors.muted, fontSize: 13.5),
                ),
                onTap: () => Navigator.of(sheet).pop(_plan),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked == _plan) {
      if (context.mounted) await openPlan(context);
      return;
    }
    if (picked != null) settings.update(() => settings.dailyGoal = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    // The reps as well as the goal: listening to settings alone left the card
    // on the count from before a match until something else redrew it.
    return ListenableBuilder(
      listenable: Listenable.merge([settings, Career.instance, trainingPlan]),
      builder: (context, _) {
        // On a plan, today's goal is today's plan (the user's pick,
        // 2026-11-09, A): the day's sets, the week, and the race.
        if (trainingPlan.active) return const PlanHomeCard();
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

/// Today's goal, met by the duel just finished: on the result screen, the
/// Match tab's own card with its ring full and ticked, and one buzz as it
/// arrives (when the lifter has the buzz on).
class GoalDoneCard extends StatefulWidget {
  const GoalDoneCard({super.key, required this.done, required this.goal});

  /// Today's push-ups now, and the goal they passed.
  final int done;
  final int goal;

  /// Whether [outcome]'s set was the one that took today past [goal] —
  /// not one after it, which would say the same thing all evening.
  static bool reached(DuelOutcome? outcome, int goal) =>
      outcome != null && passed(outcome.todayBefore, outcome.todayAfter, goal);

  /// Whether a set that took today from [before] to [after] met [goal].
  static bool passed(int before, int after, int goal) =>
      before < goal && after >= goal;

  @override
  State<GoalDoneCard> createState() => _GoalDoneCardState();
}

class _GoalDoneCardState extends State<GoalDoneCard> {
  @override
  void initState() {
    super.initState();
    tap(heavy: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final progress =
        '${localNumber(context, widget.done)} / ${localNumber(context, widget.goal)}';
    return PopIn(
      child: Container(
        key: const Key('goalDone'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.brand),
        ),
        child: Row(
          children: [
            _GoalRing(done: widget.done, goal: widget.goal),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.dailyGoalDone,
                    style: TextStyle(
                      color: context.colors.brand,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.dailyGoalProgress(progress),
                    style: TextStyle(
                      color: context.colors.muted,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
