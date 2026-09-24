/// The friends list.
///
/// Built to the spec's numbers, with one rule that is about people rather than
/// layout: every row carries the head-to-head record against you. A rank says
/// how good somebody is in general and gives nobody a reason to tap. "0W 4L vs
/// you" is a score to settle, and that is what opens a match.
///
/// Online is `last_seen` within a few minutes rather than a presence socket.
/// It answers the question the dot is really asking — "are they around" — at
/// the cost of one column.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';
import 'match_entry.dart';
import 'other_profile.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final _search = TextEditingController();

  List<Friend> _friends = const [];
  List<FriendRequest> _requests = const [];

  /// People found on the server by name, for the search that is not just a
  /// filter over people already on the list.
  List<FoundLifter> _found = const [];
  bool _searching = false;

  bool _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    if (backend.available) {
      _load();
    } else {
      _friends = demoFriends;
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (!backend.available) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final friends = await backend.friends();
      final requests = await backend.friendRequests();
      if (!mounted) return;
      setState(() {
        _friends = [
          for (final f in friends)
            Friend(
              f.username,
              f.tierIdx,
              f.divIdx,
              f.lp,
              f.online,
              id: f.id,
              winsVsYou: f.winsVsYou,
              lossesVsYou: f.lossesVsYou,
              avatarUrl: f.avatarUrl,
            ),
        ];
        _requests = requests;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  /// Looks for people who are not already on the list.
  ///
  /// Only once there is enough to go on: the server refuses a query under two
  /// characters, because "a" is not a search, it is a request for the
  /// userbase.
  Future<void> _lookUp(String query) async {
    if (!backend.available || query.trim().length < 2) {
      setState(() => _found = const []);
      return;
    }
    setState(() => _searching = true);
    try {
      final found = await backend.findLifters(query.trim());
      if (!mounted) return;
      final known = {for (final f in _friends) f.username};
      setState(() {
        _found = [
          for (final f in found)
            if (!known.contains(f.username)) f,
        ];
        _searching = false;
      });
    } on Object catch (_) {
      if (!mounted) return;
      setState(() => _searching = false);
    }
  }

  Future<void> _ask(String username) async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await backend.askFriend(username);
      if (!mounted) return;
      final said = switch (result) {
        AskResult.asked => l.requestSent(username),
        AskResult.friends => l.nowFriends(username),
        AskResult.noSuchLifter => l.noOneFound,
        AskResult.thatIsYou => l.noOneFound,
      };
      messenger.showSnackBar(
        SnackBar(content: Text(said), behavior: SnackBarBehavior.floating),
      );
      setState(
        () => _found = [
          for (final f in _found)
            if (f.username != username) f,
        ],
      );
      if (result == AskResult.friends) await _load();
    } on Object catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openRequests() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      showDragHandle: true,
      builder: (_) => _RequestsSheet(
        requests: _requests,
        onAnswer: (request, accept) async {
          await backend.answerFriend(request.id, accept: accept);
          await _load();
        },
      ),
    );
    if (mounted) await _load();
  }

  /// The list as the search box leaves it. A search field that only decorates
  /// the top of a list is worse than none — people type into it and conclude
  /// the app is broken.
  List<Friend> get _matching {
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return _friends;
    return _friends
        .where((f) => f.username.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final matching = _matching;
    final online = matching.where((f) => f.online).toList();
    final offline = matching.where((f) => !f.online).toList();
    final searching = _search.text.trim().isNotEmpty;

    // At most one of these ever applies, and each one is the entire answer
    // to "what does the list look like right now" — nothing else renders
    // beneath it. Kept as one value rather than an if/else-if chain inline
    // below so it can fill the rest of the screen through SliverFillRemaining
    // instead of sitting pinned under the search field with empty space
    // beneath it.
    Widget? specialState;
    if (_loading && _friends.isEmpty) {
      specialState = const Padding(
        padding: EdgeInsets.only(top: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_error != null && _friends.isEmpty) {
      specialState = Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          l.noConnectionBody,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.muted, fontSize: 13),
        ),
      );
    } else if (_friends.isEmpty && !searching) {
      specialState = EmptyState(
        icon: Icons.people_outline,
        title: l.noFriendsTitle,
        body: l.noFriendsBody,
        action: PillButton(
          label: l.findPeople,
          // The search field above is the way to find somebody, so this
          // points at it rather than opening a second one.
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        ),
      );
    } else if (matching.isEmpty && _found.isEmpty && !_searching) {
      // Searching into an empty result is not the same as having no friends.
      specialState = Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          l.noFriendsMatch,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.muted, fontSize: 13),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _load,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          l.tabFriends.toUpperCase(),
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SearchField(
                        controller: _search,
                        onChanged: (query) {
                          setState(() {});
                          _lookUp(query);
                        },
                      ),
                      // Hidden at zero: a row reading "Incoming requests 0"
                      // is a control that leads nowhere, and it sits at the
                      // top of the screen where the most useful thing
                      // should be.
                      if (_requests.isNotEmpty) ...[
                        const SizedBox(height: 9),
                        _RequestsRow(
                          count: _requests.length,
                          onTap: _openRequests,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (specialState case final state?)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: state,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (online.isNotEmpty) ...[
                        _SectionLabel(
                          l.onlineNowCount(localNumber(context, online.length)),
                        ),
                        for (final friend in online) _FriendRow(friend: friend),
                      ],
                      if (offline.isNotEmpty) ...[
                        _SectionLabel(
                          l.offlineCount(localNumber(context, offline.length)),
                        ),
                        for (final friend in offline)
                          _FriendRow(friend: friend),
                      ],
                      // People who are not friends yet, kept below the list
                      // so a search never buries the people already on it.
                      if (_found.isNotEmpty) ...[
                        _SectionLabel(l.findPeople),
                        for (final lifter in _found)
                          _FoundRow(
                            lifter: lifter,
                            onAdd: () => _ask(lifter.username),
                          ),
                      ],
                    ]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A person the search turned up who is not a friend yet.
class _FoundRow extends StatelessWidget {
  const _FoundRow({required this.lifter, required this.onAdd});

  final FoundLifter lifter;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    // Below five placements they have no rank, and their tier column is a
    // default rather than something they earned.
    final rank = lifter.placementsDone >= kPlacementDuels
        ? tierLabel(l, lifter.tierIdx, lifter.divIdx)
        : l.unranked;

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: context.colors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Builder(
              builder: (context) {
                final fallback = Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.surfaceRaised,
                  ),
                  child: Text(
                    lifter.username.isEmpty
                        ? '?'
                        : lifter.username.characters.first.toUpperCase(),
                    style: TextStyle(color: context.colors.text, fontSize: 13),
                  ),
                );
                if (lifter.avatarUrl == null) return fallback;
                return ClipOval(
                  child: Image.network(
                    lifter.avatarUrl!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : fallback,
                    errorBuilder: (context, error, stack) => fallback,
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lifter.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.colors.text, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rank,
                    style: TextStyle(color: context.colors.muted, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(11),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: context.colors.brand,
                ),
                child: Text(
                  l.addFriend,
                  style: TextStyle(
                    color: context.colors.background,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The requests waiting on an answer, and the two answers.
class _RequestsSheet extends StatelessWidget {
  const _RequestsSheet({required this.requests, required this.onAnswer});

  final List<FriendRequest> requests;
  final Future<void> Function(FriendRequest request, bool accept) onAnswer;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            l.incomingRequests,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          for (final request in requests)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          tierLabel(l, request.tierIdx, request.divIdx),
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await onAnswer(request, false);
                    },
                    child: Text(
                      l.decline,
                      style: TextStyle(color: context.colors.muted),
                    ),
                  ),
                  const SizedBox(width: 4),
                  FilledButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await onAnswer(request, true);
                    },
                    child: Text(l.accept),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────── search ─────────────────────────────────────

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 16, color: context.colors.muted),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(color: context.colors.text, fontSize: 13),
              cursorColor: context.colors.brand,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                // The field is already a box; the decoration would draw a
                // second one inside it.
                contentPadding: EdgeInsets.zero,
                hintText: L.of(context).searchByUsername,
                hintStyle: TextStyle(color: context.colors.faint, fontSize: 13),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged('');
              },
              child: Icon(Icons.close, size: 16, color: context.colors.muted),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────── incoming requests ──────────────────────────────

class _RequestsRow extends StatelessWidget {
  const _RequestsRow({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: context.colors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(Icons.person_add_alt_1, size: 17, color: context.colors.brand),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l.incomingRequests,
                style: TextStyle(color: context.colors.text, fontSize: 13),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: context.colors.brand,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                localNumber(context, count),
                style: TextStyle(
                  color: context.colors.background,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 15, color: context.colors.muted),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────── sections ───────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 9, left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: context.colors.muted,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────── friend rows ─────────────────────────────────

class _FriendRow extends StatelessWidget {
  const _FriendRow({required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Opacity(
        // Offline rows step back rather than disappear: they are still people
        // you can invite, just not people you can challenge this minute.
        opacity: friend.online ? 1 : 0.6,
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          // A demo row has no real id to fetch a profile for — same reason
          // the Challenge button beside it explains itself instead of doing
          // nothing, rather than opening a sheet that can only show an error.
          onTap: friend.id.isEmpty
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.needsServer),
                    behavior: SnackBarBehavior.floating,
                  ),
                )
              : () => showLifterPeek(
                  context,
                  id: friend.id,
                  username: friend.username,
                ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: context.colors.border, width: 0.5),
            ),
            child: Row(
              children: [
                _Avatar(friend: friend),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        friend.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.colors.text,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      ShrinkText(
                        _subtitle(context, l),
                        maxLines: 1,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _ActionButton(friend: friend),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Rank, then the record. Somebody you have never faced says so instead of
  /// showing "0W 0L", which reads like a loss you cannot remember.
  String _subtitle(BuildContext context, L l) {
    final rank = tierLabel(l, friend.tierIdx, friend.divIdx);
    if (!friend.hasPlayedYou) return '$rank · ${l.neverPlayedYou}';
    return '$rank · ${l.headToHead(localNumber(context, friend.winsVsYou), localNumber(context, friend.lossesVsYou))}';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Builder(
            builder: (context) {
              final fallback = Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.surfaceRaised,
                ),
                child: Text(
                  friend.username.isEmpty
                      ? '?'
                      : friend.username.characters.first.toUpperCase(),
                  style: TextStyle(color: context.colors.text, fontSize: 13),
                ),
              );
              if (friend.avatarUrl == null) return fallback;
              return ClipOval(
                child: Image.network(
                  friend.avatarUrl!,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : fallback,
                  errorBuilder: (context, error, stack) => fallback,
                ),
              );
            },
          ),
          if (friend.online)
            PositionedDirectional(
              end: 0,
              bottom: 0,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  // The ring is the card's own colour, so the dot reads as
                  // sitting on top of the avatar rather than cut out of it.
                  border: Border.all(color: context.colors.surface, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final online = friend.online;

    return InkWell(
      // The reserved-set challenge a friend races later does not care
      // whether they are online right now — "Invite" is the same action as
      // "Challenge", just worded for somebody who is not around to answer at
      // once. A demo row has no real id behind it to send one to.
      onTap: friend.id.isEmpty
          ? () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.needsServer),
                behavior: SnackBarBehavior.floating,
              ),
            )
          : () => startMatch(
              context,
              mode: MatchMode.challenge,
              targetId: friend.id,
              targetUsername: friend.username,
              targetTierIdx: friend.tierIdx,
              targetDivIdx: friend.divIdx,
            ),
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: online ? context.colors.brand : null,
          border: online
              ? null
              : Border.all(color: context.colors.border, width: 0.5),
        ),
        child: Text(
          online ? l.challenge : l.invite,
          style: TextStyle(
            // On the filled button the label is the page's background colour,
            // which is the only thing dark enough to read on `brand`.
            color: online ? context.colors.background : context.colors.text,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
