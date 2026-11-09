/// Moments on screen (the user's picks, 2026-11-09): a new personal best and
/// a milestone each get a screen of their own after the set that made them,
/// the way LEVEL UP does; and on the first days of a month, last month's
/// recap from a card on the Match tab. The rules are in lib/moments.dart.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../awards/award_text.dart';
import '../awards/families.dart';
import '../awards/medal.dart';
import '../backend/backend.dart';
import '../data.dart';
import '../face.dart';
import '../l10n/app_localizations.dart';
import '../moments.dart';
import '../rewards.dart';
import '../motion.dart';
import '../season.dart';
import 'awards.dart';
import '../theme.dart';
import '../widgets.dart';

const _gold = AppColors.gold;
const _goldLight = Color(0xFFF2D27A);

String _link() => 'https://outrepd.com/u/${demoProfile.username}';

// ──────────────────────────────── confetti ────────────────────────────────────

/// Pieces falling once through the top of the screen; still for anybody who
/// asked for less motion.
class Confetti extends StatefulWidget {
  const Confetti({super.key, this.count = 46, this.seed = 7});

  final int count;
  final int seed;

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> with SingleTickerProviderStateMixin {
  late final AnimationController _fall = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_fall.isAnimating || _fall.isCompleted) return;
    if (reduceMotion(context)) {
      _fall.value = 1;
    } else {
      _fall.forward();
    }
  }

  @override
  void dispose() {
    _fall.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: AnimatedBuilder(
      animation: _fall,
      builder: (context, _) => CustomPaint(
        size: Size.infinite,
        painter: _ConfettiPainter(
          t: Curves.easeOutCubic.transform(_fall.value),
          count: widget.count,
          seed: widget.seed,
        ),
      ),
    ),
  );
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.t, required this.count, required this.seed});

  final double t;
  final int count;
  final int seed;

  static const _colours = [
    Color(0xFFE0B145),
    Color(0xFFE8846B),
    Color(0xFFE8DCC8),
    Color(0xFF4CC38A),
    Color(0xFFF2D27A),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final r = math.Random(seed);
    final paint = Paint();
    for (var i = 0; i < count; i++) {
      final x = r.nextDouble() * size.width;
      final endY = r.nextDouble() * size.height * 0.4;
      final startY = endY - size.height * (0.4 + r.nextDouble() * 0.4);
      final y = startY + (endY - startY) * t;
      final w = 5 + r.nextDouble() * 7, h = 9 + r.nextDouble() * 10;
      final spin = r.nextDouble() * math.pi + t * (r.nextDouble() - 0.5) * 6;
      paint.color = _colours[i % _colours.length].withValues(alpha: 0.55 + r.nextDouble() * 0.45);
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(spin)
        ..drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: w, height: h), const Radius.circular(2)),
          paint,
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}

// ─────────────────────────────── the moments ──────────────────────────────────

/// Whichever moment is next.
class MomentView extends StatelessWidget {
  const MomentView({super.key, required this.moment, required this.onContinue});

  final Moment moment;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => switch (moment) {
    final PersonalBest best => PersonalBestView(best: best, onContinue: onContinue),
    final Milestone mark => MilestoneView(mark: mark, onContinue: onContinue),
    final AwardMoment award => AwardUnlockView(title: award.title, onContinue: onContinue),
  };
}

/// The frame both moments share: the gold glow, the confetti, the words in
/// the middle, and Share it / Continue at the foot.
class _MomentFrame extends StatelessWidget {
  const _MomentFrame({
    required this.keyName,
    required this.children,
    required this.share,
    required this.onContinue,
    this.seed = 7,
    this.confetti = 46,
    this.background,
  });

  final String keyName;
  final List<Widget> children;
  final String share;
  final VoidCallback onContinue;
  final int seed;
  final int confetti;

  /// Drawn under everything in place of the plain gold glow.
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.35),
                radius: 0.75,
                colors: [_gold.withValues(alpha: 0.22), Colors.transparent],
              ),
            ),
          ),
        ),
        if (background case final b?) Positioned.fill(child: b),
        Positioned.fill(child: Confetti(seed: seed, count: confetti)),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: (box.maxHeight - 24).clamp(0, double.infinity),
                      ),
                      child: Column(
                        key: Key(keyName),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        key: const Key('momentShare'),
                        onPressed: () => SharePlus.instance.share(ShareParams(text: share)),
                        child: Text(l.momentShare),
                      ),
                    ),
                    const SizedBox(height: 11),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        key: const Key('momentContinue'),
                        onPressed: onContinue,
                        child: Text(l.continueAction),
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

Widget _eyebrow(BuildContext context, String text) => Text(
  text.toUpperCase(),
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: _gold,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: 6,
  ),
);

class PersonalBestView extends StatelessWidget {
  const PersonalBestView({super.key, required this.best, required this.onContinue});

  final PersonalBest best;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    return _MomentFrame(
      keyName: 'personalBest',
      share: l.momentBestShare(localNumber(context, best.reps), _link()),
      onContinue: onContinue,
      children: [
        _eyebrow(context, l.momentBestTitle),
        const SizedBox(height: 26),
        PopIn(
          from: 0.6,
          child: Container(
            width: 230,
            height: 230,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(0, -0.3),
                colors: [Color(0xFF3A2D15), Color(0xFF1B1712)],
              ),
              border: Border.all(color: _gold, width: 6),
              boxShadow: [
                BoxShadow(color: _gold.withValues(alpha: 0.25), spreadRadius: 8),
                BoxShadow(color: _gold.withValues(alpha: 0.45), blurRadius: 70),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    localNumber(context, best.reps),
                    style: TextStyle(
                      color: _goldLight,
                      fontSize: 112,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      shadows: [Shadow(color: _goldLight.withValues(alpha: 0.5), blurRadius: 30)],
                    ),
                  ),
                ),
                Text(
                  l.momentBestUnit,
                  style: TextStyle(color: colors.muted, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${l.momentBestFrom} '),
              TextSpan(
                text: localNumber(context, best.before),
                style: TextStyle(color: colors.muted, decoration: TextDecoration.lineThrough),
              ),
              const TextSpan(text: '   '),
              TextSpan(
                text: '+${localNumber(context, best.reps - best.before)}',
                style: const TextStyle(color: AppColors.win),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.text, fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          l.momentBestLine,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.muted, fontSize: 15),
        ),
      ],
    );
  }
}

/// A milestone (the user's pick, 2026-11-09, A): the count rolls up to the
/// mark on flip tiles like a scoreboard, then the club's stamp lands, over
/// slowly turning rays.
class MilestoneView extends StatefulWidget {
  const MilestoneView({super.key, required this.mark, required this.onContinue});

  final Milestone mark;
  final VoidCallback onContinue;

  /// 100, 1K, 5K: the mark as the stamp writes it.
  static String short(int mark) => mark >= 1000 ? '${mark ~/ 1000}K' : '$mark';

  @override
  State<MilestoneView> createState() => _MilestoneViewState();
}

class _MilestoneViewState extends State<MilestoneView> with TickerProviderStateMixin {
  /// The digits rolling, then the stamp.
  late final AnimationController _roll = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  /// The rays turning, for as long as the screen is up.
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_roll.isAnimating || _roll.isCompleted) return;
    if (reduceMotion(context)) {
      _roll.value = 1;
    } else {
      _roll.forward();
      _spin.repeat();
    }
  }

  @override
  void dispose() {
    _roll.dispose();
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final mark = widget.mark;
    final next = mark.next;
    final stamp = CurvedAnimation(parent: _roll, curve: const Interval(0.72, 0.9, curve: Curves.easeOutBack));
    return _MomentFrame(
      keyName: 'milestone',
      seed: 19,
      confetti: 24,
      background: AnimatedBuilder(
        animation: _spin,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _RaysPainter(turn: _spin.value, colour: _gold.withValues(alpha: 0.13)),
        ),
      ),
      share: l.momentMilestoneShare(localNumber(context, mark.mark), _link()),
      onContinue: widget.onContinue,
      children: [
        _eyebrow(context, l.momentJustHit),
        const SizedBox(height: 22),
        AnimatedBuilder(
          animation: _roll,
          builder: (context, _) => _FlipCount(
            text: localNumber(context, mark.mark),
            t: Curves.easeOut.transform((_roll.value / 0.7).clamp(0.0, 1.0)),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l.momentPushUps.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.text, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 4),
        ),
        const SizedBox(height: 26),
        AnimatedBuilder(
          animation: stamp,
          builder: (context, child) => Opacity(
            opacity: stamp.value.clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: -0.14,
              child: Transform.scale(scale: 1.7 - 0.7 * stamp.value, child: child),
            ),
          ),
          child: Container(
            key: const Key('milestoneStamp'),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _gold, width: 4),
              boxShadow: [BoxShadow(color: _gold.withValues(alpha: 0.35), blurRadius: 30)],
            ),
            child: Text(
              l.momentClub(MilestoneView.short(mark.mark)).toUpperCase(),
              style: const TextStyle(color: _gold, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 3),
            ),
          ),
        ),
        if (next != null) ...[
          const SizedBox(height: 34),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.momentNext(localNumber(context, next)),
                        style: TextStyle(color: colors.text, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      l.momentToGo(localNumber(context, next - mark.total)),
                      style: TextStyle(color: colors.muted, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (mark.total / next).clamp(0.0, 1.0),
                    minHeight: 8,
                    color: _gold,
                    backgroundColor: colors.surfaceRaised,
                  ),
                ),
                const SizedBox(height: 10),
                Text(l.momentMilestoneLine, style: TextStyle(color: colors.muted, fontSize: 13.5)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// The count on flip tiles, each digit rolling through 0–9 and settling on
/// its own a little after the one to its left. [t] runs 0 to 1; separators
/// (and digits a language writes in other figures) are drawn as they are.
class _FlipCount extends StatelessWidget {
  const _FlipCount({required this.text, required this.t});

  final String text;
  final double t;

  @override
  Widget build(BuildContext context) {
    final chars = text.characters.toList();
    final digits = chars.where((c) => RegExp(r'^[0-9]$').hasMatch(c)).length;
    var seen = 0;
    final tiles = <Widget>[];
    for (final c in chars) {
      if (!RegExp(r'^[0-9]$').hasMatch(c)) {
        tiles.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(c, style: const TextStyle(color: _goldLight, fontSize: 56, fontWeight: FontWeight.w900)),
          ),
        );
        continue;
      }
      // Each digit settles at its own point: left to right, the last at 1.
      final settle = digits <= 1 ? 1.0 : 0.55 + 0.45 * seen / (digits - 1);
      seen++;
      final shown = t >= settle ? c : '${((t / settle) * 30 + seen * 3).floor() % 10}';
      tiles.add(_Tile(digit: shown));
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: tiles),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.digit});

  final String digit;

  @override
  Widget build(BuildContext context) => Container(
    width: 64,
    height: 96,
    margin: const EdgeInsets.symmetric(horizontal: 3),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2A2622), Color(0xFF2A2622), Color(0xFF1C1A18), Color(0xFF1C1A18)],
        stops: [0, 0.49, 0.51, 1],
      ),
      border: Border.all(color: const Color(0xFF3A3631)),
      boxShadow: const [BoxShadow(color: Color(0x80000000), blurRadius: 24, offset: Offset(0, 10))],
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Text(
          digit,
          style: const TextStyle(color: _goldLight, fontSize: 70, fontWeight: FontWeight.w900, height: 1),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 47,
          height: 2,
          child: ColoredBox(color: context.colors.background),
        ),
      ],
    ),
  );
}

/// Gold wedges turning slowly round a point a third of the way down.
class _RaysPainter extends CustomPainter {
  const _RaysPainter({required this.turn, required this.colour});

  final double turn;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height * 0.32);
    final r = size.longestSide * 1.2;
    const n = 18;
    final paint = Paint()..color = colour;
    for (var i = 0; i < n; i++) {
      final a = turn * 2 * math.pi + i * 2 * math.pi / n;
      final b = a + math.pi / n / 1.4;
      canvas.drawPath(
        Path()
          ..moveTo(c.dx, c.dy)
          ..lineTo(c.dx + math.cos(a) * r, c.dy + math.sin(a) * r)
          ..lineTo(c.dx + math.cos(b) * r, c.dy + math.sin(b) * r)
          ..close(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RaysPainter old) => old.turn != turn || old.colour != colour;
}

/// A new award tier or special, after the match that earned it (the user's
/// pick, 2026-11-09): the medal in its metal, its name, and how rare it is.
class AwardUnlockView extends StatelessWidget {
  const AwardUnlockView({super.key, required this.title, required this.onContinue});

  final EarnedTitle title;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final held = familyTierOf(title.id);
    final special = specialOf(title.id);
    final tier = held?.tier ?? special?.tier ?? 2;
    final glyph = held?.family.glyph ?? special?.glyph ?? AwardGlyph.crown;
    final colour = tierColour(tier);
    final rarity = awardRarity[title.id];
    return _MomentFrame(
      keyName: 'awardUnlock',
      seed: 23,
      confetti: 20,
      background: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.3),
            radius: 0.8,
            colors: [colour.withValues(alpha: 0.28), Colors.transparent],
          ),
        ),
      ),
      share: l.awShareText(title.name(l), title.hintText(l), _link()),
      onContinue: onContinue,
      children: [
        Text(
          l.awNewAward.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: colour, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 6),
        ),
        const SizedBox(height: 24),
        PopIn(from: 0.4, child: Medal(tier: tier, glyph: glyph, size: 220)),
        const SizedBox(height: 24),
        if (held != null)
          Text(
            tierWord(l, tier).toUpperCase(),
            style: TextStyle(color: colour, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 3),
          ),
        Text(
          title.name(l),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.text, fontSize: 32, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          title.hintText(l),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.muted, fontSize: 15),
        ),
        if (rarity != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colour.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              rarity < 1 ? l.awHeldRare : l.awHeldBy('$rarity'),
              style: TextStyle(color: colour, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ],
    );
  }
}

// ──────────────────────────────── the month ───────────────────────────────────

/// The month's name in the reader's language; season.dart reads its dates as
/// UTC, so the middle of the month, where no time zone moves it.
String _monthName(BuildContext context, DateTime month) =>
    monthName(context, DateTime.utc(month.year, month.month, 15));

/// On the Match tab in a month's first week: last month is in.
class MonthRecapCard extends StatelessWidget {
  const MonthRecapCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final month = recaps.lastMonth;
    final name = _monthName(context, month);
    final short = shortMonthName(context, DateTime.utc(month.year, month.month, 15)).toUpperCase();
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    return PressScale(
      scale: 0.98,
      child: Material(
        key: const Key('recapCard'),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color(0xFF2A2214), colors.surface], stops: const [0, 0.65]),
            border: Border.all(color: _gold, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MonthRecapScreen()),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(short, style: const TextStyle(color: _gold, fontSize: 10, fontWeight: FontWeight.w800)),
                        Text(
                          localNumber(context, lastDay),
                          style: TextStyle(color: colors.text, fontSize: 22, fontWeight: FontWeight.w900, height: 1.1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.recapCardTitle(name),
                          style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          l.recapCardLine,
                          style: TextStyle(color: colors.muted, fontSize: 14),
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
      ),
    );
  }
}

class MonthRecapScreen extends StatefulWidget {
  const MonthRecapScreen({super.key});

  @override
  State<MonthRecapScreen> createState() => _MonthRecapScreenState();
}

class _MonthRecapScreenState extends State<MonthRecapScreen> {
  late final Future<MonthRecap> _recap = recaps.recap();

  @override
  void initState() {
    super.initState();
    recaps.markSeen();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<MonthRecap>(
      future: _recap,
      builder: (context, snap) => snap.data == null
          ? const Center(child: CircularProgressIndicator())
          : MonthRecapView(recap: snap.data!, onDone: () => Navigator.of(context).pop()),
    ),
  );
}

class MonthRecapView extends StatelessWidget {
  const MonthRecapView({super.key, required this.recap, required this.onDone});

  final MonthRecap recap;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final name = _monthName(context, recap.month);
    final me = backend.me;
    final numbers = recap.numbers;

    Widget stat(String big, String small, {Color? colour, String? extra}) => Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(big, style: TextStyle(color: colour ?? colors.text, fontSize: 40, fontWeight: FontWeight.w900, height: 1)),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: small),
                if (extra != null) TextSpan(text: ' · $extra', style: const TextStyle(color: AppColors.win)),
              ],
            ),
            style: TextStyle(color: colors.muted, fontSize: 13.5),
          ),
        ],
      ),
    );

    final stats = <Widget>[
      if (recap.best case final best?)
        stat(
          localNumber(context, best),
          l.recapBest,
          colour: _goldLight,
          extra: recap.bestRise > 0 ? '+${localNumber(context, recap.bestRise)}' : null,
        ),
      if (numbers != null)
        stat('${localNumber(context, numbers.wins)}–${localNumber(context, numbers.losses)}', l.recapWins),
      stat(localNumber(context, recap.longestRun), l.recapRun),
      stat(localNumber(context, recap.daysTrained), l.recapDays, colour: colors.rival),
    ];

    final top = recap.days.fold(1, math.max);
    final topDay = recap.topDay;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -1),
                radius: 0.9,
                colors: [const Color(0xFF3A2D15), colors.background],
              ),
            ),
          ),
        ),
        const Positioned(left: 0, right: 0, top: 0, height: 220, child: Confetti(count: 20, seed: 11)),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                  children: [
                    Text(
                      l.recapTitle(name).toUpperCase(),
                      key: const Key('recapTitle'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _gold, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 6),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: PersonAvatar(
                        id: me?.id ?? '',
                        name: demoProfile.username,
                        avatarUrl: me?.avatarUrl,
                        size: 92,
                        mine: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        localNumber(context, recap.reps),
                        style: TextStyle(color: colors.text, fontSize: 96, fontWeight: FontWeight.w900, height: 1),
                      ),
                    ),
                    Text(
                      l.recapPushUps,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.muted, fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.6,
                      children: stats,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(18)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(l.recapByDay, style: TextStyle(color: colors.muted, fontSize: 14, fontWeight: FontWeight.w600)),
                              ),
                              if (topDay != null)
                                Text(
                                  l.recapTopDay(
                                    localNumber(context, topDay),
                                    localNumber(context, recap.days[topDay - 1]),
                                  ),
                                  style: TextStyle(color: colors.text, fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 70,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (var i = 0; i < recap.days.length; i++) ...[
                                  if (i > 0) const SizedBox(width: 3),
                                  Expanded(
                                    child: Container(
                                      height: math.max(3, recap.days[i] / top * 70),
                                      decoration: BoxDecoration(
                                        color: topDay == i + 1
                                            ? _goldLight
                                            : recap.days[i] > 0
                                            ? colors.brand
                                            : colors.surfaceRaised,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        key: const Key('recapShare'),
                        onPressed: () => SharePlus.instance.share(
                          ShareParams(
                            text: l.recapShare(name, localNumber(context, recap.reps), _link()),
                          ),
                        ),
                        child: Text(l.recapShareButton),
                      ),
                    ),
                    const SizedBox(height: 11),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(onPressed: onDone, child: Text(l.doneAction)),
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
