/// The small movements that make an app feel alive rather than correct.
///
/// A number that jumps from 5 to 6 is information. A number that lands is an
/// event — and in an app about effort, every rep should feel like one. None of
/// this changes what the app does; all of it changes what using it is like.
///
/// Kept short and quick throughout. Animation that draws attention to itself
/// is worse than none, and anything a lifter waits for mid-set is a bug.
library;

import 'package:flutter/material.dart';
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
        tween: Tween(end: value.clamp(0.0, 1.0)),
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
