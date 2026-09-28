import 'package:flutter/material.dart';

import '../app_bottom_nav.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../theme.dart';
import 'friends.dart';
import 'match.dart';
import 'paywall.dart';
import 'profile.dart';
import 'ranks.dart';

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
    _countFriendRequests();
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
      child: Scaffold(
        backgroundColor: context.colors.background,
        // One listener for all four tabs. Every screen under here reads the
        // account, so a duel that changes it has to redraw them — otherwise
        // the profile still shows last week's LP until something else
        // happens to rebuild it.
        body: ListenableBuilder(
          listenable: Career.instance,
          builder: (context, _) =>
              IndexedStack(index: _index, children: _tabs),
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _index,
          onTap: _select,
          friendRequestCount: friendRequestCount,
        ),
      ),
    );
  }
}
