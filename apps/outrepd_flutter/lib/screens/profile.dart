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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../avatar.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../rewards.dart';
import '../player_avatar.dart';
import '../theme.dart';
import '../widgets.dart';
import 'avatar_picker.dart';
import 'awards.dart';
import 'match_history.dart';
import 'progression.dart';
import 'settings.dart';
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

  @override
  void initState() {
    super.initState();
    _loadPositions();
  }

  Future<void> _loadPositions() async {
    if (!backend.available) return;
    try {
      // Both at once: they are two independent questions, and asking them in
      // turn doubles how long the cards sit blank.
      final places = await Future.wait([
        backend.boardPosition(),
        backend.boardPosition(country: backend.me?.country),
      ]);
      if (!mounted) return;
      setState(() {
        _globalPosition = places.first;
        _localPosition = places.last;
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
                ),
              ),
              onSettings: () => _open(const SettingsScreen()),
            ),
            _Identity(
              profile: p,
              onTapRank: () => _open(ProgressionScreen(profile: p)),
            ),
            const SizedBox(height: 16),
            _RankCards(
              profile: p,
              global: _globalPosition,
              local: _localPosition,
            ),
            const SizedBox(height: 9),
            _StatGrid(profile: p),
            const SizedBox(height: 12),
            const _WeekChart(),
            const SizedBox(height: 14),
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
  const _Header({required this.onShare, required this.onSettings});

  final VoidCallback onShare;
  final VoidCallback onSettings;

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
          _IconAction(
            icon: Icons.settings_outlined,
            tooltip: L.of(context).settings,
            onTap: onSettings,
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
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
          listenable: avatar,
          builder: (context, _) => PlayerAvatar(
            name: profile.username,
            tierIdx: profile.tierIdx,
            image: avatar.hasPhoto ? FileImage(File(avatar.photoPath!)) : null,
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
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Worn beside the name, because that is the one place earning a
        // title was ever meant to show — see [Rewards.wearing]. The first
        // thing earned is worn automatically, so this is empty only for an
        // account with nothing unlocked yet.
        if (rewards.worn case final title?) ...[
          const SizedBox(height: 1),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(title.icon, size: 12, color: title.colour ?? context.colors.brand),
              const SizedBox(width: 4),
              Text(
                title.name(l),
                style: TextStyle(
                  color: title.colour ?? context.colors.brand,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 3),
        // Rank and progress on one line. It used to take three: the rank, the
        // numbers, and a sentence naming the next rung.
        InkWell(
          onTap: onTapRank,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              '${tierLabel(l, profile.tierIdx, profile.divIdx)} · '
              '${localNumber(context, profile.lp)} / '
              '${localNumber(context, 100)} LP',
              style: TextStyle(color: context.colors.muted, fontSize: 12),
            ),
          ),
        ),

        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: profile.lp / 100,
              minHeight: 5,
              backgroundColor: context.colors.surfaceRaised,
              valueColor: AlwaysStoppedAnimation(context.colors.brand),
            ),
          ),
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
    final content = Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: content,
    );
  }
}

/// The small uppercase label every card is titled with.
class _CardLabel extends StatelessWidget {
  const _CardLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: context.colors.muted,
        fontSize: 9,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ─────────────────────────────── rank cards ──────────────────────────────────

class _RankCards extends StatelessWidget {
  const _RankCards({required this.profile, this.global, this.local});

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _RankCard(
                label: l.global,
                position: onServer ? global : profile.globalRank,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _RankCard(
                label: profile.country,
                position: onServer ? local : profile.localRank,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard({required this.label, required this.position});

  final String label;

  /// Null while it is being fetched, and null for good when there is no
  /// position to show — an account still in placements is not on the board.
  /// The card shows a dash rather than a number it made up.
  final int? position;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardLabel(label),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              position == null
                  ? '—'
                  : L.of(context).rankPosition(localNumber(context, position!)),
              style: TextStyle(
                color: position == null
                    ? context.colors.muted
                    : context.colors.text,
                fontSize: 16,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────── stat grid ──────────────────────────────────

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _Stat(
                    label: l.bestSet,
                    value: localNumber(context, profile.bestSet),
                    // The one number a single good session can move, so it is
                    // the one wearing the colour that means "you".
                    colour: context.colors.brand,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _Stat(
                    label: l.totalReps,
                    value: localNumber(context, profile.totalReps),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _Stat(
                    label: l.record,
                    value: localNumber(context, profile.wins),
                    suffix: l.winInitial,
                    value2: localNumber(context, profile.losses),
                    suffix2: l.lossInitial,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _Stat(
                    label: l.streak,
                    value: localNumber(context, profile.dayStreak),
                    suffix: l.dayInitial,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      fontSize: 24,
      height: 1.2,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final small = TextStyle(color: context.colors.muted, fontSize: 13);

    return _Card(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardLabel(label),
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

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final days = Career.instance.weekReps;
    final total = days.fold(0, (sum, d) => sum + d);
    final peak = days.fold(0, (m, d) => d > m ? d : m);

    // Narrow weekday letters in the reader's own language and week order.
    final locale = Localizations.localeOf(context).toString();
    final format = DateFormat.E(locale);
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(child: _CardLabel(l.last7Days)),
                Text(
                  l.repsCount(localNumber(context, total)),
                  style: TextStyle(color: context.colors.muted, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
                      _initial(
                        format.format(
                          today.subtract(Duration(days: days.length - 1 - i)),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        color: context.colors.faint,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// The first character of the weekday name.
  ///
  /// Latin scripts shorten to a letter; Japanese and Chinese already name the
  /// day in one character and would lose it entirely if this took a substring
  /// of a longer form, so it takes the first *character* rather than a slice
  /// of bytes.
  String _initial(String weekday) =>
      weekday.isEmpty ? '' : weekday.characters.first;
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
                child: Text(
                  l.recent.toUpperCase(),
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
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
                    style: TextStyle(color: context.colors.muted, fontSize: 11),
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
            for (final match in matchHistory.take(2))
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _RecentRow(match: match),
              ),
        ],
      ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.match});

  final MatchRecord match;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colour = match.won ? context.colors.brand : context.colors.rival;

    return _Card(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        children: [
          // A bar rather than a tick or a cross: it reads at a glance down a
          // column without anybody having to look at it directly.
          Container(
            width: 5,
            height: 26,
            decoration: BoxDecoration(
              color: colour,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  match.won
                      ? l.wonVs(match.opponent)
                      : l.lostVs(match.opponent),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.colors.text, fontSize: 12),
                ),
                Text(
                  '${localNumber(context, match.userReps)} – '
                  '${localNumber(context, match.opponentReps)} · '
                  '${_ago(context, match)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.colors.muted, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${match.lpChange >= 0 ? '+' : '−'}'
            '${localNumber(context, match.lpChange.abs())}',
            style: TextStyle(
              color: colour,
              fontSize: 12,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  /// Minutes are not worth a unit of their own, hours are while it is still
  /// today, and days after that.
  ///
  /// "0h ago" is what the hours branch says for the first sixty minutes, which
  /// is both wrong and the most common case there is — the duel you just
  /// finished.
  String _ago(BuildContext context, MatchRecord match) {
    final l = L.of(context);
    final hours = match.hoursAgo;
    if (hours == null) return relativeDays(context, match.daysAgo);
    if (hours < 1) return l.justNow;
    return l.hoursAgo(localNumber(context, hours));
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
                style: TextStyle(color: context.colors.text, fontSize: 12),
              ),
            ),
            Text(
              l.xOfY(
                localNumber(context, owned),
                localNumber(context, kTitles.length),
              ),
              style: TextStyle(color: context.colors.muted, fontSize: 11),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, size: 14, color: context.colors.muted),
          ],
        ),
      ),
    );
  }
}
