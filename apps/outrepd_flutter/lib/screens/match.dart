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

import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../app_bottom_nav.dart' show TablerIcon;
import '../connection.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../push.dart';
import '../ranking.dart';
import '../rewards.dart';
import '../season.dart';
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

            // The tab as it was (the user's pick, 2026-11-03), all of it on
            // the screen at once: on a phone with room, the badge takes all
            // the height the rest leaves and sits in the middle of it — as
            // far from the streak above as from its name below, and no empty
            // end under the tiles (2026-11-04). A phone without room, or text
            // set large, scrolls, the badge kept at a size that still reads.
            return LayoutBuilder(
              builder: (context, box) {
                final fits = MediaQuery.textScalerOf(context).scale(1) <= 1.15 &&
                    box.maxHeight >= _restHeight(context) + 120 * _badgeCrop;
                final rank = !p.isRanked
                    ? (fits
                          ? Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                // A width of its own, so its words wrap
                                // as they would on the page.
                                child: SizedBox(
                                  width: box.maxWidth - 32,
                                  child: _Unranked(size: _badgeMax(context)),
                                ),
                              ),
                            )
                          : const _Unranked(size: _minBadge))
                    // Offline the rank is still true, it just cannot change,
                    // so it steps back and stops beating rather than
                    // disappearing.
                    : Opacity(
                        opacity: offline ? 0.45 : 1,
                        child: _Rank(
                          profile: p,
                          size: fits ? _badgeMax(context) : _minBadge,
                          alive: !offline,
                          fill: fits,
                        ),
                      );
                final column = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TopRow(profile: p),
                    _StreakLine(profile: p),
                    const SizedBox(height: 4),
                    if (fits) Expanded(child: rank) else rank,
                    const SizedBox(height: 14),
                    // The button first, right under the rank it plays for
                    // (the user's pick, 2026-11-04), then today's goal. Not
                    // offline: practice still counts, but the screen there
                    // is about the connection.
                    if (offline)
                      const _OfflineActions()
                    else if (!p.isRanked) ...[
                      const _PlacementActions(),
                      const SizedBox(height: 12),
                      const DailyGoalCard(),
                    ] else ...[
                      const _Actions(),
                      const SizedBox(height: 12),
                      const DailyGoalCard(),
                      const SizedBox(height: 12),
                      // Two tiles side by side: one glance takes in both. As
                      // tall as the taller tile, so large text grows both.
                      const IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: AdventureCard(compact: true)),
                            SizedBox(width: 12),
                            Expanded(child: _WeekRaceCard()),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
                const padding = EdgeInsets.fromLTRB(16, 4, 16, 16);
                return fits
                    ? Padding(padding: padding, child: column)
                    : SingleChildScrollView(padding: padding, child: column);
              },
            );
          },
        ),
      ),
    );
  }
}

/// The badge at its largest: about six tenths of the screen's width, and
/// never more than 280.
double _badgeMax(BuildContext context) =>
    math.min(MediaQuery.sizeOf(context).width * 0.62, 280.0);

/// The badge on a phone that scrolls: still big enough to read at a glance.
const _minBadge = 150.0;

/// Everything on the tab but the badge, at this text size: the top row and
/// streak, the rank's words and bar, the button and its terms, today's goal,
/// the two tiles, the gaps between them and the page's own padding.
/// Measured off the built screens (2026-11-03): about 570 on a wide phone,
/// more where the goal's line wraps on a narrow one.
double _restHeight(BuildContext context) =>
    588 + 160 * (MediaQuery.textScalerOf(context).scale(1) - 1);

// ─────────────────────────────── unranked ────────────────────────────────────

/// A new account: no tier yet, a dashed outline where the badge goes, and
/// what the first match does — it puts you on the ladder at Iron V.
class _Unranked extends StatelessWidget {
  const _Unranked({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      children: [
        TierBadge.unranked(size: size),
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
    // And whenever the tab comes into view, or the app back from the
    // background: the count was asked for once, when the tab was built.
    shownTab.addListener(_onShowing);
  }

  @override
  void dispose() {
    Push.instance.arrived.removeListener(_countUnread);
    shownTab.removeListener(_onShowing);
    super.dispose();
  }

  void _onShowing() {
    if (shownTab.value == AppShell.matchTabIndex) _countUnread();
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
  const _Rank({
    required this.profile,
    required this.size,
    required this.alive,
    this.fill = false,
  });

  final Profile profile;

  /// The badge's size; with [fill], its largest.
  final double size;

  /// Whether the badge beats: not offline, where the rank cannot change.
  final bool alive;

  /// Whether the badge takes all the height this is given, centred in it
  /// and drawn as large as fits, rather than its own height.
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final toNext = (kRatingPerDivision - profile.lp).clamp(0, kRatingPerDivision);
    final top = profile.tierIdx >= kTopTier && profile.divIdx >= kTopDivision;

    final badge = GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RankScreen(profile: profile),
        ),
      ),
      child: PopIn(
        child: _LiveBadge(
          tierIdx: profile.tierIdx,
          size: size,
          alive: alive,
        ),
      ),
    );

    return Column(
      children: [
        // As big as the screen has room for — the badge is what this tab is
        // about — but never so tall that the buttons go under the fold.
        if (fill)
          Expanded(
            child: Center(
              child: FittedBox(fit: BoxFit.scaleDown, child: badge),
            ),
          )
        else
          badge,
        const SizedBox(height: 2),
        Text(
          tierLabel(l, profile.tierIdx, profile.divIdx),
          // Small under the badge (the user's pick, 2026-11-03): the badge
          // says the tier, the words only name it.
          style: TextStyle(
            color: context.colors.text,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        // Fills to where the rank stands each time the tab is drawn.
        GrowingBar(
          value: top ? 1.0 : (profile.lp / 100).clamp(0.0, 1.0),
          colour: context.colors.brand,
          background: context.colors.surfaceRaised,
          radius: 4,
        ),
        const SizedBox(height: 6),
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

// ──────────────────────────────── the badge ──────────────────────────────────

/// How much of a badge's square box its crest fills, top to bottom. The rest
/// is empty, and cut away on this tab so the words sit right under it.
const _badgeCrop = 0.72;

/// The badge on this tab, alive (the user's pick C, 2026-11-04): it floats,
/// slowly — up a little and back over nine seconds — lit only by its own
/// glow off its edges. Nothing round behind it, no beat, no flashes and
/// nothing flying off it: the user found those ugly. Still where the phone
/// asks for less motion, offline, and under tests.
class _LiveBadge extends StatefulWidget {
  const _LiveBadge({
    required this.tierIdx,
    required this.size,
    required this.alive,
  });

  final int tierIdx;
  final double size;
  final bool alive;

  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4500),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _run();
  }

  @override
  void didUpdateWidget(_LiveBadge old) {
    super.didUpdateWidget(old);
    if (old.alive != widget.alive) _run();
  }

  void _run() {
    if (widget.alive && loopsAllowed(context)) {
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
    final size = widget.size;
    final badge = SizedBox(
      width: size,
      height: size * _badgeCrop,
      child: OverflowBox(
        minHeight: size,
        maxHeight: size,
        // The crest's own top sits a little below the box's.
        alignment: const Alignment(0, -0.214),
        child: TierBadge(tierIndex: widget.tierIdx, size: size),
      ),
    );
    return AnimatedBuilder(
      animation: _controller,
      child: badge,
      builder: (context, child) => Transform.translate(
        // A few points at most: three hundredths of the badge.
        offset: Offset(
          0,
          -size * 0.03 * Curves.easeInOut.transform(_controller.value),
        ),
        child: child,
      ),
    );
  }
}

// ──────────────────────────────── actions ────────────────────────────────────

/// Two ways in, weighted. One filled button for the thing most people came to
/// do, and the adventure under it as a card — the monster says what it is
/// without competing with the match. Friends are challenged from their own
/// tab, where they are listed.
class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FilledAction(
          label: l.findMatch,
          onTap: () => startMatch(context, mode: MatchMode.ranked),
        ),
        const SizedBox(height: 8),
        // The terms of the thing you just agreed to, under the button rather
        // than inside it.
        Text(
          l.rankedTerms(localNumber(context, kDuelLength.inSeconds)),
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.muted, fontSize: 14),
        ),
      ],
    );
  }
}


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
  // Kept between cards, so one built again (a sign-in, a new shell) shows the
  // last place at once while it asks for the current one.
  static MonthPlace? _lastMine;
  static List<MonthRow> _lastTop = const [];

  MonthPlace? _mine = _lastMine;
  List<MonthRow> _top = _lastTop;
  DateTime? _fetchedAt;
  bool _loading = false;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    if (backend.available) {
      _load();
      // It was asked for once, when the tab was first built, and the tab
      // stays built: the place said the same after every duel until the app
      // was opened again (the user, 2026-11-04). Now again whenever the tab
      // comes into view, after a duel of this account's own, and every
      // minute while it is on screen — other people's duels move it too.
      shownTab.addListener(_onShowing);
      Career.instance.addListener(_onOwnResult);
      _tick = Timer.periodic(const Duration(minutes: 1), (_) => _refresh());
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

  @override
  void dispose() {
    _tick?.cancel();
    shownTab.removeListener(_onShowing);
    Career.instance.removeListener(_onOwnResult);
    super.dispose();
  }

  bool get _showing => shownTab.value == AppShell.matchTabIndex;

  void _onShowing() {
    if (_showing) _refresh();
  }

  /// A duel of this account's own just moved its place: asked for now, not
  /// when the last answer is a while old. The duel's own screen may still be
  /// on top; the card is ready when it is closed.
  void _onOwnResult() {
    _fetchedAt = null;
    _refresh(evenUnseen: true);
  }

  /// Asks again unless the answer in hand is a few seconds old — or the app
  /// is in the background, or the tab is not the one in view.
  void _refresh({bool evenUnseen = false}) {
    if (!mounted || _loading) return;
    if (!evenUnseen && !_showing) return;
    final state = WidgetsBinding.instance.lifecycleState;
    if (state != null && state != AppLifecycleState.resumed) return;
    final at = _fetchedAt;
    if (at != null && clock.now().difference(at) < const Duration(seconds: 20)) {
      return;
    }
    _load();
  }

  Future<void> _load() async {
    _loading = true;
    try {
      final mine = await backend.myWeekPlace();
      final top = await backend.weekBoard(limit: 3);
      _lastMine = mine;
      _lastTop = top;
      _fetchedAt = clock.now();
      if (mounted) {
        setState(() {
          _mine = mine;
          _top = top;
        });
      }
    } on Object catch (error) {
      // The last place rather than a wrong one, or no card at all.
      debugPrint('Could not read the week: $error');
    } finally {
      _loading = false;
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
