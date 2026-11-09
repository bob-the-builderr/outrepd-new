/// A challenge by link (the user's pick, 2026-11-09, B + C).
///
/// One minute, sent anywhere as outrepd.com/c/<code>: the button that was
/// Share on the result screen, or the card under Find a match for this
/// account's best. Whoever opens it races that minute — the same race as a
/// saved set — and the sender hears how it went. Friendly: no rank, record
/// or week point moves (challenge.sql), and the push-ups count toward the
/// day like any set's.
///
/// What is here: sending one, the screen a link opens (for the one taking
/// it, and for the owner, "Your challenge"), the result after a try, and
/// this account's challenges on the profile.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../data.dart';
import '../face.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../widgets.dart';
import '../xp.dart';
import 'level.dart';
import 'match_entry.dart';
import 'match_flow.dart';
import 'share_card.dart';

/// Every challenge is a minute, the same as a duel.
int get _seconds => kDuelLength.inSeconds;

/// Makes a link — for the set just lifted, or for this account's best — and
/// opens the share sheet with the challenge card on it. Says so when there is
/// no whole minute to send, or no server to make the link.
Future<void> sendChallenge(BuildContext context, {bool best = false}) async {
  final l = L.of(context);
  final messenger = ScaffoldMessenger.of(context);
  void say(String text) => messenger.showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );
  if (!backend.available || backend.me == null) {
    say(l.needsServer);
    return;
  }
  ChallengeLink? link;
  try {
    link = best
        ? await backend.challengeBest()
        : await backend.makeChallenge();
  } on Object catch (error) {
    debugPrint('Could not make a challenge: $error');
    say(l.needsServer);
    return;
  }
  if (!context.mounted) return;
  if (link == null) {
    say(l.challengeNoSet);
    return;
  }
  await showChallengeShareSheet(context, data: _myCard(link.code, link.reps));
}

/// This account's challenge card, its face drawn as every screen draws it
/// (face.dart): the lifter it wears, or its photo.
ChallengeShareData _myCard(String code, int reps) {
  final me = backend.me;
  final face = faceOf(
    id: me?.id ?? '',
    name: demoProfile.username,
    avatarUrl: me?.avatarUrl,
    mine: true,
  );
  return ChallengeShareData(
    username: demoProfile.username,
    code: code,
    reps: reps,
    seconds: _seconds,
    avatarUrl: face.photo == null ? null : me?.avatarUrl,
    lifter: face.photo == null ? face.lifter : null,
    tierIdx: demoProfile.isRanked ? demoProfile.tierIdx : null,
  );
}

/// The button on the result screen where Share was: the link icon and the
/// rival's colour round it, so it reads as a dare rather than a post.
class ChallengeButton extends StatelessWidget {
  const ChallengeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final rival = context.colors.rival;
    return OutlinedButton.icon(
      key: const Key('challenge'),
      onPressed: () => sendChallenge(context),
      icon: Icon(Icons.link_rounded, color: rival, size: 20),
      label: Text(L.of(context).challengeAction),
      style: OutlinedButton.styleFrom(
        backgroundColor: Color.alphaBlend(
          rival.withValues(alpha: 0.10),
          context.colors.background,
        ),
        side: BorderSide(color: rival, width: 1.5),
      ),
    );
  }
}

/// The home screen's card under Find a match: this account's best minute,
/// sent from anywhere at any time. Only once there is a best to send.
class ChallengeHomeCard extends StatelessWidget {
  const ChallengeHomeCard({super.key});

  /// Whether the card shows: a best set to send, and a server to send it.
  static bool get shown => demoProfile.bestSet > 0 && backend.available;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final rival = context.colors.rival;
    return PressScale(
      child: Material(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          key: const Key('challengeHome'),
          onTap: () => sendChallenge(context, best: true),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: rival, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: rival.withValues(alpha: 0.14),
                  ),
                  child: Icon(Icons.link_rounded, color: rival, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.challengeAFriend,
                        style: TextStyle(
                          color: context.colors.text,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.challengeYourBest(
                          localNumber(context, demoProfile.bestSet),
                          localNumber(context, _seconds),
                        ),
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: context.colors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────── what a link opens ───────────────────────────

/// What a challenge link opens: the challenge to take, or, when it is this
/// account's own, "Your challenge" with everybody who took it.
class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key, required this.code, this.preview});

  final String code;

  /// Already in hand, for the screenshots; asked of the server otherwise.
  final ChallengeView? preview;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  ChallengeView? _view;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.preview case final view?) {
      _view = view;
      _loading = false;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final view = await backend.openChallenge(widget.code);
      if (!mounted) return;
      setState(() {
        _view = view;
        _loading = false;
      });
    } on Object catch (error) {
      debugPrint('Could not open the challenge: $error');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final Widget body;
    if (_loading) {
      body = Center(
        child: CircularProgressIndicator(color: context.colors.brand),
      );
    } else if (_failed) {
      body = BlockingNotice(
        icon: Icons.wifi_off,
        title: l.noConnection,
        body: l.needsServer,
        actionLabel: l.retry,
        onAction: _load,
      );
    } else if (_view case final view?) {
      body = view.mine
          ? _OwnerView(view: view, onChanged: _load)
          : _TakerView(view: view);
    } else {
      body = BlockingNotice(
        icon: Icons.search_off,
        title: l.challengeGoneTitle,
        body: l.challengeGoneBody,
        actionLabel: l.backToHome,
        onAction: () => Navigator.of(context).pop(),
      );
    }
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(child: body),
    );
  }
}

/// The challenge as the one taking it sees it: who sent it, the number, the
/// board so far, and the button.
class _TakerView extends StatelessWidget {
  const _TakerView({required this.view});

  final ChallengeView view;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final owner = view.owner;
    final taken = view.taken;
    final canTake = view.open && taken == null;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonTooltip,
                      icon: Icon(Icons.close, color: context.colors.muted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Center(
                        child: ChallengePill(text: l.vsChallengeFriendly),
                      ),
                    ),
                    // As wide as the close button, so the tag sits in the
                    // middle of the screen rather than of what is left.
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 10),
                PersonAvatar(
                  id: owner.id,
                  name: owner.username,
                  avatarUrl: owner.avatarUrl,
                  tierIdx: owner.tierIdx,
                  size: 132,
                ),
                const SizedBox(height: 10),
                ShrinkText(
                  owner.username,
                  maxLines: 1,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.challengesYouToBeat,
                  style: TextStyle(color: context.colors.muted, fontSize: 16),
                ),
                _BigCount(reps: view.reps),
                Text(
                  l.pushUpsInSeconds(localNumber(context, _seconds)),
                  style: TextStyle(color: context.colors.text, fontSize: 16),
                ),
                const SizedBox(height: 22),
                ChallengeBoard(view: view, you: backend.me?.id),
                const SizedBox(height: 14),
                Text(
                  !view.open
                      ? l.challengeClosed
                      : taken != null
                      ? l.challengeYouTookIt(localNumber(context, taken))
                      : l.challengeFriendlyNote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const Key('takeChallenge'),
                  onPressed: canTake
                      ? () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => MatchFlowScreen(
                              mode: MatchMode.link,
                              linkChallenge: view,
                            ),
                          ),
                        )
                      : null,
                  child: Text(l.takeTheChallenge),
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l.notNow,
                  style: TextStyle(color: context.colors.muted, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Your challenge": the number, who took it, and a way to take each try
/// that beat it back.
class _OwnerView extends StatefulWidget {
  const _OwnerView({required this.view, required this.onChanged});

  final ChallengeView view;
  final VoidCallback onChanged;

  @override
  State<_OwnerView> createState() => _OwnerViewState();
}

class _OwnerViewState extends State<_OwnerView> {
  String? _busy;

  Future<void> _takeBack(ChallengeEntry entry) async {
    final takeId = entry.takeId;
    if (takeId == null || _busy != null) return;
    setState(() => _busy = takeId);
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final link = await backend.backChallenge(takeId);
      if (!mounted) return;
      if (link == null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l.challengeGoneBody),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ChallengeScreen(code: link.code)),
      );
      widget.onChanged();
    } on Object catch (error) {
      debugPrint('Could not take the try back: $error');
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final view = widget.view;
    final takes = view.board.where((e) => !e.owner).toList();
    final beat = takes.where((e) => e.beat).length;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    icon: Icon(Icons.chevron_left, color: context.colors.text),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      l.yourChallenge,
                      style: context.type.title.copyWith(
                        color: context.colors.text,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Text(
                      localNumber(context, view.reps),
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.pushUpsInSeconds(localNumber(context, _seconds)),
                            style: TextStyle(
                              color: context.colors.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            view.open
                                ? l.challengeOpenUntil(
                                    MaterialLocalizations.of(
                                      context,
                                    ).formatMediumDate(view.expiresAt),
                                  )
                                : l.challengeClosed,
                            style: TextStyle(
                              color: context.colors.muted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (takes.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    l.challengeNobodyYet,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.muted, fontSize: 15),
                  ),
                )
              else ...[
                _BoardCaption(
                  left: l.challengeTookIt(localNumber(context, takes.length)),
                  right: beat > 0
                      ? l.challengeBeatYou(localNumber(context, beat))
                      : null,
                  rightColour: context.colors.rival,
                ),
                _Rows(
                  children: [
                    for (final entry in takes)
                      _TakeRow(
                        entry: entry,
                        busy: _busy == entry.takeId,
                        onTakeBack: entry.beat && entry.canBack
                            ? () => _takeBack(entry)
                            : null,
                      ),
                  ],
                ),
                if (beat > 0) ...[
                  const SizedBox(height: 14),
                  Text(
                    l.takeItBackNote,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.muted,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
        if (view.open)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('sendMore'),
                onPressed: () => showChallengeShareSheet(
                  context,
                  data: _myCard(view.code, view.reps),
                ),
                child: Text(l.sendToMoreFriends),
              ),
            ),
          ),
      ],
    );
  }
}

/// One try on "Your challenge": who, their count in the colour of how it
/// went, and the button to take it back when it beat yours.
class _TakeRow extends StatelessWidget {
  const _TakeRow({required this.entry, this.onTakeBack, this.busy = false});

  final ChallengeEntry entry;
  final VoidCallback? onTakeBack;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colour = entry.beat ? context.colors.rival : context.colors.brand;
    final ago = relativeDays(
      context,
      DateTime.now().difference(entry.at).inDays,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          PersonAvatar(
            id: entry.id,
            name: entry.username,
            avatarUrl: entry.avatarUrl,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: entry.username),
                      const TextSpan(text: '  '),
                      TextSpan(
                        text: localNumber(context, entry.reps),
                        style: TextStyle(
                          color: colour,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.beat ? l.challengeRowBeat : l.challengeRowHeld} · $ago',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.colors.muted, fontSize: 12.5),
                ),
              ],
            ),
          ),
          if (onTakeBack != null)
            FilledButton(
              onPressed: busy ? null : onTakeBack,
              // A chip of a button, in the theme's own type: a style with no
              // family of its own would fall back to another font.
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(l.takeItBack),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── after a try ─────────────────────────────────

/// The result of a try: beaten or not, the two counts, where it put you on
/// the board, and sending one back.
class ChallengeResultView extends StatefulWidget {
  const ChallengeResultView({
    super.key,
    required this.view,
    required this.reps,
    required this.onDone,
    this.xp,
  });

  /// The challenge after the try, from the server.
  final ChallengeView view;
  final int reps;
  final VoidCallback onDone;
  final XpGain? xp;

  @override
  State<ChallengeResultView> createState() => _ChallengeResultViewState();
}

class _ChallengeResultViewState extends State<ChallengeResultView> {
  bool _sending = false;
  bool _sent = false;

  Future<void> _sendBack() async {
    final takeId = widget.view.takeId;
    if (takeId == null || _sending || _sent) return;
    setState(() => _sending = true);
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final link = await backend.backChallenge(takeId);
      if (!mounted) return;
      if (link == null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l.challengeNoSet),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        setState(() => _sent = true);
      }
    } on Object catch (error) {
      debugPrint('Could not send the challenge back: $error');
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final view = widget.view;
    final owner = view.owner;
    final reps = widget.reps;
    final beat = reps > view.reps;
    final gap = (reps - view.reps).abs();
    final me = backend.me?.id ?? '';
    final place = view.placeOf(me);
    final count = view.board.length;
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Column(
                children: [
                  PopIn(
                    from: 0.6,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        (beat ? l.youBeatIt : l.notThisTime).toUpperCase(),
                        maxLines: 1,
                        style: context.type.title.copyWith(
                          color: beat
                              ? context.colors.brand
                              : context.colors.rival,
                          fontSize: 46,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gap == 0
                        ? l.challengeLevelWith(owner.username)
                        : beat
                        ? l.challengeMoreThan(
                            localNumber(context, gap),
                            owner.username,
                          )
                        : l.challengeShortOf(
                            localNumber(context, gap),
                            owner.username,
                          ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.muted, fontSize: 15),
                  ),
                  const SizedBox(height: 18),
                  _ResultScore(
                    you: reps,
                    them: view.reps,
                    owner: owner,
                    beat: beat,
                  ),
                  const SizedBox(height: 22),
                  ChallengeBoard(
                    view: view,
                    you: me,
                    caption: place == null
                        ? null
                        : l.challengePlace(
                            localNumber(context, place),
                            localNumber(context, count),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.challengeResultNote(localNumber(context, reps)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.muted, fontSize: 13.5),
                  ),
                  if (widget.xp case final gain?) ...[
                    const SizedBox(height: 12),
                    XpGainCard(gain: gain),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('challengeBack'),
                    onPressed: view.takeId == null || _sent || _sending
                        ? null
                        : _sendBack,
                    child: Text(
                      _sent
                          ? l.challengeSentBack
                          : l.challengeBack(owner.username),
                    ),
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => sendChallenge(context),
                        child: Text(l.shareAction),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onDone,
                        child: Text(l.doneAction),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// You and the owner, side by side, the winner's half set off.
class _ResultScore extends StatelessWidget {
  const _ResultScore({
    required this.you,
    required this.them,
    required this.owner,
    required this.beat,
  });

  final int you;
  final int them;
  final ChallengeOwner owner;
  final bool beat;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    Widget side({
      required Widget face,
      required String name,
      required int reps,
      required Color colour,
      required bool won,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          decoration: won
              ? BoxDecoration(
                  color: context.colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colors.border, width: 1.5),
                )
              : null,
          child: Column(
            children: [
              face,
              const SizedBox(height: 4),
              ShrinkText(
                name,
                maxLines: 1,
                style: TextStyle(color: context.colors.muted, fontSize: 15),
              ),
              Text(
                localNumber(context, reps),
                style: TextStyle(
                  color: colour,
                  fontSize: 58,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
              Text(
                won ? l.winnerLabel : '',
                style: TextStyle(color: context.colors.text, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    final me = backend.me;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          side(
            face: PersonAvatar(
              id: me?.id ?? '',
              name: demoProfile.username,
              avatarUrl: me?.avatarUrl,
              size: 70,
              mine: true,
            ),
            name: l.you,
            reps: you,
            colour: beat ? context.colors.text : context.colors.rival,
            won: beat,
          ),
          side(
            face: PersonAvatar(
              id: owner.id,
              name: owner.username,
              avatarUrl: owner.avatarUrl,
              size: 70,
            ),
            name: owner.username,
            reps: them,
            colour: beat ? context.colors.rival : context.colors.text,
            won: !beat,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────── the board ──────────────────────────────────

/// Everybody on a challenge, best first, this account's own line outlined.
class ChallengeBoard extends StatelessWidget {
  const ChallengeBoard({
    super.key,
    required this.view,
    this.you,
    this.caption,
  });

  final ChallengeView view;

  /// This account's id, to mark its line.
  final String? you;

  /// What the caption's right side says; how many took it when null.
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final takes = view.board.where((e) => !e.owner).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BoardCaption(
          left: l.onThisChallenge,
          right: caption ?? l.challengeTookIt(localNumber(context, takes)),
        ),
        _Rows(
          children: [
            for (final entry in view.board)
              _BoardRow(
                entry: entry,
                mine: !entry.owner && entry.id == you,
                challengeReps: view.reps,
              ),
          ],
        ),
      ],
    );
  }
}

class _BoardCaption extends StatelessWidget {
  const _BoardCaption({required this.left, this.right, this.rightColour});

  final String left;
  final String? right;
  final Color? rightColour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      // Each side as wide as its words, the count at the far end; two long
      // ones share the row and wrap.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              left,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (right case final text?) ...[
            const SizedBox(width: 10),
            // Room for both: a long count in a long language wraps rather
            // than pushing the row off the screen.
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: rightColour ?? context.colors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Rows on one card, a hairline between them.
class _Rows extends StatelessWidget {
  const _Rows({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (final (i, child) in children.indexed) ...[
            if (i > 0) Divider(height: 1, color: context.colors.border),
            child,
          ],
        ],
      ),
    );
  }
}

class _BoardRow extends StatelessWidget {
  const _BoardRow({
    required this.entry,
    required this.mine,
    required this.challengeReps,
  });

  final ChallengeEntry entry;
  final bool mine;
  final int challengeReps;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: mine
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.brand, width: 1.5),
            )
          : null,
      child: Row(
        children: [
          PersonAvatar(
            id: entry.id,
            name: entry.username,
            avatarUrl: entry.avatarUrl,
            size: 38,
            mine: mine,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mine ? l.you : entry.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.owner)
                  Text(
                    l.challengeSetIt,
                    style: TextStyle(color: context.colors.muted, fontSize: 12),
                  ),
              ],
            ),
          ),
          if (entry.beat && !mine) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: context.colors.rival.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                l.challengeBeatTag.toUpperCase(),
                style: TextStyle(
                  color: context.colors.rival,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            localNumber(context, entry.reps),
            style: TextStyle(
              color: context.colors.text,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// The small tag at the top: "CHALLENGE · FRIENDLY".
class ChallengePill extends StatelessWidget {
  const ChallengePill({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: context.colors.rival,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The number to beat, as big as the screen allows.
class _BigCount extends StatelessWidget {
  const _BigCount({required this.reps});

  final int reps;

  @override
  Widget build(BuildContext context) {
    return Text(
      localNumber(context, reps),
      style: TextStyle(
        color: context.colors.text,
        fontSize: 104,
        fontWeight: FontWeight.w900,
        height: 1.05,
        letterSpacing: -2,
      ),
    );
  }
}

// ───────────────────────────── on the profile ────────────────────────────────

/// This account's challenges from the last month: each one's number, how
/// many took it and how many beat it, opening "Your challenge".
class MyChallengesScreen extends StatefulWidget {
  const MyChallengesScreen({super.key});

  @override
  State<MyChallengesScreen> createState() => _MyChallengesScreenState();
}

class _MyChallengesScreenState extends State<MyChallengesScreen> {
  List<MyChallenge>? _mine;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _failed = false);
    try {
      final mine = await backend.myChallenges();
      if (!mounted) return;
      setState(() => _mine = mine);
    } on Object catch (error) {
      debugPrint('Could not read the challenges: $error');
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final mine = _mine;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        title: Text(l.challengesTitle),
      ),
      body: _failed
          ? BlockingNotice(
              icon: Icons.wifi_off,
              title: l.noConnection,
              body: l.needsServer,
              actionLabel: l.retry,
              onAction: _load,
            )
          : mine == null
          ? Center(
              child: CircularProgressIndicator(color: context.colors.brand),
            )
          : mine.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l.noChallengesYet,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.muted, fontSize: 15),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Rows(
                  children: [
                    for (final c in mine)
                      ListTile(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChallengeScreen(code: c.code),
                            ),
                          );
                          _load();
                        },
                        leading: Text(
                          localNumber(context, c.reps),
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        title: Text(
                          l.challengeTookIt(localNumber(context, c.takes)),
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          c.open
                              ? l.challengeOpenUntil(
                                  MaterialLocalizations.of(
                                    context,
                                  ).formatMediumDate(c.expiresAt),
                                )
                              : l.challengeClosed,
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 13,
                          ),
                        ),
                        trailing: c.beat > 0
                            ? Text(
                                l.challengeBeatYou(localNumber(context, c.beat)),
                                style: TextStyle(
                                  color: context.colors.rival,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Icon(
                                Icons.chevron_right,
                                color: context.colors.muted,
                              ),
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}
