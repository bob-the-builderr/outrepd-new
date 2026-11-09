/// Moments on screen (the user's picks, 2026-11-09): a new personal best and
/// a milestone each get a screen of their own after the set that made them,
/// the way LEVEL UP does; and on the first days of a month, last month's
/// recap from a card on the Match tab. The rules are in lib/moments.dart.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../backend/backend.dart';
import '../data.dart';
import '../face.dart';
import '../l10n/app_localizations.dart';
import '../moments.dart';
import '../motion.dart';
import '../season.dart';
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
      final endY = r.nextDouble() * size.height * 0.55;
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
  });

  final String keyName;
  final List<Widget> children;
  final String share;
  final VoidCallback onContinue;
  final int seed;

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
        Positioned.fill(child: Confetti(seed: seed)),
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

class MilestoneView extends StatelessWidget {
  const MilestoneView({super.key, required this.mark, required this.onContinue});

  final Milestone mark;
  final VoidCallback onContinue;

  /// 100, 1K, 5K: the mark as the medal writes it.
  static String short(int mark) => mark >= 1000 ? '${mark ~/ 1000}K' : '$mark';

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final next = mark.next;
    return _MomentFrame(
      keyName: 'milestone',
      seed: 19,
      share: l.momentMilestoneShare(localNumber(context, mark.mark), _link()),
      onContinue: onContinue,
      children: [
        _eyebrow(context, l.momentMilestoneTitle),
        const SizedBox(height: 22),
        PopIn(from: 0.6, child: _Medal(text: short(mark.mark), under: l.momentPushUps.toUpperCase())),
        const SizedBox(height: 22),
        Text(
          l.momentMilestoneCount(localNumber(context, mark.mark)),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.text, fontSize: 32, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          l.momentMilestoneLine,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.muted, fontSize: 15),
        ),
        if (next != null) ...[
          const SizedBox(height: 22),
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
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (final m in kMilestones.take(5)) ...[
                      if (m != kMilestones.first) const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: m <= mark.total ? const Color(0xFF2A2214) : colors.surfaceRaised,
                            borderRadius: BorderRadius.circular(10),
                            border: m <= mark.total ? Border.all(color: _gold, width: 1.5) : null,
                          ),
                          child: Text(
                            short(m),
                            style: TextStyle(
                              color: m <= mark.total ? _goldLight : colors.muted,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// A gold sunburst medal with the mark in it.
class _Medal extends StatelessWidget {
  const _Medal({required this.text, required this.under});

  final String text;
  final String under;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 224,
    height: 224,
    child: CustomPaint(
      painter: const _MedalPainter(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(color: _goldLight, fontSize: 62, fontWeight: FontWeight.w900, height: 1),
            ),
            Text(
              under,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _MedalPainter extends CustomPainter {
  const _MedalPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final outer = size.width / 2, inner = outer * 0.84;
    final star = Path();
    const points = 20;
    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? outer : inner;
      final a = -math.pi / 2 + i * math.pi / points;
      final p = c + Offset(math.cos(a) * r, math.sin(a) * r);
      i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
    }
    star.close();
    canvas.drawPath(
      star,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF7DE8E), Color(0xFFD9A94A), Color(0xFF8F6A22)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawCircle(c, outer * 0.62, Paint()..color = const Color(0xFF1B1712));
    canvas.drawCircle(
      c,
      outer * 0.62,
      Paint()
        ..color = _goldLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_MedalPainter old) => false;
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
