/// What Pro looks like wherever it shows: the PRO chip, the holo edge, the
/// shine that runs across them now and then, and the two ways in that are
/// always there — the button beside the bell on the Match tab and the card
/// at the top of Settings (the user's picks, 2026-11-01).
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../lifter/catalog.dart';
import '../subscription.dart';
import '../theme.dart';
import 'paywall.dart';

const kProPurple = Color(0xFF8B5CF6);
const kProPink = Color(0xFFEC4899);

/// The holo foil: the colours a Pro edge runs through.
const kHolo = [
  Color(0xFF7AD7FF),
  Color(0xFFC9A8FF),
  Color(0xFFFF9FD6),
  Color(0xFFFFE59F),
  Color(0xFF9FFFD8),
  Color(0xFF7AD7FF),
];

const kHoloGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: kHolo,
);

/// "PRO", white on purple to pink.
class ProChip extends StatelessWidget {
  const ProChip({super.key, this.height = 18});

  final double height;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    padding: EdgeInsets.symmetric(horizontal: height * 0.38),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [kProPurple, kProPink]),
      borderRadius: BorderRadius.circular(height * 0.3),
    ),
    child: Text(
      'PRO',
      style: TextStyle(
        color: Colors.white,
        fontSize: height * 0.62,
        fontWeight: FontWeight.w800,
        height: 1,
      ),
    ),
  );
}

/// [child] with a soft band of light run across it every few seconds. Still
/// where the phone asks for less motion.
class ShineBand extends StatefulWidget {
  const ShineBand({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.strength = 0.38,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double strength;

  @override
  State<ShineBand> createState() => _ShineBandState();
}

class _ShineBandState extends State<ShineBand>
    with SingleTickerProviderStateMixin {
  late final _run = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  );
  Timer? _rest;

  @override
  void initState() {
    super.initState();
    // A run, then a rest: light that passes now and then, never a loop
    // that keeps the screen busy.
    _run.addStatusListener((status) {
      if (status != AnimationStatus.completed) return;
      _rest = Timer(const Duration(milliseconds: 3200), _start);
    });
    _rest = Timer(const Duration(milliseconds: 700), _start);
  }

  void _start() {
    if (!mounted) return;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return;
    _run.forward(from: 0);
  }

  @override
  void dispose() {
    _rest?.cancel();
    _run.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _run,
                builder: (context, _) {
                  final t = _run.value;
                  if (t == 0 || t == 1) return const SizedBox.shrink();
                  final at = -0.3 + t * 1.6;
                  final a = widget.strength;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: a),
                          Colors.white.withValues(alpha: 0),
                        ],
                        stops: [
                          (at - 0.14).clamp(0.0, 1.0),
                          at.clamp(0.0, 1.0),
                          (at + 0.14).clamp(0.0, 1.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [child] inside a holo edge [width] wide.
class HoloEdge extends StatelessWidget {
  const HoloEdge({
    super.key,
    required this.child,
    this.radius = 20,
    this.width = 4,
  });

  final Widget child;
  final double radius;
  final double width;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: kHoloGradient,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: Padding(
      padding: EdgeInsets.all(width),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - width),
        child: child,
      ),
    ),
  );
}

/// [lifter] dressed the way the Pro screen shows it: glowing eyes, the satin
/// bomber, the iced chain, the neon city behind. The face and hair stay the
/// player's own.
Lifter proLook(Lifter lifter) {
  int at(List<LifterPart> list, String id) =>
      list.indexWhere((p) => p.id == id);
  return lifter.copyWith(
    eyes: at(kEyes, 'glow'),
    top: at(kTops, 'satin_bomber'),
    gear: at(kGear, 'iced_chain'),
    pattern: at(kPatterns, 'neon_city'),
    background: 7,
  );
}

/// Whether to offer Pro at all: a build with a store, to an account that
/// does not have it.
bool get offersPro {
  final s = Subscription.instance;
  return s.enabled && !s.active;
}

/// The way into Pro beside the bell: a holo-edged pill with a crown, the
/// bell's height. Gone once the account is Pro.
class ProPill extends StatelessWidget {
  const ProPill({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Subscription.instance,
      builder: (context, _) {
        if (!offersPro) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: Semantics(
            button: true,
            label: 'OUTREPD Pro',
            child: GestureDetector(
              key: const Key('proPill'),
              onTap: () => openPro(context),
              child: HoloEdge(
                radius: 24,
                width: 2,
                child: ShineBand(
                  strength: 0.45,
                  child: Container(
                    width: 60,
                    height: 44,
                    color: const Color(0xFF1B1430),
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium, size: 17, color: Color(0xFFF2C14E)),
                        Text(
                          'PRO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Pro at the top of Settings: what it is, and the way in. Says thanks
/// instead once the account is Pro.
class ProSettingsCard extends StatelessWidget {
  const ProSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    return ListenableBuilder(
      listenable: Subscription.instance,
      builder: (context, _) {
        final s = Subscription.instance;
        if (!s.enabled) return const SizedBox.shrink();
        final pro = s.active;
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: HoloEdge(
            radius: 18,
            width: 2,
            child: ShineBand(
              child: Material(
                color: const Color(0xFF1B1430),
                child: InkWell(
                  key: const Key('proSettings'),
                  onTap: pro ? null : () => openPro(context),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                    child: Row(
                      children: [
                        const Icon(Icons.workspace_premium, size: 30, color: Color(0xFFF2C14E)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'OUTREPD',
                                    style: TextStyle(
                                      color: colors.text,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const ProChip(height: 20),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                pro ? l.proSettingsActive : l.proSettingsBody,
                                style: TextStyle(color: colors.muted, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        if (!pro) Icon(Icons.chevron_right, color: colors.muted),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
