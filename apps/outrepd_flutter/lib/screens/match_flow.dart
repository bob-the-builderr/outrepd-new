import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data.dart';
import '../exercises.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import 'match_rounds.dart';
import '../widgets.dart';

/// The full match loop: pick exercises → find an opponent → VS intro →
/// log the workout against a clock → see the result.
///
/// The opponent is simulated locally: their volume is generated up front from
/// the player's rank, so the match resolves without a server.
class MatchFlowScreen extends StatefulWidget {
  final Discipline discipline;

  const MatchFlowScreen({super.key, required this.discipline});

  @override
  State<MatchFlowScreen> createState() => _MatchFlowScreenState();
}

enum _Stage { picking, searching, versus, active, result }

class _MatchFlowScreenState extends State<MatchFlowScreen> {
  _Stage _stage = _Stage.picking;

  final _selected = <String>{};

  /// The six rounds, built once an opponent is found: your three and theirs,
  /// alternating.
  final _rounds = <MatchRound>[];

  late final Opponent _opponent;

  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _opponent = demoOpponents[rng.nextInt(demoOpponents.length)];
    // A believable total for six rounds of ninety seconds, rather than a
    // volume in kilos that nothing on this screen measures any more.
    _theirReps = 48 + rng.nextInt(42);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Reps, not kilos. A round is a fixed window of one movement, so what it
  /// produces is a count — and the camera can count reps but cannot read what
  /// is on the bar.
  int get _myReps => _rounds.fold(0, (sum, r) => sum + r.reps);

  /// What the opponent managed on the same six rounds. Simulated locally until
  /// there is a server to ask.
  late final int _theirReps;

  bool get _won => _myReps >= _theirReps;

  int get _lpChange {
    final margin = (_myReps - _theirReps).abs();
    return _won ? 15 + (margin.clamp(0, 40) ~/ 4) : -(12 + (margin.clamp(0, 40) ~/ 5));
  }

  void _startSearch() {
    setState(() {
      _stage = _Stage.searching;
      // The opponent's three come from the same discipline, chosen at random
      // and never one of yours — half a card of duplicates would waste rounds.
      final pool = widget.discipline.exercises
          .map((e) => e.name)
          .where((n) => !_selected.contains(n))
          .toList()
        ..shuffle();
      _rounds
        ..clear()
        ..addAll(buildCard(
          _selected.toList(),
          pool.take(kPicksPerPlayer).toList(),
        ));
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
        backgroundColor: context.colors.background,
        body: SafeArea(child: _buildStage()),
      ),
    );
  }

  Widget _buildStage() {
    switch (_stage) {
      case _Stage.picking:
        return _ExercisePicker(
          discipline: widget.discipline,
          selected: _selected,
          onToggle: (name) => setState(() {
            if (_selected.contains(name)) {
              _selected.remove(name);
            } else if (_selected.length < kPicksPerPlayer) {
              // Silently ignoring a fourth tap would read as a broken button,
              // so the counter above the list is what says why.
              _selected.add(name);
            }
          }),
          onStart:
              _selected.length == kPicksPerPlayer ? _startSearch : null,
        );
      case _Stage.searching:
        return _SearchingView(discipline: widget.discipline);
      case _Stage.versus:
        return _VersusView(
          opponent: _opponent,
          discipline: widget.discipline,
          countdown: _countdown,
        );
      case _Stage.active:
        return RoundRunner(rounds: _rounds, onFinished: _finish);
      case _Stage.result:
        return _ResultView(
          won: _won,
          volume: _myReps.toDouble(),
          opponentVolume: _theirReps.toDouble(),
          opponent: _opponent,
          lpChange: _lpChange,
          onDone: () => Navigator.of(context).pop(),
        );
    }
  }

  Future<void> _confirmQuit() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(L.of(context).forfeitQ),
        content: Text(L.of(context).forfeitBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(L.of(context).stay)),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(L.of(context).forfeit,
                style: const TextStyle(color: AppColors.loss)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) Navigator.of(context).pop();
  }
}

// ─────────────────────────── stage 1: pick exercises ──────────────────────────

class _ExercisePicker extends StatelessWidget {
  final Discipline discipline;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback? onStart;

  const _ExercisePicker({
    required this.discipline,
    required this.selected,
    required this.onToggle,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final list = discipline.exercises;
    return Column(
      children: [
        _FlowHeader(
          title: discipline.label(L.of(context)).toUpperCase(),
          subtitle: selected.length == kPicksPerPlayer
              ? L.of(context).pickThreeHint
              : L.of(context).picksLeft(
                  localNumber(context, kPicksPerPlayer - selected.length)),
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
                    color: isOn ? context.colors.brand.withValues(alpha: 0.12) : context.colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isOn ? context.colors.brand : context.colors.surfaceRaised,
                      width: isOn ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isOn ? Icons.check_circle : Icons.circle_outlined,
                        color: isOn ? context.colors.brand : context.colors.muted,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ex.name,
                              style: TextStyle(
                                color: context.colors.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ex.equipment + (ex.compound ? ' · Compound' : ''),
                              style: context.type.label.copyWith(color: context.colors.muted),
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
                // The button says what is missing rather than scolding. A
                // round needs exactly three, so "pick two more" is the whole
                // instruction and it counts down as they tap.
                child: Text(
                  selected.length == kPicksPerPlayer
                      ? L.of(context).findOpponent
                      : L.of(context).pickNMore(localNumber(
                          context, kPicksPerPlayer - selected.length)),
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
  final Discipline discipline;

  const _SearchingView({required this.discipline});

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
                            border: Border.all(color: context.colors.brand, width: 2),
                          ),
                        ),
                      ),
                    Icon(Icons.sports_mma, color: context.colors.brand, size: 44),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 36),
          Text(
            'FINDING OPPONENT',
            style: context.type.title.copyWith(color: context.colors.text),
          ),
          const SizedBox(height: 8),
          Text(
            L.of(context).matchingWith(widget.discipline.label(L.of(context))),
            style: context.type.label.copyWith(color: context.colors.muted),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── stage 3: versus ──────────────────────────────────

class _VersusView extends StatelessWidget {
  final Opponent opponent;
  final Discipline discipline;
  final int countdown;

  const _VersusView({
    required this.opponent,
    required this.discipline,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    final p = demoProfile;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          discipline.label(L.of(context)).toUpperCase(),
          style: TextStyle(
            color: context.colors.muted,
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
                subtitle: tierLabel(L.of(context), p.tierIdx, p.divIdx),
              ),
            ),
            Text(
              'VS',
              style: context.type.statValue.copyWith(color: context.colors.brand),
            ),
            Expanded(
              child: _Fighter(
                name: opponent.username.toUpperCase(),
                tierIdx: opponent.tierIdx,
                subtitle:
                    tierLabel(
                        L.of(context), opponent.tierIdx, opponent.divIdx),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          localNumber(context, countdown),
          style: context.type.display.copyWith(color: context.colors.text),
        ),
        Text(L.of(context).getReady,
            style: TextStyle(color: context.colors.muted, letterSpacing: 2)),
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
          style: context.type.heading.copyWith(color: context.colors.text),
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: context.type.label.copyWith(color: kTiers[tierIdx.clamp(0, kTiers.length - 1)].color)),
      ],
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
          Text(L.of(context).matchComplete,
              style: context.type.label.copyWith(color: context.colors.muted)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              won ? L.of(context).youWin : L.of(context).defeated,
              maxLines: 1,
              style: context.type.display.copyWith(color: color),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: _ScoreColumn(
                  label: L.of(context).you,
                  volume: volume,
                  color: won ? context.colors.brand : context.colors.muted,
                  tierIdx: demoProfile.tierIdx,
                ),
              ),
              Text(L.of(context).vs,
                  style: context.type.title.copyWith(color: context.colors.surfaceRaised)),
              Expanded(
                child: _ScoreColumn(
                  label: opponent.username.toUpperCase(),
                  volume: opponentVolume,
                  color: won ? context.colors.muted : AppColors.loss,
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
              '${lpChange >= 0 ? '+' : ''}'
              '${L.of(context).lpAmount(localNumber(context, lpChange))}',
              style: context.type.title.copyWith(color: color),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
                onPressed: onDone, child: Text(L.of(context).backToHome)),
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
            style: context.type.label.copyWith(color: context.colors.text)),
        const SizedBox(height: 4),
        Text(
          '${localNumber(context, volume.round())} ${L.of(context).shortKg}',
          style: context.type.title.copyWith(color: color),
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
                    style: context.type.heading.copyWith(color: context.colors.text)),
                Text(subtitle, style: context.type.label.copyWith(color: context.colors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
