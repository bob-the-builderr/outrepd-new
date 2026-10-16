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

import 'package:flutter/material.dart';

import '../app_bottom_nav.dart' show TablerIcon;
import '../bot.dart';
import '../connection.dart';
import '../backend/backend.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../push.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../widgets.dart';
import 'bot_setup.dart';
import 'daily_goal.dart';
import 'match_entry.dart';
import 'match_flow.dart';
import 'notifications.dart';
import 'progression.dart';

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
                const Spacer(),
                const SizedBox(height: 18),
                if (!p.isRanked)
                  _Unranked(profile: p)
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
                else if (!p.isRanked)
                  _PlacementActions(profile: p)
                else
                  const _Actions(),
                // Only where the build was made for it (see [kBotDemo]). It
                // sits under everything else so a real build never shows it
                // and a demo build can always reach it, online or not.
                if (kBotDemo) ...[
                  const SizedBox(height: 18),
                  const _DemoOpponentAction(),
                ],
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

/// A new account: no tier, a dashed outline where the badge goes, and either
/// an invitation to start placements or how far through them you are.
class _Unranked extends StatelessWidget {
  const _Unranked({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final started = profile.placementsDone > 0;

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

        if (!started)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: Text(
              l.placementsForFirstTier(localNumber(context, kPlacementDuels)),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          )
        else ...[
          // One pip per duel. A bar would say "some progress"; five pips say
          // exactly how many are left, which is the number people want.
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < kPlacementDuels; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Container(
                  width: 26,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: i < profile.placementsDone
                        ? context.colors.brand
                        : context.colors.surfaceRaised,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 9),
          Text(
            l.placementsLeft(
              localNumber(context, profile.placementsDone),
              localNumber(context, kPlacementDuels),
              localNumber(context, profile.placementsLeft),
            ),
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
        ],
      ],
    );
  }
}

class _PlacementActions extends StatelessWidget {
  const _PlacementActions({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final started = profile.placementsDone > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FilledAction(
          label: started ? l.nextPlacement : l.startPlacements,
          onTap: () => startMatch(context, mode: MatchMode.ranked),
        ),

        if (!started) ...[
          const SizedBox(height: 8),
          Text(
            l.placementsTerms(
              localNumber(context, profile.placementsDone),
              localNumber(context, kPlacementDuels),
              localNumber(context, kDuelLength.inSeconds),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
          const SizedBox(height: 18),
          // Before the first duel the useful second option is a dry run, not
          // another ranked game.
          Center(
            child: InkWell(
              onTap: () => startMatch(context, mode: MatchMode.practice),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  l.practiceFirst,
                  style: TextStyle(color: context.colors.muted, fontSize: 14),
                ),
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 12),
          _OutlinedAction(
            label: l.challengeFriend,
            onTap: () => showFriendRoomSheet(context),
          ),
        ],
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
        _FilledAction(
          label: l.practiceOffline,
          onTap: () => startMatch(context, mode: MatchMode.practice),
        ),
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

/// The streak on the left, notifications on the right, and no title.
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
    final profile = widget.profile;
    final unread = backend.available
        ? _unread
        : demoNotifications.where((n) => n.unread).length;

    return Row(
      children: [
        // The pill takes what it needs from the room on the left and the bell
        // keeps the right edge. A Flexible pill beside a Spacer split that
        // room in half instead, and left the bell short of the edge.
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: profile.dayStreak <= 0
                ? null
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: context.colors.border,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      l.dayStreakCount(localNumber(context, profile.dayStreak)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 14,
                      ),
                    ),
                  ),
          ),
        ),
        // A round button the size of a thumb, like the streak pill beside
        // it, with how many are waiting rather than a dot that only says
        // something is.
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
    final toNext = (100 - profile.lp).clamp(0, 100);

    return Column(
      children: [
        // Sized off the screen's width and height together: big — the badge
        // is what this tab is about — but never so tall on a short phone
        // that the buttons go under the fold.
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProgressionScreen(profile: profile),
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
          value: profile.lp / 100,
          colour: context.colors.brand,
          background: context.colors.surfaceRaised,
          radius: 4,
        ),
        const SizedBox(height: 8),
        // One line, not three. It used to be an LP number at display size, a
        // bar, and a separate "36 to promotion" caption underneath — three
        // pieces of furniture for one fact.
        Text(
          '${localNumber(context, profile.lp)} / '
          '${localNumber(context, 100)} LP · '
          '${l.toNextTier(localNumber(context, toNext), nextRankName(l, profile.tierIdx, profile.divIdx))}',
          style: TextStyle(color: context.colors.muted, fontSize: 14),
        ),
      ],
    );
  }
}

// ──────────────────────────────── actions ────────────────────────────────────

/// Three ways in, weighted. One filled button for the thing most people came
/// to do, one outlined for the social route, and practice as plain text —
/// available to anyone looking for it, and not competing with the match.
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
        const SizedBox(height: 10),
        // The terms of the thing you just agreed to, under the button rather
        // than inside it.
        Text(
          l.rankedTerms(localNumber(context, kDuelLength.inSeconds)),
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.muted, fontSize: 14),
        ),

        const SizedBox(height: 20),
        _OutlinedAction(
          label: l.challengeFriend,
          onTap: () => showFriendRoomSheet(context),
        ),

        const SizedBox(height: 18),
        Center(
          child: InkWell(
            onTap: () => startMatch(context, mode: MatchMode.practice),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                l.practiceTerms,
                style: TextStyle(color: context.colors.faint, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A way into the demo opponent, only in a build made with [kBotDemo]. Plain
/// text like practice, and under it, because it is a tool for filming rather
/// than a fourth way to play.
class _DemoOpponentAction extends StatelessWidget {
  const _DemoOpponentAction();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        key: const Key('demoOpponent'),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BotSetupScreen()),
        ),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.smart_display_outlined,
                size: 16,
                color: context.colors.faint,
              ),
              const SizedBox(width: 7),
              Text(
                'Demo opponent',
                style: TextStyle(color: context.colors.faint, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
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

class _OutlinedAction extends StatelessWidget {
  const _OutlinedAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
