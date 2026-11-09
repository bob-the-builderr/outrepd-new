/// What a rewarded video gives, on screen (the user's pick, 2026-11-09,
/// A + B + C; design/mockups/2026-11-09/rewarded_*): the match's XP again on
/// the result screen, a streak brought back from the home screen once a
/// week, and a Pro part worn for a day from the lifter maker.
///
/// Each offer shows only while a video is loaded, or for Pro, who gets the
/// reward with no video (Ads.rewardOffered). None touches the rank, the
/// record or the week's points.
library;

import 'package:flutter/material.dart';

import '../ads.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../l10n/app_localizations.dart';
import '../lifter/catalog.dart';
import '../lifter/lifter_view.dart';
import '../rewards.dart';
import '../theme.dart';
import '../widgets.dart';
import '../xp.dart';
import 'level.dart';
import 'pro_parts.dart';

/// The gold button that plays a rewarded video: the play mark, and what
/// the video gives.
class RewardButton extends StatelessWidget {
  const RewardButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool busy;

  /// The whole width, as on the cards; otherwise as wide as its words.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    const gold = AppColors.gold;
    final button = OutlinedButton.icon(
      onPressed: busy ? null : onPressed,
      icon: busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: gold),
            )
          : const Icon(Icons.play_arrow_rounded, color: gold, size: 22),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: gold, fontWeight: FontWeight.w700),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: expand ? const Size.fromHeight(50) : const Size(0, 46),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        backgroundColor: gold.withValues(alpha: 0.10),
        side: const BorderSide(color: gold, width: 1.5),
        shape: const StadiumBorder(),
      ),
    );
    return button;
  }
}

void _say(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );

// ─────────────────────────────── A: XP twice ──────────────────────────────────

/// The result screen's XP card with "Double it" (pick A): a short video, the
/// match's XP paid again by the server, and no ad as the match is left.
/// The plain card while no video is loaded and nothing was doubled.
class XpDoubleCard extends StatefulWidget {
  const XpDoubleCard({super.key, required this.gain, required this.duelId});

  final XpGain gain;

  /// The duel whose experience is paid again (rewarded.sql, double_duel_xp).
  final String duelId;

  @override
  State<XpDoubleCard> createState() => _XpDoubleCardState();
}

class _XpDoubleCardState extends State<XpDoubleCard> {
  bool _busy = false;

  /// What the server added, once it has.
  int? _added;

  Future<void> _double() async {
    if (_busy || _added != null) return;
    setState(() => _busy = true);
    final l = L.of(context);
    final watched = await Ads.instance.watchForReward(afterMatch: true);
    if (!mounted) return;
    if (!watched) {
      setState(() => _busy = false);
      _say(context, l.rewardNotEarned);
      return;
    }
    try {
      final added = await backend.doubleDuelXp(widget.duelId);
      await Career.instance.addRewardXp(added);
      if (!mounted) return;
      setState(() {
        _busy = false;
        _added = added;
      });
    } on Object catch (error) {
      debugPrint('Could not double the XP: $error');
      if (!mounted) return;
      setState(() => _busy = false);
      _say(context, l.needsServer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Ads.instance,
      builder: (context, _) {
        final added = _added;
        if (added == null && !_busy && !Ads.instance.rewardOffered) {
          return XpGainCard(gain: widget.gain);
        }
        return _card(context, added);
      },
    );
  }

  Widget _card(BuildContext context, int? added) {
    final l = L.of(context);
    final gain = widget.gain;
    final total = gain.total + (added ?? 0);
    final now = xpLevel(gain.after + (added ?? 0));
    const gold = AppColors.gold;
    return Container(
      key: const Key('xpDouble'),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border, width: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.levelNumber(localNumber(context, now.level)),
                  style: TextStyle(color: context.colors.text, fontSize: 15),
                ),
              ),
              Text(
                l.xpOf(
                  localNumber(context, now.into),
                  localNumber(context, now.span),
                ),
                style: TextStyle(color: context.colors.muted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 11),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: now.progress,
              minHeight: 8,
              color: gold,
              backgroundColor: context.colors.surfaceRaised,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                l.xpGained(localNumber(context, total)),
                style: const TextStyle(
                  color: gold,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 12),
              if (added == null)
                Expanded(
                  child: RewardButton(
                    key: const Key('doubleXp'),
                    label: l.xpDoubleIt,
                    busy: _busy,
                    onPressed: _double,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    l.xpDoubled.toUpperCase(),
                    style: const TextStyle(
                      color: gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            added != null
                ? l.xpToLevel(
                    localNumber(context, now.toNext),
                    localNumber(context, now.level + 1),
                  )
                : Ads.instance.rewardNeedsVideo
                ? l.xpDoubleNote
                : '',
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── B: the streak back ───────────────────────────

/// The home card when a streak has just ended (pick B): bring it back with
/// a short video, once a week. Nothing while there is nothing to bring back
/// or no video to bring it back with.
class StreakBackCard extends StatefulWidget {
  const StreakBackCard({super.key});

  /// Whether the card shows now.
  static bool get shown =>
      rewards.streakRestorable && Ads.instance.rewardOffered;

  @override
  State<StreakBackCard> createState() => _StreakBackCardState();
}

class _StreakBackCardState extends State<StreakBackCard> {
  bool _busy = false;

  Future<void> _bringBack() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l = L.of(context);
    final watched = await Ads.instance.watchForReward();
    if (!mounted) return;
    if (watched) {
      await rewards.restoreStreak();
      Career.instance.takeStreak();
    } else {
      _say(context, l.rewardNotEarned);
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final rival = context.colors.rival;
    final days = localNumber(context, rewards.streak);
    return Container(
      key: const Key('streakBack'),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: rival, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rival.withValues(alpha: 0.14),
                ),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  color: rival,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.streakEnded(days),
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Ads.instance.rewardNeedsVideo
                          ? l.streakBringBack
                          : l.streakBringBackPro,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          RewardButton(
            key: const Key('keepStreak'),
            label: l.streakKeep(days),
            busy: _busy,
            expand: true,
            onPressed: _bringBack,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── C: a Pro part for a day ──────────────────────

/// What the sheet over a locked Pro part was left with.
enum ProTrialChoice { pro, trial }

/// The sheet over a locked Pro part (pick C): [lifter] wearing it, Get Pro,
/// and — while a video is loaded — wear it free for a day.
Future<ProTrialChoice?> showProTrialSheet(
  BuildContext context, {
  required Lifter lifter,
}) {
  return showModalBottomSheet<ProTrialChoice>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (context) => _ProTrialSheet(lifter: lifter),
  );
}

class _ProTrialSheet extends StatelessWidget {
  const _ProTrialSheet({required this.lifter});

  final Lifter lifter;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: context.colors.surfaceRaised,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: LifterImage(lifter, size: 150),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    l.lifterTryingPro,
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const ProChip(height: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l.proTrialBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('trialGetPro'),
                onPressed: () => Navigator.of(context).pop(ProTrialChoice.pro),
                child: Text(l.getPro),
              ),
            ),
            if (Ads.instance.rewardOffered) ...[
              const SizedBox(height: 10),
              RewardButton(
                key: const Key('trialWear'),
                label: l.proTrialWear,
                expand: true,
                onPressed: () =>
                    Navigator.of(context).pop(ProTrialChoice.trial),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
