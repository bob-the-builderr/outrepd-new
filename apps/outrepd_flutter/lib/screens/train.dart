import 'package:flutter/material.dart';

import '../data.dart';
import '../exercises.dart';
import '../theme.dart';
import '../widgets.dart';

/// Train tab: the player picks which exercises count for each muscle group,
/// and reviews their training streak and activity.
///
/// Selections live in memory for now — they reset when the app restarts.
final Map<String, Set<String>> exerciseSelections = {
  'Chest': {'Barbell Bench Press', 'Incline Dumbbell Press', 'Cable Flyes'},
  'Back': {'Barbell Deadlift', 'Lat Pulldown', 'Cable Row'},
  'Legs': {'Barbell Squat', 'Leg Press', 'Leg Curl'},
};

class TrainScreen extends StatefulWidget {
  const TrainScreen({super.key});

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showHowItWorks,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const _StreakCard(),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Your exercises'),
          const SizedBox(height: 4),
          const Text(
            'Choose which lifts count toward each muscle group. Only these '
            'appear when you start a match.',
            style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 14),
          for (final muscle in muscleGroups) ...[
            _MuscleRow(
              muscle: muscle,
              count: exerciseSelections[muscle]?.length ?? 0,
              onTap: () => _editMuscle(muscle),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          const SectionHeader(title: 'This week'),
          const SizedBox(height: 10),
          const _WeekStrip(),
        ],
      ),
    );
  }

  Future<void> _editMuscle(String muscle) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _ExerciseSheet(muscle: muscle),
    );
    if (mounted) setState(() {});
  }

  void _showHowItWorks() {
    showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('How matches work'),
        content: const Text(
          'Pick a muscle group and you are matched with a lifter at a similar '
          'rank. You both log your sets, and whoever moves the most total '
          'volume (weight × reps) before the clock runs out takes the LP.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Got it')),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B00).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.local_fire_department, color: Color(0xFFFF6B00), size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '4 day streak',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Train today to keep it alive',
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleRow extends StatelessWidget {
  final String muscle;
  final int count;
  final VoidCallback onTap;

  const _MuscleRow({required this.muscle, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final configured = count > 0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceRaised),
        ),
        child: Row(
          children: [
            Icon(
              configured ? Icons.check_circle : Icons.fitness_center,
              color: configured ? AppColors.brand : AppColors.muted,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                muscle,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              configured ? '$count selected' : 'Not set up',
              style: TextStyle(
                color: configured ? AppColors.brand : AppColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ExerciseSheet extends StatefulWidget {
  final String muscle;

  const _ExerciseSheet({required this.muscle});

  @override
  State<_ExerciseSheet> createState() => _ExerciseSheetState();
}

class _ExerciseSheetState extends State<_ExerciseSheet> {
  late final Set<String> _selected =
      Set<String>.from(exerciseSelections[widget.muscle] ?? <String>{});

  @override
  Widget build(BuildContext context) {
    final list = exercisesFor(widget.muscle);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.92,
      builder: (context, controller) => Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.muscle.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        '${_selected.length} selected',
                        style: const TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final ex = list[i];
                final isOn = _selected.contains(ex.name);
                return InkWell(
                  onTap: () => setState(() {
                    isOn ? _selected.remove(ex.name) : _selected.add(ex.name);
                  }),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: isOn
                          ? AppColors.brand.withValues(alpha: 0.12)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isOn ? AppColors.brand : AppColors.surfaceRaised,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isOn ? Icons.check_circle : Icons.circle_outlined,
                          color: isOn ? AppColors.brand : AppColors.muted,
                          size: 21,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ex.name,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ex.equipment + (ex.compound ? ' · Compound' : ''),
                                style: const TextStyle(color: AppColors.muted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    exerciseSelections[widget.muscle] = _selected;
                    Navigator.pop(context);
                  },
                  child: const Text('SAVE'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip();

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today = DateTime.now().weekday - 1;
    // Sample activity: the current day plus the three before it. Anchoring to
    // today keeps future days blank — a day that hasn't happened yet can't be
    // ticked off.
    final active = [
      for (var i = 0; i < 7; i++) i <= today && i > today - 4,
    ];

    return Panel(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < 7; i++)
            Column(
              children: [
                Text(
                  labels[i],
                  style: TextStyle(
                    color: i == today ? AppColors.white : AppColors.muted,
                    fontSize: 12,
                    fontWeight: i == today ? FontWeight.w900 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: active[i] ? AppColors.brand : AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: i == today ? AppColors.brand : AppColors.surfaceRaised,
                      width: i == today ? 2 : 1,
                    ),
                  ),
                  child: active[i]
                      ? const Icon(Icons.check, size: 17, color: Colors.white)
                      : null,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
