/// Somebody else, as seen from outside.
///
/// One screen and one menu, both reading the same [LifterProfile]: the
/// profile a name opens, in the order and with the cards of your own (the
/// user's pick A, 2026-11-07), and the share/mute/block/report sheet it
/// opens. One fetch, `backend.lifterProfile`, is the single source — nothing
/// here computes a stat of its own.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../awards/award_text.dart';
import '../awards/medal.dart';
import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../lifter/looks.dart';
import '../motion.dart';
import '../country_names.dart';
import '../face.dart';
import '../rank_card.dart';
import '../rewards.dart';
import '../season.dart';
import '../stat_grid.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../widgets.dart';
import '../worn_title.dart';
import 'cover_parts.dart';
import 'live_invite.dart';
import 'awards.dart' show AwardMedal;
import 'pro_parts.dart';
import 'settings_privacy.dart';
import 'share_card.dart';
import 'shell.dart' show AppShell;

/// Opens [username]'s profile. The one entry point every row that shows
/// somebody's name calls, so a name means the same thing to tap wherever it
/// appears — a friend row, a board row, anywhere. It goes straight there (the
/// user's pick, 2026-11-07); a small card used to come first, with most of
/// the same numbers and no way to ask a stranger to be a friend.
Future<void> openLifter(
  BuildContext context, {
  required String id,
  required String username,
  LifterProfile? initial,
  String? avatarUrl,
}) async {
  // Your own name on a board is you: the server does not describe you to
  // yourself as somebody else, and the card said it could not load
  // (the user, 2026-11-04). Your own profile is the tab for that.
  final me = backend.me?.id;
  if (me != null && me.isNotEmpty && id == me && AppShell.goToProfile(context)) {
    return;
  }
  await Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => OtherProfileScreen(
        id: id,
        username: username,
        initial: initial,
        avatarUrl: avatarUrl,
      ),
    ),
  );
}

// ──────────────────────────────── the profile ─────────────────────────────

class OtherProfileScreen extends StatefulWidget {
  const OtherProfileScreen({
    super.key,
    required this.id,
    required this.username,
    this.initial,
    this.avatarUrl,
  });

  final String id;
  final String username;

  /// Already known, so nothing is fetched — the sample rows, which have no
  /// server to ask.
  final LifterProfile? initial;

  /// Their photo, as the row that was tapped already had it: drawn at once,
  /// before the profile has been read from the server — until then the
  /// circle showed their name's lifter (the user, 2026-11-05).
  final String? avatarUrl;

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  LifterProfile? _profile;
  bool _loading = true;
  bool _sendingRequest = false;

  /// Their awards from finished months. Fetched beside the profile rather
  /// than inside it: a card that could not get them still has everything
  /// else to show.
  List<SeasonAward> _awards = const [];

  @override
  void initState() {
    super.initState();
    if (widget.initial case final seeded?) {
      _profile = seeded;
      _loading = false;
    } else {
      _load();
    }
    _loadAwards();
  }

  Future<void> _load() async {
    // How they look comes from its own call, beside the card.
    unawaited(Looks.instance.fetch([widget.id]));
    setState(() => _loading = true);
    try {
      final result = await backend.lifterProfile(widget.id);
      if (!mounted) return;
      setState(() {
        _profile = result;
        _loading = false;
      });
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        _profile = null;
        _loading = false;
      });
    }
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
        await _load();
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

  // Their look arrives after the profile, so all of it listens for that.
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Looks.instance,
    builder: (context, _) => _page(context),
  );

  /// A Pro wears their cover behind the top, a holo line along it whose
  /// colours drift slowly, the PRO chip, the name in the holo foil, and a
  /// soft light breathing behind the picture.
  Widget _page(BuildContext context) {
    final l = L.of(context);
    final p = _profile;
    final pro = Looks.instance.pro(widget.id);

    return Scaffold(
      backgroundColor: context.colors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          if (pro) const Center(child: ProChip(height: 20)),
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: l.moreOptions,
            onPressed: () => openLifterMenu(
              context,
              id: widget.id,
              username: widget.username,
              profile: p,
              onChanged: _load,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 320,
            child: ProfileCover(
              cover: pro ? Looks.instance.cover(widget.id) : null,
            ),
          ),
          if (pro)
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 2.5,
              child: _HoloLine(),
            ),
          Positioned.fill(
            child: _Body(
              id: widget.id,
              username: widget.username,
              avatarUrl: widget.avatarUrl,
              pro: pro,
              profile: p,
              loading: _loading,
              awards: _awards,
              sendingRequest: _sendingRequest,
              onChallenge: () => _challenge(context, p!),
              onAddFriend: _addFriend,
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.pro,
    required this.profile,
    required this.loading,
    required this.awards,
    required this.sendingRequest,
    required this.onChallenge,
    required this.onAddFriend,
  });

  final String id;
  final String username;
  final String? avatarUrl;
  final bool pro;
  final LifterProfile? profile;
  final bool loading;
  final List<SeasonAward> awards;
  final bool sendingRequest;
  final VoidCallback onChallenge;
  final VoidCallback onAddFriend;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final p = profile;
    // The picture takes the height the page has: more for a stranger, who
    // has no head-to-head under it. Inside the app bar's height at the top,
    // between its two buttons.
    final share = p == null || p.isFriend ? 0.15 : 0.185;
    // A stranger has no head-to-head: the room it leaves goes between the
    // parts, as on the picked mockup, rather than under the last of them.
    final roomy = p != null && !p.isFriend;
    final picture = (MediaQuery.sizeOf(context).height * share).clamp(92.0, 176.0);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top - 32,
              bottom: 12,
            ),
            children: [
              Center(
                child: _ProLight(
                  on: pro,
                  child: PersonAvatar(
                    id: id,
                    name: username,
                    avatarUrl: p?.avatarUrl ?? avatarUrl,
                    tierIdx: p != null && p.ranked ? p.tierIdx : null,
                    size: picture,
                  ),
                ),
              ),
              SizedBox(height: roomy ? 14 : 10),
              Center(child: _Name(name: username, xp: p?.xp, pro: pro)),
              if (titleById(p?.title) case final title?)
                // Centred under the name like everything else here; the list
                // stretches its children, which left it hanging at the start.
                Center(child: WornTitle(title: title)),
              if (awards.isNotEmpty) ...[
                const SizedBox(height: 10),
                SeasonAwardChips(awards: awards, alignment: WrapAlignment.center),
              ],
              SizedBox(height: roomy ? 26 : 12),
              if (loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (p == null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: Text(
                    l.couldNotLoadProfile,
                    textAlign: TextAlign.center,
                    style: context.type.body.copyWith(
                      color: context.colors.muted,
                    ),
                  ),
                )
              else ...[
                if (p.ranked)
                  // Its frame brings its own room either side for the wings.
                  RankCard(tierIdx: p.tierIdx, divIdx: p.divIdx, lp: p.lp)
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
                SizedBox(height: roomy ? 20 : 6),
                _Stats(profile: p),
                // The awards they pinned (the user's pick, 2026-11-09).
                _TheirShowcase(id: id),
                // A record between the two of you is for friends — a stranger
                // off the board gets their numbers, not yours.
                if (p.isFriend) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _HeadToHead(profile: p, username: username),
                  ),
                ],
              ],
            ],
          ),
        ),
        // Friends go live; anybody else is asked to be a friend first, and
        // that is the one thing offered here. At the foot of the page, so it
        // is there however short the phone is.
        if (!loading && p != null)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: p.isFriend
                    ? FilledButton(
                        key: const Key('challengeLive'),
                        onPressed: onChallenge,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(l.challenge),
                      )
                    : FilledButton(
                        key: const Key('addFriendButton'),
                        onPressed: sendingRequest ? null : onAddFriend,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(l.addFriendButton),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}

/// The name, with its level, and on a Pro in the holo foil.
class _Name extends StatelessWidget {
  const _Name({required this.name, required this.xp, required this.pro});

  final String name;
  final int? xp;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final style = context.type.heading.copyWith(
      color: pro ? Colors.white : context.colors.text,
      fontSize: 28,
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

/// Their six numbers, as your own profile shows yours: where they stand, then
/// what they have done.
class _Stats extends StatelessWidget {
  const _Stats({required this.profile});

  final LifterProfile profile;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final p = profile;

    // Null for good when they have no place: not placed yet, or asked to be
    // left off the board. A dash then, rather than a number made up.
    Widget place(String label, int? position) => StatCell(
      label: label,
      value: position == null
          ? '—'
          : l.rankPosition(localNumber(context, position)),
      colour: position == null ? context.colors.muted : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: StatGrid(
        top: [
          place(l.global, p.globalPlace),
          if (p.country case final code?)
            place(countryName(context, code), p.countryPlace)
          else
            StatCell(
              label: l.winRate,
              value: p.wins + p.losses == 0
                  ? '—'
                  : '${(p.wins * 100 / (p.wins + p.losses)).round()}%',
            ),
          StatCell(
            label: l.bestSet,
            value: localNumber(context, p.bestSet),
            colour: context.colors.brand,
          ),
        ],
        bottom: [
          StatCell(label: l.totalReps, value: localNumber(context, p.totalReps)),
          StatCell(
            label: l.record,
            value: localNumber(context, p.wins),
            suffix: l.winInitial,
            value2: localNumber(context, p.losses),
            suffix2: l.lossInitial,
          ),
          StatCell(label: l.streak, value: localNumber(context, p.winStreak)),
        ],
      ),
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
    final colors = context.colors;
    final note = TextStyle(color: colors.muted, fontSize: 13, height: 1.4);
    TextStyle score(Color colour) => TextStyle(
      color: colour,
      fontSize: 30,
      fontWeight: FontWeight.w800,
      height: 1,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    final card = BoxDecoration(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
    );

    if (!p.hasPlayedThem) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: card,
        child: Text(l.noHistoryWithThem(username), style: note),
      );
    }

    final total = p.winsVsYou + p.lossesVsYou;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 12),
      decoration: card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.headToHeadTitle,
            style: TextStyle(
              color: colors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(localNumber(context, p.lossesVsYou), style: score(colors.text)),
              Text(' ${l.you}', style: note),
              Expanded(
                child: Text(
                  username,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: note,
                ),
              ),
              // A space at the end of the name is not drawn when it is set
              // against the far edge: the name ran into the number.
              const SizedBox(width: 6),
              Text(localNumber(context, p.winsVsYou), style: score(colors.rival)),
            ],
          ),
          const SizedBox(height: 9),
          SizedBox(
            height: 8,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Row(
                // A Row's default center alignment gives a flexible child
                // only a loose cross-axis constraint, and a childless
                // ColoredBox collapses to zero height under a loose one —
                // stretch is what makes it actually fill the height given.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: p.lossesVsYou == 0 ? 0 : p.lossesVsYou,
                    child: ColoredBox(color: colors.brand),
                  ),
                  Expanded(
                    flex: p.winsVsYou == 0 ? 0 : p.winsVsYou,
                    child: ColoredBox(color: colors.rival),
                  ),
                  if (total == 0)
                    Expanded(child: ColoredBox(color: colors.surfaceRaised)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
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
            style: note,
          ),
        ],
      ),
    );
  }
}

/// A Pro's line of holo foil along the top of their page, its colours
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

/// On a Pro's page, a soft gold light breathing behind the picture over six
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

/// Share, mute, block, report: the sheet the profile's kebab opens.
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
        lifter: Looks.instance.lifter(widget.id),
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

/// The awards another lifter pinned to their profile: nothing at all when
/// they pinned none, or the server cannot say.
class _TheirShowcase extends StatefulWidget {
  const _TheirShowcase({required this.id});

  final String id;

  @override
  State<_TheirShowcase> createState() => _TheirShowcaseState();
}

class _TheirShowcaseState extends State<_TheirShowcase> {
  List<String> _ids = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!backend.available || backend.me == null || widget.id.isEmpty) return;
    try {
      final ids = await backend.lifterShowcase(widget.id);
      if (mounted) setState(() => _ids = ids.where((i) => awardNameOf(L.of(context), i) != null).toList());
    } on Object catch (error) {
      debugPrint('Could not read their showcase: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ids.isEmpty) return const SizedBox.shrink();
    final l = L.of(context);
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        key: const Key('theirShowcase'),
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [const Color(0xFF2A2214), colors.surface], stops: const [0, 0.6]),
          border: Border.all(color: tierColour(2), width: 1.5),
        ),
        child: Row(
          children: [
            for (final id in _ids)
              Expanded(
                child: Column(
                  children: [
                    AwardMedal(id: id, size: 64),
                    const SizedBox(height: 4),
                    Text(
                      awardNameOf(l, id)!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colors.text, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
