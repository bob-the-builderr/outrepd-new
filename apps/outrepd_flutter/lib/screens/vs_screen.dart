/// The VS screen before every match with somebody in it — live, a saved
/// set, a rematch: the two lifters big, face to
/// face — the opponent above, this account below, split by a slanted line,
/// VS exactly between the two pictures (the user's picks, 2026-11-01: the
/// first design, refined). A Pro enters with lightning, a holo edge and the
/// shine passing over them; the other phone sees it too.
///
/// It comes in as one move: the opponent's half drops from the top and this
/// account's rises from the foot, VS pops between them, then the lightning
/// flashes once. Each side is the lifter its account made; an account that
/// made none but has a photo shows the photo, filling its half; one with
/// neither, the lifter its name gives.
library;

import 'package:flutter/material.dart';

import '../avatar.dart';
import '../face.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../lifter/catalog.dart';
import '../lifter/lifter_view.dart';
import '../lifter/looks.dart';
import '../lifter/my_lifter.dart';
import '../subscription.dart';
import '../theme.dart';
import '../widgets.dart';
import '../xp.dart';
import 'pro_parts.dart';

/// How long the VS screen stays: three seconds, counted down at its foot.
const kVsTime = Duration(seconds: 3);

/// What the other side of a VS screen is: somebody on camera now, a set they
/// saved, or a rematch.
enum VsKind { live, saved, rematch }

/// What a side shows: a lifter to draw, or a photo.
typedef _Face = ({Lifter? lifter, ImageProvider? photo});

class VsScreen extends StatefulWidget {
  const VsScreen({
    super.key,
    required this.opponentId,
    required this.opponentName,
    required this.opponentTierIdx,
    required this.opponentDivIdx,
    this.opponentXp,
    this.opponentAvatarUrl,
    this.ranked = true,
    this.kind = VsKind.live,
  });

  final String opponentId;
  final String opponentName;
  final int opponentTierIdx;
  final int opponentDivIdx;
  final int? opponentXp;

  /// Their uploaded picture, shown when they made no lifter.
  final String? opponentAvatarUrl;
  final bool ranked;

  /// Live, a saved set or a rematch: what the tag at the top says, and
  /// whether its dot is live red. A saved set is not somebody on camera now,
  /// and the screen must not say it is (the user's pick, 2026-11-04: the
  /// same tag with a grey dot).
  final VsKind kind;

  @override
  State<VsScreen> createState() => _VsScreenState();
}

class _VsScreenState extends State<VsScreen> with SingleTickerProviderStateMixin {
  /// The entrance, start to finish: halves in, VS, the lightning.
  late final AnimationController _in = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  );

  // Its parts: the halves meet, VS pops as they do, the names and the line
  // appear, the lightning flashes last.
  late final _halves = CurvedAnimation(parent: _in, curve: const Interval(0, 0.45, curve: Curves.easeOutCubic));
  late final _vs = CurvedAnimation(parent: _in, curve: const Interval(0.38, 0.75, curve: Curves.easeOutBack));
  late final _names = CurvedAnimation(parent: _in, curve: const Interval(0.45, 0.8, curve: Curves.easeOut));
  late final _flash = CurvedAnimation(parent: _in, curve: const Interval(0.6, 1));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_in.isAnimating || _in.isCompleted) return;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _in.value = 1;
    } else {
      _in.forward();
    }
  }

  @override
  void dispose() {
    _halves.dispose();
    _vs.dispose();
    _names.dispose();
    _flash.dispose();
    _in.dispose();
    super.dispose();
  }

  /// This account: the lifter it made, or the photo it chose over it, or
  /// the lifter its name gives.
  _Face _mine(String name) => switch (avatar.picture) {
    final LifterPicture made => (lifter: made.lifter, photo: null),
    final ImageProvider photo => (lifter: null, photo: photo),
    null => (lifter: lifterFor(name), photo: null),
  };

  /// The opponent: the lifter they wear, or their photo, or the lifter their
  /// name gives.
  _Face _theirs() {
    final face = faceOf(
      id: widget.opponentId,
      name: widget.opponentName,
      avatarUrl: widget.opponentAvatarUrl,
    );
    if (face.photo case final photo?) return (lifter: null, photo: photo);
    return (lifter: face.lifter, photo: null);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([Looks.instance, MyLifter.instance, Subscription.instance, avatar]),
    builder: (context, _) => LayoutBuilder(builder: _layout),
  );

  Widget _layout(BuildContext context, BoxConstraints box) {
    final l = L.of(context);
    final colors = context.colors;
    final w = box.maxWidth, h = box.maxHeight;
    final me = demoProfile;
    final mePro = Subscription.instance.active;
    final themPro = Looks.instance.pro(widget.opponentId);
    final anyPro = mePro || themPro;

    // The design's measures, as shares of the screen (drawn at 824 × 1830).
    final top = h * 0.057;
    final split = (left: h * 0.486, right: h * 0.421); // the opponent's foot
    final rise = (left: h * 0.552, right: h * 0.486); // this account's head
    final foot = h * 0.885;
    final art = w * 1.097;
    final vsY = (split.left + split.right + rise.left + rise.right) / 4;

    final halves = _halves, vs = _vs, names = _names, flash = _flash;

    Widget side({
      required Path Function(Size) shape,
      required _Face face,
      required double y,
      required double photoTop,
      required double photoBottom,
      required double fadeFrom,
      required double fadeTo,
      required bool pro,
      required double from,
    }) {
      final lifter = face.lifter;
      final photo = face.photo;
      return AnimatedBuilder(
        animation: halves,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, from * (1 - halves.value)),
          child: child,
        ),
        child: ClipPath(
          clipper: _PathClip(shape),
          child: Stack(
            children: [
              if (photo != null)
                // A photo fills its half, faces kept a little above the middle.
                Positioned(
                  left: 0,
                  right: 0,
                  top: photoTop,
                  bottom: h - photoBottom,
                  child: Image(
                    image: photo,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.3),
                    errorBuilder: (context, error, stack) => const SizedBox.shrink(),
                  ),
                )
              else if (lifter != null)
                Positioned(
                  left: -w * 0.0485,
                  top: y,
                  width: art,
                  height: art,
                  child: pro
                      ? AliveLifter(
                          lifter: lifter,
                          builder: (context, shown, breath) =>
                              breathing(breath, LifterImage(shown, size: art)),
                        )
                      : LifterImage(lifter, size: art),
                ),
              Positioned(
                left: 0,
                right: 0,
                top: fadeFrom,
                height: fadeTo - fadeFrom,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colors.background.withValues(alpha: 0), colors.background.withValues(alpha: 0.96)],
                    ),
                  ),
                ),
              ),
              if (pro) const Positioned.fill(child: ShineBand(strength: 0.22, child: SizedBox.expand())),
            ],
          ),
        ),
      );
    }

    Widget name({
      required String text,
      required String line,
      required Color bar,
      required Color lineColour,
      required bool pro,
      required bool end,
    }) => FadeTransition(
      opacity: names,
      child: Row(
        mainAxisAlignment: end ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!end) ...[_Bar(colour: bar), const SizedBox(width: 9)],
          Flexible(
            child: Column(
              crossAxisAlignment: end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (pro && end) ...[const ProChip(height: 18), const SizedBox(width: 7)],
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colors.text, fontSize: 25, fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (pro && !end) ...[const SizedBox(width: 7), const ProChip(height: 18)],
                  ],
                ),
                Text(
                  line,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: lineColour, fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (end) ...[const SizedBox(width: 9), _Bar(colour: bar)],
        ],
      ),
    );

    String level(int? xp) => xp == null ? '' : ' · ${l.levelShort(localNumber(context, levelOf(xp)))}';

    return ColoredBox(
      color: colors.background,
      child: Stack(
        children: [
          // The opponent, dropping in from the top.
          Positioned.fill(
            child: side(
              shape: (s) => Path()
                ..moveTo(0, top)
                ..lineTo(s.width, top)
                ..lineTo(s.width, split.right)
                ..lineTo(0, split.left)
                ..close(),
              face: _theirs(),
              y: h * 0.0164,
              photoTop: top,
              photoBottom: split.left,
              fadeFrom: h * 0.30,
              fadeTo: split.left + 6,
              pro: themPro,
              from: -h * 0.5,
            ),
          ),
          // This account, rising from the foot.
          Positioned.fill(
            child: side(
              shape: (s) => Path()
                ..moveTo(0, rise.left)
                ..lineTo(s.width, rise.right)
                ..lineTo(s.width, foot)
                ..lineTo(0, foot)
                ..close(),
              face: _mine(me.username),
              y: h * 0.4535,
              photoTop: rise.right,
              photoBottom: foot,
              fadeFrom: h * 0.743,
              fadeTo: foot + 2,
              pro: mePro,
              from: h * 0.5,
            ),
          ),
          // The line between them, once both are in: holo when either is Pro.
          Positioned.fill(
            child: FadeTransition(
              opacity: names,
              child: CustomPaint(
                painter: _Split(
                  from: Offset(0, (split.left + rise.left) / 2 + h * 0.033),
                  to: Offset(w, (split.right + rise.right) / 2 + h * 0.033),
                  holo: anyPro,
                  plain: colors.border,
                ),
              ),
            ),
          ),
          // The live tag.
          Positioned(
            left: 0,
            right: 0,
            top: h * 0.012,
            child: Center(
              child: _LivePill(
                text: switch (widget.kind) {
                  VsKind.live => widget.ranked ? l.vsLiveRanked : l.vsLiveFriendly,
                  VsKind.saved => l.vsSavedRanked,
                  VsKind.rematch => l.vsRematchFriendly,
                },
                live: widget.kind == VsKind.live,
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: split.left - h * 0.105,
            child: name(
              text: widget.opponentName,
              line: '${tierLabel(l, widget.opponentTierIdx, widget.opponentDivIdx)}${level(widget.opponentXp)}',
              bar: colors.rival,
              lineColour: colors.muted,
              pro: themPro,
              end: false,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: foot - h * 0.085,
            child: name(
              text: me.username,
              line: '${tierLabel(l, me.tierIdx, me.divIdx)}${level(me.xp)}',
              bar: mePro ? AppColors.gold : colors.brand,
              lineColour: AppColors.gold,
              pro: mePro,
              end: true,
            ),
          ),
          // Lightning either side of VS, for a Pro: it flashes once, then
          // stays.
          if (anyPro) ...[
            Positioned(left: w * 0.24, top: vsY - h * 0.065, child: _Flash(flash: flash, child: _Bolt(size: w * 0.14))),
            Positioned(right: w * 0.24, top: vsY - h * 0.04, child: _Flash(flash: flash, child: _Bolt(size: w * 0.12))),
          ],
          // VS, exactly between the two pictures, popping in as they meet.
          Positioned(
            left: 0,
            right: 0,
            top: vsY - w * 0.12,
            height: w * 0.24,
            child: Center(
              child: AnimatedBuilder(
                animation: vs,
                builder: (context, child) => Opacity(
                  opacity: (vs.value * 2).clamp(0.0, 1.0),
                  child: Transform.scale(scale: 1.8 - 0.8 * vs.value, child: child),
                ),
                child: Transform.rotate(
                  angle: -0.14,
                  child: _VsWord(size: w * 0.19, gold: anyPro),
                ),
              ),
            ),
          ),
          // Three, two, one.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: h - foot,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _Countdown(size: 54),
                  const SizedBox(height: 6),
                  Text(l.getIntoPosition, style: TextStyle(color: colors.muted, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [child] flashing in once: bright and a little big, then settling.
class _Flash extends StatelessWidget {
  const _Flash({required this.flash, required this.child});

  final Animation<double> flash;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: flash,
    builder: (context, child) {
      final t = flash.value;
      // Up to full in the first fifth, a burst of light at the peak, then
      // the bolt as it stays.
      final shown = (t / 0.2).clamp(0.0, 1.0);
      final burst = t < 0.2 ? t / 0.2 : (1 - (t - 0.2) / 0.5).clamp(0.0, 1.0);
      return Opacity(
        opacity: shown,
        child: Transform.scale(
          scale: 1 + 0.25 * burst,
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFE04A).withValues(alpha: 0.7 * burst),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: child,
          ),
        ),
      );
    },
    child: child,
  );
}

class _PathClip extends CustomClipper<Path> {
  const _PathClip(this.shape);

  final Path Function(Size) shape;

  @override
  Path getClip(Size size) => shape(size);

  @override
  bool shouldReclip(_PathClip old) => true;
}

class _Split extends CustomPainter {
  const _Split({required this.from, required this.to, required this.holo, required this.plain});

  final Offset from;
  final Offset to;
  final bool holo;
  final Color plain;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = holo ? 4 : 2.5
      ..color = plain;
    if (holo) paint.shader = kHoloGradient.createShader(Rect.fromPoints(from, to));
    canvas.drawLine(from, to, paint);
  }

  @override
  bool shouldRepaint(_Split old) =>
      old.from != from || old.to != to || old.holo != holo || old.plain != plain;
}

class _Bar extends StatelessWidget {
  const _Bar({required this.colour});

  final Color colour;

  @override
  Widget build(BuildContext context) => Container(
    width: 4,
    height: 46,
    decoration: BoxDecoration(color: colour, borderRadius: BorderRadius.circular(2)),
  );
}

class _LivePill extends StatelessWidget {
  const _LivePill({required this.text, this.live = true});

  final String text;

  /// Red for somebody on camera now, grey for a set recorded before.
  final bool live;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: context.colors.border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: live ? const Color(0xFFFF4D4D) : context.colors.muted,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.text, fontSize: 12.5, fontWeight: FontWeight.w800, letterSpacing: 0.4),
          ),
        ),
      ],
    ),
  );
}

/// VS, gold for a Pro match, cream otherwise, with a dark edge.
class _VsWord extends StatelessWidget {
  const _VsWord({required this.size, required this.gold});

  final double size;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: size, fontWeight: FontWeight.w900, height: 1);
    return Stack(
      children: [
        Text(
          'VS',
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = size * 0.1
              ..strokeJoin = StrokeJoin.round
              ..color = const Color(0xFF121110),
          ),
        ),
        if (gold)
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFE08A), Color(0xFFD9A94A)],
            ).createShader(rect),
            child: Text('VS', style: style.copyWith(color: Colors.white)),
          )
        else
          Text('VS', style: style.copyWith(color: context.colors.brand)),
      ],
    );
  }
}

/// A lightning bolt with an ink edge.
class _Bolt extends StatelessWidget {
  const _Bolt({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size * 2,
    child: const CustomPaint(painter: _BoltPainter()),
  );
}

class _BoltPainter extends CustomPainter {
  const _BoltPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 36, y = size.height / 80;
    final bolt = Path()
      ..moveTo(14 * x, 0)
      ..lineTo(0, 40 * y)
      ..lineTo(16 * x, 40 * y)
      ..lineTo(4 * x, 80 * y)
      ..lineTo(36 * x, 30 * y)
      ..lineTo(20 * x, 30 * y)
      ..lineTo(30 * x, 0)
      ..close();
    canvas
      ..drawPath(bolt, Paint()..color = const Color(0xFFFFE04A))
      ..drawPath(
        bolt,
        Paint()
          ..color = const Color(0xFF121110)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeJoin = StrokeJoin.round,
      );
  }

  @override
  bool shouldRepaint(_BoltPainter old) => false;
}

/// 3, 2, 1 in a ring that empties over [kVsTime].
class _Countdown extends StatelessWidget {
  const _Countdown({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: kVsTime,
      builder: (context, t, _) => SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: 1 - t,
                strokeWidth: 3,
                color: colors.brand,
                backgroundColor: colors.surfaceRaised,
              ),
            ),
            Text(
              localNumber(context, (3 - (t * 3).floor()).clamp(1, 3)),
              style: TextStyle(color: colors.text, fontSize: size * 0.5, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
