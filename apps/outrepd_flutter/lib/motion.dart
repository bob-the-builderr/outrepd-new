/// The small movements that make an app feel alive rather than correct.
///
/// A number that jumps from 5 to 6 is information. A number that lands is an
/// event — and in an app about effort, every rep should feel like one. None of
/// this changes what the app does; all of it changes what using it is like.
///
/// Kept short and quick throughout. Animation that draws attention to itself
/// is worse than none, and anything a lifter waits for mid-set is a bug.
library;

import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter/services.dart';

import 'settings.dart';

/// Fast enough not to be waited for, slow enough to be seen.
const kQuick = Duration(milliseconds: 180);
const kSettle = Duration(milliseconds: 320);

/// A short tap through the phone, when the lifter has asked for it. Silent on
/// anything without a motor, and never thrown.
void tap({bool heavy = false}) {
  if (!settings.vibration) return;
  try {
    heavy ? HapticFeedback.mediumImpact() : HapticFeedback.selectionClick();
  } on Object {
    // A phone that cannot buzz is not a problem worth reporting.
  }
}

/// A number that swells briefly whenever it changes.
///
/// The count is the whole point of a set, so it is given the one flourish in
/// the app that is allowed to be obvious.
class PopOnChange extends StatefulWidget {
  const PopOnChange({
    super.key,
    required this.value,
    required this.child,
    this.scale = 1.18,
  });

  /// Whatever the child is showing. A change here is what triggers the pop.
  final Object? value;

  final Widget child;
  final double scale;

  @override
  State<PopOnChange> createState() => _PopOnChangeState();
}

class _PopOnChangeState extends State<PopOnChange>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: kQuick,
    reverseDuration: kSettle,
  );

  late final _scale = Tween<double>(begin: 1, end: widget.scale).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeOut,
    ),
  );

  @override
  void didUpdateWidget(PopOnChange old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _controller.forward(from: 0).then((_) {
        if (mounted) _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

/// A bar that fills towards its new value rather than snapping to it.
class GrowingBar extends StatelessWidget {
  const GrowingBar({
    super.key,
    required this.value,
    required this.colour,
    this.background,
    this.height = 8,
    this.radius = 8,
  });

  final double value;
  final Color colour;
  final Color? background;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: TweenAnimationBuilder<double>(
        // Empty the first time it is drawn, so it fills in front of you.
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
        builder: (context, grown, _) => LinearProgressIndicator(
          value: grown,
          minHeight: height,
          backgroundColor: background,
          valueColor: AlwaysStoppedAnimation(colour),
        ),
      ),
    );
  }
}

/// Fades and lifts a widget into place. Used on list rows so a screen assembles
/// itself instead of appearing all at once.
class RiseIn extends StatelessWidget {
  const RiseIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = 14,
  });

  final Widget child;
  final Duration delay;
  final double from;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: kSettle + delay,
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        // The delay is folded into the curve rather than timed separately, so
        // a long list cannot end up holding a pile of pending timers.
        final started =
            ((t * (kSettle + delay).inMilliseconds) - delay.inMilliseconds) /
                kSettle.inMilliseconds;
        final eased = started.clamp(0.0, 1.0);
        return Opacity(
          opacity: eased,
          child: Transform.translate(
            offset: Offset(0, from * (1 - eased)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// A slow breath, for anything that should look lit rather than printed — a
/// live streak, a match about to start.
class Breathe extends StatefulWidget {
  const Breathe({super.key, required this.child, this.scale = 1.06});

  final Widget child;
  final double scale;

  @override
  State<Breathe> createState() => _BreatheState();
}

class _BreatheState extends State<Breathe>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1, end: widget.scale).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: widget.child,
    );
  }
}

/// Screens slide in from the right and fade, rather than the platform default
/// — which on Android is a vertical shove that feels heavier than this app is.
class SlideRoute<T> extends PageRouteBuilder<T> {
  SlideRoute({required this.page})
      : super(
          transitionDuration: kSettle,
          reverseTransitionDuration: kQuick,
          pageBuilder: (_, _, _) => page,
          transitionsBuilder: (context, animation, _, child) {
            final eased =
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: eased,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0.06, 0),
                  end: Offset.zero,
                ).animate(eased),
                child: child,
              ),
            );
          },
        );

  final Widget page;
}

/// Whether the phone asked for less motion. Every entrance below steps aside
/// for it: the content is there at once, which is what that setting is for.
bool reduceMotion(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

/// Whether something may move for ever — a light crossing a card, a ring
/// round a button. Not when the phone asks for less motion, and not under
/// `flutter test`, where a loop that never ends keeps pumpAndSettle waiting
/// for it.
bool loopsAllowed(BuildContext context) =>
    !reduceMotion(context) &&
    (kIsWeb || !Platform.environment.containsKey('FLUTTER_TEST'));

/// The delay for the [index]th row of a list rising in: one after another,
/// quickly, and no later than the ninth — a long list should not make
/// somebody wait to see its bottom.
Duration staggered(int index) =>
    Duration(milliseconds: 55 * (index < 8 ? index : 8));

/// Text that types itself out, a letter at a time, with a cursor while it
/// does. For the one line a screen opens on, not for reading matter.
///
/// The whole text is laid out from the first frame, the unwritten part
/// transparent, so the lines never re-wrap as the letters arrive and what
/// follows it does not jump. The cursor takes no room in the line: as a
/// letter of its own it widened the line it was on, and a centred line slid
/// half a letter sideways and back as it passed through (2026-11-04: "the
/// typing lags strangely"). Screen readers get the whole sentence at once.
class TypeOut extends StatefulWidget {
  const TypeOut(
    this.text, {
    super.key,
    required this.style,
    this.textAlign,
    this.perLetter = const Duration(milliseconds: 38),
    this.delay = Duration.zero,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final Duration perLetter;
  final Duration delay;

  /// How long [text] takes to type, delay included — for timing what comes
  /// in after it.
  static Duration lengthOf(
    String text, {
    Duration perLetter = const Duration(milliseconds: 38),
    Duration delay = Duration.zero,
  }) {
    final typing = perLetter * text.characters.length;
    const most = Duration(milliseconds: 1400);
    return delay + (typing > most ? most : typing);
  }

  @override
  State<TypeOut> createState() => _TypeOutState();
}

class _TypeOutState extends State<TypeOut> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: TypeOut.lengthOf(
        widget.text,
        perLetter: widget.perLetter,
        delay: widget.delay,
      ),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The laid-out text, for where its caret is.
  final _line = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) {
      return Text(widget.text, style: widget.style, textAlign: widget.textAlign);
    }
    final letters = widget.text.characters.toList();
    final total = _controller.duration!.inMilliseconds;
    final wait = widget.delay.inMilliseconds;
    final style = DefaultTextStyle.of(context).style.merge(widget.style);
    final colour = (style.color ?? Colors.white).withValues(alpha: 0.7);
    final bar = MediaQuery.textScalerOf(context).scale(style.fontSize ?? 14) * 1.1;
    // The text is never touched while it types: the same characters, laid
    // out the same way on every frame, the unwritten ones transparent. The
    // cursor is painted over it, at the caret of that very layout. As a
    // character of its own it moved the line (2026-11-04: "the typing lags
    // strangely").
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final elapsed = _controller.value * total - wait;
        final typing = total - wait;
        final shown = elapsed <= 0
            ? 0
            : (letters.length * (elapsed / (typing <= 0 ? 1 : typing)))
                  .ceil()
                  .clamp(0, letters.length);
        final done = shown >= letters.length;
        final written = letters.take(shown).join();
        return Semantics(
          label: widget.text,
          excludeSemantics: true,
          child: CustomPaint(
            foregroundPainter: done
                ? null
                : _Caret(line: _line, offset: written.length, colour: colour, height: bar),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: written),
                  TextSpan(
                    text: letters.skip(shown).join(),
                    style: const TextStyle(color: Colors.transparent),
                  ),
                ],
              ),
              key: _line,
              style: widget.style,
              textAlign: widget.textAlign,
            ),
          ),
        );
      },
    );
  }
}

/// The typing cursor, painted at a caret of the laid-out line, so it takes
/// no room in it.
class _Caret extends CustomPainter {
  _Caret({
    required this.line,
    required this.offset,
    required this.colour,
    required this.height,
  });

  final GlobalKey line;
  final int offset;
  final Color colour;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final paragraph = line.currentContext?.findRenderObject();
    if (paragraph is! RenderParagraph || !paragraph.hasSize) return;
    final position = TextPosition(offset: offset);
    final at = paragraph.getOffsetForCaret(position, Rect.zero);
    final full = paragraph.getFullHeightForCaret(position);
    canvas.drawRect(
      Rect.fromLTWH(at.dx - 1, at.dy + (full - height) / 2, 2, height),
      Paint()..color = colour,
    );
  }

  @override
  bool shouldRepaint(_Caret old) =>
      old.offset != offset || old.colour != colour || old.height != height;
}

/// A number that counts up to its value when it first appears, and from the
/// old value to the new one when it changes.
class CountUp extends StatelessWidget {
  const CountUp({
    super.key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 900),
  });

  final int value;

  /// Draws the number as it is part-way there.
  final Widget Function(BuildContext context, int shown) builder;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return builder(context, value);
    return TweenAnimationBuilder<double>(
      // From nothing the first time, then from wherever it was.
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, shown, _) => builder(context, shown.round()),
    );
  }
}

/// Presses in a little under the finger, and springs back. For buttons that
/// start something, so the press is felt as well as seen.
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.scale = 0.96});

  final Widget child;
  final double scale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  void _set(bool down) {
    if (_down != down) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    // A listener, not a gesture detector: it watches the finger without
    // taking the tap away from the button underneath.
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Grows a widget in from a little smaller, with a slight overshoot — for
/// the one thing a screen is about, the first time it is shown.
class PopIn extends StatelessWidget {
  const PopIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = 0.82,
  });

  final Widget child;
  final Duration delay;
  final double from;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return child;
    const length = Duration(milliseconds: 520);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: length + delay,
      builder: (context, t, child) {
        final started =
            ((t * (length + delay).inMilliseconds) - delay.inMilliseconds) /
            length.inMilliseconds;
        final linear = started.clamp(0.0, 1.0);
        final grown = Curves.easeOutBack.transform(linear);
        return Opacity(
          opacity: Curves.easeOut.transform(linear),
          child: Transform.scale(scale: from + (1 - from) * grown, child: child),
        );
      },
      child: child,
    );
  }
}
