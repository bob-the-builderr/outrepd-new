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
import '../pill_strip.dart';
import '../player_avatar.dart' show PhotoOrLifter, decodedAt;
import '../ranking.dart';
import '../season.dart';
import '../subscription.dart';
import '../theme.dart';
import '../tier_frame.dart';
import '../widgets.dart';
import 'other_profile.dart';
import 'pro_parts.dart';
import 'shell.dart';

/// The three boards, on one strip (pick A, 2026-11-02). Your Tier went
/// then: this account's place on Overall is pinned under it anyway.
enum _Scope {
  /// The week's race: points won in ranked duels since Monday. Shown first,
  /// since a week is a race more people can win.
  thisWeek,

  /// The month's race: points won in ranked duels since the 1st. The one
  /// board everybody starts level on, whatever their rank, and the one with
  /// awards.
  thisMonth,

  /// Everyone, ranked by rating — the whole ladder in one list ("Overall").
  topPlayers,
}

/// Whose boards, from the button by the title: everybody's, the country's,
/// or only this account and its friends' (pick B, 2026-11-02).
enum _Place { world, country, friends }

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

  /// Whose boards: every board follows it, the week and the month as well
  /// as Overall (the country, 2026-10-29; friends, pick B 2026-11-02).
  _Place _place = _Place.world;

  /// The country the boards are filtered to, or null. None when the account
  /// has no country: there is no country board to show.
  String? get _country =>
      _place == _Place.country ? backend.me?.country : null;

  bool get _friends => _place == _Place.friends;

  void _switchPlace(_Place place) {
    if (place == _place) return;
    setState(() {
      _place = place;
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
    setState(() {
      _loading = true;
      if (!quiet) _error = null;
    });
    final friends = _friends;
    // An answer for the other place, after the button moved: dropped.
    bool stale() => !mounted || country != _country || friends != _friends;
    try {
      if (scope == _Scope.thisWeek) {
        // Both at once: one trip's wait rather than two (2026-11-04).
        final (place, rows) = await (
          backend.myWeekPlace(country: country),
          friends ? backend.friendsBoard() : backend.weekBoard(country: country),
        ).wait;
        if (stale()) return;
        unawaited(Looks.instance.fetch(rows.map((row) => row.id)));
        setState(() {
          _weekPlace = friends ? _amongFriends(place, rows) : place;
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
        final rows = friends
            ? await backend.friendsBoard(month: true)
            : await backend.monthBoard(country: country);
        // Nobody on it yet: last month's winners stand in, on the world's
        // board, the one with awards.
        final winners = rows.isEmpty && country == null && !friends
            ? await _readLastMonth()
            : null;
        if (stale()) return;
        unawaited(Looks.instance.fetch([
          ...rows.map((row) => row.id),
          ...?winners?.rows.map((row) => row.id),
        ]));
        setState(() {
          _monthPlace = friends ? _amongFriends(place, rows) : place;
          _month = rows;
          _lastMonth = winners;
          _fetchedAt[scope] = clock.now();
          _loading = false;
          _error = null;
        });
        return;
      }
      final rows = friends
          ? await backend.friendsLeaderboard()
          : await backend.leaderboard(country: country);
      // Below the hundred shown, the place still is one: asked for apart.
      // Among friends everybody is on the page.
      final global = !friends && !rows.any((row) => row.id == backend.me?.id)
          ? await backend.boardPosition(country: country)
          : null;
      if (stale()) return;
      unawaited(Looks.instance.fetch(rows.map((row) => row.id)));
      setState(() {
        _boards[scope] = rows;
        _globalPlace = global;
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

  /// This account among its friends: the whole board's answer for when the
  /// race ends and what it has scored, the place counted on the circle's
  /// own rows.
  MonthPlace? _amongFriends(MonthPlace? whole, List<MonthRow> rows) {
    if (whole == null) return null;
    final id = backend.me?.id;
    return MonthPlace(
      season: whole.season,
      endsAt: whole.endsAt,
      place: rows.where((row) => row.id == id).firstOrNull?.place,
      ofTotal: rows.length,
      points: whole.points,
      wins: whole.wins,
      played: whole.played,
    );
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
    if (!backend.available) return demoLeaderboard;
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

  /// Where this account sits on Overall, or null when that is not known.
  ///
  /// Known exactly whenever the account appears in the page that was
  /// fetched, and asked for apart below it. Never made up: a wrong position
  /// on the one row somebody looks for themselves on is worse than none.
  /// Offline, the sample profile's own global rank stands in — the same
  /// fallback every other screen already reads for it.
  int? get _myPosition {
    if (!backend.available) return demoProfile.globalRank;
    final id = backend.me?.id;
    final rows = _boards[_scope];
    if (id == null || rows == null) return null;
    final at = rows.indexWhere((row) => row.id == id);
    return at >= 0 ? at + 1 : _globalPlace;
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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      L.of(context).ranksTitle,
                      style: kPageTitle.copyWith(color: context.colors.text),
                    ),
                  ),
                  // Whose boards: a button by the title rather than a row of
                  // its own (pick A, 2026-11-02), with friends beside the
                  // world and the country (pick B).
                  if (backend.available)
                    _PlacePicker(
                      country: backend.me?.country,
                      place: _place,
                      onChanged: _switchPlace,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ScopeToggle(scope: _scope, onChanged: _switchTo),

            const SizedBox(height: 12),
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
                      onRefresh: _load,
                      country: countryLabel,
                      friends: _friends,
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
                        // Above the list on Overall: the link to how it
                        // counts, and who is on it.
                        itemCount: entries.length + 1,
                        itemBuilder: (context, i) => i == 0
                            ? const _BoardLine()
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
            // Not among friends: there this account is a row of the list,
            // picked out where it stands.
            if (me.isRanked && !(month && nothingYet) && !_friends)
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

/// Whose boards, for every board under it: the world, this account's
/// country, or its friends — a button by the title that opens the choice
/// (pick A, 2026-11-02; friends, pick B).
class _PlacePicker extends StatelessWidget {
  const _PlacePicker({
    required this.country,
    required this.place,
    required this.onChanged,
  });

  /// This account's country; null leaves the country out of the choice.
  final String? country;
  final _Place place;
  final ValueChanged<_Place> onChanged;

  String _label(BuildContext context, _Place of) => switch ((of, country)) {
    (_Place.country, final code?) =>
      '${countryFlag(code)} ${countryName(context, code)}',
    (_Place.friends, _) => '👥 ${L.of(context).tabFriends}',
    _ => '🌍 ${L.of(context).global}',
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        key: const Key('boardsPlace'),
        borderRadius: BorderRadius.circular(12),
        onTap: () => _pick(context),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  _label(context, place),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.expand_more, size: 18, color: colors.muted),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showModalBottomSheet<_Place>(
      context: context,
      backgroundColor: context.colors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (value, key) in [
                (_Place.world, 'boardsWorld'),
                if (country != null) (_Place.country, 'boardsCountry'),
                (_Place.friends, 'boardsFriends'),
              ])
                ListTile(
                  key: Key(key),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(
                    _label(context, value),
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: value == place
                      ? Icon(Icons.check, color: context.colors.brand)
                      : null,
                  onTap: () => Navigator.pop(context, value),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) onChanged(picked);
  }
}

/// Week, Month and Overall as one strip, the chosen one filled (pick A,
/// 2026-11-02). It was three tabs over a week/month switch.
class _ScopeToggle extends StatelessWidget {
  const _ScopeToggle({required this.scope, required this.onChanged});

  final _Scope scope;
  final ValueChanged<_Scope> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PillStrip<_Scope>(
        value: scope,
        onChanged: onChanged,
        options: [
          (_Scope.thisWeek, l.lengthWeek, const Key('lengthWeek')),
          (_Scope.thisMonth, l.lengthMonth, const Key('lengthMonth')),
          (_Scope.topPlayers, l.boardOverall, const Key('boardOverall')),
        ],
      ),
    );
  }
}

/// Under the strip, at the top of every board: when it ends, and the way to
/// how its points work against the far edge (pick A, 2026-11-02, and again
/// for the link's place). The rules were chips here, and who is on Overall
/// and how a tie goes a line of their own: both are in the sheet now.
class _BoardLine extends StatelessWidget {
  const _BoardLine({this.text, this.below});

  /// The line's words; none on Overall, where the link stands alone.
  final String? text;

  /// A second line under the first: the 20 Club on the month.
  final Widget? below;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The words take what the link leaves them; the link keeps its
          // size, up to a cap that a long language shortens it to.
          Row(
            children: [
              Expanded(
                child: Text(
                  text ?? '',
                  maxLines: 2,
                  style: TextStyle(color: colors.muted, fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 210),
                child: InkWell(
                  key: const Key('howPoints'),
                  onTap: () => showHowPoints(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, size: 16, color: colors.brand),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            L.of(context).howPointsWork,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.brand,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (below case final line?) ...[const SizedBox(height: 2), line],
        ],
      ),
    );
  }
}

/// How the boards count: the week's and the month's points, then the
/// rating Overall is ranked by, and who is on it.
Future<void> showHowPoints(BuildContext context) {
  final l = L.of(context);
  final colors = context.colors;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
        child: Column(
          key: const Key('howPointsSheet'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.howPointsWork,
              style: TextStyle(
                color: colors.text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              '${l.lengthWeek} · ${l.lengthMonth}',
              style: sectionLabelStyle(context),
            ),
            const SizedBox(height: 8),
            Wrap(
              key: const Key('boardRules'),
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final rule in [
                  l.boardRuleWin,
                  l.boardRuleLoss,
                  l.boardRuleStreak,
                ])
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceRaised,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      rule,
                      style: TextStyle(color: colors.text, fontSize: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            Text(l.boardOverall, style: sectionLabelStyle(context)),
            const SizedBox(height: 8),
            Text(
              l.lpMovesWithGap,
              style: TextStyle(color: colors.text, fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 6),
            Text(
              '${l.boardActiveNote} · ${l.boardTieNote}',
              style: TextStyle(color: colors.muted, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────── ranks among friends ─────────────────────────────

/// You and your friends by rating, on the Friends tab (pick B, 2026-11-07),
/// each with what the two of you have done against each other. A list of the
/// page, so it scrolls with the tab's own header: a sliver. Worked out here
/// from the list the tab already has, so it is as fresh as that list, and
/// counts every friend, where the Friends board on Ranks leaves out anybody
/// who has asked to be off the boards or has not been seen in a month.
/// Nobody without a rank yet has a place: they stand at the foot.
class FriendRanks extends StatelessWidget {
  const FriendRanks({super.key, required this.friends});

  final List<Friend> friends;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final me = demoProfile;
    final self = Friend(
      me.username,
      me.tierIdx,
      me.divIdx,
      me.lp,
      true,
      id: backend.me?.id ?? '',
      xp: me.xp,
      placementsDone: me.placementsDone,
    );
    final everybody = [self, ...friends];
    int rating(Friend f) => ratingOf(f.tierIdx, f.divIdx, f.lp);
    final ranked = everybody.where((f) => f.ranked).toList()
      ..sort((a, b) {
        final by = rating(b).compareTo(rating(a));
        return by != 0 ? by : a.username.compareTo(b.username);
      });
    final rows = [...ranked, ...everybody.where((f) => !f.ranked)];

    return SliverList.builder(
      itemCount: rows.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 9, left: 4),
            child: Text(
              self.ranked
                  ? l.friendsRankLine(
                      localNumber(context, ranked.indexOf(self) + 1),
                      localNumber(context, ranked.length),
                    )
                  : l.unranked,
              style: sectionLabelStyle(context),
            ),
          );
        }
        final friend = rows[i - 1];
        return _Slice(
          first: i == 1,
          last: i == rows.length,
          child: RiseIn(
            delay: staggered(i - 1),
            child: ListenableBuilder(
              listenable: Looks.instance,
              builder: (context, _) => _FriendRankRow(
                position: friend.ranked ? i : null,
                friend: friend,
                mine: identical(friend, self),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FriendRankRow extends StatelessWidget {
  const _FriendRankRow({
    required this.position,
    required this.friend,
    required this.mine,
  });

  /// Null for somebody with no rank yet.
  final int? position;
  final Friend friend;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final pro = Looks.instance.pro(friend.id);
    final muted = context.colors.muted;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: mine
          ? () => AppShell.goToProfile(context)
          : () => openLifter(
              context,
              id: friend.id,
              username: friend.username,
              avatarUrl: friend.avatarUrl,
              // A sample row has no id to fetch with.
              initial: friend.id.isEmpty
                  ? demoLifterProfile(friend.username)
                  : null,
            ),
      child: _RowCard(
        grouped: true,
        pro: pro,
        mine: mine,
        child: Row(
          children: [
            if (position case final place?)
              _Position(position: place)
            else
              const SizedBox(width: 30),
            const SizedBox(width: 11),
            _Initial(
              name: friend.username,
              size: 40,
              fontSize: 17,
              avatarUrl: friend.avatarUrl,
              mine: mine,
              frame: friend.ranked ? friend.tierIdx : null,
              id: friend.id,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: _Identity.line(
                username: friend.username,
                xp: friend.xp,
                trailing: mine
                    ? const _YouChip()
                    : pro
                    ? const ProChip(height: 16)
                    : null,
                line: mine
                    ? Text(
                        friend.ranked
                            ? tierLabel(L.of(context), friend.tierIdx, friend.divIdx)
                            : L.of(context).unranked,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: muted, fontSize: 12),
                      )
                    : _AgainstYou(friend: friend),
              ),
            ),
            const SizedBox(width: 11),
            if (friend.ranked)
              _Points(
                lp: ratingOf(friend.tierIdx, friend.divIdx, friend.lp),
                colour: mine ? context.colors.brand : context.colors.text,
                rating: true,
              )
            else
              Text('—', style: TextStyle(color: muted, fontSize: 17)),
          ],
        ),
      ),
    );
  }
}

/// You and them against each other, each in their colour. Somebody you have
/// never faced says so instead of "0 – 0".
class _AgainstYou extends StatelessWidget {
  const _AgainstYou({required this.friend});

  final Friend friend;

  /// The two words are lower case for the middle of a sentence.
  String _capital(String word) =>
      word.isEmpty ? word : word[0].toUpperCase() + word.substring(1);

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final words = TextStyle(color: colors.muted, fontSize: 12);
    if (!friend.hasPlayedYou) {
      return Text(
        l.neverPlayedYou,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: words,
      );
    }
    TextStyle score(Color colour) => TextStyle(
      color: colour,
      fontSize: 13,
      fontWeight: FontWeight.w800,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Text.rich(
      TextSpan(
        style: words,
        children: [
          TextSpan(text: '${_capital(l.h2hYou)} '),
          TextSpan(
            text: localNumber(context, friend.lossesVsYou),
            style: score(colors.brand),
          ),
          const TextSpan(text: ' – '),
          TextSpan(
            text: localNumber(context, friend.winsVsYou),
            style: score(colors.rival),
          ),
          TextSpan(text: ' ${_capital(l.h2hThem)}'),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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
      onTap: () => openLifter(
        context,
        id: entry.id,
        username: entry.username,
        avatarUrl: entry.avatarUrl,
        initial: entry.id.isEmpty ? demoLifterProfile(entry.username) : null,
      ),
      child: _RowCard(
        grouped: true,
        pro: Looks.instance.pro(entry.id),
        mine: entry.id.isNotEmpty && entry.id == backend.me?.id,
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
    this.mine = false,
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

  /// This account's own row in a board's card: a cream edge round it, as
  /// tall as the rows round it (4 + 1.5 + 6.5 = 12). Among friends it is
  /// not pinned below, it is here (pick B, 2026-11-02).
  final bool mine;

  @override
  Widget build(BuildContext context) {
    if (grouped && !pro && mine) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 6.5),
          decoration: BoxDecoration(
            color: context.colors.brand.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.brand, width: 1.5),
          ),
          child: child,
        ),
      );
    }
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

  /// The tier to frame the picture in, on a row or the podium. Null for a
  /// bare picture.
  final int? frame;

  /// Whose picture: what [Looks] knows them by. Empty for a sample row.
  final String id;

  @override
  Widget build(BuildContext context) {
    final out = Looks.instance.poppingOut(id, name, photo: _wearsPhoto());
    final picture = out != null ? PopOutLifter(out, size: size) : _picture(context);
    if (frame == null) return picture;
    return TierFrame(tierIdx: frame, size: size, child: picture);
  }

  /// Whether a photo is the picture: this phone's own for this account,
  /// the uploaded one for anybody else.
  bool _wearsPhoto() {
    if (mine) {
      final own = avatar.picture;
      return own != null && own is! LifterPicture;
    }
    return avatarUrl?.isNotEmpty ?? false;
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
    final photo = own ?? pictureAt(avatarUrl);
    if (photo == null || photo is LifterPicture) return fallback;
    return ClipOval(
      // As in PlayerAvatar: the photo, with the lifter standing in only once
      // it has been on its way half a second.
      child: PhotoOrLifter(
        image: decodedAt(context, photo, size),
        size: size,
        lifter: fallback,
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
  }) : line = null;

  /// With [line] under the name in place of the rank and record.
  const _Identity.line({
    required this.username,
    required Widget this.line,
    this.trailing,
    this.xp,
  }) : tierIdx = 0,
       divIdx = 0,
       wins = 0,
       losses = 0;

  final String username;
  final int tierIdx;
  final int divIdx;
  final int wins;
  final int losses;
  final Widget? trailing;
  final Widget? line;

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
        line ??
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

  /// A rating (Overall) rather than the season's points.
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
    this.country,
    this.friends = false,
    this.lastMonth,
  });

  final List<MonthRow> rows;
  final MonthPlace mine;
  final Future<void> Function() onRefresh;

  /// Last month's top ten, shown while this month's board is empty.
  final MonthWinners? lastMonth;

  /// The week's board rather than the month's: no awards at its end.
  final bool week;

  /// The country's board, by its name, rather than the world's. No awards
  /// on it: those are the world's month (2026-10-29).
  final String? country;

  /// Among this account and its friends: no awards on it either.
  final bool friends;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final podium = rows.take(3).toList();
    final rest = rows.skip(3).toList();
    // Where the awards stop: only on the world's month.
    final awards = country == null && !friends;
    final awardLine = !week && awards;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        children: [
          _SeasonHeader(mine: mine, week: week),
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
                    awards: awards,
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

/// The week's or the month's line: when it ends, and on the month how far
/// the 20 Club badge is. The rules went to [showHowPoints] (pick A).
class _SeasonHeader extends StatelessWidget {
  const _SeasonHeader({required this.mine, this.week = false});

  final MonthPlace mine;
  final bool week;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final played = mine.played;
    final earned = played >= kRegularDuels;

    return _BoardLine(
      text: '${week ? l.thisWeek : monthName(context, mine.season)} · '
          '${monthLeft(context, mine.endsAt, clock.now())}',
      below: week
          ? null
          : Text(
              earned
                  ? l.monthRegularEarned
                  : l.monthRegularProgress(
                      '${localNumber(context, played)}/'
                      '${localNumber(context, kRegularDuels)}',
                    ),
              style: TextStyle(
                color: earned ? context.colors.brand : context.colors.muted,
                fontSize: 13,
              ),
            ),
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

  // Drawn again when the looks arrive, after the board: a Pro on the podium
  // sat in a plain circle, where the rows below them broke out.
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Looks.instance,
    builder: (context, _) => _place(context),
  );

  Widget _place(BuildContext context) {
    final first = row.place == 1;
    final medal = switch (row.place) {
      1 => AppColors.gold,
      2 => AppColors.silver,
      _ => AppColors.bronze,
    };
    final avatar = first ? 58.0 : 46.0;
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
      onTap: () => openLifter(
        context,
        id: row.id,
        username: row.username,
        avatarUrl: row.avatarUrl,
        initial: row.id.isEmpty ? demoLifterProfile(row.username) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (first)
            const Icon(Icons.emoji_events, color: AppColors.gold, size: 26),
          // In the place's tier frame, as on every row (the user,
          // 2026-11-02); the step under it wears the medal's colour. Shrunk
          // to its third of the podium on a narrow phone.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: _Initial(
              name: row.username,
              size: avatar,
              fontSize: first ? 24 : 19,
              avatarUrl: row.avatarUrl,
              mine: row.id == backend.me?.id,
              frame: row.tierIdx,
              id: row.id,
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
      onTap: () => openLifter(
        context,
        id: row.id,
        username: row.username,
        avatarUrl: row.avatarUrl,
        initial: row.id.isEmpty ? demoLifterProfile(row.username) : null,
      ),
      child: _RowCard(
        grouped: true,
        pro: Looks.instance.pro(row.id),
        mine: row.id.isNotEmpty && row.id == backend.me?.id,
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
