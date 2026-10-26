/// The leaderboard.
///
/// Built to the spec's numbers rather than to a feel for them: every size and
/// gap below is a figure from the build document.
///
/// The one rule here that is about people rather than layout is the pinned self
/// row. It is visible whatever the position, four digits or five, because a
/// board you cannot find yourself on tells you only that other people exist.
library;

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../avatar.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../season.dart';
import '../theme.dart';
import '../tier_frame.dart';
import '../widgets.dart';
import 'other_profile.dart';
import 'shell.dart';

enum _Scope {
  /// The week's race, the month's board a week at a time: LP won in ranked
  /// duels since Monday. Shown first, under the same tab as the month, since
  /// a week is a race more people can win.
  thisWeek,

  /// The month's race: LP won in ranked duels since the 1st. The one board
  /// everybody starts level on, whatever their rank, and the one with awards.
  thisMonth,

  /// Everyone, ranked by LP alone — the whole ladder in one list.
  topPlayers,

  /// Only the lifters currently sharing this account's own tier and
  /// division, ranked against just each other rather than the whole game.
  yourTier,
}

/// How long a board is shown before it is asked for again while somebody is
/// looking at it: places move every time anybody finishes a duel, and the
/// board is where people watch them move.
const kBoardFreshFor = Duration(seconds: 30);

class RanksScreen extends StatefulWidget {
  const RanksScreen({super.key});

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  _Scope _scope = _Scope.thisWeek;

  /// The tab that holds the week and the month: the one race, two lengths.
  bool get _season => _scope == _Scope.thisWeek || _scope == _Scope.thisMonth;

  /// Rows per scope, kept once fetched so flipping the toggle shows them at
  /// once; asked for again behind them once they are [kBoardFreshFor] old.
  final _boards = <_Scope, List<BoardRow>>{};

  /// When each scope was last fetched. Missing is "ask before showing it":
  /// never fetched, or this account's own place has moved since.
  final _fetchedAt = <_Scope, DateTime>{};

  /// The month's board and this account's place on it, fetched together;
  /// the week's the same way.
  List<MonthRow>? _month;
  MonthPlace? _monthPlace;
  List<MonthRow>? _week;
  MonthPlace? _weekPlace;

  /// This account's place on the whole board, for when it is below the
  /// hundred rows the board shows.
  int? _globalPlace;

  bool _loading = false;
  Object? _error;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    if (backend.available) {
      _load();
      shownTab.addListener(_onShowing);
      Career.instance.addListener(_onOwnResult);
      _tick = Timer.periodic(kBoardFreshFor, (_) => _refreshIfShowing());
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    shownTab.removeListener(_onShowing);
    Career.instance.removeListener(_onOwnResult);
    super.dispose();
  }

  /// Opened: whatever moved since it was last looked at.
  void _onShowing() {
    if (_showing) _refreshIfShowing();
  }

  /// A duel of this account's own just changed its place on every board:
  /// none of them is fresh any more, and the one in view is asked for now.
  void _onOwnResult() {
    _fetchedAt.clear();
    _refreshIfShowing();
  }

  /// Asks for the board in view again, quietly, when it is on screen and has
  /// been shown long enough to be out of date. Not while a match or any
  /// other screen is on top of it, nor while the app is in the background.
  void _refreshIfShowing() {
    if (!mounted || !_showing) return;
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
    final state = WidgetsBinding.instance.lifecycleState;
    if (state != null && state != AppLifecycleState.resumed) return;
    if (_fresh(_scope) || _loading) return;
    _load(quiet: true);
  }

  bool get _showing => shownTab.value == AppShell.ranksTabIndex;

  bool _fresh(_Scope scope) {
    final at = _fetchedAt[scope];
    return at != null && clock.now().difference(at) < kBoardFreshFor;
  }

  bool get _loaded => switch (_scope) {
    _Scope.thisWeek => _week != null,
    _Scope.thisMonth => _month != null,
    _ => _boards.containsKey(_scope),
  };

  /// [quiet] keeps what is on screen while it is asked for again — no
  /// spinner, and a failed read leaves the board as it was rather than
  /// replacing it with an error.
  Future<void> _load({bool quiet = false}) async {
    if (!backend.available) return;
    final scope = _scope;
    final me = demoProfile;
    setState(() {
      _loading = true;
      if (!quiet) _error = null;
    });
    try {
      if (scope == _Scope.thisWeek) {
        final place = await backend.myWeekPlace();
        final rows = await backend.weekBoard();
        if (!mounted) return;
        setState(() {
          _weekPlace = place;
          _week = rows;
          _fetchedAt[scope] = clock.now();
          _loading = false;
          _error = null;
        });
        return;
      }
      if (scope == _Scope.thisMonth) {
        // The place first: asking for it is what closes a month that has
        // ended, so the board read after it is already the new month's.
        final place = await backend.myMonthPlace();
        final rows = await backend.monthBoard();
        if (!mounted) return;
        setState(() {
          _monthPlace = place;
          _month = rows;
          _fetchedAt[scope] = clock.now();
          _loading = false;
          _error = null;
        });
        return;
      }
      final rows = await backend.leaderboard(
        tierIdx: scope == _Scope.yourTier ? me.tierIdx : null,
        divIdx: scope == _Scope.yourTier ? me.divIdx : null,
      );
      // Below the hundred shown, the place still is one: asked for apart.
      final global = scope == _Scope.topPlayers &&
              !rows.any((row) => row.id == backend.me?.id)
          ? await backend.boardPosition()
          : null;
      if (!mounted) return;
      setState(() {
        _boards[scope] = rows;
        if (scope == _Scope.topPlayers) _globalPlace = global;
        _fetchedAt[scope] = clock.now();
        _loading = false;
        _error = null;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        if (!quiet) _error = error;
        _loading = false;
      });
    }
  }

  void _switchTo(_Scope scope) {
    setState(() {
      _scope = scope;
      _error = null;
    });
    if (!_loaded) {
      _load();
    } else if (!_fresh(scope)) {
      _load(quiet: true);
    }
  }

  /// The month's rows — or the week's — from whichever source this build is
  /// running on.
  List<MonthRow> get _monthRows => !backend.available
      ? demoMonthBoard
      : (_scope == _Scope.thisWeek ? _week : _month) ?? const [];

  /// This account on the month's board. With no server it is somebody who
  /// has not played this month yet: the sample has no real place to give.
  MonthPlace get _myMonth {
    final week = _scope == _Scope.thisWeek;
    if ((week ? _weekPlace : _monthPlace) case final place?) return place;
    final now = clock.now().toUtc();
    final monday = DateTime.utc(now.year, now.month, now.day - (now.weekday - 1));
    return MonthPlace(
      season: week ? monday : DateTime.utc(now.year, now.month),
      endsAt: week
          ? monday.add(const Duration(days: 7))
          : DateTime.utc(now.year, now.month + 1),
      place: null,
      ofTotal: 0,
      points: 0,
      wins: 0,
      played: 0,
    );
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
          xp: row.xp,
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
    if (at >= 0) return at + 1;
    return _scope == _Scope.topPlayers ? _globalPlace : null;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;
    final me = demoProfile;
    final month = _season;
    final week = _scope == _Scope.thisWeek;

    // Nothing to draw yet. The month's board can be empty and still be an
    // answer — a new month, nobody has won a duel — so it is "not fetched"
    // that matters there, not "no rows".
    final nothingYet = month
        ? backend.available && (week ? _week : _month) == null
        : entries.isEmpty;

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
                    fontSize: 24,
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
                      body: L.of(context).firstMatchForBoard,
                      action: PillButton(
                        label: L.of(context).playFirstMatch,
                        onTap: () => AppShell.goToMatch(context),
                      ),
                    )
                  : _loading && nothingYet
                  ? const Center(child: CircularProgressIndicator())
                  // A board that could not be fetched is not an empty board.
                  // Saying "nobody is ranked" when the truth is "the phone
                  // could not ask" invents a fact about other people.
                  : _error != null && nothingYet
                  ? BlockingNotice(
                      icon: Icons.wifi_off,
                      title: L.of(context).noConnection,
                      body: L.of(context).noConnectionBody,
                      actionLabel: L.of(context).retry,
                      onAction: _load,
                    )
                  : month
                  ? _MonthBoard(
                      rows: _monthRows,
                      mine: _myMonth,
                      week: week,
                      onLength: (toWeek) => _switchTo(
                        toWeek ? _Scope.thisWeek : _Scope.thisMonth,
                      ),
                      onRefresh: _load,
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
                        // Above the list on Top Players: who is on it, and
                        // how a tie is settled.
                        itemCount: entries.length + 1,
                        separatorBuilder: (_, _) => const SizedBox(height: 7),
                        itemBuilder: (context, i) => i == 0
                            ? const _BoardNote()
                            : RiseIn(
                                delay: staggered(i - 1),
                                child: _RankRow(
                                  position: i,
                                  entry: entries[i - 1],
                                ),
                              ),
                      ),
                    ),
            ),

            // Pinned whatever the position — but only once there is a position
            // to pin. An unranked account has no place on this board, and a
            // row inventing one sat directly under "No rank yet" claiming a
            // rank, a record and a position in the same breath.
            if (me.isRanked && !(month && nothingYet))
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: month
                    ? _MonthSelfRow(
                        mine: _myMonth,
                        rows: _monthRows,
                        username: me.username,
                        week: week,
                      )
                    : _SelfRow(
                        position: _myPosition,
                        username: me.username,
                        tierIdx: me.tierIdx,
                        divIdx: me.divIdx,
                        lp: me.lp,
                        wins: me.wins,
                        losses: me.losses,
                        xp: me.xp,
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
      final selected = scope == value ||
          (value == _Scope.thisWeek && scope == _Scope.thisMonth);
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: selected ? context.colors.brand : null,
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? null
                  : Border.all(color: context.colors.border, width: 0.5),
            ),
            // Three to a row, so a long name shrinks to fit rather than
            // wrapping one pill to twice the height of its neighbours.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? context.colors.background
                      : context.colors.muted,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : null,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final l = L.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          pill(_Scope.thisWeek, l.thisSeason),
          const SizedBox(width: 8),
          pill(_Scope.topPlayers, l.topPlayers),
          const SizedBox(width: 8),
          pill(_Scope.yourTier, l.yourTier),
        ],
      ),
    );
  }
}

/// Week or month, inside the first tab: the same race, two lengths.
class _LengthSwitch extends StatelessWidget {
  const _LengthSwitch({required this.week, required this.onChanged});

  final bool week;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    Widget half(bool value, String label) {
      final selected = week == value;
      return Expanded(
        child: GestureDetector(
          key: Key(value ? 'lengthWeek' : 'lengthMonth'),
          onTap: () => onChanged(value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? context.colors.surfaceRaised : null,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? context.colors.text : context.colors.muted,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : null,
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [half(true, l.lengthWeek), half(false, l.lengthMonth)],
        ),
      ),
    );
  }
}

/// Above Top Players and Your Tier: who is on the board, and how a tie on
/// rank and LP is settled (social.sql, leaderboard).
class _BoardNote extends StatelessWidget {
  const _BoardNote();

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        '${l.boardActiveNote} · ${l.boardTieNote}',
        textAlign: TextAlign.center,
        style: TextStyle(color: context.colors.muted, fontSize: 12),
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
              size: 40,
              fontSize: 17,
              avatarUrl: entry.avatarUrl,
              mine: entry.id == backend.me?.id,
              frame: entry.tierIdx,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: _Identity(
                username: entry.username,
                tierIdx: entry.tierIdx,
                divIdx: entry.divIdx,
                wins: entry.wins,
                losses: entry.losses,
                xp: entry.xp,
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
    required this.xp,
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
  final int xp;

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
                fontSize: 14,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 11),
          ],
          _Initial(
            name: username,
            size: 40,
            fontSize: 17,
            frame: tierIdx,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: _Identity(
              username: username,
              tierIdx: tierIdx,
              divIdx: divIdx,
              wins: wins,
              losses: losses,
              xp: xp,
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
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
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
      width: 30,
      height: 30,
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
          fontSize: 14,
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
    this.mine = false,
    this.frame,
  });

  final String name;
  final double size;
  final double fontSize;
  final String? avatarUrl;

  /// This account's own row: drawn from the picture on this phone, so a new
  /// one is on the board the moment it is picked, before the board is read
  /// again from the server.
  final bool mine;

  /// The tier to frame the picture in, in a row. Null on the podium, whose
  /// pictures wear their place's medal ring instead.
  final int? frame;

  @override
  Widget build(BuildContext context) {
    final picture = _picture(context);
    if (frame == null) return picture;
    return TierFrame(tierIdx: frame, size: size, child: picture);
  }

  Widget _picture(BuildContext context) {
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

    final own = mine ? avatar.picture : null;
    final url = avatarUrl;
    if (own == null && url == null) return fallback;
    return ClipOval(
      child: Image(
        image: own ?? NetworkImage(url!),
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
    this.xp,
  });

  final String username;
  final int tierIdx;
  final int divIdx;
  final int wins;
  final int losses;
  final Widget? trailing;

  /// For the level after the name.
  final int? xp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: NameWithLevel(
                name: username,
                xp: xp,
                style: TextStyle(color: context.colors.text, fontSize: 15),
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
          style: TextStyle(color: context.colors.muted, fontSize: 12),
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
            fontSize: 17,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          L.of(context).lpUnit,
          style: TextStyle(color: context.colors.muted, fontSize: 11),
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
        style: TextStyle(color: context.colors.background, fontSize: 11),
      ),
    );
  }
}

// ─────────────────────────────── this month ──────────────────────────────────

/// The month's race: who is winning it, what they win, and how long is left.
///
/// The top three stand on a podium because they are what the month gives
/// out; the line under tenth is where the awards stop.
class _MonthBoard extends StatelessWidget {
  const _MonthBoard({
    required this.rows,
    required this.mine,
    required this.onRefresh,
    this.week = false,
    this.onLength,
  });

  final List<MonthRow> rows;
  final MonthPlace mine;
  final Future<void> Function() onRefresh;

  /// The week's board rather than the month's: no awards at its end.
  final bool week;

  /// Week or month, from the switch at the top.
  final ValueChanged<bool>? onLength;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final podium = rows.take(3).toList();
    final rest = rows.skip(3).toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        children: [
          if (onLength case final onLength?) ...[
            _LengthSwitch(week: week, onChanged: onLength),
            const SizedBox(height: 12),
          ],
          _SeasonHeader(mine: mine, week: week),
          if (rows.isEmpty)
            EmptyState(
              icon: Icons.calendar_month_outlined,
              title: l.monthEmptyTitle,
              body: l.monthEmptyBody,
            )
          else ...[
            const SizedBox(height: 14),
            _Podium(rows: podium),
            const SizedBox(height: 12),
            for (final row in rest) ...[
              if (row.place == 11 && !week) const _Top10Line(),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: RiseIn(
                  delay: staggered(row.place - 3),
                  child: _MonthRankRow(row: row, week: week),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SeasonHeader extends StatelessWidget {
  const _SeasonHeader({required this.mine, this.week = false});

  final MonthPlace mine;
  final bool week;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final played = mine.played;
    final earned = played >= kRegularDuels;

    return Column(
      children: [
        Text(
          '${week ? l.thisWeek : monthName(context, mine.season)} · '
          '${monthLeft(context, mine.endsAt, clock.now())}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          week
              ? l.weekStartsAgain
              : earned
              ? l.monthRegularEarned
              : l.monthRegularProgress(
                  '${localNumber(context, played)}/'
                  '${localNumber(context, kRegularDuels)}',
                ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: earned && !week
                ? context.colors.brand
                : context.colors.muted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

/// First in the middle and tallest, second to its left, third to its right —
/// the way a podium stands, whichever way the language reads.
class _Podium extends StatelessWidget {
  const _Podium({required this.rows});

  final List<MonthRow> rows;

  @override
  Widget build(BuildContext context) {
    MonthRow? at(int place) => rows.where((r) => r.place == place).firstOrNull;

    Widget slot(int place) => Expanded(
      child: switch (at(place)) {
        // First up first, then second and third either side of it.
        final row? => PopIn(
          delay: Duration(milliseconds: place == 1 ? 0 : 90 * place),
          child: _PodiumPlace(row: row),
        ),
        null => const SizedBox.shrink(),
      },
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          slot(2),
          const SizedBox(width: 8),
          slot(1),
          const SizedBox(width: 8),
          slot(3),
        ],
      ),
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  const _PodiumPlace({required this.row});

  final MonthRow row;

  @override
  Widget build(BuildContext context) {
    final first = row.place == 1;
    final medal = switch (row.place) {
      1 => AppColors.gold,
      2 => AppColors.silver,
      _ => AppColors.bronze,
    };
    final avatar = first ? 66.0 : 52.0;
    final block = switch (row.place) {
      1 => 92.0,
      2 => 70.0,
      _ => 56.0,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showLifterPeek(
        context,
        id: row.id,
        username: row.username,
        initial: row.id.isEmpty ? demoLifterProfile(row.username) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (first)
            const Icon(Icons.emoji_events, color: AppColors.gold, size: 26),
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: medal, width: 2.5),
            ),
            child: _Initial(
              name: row.username,
              size: avatar,
              fontSize: first ? 26 : 21,
              avatarUrl: row.avatarUrl,
              mine: row.id == backend.me?.id,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            row.username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.colors.text,
              fontSize: first ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(fit: BoxFit.scaleDown, child: LevelChip(xp: row.xp)),
          const SizedBox(height: 6),
          Container(
            height: block,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: medal,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            // Shrunk to the step rather than spilling out of it at large text:
            // the steps' heights are the podium, and the podium is the point.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localNumber(context, row.place),
                    style: TextStyle(
                      color: context.colors.background,
                      fontSize: first ? 30 : 26,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    '${localNumber(context, row.points)} '
                    '${L.of(context).lpUnit}',
                    style: TextStyle(
                      color: context.colors.background,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Where the month's awards stop.
class _Top10Line extends StatelessWidget {
  const _Top10Line();

  @override
  Widget build(BuildContext context) {
    Widget dashes() => Expanded(
      child: LayoutBuilder(
        builder: (context, box) {
          final count = (box.maxWidth / 8).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < count; i++)
                Container(width: 4, height: 1.5, color: AppColors.gold),
            ],
          );
        },
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 11),
      child: Row(
        children: [
          dashes(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              L.of(context).awardTop10,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          dashes(),
        ],
      ),
    );
  }
}

class _MonthRankRow extends StatelessWidget {
  const _MonthRankRow({required this.row, this.week = false});

  final MonthRow row;
  final bool week;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    // A week names nobody at its end: the rank under the name instead.
    final award = week ? null : awardForPlace(row.place);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showLifterPeek(
        context,
        id: row.id,
        username: row.username,
        initial: row.id.isEmpty ? demoLifterProfile(row.username) : null,
      ),
      child: _RowCard(
        child: Row(
          children: [
            _Position(position: row.place),
            const SizedBox(width: 11),
            _Initial(
              name: row.username,
              size: 40,
              fontSize: 17,
              avatarUrl: row.avatarUrl,
              mine: row.id == backend.me?.id,
              frame: row.tierIdx,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  NameWithLevel(
                    name: row.username,
                    xp: row.xp,
                    style: TextStyle(color: context.colors.text, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    award != null
                        ? awardName(l, award)
                        : tierLabel(l, row.tierIdx, row.divIdx),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: award != null
                          ? awardColour(context, award)
                          : context.colors.muted,
                      fontSize: 12,
                      fontWeight: award != null ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 11),
            _Points(lp: row.points, colour: context.colors.text),
          ],
        ),
      ),
    );
  }
}

/// This account on the month's board, and the one thing worth knowing about
/// it: what it would win, or how far it is from winning anything.
class _MonthSelfRow extends StatelessWidget {
  const _MonthSelfRow({
    required this.mine,
    required this.rows,
    required this.username,
    this.week = false,
  });

  final MonthPlace mine;
  final List<MonthRow> rows;
  final String username;
  final bool week;

  String _hint(BuildContext context) {
    final l = L.of(context);
    final place = mine.place;
    if (week) {
      // The week has no awards: how far from the top three, or there.
      if (place == null) return l.weekJoinHint;
      final third = rows.where((r) => r.place == 3).firstOrNull;
      if (place <= 3 || third == null) return l.weekInTop3;
      final gap = third.points - mine.points + 1;
      return l.weekToTop3(localNumber(context, gap < 1 ? 1 : gap));
    }
    if (place == null) return l.monthJoinHint;
    if (awardForPlace(place) case final award?) {
      return l.monthIfEndedNow(awardName(l, award));
    }
    // Past tenth, the gap to tenth. Level on points is not enough: ties go
    // to wins, so it takes one more than tenth has to be sure of passing.
    final tenth = rows.where((r) => r.place == 10).firstOrNull;
    if (tenth == null) return l.monthJoinHint;
    final gap = tenth.points - mine.points + 1;
    return l.monthToTop10(localNumber(context, gap < 1 ? 1 : gap));
  }

  @override
  Widget build(BuildContext context) {
    final place = mine.place;

    return _RowCard(
      borderColour: context.colors.brand,
      borderWidth: 1,
      child: Row(
        children: [
          if (place != null) ...[
            Text(
              localNumber(context, place),
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 14,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 11),
          ],
          _Initial(
            name: username,
            size: 40,
            fontSize: 17,
            avatarUrl: backend.me?.avatarUrl,
            frame: demoProfile.isRanked ? demoProfile.tierIdx : null,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: NameWithLevel(
                        name: username,
                        xp: demoProfile.xp,
                        style: TextStyle(
                          color: context.colors.text,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const _YouChip(),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _hint(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.colors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 11),
          _Points(lp: mine.points, colour: context.colors.brand),
        ],
      ),
    );
  }
}
