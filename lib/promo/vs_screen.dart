/// The app's VS screen before the round (lib/screens/vs_screen.dart), with
/// both sides as chosen in the setup: the two big, face to face, the opponent
/// above, you below, split by a slanted line, VS between the two pictures.
/// It comes in as one move: the opponent's half drops from the top, yours
/// rises from the foot, VS pops between them. A side with a photo shows the
/// photo, filling its half; one without, the lifter its name gives. No Pro
/// look here: it would bring the whole Pro screen with it.
library;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../lifter/catalog.dart';
import '../lifter/lifter_view.dart';
import '../theme.dart';
import '../widgets.dart';
import '../xp.dart';

/// How long the VS screen stays: three seconds, counted down at its foot.
const kVsTime = Duration(seconds: 3);

/// What a side shows: a lifter to draw, or a photo.
typedef _Face = ({Lifter? lifter, ImageProvider? photo});

class PromoVsScreen extends StatefulWidget {
  const PromoVsScreen({
    super.key,
    required this.myName,
    required this.myTierIdx,
    required this.myDivIdx,
    required this.myXp,
    required this.opponentName,
    required this.opponentTierIdx,
    required this.opponentDivIdx,
    required this.opponentXp,
    this.myPhoto,
    this.opponentPhoto,
  });

  final String myName;
  final int myTierIdx;
  final int myDivIdx;
  final int myXp;
  final ImageProvider? myPhoto;

  final String opponentName;
  final int opponentTierIdx;
  final int opponentDivIdx;
  final int opponentXp;
  final ImageProvider? opponentPhoto;

  @override
  State<PromoVsScreen> createState() => _VsScreenState();
}

class _VsScreenState extends State<PromoVsScreen> with SingleTickerProviderStateMixin {
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
    _in.dispose();
    super.dispose();
  }

  /// A side: the photo chosen for it, or the lifter its name gives.
  _Face _face(String name, ImageProvider? photo) => photo == null
      ? (lifter: lifterFor(name), photo: null)
      : (lifter: null, photo: photo);

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: _layout);

  Widget _layout(BuildContext context, BoxConstraints box) {
    final l = L.of(context);
    final colors = context.colors;
    final w = box.maxWidth, h = box.maxHeight;

    // The design's measures, as shares of the screen (drawn at 824 × 1830).
    final top = h * 0.057;
    final split = (left: h * 0.486, right: h * 0.421); // the opponent's foot
    final rise = (left: h * 0.552, right: h * 0.486); // this account's head
    final foot = h * 0.885;
    final art = w * 1.097;
    final vsY = (split.left + split.right + rise.left + rise.right) / 4;

    final halves = _halves, vs = _vs, names = _names;

    Widget side({
      required Path Function(Size) shape,
      required _Face face,
      required double y,
      required double photoTop,
      required double photoBottom,
      required double fadeFrom,
      required double fadeTo,
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
                  child: LifterImage(lifter, size: art),
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
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colors.text, fontSize: 25, fontWeight: FontWeight.w800),
                      ),
                    ),
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
              face: _face(widget.opponentName, widget.opponentPhoto),
              y: h * 0.0164,
              photoTop: top,
              photoBottom: split.left,
              fadeFrom: h * 0.30,
              fadeTo: split.left + 6,
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
              face: _face(widget.myName, widget.myPhoto),
              y: h * 0.4535,
              photoTop: rise.right,
              photoBottom: foot,
              fadeFrom: h * 0.743,
              fadeTo: foot + 2,
              from: h * 0.5,
            ),
          ),
          // The line between them, once both are in.
          Positioned.fill(
            child: FadeTransition(
              opacity: names,
              child: CustomPaint(
                painter: _Split(
                  from: Offset(0, (split.left + rise.left) / 2 + h * 0.033),
                  to: Offset(w, (split.right + rise.right) / 2 + h * 0.033),
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
              child: _LivePill(text: l.vsLiveRanked, live: true),
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
              end: false,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: foot - h * 0.085,
            child: name(
              text: widget.myName,
              line: '${tierLabel(l, widget.myTierIdx, widget.myDivIdx)}${level(widget.myXp)}',
              bar: colors.brand,
              lineColour: AppColors.gold,
              end: true,
            ),
          ),
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
                  child: _VsWord(size: w * 0.19, gold: false),
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

class _PathClip extends CustomClipper<Path> {
  const _PathClip(this.shape);

  final Path Function(Size) shape;

  @override
  Path getClip(Size size) => shape(size);

  @override
  bool shouldReclip(_PathClip old) => true;
}

class _Split extends CustomPainter {
  const _Split({required this.from, required this.to, required this.plain});

  final Offset from;
  final Offset to;
  final Color plain;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      from,
      to,
      Paint()
        ..strokeWidth = 2.5
        ..color = plain,
    );
  }

  @override
  bool shouldRepaint(_Split old) =>
      old.from != from || old.to != to || old.plain != plain;
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

/// VS, cream with a dark edge.
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
