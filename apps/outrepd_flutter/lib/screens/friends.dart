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

import 'dart:async';

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../face.dart';
import '../l10n/app_localizations.dart';
import '../lifter/lifter_view.dart';
import '../lifter/looks.dart';
import '../motion.dart';
import '../photo_cache.dart';
import '../pill_strip.dart';
import '../player_avatar.dart';
import '../theme.dart';
import '../tier_frame.dart';
import '../type_scale.dart';
import '../widgets.dart';
import 'bring_friend_card.dart';
import 'live_invite.dart';
import 'other_profile.dart';
import 'ranks.dart' show FriendRanks;
import 'shell.dart';

/// How long the list is shown before it is read again while somebody is
/// looking at it.
const kListFreshFor = Duration(seconds: 30);

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  /// Opens the requests from outside the tab — a friend request tapped in
  /// the notifications. The tab is kept alive under the others, so it hears
  /// this rather than being built again.
  static void showRequests() => _requestsAsked.value++;
  static final _requestsAsked = ValueNotifier<int>(0);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final _search = TextEditingController();

  List<Friend> _friends = const [];
  List<FriendRequest> _requests = const [];

  bool _loading = false;
  Object? _error;

  /// When the list was last read. Null is "read it before showing it again":
  /// never read, or this account's own duel has moved a rank and a
  /// head-to-head on it since.
  DateTime? _fetchedAt;
  Timer? _tick;

  /// Ranks among friends rather than the list (pick B, 2026-11-07).
  bool _ranks = false;

  @override
  void initState() {
    super.initState();
    FriendsScreen._requestsAsked.addListener(_showRequests);
    if (backend.available) {
      _load();
      shownTab.addListener(_onShowing);
      Career.instance.addListener(_onOwnResult);
      // Who is online decides Challenge or Invite, and ranks move with every
      // duel: read again while the list is being looked at.
      _tick = Timer.periodic(kListFreshFor, (_) => _refreshIfShowing());
    } else {
      _friends = demoFriends;
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    shownTab.removeListener(_onShowing);
    Career.instance.removeListener(_onOwnResult);
    FriendsScreen._requestsAsked.removeListener(_showRequests);
    _search.dispose();
    super.dispose();
  }

  bool get _showing => shownTab.value == AppShell.friendsTabIndex;

  void _onShowing() {
    if (_showing) _refreshIfShowing();
  }

  void _onOwnResult() {
    _fetchedAt = null;
    _refreshIfShowing();
  }

  /// Read again, keeping the list on screen while it is, when it is in view
  /// and out of date — not under another screen, nor in the background.
  void _refreshIfShowing() {
    if (!mounted || !_showing || _loading) return;
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
    final state = WidgetsBinding.instance.lifecycleState;
    if (state != null && state != AppLifecycleState.resumed) return;
    final at = _fetchedAt;
    if (at != null && DateTime.now().difference(at) < kListFreshFor) return;
    _load();
  }

  /// The latest requests, then the sheet to answer them in.
  Future<void> _showRequests() async {
    await _load();
    if (mounted) await _openRequests();
  }

  /// The list is kept on screen while it is read again; the spinner and the
  /// error are only for an empty one (build).
  Future<void> _load() async {
    if (!backend.available) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Both at once: neither waits on the other, and one trip's wait is
      // shorter than two.
      final (friends, requests) = await (
        backend.friends(),
        backend.friendRequests(),
      ).wait;
      // How they look — a Pro's row, the lifter each made — and their
      // pictures, asked for before the rows are drawn.
      unawaited(Looks.instance.fetch([for (final f in friends) f.id]));
      PhotoBytes.instance.warmSmall([for (final f in friends) f.avatarUrl]);
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
              xp: f.xp,
              placementsDone: f.placementsDone,
            ),
        ];
        _requests = requests;
        _loading = false;
        _fetchedAt = DateTime.now();
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  /// Opens the add-by-identifier sheet and reports whatever it did, on this
  /// screen's own context — the sheet's is already gone by the time an
  /// answer comes back, since it pops itself the moment the server answers.
  Future<void> _openAddFriend() async {
    final outcome = await showModalBottomSheet<_AddFriendOutcome>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => const _AddFriendSheet(),
    );
    if (!mounted || outcome == null) return;
    final l = L.of(context);
    final said = switch (outcome.result) {
      AskResult.asked => l.requestSent(outcome.identifier),
      AskResult.friends => l.nowFriends(outcome.identifier),
      AskResult.noSuchLifter => l.noOneFound,
      AskResult.thatIsYou => l.noOneFound,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(said), behavior: SnackBarBehavior.floating),
    );
    if (outcome.result == AskResult.friends) await _load();
  }

  Future<void> _openRequests() async {
    await showModalBottomSheet<void>(
      context: context,
      // The page colour, so each request card stands out from it.
      backgroundColor: context.colors.background,
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
    // Nobody to rank yet: there is only the list to look at.
    final showRanks = _ranks && _friends.isNotEmpty;

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
          style: TextStyle(color: context.colors.muted, fontSize: 15),
        ),
      );
    } else if (_friends.isEmpty && !searching) {
      specialState = EmptyState(
        icon: Icons.people_outline,
        title: l.noFriendsTitle,
        body: l.noFriendsBody,
        action: PillButton(label: l.addFriendAction, onTap: _openAddFriend),
      );
    } else if (matching.isEmpty && !showRanks) {
      // A pure filter over friends already on the list — no server search
      // hides behind this field any more, so an empty result only ever means
      // one thing.
      specialState = Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          l.noFriendsMatch,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.muted, fontSize: 15),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l.tabFriends,
                                style: kPageTitle.copyWith(
                                  color: context.colors.text,
                                ),
                              ),
                            ),
                            _AddFriendButton(onTap: _openAddFriend),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_friends.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: PillStrip<bool>(
                            value: showRanks,
                            onChanged: (ranks) => setState(() => _ranks = ranks),
                            options: [
                              (false, l.tabFriends, const Key('friendsViewList')),
                              (true, l.tabRanks, const Key('friendsViewRanks')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 9),
                      ],
                      // A filter over the list below, and only that now —
                      // finding somebody new to add is Add Friend's job,
                      // above, so an empty result here can only ever mean
                      // one thing: nobody on the list matches.
                      if (!showRanks) ...[
                        _SearchField(
                          controller: _search,
                          onChanged: (query) => setState(() {}),
                        ),
                        // Always here, not just when something is waiting: a
                        // busy app gets requests often enough that "check for
                        // them" needs a fixed address, not a row that only
                        // exists once there is something to see.
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
              else if (showRanks)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  sliver: FriendRanks(friends: _friends),
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
                        _FriendGroup(friends: online),
                      ],
                      if (offline.isNotEmpty) ...[
                        _SectionLabel(
                          l.offlineCount(localNumber(context, offline.length)),
                        ),
                        _FriendGroup(friends: offline, from: online.length),
                      ],
                      // A way to bring somebody in, for everyone. The yearly
                      // plan's "give a friend 7 days free" card went with the
                      // email sign-up (2026-10-27): its code was typed there,
                      // and Apple and Google have nowhere to type one.
                      const SizedBox(height: 18),
                      const BringFriendCard(),
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

// ──────────────────────────────── add friend ──────────────────────────────────

class _AddFriendButton extends StatelessWidget {
  const _AddFriendButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: L.of(context).addFriendAction,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.person_add_alt_1_outlined,
            size: 21,
            color: context.colors.text,
          ),
        ),
      ),
    );
  }
}

/// What [_AddFriendSheet] did, reported once it has already popped itself —
/// the identifier is carried back with it so the snackbar can name whoever
/// was just asked without the caller needing to remember what was typed.
class _AddFriendOutcome {
  const _AddFriendOutcome(this.result, this.identifier);

  final AskResult result;
  final String identifier;
}

/// One field, either a username or a `#code`, and one button. Not a live
/// search: unlike the friend-room sheet in match_entry.dart, this is meant to
/// work from a code alone, which nothing about the person to add can be
/// shown for until the server has already resolved it.
class _AddFriendSheet extends StatefulWidget {
  const _AddFriendSheet();

  @override
  State<_AddFriendSheet> createState() => _AddFriendSheetState();
}

class _AddFriendSheetState extends State<_AddFriendSheet> {
  final _controller = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final identifier = _controller.text.trim();
    if (identifier.isEmpty) return;
    final l = L.of(context);
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final result = await backend.askFriend(identifier);
      if (!mounted) return;
      Navigator.of(context).pop(_AddFriendOutcome(result, identifier));
    } on Object catch (error) {
      debugPrint('Could not send a friend request: $error');
      if (!mounted) return;
      setState(() {
        _sending = false;
        _error = l.needsServer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final canSend = _controller.text.trim().isNotEmpty && !_sending;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.addFriendAction,
                style: context.type.heading.copyWith(color: context.colors.text),
              ),
              const SizedBox(height: 6),
              Text(
                l.addFriendHint,
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: context.colors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colors.border),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  autocorrect: false,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _send(),
                  style: TextStyle(color: context.colors.text, fontSize: 18),
                  cursorColor: context.colors.brand,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    hintText: l.usernameOrCode,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error ?? '',
                style: TextStyle(color: AppColors.loss, fontSize: 14),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canSend ? _send : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l.sendRequest),
                ),
              ),
            ],
          ),
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
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (requests.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                l.noRequestsWaiting,
                style: TextStyle(color: context.colors.muted, fontSize: 15),
              ),
            ),
          for (final request in requests)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RequestCard(
                request: request,
                onAnswer: (accept) async {
                  Navigator.of(context).pop();
                  await onAnswer(request, accept);
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// One request, with enough about whoever sent it to decide on: their photo
/// and name, when they asked, their rank, best set and record — and the two
/// answers, each a button a thumb can find.
class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.onAnswer});

  final FriendRequest request;
  final ValueChanged<bool> onAnswer;

  String _asked(BuildContext context) {
    final l = L.of(context);
    final at = request.askedAt;
    if (at == null) return l.wantsToBeFriends;
    final since = DateTime.now().difference(at);
    final String when;
    if (since.inMinutes < 60) {
      when = l.justNow;
    } else if (since.inHours < 24) {
      when = l.hoursAgo(localNumber(context, since.inHours));
    } else {
      when = relativeDays(context, since.inDays);
    }
    return '${l.wantsToBeFriends} · $when';
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final ranked = request.placementsDone >= kPlacementDuels;
    final photo = request.avatarUrl;
    final wins = localNumber(context, request.wins);
    final losses = localNumber(context, request.losses);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              PersonAvatar(
                id: request.id,
                name: request.username,
                avatarUrl: photo,
                tierIdx: ranked ? request.tierIdx : null,
                size: 52,
                textColour: context.colors.rival,
              ),
              const SizedBox(width: 12),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _asked(context),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  value: ranked
                      ? tierLabel(l, request.tierIdx, request.divIdx)
                      : l.unranked,
                  label: l.rankLabel,
                  colour: ranked
                      ? kTiers[request.tierIdx.clamp(0, kTiers.length - 1)]
                            .color
                      : context.colors.muted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Stat(
                  value: localNumber(context, request.bestSet),
                  label: l.bestSet,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Stat(value: '$wins–$losses', label: l.record),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _AnswerButton(
                  key: Key('decline-${request.id}'),
                  label: l.decline,
                  colour: AppColors.loss,
                  filled: false,
                  onTap: () => onAnswer(false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _AnswerButton(
                  key: Key('accept-${request.id}'),
                  label: l.accept,
                  colour: AppColors.success,
                  filled: true,
                  onTap: () => onAnswer(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.colour});

  final String value;
  final String label;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.surfaceRaised,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: colour ?? context.colors.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    super.key,
    required this.label,
    required this.colour,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final Color colour;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? colour : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: filled
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colour, width: 1.2),
                ),
          child: Text(
            label,
            style: TextStyle(
              color: filled ? context.colors.background : colour,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
              style: TextStyle(color: context.colors.text, fontSize: 15),
              cursorColor: context.colors.brand,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                // The field is already a box; the decoration would draw a
                // second one inside it.
                contentPadding: EdgeInsets.zero,
                hintText: L.of(context).searchByUsername,
                hintStyle: TextStyle(color: context.colors.faint, fontSize: 15),
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
                style: TextStyle(color: context.colors.text, fontSize: 15),
              ),
            ),
            // A row that is always here to check needs no badge to justify
            // its own presence — the pill is only for saying something is
            // actually waiting.
            if (count > 0) ...[
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
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
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
      child: Text(text, style: sectionLabelStyle(context)),
    );
  }
}

// ─────────────────────────────── friend rows ─────────────────────────────────

/// One section's friends in one card, a hairline between each (direction B,
/// 2026-11-02). It was a card for every friend, which crowded the list.
class _FriendGroup extends StatelessWidget {
  const _FriendGroup({required this.friends, this.from = 0});

  final List<Friend> friends;

  /// How many rows came before, so the rise-in runs on down the screen.
  final int from;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (final (i, friend) in friends.indexed) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 74),
                child: Divider(height: 1, thickness: 0.5, color: context.colors.border),
              ),
            RiseIn(
              delay: staggered(from + i),
              child: _FriendRow(friend: friend),
            ),
          ],
        ],
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  const _FriendRow({required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Opacity(
        // Offline rows step back rather than disappear: they are still people
        // you can invite, just not people you can challenge this minute.
        opacity: friend.online ? 1 : 0.6,
        child: InkWell(
          // A demo row has no real id to fetch a profile for, so it opens a
          // sample profile instead of one that can only show an error.
          onTap: () => openLifter(
            context,
            id: friend.id,
            username: friend.username,
            avatarUrl: friend.avatarUrl,
            initial: friend.id.isEmpty
                ? demoLifterProfile(friend.username)
                : null,
          ),
          // The card is the section's (_FriendGroup); the row is only a row.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                _Avatar(friend: friend),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NameWithLevel(
                        name: friend.username,
                        xp: friend.xp,
                        style: TextStyle(
                          color: context.colors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      ShrinkText(
                        _subtitle(context, l),
                        maxLines: 1,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // The button gives way before the name does when the text is
                // large: the frame round the picture already takes its share
                // of the row.
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 104),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _ActionButton(friend: friend),
                  ),
                ),
              ],
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

  // Drawn again when how they look arrives: their own lifter.
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Looks.instance,
    builder: (context, _) => TierFrame(
      tierIdx: friend.tierIdx,
      size: 44,
      child: _picture(context),
    ),
  );

  /// The circle and the online dot, which the frame goes around.
  Widget _picture(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Builder(
            builder: (context) {
              // Their face as everywhere else (face.dart).
              final face = faceOf(
                id: friend.id,
                name: friend.username,
                avatarUrl: friend.avatarUrl,
                small: true,
              );
              final fallback = LifterCircle(
                name: friend.username,
                size: 44,
                lifter: face.lifter,
              );
              final photo = face.photo;
              if (photo == null) return fallback;
              // As on the boards: the small copy, kept on the phone and
              // decoded at the circle's size. It was the whole photo, read
              // again on every launch and decoded at 800 px for 44 points.
              return ClipOval(
                child: PhotoOrLifter(
                  image: decodedAt(context, photo, 44),
                  size: 44,
                  lifter: fallback,
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
      // Live either way: "Invite" is the same live invite as "Challenge",
      // worded for somebody who is not around to answer at once — they get
      // a push and a minute to join.
      onTap: () => inviteFriendLive(
        context,
        id: friend.id,
        username: friend.username,
        tierIdx: friend.tierIdx,
        divIdx: friend.divIdx,
        avatarUrl: friend.avatarUrl,
      ),
      borderRadius: BorderRadius.circular(12),
      // One family of button (direction B): cream for Challenge, the quiet
      // filled one for Invite — no box drawn round a word.
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: online ? context.colors.brand : context.colors.surfaceRaised,
        ),
        child: Text(
          online ? l.challenge : l.invite,
          style: TextStyle(
            // On the filled button the label is the page's background colour,
            // which is the only thing dark enough to read on `brand`.
            color: online ? context.colors.background : context.colors.text,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
