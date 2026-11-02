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
import '../country_names.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../lifter/lifter_view.dart';
import '../lifter/looks.dart';
import '../lifter/my_lifter.dart';
import '../motion.dart';
import '../ranking.dart';
import '../season.dart';
import '../subscription.dart';
import '../theme.dart';
import '../tier_frame.dart';
import '../widgets.dart';
import 'other_profile.dart';
import 'pro_parts.dart';
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

  /// Last month's top ten, read while this month's board is empty.
  MonthWinners? _lastMonth;
  List<MonthRow>? _week;
  MonthPlace? _weekPlace;

  /// This account's place on the whole board, for when it is below the
  /// hundred rows the board shows.
  int? _globalPlace;

  /// The country's boards rather than the world's: every scope, the week and
  /// the month as well as Top Players and Your Tier (the user, 2026-10-29).
  bool _inCountry = false;

  /// The country the boards are filtered to, or null for the world's. None
  /// when the account has no country: there is no country board to show.
  String? get _country => _inCountry ? backend.me?.country : null;

  void _switchCountry(bool inCountry) {
    if (inCountry == _inCountry) return;
    setState(() {
      _inCountry = inCountry;
      // Every board was the other place's: none of it stands.
      _boards.clear();
      _fetchedAt.clear();
      _week = null;
      _weekPlace = null;
      _month = null;
      _monthPlace = null;
      _lastMonth = null;
      _globalPlace = null;
      _error = null;
    });
    _load();
  }

  /// Last month's top ten, or nothing. This month's board is right without
  /// it, so a read that fails leaves the board's own message, not an error.
  Future<MonthWinners?> _readLastMonth() async {
    try {
      return await backend.lastMonthWinners();
    } on Object catch (error) {
      debugPrint("Could not read last month's winners: $error");
      return null;
    }
  }

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
    final country = _country;
    final me = demoProfile;
    setState(() {
      _loading = true;
      if (!quiet) _error = null;
    });
    // An answer for the other place, after the toggle moved: dropped.
    bool stale() => !mounted || country != _country;
    try {
      if (scope == _Scope.thisWeek) {
        final place = await backend.myWeekPlace(country: country);
        final rows = await backend.weekBoard(country: country);
        if (stale()) return;
        unawaited(Looks.instance.fetch(rows.map((row) => row.id)));
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
        final place = await backend.myMonthPlace(country: country);
        final rows = await backend.monthBoard(country: country);
        // Nobody on it yet: last month's winners stand in, on the world's
        // board, the one with awards.
        final winners = rows.isEmpty && country == null
            ? await _readLastMonth()
            : null;
        if (stale()) return;
        unawaited(Looks.instance.fetch([
          ...rows.map((row) => row.id),
          ...?winners?.rows.map((row) => row.id),
        ]));
        setState(() {
          _monthPlace = place;
          _month = rows;
          _lastMonth = winners;
          _fetchedAt[scope] = clock.now();
          _loading = false;
          _error = null;
        });
        return;
      }
      final rows = await backend.leaderboard(
        country: country,
        tierIdx: scope == _Scope.yourTier ? me.tierIdx : null,
        divIdx: scope == _Scope.yourTier ? me.divIdx : null,
      );
      // Below the hundred shown, the place still is one: asked for apart.
      final global = scope == _Scope.topPlayers &&
              !rows.any((row) => row.id == backend.me?.id)
          ? await backend.boardPosition(country: country)
          : null;
      if (stale()) return;
      unawaited(Looks.instance.fetch(rows.map((row) => row.id)));
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
    // The country's name while its boards are shown; null on the world's.
    final countryLabel = _country == null
        ? null
        : countryName(context, _country!);

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
                  L.of(context).ranksTitle,
                  style: kPageTitle.copyWith(color: context.colors.text),
                ),
              ),
            ),

            // The world's boards or the country's, above everything else:
            // it changes every board under it. Only with a country to show.
            if (backend.available && backend.me?.country != null) ...[
              const SizedBox(height: 12),
              _PlaceToggle(
                country: backend.me!.country!,
                inCountry: _inCountry,
                onChanged: _switchCountry,
              ),
            ],
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
                      lastMonth: week ? null : _lastMonth,
                      onLength: (toWeek) => _switchTo(
                        toWeek ? _Scope.thisWeek : _Scope.thisMonth,
                      ),
                      onRefresh: _load,
                      country: countryLabel,
                    )
                  : entries.isEmpty
                  ? EmptyState(
                      icon: Icons.emoji_events_outlined,
                      title: L.of(context).noRanksYet,
                      body: L.of(context).noRanksYetBody,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        // Above the list on Top Players: who is on it, and
                        // how a tie is settled.
                        itemCount: entries.length + 1,
                        itemBuilder: (context, i) => i == 0
                            ? const _BoardNote()
                            : _Slice(
                                first: i == 1,
                                last: i == entries.length,
                                child: RiseIn(
                                  delay: staggered(i - 1),
                                  child: ListenableBuilder(
                                    listenable: Looks.instance,
                                    builder: (context, _) => _RankRow(
                                      position: i,
                                      entry: entries[i - 1],
                                    ),
                                  ),
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
                        country: countryLabel,
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

/// The world or this account's country, for every board under it.
class _PlaceToggle extends StatelessWidget {
  const _PlaceToggle({
    required this.country,
    required this.inCountry,
    required this.onChanged,
  });

  final String country;
  final bool inCountry;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget half(bool value, String label, Key key) {
      final selected = value == inCountry;
      return Expanded(
        child: InkWell(
          key: key,
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(11),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: selected ? colors.surfaceRaised : null,
              borderRadius: BorderRadius.circular(11),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: selected ? colors.text : colors.muted,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : null,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            half(false, '🌍 ${L.of(context).global}', const Key('boardsWorld')),
            half(
              true,
              '${countryFlag(country)} ${countryName(context, country)}',
              const Key('boardsCountry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The three boards as one strip, the chosen one filled (direction B,
/// 2026-11-02). They were three outlined pills.
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
          borderRadius: BorderRadius.circular(11),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
            decoration: BoxDecoration(
              color: selected ? context.colors.brand : null,
              borderRadius: BorderRadius.circular(11),
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
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            pill(_Scope.thisWeek, l.thisSeason),
            const SizedBox(width: 4),
            pill(_Scope.topPlayers, l.topPlayers),
            const SizedBox(width: 4),
            pill(_Scope.yourTier, l.yourTier),
          ],
        ),
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
              color: selected ? context.colors.brand : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected
                    ? context.colors.background
                    : context.colors.muted,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            half(true, l.lengthWeek),
            const SizedBox(width: 4),
            half(false, l.lengthMonth),
          ],
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
      padding: const EdgeInsets.only(bottom: 10),
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
        grouped: true,
        pro: Looks.instance.pro(entry.id),
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
              id: entry.id,
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
                trailing: Looks.instance.pro(entry.id)
                    ? const ProChip(height: 16)
                    : null,
              ),
            ),
            const SizedBox(width: 11),
            _Points(
              lp: ratingOf(entry.tierIdx, entry.divIdx, entry.lp),
              colour: context.colors.text,
              rating: true,
            ),
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
      borderWidth: 1.5,
      pro: Subscription.instance.active,
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
            mine: true,
            id: backend.me?.id ?? '',
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
          _Points(
            lp: ratingOf(tierIdx, divIdx, lp),
            colour: context.colors.brand,
            rating: true,
          ),
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
    this.pro = false,
    this.grouped = false,
  });

  final Widget child;

  /// An edge round the card; none without one.
  final Color? borderColour;
  final double borderWidth;

  /// A Pro's row: a holo edge, a faint holo wash, and the shine passing
  /// over it now and then (the user's pick, 2026-11-01).
  final bool pro;

  /// A row in a board's card ([_Slice]) rather than a card of its own
  /// (direction B, 2026-11-02): no card is drawn, and a Pro's row is a holo
  /// card set into the board's, as tall as the rows round it.
  final bool grouped;

  @override
  Widget build(BuildContext context) {
    if (grouped && !pro) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        child: child,
      );
    }
    if (pro) {
      // In a board's card: 4 + 1.5 + 6.5 = the 12 a plain row stands off by.
      final card = HoloEdge(
        radius: grouped ? 12 : 16,
        width: 1.5,
        child: ShineBand(
          strength: 0.16,
          child: DecoratedBox(
            decoration: BoxDecoration(color: context.colors.surface),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [for (final c in kHolo) c.withValues(alpha: 0.07)],
                ),
              ),
              child: Padding(
                padding: grouped
                    ? const EdgeInsets.symmetric(horizontal: 7.5, vertical: 6.5)
                    : const EdgeInsets.symmetric(horizontal: 11.5, vertical: 12.5),
                child: child,
              ),
            ),
          ),
        ),
      );
      return grouped
          ? Padding(padding: const EdgeInsets.all(4), child: card)
          : card;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: borderColour == null
            ? null
            : Border.all(color: borderColour!, width: borderWidth),
      ),
      child: child,
    );
  }
}

/// One row's share of a board's card (direction B, 2026-11-02): the card's
/// top corners on the [first], its bottom ones on the [last], and a hairline
/// from the name on above every row but the first. Drawn a row at a time so
/// the list stays lazy, and outside the row's rise-in, so the card stands
/// whole while the rows rise into it.
class _Slice extends StatelessWidget {
  const _Slice({required this.first, required this.last, required this.child});

  final bool first;
  final bool last;
  final Widget child;

  /// From the card's edge to the name: 13 + 30 + 11 + 40 + 11.
  static const _hairlineStart = 105.0;

  @override
  Widget build(BuildContext context) {
    const round = Radius.circular(16);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: first ? round : Radius.zero,
          bottom: last ? round : Radius.zero,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!first)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: _hairlineStart),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: context.colors.border,
              ),
            ),
          child,
        ],
      ),
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
      decoration: medal == null
          ? null
          : BoxDecoration(shape: BoxShape.circle, color: medal),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          localNumber(context, position),
          style: TextStyle(
            color: medal == null
                ? context.colors.muted
                : context.colors.background,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
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
    this.id = '',
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

  /// Whose picture: what [Looks] knows them by. Empty for a sample row.
  final String id;

  @override
  Widget build(BuildContext context) {
    final looks = Looks.instance;
    final made = looks.lifter(id);
    final picture = id.isNotEmpty && looks.pro(id) && made != null
        ? PopOutLifter(made, size: size)
        : _picture(context);
    if (frame == null) return picture;
    return TierFrame(tierIdx: frame, size: size, child: picture);
  }

  Widget _picture(BuildContext context) {
    final own = mine ? avatar.picture : null;
    // No photo: the lifter. This account's own made one, drawn from here;
    // anybody else's, the one their name gives.
    final fallback = LifterCircle(
      name: name,
      size: size,
      lifter: own is LifterPicture ? own.lifter : null,
    );
    final url = avatarUrl;
    if ((own == null && url == null) || own is LifterPicture) return fallback;
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
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
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
  const _Points({required this.lp, required this.colour, this.rating = false});

  final int lp;
  final Color colour;

  /// A rating (Top Players, Your Tier) rather than the season's points.
  final bool rating;

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
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          rating ? L.of(context).ratingUnit : L.of(context).ptsUnit,
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
        style: TextStyle(
          color: context.colors.background,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
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
    this.country,
    this.lastMonth,
  });

  final List<MonthRow> rows;
  final MonthPlace mine;
  final Future<void> Function() onRefresh;

  /// Last month's top ten, shown while this month's board is empty.
  final MonthWinners? lastMonth;

  /// The week's board rather than the month's: no awards at its end.
  final bool week;

  /// Week or month, from the switch at the top.
  final ValueChanged<bool>? onLength;

  /// The country's board, by its name, rather than the world's. No awards
  /// on it: those are the world's month (2026-10-29).
  final String? country;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final podium = rows.take(3).toList();
    final rest = rows.skip(3).toList();
    // Where the awards stop: only on the world's month.
    final awardLine = !week && country == null;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        children: [
          if (onLength case final onLength?) ...[
            _LengthSwitch(week: week, onChanged: onLength),
            const SizedBox(height: 12),
          ],
          _SeasonHeader(mine: mine, week: week, country: country),
          if (rows.isEmpty && (lastMonth?.rows.isNotEmpty ?? false))
            _LastMonth(winners: lastMonth!)
          else if (rows.isEmpty)
            EmptyState(
              icon: Icons.calendar_month_outlined,
              title: week ? l.weekEmptyTitle : l.monthEmptyTitle,
              body: week ? l.weekEmptyBody : l.monthEmptyBody,
            )
          else ...[
            const SizedBox(height: 14),
            _Podium(rows: podium),
            const SizedBox(height: 12),
            for (final (i, row) in rest.indexed) ...[
              if (row.place == 11 && awardLine) ...[
                const SizedBox(height: 12),
                const _Top10Line(),
              ],
              _Slice(
                first: i == 0 || (row.place == 11 && awardLine),
                last: i == rest.length - 1 ||
                    (rest[i + 1].place == 11 && awardLine),
                child: RiseIn(
                  delay: staggered(row.place - 3),
                  child: _MonthRankRow(
                    row: row,
                    week: week,
                    awards: country == null,
                  ),
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
  const _SeasonHeader({required this.mine, this.week = false, this.country});

  final MonthPlace mine;
  final bool week;

  /// The country's name, on its own board.
  final String? country;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final played = mine.played;
    final earned = played >= kRegularDuels;

    return Column(
      children: [
        Text(
          '${country == null ? '' : '$country · '}'
          '${week ? l.thisWeek : monthName(context, mine.season)} · '
          '${monthLeft(context, mine.endsAt, clock.now())}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (!week) ...[
          const SizedBox(height: 4),
          Text(
            earned
                ? l.monthRegularEarned
                : l.monthRegularProgress(
                    '${localNumber(context, played)}/'
                    '${localNumber(context, kRegularDuels)}',
                  ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: earned ? context.colors.brand : context.colors.muted,
              fontSize: 13,
            ),
          ),
        ],
        const SizedBox(height: 8),
        // What the season's points are, where they are counted (2026-11-02).
        Wrap(
          key: const Key('boardRules'),
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final rule in [
              l.boardRuleWin,
              l.boardRuleLoss,
              l.boardRuleStreak,
            ])
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: context.colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  rule,
                  style: TextStyle(color: context.colors.text, fontSize: 13),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// First in the middle and tallest, second to its left, third to its right —
/// the way a podium stands, whichever way the language reads.
/// The new month before anybody has scored in it: a word on that with the way
/// to a match, then last month's top ten as it finished (the user's pick A,
/// 2026-11-01). The month's own board takes its place with the first ranked
/// duel won.
class _LastMonth extends StatelessWidget {
  const _LastMonth({required this.winners});

  final MonthWinners winners;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final podium = winners.rows.where((row) => row.place <= 3).toList();
    final rest = winners.rows.where((row) => row.place > 3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 14),
        _RowCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.monthEmptyTitle,
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l.monthEmptyBody,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                key: const Key('lastMonthPlay'),
                onPressed: () => AppShell.goToMatch(context),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(l.playShort),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: AppColors.gold, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                l
                    .monthWinners(monthName(context, winners.season))
                    .toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _Podium(rows: podium, awards: true),
        const SizedBox(height: 12),
        for (final (i, row) in rest.indexed)
          _Slice(
            first: i == 0,
            last: i == rest.length - 1,
            child: _MonthRankRow(row: row),
          ),
      ],
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({required this.rows, this.awards = false});

  final List<MonthRow> rows;

  /// A finished month's podium: each step says what its place won.
  final bool awards;

  @override
  Widget build(BuildContext context) {
    MonthRow? at(int place) => rows.where((r) => r.place == place).firstOrNull;

    Widget slot(int place) => Expanded(
      child: switch (at(place)) {
        // First up first, then second and third either side of it.
        final row? => PopIn(
          delay: Duration(milliseconds: place == 1 ? 0 : 90 * place),
          child: _PodiumPlace(row: row, award: awards),
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
  const _PodiumPlace({required this.row, this.award = false});

  final MonthRow row;

  /// Whether the step names what the place won, under its LP.
  final bool award;

  @override
  Widget build(BuildContext context) {
    final first = row.place == 1;
    final medal = switch (row.place) {
      1 => AppColors.gold,
      2 => AppColors.silver,
      _ => AppColors.bronze,
    };
    final avatar = first ? 66.0 : 52.0;
    // A step that names its award is a line taller, so the line fits rather
    // than shrinking the number with it.
    final step = switch (row.place) {
      1 => 92.0,
      2 => 70.0,
      _ => 56.0,
    };
    final block = award ? step + 16 : step;
    final won = award ? awardForPlace(row.place) : null;

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
                    L.of(context).ptsAmount(localNumber(context, row.points)),
                    style: TextStyle(
                      color: context.colors.background,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (won != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      awardName(L.of(context), won).toUpperCase(),
                      style: TextStyle(
                        color: context.colors.background,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
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
  const _MonthRankRow({
    required this.row,
    this.week = false,
    this.awards = true,
  });

  final MonthRow row;
  final bool week;

  /// Whether a place here wins anything: not on a country's board.
  final bool awards;

  // Drawn again when the looks arrive: a Pro's row turns holo.
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Looks.instance,
    builder: (context, _) => _row(context),
  );

  Widget _row(BuildContext context) {
    final l = L.of(context);
    // A week names nobody at its end: the rank under the name instead.
    final award = week || !awards ? null : awardForPlace(row.place);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showLifterPeek(
        context,
        id: row.id,
        username: row.username,
        initial: row.id.isEmpty ? demoLifterProfile(row.username) : null,
      ),
      child: _RowCard(
        grouped: true,
        pro: Looks.instance.pro(row.id),
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
              id: row.id,
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
                          name: row.username,
                          xp: row.xp,
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (Looks.instance.pro(row.id)) ...[
                        const SizedBox(width: 6),
                        const ProChip(height: 16),
                      ],
                    ],
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
    this.country,
  });

  final MonthPlace mine;
  final List<MonthRow> rows;
  final String username;
  final bool week;

  /// The country's name, on its own board, where no award is at stake.
  final String? country;

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
    // On a country's board no award is at stake — they are the world's —
    // so the top ten is just the top ten.
    if (country case final name?) {
      if (place <= 10) return l.topTenIn(name);
    } else if (awardForPlace(place) case final award?) {
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
      borderWidth: 1.5,
      pro: Subscription.instance.active,
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
            mine: true,
            id: backend.me?.id ?? '',
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
                          fontWeight: FontWeight.w600,
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
