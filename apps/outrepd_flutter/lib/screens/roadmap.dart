import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

/// The tier ladder drawn as a winding road, with a card up top showing the
/// next step. Opened by tapping the badge on the match screen.
class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Road to Legend')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _NextStepCard(profile: profile),
          const SizedBox(height: 22),
          const SectionHeader(title: 'All tiers'),
          _RoadStrip(currentTier: profile.tierIdx, currentDiv: profile.divIdx),
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
    final atTop = profile.tierIdx >= kTiers.length - 1;
    final nextIdx = atTop ? profile.tierIdx : profile.tierIdx + 1;
    final next = kTiers[nextIdx];
    final remaining = (100 - profile.lp).clamp(0, 100);

    return Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  TierBadge(tierIdx: nextIdx, size: 62),
                  const SizedBox(height: 6),
                  Text(
                    next.name,
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
              Icon(Icons.workspace_premium, color: next.color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  atTop
                      ? 'You have unlocked everything'
                      : 'Unlocks at ${next.name}: ${next.reward}',
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

/// Every division of every tier threaded along a snaking path — 45 stops,
/// lit up to the rank you currently hold.
class _RoadStrip extends StatelessWidget {
  const _RoadStrip({required this.currentTier, required this.currentDiv});

  final int currentTier;
  final int currentDiv;

  static const _rowHeight = 96.0;

  /// Flattens tier + division into a single position on the ladder.
  static int stepOf(int tierIdx, int divIdx) =>
      tierIdx * kDivisions.length + divIdx;

  @override
  Widget build(BuildContext context) {
    final total = kTiers.length * kDivisions.length;
    final currentStep = stepOf(currentTier, currentDiv);

    return SizedBox(
      height: _rowHeight * total,
      child: CustomPaint(
        painter: _RoadPainter(
          count: total,
          currentStep: currentStep,
          rowHeight: _rowHeight,
        ),
        child: Column(
          children: [
            // Index 0 of the column is the top of the screen, which is the
            // highest rank — so walk the ladder backwards.
            for (var listIdx = 0; listIdx < total; listIdx++)
              SizedBox(
                height: _rowHeight,
                child: _RoadStop(
                  step: total - 1 - listIdx,
                  listIndex: listIdx,
                  currentStep: currentStep,
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
  static const _badgeCentreOffset = -11.0;

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

  @override
  void paint(Canvas canvas, Size size) {
    // List index 0 is the highest tier, so walk it in reverse for the path.
    final all = [for (var i = 0; i < count; i++) _pointFor(i, size)];

    final track = Paint()
      ..color = AppColors.surfaceRaised
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_pathThrough(all), track);

    // Walked section: from the bottom stop up to where you stand.
    final walkedCount = (currentStep + 1).clamp(1, count);
    final walked = all.sublist(count - walkedCount);
    if (walked.length > 1) {
      final done = Paint()
        ..color = AppColors.brand
        ..strokeWidth = 7
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(_pathThrough(walked), done);
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
  });

  /// Position on the flattened 45-rung ladder.
  final int step;

  /// Row from the top of the strip, which decides the horizontal offset.
  final int listIndex;

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final tierIdx = step ~/ kDivisions.length;
    final divIdx = step % kDivisions.length;
    final tier = kTiers[tierIdx];
    final isCurrent = step == currentStep;
    final reached = step <= currentStep;
    // Every fifth rung opens a new tier, so give it the name and more weight.
    final startsTier = divIdx == 0;
    final size = isCurrent ? 84.0 : (startsTier ? 66.0 : 58.0);

    final badge = reached
        ? TierBadge(tierIdx: tierIdx, size: size)
        : ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Color(0xFF223040),
              BlendMode.srcATop,
            ),
            child: TierBadge(tierIdx: tierIdx, size: size),
          );

    final marker = isCurrent
        ? Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Opacity(
                opacity: 0.6,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(tier.color, BlendMode.srcATop),
                    child: TierBadge(tierIdx: tierIdx, size: size),
                  ),
                ),
              ),
              badge,
            ],
          )
        : badge;

    return LayoutBuilder(
      builder: (context, constraints) {
        final centre = roadFraction(listIndex) * constraints.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: centre - 68,
              top: 0,
              width: 136,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  marker,
                  const SizedBox(height: 2),
                  Text(
                    tierLabel(tierIdx, divIdx),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent
                          ? tier.color
                          : (reached ? Colors.white : AppColors.muted),
                      fontSize: isCurrent ? 13 : 11.5,
                      fontWeight: isCurrent || startsTier
                          ? FontWeight.w700
                          : FontWeight.w500,
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
  final wander = 0.22 * math.sin(index * 1.15) + 0.07 * math.sin(index * 2.7);
  return (0.5 + wander).clamp(0.26, 0.74);
}
