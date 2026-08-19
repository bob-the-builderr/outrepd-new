import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'friends.dart';
import 'leaderboard.dart';
import 'match.dart';
import 'profile.dart';
import 'crew.dart';

/// Bottom-tab container holding the five main sections.
///
/// Match sits in the middle and is the only tab with a filled icon, so it
/// reads as the app's primary action. Everything stays on one plane inside a
/// floating bar — nothing overhangs, so page content is never obscured.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = matchTabIndex});

  /// Position of the Match tab, which doubles as the default landing tab.
  static const int matchTabIndex = 2;

  /// Which tab to open on. Lets callers deep-link straight to a section.
  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _index = widget.initialIndex;

  static const _tabs = <Widget>[
    FriendsScreen(),
    LeaderboardScreen(),
    MatchScreen(),
    CrewScreen(),
    ProfileScreen(),
  ];

  /// Rebuilt per frame rather than held const: the labels follow the chosen
  /// language, which can change while the shell is on screen.
  static List<_TabSpec> _specsFor(L l) => [
        _TabSpec(l.tabFriends, Icons.people_outline, Icons.people),
        _TabSpec(l.tabRanks, Icons.emoji_events_outlined, Icons.emoji_events),
        _TabSpec(l.tabMatch, Icons.sports_mma, Icons.sports_mma),
        _TabSpec(l.tabCrew, Icons.groups_2_outlined, Icons.groups_2),
        _TabSpec(l.tabProfile, Icons.person_outline, Icons.person),
      ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final specs = _specsFor(L.of(context));

    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 10 + bottomInset),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: context.colors.surfaceRaised),
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              for (var i = 0; i < specs.length; i++)
                Expanded(
                  child: _Tab(
                    spec: specs[i],
                    selected: _index == i,
                    primary: i == AppShell.matchTabIndex,
                    onTap: () => setState(() => _index = i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.icon, this.selectedIcon);
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.spec,
    required this.selected,
    required this.primary,
    required this.onTap,
  });

  final _TabSpec spec;
  final bool selected;

  /// The Match tab — drawn as a filled disc so it stands out from the rest.
  final bool primary;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? context.colors.brand : context.colors.muted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (primary)
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.brand,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: context.colors.brand.withValues(alpha: 0.4),
                          blurRadius: 14,
                        ),
                      ]
                    : null,
              ),
              child: Icon(Icons.sports_mma, color: Colors.white, size: 22),
            )
          else
            Icon(selected ? spec.selectedIcon : spec.icon, color: color, size: 23),
          const SizedBox(height: 4),
          // Five fixed-width tabs have to hold a word in fourteen languages.
          // Shrinking a long one a point or two reads better than cutting it
          // off mid-word, which is what an ellipsis does to "プロフィール".
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                spec.label,
                maxLines: 1,
                style: TextStyle(
                  color: primary ? context.colors.brand : color,
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
