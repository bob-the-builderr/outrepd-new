/// Somebody else, as seen from outside.
///
/// Two depths and one menu, all reading the same [LifterProfile]: a quick
/// peek from wherever a name appears in a list, the full card one tap
/// deeper, and the share/mute/block/report sheet either of them opens. One
/// fetch, `backend.lifterProfile`, is the single source both depths draw
/// from — nothing here computes a stat of its own.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../lifter/looks.dart';
import '../lifter/my_lifter.dart';
import '../motion.dart';
import '../country_names.dart';
import '../player_avatar.dart';
import '../rank_row.dart';
import '../ranking.dart';
import '../rewards.dart';
import '../season.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../widgets.dart';
import '../worn_title.dart';
import 'cover_parts.dart';
import 'live_invite.dart';
import 'pro_parts.dart';
import 'settings_privacy.dart';
import 'share_card.dart';

/// Opens the quick-peek sheet for [username]. The one entry point every row
/// that shows somebody's name calls, so a name means the same thing to tap
/// wherever it appears — a friend row, a board row, anywhere.
Future<void> showLifterPeek(
  BuildContext context, {
  required String id,
  required String username,
  LifterProfile? initial,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) =>
        _LifterPeekSheet(id: id, username: username, initial: initial),
  );
}

// ──────────────────────────────── the fetch ───────────────────────────────

/// The loading/error/content states both the peek sheet and the full screen
/// share, so neither has to restate what "couldn't load" looks like.
mixin _LifterFetch<T extends StatefulWidget> on State<T> {
  String get lifterId;

  LifterProfile? profile;
  bool loading = true;

  Future<void> load() async {
    // How they look comes from its own call, beside the card.
    unawaited(Looks.instance.fetch([lifterId]));
    setState(() => loading = true);
    try {
      final result = await backend.lifterProfile(lifterId);
      if (!mounted) return;
      setState(() {
        profile = result;
        loading = false;
      });
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        profile = null;
        loading = false;
      });
    }
  }
}

// ──────────────────────────────── quick peek ───────────────────────────────

class _LifterPeekSheet extends StatefulWidget {
  const _LifterPeekSheet({
    required this.id,
    required this.username,
    this.initial,
  });

  final String id;
  final String username;

  /// Already known, so nothing is fetched — the sample rows, which have no
  /// server to ask.
  final LifterProfile? initial;

  @override
  State<_LifterPeekSheet> createState() => _LifterPeekSheetState();
}

class _LifterPeekSheetState extends State<_LifterPeekSheet>
    with _LifterFetch<_LifterPeekSheet> {
  @override
  String get lifterId => widget.id;

  @override
  void initState() {
    super.initState();
    if (widget.initial case final seeded?) {
      profile = seeded;
      loading = false;
    } else {
      load();
    }
  }

  void _openFullProfile() {
    final loaded = profile;
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtherProfileScreen(
          id: widget.id,
          username: widget.username,
          initial: loaded,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final p = profile;

    return ListenableBuilder(
      listenable: Looks.instance,
      builder: (context, _) => _sheet(context, l, p),
    );
  }

  /// A player card (the user's pick, 2026-11-03): the picture large in its
  /// tier's frame, the name and level, the title worn, where they stand,
  /// the rank row in its frame, and the numbers in one card. A Pro's card
  /// wears their cover behind the top, a holo line along its edge whose
  /// colours drift slowly, the PRO chip, the name in the holo foil, and a
  /// soft light breathing behind the picture.
  Widget _sheet(BuildContext context, L l, LifterProfile? p) {
    final pro = Looks.instance.pro(widget.id);
    final cover = pro ? Looks.instance.cover(widget.id) : null;
    final tint = p != null && p.ranked
        ? tierMetal(p.tierIdx).mid
        : context.colors.brand;
    final places = p == null ? '' : _placesLine(context, l, p);

    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            // Behind the top: a Pro's cover, or anyone else's tier as a
            // soft light.
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 230,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: cover != null
                    ? ProfileCover(cover: cover)
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0, -1.1),
                            radius: 1.1,
                            colors: [
                              tint.withValues(alpha: 0.2),
                              tint.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            if (pro)
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 2.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: _HoloLine(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SheetGrip(),
                  Row(
                    children: [
                      if (pro) const ProChip(height: 20),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        color: context.colors.muted,
                        tooltip: l.moreOptions,
                        onPressed: () => openLifterMenu(
                          context,
                          id: widget.id,
                          username: widget.username,
                          profile: p,
                          onChanged: load,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: _ProLight(
                      on: pro,
                      child: PlayerAvatar(
                        name: widget.username,
                        tierIdx: p != null && p.ranked ? p.tierIdx : null,
                        image: _picture(widget.id, p?.avatarUrl),
                        alive: pro,
                        size: 92,
                        onBadgeTap: p != null && p.ranked
                            ? _openFullProfile
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: _PeekName(
                      name: widget.username,
                      xp: p?.xp,
                      pro: pro,
                    ),
                  ),
                  if (titleById(p?.title) case final title?)
                    Center(child: WornTitle(title: title)),
                  if (places.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        places,
                        textAlign: TextAlign.center,
                        style: context.type.label.copyWith(
                          color: context.colors.muted,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (p == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        l.couldNotLoadProfile,
                        textAlign: TextAlign.center,
                        style: context.type.label.copyWith(
                          color: context.colors.muted,
                        ),
                      ),
                    )
                  else ...[
                    if (p.ranked)
                      RankRow(
                        tierIdx: p.tierIdx,
                        divIdx: p.divIdx,
                        lp: p.lp,
                        onTap: _openFullProfile,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          l.unranked,
                          textAlign: TextAlign.center,
                          style: context.type.label.copyWith(
                            color: context.colors.muted,
                          ),
                        ),
                      ),
                    _PeekStats(
                      pro: pro,
                      stats: [
                        // A record between the two of you is for friends —
                        // a stranger off the board gets their numbers, not
                        // yours.
                        if (p.isFriend)
                          (
                            l.vsYouCaption,
                            p.hasPlayedThem
                                ? '${localNumber(context, p.winsVsYou)}${l.winInitial} ${localNumber(context, p.lossesVsYou)}${l.lossInitial}'
                                : '—',
                            null,
                          ),
                        (
                          l.bestSet,
                          localNumber(context, p.bestSet),
                          context.colors.brand,
                        ),
                        (
                          l.winRate,
                          p.wins + p.losses == 0
                              ? '—'
                              : '${(p.wins * 100 / (p.wins + p.losses)).round()}%',
                          null,
                        ),
                      ],
                    ),
                    // A friend is challenged live; a stranger is not
                    // challenged at all — the full profile is where they are
                    // asked to be a friend first.
                    if (p.isFriend) ...[
                      const SizedBox(height: 14),
                      FilledButton(
                        key: const Key('challengeLive'),
                        onPressed: () => _challenge(context, p),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(l.challenge),
                      ),
                    ],
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _openFullProfile,
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colors.surfaceRaised,
                        foregroundColor: context.colors.brand,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(l.viewFullProfile),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The name on the card: with its level, and on a Pro's card in the holo
/// foil.
class _PeekName extends StatelessWidget {
  const _PeekName({required this.name, required this.xp, required this.pro});

  final String name;
  final int? xp;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final style = context.type.heading.copyWith(
      color: pro ? Colors.white : context.colors.text,
      fontSize: 26,
      fontWeight: FontWeight.w800,
    );
    if (!pro) {
      return NameWithLevel(name: name, xp: xp, chipFontSize: 12, style: style);
    }
    final level = xp;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (rect) => kHoloGradient.createShader(rect),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ),
        if (level != null) ...[
          const SizedBox(width: 6),
          LevelChip(xp: level, fontSize: 12),
        ],
      ],
    );
  }
}

/// The numbers, in one card divided into columns: each value over its label.
class _PeekStats extends StatelessWidget {
  const _PeekStats({required this.stats, required this.pro});

  final List<(String, String, Color?)> stats;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pro
              ? AppColors.gold.withValues(alpha: 0.35)
              : colors.border,
          width: 0.8,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (final (i, (label, value, colour)) in stats.indexed) ...[
              if (i > 0) VerticalDivider(width: 1, color: colors.border),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      Text(
                        value,
                        maxLines: 1,
                        style: TextStyle(
                          color: colour ?? colors.text,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.type.label.copyWith(
                          color: colors.muted,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A Pro's line of holo foil along the top of their card, its colours
/// drifting across it once every ten seconds. Still where the phone asks
/// for less motion, and under tests.
class _HoloLine extends StatefulWidget {
  const _HoloLine();

  @override
  State<_HoloLine> createState() => _HoloLineState();
}

class _HoloLineState extends State<_HoloLine>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loopsAllowed(context)) {
      if (!_controller.isAnimating) _controller.repeat();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: kHolo,
            tileMode: TileMode.repeated,
            transform: _Slide(_controller.value),
          ),
        ),
      ),
    );
  }
}

/// Moves a gradient along by [t] of the box's width.
class _Slide extends GradientTransform {
  const _Slide(this.t);

  final double t;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * t, 0, 0);
}

/// On a Pro's card, a soft gold light breathing behind the picture over six
/// seconds. Held halfway where the phone asks for less motion, and under
/// tests; nothing at all for anyone else.
class _ProLight extends StatefulWidget {
  const _ProLight({required this.on, required this.child});

  final bool on;
  final Widget child;

  @override
  State<_ProLight> createState() => _ProLightState();
}

class _ProLightState extends State<_ProLight>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
    value: 0.5,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.on && loopsAllowed(context)) {
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
    if (!widget.on) return widget.child;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = Curves.easeInOut.transform(_controller.value);
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.gold.withValues(alpha: 0.12 + 0.14 * t),
                        AppColors.gold.withValues(alpha: 0),
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

/// "Global #3 · Egypt #1" — built from the two board places rather than
/// carried as one string, so either half can be missing without the other
/// looking orphaned.
String _placesLine(BuildContext context, L l, LifterProfile p) {
  final parts = <String>[
    if (p.globalPlace case final g?)
      '${l.global} ${l.rankPosition(localNumber(context, g))}',
    if (p.countryPlace case final c?)
      if (p.country case final code?)
        '${countryName(context, code)} '
            '${l.rankPosition(localNumber(context, c))}',
  ];
  return parts.join(' · ');
}

/// [id]'s picture: a Pro who made a lifter is drawn from it (alive, in
/// vectors); anybody else by their uploaded picture, or their name's lifter.
ImageProvider? _picture(String id, String? avatarUrl) {
  final made = Looks.instance.lifter(id);
  if (Looks.instance.pro(id) && made != null) return LifterPicture(made);
  return avatarUrl != null ? NetworkImage(avatarUrl) : null;
}

// ──────────────────────────────── full profile ────────────────────────────

class OtherProfileScreen extends StatefulWidget {
  const OtherProfileScreen({
    super.key,
    required this.id,
    required this.username,
    this.initial,
  });

  final String id;
  final String username;

  /// Already fetched, when this screen was reached from the quick peek —
  /// the peek only just asked the same question, so asking again would be a
  /// second round trip for an answer already in hand.
  final LifterProfile? initial;

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen>
    with _LifterFetch<OtherProfileScreen> {
  @override
  String get lifterId => widget.id;

  bool _sendingRequest = false;

  /// Their awards from finished months. Fetched beside the profile rather
  /// than inside it: a card that could not get them still has everything
  /// else to show.
  List<SeasonAward> _awards = const [];

  @override
  void initState() {
    super.initState();
    if (widget.initial case final seeded?) {
      profile = seeded;
      loading = false;
    } else {
      load();
    }
    _loadAwards();
  }

  Future<void> _loadAwards() async {
    if (!backend.available || widget.id.isEmpty) return;
    try {
      final awards = await backend.lifterSeasonAwards(widget.id);
      if (mounted) setState(() => _awards = awards);
    } on Object catch (error) {
      debugPrint('Could not read their season awards: $error');
    }
  }

  Future<void> _addFriend() async {
    if (_sendingRequest) return;
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _sendingRequest = true);
    try {
      final result = await backend.askFriend(widget.username);
      if (!mounted) return;
      final said = switch (result) {
        AskResult.asked => l.requestSent(widget.username),
        AskResult.friends => l.nowFriends(widget.username),
        AskResult.noSuchLifter => l.noOneFound,
        AskResult.thatIsYou => l.noOneFound,
      };
      messenger.showSnackBar(
        SnackBar(content: Text(said), behavior: SnackBarBehavior.floating),
      );
      if (result == AskResult.asked || result == AskResult.friends) {
        await load();
      }
    } on Object catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _sendingRequest = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final p = profile;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: l.moreOptions,
            onPressed: () => openLifterMenu(
              context,
              id: widget.id,
              username: widget.username,
              profile: p,
              onChanged: load,
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : p == null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Text(
                  l.couldNotLoadProfile,
                  textAlign: TextAlign.center,
                  style: context.type.body.copyWith(
                    color: context.colors.muted,
                  ),
                ),
              ),
            )
          : _Body(
              profile: p,
              username: widget.username,
              awards: _awards,
              sendingRequest: _sendingRequest,
              onChallenge: () => _challenge(context, p),
              onAddFriend: _addFriend,
            ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.profile,
    required this.username,
    required this.awards,
    required this.sendingRequest,
    required this.onChallenge,
    required this.onAddFriend,
  });

  final LifterProfile profile;
  final String username;
  final List<SeasonAward> awards;
  final bool sendingRequest;
  final VoidCallback onChallenge;
  final VoidCallback onAddFriend;

  // Their cover behind the top, while they are Pro; redrawn when their
  // look arrives.
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Looks.instance,
    builder: (context, _) => Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 220,
          child: ProfileCover(cover: Looks.instance.cover(profile.id)),
        ),
        _list(context),
      ],
    ),
  );

  Widget _list(BuildContext context) {
    final l = L.of(context);
    final p = profile;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      children: [
        Center(
          child: PlayerAvatar(
            name: username,
            tierIdx: p.ranked ? p.tierIdx : null,
            image: _picture(p.id, p.avatarUrl),
            alive: Looks.instance.pro(p.id),
            size: 74,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: NameWithLevel(
            name: username,
            xp: p.xp,
            chipFontSize: 13,
            style: context.type.title.copyWith(color: context.colors.text),
          ),
        ),
        // Beside the name, the same as on your own profile.
        if (titleById(p.title) case final title?) ...[
          const SizedBox(height: 2),
          WornTitle(title: title),
        ],
        const SizedBox(height: 3),
        Text(
          p.ranked
              ? '${tierLabel(l, p.tierIdx, p.divIdx)} · ${localNumber(context, ratingOf(p.tierIdx, p.divIdx, p.lp))}'
              : l.unranked,
          textAlign: TextAlign.center,
          style: context.type.label.copyWith(color: _tierColour(p.tierIdx)),
        ),
        if (_placesLine(context, l, p) case final places when places.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            places,
            textAlign: TextAlign.center,
            style: context.type.micro.copyWith(color: context.colors.muted),
          ),
        ],
        if (awards.isNotEmpty) ...[
          const SizedBox(height: 10),
          SeasonAwardChips(awards: awards, alignment: WrapAlignment.center),
        ],

        const SizedBox(height: 18),
        // Friends only, same as the peek's "vs you" tile.
        if (p.isFriend) ...[
          _HeadToHead(profile: p, username: username),
          const SizedBox(height: 11),
        ],
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 7,
          crossAxisSpacing: 7,
          childAspectRatio: 2.1,
          children: [
            _StatBox(label: l.bestSet, value: localNumber(context, p.bestSet)),
            _StatBox(
              label: l.winRate,
              value: p.wins + p.losses == 0
                  ? '—'
                  : '${(p.wins * 100 / (p.wins + p.losses)).round()}%',
            ),
            _StatBox(
              label: l.totalReps,
              value: localNumber(context, p.totalReps),
            ),
            _StatBox(label: l.streak, value: localNumber(context, p.winStreak)),
          ],
        ),

        const SizedBox(height: 20),
        // Friends go live; anybody else is asked to be a friend first, and
        // that is the one thing offered here.
        if (p.isFriend) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('challengeLive'),
              onPressed: onChallenge,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(l.challenge),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(l.alreadyFriends),
            ),
          ),
        ] else
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('addFriendButton'),
              onPressed: sendingRequest ? null : onAddFriend,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(l.addFriendButton),
            ),
          ),
      ],
    );
  }
}

class _HeadToHead extends StatelessWidget {
  const _HeadToHead({required this.profile, required this.username});

  final LifterProfile profile;
  final String username;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final p = profile;

    if (!p.hasPlayedThem) {
      return Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: context.colors.surface,
          border: Border.all(color: context.colors.border, width: 0.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          l.noHistoryWithThem(username),
          style: context.type.label.copyWith(color: context.colors.muted),
        ),
      );
    }

    final total = p.winsVsYou + p.lossesVsYou;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.rival),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.headToHeadTitle.toUpperCase(),
            style: context.type.micro.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                localNumber(context, p.lossesVsYou),
                style: context.type.title.copyWith(color: context.colors.text),
              ),
              Text(
                ' ${l.h2hYou}',
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
              const Spacer(),
              Text(
                '${l.h2hThem} ',
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
              Text(
                localNumber(context, p.winsVsYou),
                style: context.type.title.copyWith(
                  color: context.colors.rival,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          SizedBox(
            height: 9,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Row(
                // A Row's default center alignment gives a flexible child
                // only a loose cross-axis constraint, and a childless
                // ColoredBox collapses to zero height under a loose one —
                // stretch is what makes it actually fill the 9px given to it.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: p.lossesVsYou == 0 ? 0 : p.lossesVsYou,
                    child: ColoredBox(color: context.colors.brand),
                  ),
                  Expanded(
                    flex: p.winsVsYou == 0 ? 0 : p.winsVsYou,
                    child: ColoredBox(color: context.colors.rival),
                  ),
                  if (total == 0)
                    Expanded(
                      child: ColoredBox(color: context.colors.surfaceRaised),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            [
              l.lastDuelScore(
                localNumber(context, p.lastYourReps ?? 0),
                localNumber(context, p.lastTheirReps ?? 0),
                relativeDays(
                  context,
                  DateTime.now().difference(p.lastDuelAt!).inDays,
                ),
              ),
              if (p.yourBestVsThem case final best?)
                l.yourBestVsThemLine(localNumber(context, best)),
            ].join(' '),
            style: context.type.micro.copyWith(
              color: context.colors.muted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      // Unlike a Column left to size itself, this one is given the cell's
      // actual height by the GridView above, so the Expanded below has real
      // room to shrink the value into rather than reporting its natural
      // size upward and overflowing the cell at a larger text scale.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShrinkText(
            label.toUpperCase(),
            maxLines: 1,
            style: context.type.micro.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                value,
                style: context.type.heading.copyWith(
                  color: context.colors.text,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _tierColour(int tierIdx) =>
    kTiers[tierIdx.clamp(0, kTiers.length - 1)].color;

/// Asks [profile] — a friend; nobody else is offered the button — to go
/// live, the same invite as the Friends tab's Challenge.
void _challenge(BuildContext context, LifterProfile profile) {
  inviteFriendLive(
    context,
    id: profile.id,
    username: profile.username,
    tierIdx: profile.tierIdx,
    divIdx: profile.divIdx,
    avatarUrl: profile.avatarUrl,
  );
}

// ──────────────────────────────── the menu ────────────────────────────────

/// Share, mute, block, report — the same sheet from the quick peek's kebab
/// and the full profile's, so tapping "more" means the same thing at either
/// depth.
Future<void> openLifterMenu(
  BuildContext context, {
  required String id,
  required String username,
  LifterProfile? profile,
  VoidCallback? onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    showDragHandle: true,
    builder: (_) => _LifterMenuSheet(
      id: id,
      username: username,
      profile: profile,
      onChanged: onChanged,
    ),
  );
}

class _LifterMenuSheet extends StatefulWidget {
  const _LifterMenuSheet({
    required this.id,
    required this.username,
    this.profile,
    this.onChanged,
  });

  final String id;
  final String username;

  /// Already fetched by whichever screen opened this sheet. Null only when
  /// the profile never loaded — Share falls back to the same placeholder
  /// every other share button in the app uses without one.
  final LifterProfile? profile;

  /// Something this sheet did changed what the screen behind it shows — a
  /// friendship ended — so it should fetch the profile again.
  final VoidCallback? onChanged;

  @override
  State<_LifterMenuSheet> createState() => _LifterMenuSheetState();
}

class _LifterMenuSheetState extends State<_LifterMenuSheet> {
  bool _busy = false;

  Future<void> _mute() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await backend.mute(widget.id);
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.mutedLifter(widget.username)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on Object catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Asks first: a friendship takes both people agreeing to make, and one
  /// mistaken tap should not be what ends it.
  Future<void> _removeFriend() async {
    if (_busy) return;
    final l = L.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l.removeFriendQuestion(widget.username)),
        content: Text(l.removeFriendBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: Text(l.cancel),
          ),
          TextButton(
            key: const Key('confirmRemoveFriend'),
            onPressed: () => Navigator.of(dialog).pop(true),
            child: Text(
              l.removeAction,
              style: TextStyle(color: context.colors.rival),
            ),
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;

    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await backend.removeFriend(widget.id);
      navigator.pop();
      widget.onChanged?.call();
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.removedFriend(widget.username)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on Object catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _block() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await backend.block(widget.id);
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.blockedLifter(widget.username)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on Object catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _share() {
    final navigator = Navigator.of(context);
    final rootContext = context;
    navigator.pop();

    final p = widget.profile;
    if (p == null) {
      // Nothing to draw a card from — the same placeholder every other
      // share button in the app falls back to without real data.
      ScaffoldMessenger.of(rootContext).showSnackBar(
        SnackBar(
          content: Text(L.of(rootContext).needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showShareCardSheet(
      rootContext,
      data: ShareCardData(
        username: p.username,
        tierIdx: p.tierIdx,
        divIdx: p.divIdx,
        lp: p.lp,
        wins: p.wins,
        losses: p.losses,
        bestSet: p.bestSet,
        winStreak: p.winStreak,
        globalPlace: p.globalPlace,
        country: p.country,
        countryPlace: p.countryPlace,
        avatarUrl: p.avatarUrl,
        xp: p.xp,
        title: titleById(p.title),
        pro: Looks.instance.pro(widget.id),
        cover: Looks.instance.cover(widget.id),
      ),
    );
  }

  void _report() {
    final id = widget.id;
    final username = widget.username;
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReportScreen(aboutId: id, aboutName: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        child: ListView(
          shrinkWrap: true,
          children: [
            _MenuRow(
              icon: Icons.ios_share,
              label: l.shareProfile,
              onTap: _busy ? null : _share,
            ),
            _MenuRow(
              icon: Icons.notifications_off_outlined,
              label: l.muteChallenges(widget.username),
              onTap: _busy ? null : _mute,
            ),
            // Only between friends: there is nothing to remove otherwise.
            if (widget.profile?.isFriend ?? false)
              _MenuRow(
                key: const Key('removeFriend'),
                icon: Icons.person_remove_outlined,
                label: l.removeFriend,
                body: l.removeFriendBody,
                onTap: _busy ? null : _removeFriend,
              ),
            _MenuRow(
              icon: Icons.block,
              iconColour: context.colors.rival,
              label: l.block,
              labelColour: context.colors.rival,
              body: l.blockRowBody,
              onTap: _busy ? null : _block,
            ),
            _MenuRow(
              icon: Icons.flag_outlined,
              iconColour: context.colors.rival,
              label: l.report,
              labelColour: context.colors.rival,
              body: l.reportRowBody,
              onTap: _busy ? null : _report,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(l.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColour,
    this.labelColour,
    this.body,
  });

  final IconData icon;
  final String label;
  final String? body;
  final Color? iconColour;
  final Color? labelColour;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 19, color: iconColour ?? context.colors.text),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: context.type.body.copyWith(
                      color: labelColour ?? context.colors.text,
                    ),
                  ),
                  if (body case final b?) ...[
                    const SizedBox(height: 2),
                    Text(
                      b,
                      style: context.type.micro.copyWith(
                        color: context.colors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetGrip extends StatelessWidget {
  const _SheetGrip();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: 38,
        height: 4,
        decoration: BoxDecoration(
          color: context.colors.surfaceRaised,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
