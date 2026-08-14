import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data.dart';
import '../exercises.dart';
import '../theme.dart';
import '../widgets.dart';

/// The full match loop: pick exercises → find an opponent → VS intro →
/// log the workout against a clock → see the result.
///
/// The opponent is simulated locally: their volume is generated up front from
/// the player's rank, so the match resolves without a server.
class MatchFlowScreen extends StatefulWidget {
  final String muscle;

  const MatchFlowScreen({super.key, required this.muscle});

  @override
  State<MatchFlowScreen> createState() => _MatchFlowScreenState();
}

enum _Stage { picking, searching, versus, active, result }

class _MatchFlowScreenState extends State<MatchFlowScreen> {
  _Stage _stage = _Stage.picking;

  final _selected = <String>{};
  final _workout = <WorkoutEntry>[];

  late final Opponent _opponent;
  late final double _opponentVolume;

  int _countdown = 3;
  Duration _remaining = const Duration(hours: 2);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _opponent = demoOpponents[rng.nextInt(demoOpponents.length)];
    // Give the opponent a believable target around the player's usual output.
    _opponentVolume = 5200 + rng.nextDouble() * 5200;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get _volume => _workout.fold(0.0, (sum, e) => sum + e.volume);

  bool get _won => _volume >= _opponentVolume;

  int get _lpChange {
    if (!_won) return -(12 + (_opponentVolume - _volume).clamp(0, 4000) ~/ 500);
    return 15 + (_volume - _opponentVolume).clamp(0, 5000) ~/ 400;
  }

  void _startSearch() {
    setState(() {
      _stage = _Stage.searching;
      _workout
        ..clear()
        ..addAll(_selected.map((name) => WorkoutEntry(name: name)));
    });
    Timer(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      setState(() => _stage = _Stage.versus);
      _runCountdown();
    });
  }

  void _runCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 900), (t) {
      if (!mounted) return;
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        t.cancel();
        setState(() => _stage = _Stage.active);
        _runMatchClock();
      }
    });
  }

  void _runMatchClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_remaining.inSeconds <= 1) {
        t.cancel();
        _finish();
      } else {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  void _finish() {
    _timer?.cancel();
    setState(() => _stage = _Stage.result);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Leaving mid-match would silently forfeit, so confirm first.
      canPop: _stage == _Stage.picking || _stage == _Stage.result,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: _buildStage()),
      ),
    );
  }

  Widget _buildStage() {
    switch (_stage) {
      case _Stage.picking:
        return _ExercisePicker(
          muscle: widget.muscle,
          selected: _selected,
          onToggle: (name) => setState(() {
            _selected.contains(name) ? _selected.remove(name) : _selected.add(name);
          }),
          onStart: _selected.isEmpty ? null : _startSearch,
        );
      case _Stage.searching:
        return _SearchingView(muscle: widget.muscle);
      case _Stage.versus:
        return _VersusView(
          opponent: _opponent,
          muscle: widget.muscle,
          countdown: _countdown,
        );
      case _Stage.active:
        return _ActiveMatchView(
          workout: _workout,
          remaining: _remaining,
          volume: _volume,
          opponent: _opponent,
          onChanged: () => setState(() {}),
          onFinish: _confirmFinish,
        );
      case _Stage.result:
        return _ResultView(
          won: _won,
          volume: _volume,
          opponentVolume: _opponentVolume,
          opponent: _opponent,
          lpChange: _lpChange,
          onDone: () => Navigator.of(context).pop(),
        );
    }
  }

  Future<void> _confirmFinish() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Finish match?'),
        content: const Text('Your volume will be locked in and compared with your opponent.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Keep going')),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Finish', style: TextStyle(color: AppColors.brand)),
          ),
        ],
      ),
    );
    if (ok == true) _finish();
  }

  Future<void> _confirmQuit() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Forfeit match?'),
        content: const Text('You will lose LP if you leave now.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Stay')),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Forfeit', style: TextStyle(color: AppColors.loss)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) Navigator.of(context).pop();
  }
}

// ─────────────────────────── stage 1: pick exercises ──────────────────────────

class _ExercisePicker extends StatelessWidget {
  final String muscle;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback? onStart;

  const _ExercisePicker({
    required this.muscle,
    required this.selected,
    required this.onToggle,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final list = exercisesFor(muscle);
    return Column(
      children: [
        _FlowHeader(
          title: muscle.toUpperCase(),
          subtitle: 'Pick the exercises you will train',
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final ex = list[i];
              final isOn = selected.contains(ex.name);
              return InkWell(
                onTap: () => onToggle(ex.name),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: isOn ? AppColors.brand.withValues(alpha: 0.12) : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isOn ? AppColors.brand : AppColors.surfaceRaised,
                      width: isOn ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isOn ? Icons.check_circle : Icons.circle_outlined,
                        color: isOn ? AppColors.brand : AppColors.muted,
                        size: 22,
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
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onStart,
                child: Text(
                  selected.isEmpty
                      ? 'SELECT AT LEAST ONE'
                      : 'FIND OPPONENT (${selected.length})',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── stage 2: searching ───────────────────────────────

class _SearchingView extends StatefulWidget {
  final String muscle;

  const _SearchingView({required this.muscle});

  @override
  State<_SearchingView> createState() => _SearchingViewState();
}

class _SearchingViewState extends State<_SearchingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _c,
            builder: (context, child) {
              return SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Opacity(
                        opacity: (1 - ((_c.value + i / 3) % 1)).clamp(0.0, 1.0) * 0.5,
                        child: Container(
                          width: 60 + 120 * ((_c.value + i / 3) % 1),
                          height: 60 + 120 * ((_c.value + i / 3) % 1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.brand, width: 2),
                          ),
                        ),
                      ),
                    const Icon(Icons.sports_mma, color: AppColors.brand, size: 44),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 36),
          const Text(
            'FINDING OPPONENT',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Matching you with a lifter at your rank · ${widget.muscle}',
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── stage 3: versus ──────────────────────────────────

class _VersusView extends StatelessWidget {
  final Opponent opponent;
  final String muscle;
  final int countdown;

  const _VersusView({
    required this.opponent,
    required this.muscle,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    final p = demoProfile;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          muscle.toUpperCase(),
          style: const TextStyle(
            color: AppColors.muted,
            letterSpacing: 3,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: _Fighter(
                name: 'YOU',
                tierIdx: p.tierIdx,
                subtitle: tierLabel(p.tierIdx, p.divIdx),
              ),
            ),
            const Text(
              'VS',
              style: TextStyle(
                color: AppColors.brand,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            Expanded(
              child: _Fighter(
                name: opponent.username.toUpperCase(),
                tierIdx: opponent.tierIdx,
                subtitle:
                    tierLabel(opponent.tierIdx, opponent.divIdx),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          '$countdown',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 72,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Text('GET READY', style: TextStyle(color: AppColors.muted, letterSpacing: 2)),
      ],
    );
  }
}

class _Fighter extends StatelessWidget {
  final String name;
  final int tierIdx;
  final String subtitle;

  const _Fighter({required this.name, required this.tierIdx, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TierBadge(tierIdx: tierIdx, size: 96),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(color: kTiers[tierIdx.clamp(0, kTiers.length - 1)].color, fontSize: 12)),
      ],
    );
  }
}

// ─────────────────────────── stage 4: active match ────────────────────────────

class _ActiveMatchView extends StatelessWidget {
  final List<WorkoutEntry> workout;
  final Duration remaining;
  final double volume;
  final Opponent opponent;
  final VoidCallback onChanged;
  final VoidCallback onFinish;

  const _ActiveMatchView({
    required this.workout,
    required this.remaining,
    required this.volume,
    required this.opponent,
    required this.onChanged,
    required this.onFinish,
  });

  String get _clock {
    final h = remaining.inHours.toString().padLeft(2, '0');
    final m = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.surfaceRaised)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TIME LEFT',
                      style: TextStyle(color: AppColors.muted, fontSize: 11, letterSpacing: 1)),
                  Text('vs ${opponent.username}',
                      style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _clock,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    volume.toStringAsFixed(0),
                    style: const TextStyle(
                      color: AppColors.brand,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('kg total volume',
                      style: TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: workout.length,
            itemBuilder: (context, i) => _ExerciseCard(
              entry: workout[i],
              onChanged: onChanged,
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: onFinish, child: const Text('FINISH MATCH')),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final WorkoutEntry entry;
  final VoidCallback onChanged;

  const _ExerciseCard({required this.entry, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceRaised),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.name,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Divider(color: AppColors.surfaceRaised, height: 22),
          for (var i = 0; i < entry.sets.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      'S${i + 1}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _NumberField(
                      hint: 'KG',
                      value: entry.sets[i].weight,
                      onChanged: (v) {
                        entry.sets[i].weight = v;
                        onChanged();
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('×', style: TextStyle(color: AppColors.muted)),
                  ),
                  Expanded(
                    child: _NumberField(
                      hint: 'REPS',
                      value: entry.sets[i].reps,
                      onChanged: (v) {
                        entry.sets[i].reps = v;
                        onChanged();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.loss, size: 20),
                    onPressed: entry.sets.length == 1
                        ? null
                        : () {
                            entry.sets.removeAt(i);
                            onChanged();
                          },
                  ),
                ],
              ),
            ),
          TextButton.icon(
            onPressed: () {
              entry.sets.add(WorkoutSet());
              onChanged();
            },
            icon: const Icon(Icons.add, color: AppColors.brand, size: 20),
            label: const Text('ADD SET',
                style: TextStyle(color: AppColors.brand, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatefulWidget {
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;

  const _NumberField({required this.hint, required this.value, required this.onChanged});

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _c = TextEditingController(text: widget.value);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 12),
        filled: true,
        fillColor: AppColors.background,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

// ─────────────────────────── stage 5: result ──────────────────────────────────

class _ResultView extends StatelessWidget {
  final bool won;
  final double volume;
  final double opponentVolume;
  final Opponent opponent;
  final int lpChange;
  final VoidCallback onDone;

  const _ResultView({
    required this.won,
    required this.volume,
    required this.opponentVolume,
    required this.opponent,
    required this.lpChange,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final color = won ? AppColors.win : AppColors.loss;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('MATCH COMPLETE',
              style: TextStyle(color: AppColors.muted, letterSpacing: 2, fontSize: 13)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              won ? 'YOU WIN!' : 'DEFEATED',
              maxLines: 1,
              style: TextStyle(color: color, fontSize: 42, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: _ScoreColumn(
                  label: 'YOU',
                  volume: volume,
                  color: won ? AppColors.brand : AppColors.muted,
                  tierIdx: demoProfile.tierIdx,
                ),
              ),
              const Text('VS',
                  style: TextStyle(color: AppColors.surfaceRaised, fontSize: 22, fontWeight: FontWeight.w900)),
              Expanded(
                child: _ScoreColumn(
                  label: opponent.username.toUpperCase(),
                  volume: opponentVolume,
                  color: won ? AppColors.muted : AppColors.loss,
                  tierIdx: opponent.tierIdx,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Text(
              '${lpChange >= 0 ? '+' : ''}$lpChange LP',
              style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onDone, child: const Text('BACK TO HOME')),
          ),
        ],
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  final String label;
  final double volume;
  final Color color;
  final int tierIdx;

  const _ScoreColumn({
    required this.label,
    required this.volume,
    required this.color,
    required this.tierIdx,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TierBadge(tierIdx: tierIdx, size: 64),
        const SizedBox(height: 10),
        Text(label,
            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          '${volume.toStringAsFixed(0)} kg',
          style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

// ─────────────────────────── shared header ────────────────────────────────────

class _FlowHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FlowHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
