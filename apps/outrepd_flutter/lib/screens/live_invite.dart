/// Live with a friend: asking, waiting, and being asked.
///
/// The one asking waits on [LiveInviteScreen] with their friend's picture
/// and the minute the invite lasts. The one asked gets a notice and a push,
/// and — with the app open — [LiveInviteBanner] across the top of whatever
/// screen they are on. Either way it ends in the same match
/// ([MatchMode.liveFriend]), friendly, moving no rank.
library;

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../player_avatar.dart';
import '../theme.dart';
import '../widgets.dart';
import 'match_entry.dart';
import 'match_flow.dart';

/// How long an invite lasts; supabase/live.sql holds the same minute.
const kLiveInviteFor = Duration(seconds: 60);

/// Accepts [invite] and opens the match, or says it has run out.
Future<void> joinLiveInvite(BuildContext context, LiveInvite invite) async {
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);
  final gone = L.of(context).inviteGone;
  try {
    final status = await backend.answerLiveInvite(
      invite.matchId,
      accept: true,
    );
    if (status == LiveStatus.ready || status == LiveStatus.live) {
      await navigator.push(
        MaterialPageRoute(
          builder: (_) => MatchFlowScreen(
            mode: MatchMode.liveFriend,
            liveMatch: LiveMatch(
              id: invite.matchId,
              ranked: false,
              opponent: invite.from,
            ),
          ),
        ),
      );
      return;
    }
  } on Object catch (error) {
    debugPrint('Could not join the live invite: $error');
  }
  messenger.showSnackBar(
    SnackBar(content: Text(gone), behavior: SnackBarBehavior.floating),
  );
}

/// The one who asked, waiting for an answer.
class LiveInviteScreen extends StatefulWidget {
  const LiveInviteScreen({super.key, required this.friend});

  final LiveOpponent friend;

  @override
  State<LiveInviteScreen> createState() => _LiveInviteScreenState();
}

class _LiveInviteScreenState extends State<LiveInviteScreen> {
  String? _matchId;
  DateTime? _deadline;
  Timer? _poll;

  /// How it ended without a match, once it has.
  LiveStatus? _ended;

  /// The invite never reached the server.
  bool _failed = false;

  /// Handed over to the match; nothing left here to withdraw.
  bool _handedOver = false;

  @override
  void initState() {
    super.initState();
    _invite();
  }

  @override
  void dispose() {
    _poll?.cancel();
    // Left before an answer: the friend should not join an empty room.
    final id = _matchId;
    if (id != null && !_handedOver && _ended == null) {
      unawaited(
        backend.cancelLiveInvite(id).catchError(
          (Object error) => debugPrint('Could not withdraw the invite: $error'),
        ),
      );
    }
    super.dispose();
  }

  Future<void> _invite() async {
    _poll?.cancel();
    setState(() {
      _ended = null;
      _failed = false;
      _matchId = null;
      _deadline = clock.now().add(kLiveInviteFor);
    });
    try {
      final id = await backend.inviteLive(widget.friend.id);
      if (!mounted) return;
      _matchId = id;
      _poll = Timer.periodic(const Duration(seconds: 1), (_) => _check());
    } on Object catch (error) {
      debugPrint('Could not send the live invite: $error');
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _check() async {
    final id = _matchId;
    if (id == null || _handedOver) return;
    if (mounted) setState(() {});
    try {
      final state = await backend.liveState(id);
      if (!mounted || _handedOver) return;
      if (state.expiresIn case final left?) {
        _deadline = clock.now().add(left);
      }
      switch (state.status) {
        case LiveStatus.ready || LiveStatus.live:
          _handedOver = true;
          _poll?.cancel();
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MatchFlowScreen(
                mode: MatchMode.liveFriend,
                liveMatch: LiveMatch(
                  id: id,
                  ranked: false,
                  opponent: widget.friend,
                ),
              ),
            ),
          );
        case LiveStatus.declined ||
            LiveStatus.expired ||
            LiveStatus.cancelled:
          _poll?.cancel();
          setState(() => _ended = state.status);
        case LiveStatus.invited || LiveStatus.done:
          break;
      }
    } on Object catch (error) {
      debugPrint('Could not check the live invite: $error');
    }
  }

  void _cancel() {
    _poll?.cancel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final name = widget.friend.username;
    final left = _deadline == null
        ? kLiveInviteFor
        : _deadline!.difference(clock.now());
    final seconds = left.isNegative ? 0 : left.inSeconds;
    final waiting = _ended == null && !_failed;

    final String title;
    if (_failed) {
      title = l.needsServer;
    } else if (_ended == LiveStatus.declined) {
      title = l.inviteDeclined(name);
    } else if (_ended != null) {
      title = l.inviteRanOut;
    } else {
      title = l.waitingForName(name);
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),
            Text(
              l.friendlyNoRank,
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
            const Spacer(flex: 2),
            Container(
              width: 156,
              height: 156,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colors.rival.withValues(
                    alpha: waiting ? 0.45 : 0.15,
                  ),
                  width: 3,
                ),
              ),
              child: PlayerAvatar(
                name: name,
                tierIdx: widget.friend.tierIdx,
                size: 124,
                textColour: context.colors.rival,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (waiting) ...[
              const SizedBox(height: 8),
              Text(
                l.weSentThemANotice,
                style: TextStyle(color: context.colors.muted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Text(
                formatClock(context, seconds),
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 36,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                l.untilInviteRunsOut,
                style: TextStyle(color: context.colors.faint, fontSize: 12),
              ),
            ],
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
              child: Column(
                children: [
                  if (!waiting && !_failed) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _invite,
                        child: Text(l.inviteAgain),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      key: const Key('cancelLiveInvite'),
                      onPressed: _cancel,
                      child: Text(waiting ? l.cancelInvite : l.backToHome),
                    ),
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

/// A friend's invite, across the top of whatever screen the one asked is on:
/// who, how long it has left, and Join. Swiped away, it is gone from this
/// phone; the notice in the list stays.
class LiveInviteBanner extends StatefulWidget {
  const LiveInviteBanner({
    super.key,
    required this.invite,
    required this.readAt,
    required this.onJoin,
  });

  final LiveInvite invite;

  /// When [invite]'s time left was read, to count down from.
  final DateTime readAt;
  final VoidCallback onJoin;

  @override
  State<LiveInviteBanner> createState() => _LiveInviteBannerState();
}

class _LiveInviteBannerState extends State<LiveInviteBanner> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final from = widget.invite.from;
    final left = widget.invite.expiresIn - clock.now().difference(widget.readAt);
    final seconds = left.isNegative ? 0 : left.inSeconds;

    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.rival),
        ),
        child: Row(
          children: [
            PlayerAvatar(
              name: from.username,
              tierIdx: from.tierIdx,
              size: 44,
              textColour: context.colors.rival,
              ringColour: context.colors.surface,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.liveInviteFrom(from.username),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    l.timeLeft(formatClock(context, seconds)),
                    style: TextStyle(color: context.colors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              key: const Key('joinLiveInvite'),
              onPressed: widget.onJoin,
              child: Text(l.joinLive),
            ),
          ],
        ),
      ),
    );
  }
}
