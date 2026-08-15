import 'dart:math' as math;
import 'dart:ui' show ImageFilter, PathMetric;

import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

/// The tier ladder drawn as a winding road, with a card up top showing the
/// next step. Opened by tapping the badge on the match screen.
class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key, required this.profile});

  final Profile profile;

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  /// Built on first paint so the opening position is set before anything is
  /// drawn. Jumping after the first frame was unreliable — the list has not
  /// measured its full extent yet, so the jump clamped back to the top.
  ScrollController? _controller;

  /// Height of the section header above the strip. The next-step card is
  /// pinned outside the scroll view, so it no longer counts here. Only used
  /// to aim the opening scroll, so an estimate is fine.
  static const _headerHeight = 44.0;

  /// Roughly how much of the screen the app bar and the pinned card eat, so
  /// the remainder is the list's own viewport.
  static const _chromeHeight = 300.0;

  /// Opens on the rank you hold. Landing at Legend and making people scroll
  /// most of the ladder to find themselves is the wrong first impression.
  double _openingOffset(BuildContext context) {
    final total = kTiers.length * kDivisions.length;
    final step =
        _RoadStrip.stepOf(widget.profile.tierIdx, widget.profile.divIdx);
    final rowsFromTop = total - 1 - step;
    final listViewport =
        MediaQuery.of(context).size.height - _chromeHeight;
    final centreOfRow =
        _headerHeight + rowsFromTop * _RoadStrip.rowHeight + _RoadStrip.rowHeight / 2;
    return math.max(0, centreOfRow - listViewport / 2);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller ??= ScrollController(
      initialScrollOffset: _openingOffset(context),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Road to Legend'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const _GymBackdrop(),
          Column(
            children: [
              // The next step stays put while the ladder scrolls under it —
              // it is the one thing you always want in view.
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                  16,
                  14,
                ),
                child: _NextStepCard(profile: widget.profile),
              ),
              Expanded(
                child: ListView(
                  controller: _controller,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                  children: [
                    const SectionHeader(title: 'All tiers'),
                    _RoadStrip(
                      currentTier: widget.profile.tierIdx,
                      currentDiv: widget.profile.divIdx,
                      lp: widget.profile.lp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Gym artwork behind the road. It is pinned to the viewport rather than the
/// scrolling strip, so it stays put while 45 rungs slide past it instead of
/// being stretched down the whole ladder.
class _GymBackdrop extends StatelessWidget {
  const _GymBackdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // A busy pattern carrying its own words, so it is held well back —
          // enough to feel like texture, not enough to argue with the rank
          // labels sitting on top of it.
          Image.asset(
            'assets/images/roadmap-bg.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            opacity: const AlwaysStoppedAnimation(0.85),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.18),
                  AppColors.background.withValues(alpha: 0.42),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Current tier, next tier, the LP between them, and what the next one unlocks.
class _NextStepCard extends StatelessWidget {
  const _NextStepCard({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    // The next step is the next DIVISION, not the next tier — from Gold III
    // you climb to Gold II, and only reach Platinum after Gold I.
    final totalSteps = kTiers.length * kDivisions.length;
    final step = _RoadStrip.stepOf(profile.tierIdx, profile.divIdx);
    final atTop = step >= totalSteps - 1;
    final nextStep = atTop ? step : step + 1;
    final nextTierIdx = nextStep ~/ kDivisions.length;
    final nextDivIdx = nextStep % kDivisions.length;
    final next = kTiers[nextTierIdx];

    // The reward belongs to the tier, so point at the next tier you unlock.
    final rewardTierIdx =
        (profile.tierIdx + 1).clamp(0, kTiers.length - 1);
    final rewardTier = kTiers[rewardTierIdx];
    final atTopTier = profile.tierIdx >= kTiers.length - 1;

    final remaining = (100 - profile.lp).clamp(0, 100);

    return Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              Opacity(
                opacity: 0.55,
                child: Column(
                  children: [
                    TierBadge(tierIdx: profile.tierIdx, size: 46),
                    const SizedBox(height: 6),
                    Text(
                      tierLabel(profile.tierIdx, profile.divIdx),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (profile.lp / 100).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: AppColors.surfaceRaised,
                          valueColor:
                              const AlwaysStoppedAnimation(AppColors.brand),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        atTop ? 'Top tier' : '$remaining LP',
                        style: const TextStyle(
                          color: AppColors.brand,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  TierBadge(tierIdx: nextTierIdx, size: 62),
                  const SizedBox(height: 6),
                  Text(
                    tierLabel(nextTierIdx, nextDivIdx),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.surfaceRaised, height: 1),
          ),
          Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: atTopTier ? next.color : rewardTier.color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  atTopTier
                      ? 'You have unlocked everything'
                      : 'Unlocks at ${rewardTier.name}: ${rewardTier.reward}',
                  style: const TextStyle(color: Colors.white, fontSize: 12.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Every division of every tier threaded along a snaking path — 45 rungs,
/// lit up to the rank you currently hold.
class _RoadStrip extends StatelessWidget {
  const _RoadStrip({
    required this.currentTier,
    required this.currentDiv,
    required this.lp,
  });

  final int currentTier;
  final int currentDiv;
  final int lp;

  static const rowHeight = 150.0;

  /// Flattens tier + division into a single position on the ladder.
  static int stepOf(int tierIdx, int divIdx) =>
      tierIdx * kDivisions.length + divIdx;

  @override
  Widget build(BuildContext context) {
    final total = kTiers.length * kDivisions.length;
    final currentStep = stepOf(currentTier, currentDiv);

    return SizedBox(
      height: rowHeight * total,
      child: CustomPaint(
        painter: _RoadPainter(
          count: total,
          currentStep: currentStep,
          rowHeight: rowHeight,
        ),
        child: Column(
          children: [
            // Index 0 of the column is the top of the screen, which is the
            // highest rank — so walk the ladder backwards.
            for (var listIdx = 0; listIdx < total; listIdx++)
              SizedBox(
                height: rowHeight,
                child: _RoadStop(
                  step: total - 1 - listIdx,
                  listIndex: listIdx,
                  currentStep: currentStep,
                  lp: lp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  _RoadPainter({
    required this.count,
    required this.currentStep,
    required this.rowHeight,
  });

  final int count;
  final int currentStep;
  final double rowHeight;

  /// Centre of the badge in a row. The label sits below it, which lifts the
  /// badge above the row's midpoint — the path has to follow.
  static const _badgeCentreOffset = -18.0;

  Offset _pointFor(int listIndex, Size size) {
    final y = rowHeight * listIndex + rowHeight / 2 + _badgeCentreOffset;
    return Offset(roadFraction(listIndex) * size.width, y);
  }

  Path _pathThrough(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final midY = (prev.dy + curr.dy) / 2;
      path.cubicTo(prev.dx, midY, curr.dx, midY, curr.dx, curr.dy);
    }
    return path;
  }

  /// Rebuilds [source] as a series of dashes.
  Path _dashed(Path source, {double dash = 13, double gap = 11}) {
    final out = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      var pos = 0.0;
      while (pos < metric.length) {
        final end = math.min(pos + dash, metric.length);
        out.addPath(metric.extractPath(pos, end), Offset.zero);
        pos = end + gap;
      }
    }
    return out;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final all = [for (var i = 0; i < count; i++) _pointFor(i, size)];

    final walkedCount = (currentStep + 1).clamp(1, count);
    final aheadPoints = all.sublist(0, count - walkedCount + 1);
    final walkedPoints = all.sublist(count - walkedCount);

    // The stretch you have not walked is dashed, so the road reads as
    // "done" versus "still to come" at a glance.
    if (aheadPoints.length > 1) {
      final ahead = Paint()
        ..color = AppColors.surfaceRaised
        ..strokeWidth = 7
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(_dashed(_pathThrough(aheadPoints)), ahead);
    }

    if (walkedPoints.length > 1) {
      final walkedPath = _pathThrough(walkedPoints);
      // A soft under-glow makes the travelled road feel lit rather than drawn.
      canvas.drawPath(
        walkedPath,
        Paint()
          ..color = AppColors.brand.withValues(alpha: 0.28)
          ..strokeWidth = 16
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
      );
      canvas.drawPath(
        walkedPath,
        Paint()
          ..color = AppColors.brand
          ..strokeWidth = 7
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RoadPainter old) =>
      old.currentStep != currentStep || old.count != count;
}

/// One rung of the ladder: a single division of a single tier.
class _RoadStop extends StatelessWidget {
  const _RoadStop({
    required this.step,
    required this.listIndex,
    required this.currentStep,
    required this.lp,
  });

  /// Position on the flattened 45-rung ladder.
  final int step;

  /// Row from the top of the strip, which decides the horizontal offset.
  final int listIndex;

  final int currentStep;
  final int lp;

  @override
  Widget build(BuildContext context) {
    final tierIdx = step ~/ kDivisions.length;
    final divIdx = step % kDivisions.length;
    final tier = kTiers[tierIdx];
    final isCurrent = step == currentStep;
    final reached = step <= currentStep;
    // Every fifth rung opens a new tier, so give it the reward and more weight.
    final startsTier = divIdx == 0;
    final size = isCurrent ? 138.0 : (startsTier ? 118.0 : 106.0);

    final art = reached
        ? TierBadge(tierIdx: tierIdx, size: size)
        // Locked rungs are desaturated rather than blacked out — you should be
        // able to make out the crest you are working towards, especially now
        // there is artwork behind it.
        : ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.26, 0.30, 0.10, 0, 6,
              0.26, 0.30, 0.10, 0, 10,
              0.26, 0.30, 0.10, 0, 18,
              0, 0, 0, 0.75, 0,
            ]),
            child: TierBadge(tierIdx: tierIdx, size: size),
          );

    // A dark disc under the crest so it sits ON the road instead of floating
    // over it, with the road line disappearing behind the badge.
    final socket = Container(
      width: size * 0.82,
      height: size * 0.82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.background,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );

    final marker = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        socket,
        if (isCurrent)
          Opacity(
            opacity: 0.6,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(tier.color, BlendMode.srcATop),
                child: TierBadge(tierIdx: tierIdx, size: size),
              ),
            ),
          ),
        art,
        // Progress towards the next rung, ringed around where you stand.
        if (isCurrent)
          SizedBox(
            width: size * 1.04,
            height: size * 1.04,
            child: CircularProgressIndicator(
              value: (lp / 100).clamp(0.0, 1.0),
              strokeWidth: 4,
              backgroundColor: AppColors.surfaceRaised.withValues(alpha: 0.7),
              valueColor: const AlwaysStoppedAnimation(AppColors.brand),
            ),
          ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final centre = roadFraction(listIndex) * constraints.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: centre - 84,
              top: 0,
              width: 168,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  marker,
                  const SizedBox(height: 1),
                  Text(
                    tierLabel(tierIdx, divIdx),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent
                          ? tier.color
                          : (reached ? Colors.white : AppColors.muted),
                      fontSize: isCurrent ? 13.5 : 12,
                      fontWeight: isCurrent || startsTier
                          ? FontWeight.w800
                          : FontWeight.w500,
                    ),
                  ),
                  // Treasure along the road: what this tier hands you.
                  if (startsTier)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: tier.color
                              .withValues(alpha: reached ? 0.18 : 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tier.reward,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: reached
                                ? tier.color
                                : AppColors.muted.withValues(alpha: 0.8),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Horizontal position of a stop as a fraction of the strip's width.
///
/// Two out-of-phase sine waves give the road an unforced wander instead of a
/// mechanical left-right zigzag, and being a pure function of the index keeps
/// the shape identical between the painter and the badges laid over it.
double roadFraction(int index) {
  // Amplitude is deliberately modest: the badges are large, so a wide swing
  // would push neighbouring stops into each other.
  final wander = 0.16 * math.sin(index * 1.15) + 0.05 * math.sin(index * 2.7);
  return (0.5 + wander).clamp(0.31, 0.69);
}
