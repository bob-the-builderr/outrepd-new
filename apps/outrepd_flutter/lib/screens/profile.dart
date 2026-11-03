/// The profile.
///
/// A record of what somebody has done, arranged so the parts they can move are
/// the parts that stand out. Three rules here are about people rather than
/// layout:
///
///   * the local rank sits beside the global one, at the same size. Global
///     says how far there is to go; local is the one most people can actually
///     move, and for many it is the only one that ever feels within reach;
///   * best set leads the grid, in the colour that means "you". It is the only
///     figure here a single good session can change;
///   * there is no weight or volume anywhere. This app counts push-ups, and a
///     kilo total would be a number nobody could act on.
library;


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../avatar.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../lifter/looks.dart';
import '../lifter/my_lifter.dart';
import '../motion.dart';
import '../country_names.dart';
import '../rank_card.dart';
import '../rewards.dart';
import '../player_avatar.dart';
import '../season.dart';
import '../subscription.dart';
import '../theme.dart';
import '../widgets.dart';
import '../worn_title.dart';
import 'avatar_picker.dart';
import 'awards.dart';
import 'cover_parts.dart';
import 'level.dart';
import 'match_history.dart';
import 'rank_screen.dart';
import 'ranks.dart' show kBoardFreshFor;
import 'settings.dart';
import 'shell.dart' show AppShell, shownTab;
import 'share_card.dart';
import 'username_editor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Where this account actually sits on each board, once the server has
  /// said. Null until then, and null for good if there is no answer — an
  /// account still in placements is not on a board at all.
  int? _globalPosition;
  int? _localPosition;

  /// Awards from finished months, newest first. Empty until fetched, and for
  /// the many who have none — the card only appears once there is one.
  List<SeasonAward> _seasonAwards = const [];

  /// When the places were last read. Null once this account's own duel has
  /// moved them, so the next look reads them again.
  DateTime? _positionsAt;

  @override
  void initState() {
    super.initState();
    _loadPositions();
    _loadSeasonAwards();
    if (backend.available) {
      shownTab.addListener(_onShowing);
      Career.instance.addListener(_onOwnResult);
    }
  }

  @override
  void dispose() {
    shownTab.removeListener(_onShowing);
    Career.instance.removeListener(_onOwnResult);
    super.dispose();
  }

  /// Opened: the places again, if a duel has moved them or they are a while
  /// old — other people's duels move them too.
  void _onShowing() {
    if (shownTab.value != AppShell.profileTabIndex) return;
    final at = _positionsAt;
    if (at == null || DateTime.now().difference(at) > kBoardFreshFor) {
      _loadPositions();
    }
  }

  void _onOwnResult() {
    _positionsAt = null;
    if (shownTab.value == AppShell.profileTabIndex) _onShowing();
  }

  Future<void> _loadSeasonAwards() async {
    if (!backend.available) return;
    try {
      final awards = await backend.mySeasonAwards();
      if (mounted) setState(() => _seasonAwards = awards);
    } on Object catch (error) {
      debugPrint('Could not read the season awards: $error');
    }
  }

  Future<void> _loadPositions() async {
    if (!backend.available) return;
    try {
      // Both at once: they are two independent questions, and asking them in
      // turn doubles how long the cards sit blank.
      final country = backend.me?.country;
      final places = await Future.wait([
        backend.boardPosition(),
        // No country on the account, no country board to be on. Asking with
        // none is asking for the global place again, and the country card
        // showed it as though it were the country's.
        if (country != null)
          backend.boardPosition(country: country)
        else
          Future<int?>.value(),
      ]);
      if (!mounted) return;
      setState(() {
        _globalPosition = places.first;
        _localPosition = places.last;
        _positionsAt = DateTime.now();
      });
    } on Object catch (error) {
      // A position nobody could fetch is left blank rather than guessed at.
      debugPrint('Could not read the board position: $error');
    }
  }

  Future<void> _open(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final p = demoProfile;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            // The cover behind the top of the profile, while Pro.
            Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 250,
                  child: ListenableBuilder(
                    listenable: Listenable.merge([MyCover.instance, Subscription.instance]),
                    builder: (context, _) => ProfileCover(
                      cover: Subscription.instance.active ? MyCover.instance.cover : null,
                    ),
                  ),
                ),
                Column(
                  children: [
            _Header(
              onShare: () => showShareCardSheet(
                context,
                data: ShareCardData(
                  username: p.username,
                  tierIdx: p.tierIdx,
                  divIdx: p.divIdx,
                  lp: p.lp,
                  wins: p.wins,
                  losses: p.losses,
                  bestSet: p.bestSet,
                  winStreak: p.winStreak,
                  globalPlace: backend.available ? _globalPosition : p.globalRank,
                  country: p.country,
                  countryPlace: backend.available ? _localPosition : p.localRank,
                  avatarUrl: backend.me?.avatarUrl,
                  xp: p.xp,
                  title: rewards.worn,
                  pro: Subscription.instance.active,
                  cover: MyCover.instance.cover,
                ),
              ),
              onSettings: () => _open(const SettingsScreen()),
              onCover: () => showCoverPicker(context),
            ),
            _Identity(
              profile: p,
              onTapRank: () => _open(RankScreen(profile: p)),
            ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: XpCard(xp: p.xp),
            ),
            const SizedBox(height: 10),
            _Stats(
              profile: p,
              global: _globalPosition,
              local: _localPosition,
            ),
            if (_seasonAwards.isNotEmpty) ...[
              const SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardLabel(L.of(context).monthlyAwards),
                      const SizedBox(height: 8),
                      SeasonAwardChips(awards: _seasonAwards),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 18),
            const _WeekChart(),
            const SizedBox(height: 18),
            _Recent(onViewAll: () => _open(const MatchHistoryScreen())),
            const SizedBox(height: 12),
            _AchievementsRow(onTap: () => _open(const AwardsScreen())),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────── header ─────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.onShare,
    required this.onSettings,
    required this.onCover,
  });

  final VoidCallback onShare;
  final VoidCallback onSettings;

  /// The cover picker: Pro's, open to everybody to look at.
  final VoidCallback onCover;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IconAction(
            icon: Icons.ios_share,
            tooltip: L.of(context).shareProfile,
            onTap: onShare,
          ),
          Row(
            children: [
              _IconAction(
                key: const Key('coverButton'),
                icon: Icons.wallpaper_outlined,
                tooltip: L.of(context).coverTitle,
                onTap: onCover,
              ),
              const SizedBox(width: 8),
              _IconAction(
                icon: Icons.settings_outlined,
                tooltip: L.of(context).settings,
                onTap: onSettings,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 19, color: context.colors.muted),
        ),
      ),
    );
  }
}

// ─────────────────────────────── identity ────────────────────────────────────

class _Identity extends StatelessWidget {
  const _Identity({required this.profile, required this.onTapRank});

  final Profile profile;
  final VoidCallback onTapRank;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      children: [
        // The badge overlaps the avatar rather than sitting in a chip of its
        // own. It belongs to the person, and hanging it off their picture says
        // that in a way a separate row cannot.
        //
        // Listens to `avatar` on its own rather than through Career, which
        // this screen already rebuilds on — a picked photo is a change
        // nothing about a career tracks.
        ListenableBuilder(
          listenable: Listenable.merge([avatar, MyLifter.instance, Subscription.instance]),
          builder: (context, _) => PlayerAvatar(
            name: profile.username,
            tierIdx: profile.tierIdx,
            image: avatar.picture,
            // A Pro's lifter is alive in its frame.
            alive: Subscription.instance.active,
            size: 78,
            onTap: () => showAvatarPicker(context, profile.tierIdx),
            onBadgeTap: onTapRank,
          ),
        ),

        const SizedBox(height: 10),
        InkWell(
          onTap: () => showUsernameEditor(context),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              profile.username,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // The code a friend adds this account by without ever needing the
        // name above — see the comment on friend_code in schema.sql. Shown
        // with the '#' the stored value never has, and copied the same way.
        // Copy, or send it on with an invite — a code only ever gets a friend
        // by leaving this phone.
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: '#${profile.friendCode}'),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.codeCopied),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#${profile.friendCode}',
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.copy, size: 11, color: context.colors.faint),
                  ],
                ),
              ),
            ),
            InkWell(
              key: const Key('shareFriendCode'),
              onTap: () => shareFriendCode(context, profile.friendCode),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Icon(
                  Icons.share_outlined,
                  size: 13,
                  color: context.colors.faint,
                  semanticLabel: l.shareThisCode,
                ),
              ),
            ),
          ],
        ),

        // Worn beside the name, because that is the one place earning a
        // title was ever meant to show — see [Rewards.wearing]. The first
        // thing earned is worn automatically, so this is empty only for an
        // account with nothing unlocked yet.
        if (rewards.worn case final title?) ...[
          const SizedBox(height: 1),
          WornTitle(title: title),
        ],

        const SizedBox(height: 12),
        // The rank as one number on a card in its tier's colours (pick A,
        // 2026-11-02), wearing its tier's frame (pick A, 2026-11-03), which
        // brings its own room either side for the wings. It was a muted line
        // over a thin bar.
        RankCard(
          tierIdx: profile.tierIdx,
          divIdx: profile.divIdx,
          lp: profile.lp,
          onTap: onTapRank,
        ),
      ],
    );
  }
}

// ────────────────────────── the card every block uses ────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // No edge, the app's corners (direction B, 2026-11-02).
    final content = Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: content,
    );
  }
}

/// The small label a card or a number is titled with: as written, not
/// shouted (direction B, 2026-11-02).
class _CardLabel extends StatelessWidget {
  const _CardLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: context.colors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ──────────────────────────────── the numbers ────────────────────────────────

/// The six numbers in one card, a hairline between them (direction B,
/// 2026-11-02): where this account stands, then what it has done. They were
/// six cards of their own.
class _Stats extends StatelessWidget {
  const _Stats({required this.profile, this.global, this.local});

  final Profile profile;

  /// The real positions, when the server has given them. With no server they
  /// fall back to the sample profile's, which is what keeps the layout worth
  /// looking at before there is anybody to be ranked against.
  final int? global;
  final int? local;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final onServer = backend.available;
    final line = context.colors.border;

    // A row of three, the hairlines between them stopping short of the
    // card's edge and meeting the one across the middle.
    Widget row(List<Widget> cells, {required bool top}) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, cell) in cells.indexed) ...[
            if (i > 0)
              VerticalDivider(
                width: 1,
                thickness: 0.5,
                color: line,
                indent: top ? 14 : 0,
                endIndent: top ? 0 : 14,
              ),
            Expanded(child: cell),
          ],
        ],
      ),
    );

    // Null while it is being fetched, and null for good when there is no
    // position to show — an account still in placements is not on the
    // board. A dash then, rather than a number made up.
    Widget place(String label, int? position) => _Stat(
      label: label,
      value: position == null
          ? '—'
          : l.rankPosition(localNumber(context, position)),
      colour: position == null ? context.colors.muted : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        key: const Key('profileStats'),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            row(top: true, [
              place(l.global, onServer ? global : profile.globalRank),
              place(
                countryName(context, profile.country),
                onServer ? local : profile.localRank,
              ),
              CountUp(
                value: profile.bestSet,
                builder: (context, shown) => _Stat(
                  label: l.bestSet,
                  value: localNumber(context, shown),
                  // The one number a single good session can move, so it is
                  // the one wearing the colour that means "you".
                  colour: context.colors.brand,
                ),
              ),
            ]),
            Divider(
              height: 1,
              thickness: 0.5,
              color: line,
              indent: 14,
              endIndent: 14,
            ),
            row(top: false, [
              CountUp(
                value: profile.totalReps,
                builder: (context, shown) => _Stat(
                  label: l.totalReps,
                  value: localNumber(context, shown),
                ),
              ),
              _Stat(
                label: l.record,
                value: localNumber(context, profile.wins),
                suffix: l.winInitial,
                value2: localNumber(context, profile.losses),
                suffix2: l.lossInitial,
              ),
              _Stat(
                label: l.streak,
                value: localNumber(context, profile.dayStreak),
                suffix: l.dayInitial,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

/// One of the six: its label, then the number.
class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.suffix,
    this.value2,
    this.suffix2,
    this.colour,
  });

  final String label;
  final String value;

  /// A unit worn by the number — "W", "L", "d". Set smaller and in the muted
  /// colour, so the figure still reads as the figure.
  final String? suffix;
  final String? value2;
  final String? suffix2;

  final Color? colour;

  @override
  Widget build(BuildContext context) {
    final big = TextStyle(
      color: colour ?? context.colors.text,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.2,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final small = TextStyle(color: context.colors.muted, fontSize: 13);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 15, 10, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardLabel(label),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: value, style: big),
                  if (suffix case final s?) TextSpan(text: s, style: small),
                  if (value2 case final v?) ...[
                    const TextSpan(text: ' '),
                    TextSpan(text: v, style: big),
                  ],
                  if (suffix2 case final s?) TextSpan(text: s, style: small),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── week chart ──────────────────────────────────

/// Seven days of reps.
///
/// Answers one question — did I train this week — and answers it without a
/// number anybody has to read. The gap in the middle of the row is the point:
/// a rest day is visible, and so is a week of them.
class _WeekChart extends StatelessWidget {
  const _WeekChart();

  // The profile places it as a const, which the tab's own redraw after a duel
  // passes by: so it listens for the reps itself, or today's bar stays where
  // it was before the match.
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Career.instance,
    builder: (context, _) => _chart(context),
  );

  Widget _chart(BuildContext context) {
    final l = L.of(context);
    final days = Career.instance.weekReps;
    final total = days.fold(0, (sum, d) => sum + d);
    final peak = days.fold(0, (m, d) => d > m ? d : m);

    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, end: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(l.last7Days, style: sectionLabelStyle(context)),
                ),
                Text(
                  l.repsCount(localNumber(context, total)),
                  style: TextStyle(color: context.colors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          _Card(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 11),
            child: Column(
              children: [
                SizedBox(
                  height: 44,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (var i = 0; i < days.length; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        Expanded(
                          child: _DayBar(
                            reps: days[i],
                            peak: peak,
                            // The last bar is today, and today is the one worth
                            // picking out: it is the only one still changeable.
                            today: i == days.length - 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    for (var i = 0; i < days.length; i++) ...[
                      if (i > 0) const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          dayLetter(
                            context,
                            DateTime(
                              today.year,
                              today.month,
                              today.day - (days.length - 1 - i),
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            color: context.colors.faint,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The first character of the weekday name.
  ///
}

class _DayBar extends StatelessWidget {
  const _DayBar({required this.reps, required this.peak, required this.today});

  final int reps;
  final int peak;
  final bool today;

  @override
  Widget build(BuildContext context) {
    // A rest day still draws a sliver. A day with nothing at all looks like a
    // chart that failed to load rather than a day off.
    final share = peak == 0 ? 0.0 : reps / peak;
    final height = reps == 0 ? 4.0 : (share * 42).clamp(6.0, 42.0);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: today ? context.colors.brand : context.colors.surfaceRaised,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// ──────────────────────────────── recent ─────────────────────────────────────

class _Recent extends StatelessWidget {
  const _Recent({required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 4),
                  child: Text(l.recent, style: sectionLabelStyle(context)),
                ),
              ),
              InkWell(
                onTap: onViewAll,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Text(
                    l.viewAll,
                    style: TextStyle(color: context.colors.muted, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          if (matchHistory.isEmpty)
            EmptyState(
              icon: Icons.sports_mma,
              title: l.noMatchesYet,
              body: l.noMatchesYetBody,
            )
          else
            // The history screen's own pieces, so the two read as one: the
            // last ten as a strip, then the latest two a line each.
            _Card(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.lastN(localNumber(context, FormStrip.shown)),
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const FormStrip(
                          key: Key('recentForm'),
                          height: 22,
                          gap: 5,
                        ),
                      ],
                    ),
                  ),
                  for (final (i, match) in matchHistory.take(2).indexed)
                    MatchRow(
                      m: match,
                      inset: 14,
                      divider: i == 0 && matchHistory.length > 1,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ────────────────────────────── achievements ─────────────────────────────────

/// One row, not a grid.
///
/// The grid that used to be here showed four of sixty-one, which is a sample
/// rather than a summary — and it pushed everything a lifter checks daily
/// below the fold to do it. The count is the summary; the screen behind it is
/// where the rest lives.
class _AchievementsRow extends StatelessWidget {
  const _AchievementsRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final owned = kTitles.where((t) => rewards.has(t.id)).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: _Card(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              Icons.workspace_premium_outlined,
              size: 17,
              color: context.colors.brand,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l.awards,
                style: TextStyle(color: context.colors.text, fontSize: 14),
              ),
            ),
            Text(
              l.xOfY(
                localNumber(context, owned),
                localNumber(context, kTitles.length),
              ),
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, size: 14, color: context.colors.muted),
          ],
        ),
      ),
    );
  }
}
