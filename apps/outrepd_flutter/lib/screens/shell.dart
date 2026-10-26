import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../app_bottom_nav.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../deep_links.dart';
import '../motion.dart';
import '../push.dart';
import '../theme.dart';
import 'friends.dart';
import 'live_invite.dart';
import 'match.dart';
import 'notifications.dart';
import 'paywall.dart';
import 'profile.dart';
import 'ranks.dart';
import 'season_over.dart';

/// Which of the four tabs is on screen, null with none. Every tab stays
/// mounted under the others, so a tab cannot tell from its own state whether
/// anybody is looking at it; the ones that read the server ask for
/// themselves again when they are opened (ranks.dart, friends.dart,
/// profile.dart).
final shownTab = ValueNotifier<int?>(null);

/// Bottom-tab container holding the four sections.
///
/// The bar itself lives in `app_bottom_nav.dart`; this only owns which tab is
/// showing.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = matchTabIndex});

  /// Match is first and is where the app opens. Everything else on these four
  /// screens is a record of duels; this is the one that starts one.
  static const int matchTabIndex = 0;

  final int initialIndex;

  /// Switch to the Match tab from inside another one.
  ///
  /// Pushing a MatchScreen instead would leave the bottom bar showing Ranks
  /// while the match screen sits on top of it, and the back gesture would take
  /// people somewhere they never were.
  static void goToMatch(BuildContext context) =>
      context.findAncestorStateOfType<_AppShellState>()?._select(matchTabIndex);

  static const int friendsTabIndex = 1;
  static const int ranksTabIndex = 2;
  static const int profileTabIndex = 3;

  /// Switch to the Ranks tab, which opens on this week's board.
  static void goToRanks(BuildContext context) =>
      context.findAncestorStateOfType<_AppShellState>()?._select(ranksTabIndex);

  /// Switch to the Friends tab with the waiting requests open — a friend
  /// request tapped in the notifications.
  static void goToFriendRequests(BuildContext context) {
    context.findAncestorStateOfType<_AppShellState>()?._select(friendsTabIndex);
    FriendsScreen.showRequests();
  }

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _tabs = <Widget>[
    MatchScreen(),
    FriendsScreen(),
    RanksScreen(),
    ProfileScreen(),
  ];

  /// Clamped: `main.dart` still has routes from when there were five tabs, and
  /// an out-of-range index would throw on the IndexedStack rather than land
  /// somewhere sensible.
  late int _index = widget.initialIndex.clamp(0, _tabs.length - 1);

  /// How many friend requests are waiting. Asked for here rather than read
  /// off the Friends tab, because that tab stays mounted in the IndexedStack
  /// and never tells the bar when an answer changes the count.
  int _friendRequests = 0;

  @override
  void initState() {
    super.initState();
    shownTab.value = _index;
    _countFriendRequests();
  }

  @override
  void dispose() {
    shownTab.value = null;
    super.dispose();
  }

  Future<void> _countFriendRequests() async {
    if (!backend.available) return;
    try {
      final requests = await backend.friendRequests();
      if (mounted) setState(() => _friendRequests = requests.length);
    } on Object catch (error) {
      // No badge rather than a wrong one.
      debugPrint('Could not count friend requests: $error');
    }
  }

  void _select(int index) {
    setState(() => _index = index);
    shownTab.value = index;
    // Leaving the Friends tab is when a request most likely just got
    // answered, so the badge is only as stale as one tab switch.
    _countFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    // Offline, the Friends tab itself never shows a fake pending request —
    // there is no server to have sent one — so the badge above it must agree.
    final friendRequestCount = backend.available ? _friendRequests : 0;

    // Every way into the app lands here — the end of onboarding, a returning
    // launch, a login — so this is where the subscription is asked for.
    return PaywallGate(
      child: _Inside(
        child: Scaffold(
          backgroundColor: context.colors.background,
          // One listener for all four tabs. Every screen under here reads the
          // account, so a duel that changes it has to redraw them — otherwise
          // the profile still shows last week's LP until something else
          // happens to rebuild it.
          body: ListenableBuilder(
            listenable: Career.instance,
            builder: (context, _) => _TabStack(index: _index, children: _tabs),
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: _index,
            onTap: _select,
            friendRequestCount: friendRequestCount,
          ),
        ),
      ),
    );
  }
}

/// The four tabs, every one kept alive as an IndexedStack keeps them, with
/// the one being opened fading and rising in over a moment instead of
/// cutting to it.
class _TabStack extends StatefulWidget {
  const _TabStack({required this.index, required this.children});

  final int index;
  final List<Widget> children;

  @override
  State<_TabStack> createState() => _TabStackState();
}

class _TabStackState extends State<_TabStack>
    with SingleTickerProviderStateMixin {
  late final _arrive = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
    value: 1,
  );
  late final _eased = CurvedAnimation(parent: _arrive, curve: Curves.easeOutCubic);

  @override
  void didUpdateWidget(_TabStack old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index && !reduceMotion(context)) {
      _arrive.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _eased.dispose();
    _arrive.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _eased,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.015),
          end: Offset.zero,
        ).animate(_eased),
        child: IndexedStack(index: widget.index, children: widget.children),
      ),
    );
  }
}

/// What happens once somebody is past the paywall: the phone is asked, once,
/// whether the app may show notifications; it is registered for the
/// account's pushes; and a tapped push opens the notices.
///
/// Inside the gate on purpose. Built only when the gate lets the app through,
/// so a push can never open a screen the subscription has not.
class _Inside extends StatefulWidget {
  const _Inside({required this.child});

  final Widget child;

  @override
  State<_Inside> createState() => _InsideState();
}

class _InsideState extends State<_Inside> with WidgetsBindingObserver {
  /// Friends' live invites waiting on this account, as last read.
  List<LiveInvite> _invites = const [];
  DateTime _invitesReadAt = clock.now();
  final _dismissed = <String>{};
  Timer? _invitePoll;

  /// Links to `outrepd.com/u/<name>`, opened as that lifter's card.
  StreamSubscription<Uri>? _links;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _links = listenForLinks(() => context);
    Push.instance.openNotices.addListener(_openNotices);
    Push.instance.arrived.addListener(_checkInvites);
    // A push is often somebody racing this lifter's set while they were
    // away: the result goes into the history as it arrives.
    Push.instance.arrived.addListener(_syncHistory);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await askForNotificationsOnce();
      // After the answer, so a phone that just said yes is registered with
      // the permission it now has.
      await Push.instance.start();
      // Last, so the month's result is not stacked on top of the question
      // about notifications.
      if (mounted) await tellSeasonAwards(context);
    });
    // An invite lasts a minute, so every few seconds is the least that
    // shows one in time to answer it.
    if (backend.available) {
      _checkInvites();
      _invitePoll = Timer.periodic(
        const Duration(seconds: 5),
        (_) => _checkInvites(),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Push.instance.openNotices.removeListener(_openNotices);
    Push.instance.arrived.removeListener(_checkInvites);
    Push.instance.arrived.removeListener(_syncHistory);
    _invitePoll?.cancel();
    _links?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkInvites();
      _syncHistory();
    }
  }

  void _syncHistory() => unawaited(Career.instance.syncHistory());

  Future<void> _checkInvites() async {
    if (!backend.available || backend.me == null) return;
    try {
      final invites = await backend.liveInvites();
      if (!mounted) return;
      setState(() {
        _invites = invites;
        _invitesReadAt = clock.now();
      });
    } on Object catch (error) {
      debugPrint('Could not read live invites: $error');
    }
  }

  LiveInvite? get _shownInvite {
    for (final invite in _invites) {
      if (_dismissed.contains(invite.matchId)) continue;
      final left =
          invite.expiresIn - clock.now().difference(_invitesReadAt);
      if (left > Duration.zero) return invite;
    }
    return null;
  }

  Future<void> _join(LiveInvite invite) async {
    setState(() => _dismissed.add(invite.matchId));
    await joinLiveInvite(context, invite);
  }

  bool _showingNotices = false;

  Future<void> _openNotices() async {
    if (!mounted || _showingNotices) return;
    _showingNotices = true;
    await openNotifications(context);
    _showingNotices = false;
  }

  @override
  Widget build(BuildContext context) {
    final invite = _shownInvite;
    // Always the same Stack, banner or not: swapping the tree's shape when an
    // invite lands would rebuild every tab underneath it from scratch.
    return Stack(
      children: [
        widget.child,
        if (invite != null)
          Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
              child: Dismissible(
                key: ValueKey('invite-${invite.matchId}'),
                direction: DismissDirection.up,
                onDismissed: (_) =>
                    setState(() => _dismissed.add(invite.matchId)),
                child: LiveInviteBanner(
                  invite: invite,
                  readAt: _invitesReadAt,
                  onJoin: () => _join(invite),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
