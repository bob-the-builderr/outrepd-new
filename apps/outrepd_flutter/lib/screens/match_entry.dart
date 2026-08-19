import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';
import 'match.dart';
import 'match_flow.dart';

/// How a match was started. Ranked results move your LP; the social routes
/// are for bragging rights only.
enum MatchMode { ranked, room, crew }

/// Asks which muscle group the match is for, then starts it.
Future<void> pickMuscle(BuildContext context, {required MatchMode mode}) async {
  final muscle = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => const _MusclePicker(),
  );

  if (muscle == null || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => MatchFlowScreen(muscle: muscle)),
  );
}

class _MusclePicker extends StatelessWidget {
  const _MusclePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetGrip(),
            Text(
              "Today's muscle",
              style: TextStyle(
                color: context.colors.text,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              L.of(context).matchedSameGroup,
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            for (final g in muscleGroups)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Panel(
                  onTap: () => Navigator.of(context).pop(g),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Row(
                    children: [
                      Icon(muscleIcons[g], color: context.colors.brand, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          g,
                          style: TextStyle(
                            color: context.colors.text,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          color: context.colors.muted, size: 20),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Create or join a private room to face a friend.
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
  final _codeController = TextEditingController();
  String? _createdCode;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String _newCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random();
    return List.generate(6, (_) => chars[r.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
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
                L.of(context).challengeFriend,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                L.of(context).roomFriendly,
                style: TextStyle(color: context.colors.muted, fontSize: 13),
              ),
              const SizedBox(height: 18),
              if (_createdCode == null) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () =>
                        setState(() => _createdCode = _newCode()),
                    icon: const Icon(Icons.add),
                    label: Text(L.of(context).createRoom),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(color: context.colors.surfaceRaised)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or',
                          style:
                              TextStyle(color: context.colors.muted, fontSize: 12)),
                    ),
                    Expanded(child: Divider(color: context.colors.surfaceRaised)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 6,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: L.of(context).enterCode,
                    hintStyle: TextStyle(
                      color: context.colors.muted,
                      letterSpacing: 3,
                      fontSize: 15,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _codeController.text.trim().length == 6
                        ? () {
                            Navigator.of(context).pop();
                            pickMuscle(context, mode: MatchMode.room);
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(L.of(context).joinRoom),
                  ),
                ),
              ] else
                _RoomCreated(
                  code: _createdCode!,
                  onStart: () {
                    Navigator.of(context).pop();
                    pickMuscle(context, mode: MatchMode.room);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomCreated extends StatelessWidget {
  const _RoomCreated({required this.code, required this.onStart});

  final String code;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          L.of(context).shareThisCode,
          style: TextStyle(color: context.colors.muted, fontSize: 13),
        ),
        const SizedBox(height: 10),
        Panel(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                code,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.copy, color: context.colors.brand, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(L.of(context).codeCopied)),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: onStart,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(L.of(context).pickMuscleAndStart),
        ),
      ],
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
