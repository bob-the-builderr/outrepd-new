/// How the minute went: both counts drawn over the sixty seconds, and the
/// moment the result was decided.
///
/// A result is two numbers; the minute behind them is a race, and losing by
/// five reads differently when the chart shows they pulled away at 0:30
/// than when it shows they were ahead from the first rep.
library;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';
import 'match_flow.dart' show kDuelLength;

class RaceChart extends StatelessWidget {
  const RaceChart({
    super.key,
    required this.yours,
    required this.theirs,
    required this.opponent,
  });

  /// When each rep landed, in milliseconds from the start of the minute.
  final List<int> yours;
  final List<int> theirs;

  final String opponent;

  /// The moment whoever finished ahead went ahead for good, and who that
  /// was — or null when the minute ended level.
  static ({int at, bool you})? decided(List<int> yours, List<int> theirs) {
    final events = [
      for (final t in yours) (t, true),
      for (final t in theirs) (t, false),
    ]..sort((a, b) => a.$1.compareTo(b.$1));
    var mine = 0, others = 0;
    bool? leader;
    var since = 0;
    for (final (t, you) in events) {
      if (you) {
        mine++;
      } else {
        others++;
      }
      final now = mine > others
          ? true
          : others > mine
          ? false
          : null;
      if (now != leader) {
        leader = now;
        since = t;
      }
    }
    if (leader == null) return null;
    return (at: since, you: leader);
  }

  static String _clock(int ms) {
    final seconds = (ms / 1000).floor().clamp(0, kDuelLength.inSeconds);
    return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final when = decided(yours, theirs);

    return Container(
      key: const Key('raceChart'),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.raceChartTitle,
            style: TextStyle(
              color: colors.text,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 130,
            width: double.infinity,
            child: CustomPaint(
              painter: _RacePainter(
                yours: yours,
                theirs: theirs,
                decidedAt: when?.at,
                you: colors.brand,
                them: colors.rival,
                line: colors.surfaceRaised,
                mark: colors.faint,
              ),
            ),
          ),
          if (when != null) ...[
            const SizedBox(height: 8),
            Text(
              when.you
                  ? l.raceYouLead(_clock(when.at))
                  : l.raceTheyLead(_clock(when.at), opponent),
              key: const Key('raceDecided'),
              style: TextStyle(color: colors.muted, fontSize: 13),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              _Key(colour: colors.brand, label: l.you),
              const SizedBox(width: 18),
              Flexible(child: _Key(colour: colors.rival, label: opponent)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.colour, required this.label});

  final Color colour;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 4,
          decoration: BoxDecoration(
            color: colour,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: ShrinkText(
            label,
            maxLines: 1,
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _RacePainter extends CustomPainter {
  const _RacePainter({
    required this.yours,
    required this.theirs,
    required this.decidedAt,
    required this.you,
    required this.them,
    required this.line,
    required this.mark,
  });

  final List<int> yours;
  final List<int> theirs;
  final int? decidedAt;
  final Color you;
  final Color them;
  final Color line;
  final Color mark;

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 4.0;
    final width = size.width - pad * 2;
    final height = size.height - pad * 2;
    final most = [yours.length, theirs.length, 1].reduce((a, b) => a > b ? a : b);
    final length = kDuelLength.inMilliseconds;
    double x(int ms) => pad + width * (ms / length).clamp(0.0, 1.0);
    double y(int count) => pad + height - height * count / most;

    canvas.drawLine(
      Offset(pad, y(0)),
      Offset(pad + width, y(0)),
      Paint()
        ..color = line
        ..strokeWidth = 2,
    );

    if (decidedAt case final at?) {
      final dx = x(at);
      final dash = Paint()
        ..color = mark
        ..strokeWidth = 1.5;
      for (var dy = pad; dy < pad + height; dy += 9) {
        canvas.drawLine(Offset(dx, dy), Offset(dx, dy + 5), dash);
      }
    }

    Path race(List<int> times) {
      final path = Path()..moveTo(x(0), y(0));
      for (var i = 0; i < times.length; i++) {
        path.lineTo(x(times[i]), y(i + 1));
      }
      path.lineTo(x(length), y(times.length));
      return path;
    }

    Paint stroke(Color colour) => Paint()
      ..color = colour
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // Theirs first, so where the two meet, yours is the one on top.
    canvas.drawPath(race(theirs), stroke(them));
    canvas.drawPath(race(yours), stroke(you));
  }

  @override
  bool shouldRepaint(_RacePainter old) =>
      old.yours != yours || old.theirs != theirs || old.decidedAt != decidedAt;
}
