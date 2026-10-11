/// Another one, straight after a live match: the button on the result screen.
///
/// Either phone asks; the other sees it on its own result screen and the
/// button there turns into the answer. When both have asked, the match
/// starts. The server holds the rules (supabase/live.sql, `rematch_live`):
/// only the two who just played, only straight after, and as ranked as the
/// match before — with the two-a-day rule still deciding whether it pays.
library;

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

/// How long a rematch waits for the other side; supabase/live.sql holds the
/// same thirty seconds.
const kRematchFor = Duration(seconds: 30);

enum _Ask { idle, sending, waiting, asked, gone }

class LiveRematchButton extends StatefulWidget {
  const LiveRematchButton({
    super.key,
    required this.after,
    required this.onStart,
    this.friendlyNext = false,
  });

  /// The match that just ended.
  final LiveMatch after;

  /// Both asked: the new match, ready to open.
  final ValueChanged<LiveMatch> onStart;

  /// The next one would be friendly whatever is pressed, so it says so first.
  final bool friendlyNext;

  @override
  State<LiveRematchButton> createState() => _LiveRematchButtonState();
}

class _LiveRematchButtonState extends State<LiveRematchButton> {
  _Ask _ask = _Ask.idle;

  /// Ours, once asked; theirs, once seen.
  String? _mine;
  LiveInvite? _theirs;
  bool? _ranked;
  DateTime? _deadline;
  Timer? _poll;
  bool _started = false;

  LiveOpponent get _them => widget.after.opponent;

  @override
  void initState() {
    super.initState();
    // Watching for theirs from the start: they may press first.
    _poll = Timer.periodic(const Duration(seconds: 1), (_) => _check());
  }

  @override
  void dispose() {
    _poll?.cancel();
    // Left before an answer: they should not join an empty room.
    if (_mine case final id? when !_started && _ask == _Ask.waiting) {
      unawaited(
        backend.cancelLiveInvite(id).catchError(
          (Object error) => debugPrint('Could not withdraw the rematch: $error'),
        ),
      );
    }
    super.dispose();
  }

  Future<void> _check() async {
    if (_started || !mounted) return;
    try {
      if (_ask == _Ask.waiting && _mine != null) {
        final state = await backend.liveState(_mine!);
        if (!mounted || _started) return;
        switch (state.status) {
          case LiveStatus.ready || LiveStatus.live:
            _start(_mine!, _ranked ?? false);
          case LiveStatus.declined ||
              LiveStatus.expired ||
              LiveStatus.cancelled:
            setState(() => _ask = _Ask.gone);
          case LiveStatus.invited || LiveStatus.done:
            setState(() {});
        }
        return;
      }
      if (_ask == _Ask.idle || _ask == _Ask.asked || _ask == _Ask.gone) {
        final invites = await backend.liveInvites();
        if (!mounted || _started) return;
        final theirs = invites.where((i) => i.from.id == _them.id).firstOrNull;
        if (theirs != null && _theirs?.matchId != theirs.matchId) {
          setState(() {
            _theirs = theirs;
            _ranked = theirs.ranked;
            _deadline = clock.now().add(theirs.expiresIn);
            _ask = _Ask.asked;
          });
        } else if (theirs == null && _ask == _Ask.asked) {
          setState(() {
            _theirs = null;
            _ask = _Ask.gone;
          });
        } else if (_ask == _Ask.asked) {
          setState(() {});
        }
      }
    } on Object catch (error) {
      debugPrint('Could not check the rematch: $error');
    }
  }

  /// Asking, or — when they asked first — answering. The server tells which.
  Future<void> _press() async {
    if (_ask == _Ask.sending || _ask == _Ask.waiting) return;
    setState(() => _ask = _Ask.sending);
    try {
      final answer = await backend.rematchLive(widget.after.id);
      if (!mounted) return;
      _ranked = answer.ranked;
      if (answer.status == LiveStatus.ready ||
          answer.status == LiveStatus.live) {
        _start(answer.matchId, answer.ranked);
        return;
      }
      setState(() {
        _mine = answer.matchId;
        _deadline = clock.now().add(kRematchFor);
        _ask = _Ask.waiting;
      });
    } on Object catch (error) {
      debugPrint('Could not ask for the rematch: $error');
      if (mounted) setState(() => _ask = _Ask.gone);
    }
  }

  Future<void> _cancel() async {
    final id = _mine;
    setState(() {
      _mine = null;
      _ask = _Ask.idle;
    });
    if (id == null) return;
    try {
      await backend.cancelLiveInvite(id);
    } on Object catch (error) {
      debugPrint('Could not withdraw the rematch: $error');
    }
  }

  void _start(String matchId, bool ranked) {
    if (_started) return;
    _started = true;
    _poll?.cancel();
    widget.onStart(LiveMatch(id: matchId, ranked: ranked, opponent: _them));
  }

  String _secondsLeft() {
    final left = (_deadline ?? clock.now()).difference(clock.now());
    final seconds = left.isNegative ? 0 : left.inSeconds;
    return '0:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final name = _them.username;
    // Friendly when the server says the next one will be, or when the match
    // just played already was by the same rule.
    final friendly =
        widget.friendlyNext ||
        (widget.after.ranked && _ranked == false);

    final (label, fill, ink, onTap) = switch (_ask) {
      _Ask.waiting => (
        '${l.rematchWaiting(name)} · ${_secondsLeft()}',
        context.colors.surfaceRaised,
        context.colors.text,
        null,
      ),
      _Ask.asked => (
        '${l.rematchAsked(name)} · ${l.accept}',
        context.colors.rival,
        context.colors.background,
        _press,
      ),
      _ => (
        l.rematchLive,
        context.colors.brand,
        context.colors.background,
        _ask == _Ask.sending ? null : _press,
      ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: fill,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            key: const Key('liveRematch'),
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_ask == _Ask.waiting)
          TextButton(onPressed: _cancel, child: Text(l.cancel))
        else if (_ask == _Ask.asked)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l.timeLeft(_secondsLeft()),
              style: TextStyle(color: context.colors.muted, fontSize: 12),
            ),
          )
        else if (_ask == _Ask.gone)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l.rematchGone,
              style: TextStyle(color: context.colors.muted, fontSize: 12),
            ),
          ),
        if (friendly)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l.twoRankedADay,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.muted, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
