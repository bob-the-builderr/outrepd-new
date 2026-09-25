/// The ways into a duel.
///
/// There used to be a muscle picker here: three disciplines, then a list of
/// eighty exercises to choose three from. All of it is gone. The app counts
/// push-ups, so there is nothing to disambiguate and nothing worth asking —
/// the fastest route from wanting a duel to being in one is no questions at
/// all.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../widgets.dart';
import 'match_flow.dart';

/// How a match was started. Ranked results move your LP; the social routes
/// are for bragging rights only.
enum MatchMode {
  ranked,

  /// No opponent, no rank, no LP. The camera still counts, so it is the one
  /// way to find out whether your form reads before a loss is riding on it.
  practice,

  /// Sending a rematch: record a set that names a specific lifter instead of
  /// joining the open pool. See [MatchFlowScreen.isChallenge].
  challenge,

  /// Racing a rematch that was sent to this account. See
  /// [MatchFlowScreen.isChallengeAccept].
  challengeAccept,
}

/// Straight into the duel.
Future<void> startMatch(
  BuildContext context, {
  required MatchMode mode,
  String? targetId,
  String? targetUsername,
  int? targetTierIdx,
  int? targetDivIdx,
}) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MatchFlowScreen(
        mode: mode,
        targetId: targetId,
        targetUsername: targetUsername,
        targetTierIdx: targetTierIdx,
        targetDivIdx: targetDivIdx,
      ),
    ),
  );
}

/// Find somebody by username and send them a real challenge — the same
/// reserved-set mechanism a rematch uses, reached here for anybody, friend
/// or not. There used to be a room code here instead, generated on the
/// phone and never checked against anything: two people "sharing" it could
/// never actually have been paired by it. A username the server can look up
/// is a code that already works.
Future<void> showFriendRoomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => const _FriendRoomSheet(),
  );
}

class _FriendRoomSheet extends StatefulWidget {
  const _FriendRoomSheet();

  @override
  State<_FriendRoomSheet> createState() => _FriendRoomSheetState();
}

class _FriendRoomSheetState extends State<_FriendRoomSheet> {
  final _search = TextEditingController();
  List<FoundLifter> _found = const [];
  bool _searching = false;

  /// Distinct from an empty [_found]: nobody matching that name is a real
  /// answer, but never having been able to ask the server is not — the two
  /// must not read the same way.
  bool _searchFailed = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    if (query.trim().length < 2) {
      setState(() {
        _found = const [];
        _searchFailed = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _lookUp(query));
  }

  Future<void> _lookUp(String query) async {
    if (!backend.available) {
      setState(() {
        _found = const [];
        _searchFailed = true;
      });
      return;
    }
    setState(() {
      _searching = true;
      _searchFailed = false;
    });
    try {
      final found = await backend.findLifters(query.trim());
      if (!mounted) return;
      setState(() {
        _found = found;
        _searching = false;
      });
    } on Object catch (error) {
      debugPrint('Could not search for lifters: $error');
      if (!mounted) return;
      setState(() {
        _searching = false;
        _searchFailed = true;
      });
    }
  }

  void _challenge(FoundLifter lifter) {
    Navigator.of(context).pop();
    startMatch(
      context,
      mode: MatchMode.challenge,
      targetId: lifter.id,
      targetUsername: lifter.username,
      targetTierIdx: lifter.tierIdx,
      targetDivIdx: lifter.divIdx,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetGrip(),
              Text(
                l.challengeFriend,
                style: context.type.heading.copyWith(color: context.colors.text),
              ),
              const SizedBox(height: 4),
              Text(
                l.roomFriendly,
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _search,
                autofocus: true,
                autocorrect: false,
                style: context.type.body.copyWith(color: context.colors.text),
                cursorColor: context.colors.brand,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: context.colors.muted),
                  hintText: l.searchByUsername,
                  hintStyle: context.type.body.copyWith(color: context.colors.muted),
                  filled: true,
                  fillColor: context.colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: context.colors.border),
                  ),
                ),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: _searching
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _found.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            _searchFailed
                                ? l.needsServer
                                : _search.text.trim().length < 2
                                ? l.roomFriendly
                                : l.noOneFound,
                            textAlign: TextAlign.center,
                            style: context.type.label.copyWith(
                              color: context.colors.muted,
                            ),
                          ),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          for (final lifter in _found)
                            _FoundLifterRow(
                              lifter: lifter,
                              onChallenge: () => _challenge(lifter),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoundLifterRow extends StatelessWidget {
  const _FoundLifterRow({required this.lifter, required this.onChallenge});

  final FoundLifter lifter;
  final VoidCallback onChallenge;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final rank = lifter.placementsDone >= kPlacementDuels
        ? tierLabel(l, lifter.tierIdx, lifter.divIdx)
        : l.unranked;

    return InkWell(
      onTap: onChallenge,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: context.colors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lifter.username,
                    style: context.type.body.copyWith(color: context.colors.text),
                  ),
                  Text(
                    rank,
                    style: context.type.micro.copyWith(color: context.colors.muted),
                  ),
                ],
              ),
            ),
            Icon(Icons.sports_mma, color: context.colors.brand, size: 18),
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
    return Center(
      child: Container(
        width: 38,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.colors.surfaceRaised,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
