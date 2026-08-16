import 'dart:async';

import 'package:flutter/material.dart';

import 'theme.dart';

/// Reveals text one character at a time, then calls [onComplete].
class TypewriterText extends StatefulWidget {
  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.onComplete,
    this.speed = const Duration(milliseconds: 32),
  });

  final String text;
  final TextStyle? style;
  final VoidCallback? onComplete;
  final Duration speed;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  Timer? _timer;
  int _shown = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(TypewriterText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      _timer?.cancel();
      _shown = 0;
      _start();
    }
  }

  void _start() {
    _timer = Timer.periodic(widget.speed, (t) {
      if (!mounted) return t.cancel();
      if (_shown >= widget.text.length) {
        t.cancel();
        widget.onComplete?.call();
        return;
      }
      setState(() => _shown++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text.substring(0, _shown),
      textAlign: TextAlign.center,
      style: widget.style,
    );
  }
}

/// Big centred question heading used at the top of most steps.
class StepHeading extends StatelessWidget {
  const StepHeading({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.colors.text,
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Full-width tappable answer used by the questionnaire steps.
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: selected
              ? context.colors.brand.withValues(alpha: 0.12)
              : const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? context.colors.brand : const Color(0xFF444444),
            width: 2.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? context.colors.text : const Color(0xFFDDDDDD),
            fontSize: 16,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Horizontal ruler for picking a number, with snapping and a centre marker.
class RulerPicker extends StatefulWidget {
  const RulerPicker({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.unitLabel = '',
  });

  final int min;
  final int max;
  final int value;
  final ValueChanged<int> onChanged;
  final String unitLabel;

  @override
  State<RulerPicker> createState() => _RulerPickerState();
}

class _RulerPickerState extends State<RulerPicker> {
  static const _tick = 12.0;
  late final ScrollController _controller = ScrollController(
    initialScrollOffset: (widget.value - widget.min) * _tick,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll(double padding) {
    final raw = (_controller.offset / _tick).round() + widget.min;
    final clamped = raw.clamp(widget.min, widget.max);
    if (clamped != widget.value) widget.onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.max - widget.min + 1;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${widget.value}',
              style: TextStyle(
                color: context.colors.text,
                fontSize: 56,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (widget.unitLabel.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                widget.unitLabel,
                style: TextStyle(
                  color: context.colors.brand,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 80,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final sidePad = constraints.maxWidth / 2;
              return Stack(
                alignment: Alignment.center,
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (n) {
                      if (n is ScrollUpdateNotification) _onScroll(sidePad);
                      return false;
                    },
                    child: ListView.builder(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: sidePad),
                      itemExtent: _tick,
                      itemCount: count,
                      itemBuilder: (context, i) {
                        final n = widget.min + i;
                        final major = n % 10 == 0;
                        final mid = n % 5 == 0;
                        return Center(
                          child: Container(
                            width: 2,
                            height: major ? 40 : (mid ? 26 : 16),
                            color: major
                                ? context.colors.text.withValues(alpha: 0.7)
                                : const Color(0xFF3A4552),
                          ),
                        );
                      },
                    ),
                  ),
                  IgnorePointer(
                    child: Container(
                      width: 3,
                      height: 52,
                      decoration: BoxDecoration(
                        color: context.colors.brand,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Two-way unit switch (kg/lb, cm/ft).
class UnitToggle extends StatelessWidget {
  const UnitToggle({
    super.key,
    required this.left,
    required this.right,
    required this.leftSelected,
    required this.onChanged,
  });

  final String left;
  final String right;
  final bool leftSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget seg(String label, bool active, VoidCallback onTap) => Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? context.colors.brand : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: active ? context.colors.text : context.colors.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );

    return Container(
      width: 180,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.surfaceRaised),
      ),
      child: Row(
        children: [
          seg(left, leftSelected, () => onChanged(true)),
          seg(right, !leftSelected, () => onChanged(false)),
        ],
      ),
    );
  }
}

/// Progress bar + Continue button pinned to the bottom of the flow.
class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.canProceed,
    required this.onNext,
    this.label = 'Continue',
    this.showProgress = true,
  });

  final int step;
  final int totalSteps;
  final bool canProceed;
  final VoidCallback onNext;
  final String label;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showProgress) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (step + 1) / totalSteps,
                minHeight: 6,
                backgroundColor: context.colors.surfaceRaised,
                valueColor: AlwaysStoppedAnimation(context.colors.brand),
              ),
            ),
            const SizedBox(height: 16),
          ],
          FilledButton(
            onPressed: canProceed ? onNext : null,
            style: FilledButton.styleFrom(
              disabledBackgroundColor: context.colors.surfaceRaised,
              disabledForegroundColor: context.colors.muted,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
