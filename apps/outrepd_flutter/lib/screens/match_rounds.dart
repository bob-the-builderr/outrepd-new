/// The six rounds of a match, and the rest between them.
///
/// Half the card is yours and half is your opponent's, alternating, so nobody
/// spends three rounds warming up on their own picks while the other waits.
/// Each round is a fixed window of work rather than a target number of reps:
/// both lifters answer the same question — how many in ninety seconds — instead
/// of racing to a number where the faster one simply finishes and stands about.
library;

import 'package:flutter/material.dart';

import '../exercises.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../reps/exercise_patterns.dart';
import '../theme.dart';
import '../widgets.dart';
import 'trainer.dart';

/// One round: the movement, and whose pick put it on the card.
class MatchRound {
  MatchRound({required this.exercise, required this.mine});

  final String exercise;

  /// True when this was one of your three. Shown because lifting your
  /// opponent's choice is the part of the format worth feeling.
  final bool mine;

  /// Reps that survived the count, once the round has been lifted.
  int reps = 0;
  bool done = false;
}

/// Builds the card from both players' picks, alternating so the rounds trade
/// off rather than arriving in two blocks.
List<MatchRound> buildCard(List<String> mine, List<String> theirs) {
  final rounds = <MatchRound>[];
  for (var i = 0; i < kPicksPerPlayer; i++) {
    if (i < mine.length) {
      rounds.add(MatchRound(exercise: mine[i], mine: true));
    }
    if (i < theirs.length) {
      rounds.add(MatchRound(exercise: theirs[i], mine: false));
    }
  }
  return rounds;
}

class RoundRunner extends StatefulWidget {
  const RoundRunner({
    super.key,
    required this.rounds,
    required this.onFinished,
  });

  final List<MatchRound> rounds;
  final VoidCallback onFinished;

  @override
  State<RoundRunner> createState() => _RoundRunnerState();
}

class _RoundRunnerState extends State<RoundRunner> {
  int _index = 0;
  Duration _rest = Duration.zero;
  bool _resting = false;

  MatchRound get _round => widget.rounds[_index];

  int get _total => widget.rounds.fold(0, (sum, r) => sum + r.reps);

  Future<void> _lift() async {
    final def = cameraDefFor(_round.exercise);
    if (def == null) return;

    final counted = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => TrainerScreen(
          exercise: def,
          autoStart: true,
          forMatch: true,
          limit: kRoundWork,
        ),
      ),
    );
    if (!mounted) return;

    setState(() {
      _round.reps = counted ?? 0;
      _round.done = true;
    });

    if (_index >= widget.rounds.length - 1) {
      widget.onFinished();
      return;
    }
    _startRest();
  }

  void _startRest() {
    setState(() {
      _resting = true;
      _rest = kRoundRest;
    });
    _tickRest();
  }

  void _tickRest() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || !_resting) return;
      if (_rest.inSeconds <= 1) {
        setState(() {
          _resting = false;
          _index++;
        });
        return;
      }
      setState(() => _rest -= const Duration(seconds: 1));
      _tickRest();
    });
  }

  /// Rest is a courtesy, not a rule. Somebody who is ready should not have to
  /// watch a clock they do not need.
  void _skipRest() => setState(() {
        _resting = false;
        _index++;
      });

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Column(
            children: [
              Text(
                l.roundOf(
                  localNumber(context, _index + 1),
                  localNumber(context, widget.rounds.length),
                ),
                style: TextStyle(
                  color: context.colors.muted,
                  fontSize: 12.5,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              PopOnChange(
                value: _total,
                child: Text(
                  localNumber(context, _total),
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                l.reps,
                style: TextStyle(color: context.colors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: _resting
              ? _RestView(
                  remaining: _rest,
                  next: widget.rounds[_index + 1],
                  onSkip: _skipRest,
                )
              : _WorkView(round: _round, onStart: _lift),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              for (final r in widget.rounds)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        r.done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 15,
                        color: r.done
                            ? AppColors.win
                            : context.colors.surfaceRaised,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          r.exercise,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: r.done
                                ? context.colors.text
                                : context.colors.muted,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      if (r.done)
                        Text(
                          localNumber(context, r.reps),
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkView extends StatelessWidget {
  const _WorkView({required this.round, required this.onStart});

  final MatchRound round;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Whose pick it is, said plainly. Lifting somebody else's choice is
            // the whole shape of the format and it should be felt, not buried.
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: round.mine
                    ? context.colors.brand.withValues(alpha: 0.15)
                    : AppColors.loss.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                round.mine ? l.yourPick : l.theirPick,
                style: TextStyle(
                  color: round.mine ? context.colors.brand : AppColors.loss,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              round.exercise,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l.secondsOfWork(localNumber(context, kRoundWork.inSeconds)),
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onStart,
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.brand,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l.start,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestView extends StatelessWidget {
  const _RestView({
    required this.remaining,
    required this.next,
    required this.onSkip,
  });

  final Duration remaining;
  final MatchRound next;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l.rest.toUpperCase(),
            style: TextStyle(
              color: context.colors.muted,
              fontSize: 12.5,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            localNumber(context, remaining.inSeconds),
            style: TextStyle(
              color: context.colors.brand,
              fontSize: 64,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l.nextUp,
            style: TextStyle(color: context.colors.muted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            next.exercise,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 26),
          TextButton(
            onPressed: onSkip,
            child: Text(
              l.skip,
              style: TextStyle(color: context.colors.brand),
            ),
          ),
        ],
      ),
    );
  }
}
