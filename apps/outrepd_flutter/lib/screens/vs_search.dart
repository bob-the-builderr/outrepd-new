/// The search for an opponent as a face-off (the user's pick, 2026-11-03):
/// you in your frame on one side, and on the other an empty seat whose faces
/// keep flicking past while the search runs, slowing when somebody is found
/// and landing on them — in their tier's frame, with their name and rank.
///
/// The faces that flick past are lifters drawn from made-up names, the way a
/// slot machine shows any fruit; nobody is claimed to be searching. A
/// question mark sits in the seat instead where the phone asks for less
/// motion, and under tests.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../avatar.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../lifter/lifter_view.dart';
import '../lifter/my_lifter.dart';
import '../motion.dart';
import '../player_avatar.dart';
import '../subscription.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../tier_frame.dart';
import '../widgets.dart';

/// The size of each side's picture.
const _picture = 60.0;

class VsSearchCard extends StatelessWidget {
  const VsSearchCard({super.key, required this.found, required this.children});

  /// Who the search found, or null while it is still looking.
  final Opponent? found;

  /// What the search says under the two of you: how long, and what next.
  final List<Widget> children;

  /// The gap between the two sides, where "VS" sits.
  static const _middle = 56.0;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final me = demoProfile;
    final them = found;

    return Container(
      key: const Key('vsSearchCard'),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 180,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -1),
                    radius: 1.2,
                    colors: [
                      AppColors.gold.withValues(alpha: 0.1),
                      AppColors.gold.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      // The framed picture is twice as wide as its circle;
                      // on a narrow phone it shrinks rather than overflow.
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ListenableBuilder(
                          listenable: Listenable.merge([
                            avatar,
                            MyLifter.instance,
                            Subscription.instance,
                          ]),
                          builder: (context, _) => PlayerAvatar(
                            name: me.username,
                            tierIdx: me.isRanked ? me.tierIdx : null,
                            image: avatar.picture,
                            alive: Subscription.instance.active,
                            size: _picture,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _middle,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l.vs,
                          style: TextStyle(
                            color: colors.brand.withValues(alpha: 0.55),
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _Seat(found: them),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        l.you,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: _middle),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            them?.username ?? l.whoIsNext,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: them == null
                                ? TextStyle(color: colors.muted, fontSize: 13)
                                : TextStyle(
                                    color: colors.rival,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                          ),
                          if (them != null)
                            Text(
                              tierLabel(l, them.tierIdx, them.divIdx),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: tierMetal(them.tierIdx).light,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...children,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The seat across from you: faces flicking past inside a turning dashed
/// ring, slowing to a stop on whoever was found.
class _Seat extends StatefulWidget {
  const _Seat({required this.found});

  final Opponent? found;

  @override
  State<_Seat> createState() => _SeatState();
}

class _SeatState extends State<_Seat> with SingleTickerProviderStateMixin {
  /// Made-up names, each drawing a different lifter.
  static final _names = [for (var i = 0; i < 24; i++) 'seat-$i-${i * 37 % 11}'];

  /// How long each face stays as the seat slows, once somebody is found.
  static const _slowing = [110, 150, 210];

  late final _turn = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );
  Timer? _flick;
  var _face = 0;
  var _landed = false;
  var _moving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _moving = loopsAllowed(context);
    if (widget.found != null && _flick == null) {
      _landed = true;
    } else if (_moving && !_landed && _flick == null) {
      _face = math.Random().nextInt(_names.length);
      _flick = Timer.periodic(const Duration(milliseconds: 85), (_) => _next());
    }
    if (_moving && !_landed) {
      if (!_turn.isAnimating) _turn.repeat();
    } else {
      _turn.stop();
    }
  }

  @override
  void didUpdateWidget(_Seat old) {
    super.didUpdateWidget(old);
    if (old.found == null && widget.found != null) _land();
  }

  void _next() {
    if (mounted) setState(() => _face = (_face + 1) % _names.length);
  }

  /// Slower and slower, then them.
  void _land() {
    _flick?.cancel();
    _flick = null;
    if (!_moving) {
      setState(() => _landed = true);
      return;
    }
    var step = 0;
    void slower() {
      if (step == _slowing.length) {
        _turn.stop();
        if (mounted) setState(() => _landed = true);
        return;
      }
      _flick = Timer(Duration(milliseconds: _slowing[step++]), () {
        _next();
        slower();
      });
    }

    slower();
  }

  @override
  void dispose() {
    _flick?.cancel();
    _turn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rival = context.colors.rival;
    final them = widget.found;
    final box = Size(TierFrame.widthFor(_picture), 88);

    final Widget seat;
    if (_landed && them != null) {
      final url = them.avatarUrl;
      seat = TweenAnimationBuilder<double>(
        key: const ValueKey('landed'),
        tween: Tween(begin: _moving ? 0.6 : 1, end: 1),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: PlayerAvatar(
          name: them.username,
          tierIdx: them.tierIdx,
          image: pictureAt(url),
          size: _picture,
        ),
      );
    } else {
      seat = SizedBox.square(
        dimension: 84,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RotationTransition(
              turns: _turn,
              child: CustomPaint(
                size: const Size.square(84),
                painter: _DashedRing(rival.withValues(alpha: 0.6)),
              ),
            ),
            if (_moving)
              LifterCircle(name: _names[_face], size: 70)
            else
              Text(
                '?',
                style: TextStyle(
                  color: rival,
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
          ],
        ),
      );
    }
    return SizedBox.fromSize(size: box, child: Center(child: seat));
  }
}

class _DashedRing extends CustomPainter {
  const _DashedRing(this.colour);

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colour
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final rect = (Offset.zero & size).deflate(1);
    const dashes = 22;
    const sweep = 2 * math.pi / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect, i * sweep, sweep * 0.55, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRing old) => old.colour != colour;
}
