/// Home: your rank, and the three ways to start something.
///
/// Stripped back to what the screen is for. It used to open on a 280dp painted
/// crest wrapped in two blurred copies of itself, with the LP number set at
/// display size — a trophy cabinet you had to scroll past to reach the button
/// that starts a match.
///
/// Now the badge is the drawn polygon every other screen uses, at a size that
/// leaves the primary action above the fold, and the rank reads as one block:
/// shape, name, bar, one line of numbers.
library;

import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../app_bottom_nav.dart' show TablerIcon;
import '../avatar.dart';
import '../connection.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../lifter/my_lifter.dart';
import '../motion.dart';
import '../player_avatar.dart';
import '../push.dart';
import '../ranking.dart';
import '../rewards.dart';
import '../season.dart';
import '../subscription.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../widgets.dart';
import 'adventure_map.dart';
import 'daily_goal.dart';
import 'match_entry.dart';
import 'match_flow.dart';
import 'notifications.dart';
import 'pro_parts.dart';
import 'rank_screen.dart';
import 'shell.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = demoProfile;

    // The screen has one job in three situations, and the rank block and the
    // buttons both change with it: an account with no tier yet is doing
    // placements, an account with no network can still practise, and everyone
    // else is looking for a match.
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: Connection.instance,
          builder: (context, _) {
            final offline = !Connection.instance.online;

            // Ranked and online (the user's pick 2, 2026-11-03): the rank as
            // one quiet row, the match as you against an empty seat, then
            // Adventure and the week side by side and today's goal, each
            // rising in. The colours are the app's own and nothing moves
            // fast: a light breathes behind the crest, a warm light drifts
            // across the match, the empty seat turns, the button glows.
            if (p.isRanked && !offline) {
              // Every card built at once, not as it scrolls in, so what is
              // under the fold on a short phone is still there to find.
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TopRow(profile: p),
                    _StreakLine(profile: p),
                    const SizedBox(height: 12),
                    RiseIn(
                      child: _RankRow(
                        profile: p,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RankScreen(profile: p),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RiseIn(
                      delay: staggered(1),
                      child: _MatchHero(profile: p),
                    ),
                    const SizedBox(height: 12),
                    // Two tiles side by side: one glance takes in both. As
                    // tall as the taller tile, so large text grows both.
                    RiseIn(
                      delay: staggered(2),
                      child: const IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: AdventureCard(compact: true)),
                            SizedBox(width: 12),
                            Expanded(child: _WeekRaceCard()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RiseIn(delay: staggered(3), child: const DailyGoalCard()),
                  ],
                ),
              );
            }

            // The rank and the buttons sit in the middle of the space under
            // the top row, rather than at the top of it with the bottom
            // third of a tall phone empty. A short phone scrolls instead.
            return LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (box.maxHeight - 28).clamp(0, double.infinity),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                _TopRow(profile: p),
                _StreakLine(profile: p),
                const Spacer(),
                const SizedBox(height: 18),
                if (!p.isRanked)
                  const _Unranked()
                else
                  // Offline the rank is still true, it just cannot change, so
                  // it steps back rather than disappearing.
                  Opacity(
                    opacity: offline ? 0.45 : 1,
                    child: _Rank(profile: p),
                  ),
                const SizedBox(height: 26),
                // Today's goal, above the button that works toward it. Not
                // offline: practice still counts, but the screen there is
                // about the connection.
                if (!offline) ...[
                  const DailyGoalCard(),
                  const SizedBox(height: 16),
                ],
                if (offline)
                  const _OfflineActions()
                else
                  const _PlacementActions(),
                const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The badge on this tab: half the width on a tall phone, smaller on a
/// short one, so the rank fills the top of the screen and the buttons stay
/// in reach.
double _badgeSize(BuildContext context) {
  final screen = MediaQuery.sizeOf(context);
  final byWidth = screen.width * 0.5;
  final byHeight = screen.height * 0.27;
  return (byWidth < byHeight ? byWidth : byHeight).clamp(100.0, 240.0);
}

// ─────────────────────────────── unranked ────────────────────────────────────

/// A new account: no tier yet, a dashed outline where the badge goes, and
/// what the first match does — it puts you on the ladder at Iron V.
class _Unranked extends StatelessWidget {
  const _Unranked();

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      children: [
        TierBadge.unranked(size: _badgeSize(context)),
        const SizedBox(height: 9),
        Text(
          l.unranked,
          style: TextStyle(
            color: context.colors.text,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: Text(
            l.firstMatchForTier,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.muted,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlacementActions extends StatelessWidget {
  const _PlacementActions();

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FilledAction(
          label: l.playFirstMatch,
          onTap: () => startMatch(context, mode: MatchMode.ranked),
        ),
        const SizedBox(height: 8),
        Text(
          l.firstMatchTerms(localNumber(context, kDuelLength.inSeconds)),
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.muted, fontSize: 13),
        ),
        const SizedBox(height: 18),
        // Before the first duel the useful second option is a fight with
        // nothing at stake, not another ranked game.
        const AdventureCard(),
      ],
    );
  }
}

// ──────────────────────────────── offline ────────────────────────────────────

/// With no network there is no opponent, so the ranked button is dead and
/// practice is promoted to the filled one. The camera does not need a server.
class _OfflineActions extends StatelessWidget {
  const _OfflineActions();

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 16, color: context.colors.muted),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  l.noConnection,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.colors.muted, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 11),
        // Visibly dead rather than hidden: a button that vanishes reads as the
        // app losing a feature, and this one is coming back.
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: context.colors.surfaceRaised,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              l.findMatch,
              style: TextStyle(
                color: context.colors.faint,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        // The camera needs no server, and neither does the adventure.
        const AdventureCard(),
        const SizedBox(height: 14),
        Center(
          child: InkWell(
            onTap: () => Connection.instance.refresh(),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l.retry,
                style: TextStyle(color: context.colors.muted, fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────── top row ────────────────────────────────────

/// The week's training days on the left, notifications on the right, and no
/// title.
///
/// The app's name sat here for a while. It is the one thing on the screen the
/// reader already knows — they opened it — so it was spending the best line on
/// the page to say nothing.
class _TopRow extends StatefulWidget {
  const _TopRow({required this.profile});

  final Profile profile;

  @override
  State<_TopRow> createState() => _TopRowState();
}

class _TopRowState extends State<_TopRow> {
  /// How many things the server has to tell this lifter. Asked for here
  /// rather than on the notifications screen, because the whole job of the
  /// dot is to be the reason somebody opens that screen at all.
  int _unread = 0;

  @override
  void initState() {
    super.initState();
    _countUnread();
    // A push that lands with the app open is not drawn by Android; the dot
    // is how it gets noticed.
    Push.instance.arrived.addListener(_countUnread);
  }

  @override
  void dispose() {
    Push.instance.arrived.removeListener(_countUnread);
    super.dispose();
  }

  Future<void> _countUnread() async {
    if (!backend.available) return;
    try {
      final unread = await backend.unreadNotices();
      if (mounted) setState(() => _unread = unread);
    } on Object catch (error) {
      // No dot rather than a wrong one.
      debugPrint('Could not count notifications: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final unread = backend.available
        ? _unread
        : demoNotifications.where((n) => n.unread).length;

    return Row(
      children: [
        // The week on the left, the bell keeping the right edge, and Pro
        // beside the bell, where it is seen every time the app opens (the
        // user's pick, 2026-11-01). The week gives it the room.
        const Expanded(child: _WeekRow()),
        const SizedBox(width: 12),
        const ProPill(),
        // A round button the size of a thumb, with how many are waiting
        // rather than a dot that only says something is.
        Semantics(
          button: true,
          label: l.notifications,
          child: SizedBox(
            key: const Key('noticesButton'),
            width: 48,
            height: 48,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Material(
                  color: context.colors.surface,
                  shape: CircleBorder(
                    side: BorderSide(color: context.colors.border),
                  ),
                  child: InkWell(
                    // The screen marks them read, so the count has to be
                    // asked again on the way back rather than left standing.
                    onTap: () async {
                      await openNotifications(context);
                      await _countUnread();
                    },
                    customBorder: const CircleBorder(),
                    child: Center(
                      child: IconTheme(
                        data: IconThemeData(
                          color: context.colors.text,
                          size: 26,
                        ),
                        child: const TablerIcon(TablerIcon.bell),
                      ),
                    ),
                  ),
                ),
                if (unread > 0)
                  PositionedDirectional(
                    top: -4,
                    end: -6,
                    child: Container(
                      key: const Key('noticesCount'),
                      constraints: const BoxConstraints(minWidth: 22),
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.colors.rival,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: context.colors.background,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        unread > 9 ? '9+' : localNumber(context, unread),
                        style: TextStyle(
                          color: context.colors.background,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────── rank ─────────────────────────────────────

class _Rank extends StatelessWidget {
  const _Rank({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final toNext = (kRatingPerDivision - profile.lp).clamp(0, kRatingPerDivision);
    final top = profile.tierIdx >= kTopTier && profile.divIdx >= kTopDivision;

    return Column(
      children: [
        // Sized off the screen's width and height together: big — the badge
        // is what this tab is about — but never so tall on a short phone
        // that the buttons go under the fold.
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RankScreen(profile: profile),
            ),
          ),
          child: PopIn(
            child: TierBadge(
              tierIndex: profile.tierIdx,
              size: _badgeSize(context),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          tierLabel(l, profile.tierIdx, profile.divIdx),
          style: TextStyle(
            color: context.colors.text,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        // Fills to where the rank stands each time the tab is drawn.
        GrowingBar(
          value: top ? 1.0 : (profile.lp / 100).clamp(0.0, 1.0),
          colour: context.colors.brand,
          background: context.colors.surfaceRaised,
          radius: 4,
        ),
        const SizedBox(height: 8),
        // One line, not three: the rating (2026-11-02) and the next rung.
        Text(
          [
            localNumber(
              context,
              ratingOf(profile.tierIdx, profile.divIdx, profile.lp),
            ),
            if (!top)
              l.toNextTier(
                localNumber(context, toNext),
                nextRankName(l, profile.tierIdx, profile.divIdx),
              ),
          ].join(' · '),
          key: const Key('homeRating'),
          style: TextStyle(color: context.colors.muted, fontSize: 14),
        ),
      ],
    );
  }
}

// ─────────────────────────────── the rank row ────────────────────────────────

/// The rank on this tab (the user's pick 2, 2026-11-03): one quiet row in
/// the tier's metal — the crest with a light breathing slowly behind it, the
/// tier, the rating and what the next division needs, and a thin bar. The
/// profile keeps the large card; here the match is the point.
class _RankRow extends StatelessWidget {
  const _RankRow({required this.profile, required this.onTap});

  final Profile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final p = profile;
    final colors = context.colors;
    final metal = tierMetal(p.tierIdx);
    final dark = Theme.of(context).brightness == Brightness.dark;
    // As on the profile's card: Master's identity is its terracotta wings,
    // and the name is in the lightest metal on the dark theme, the darkest
    // on the light one.
    final accent = p.tierIdx >= kTopTier ? metal.wing : metal.mid;
    final ink = dark ? metal.light : metal.base;
    final top = p.tierIdx >= kTopTier && p.divIdx >= kTopDivision;
    final toNext = (kRatingPerDivision - p.lp).clamp(0, kRatingPerDivision);
    final fill = top ? 1.0 : (p.lp / kRatingPerDivision).clamp(0.0, 1.0);
    final next = top
        ? null
        : l.toNextTier(
            localNumber(context, toNext),
            nextRankName(l, p.tierIdx, p.divIdx),
          );
    final radius = BorderRadius.circular(18);

    return PressScale(
      scale: 0.98,
      child: Material(
        key: const Key('rankRow'),
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            // A touch of the metal from the crest's side, gone by the middle.
            gradient: LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              stops: const [0, 0.6],
              colors: [
                Color.alphaBlend(
                  accent.withValues(alpha: dark ? 0.09 : 0.07),
                  colors.surface,
                ),
                colors.surface,
              ],
            ),
            border: Border.all(
              color: Color.alphaBlend(
                accent.withValues(alpha: 0.18),
                colors.border,
              ),
              width: 0.8,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 10, 12, 10),
              child: Row(
                children: [
                  _Breathe(
                    colour: accent,
                    child: TierBadge(tierIndex: p.tierIdx, size: 52),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShrinkText(
                          tierLabel(l, p.tierIdx, p.divIdx).toUpperCase(),
                          maxLines: 1,
                          style: TextStyle(
                            color: ink,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 1),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text.rich(
                            key: const Key('rankRowRating'),
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: localNumber(
                                    context,
                                    ratingOf(p.tierIdx, p.divIdx, p.lp),
                                  ),
                                  style: TextStyle(
                                    color: colors.text,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                if (next != null)
                                  TextSpan(
                                    text: '  ·  $next',
                                    style: TextStyle(
                                      color: colors.muted,
                                      fontSize: 12.5,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: SizedBox(
                            height: 4,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ColoredBox(
                                  color: Colors.black.withValues(
                                    alpha: dark ? 0.35 : 0.08,
                                  ),
                                ),
                                FractionallySizedBox(
                                  alignment: AlignmentDirectional.centerStart,
                                  widthFactor: fill,
                                  child: ColoredBox(
                                    color: accent.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.chevron_right, color: colors.muted, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A soft light in the tier's colour behind the crest, swelling and fading
/// over six seconds. Held halfway where the phone asks for less motion, and
/// under tests.
class _Breathe extends StatefulWidget {
  const _Breathe({required this.colour, required this.child});

  final Color colour;
  final Widget child;

  @override
  State<_Breathe> createState() => _BreatheState();
}

class _BreatheState extends State<_Breathe>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
    value: 0.5,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loopsAllowed(context)) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colour;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -8,
          top: -8,
          right: -8,
          bottom: -8,
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = Curves.easeInOut.transform(_controller.value);
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        c.withValues(alpha: 0.12 + 0.16 * t),
                        c.withValues(alpha: 0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

// ─────────────────────────────── the match ───────────────────────────────────

/// The ranked match (the user's pick 2, 2026-11-03): you on one side, the
/// seat across from you still empty, what the match is in two lines, the
/// button and its terms. Calm on purpose: a warm light drifts slowly across
/// the whole card, the empty seat turns very slowly, the button glows and
/// fades. Nothing flashes, spins fast or crosses the text.
class _MatchHero extends StatelessWidget {
  const _MatchHero({required this.profile});

  final Profile profile;

  /// The gap between the two sides, where "VS" sits.
  static const _middle = 56.0;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;

    return Container(
      key: const Key('matchHero'),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: _WarmLight())),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
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
                            name: profile.username,
                            tierIdx: profile.tierIdx,
                            image: avatar.picture,
                            // A Pro's lifter is alive in its frame, as on
                            // the profile.
                            alive: Subscription.instance.active,
                            size: 60,
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
                    const Expanded(child: Center(child: _EmptySeat(size: 72))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
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
                      child: Text(
                        l.whoIsNext,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colors.muted, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  l.obIdeaTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  l.obIdeaRival,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.muted, fontSize: 14),
                ),
                const SizedBox(height: 16),
                _Glow(
                  child: _FilledAction(
                    label: l.findMatch,
                    onTap: () => startMatch(context, mode: MatchMode.ranked),
                  ),
                ),
                const SizedBox(height: 10),
                // The terms of the thing you just agreed to, under the button
                // rather than inside it.
                Text(
                  l.rankedTerms(localNumber(context, kDuelLength.inSeconds)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.muted, fontSize: 13.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A warm light drifting across the whole card and back, once every thirty
/// seconds — there to make the card feel lit, not to be watched — and the
/// opponent's side faintly in their colour. Still, behind your side, where
/// the phone asks for less motion and under tests.
class _WarmLight extends StatefulWidget {
  const _WarmLight();

  @override
  State<_WarmLight> createState() => _WarmLightState();
}

class _WarmLightState extends State<_WarmLight>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 15),
    value: 0.15,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loopsAllowed(context)) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final rival = context.colors.rival;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_controller.value);
        // Along the card, dipping gently towards the middle on the way.
        final x = -1.1 + 2.2 * t;
        final y = -0.75 + 0.35 * math.sin(t * math.pi);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(x, y),
              radius: 0.95,
              colors: [
                AppColors.gold.withValues(alpha: dark ? 0.11 : 0.08),
                AppColors.gold.withValues(alpha: 0),
              ],
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.65, -0.7),
                radius: 0.7,
                colors: [
                  rival.withValues(alpha: dark ? 0.06 : 0.04),
                  rival.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The seat across from you: a dashed ring in the opponent's colour turning
/// once in forty seconds, and a question mark that fades in and out. Both
/// still where the phone asks for less motion, and under tests.
class _EmptySeat extends StatefulWidget {
  const _EmptySeat({required this.size});

  final double size;

  @override
  State<_EmptySeat> createState() => _EmptySeatState();
}

class _EmptySeatState extends State<_EmptySeat> with TickerProviderStateMixin {
  late final _turn = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  );
  late final _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
    value: 1,
  );
  late final _opacity = Tween<double>(begin: 0.5, end: 0.9).animate(
    CurvedAnimation(parent: _fade, curve: Curves.easeInOut),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loopsAllowed(context)) {
      if (!_turn.isAnimating) _turn.repeat();
      if (!_fade.isAnimating) _fade.repeat(reverse: true);
    } else {
      _turn.stop();
      _fade.stop();
    }
  }

  @override
  void dispose() {
    _turn.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rival = context.colors.rival;
    final size = widget.size;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _turn,
            child: CustomPaint(
              size: Size.square(size),
              painter: _DashedRing(rival.withValues(alpha: 0.45)),
            ),
          ),
          FadeTransition(
            opacity: _opacity,
            child: Text(
              '?',
              style: TextStyle(
                color: rival,
                fontSize: size * 0.48,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
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

/// A soft glow round the button, swelling and fading over four and a half
/// seconds, so the one thing the tab is for looks ready without anything
/// moving across it. None where the phone asks for less motion, and under
/// tests.
class _Glow extends StatefulWidget {
  const _Glow({required this.child});

  final Widget child;

  @override
  State<_Glow> createState() => _GlowState();
}

class _GlowState extends State<_Glow> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2250),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loopsAllowed(context)) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.colors.brand;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: brand.withValues(alpha: 0.17 * t),
                blurRadius: 26,
                spreadRadius: 2 * t,
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

// ──────────────────────────────── actions ────────────────────────────────────

class _FilledAction extends StatelessWidget {
  const _FilledAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: Material(
      color: context.colors.brand,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                // The page background is the only colour dark enough to read
                // on `brand`.
                color: context.colors.background,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

// ──────────────────────────────── the week ───────────────────────────────────

/// This calendar week, Monday to Sunday: a filled dot for each day trained, an
/// open ring for today until it is, and faint rings for the rest.
class _WeekRow extends StatelessWidget {
  const _WeekRow();

  @override
  Widget build(BuildContext context) {
    // Calendar days, as Career.thisWeekReps counts them: across a clock
    // change a day is 23 or 25 hours, and adding hours named Thursday twice.
    final now = DateTime.now();
    final monday = now.day - (now.weekday - DateTime.monday);
    final today = now.weekday - DateTime.monday;

    return ListenableBuilder(
      listenable: Career.instance,
      builder: (context, _) {
        final reps = Career.instance.thisWeekReps;
        return Container(
          key: const Key('weekRow'),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child: Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: _DayDot(
                    trained: reps[i] > 0,
                    today: i == today,
                    letter: dayLetter(
                      context,
                      DateTime(now.year, now.month, monday + i),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.trained,
    required this.today,
    required this.letter,
  });

  final bool trained;
  final bool today;
  final String letter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: trained ? colors.rival : null,
            border: trained
                ? null
                : Border.all(
                    color: today ? colors.rival : colors.surfaceRaised,
                    width: today ? 2 : 1.5,
                  ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          letter,
          style: TextStyle(
            color: today ? colors.text : colors.muted,
            fontSize: 11,
            fontWeight: today ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// The streak under the week, and what today does to it — said only while
/// training today would still carry it on.
class _StreakLine extends StatelessWidget {
  const _StreakLine({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return ListenableBuilder(
      listenable: rewards,
      builder: (context, _) {
        if (profile.dayStreak <= 0 || !rewards.streakAlive) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Text(
            '${l.dayStreakCount(localNumber(context, profile.dayStreak))}'
            ' · '
            '${rewards.trainedToday ? l.streakDoneToday : l.streakTrainToday}',
            key: const Key('streakLine'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.rival,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}

/// This week's race, under the buttons: where this lifter stands, how long
/// is left, and how far it is to the top three. Opens the week's board.
class _WeekRaceCard extends StatefulWidget {
  const _WeekRaceCard();

  @override
  State<_WeekRaceCard> createState() => _WeekRaceCardState();
}

class _WeekRaceCardState extends State<_WeekRaceCard> {
  MonthPlace? _mine;
  List<MonthRow> _top = const [];

  @override
  void initState() {
    super.initState();
    if (backend.available) {
      _load();
      return;
    }
    // The preview and the screenshots, which have no server: the sample
    // lifter, fourteenth, with two days of the week left.
    final now = clock.now();
    _mine = MonthPlace(
      season: now,
      endsAt: now.add(const Duration(days: 2, hours: 4, minutes: 30)),
      place: 14,
      ofTotal: 120,
      points: 41,
      wins: 3,
      played: 5,
    );
    _top = [
      for (final (place, points) in const [(1, 140), (2, 96), (3, 79)])
        MonthRow(
          place: place,
          id: '$place',
          username: '',
          tierIdx: 0,
          divIdx: 0,
          points: points,
          wins: 0,
          played: 0,
        ),
    ];
  }

  Future<void> _load() async {
    try {
      final mine = await backend.myWeekPlace();
      final top = await backend.weekBoard(limit: 3);
      if (mounted) {
        setState(() {
          _mine = mine;
          _top = top;
        });
      }
    } on Object catch (error) {
      // No card rather than a wrong one.
      debugPrint('Could not read the week: $error');
    }
  }

  /// The same hint the week's board gives its own row.
  String _hint(BuildContext context, L l, MonthPlace mine) {
    final place = mine.place;
    if (place == null) return l.weekJoinHint;
    final third = _top.where((r) => r.place == 3).firstOrNull;
    if (place <= 3 || third == null) return l.weekInTop3;
    final gap = third.points - mine.points + 1;
    return l.weekToTop3(localNumber(context, gap < 1 ? 1 : gap));
  }

  /// A tile beside Adventure's (direction B, 2026-11-02): the place large,
  /// then the time left and how far the next places are. Until the server
  /// answers, the tile stands with a dash, so Adventure keeps its half.
  @override
  Widget build(BuildContext context) {
    final mine = _mine;
    final l = L.of(context);
    final colors = context.colors;
    final place = mine?.place;

    return Material(
      key: const Key('weekRaceCard'),
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => AppShell.goToRanks(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AdventureCard.tileHeight,
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.boardThisWeek,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  place == null ? '–' : '#${localNumber(context, place)}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
              ),
              const Spacer(),
              if (mine != null) ...[
                Text(
                  monthLeft(context, mine.endsAt, clock.now()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _hint(context, l, mine),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.muted, fontSize: 11.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
