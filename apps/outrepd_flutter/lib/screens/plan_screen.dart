/// Beat your past self, on screen (the user's picks, 2026-11-09: A, free):
/// starting a plan, the plan itself, its card on the Match tab in place of
/// today's goal, and the week's race result. The plan's rules are in
/// lib/plan.dart.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../face.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../plan.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../widgets.dart';
import '../xp.dart';
import 'level.dart';
import 'match_entry.dart';
import 'match_flow.dart';

/// The plan when there is one, else the screen that starts one.
Future<void> openPlan(BuildContext context) => Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => trainingPlan.plan == null
        ? const PlanSetupScreen()
        : const PlanScreen(),
  ),
);

/// One of the day's sets: a practice minute, counted onto the plan when it
/// reaches the day's number.
Future<void> startPlanSet(BuildContext context) => Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) =>
        const MatchFlowScreen(mode: MatchMode.practice, planSet: true),
  ),
);

/// The week's race, against last week's you.
Future<void> racePastSelf(BuildContext context) async {
  final self = await trainingPlan.lastWeek();
  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MatchFlowScreen(mode: MatchMode.pastSelf, pastSelf: self),
    ),
  );
}

/// Grey: last week's you, a memory rather than a person.
const _grey = ColorFilter.matrix([
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 0.8, 0,
]);

/// This lifter's face, in grey: last week's them.
class PastFace extends StatelessWidget {
  const PastFace({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => ColorFiltered(
    colorFilter: _grey,
    child: PersonAvatar(
      id: backend.me?.id ?? '',
      name: demoProfile.username,
      avatarUrl: backend.me?.avatarUrl,
      size: size,
      mine: true,
    ),
  );
}

// ───────────────────────────────── starting one ─────────────────────────────────

class PlanSetupScreen extends StatefulWidget {
  const PlanSetupScreen({super.key});

  @override
  State<PlanSetupScreen> createState() => _PlanSetupScreenState();
}

class _PlanSetupScreenState extends State<PlanSetupScreen> {
  int _goal = 1;
  int _days = 3;

  Future<void> _begin(int best, List<int> goals) async {
    await trainingPlan.begin(start: best, goal: goals[_goal], days: _days);
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PlanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListenableBuilder(
        listenable: Career.instance,
        builder: (context, _) {
          final best = demoProfile.bestSet;
          final goals = planGoals(math.max(best, 1));
          return SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                    children: [
                      Text(
                        l.planSetupTitle,
                        style: context.type.title.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.planSetupSub,
                        style: TextStyle(color: colors.muted, fontSize: 15.5),
                      ),
                      const SizedBox(height: 18),
                      _Box(
                        child: Row(
                          children: [
                            Text(
                              localNumber(context, best),
                              style: TextStyle(
                                color: colors.text,
                                fontSize: 60,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l.planYourBest,
                                    style: TextStyle(
                                      color: colors.text,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    l.planInSixty,
                                    style: TextStyle(
                                      color: colors.muted,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (best <= 0) ...[
                        const SizedBox(height: 16),
                        Text(
                          l.planNeedBest,
                          style: TextStyle(color: colors.muted, fontSize: 15),
                        ),
                      ] else ...[
                        const SizedBox(height: 20),
                        _Caption(l.planGoalCaption),
                        Row(
                          children: [
                            for (var i = 0; i < 3; i++) ...[
                              if (i > 0) const SizedBox(width: 10),
                              _Choice(
                                key: Key('planGoal$i'),
                                big: localNumber(context, goals[i]),
                                small: [
                                  l.planSteady,
                                  l.planRecommended,
                                  l.planHard,
                                ][i],
                                on: _goal == i,
                                onTap: () => setState(() => _goal = i),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        _Caption(l.planDaysCaption),
                        Row(
                          children: [
                            for (final d in const [3, 4, 5]) ...[
                              if (d > 3) const SizedBox(width: 10),
                              _Choice(
                                key: Key('planDays$d'),
                                big: localNumber(context, d),
                                small: l.planDaysUnit,
                                on: _days == d,
                                onTap: () => setState(() => _days = d),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        _Box(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.planHowDays,
                                style: TextStyle(color: colors.text, fontSize: 14.5),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l.planHowRace,
                                style: TextStyle(color: colors.text, fontSize: 14.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                  child: SizedBox(
                    width: double.infinity,
                    child: best <= 0
                        ? FilledButton(
                            key: const Key('planFirstSet'),
                            onPressed: () => startPlanSet(context),
                            child: Text(l.planDoASet),
                          )
                        : FilledButton(
                            key: const Key('planStart'),
                            onPressed: () => _begin(best, goals),
                            child: Text(l.planStart),
                          ),
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

class _Choice extends StatelessWidget {
  const _Choice({
    super.key,
    required this.big,
    required this.small,
    required this.on,
    required this.onTap,
  });

  final String big;
  final String small;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Material(
        color: on ? colors.surfaceRaised : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: on ? colors.brand : colors.border,
            width: on ? 2 : 0.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: SizedBox(
            height: 86,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  big,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                ShrinkText(
                  small,
                  maxLines: 1,
                  style: TextStyle(
                    color: on ? colors.brand : colors.muted,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.child, this.outline});

  final Widget child;
  final Color? outline;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(18),
      border: outline == null ? null : Border.all(color: outline!, width: 1.5),
    ),
    child: child,
  );
}

class _Caption extends StatelessWidget {
  const _Caption(this.text, {this.end});

  final String text;
  final String? end;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: context.colors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (end case final e?)
          Text(
            e,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    ),
  );
}

// ─────────────────────────────────── the plan ───────────────────────────────────

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late Future<PastSelf> _lastWeek = trainingPlan.lastWeek();

  Future<void> _stop() async {
    final l = L.of(context);
    final stop = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l.planStopAsk),
        content: Text(l.planStopBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            key: const Key('planStopYes'),
            onPressed: () => Navigator.of(dialog).pop(true),
            child: Text(l.planStopYes),
          ),
        ],
      ),
    );
    if (stop != true || !mounted) return;
    await trainingPlan.stop();
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PlanSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.planTitle)),
      body: ListenableBuilder(
        listenable: trainingPlan,
        builder: (context, _) {
          final plan = trainingPlan.plan;
          if (plan == null) return const SizedBox.shrink();
          return SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    children: [_body(context, plan)],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: _action(context, plan),
                  ),
                ),
                TextButton(
                  key: const Key('planChange'),
                  onPressed: _stop,
                  child: Text(
                    plan.overOn(trainingPlan.today) ? l.planAnother : l.planChange,
                    style: TextStyle(color: context.colors.muted, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _action(BuildContext context, TrainingPlan plan) {
    final l = L.of(context);
    final today = trainingPlan.today;
    if (plan.overOn(today)) {
      return FilledButton(
        key: const Key('planShare'),
        onPressed: () => sharePlan(context, plan),
        child: Text(l.planShare),
      );
    }
    if (plan.racesOn(today) && plan.raceOf(today) == null) {
      return FilledButton(
        key: const Key('planRace'),
        onPressed: () async {
          await racePastSelf(context);
          if (mounted) setState(() => _lastWeek = trainingPlan.lastWeek());
        },
        child: Text(l.planRaceTitle),
      );
    }
    if (plan.trainsOn(today) && !plan.doneOn(today)) {
      return FilledButton(
        key: const Key('planSet'),
        onPressed: () => startPlanSet(context),
        child: Text(
          l.planStartSet(
            localNumber(context, plan.setsOn(today) + 1),
            localNumber(context, kPlanSetsPerDay),
          ),
        ),
      );
    }
    return OutlinedButton(
      key: const Key('planExtra'),
      onPressed: () => startPlanSet(context),
      child: Text(l.planExtraSet),
    );
  }

  Widget _body(BuildContext context, TrainingPlan plan) {
    final l = L.of(context);
    final colors = context.colors;
    final today = trainingPlan.today;
    final week = plan.weekOf(today);
    final over = plan.overOn(today);
    final progress = plan.weekProgress(today);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.planRoadTo(localNumber(context, plan.goal)),
          style: context.type.title.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          over
              ? l.planDone(
                  localNumber(context, plan.start),
                  localNumber(context, plan.bestSoFar),
                )
              : '${l.planWeekOf(localNumber(context, week), localNumber(context, kPlanWeeks))}'
                    ' · ${l.planStartedAt(localNumber(context, plan.start))}',
          style: TextStyle(color: colors.muted, fontSize: 15),
        ),
        const SizedBox(height: 14),
        _Box(child: SizedBox(height: 190, child: RoadChart(plan: plan))),
        if (!over) ...[
          const SizedBox(height: 18),
          _Caption(
            l.planThisWeek,
            end: l.planDaysDone(
              localNumber(context, progress.done),
              localNumber(context, progress.of),
            ),
          ),
          _Box(child: _Week(plan: plan)),
          const SizedBox(height: 14),
          FutureBuilder<PastSelf>(
            future: _lastWeek,
            builder: (context, snap) {
              final raced = plan.raceOf(today);
              final reps = snap.data?.reps;
              final line = raced != null
                  ? l.planRaced(localNumber(context, raced))
                  : reps == null
                  ? '…'
                  : plan.racesOn(today)
                  ? l.planToBeat(localNumber(context, reps))
                  : l.planToBeatSunday(localNumber(context, reps));
              return _Box(
                outline: AppColors.gold,
                child: Row(
                  children: [
                    const PastFace(size: 52),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.planRaceTitle,
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            line,
                            key: const Key('planRaceLine'),
                            style: TextStyle(color: colors.muted, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.flag_rounded, color: AppColors.gold),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

/// The week, Monday to Sunday: days trained, today, rest days, the race.
class _Week extends StatelessWidget {
  const _Week({required this.plan});

  final TrainingPlan plan;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final today = trainingPlan.today;
    final monday = mondayOf(today);
    // MaterialLocalizations starts its week letters on Sunday.
    final letters = MaterialLocalizations.of(context).narrowWeekdays;
    final week = plan.weekOf(today);
    final per = plan.repsPerSet(week);

    Widget mark(int day) {
      if (plan.racesOn(day)) {
        return plan.raceOf(day) != null
            ? const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 26)
            : const Icon(Icons.flag_rounded, color: AppColors.gold, size: 24);
      }
      if (!plan.trainsOn(day) || day < plan.began) {
        return Text(
          l.planRest,
          style: TextStyle(color: colors.muted, fontSize: 12.5),
        );
      }
      if (plan.doneOn(day)) {
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: colors.brand, shape: BoxShape.circle),
        );
      }
      if (day == today) {
        return _Ring(
          size: 30,
          share: plan.setsOn(day) / kPlanSetsPerDay,
          label: '',
        );
      }
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colors.border, width: 2),
        ),
      );
    }

    final todayLine = plan.racesOn(today)
        ? l.planRaceToday
        : plan.trainsOn(today)
        ? l.planTodaySets(
            localNumber(context, kPlanSetsPerDay),
            localNumber(context, per),
          )
        : l.planRestToday;

    return Column(
      children: [
        Row(
          children: [
            for (var d = monday; d < monday + 7; d++)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      letters[weekdayOf(d) % 7],
                      style: TextStyle(
                        color: d == today ? colors.text : colors.muted,
                        fontSize: 13,
                        fontWeight: d == today ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(height: 34, child: Center(child: mark(d))),
                  ],
                ),
              ),
          ],
        ),
        Divider(color: colors.border, height: 22),
        Row(
          children: [
            Expanded(
              child: Text(
                todayLine,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (plan.trainsOn(today))
              for (var i = 0; i < kPlanSetsPerDay; i++)
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 6),
                  width: 24,
                  height: 10,
                  decoration: BoxDecoration(
                    color: i < plan.setsOn(today)
                        ? colors.brand
                        : colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
          ],
        ),
      ],
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.share, required this.label});

  final double size;
  final double share;
  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      painter: _RingPainter(
        share: share.clamp(0.0, 1.0),
        track: context.colors.surfaceRaised,
        fill: context.colors.brand,
        stroke: size >= 50 ? 7 : 4,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: context.colors.text,
            fontSize: size / 4,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
  );
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.share,
    required this.track,
    required this.fill,
    required this.stroke,
  });

  final double share;
  final Color track;
  final Color fill;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final arc = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arc, 0, math.pi * 2, false, paint..color = track);
    if (share > 0) {
      canvas.drawArc(arc, -math.pi / 2, math.pi * 2 * share, false, paint..color = fill);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.share != share || old.track != track || old.fill != fill;
}

/// From the starting best to the goal, week by week: the dashed line where
/// the plan means to be, the solid one where the races have been.
class RoadChart extends StatelessWidget {
  const RoadChart({super.key, required this.plan});

  final TrainingPlan plan;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return CustomPaint(
      size: Size.infinite,
      painter: _RoadPainter(
        start: plan.start,
        goal: plan.goal,
        races: plan.races,
        labels: [
          l.planStartShort,
          for (var w = 1; w <= kPlanWeeks; w++)
            l.planWeekShort(localNumber(context, w)),
        ],
        number: (n) => localNumber(context, n),
        // The app's own type, as every Text around it has.
        base: DefaultTextStyle.of(context).style,
        line: context.colors.text,
        muted: context.colors.muted,
        faint: context.colors.border,
        dot: context.colors.background,
        gold: AppColors.gold,
        direction: Directionality.of(context),
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  _RoadPainter({
    required this.start,
    required this.goal,
    required this.races,
    required this.labels,
    required this.number,
    required this.base,
    required this.line,
    required this.muted,
    required this.faint,
    required this.dot,
    required this.gold,
    required this.direction,
  });

  final int start;
  final int goal;
  final Map<int, int> races;
  final List<String> labels;
  final String Function(int) number;
  final TextStyle base;
  final Color line;
  final Color muted;
  final Color faint;
  final Color dot;
  final Color gold;
  final TextDirection direction;

  void _text(Canvas canvas, String s, Offset at, Color colour, double size, FontWeight weight) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: base.copyWith(color: colour, fontSize: size, fontWeight: weight),
      ),
      textDirection: direction,
    )..layout();
    tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final top = 24.0, bottom = h - 26;
    final low = math.min(start, races.values.fold(start, math.min)) - 2;
    final high = math.max(goal, races.values.fold(goal, math.max)) + 1;
    double x(int i) => 14 + i * (w - 28) / kPlanWeeks;
    double y(int v) => bottom - (v - low) * (bottom - top) / math.max(1, high - low);

    // Where the plan means to be.
    final dash = Paint()
      ..color = faint
      ..strokeWidth = 2;
    final from = Offset(x(0), y(start)), to = Offset(x(kPlanWeeks), y(goal));
    const steps = 22;
    for (var i = 0; i < steps; i += 2) {
      canvas.drawLine(
        Offset.lerp(from, to, i / steps)!,
        Offset.lerp(from, to, (i + 1) / steps)!,
        dash,
      );
    }

    // Where it has been.
    final points = <(int, int)>[
      (0, start),
      for (var week = 1; week <= kPlanWeeks; week++)
        if (races[week] case final reps?) (week, reps),
    ];
    final path = Path()..moveTo(x(points.first.$1), y(points.first.$2));
    for (final (i, v) in points.skip(1)) {
      path.lineTo(x(i), y(v));
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeJoin = StrokeJoin.round,
    );
    for (var n = 0; n < points.length; n++) {
      final (i, v) = points[n];
      final last = n == points.length - 1;
      final c = Offset(x(i), y(v));
      canvas.drawCircle(c, last ? 7 : 5, Paint()..color = last ? line : dot);
      canvas.drawCircle(
        c,
        last ? 7 : 5,
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
      _text(canvas, number(v), c - const Offset(0, 16), line, 13.5, FontWeight.w700);
    }

    // The goal.
    final g = Offset(x(kPlanWeeks), y(goal));
    canvas.drawCircle(
      g,
      6,
      Paint()
        ..color = gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    if (races[kPlanWeeks] == null) {
      _text(canvas, number(goal), g - const Offset(0, 16), gold, 13.5, FontWeight.w800);
    }

    for (var i = 0; i < labels.length; i++) {
      _text(canvas, labels[i], Offset(x(i), h - 8), muted, 11.5, FontWeight.w500);
    }
  }

  @override
  bool shouldRepaint(_RoadPainter old) =>
      old.start != start ||
      old.goal != goal ||
      old.races.toString() != races.toString() ||
      old.line != line;
}

/// The road so far, shared as text with a link to the lifter's page.
Future<void> sharePlan(BuildContext context, TrainingPlan plan) async {
  final l = L.of(context);
  final text = l.planShareText(
    localNumber(context, plan.start),
    localNumber(context, plan.bestSoFar),
    localNumber(context, plan.goal),
    'https://outrepd.com/u/${demoProfile.username}',
  );
  await SharePlus.instance.share(ShareParams(text: text));
}

// ─────────────────────────────── on the Match tab ───────────────────────────────

/// Today's goal while on a plan: today's sets, the week, and the race.
class PlanHomeCard extends StatelessWidget {
  const PlanHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    return ListenableBuilder(
      listenable: trainingPlan,
      builder: (context, _) {
        final plan = trainingPlan.plan;
        if (plan == null) return const SizedBox.shrink();
        final today = trainingPlan.today;
        final week = plan.weekOf(today);
        final weekText = localNumber(context, week);
        final trains = plan.trainsOn(today);
        final raced = plan.raceOf(today);
        final line = trains
            ? plan.doneOn(today)
                  ? l.planCardDone(weekText)
                  : l.planCardSets(
                      weekText,
                      localNumber(context, kPlanSetsPerDay),
                      localNumber(context, plan.repsPerSet(week)),
                      localNumber(context, plan.setsOn(today)),
                    )
            : l.planCardRest(weekText);
        final race = raced != null
            ? l.planCardRaced(localNumber(context, raced))
            : plan.racesOn(today)
            ? l.planRaceToday
            : l.planCardRaceSunday;
        return PressScale(
          scale: 0.98,
          child: Material(
            key: const Key('planCard'),
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colors.border, width: 0.5),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => openPlan(context),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    trains
                        ? _Ring(
                            size: 64,
                            share: plan.setsOn(today) / kPlanSetsPerDay,
                            label:
                                '${localNumber(context, math.min(plan.setsOn(today), kPlanSetsPerDay))}/${localNumber(context, kPlanSetsPerDay)}',
                          )
                        : _Ring(
                            size: 64,
                            share: week / kPlanWeeks,
                            label: l.planWeekShort(weekText),
                          ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l.planToday,
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            line,
                            style: TextStyle(color: colors.muted, fontSize: 14.5),
                          ),
                          Text(
                            race,
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: colors.muted),
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

// ─────────────────────────────────── the race ───────────────────────────────────

/// After the week's race: who won, the two counts, and the road so far.
class PastSelfResultView extends StatelessWidget {
  const PastSelfResultView({
    super.key,
    required this.mine,
    required this.theirs,
    required this.onDone,
    this.xp,
  });

  final int mine;
  final int theirs;
  final VoidCallback onDone;
  final XpGain? xp;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final beat = mine > theirs;
    final gap = (mine - theirs).abs();
    final plan = trainingPlan.plan;
    final today = trainingPlan.today;

    Widget side({
      required Widget face,
      required String name,
      required int reps,
      required Color colour,
      required bool won,
    }) => Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
        decoration: won
            ? BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.border, width: 1.5),
              )
            : null,
        child: Column(
          children: [
            face,
            const SizedBox(height: 4),
            ShrinkText(
              name,
              maxLines: 1,
              style: TextStyle(color: colors.muted, fontSize: 15),
            ),
            Text(
              localNumber(context, reps),
              style: TextStyle(
                color: colour,
                fontSize: 56,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            Text(
              won ? l.winnerLabel : '',
              style: TextStyle(color: colors.text, fontSize: 13),
            ),
          ],
        ),
      ),
    );

    final status = plan == null
        ? null
        : plan.bestSoFar >= plan.goal
        ? l.planReached
        : l.planToGo(localNumber(context, plan.goal - plan.bestSoFar));
    final onTrack =
        plan != null && plan.bestSoFar >= plan.targetFor(plan.weekOf(today));

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Column(
                children: [
                  PopIn(
                    from: 0.6,
                    child: Text(
                      (beat
                              ? l.planBeatTitle
                              : gap == 0
                              ? l.planTieTitle
                              : l.planLostTitle)
                          .toUpperCase(),
                      key: const Key('pastSelfTitle'),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: context.type.title.copyWith(
                        color: beat ? colors.brand : colors.text,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    gap == 0
                        ? l.planLevel
                        : beat
                        ? l.planMoreThan(localNumber(context, gap))
                        : l.planShortOf(localNumber(context, gap)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.muted, fontSize: 16),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        side(
                          face: PersonAvatar(
                            id: backend.me?.id ?? '',
                            name: demoProfile.username,
                            avatarUrl: backend.me?.avatarUrl,
                            size: 70,
                            mine: true,
                          ),
                          name: l.planYouNow,
                          reps: mine,
                          colour: colors.text,
                          won: beat,
                        ),
                        side(
                          face: const PastFace(size: 70),
                          name: l.planLastWeek,
                          reps: theirs,
                          colour: colors.muted,
                          won: !beat && gap > 0,
                        ),
                      ],
                    ),
                  ),
                  if (plan != null) ...[
                    const SizedBox(height: 18),
                    _Box(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l.planRoadTo(localNumber(context, plan.goal)),
                                  style: TextStyle(
                                    color: colors.text,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                onTrack ? l.planOnTrack : l.planBehind,
                                style: TextStyle(
                                  color: onTrack ? colors.brand : colors.muted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(height: 170, child: RoadChart(plan: plan)),
                        ],
                      ),
                    ),
                    if (status != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        status,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.muted, fontSize: 14),
                      ),
                    ],
                  ],
                  if (xp case final gain?) ...[
                    const SizedBox(height: 12),
                    XpGainCard(gain: gain),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              children: [
                if (plan != null)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const Key('pastSelfShare'),
                      onPressed: () => sharePlan(context, plan),
                      child: Text(l.planShare),
                    ),
                  ),
                const SizedBox(height: 11),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onDone,
                    child: Text(l.doneAction),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
