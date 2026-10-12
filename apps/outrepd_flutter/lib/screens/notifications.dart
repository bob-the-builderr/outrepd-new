/// What happened while you were away.
///
/// The one that matters is "your set was raced". A duel here is async — you
/// race somebody's stored minute and they are not there for it — so without
/// this screen half of every match is invisible to the person who was in it.
/// They lifted, somebody beat them or failed to, their rank moved, and the
/// app never mentioned it.
///
/// Opening the screen marks everything read. There is no "mark all as read"
/// button, because looking at them is what having seen them means.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';
import 'match_entry.dart';
import 'live_invite.dart';
import 'match_flow.dart';
import 'other_profile.dart';
import 'share_card.dart';
import 'shell.dart';

/// Opens the list from inside the [AppShell], and follows a friend request
/// tapped in it to the Friends tab: answering one happens there, under this
/// screen rather than on top of it.
Future<void> openNotifications(BuildContext context) async {
  final exit = await Navigator.of(context).push<NoticeExit>(
    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
  );
  if (exit == NoticeExit.friendRequests && context.mounted) {
    AppShell.goToFriendRequests(context);
  }
}

/// What the screen under the list is asked to open as it closes.
enum NoticeExit { friendRequests }

/// Pops with a [NoticeExit] when a notice leads to a tab — open it with
/// [openNotifications], which follows it there.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Notice> _notices = const [];
  bool _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    if (backend.available) _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final notices = await backend.notices();
      if (!mounted) return;
      setState(() {
        _notices = notices;
        _loading = false;
      });
      // Marked read after they are on screen, not before: a notice cleared
      // by a fetch that then failed to draw is a notice nobody ever saw.
      await backend.readNotices();
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.notifications)),
      body: RefreshIndicator(onRefresh: _load, child: _body(context, l)),
    );
  }

  Widget _body(BuildContext context, L l) {
    if (!backend.available) return const _DemoList();

    if (_loading && _notices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Nothing to report and could not ask are different answers, and only one
    // of them is about the lifter.
    if (_error != null && _notices.isEmpty) {
      return BlockingNotice(
        icon: Icons.wifi_off,
        title: l.noConnection,
        body: l.noConnectionBody,
        actionLabel: l.retry,
        onAction: _load,
      );
    }

    if (_notices.isEmpty) {
      return EmptyState(
        icon: Icons.notifications_none,
        title: l.noNotificationsTitle,
        body: l.noNotificationsBody,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _notices.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _NoticeTile(notice: _notices[i]),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  const _NoticeTile({required this.notice});

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    final heading = switch (notice.kind) {
      NoticeKind.raced => l.nRacedTitle,
      NoticeKind.friendRequest => l.nFriendTitle,
      NoticeKind.friendAccepted => l.nFriendOkTitle,
      NoticeKind.challenged => l.nChallengedTitle,
      NoticeKind.liveInvite => l.nLiveTitle,
    };

    final detail = switch (notice.kind) {
      NoticeKind.raced => _raced(context, l),
      NoticeKind.friendRequest => l.nFriendBody(notice.actorName),
      NoticeKind.friendAccepted => l.nFriendOkBody(notice.actorName),
      NoticeKind.challenged => l.nChallengedBody(notice.actorName),
      NoticeKind.liveInvite => l.nLiveBody(notice.actorName),
    };

    // Each one opens what it is about. A challenge opens the duel it asks
    // for. A raced set opens the card to share it — the lifter who raced
    // could share from their result screen, and the one who was raced only
    // ever hears about it here. A friend request goes to the requests, a yes
    // to the new friend. Only a notice whose account is gone opens nothing.
    final VoidCallback? onTap = switch (notice.kind) {
      // Still open, it joins; run out, it says so. The list keeps the notice
      // either way, as the record that they asked.
      NoticeKind.liveInvite when notice.actorId != null => () =>
          _joinFrom(context, notice.actorId!),
      NoticeKind.challenged when notice.actorId != null => () =>
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MatchFlowScreen(
                mode: MatchMode.challengeAccept,
                targetId: notice.actorId,
              ),
            ),
          ),
      NoticeKind.raced
          when notice.youWon != null &&
              notice.yourReps != null &&
              notice.theirReps != null =>
        () => showMatchShareSheet(
              context,
              data: MatchShareData(
                username: demoProfile.username,
                won: notice.youWon!,
                yourReps: notice.yourReps!,
                theirReps: notice.theirReps!,
                opponent: notice.actorName,
                seconds: kDuelLength.inSeconds,
                // Where the account stands now, and what this duel did to
                // it when the server said (older notices do not carry it).
                tierIdx: demoProfile.isRanked ? demoProfile.tierIdx : null,
                divIdx: demoProfile.divIdx,
                lpDelta: notice.lpDelta,
                avatarUrl: backend.me?.avatarUrl,
              ),
            ),
      // An older result, from before notices carried the score: the
      // opponent, at least.
      NoticeKind.raced when notice.actorId != null => () =>
          _openProfile(context, notice),
      // Answered on the Friends tab, under this screen: back there, with the
      // requests open.
      NoticeKind.friendRequest => () =>
          Navigator.of(context).pop(NoticeExit.friendRequests),
      NoticeKind.friendAccepted when notice.actorId != null => () =>
          _openProfile(context, notice),
      _ => null,
    };

    return _Row(
      heading: heading,
      detail: detail,
      // The days since, from the instant it happened rather than a number
      // that was written down once and never moved.
      when: relativeDays(context, DateTime.now().difference(notice.at).inDays),
      unread: notice.unread,
      onTap: onTap,
    );
  }

  /// Both counts, and which way it went. A result with no score is a rumour.
  String _raced(BuildContext context, L l) {
    final yours = localNumber(context, notice.yourReps ?? 0);
    final theirs = localNumber(context, notice.theirReps ?? 0);
    return (notice.youWon ?? false)
        ? l.nRacedHeld(notice.actorName, yours, theirs)
        : l.nRacedBeaten(notice.actorName, yours, theirs);
  }
}

/// The sample list, for a build with no server behind it.
class _DemoList extends StatelessWidget {
  const _DemoList();

  @override
  Widget build(BuildContext context) {
    if (demoNotifications.isEmpty) {
      return EmptyState(
        icon: Icons.notifications_none,
        title: L.of(context).noNotificationsTitle,
        body: L.of(context).noNotificationsBody,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: demoNotifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final n = demoNotifications[i];
        return _Row(
          heading: n.heading(L.of(context)),
          detail: n.detail(L.of(context)),
          when: relativeDays(context, n.daysAgo),
          unread: n.unread,
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.heading,
    required this.detail,
    required this.when,
    required this.unread,
    this.onTap,
  });

  final String heading;
  final String detail;
  final String when;
  final bool unread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsetsDirectional.only(top: 6, end: 12),
            decoration: BoxDecoration(
              color: unread ? context.colors.brand : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: context.type.body.copyWith(color: context.colors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: context.type.label.copyWith(
                    color: context.colors.muted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  when,
                  style: context.type.label.copyWith(
                    color: context.colors.muted,
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

/// The lifter a notice is about, by the name it was sent under.
void _openProfile(BuildContext context, Notice notice) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) =>
          OtherProfileScreen(id: notice.actorId!, username: notice.actorName),
    ),
  );
}

/// A live invite tapped in the list: joined if it is still open, and said so
/// if it has run out.
Future<void> _joinFrom(BuildContext context, String fromId) async {
  final messenger = ScaffoldMessenger.of(context);
  final gone = L.of(context).inviteGone;
  try {
    final invites = await backend.liveInvites();
    for (final invite in invites) {
      if (invite.from.id != fromId) continue;
      if (context.mounted) await joinLiveInvite(context, invite);
      return;
    }
  } on Object catch (error) {
    debugPrint('Could not read live invites: $error');
  }
  messenger.showSnackBar(
    SnackBar(content: Text(gone), behavior: SnackBarBehavior.floating),
  );
}
