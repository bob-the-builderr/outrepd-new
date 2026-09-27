/// The leaderboard.
///
/// Built to the spec's numbers rather than to a feel for them: every size and
/// gap below is a figure from the build document.
///
/// The one rule here that is about people rather than layout is the pinned self
/// row. It is visible whatever the position, four digits or five, because a
/// board you cannot find yourself on tells you only that other people exist.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';
import 'other_profile.dart';
import 'shell.dart';

enum _Scope {
  /// Everyone, ranked by LP alone — the whole ladder in one list.
  topPlayers,

  /// Only the lifters currently sharing this account's own tier and
  /// division, ranked against just each other rather than the whole game.
  yourTier,
}

class RanksScreen extends StatefulWidget {
  const RanksScreen({super.key});

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  _Scope _scope = _Scope.topPlayers;

  /// Rows per scope, kept once fetched so flipping the toggle does not
  /// re-query a board that does not change minute to minute.
  final _boards = <_Scope, List<BoardRow>>{};
  bool _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    if (backend.available) _load();
  }

  Future<void> _load() async {
    if (!backend.available) return;
    final scope = _scope;
    final me = demoProfile;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rows = await backend.leaderboard(
        tierIdx: scope == _Scope.yourTier ? me.tierIdx : null,
        divIdx: scope == _Scope.yourTier ? me.divIdx : null,
      );
      if (!mounted) return;
      setState(() {
        _boards[scope] = rows;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  void _switchTo(_Scope scope) {
    setState(() => _scope = scope);
    if (!_boards.containsKey(scope)) _load();
  }

  /// The board, from whichever source this build is running on.
  ///
  /// With no server it is the sample board, which is what the rest of the app
  /// falls back to and the only thing that makes the layout worth looking at
  /// before there is anybody real to put on it.
  List<LeaderboardEntry> get _entries {
    if (!backend.available) {
      final me = demoProfile;
      return _scope == _Scope.topPlayers
          ? demoLeaderboard
          : demoLeaderboard
              .where((e) => e.tierIdx == me.tierIdx && e.divIdx == me.divIdx)
              .toList();
    }
    return [
      for (final row in _boards[_scope] ?? const <BoardRow>[])
        LeaderboardEntry(
          row.username,
          row.tierIdx,
          row.divIdx,
          row.lp,
          row.wins,
          row.losses,
          id: row.id,
          avatarUrl: row.avatarUrl,
        ),
    ];
  }

  /// Where this account sits, or null when that is not known.
  ///
  /// Known exactly whenever the account appears in the page that was
  /// fetched. Below that the honest answer is nothing at all: a made-up
  /// position on the one row somebody looks for themselves on is worse than
  /// no position. Offline, the sample profile's own global rank stands in for
  /// Top Players — the same fallback every other screen already reads for it
  /// — but Your Tier has no equivalent sample number to stand in with, since
  /// the demo board it lists from was never really the one this account was
  /// on, so it stays honestly unknown there too.
  int? get _myPosition {
    if (!backend.available) {
      return _scope == _Scope.topPlayers ? demoProfile.globalRank : null;
    }
    final id = backend.me?.id;
    final rows = _boards[_scope];
    if (id == null || rows == null) return null;
    final at = rows.indexWhere((row) => row.id == id);
    return at < 0 ? null : at + 1;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;
    final me = demoProfile;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  L.of(context).ranksTitle.toUpperCase(),
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),
            _ScopeToggle(scope: _scope, onChanged: _switchTo),

            const SizedBox(height: 14),
            Expanded(
              // An unranked account is not looking at an empty board — the
              // board is full, they are simply not on it yet. Saying "no ranks
              // yet" there would be a lie about the app; saying "no rank yet"
              // is the truth about them, and it comes with the way out.
              child: !me.isRanked
                  ? EmptyState(
                      icon: Icons.emoji_events_outlined,
                      title: L.of(context).noRankYet,
                      body: L
                          .of(context)
                          .placementsForTier(
                            localNumber(context, kPlacementDuels),
                          ),
                      action: PillButton(
                        label: L.of(context).startPlacements,
                        onTap: () => AppShell.goToMatch(context),
                      ),
                      footnote: L
                          .of(context)
                          .placementsDoneCount(
                            localNumber(context, me.placementsDone),
                            localNumber(context, kPlacementDuels),
                          ),
                    )
                  : _loading && entries.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  // A board that could not be fetched is not an empty board.
                  // Saying "nobody is ranked" when the truth is "the phone
                  // could not ask" invents a fact about other people.
                  : _error != null && entries.isEmpty
                  ? BlockingNotice(
                      icon: Icons.wifi_off,
                      title: L.of(context).noConnection,
                      body: L.of(context).noConnectionBody,
                      actionLabel: L.of(context).retry,
                      onAction: _load,
                    )
                  : entries.isEmpty
                  ? EmptyState(
                      icon: Icons.emoji_events_outlined,
                      title: L.of(context).noRanksYet,
                      body: L.of(context).noRanksYetBody,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        itemCount: entries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 7),
                        itemBuilder: (context, i) =>
                            _RankRow(position: i + 1, entry: entries[i]),
                      ),
                    ),
            ),

            // Pinned whatever the position — but only once there is a position
            // to pin. An unranked account has no place on this board, and a
            // row inventing one sat directly under "No rank yet" claiming a
            // rank, a record and a position in the same breath.
            if (me.isRanked)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: _SelfRow(
                  position: _myPosition,
                  username: me.username,
                  tierIdx: me.tierIdx,
                  divIdx: me.divIdx,
                  lp: me.lp,
                  wins: me.wins,
                  losses: me.losses,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────── the controls ───────────────────────────────

class _ScopeToggle extends StatelessWidget {
  const _ScopeToggle({required this.scope, required this.onChanged});

  final _Scope scope;
  final ValueChanged<_Scope> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget pill(_Scope value, String label) {
      final selected = scope == value;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: selected ? context.colors.brand : null,
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? null
                  : Border.all(color: context.colors.border, width: 0.5),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected
                    ? context.colors.background
                    : context.colors.muted,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          pill(_Scope.topPlayers, L.of(context).topPlayers),
          const SizedBox(width: 8),
          pill(_Scope.yourTier, L.of(context).yourTier),
        ],
      ),
    );
  }
}

// ───────────────────────────────── the rows ──────────────────────────────────

class _RankRow extends StatelessWidget {
  const _RankRow({required this.position, required this.entry});

  final int position;
  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      // A sample row has no id to fetch with, so it opens a sample card.
      onTap: () => showLifterPeek(
        context,
        id: entry.id,
        username: entry.username,
        initial: entry.id.isEmpty ? demoLifterProfile(entry.username) : null,
      ),
      child: _RowCard(
        child: Row(
          children: [
            _Position(position: position),
            const SizedBox(width: 11),
            _Initial(
              name: entry.username,
              size: 30,
              fontSize: 13,
              avatarUrl: entry.avatarUrl,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: _Identity(
                username: entry.username,
                tierIdx: entry.tierIdx,
                divIdx: entry.divIdx,
                wins: entry.wins,
                losses: entry.losses,
              ),
            ),
            const SizedBox(width: 11),
            _Points(lp: entry.lp, colour: context.colors.text),
          ],
        ),
      ),
    );
  }
}

class _SelfRow extends StatelessWidget {
  const _SelfRow({
    required this.position,
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.wins,
    required this.losses,
  });

  /// Null when the board this account is on has not said where they are.
  /// The row still belongs here — it is their rank and their record — and it
  /// shows those without a position rather than inventing one.
  final int? position;
  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;
  final int wins;
  final int losses;

  @override
  Widget build(BuildContext context) {
    return _RowCard(
      borderColour: context.colors.brand,
      borderWidth: 1,
      child: Row(
        children: [
          // The raw number rather than a circle: at four or five digits a
          // circle either clips the position or swells the row.
          if (position case final place?) ...[
            Text(
              localNumber(context, place),
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 12,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 11),
          ],
          _Initial(name: username, size: 30, fontSize: 13),
          const SizedBox(width: 11),
          Expanded(
            child: _Identity(
              username: username,
              tierIdx: tierIdx,
              divIdx: divIdx,
              wins: wins,
              losses: losses,
              trailing: const _YouChip(),
            ),
          ),
          const SizedBox(width: 11),
          _Points(lp: lp, colour: context.colors.brand),
        ],
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  const _RowCard({
    required this.child,
    this.borderColour,
    this.borderWidth = 0.5,
  });

  final Widget child;
  final Color? borderColour;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColour ?? context.colors.border,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}

class _Position extends StatelessWidget {
  const _Position({required this.position});

  final int position;

  @override
  Widget build(BuildContext context) {
    // The podium is the only place colour is spent on a leaderboard. Below
    // third it would be decoration.
    final medal = switch (position) {
      1 => AppColors.gold,
      2 => AppColors.silver,
      3 => AppColors.bronze,
      _ => null,
    };

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: medal ?? context.colors.surfaceRaised,
      ),
      child: Text(
        localNumber(context, position),
        style: TextStyle(
          color: medal == null
              ? context.colors.muted
              : context.colors.background,
          fontSize: 12,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({
    required this.name,
    required this.size,
    required this.fontSize,
    this.avatarUrl,
  });

  final String name;
  final double size;
  final double fontSize;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.surfaceRaised,
      ),
      child: Text(
        name.isEmpty ? '?' : name.characters.first.toUpperCase(),
        style: TextStyle(color: context.colors.text, fontSize: fontSize),
      ),
    );

    if (avatarUrl == null) return fallback;
    return ClipOval(
      child: Image.network(
        avatarUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : fallback,
        errorBuilder: (context, error, stack) => fallback,
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.wins,
    required this.losses,
    this.trailing,
  });

  final String username;
  final int tierIdx;
  final int divIdx;
  final int wins;
  final int losses;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.colors.text, fontSize: 13),
              ),
            ),
            if (trailing case final chip?) ...[const SizedBox(width: 6), chip],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '${tierLabel(L.of(context), tierIdx, divIdx)} · '
          '${L.of(context).winLoss(localNumber(context, wins), localNumber(context, losses))}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: context.colors.muted, fontSize: 10),
        ),
      ],
    );
  }
}

class _Points extends StatelessWidget {
  const _Points({required this.lp, required this.colour});

  final int lp;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          localNumber(context, lp),
          style: TextStyle(
            color: colour,
            fontSize: 15,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          L.of(context).lpUnit,
          style: TextStyle(color: context.colors.muted, fontSize: 9),
        ),
      ],
    );
  }
}

class _YouChip extends StatelessWidget {
  const _YouChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: context.colors.brand,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        L.of(context).you.toUpperCase(),
        style: TextStyle(color: context.colors.background, fontSize: 9),
      ),
    );
  }
}
