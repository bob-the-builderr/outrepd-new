/// The demo opponent's setup screen: name a rival, give them a face, say how
/// many reps they do and drag each one to the second it lands on.
///
/// Opened from the match screen only in a [kBotDemo] build. The strings here
/// are plain English on purpose: this is a tool for the person filming, not a
/// screen any lifter sees, and it is not worth thirteen translations of
/// "Drag a dot to move that rep" to say so.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../bot.dart';
import '../player_avatar.dart';
import '../theme.dart';
import '../type_scale.dart';
import 'match_entry.dart';

class BotSetupScreen extends StatefulWidget {
  const BotSetupScreen({super.key});

  @override
  State<BotSetupScreen> createState() => _BotSetupScreenState();
}

class _BotSetupScreenState extends State<BotSetupScreen> {
  final _name = TextEditingController();
  String? _photoPath;
  List<int> _times = const [];
  int? _selected;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(_onNameChanged);
    _load();
  }

  @override
  void dispose() {
    _name.removeListener(_onNameChanged);
    _name.dispose();
    super.dispose();
  }

  void _onNameChanged() => setState(() {});

  Future<void> _load() async {
    final bot = await loadBot();
    if (!mounted) return;
    setState(() {
      _name.text = bot.name;
      _photoPath = bot.photoPath;
      _times = List.of(bot.repTimesMs);
      _ready = true;
    });
  }

  /// Changing the count lays the reps out again across the minute, because a
  /// fresh, even shape is a better place to start dragging from than a set of
  /// times that no longer matches the number.
  void _setCount(int count) {
    final n = count.clamp(1, kBotMaxReps).toInt();
    setState(() {
      _times = spreadRepTimes(count: n);
      _selected = null;
    });
  }

  void _spread() {
    setState(() {
      _times = spreadRepTimes(count: _times.length);
      _selected = null;
    });
  }

  void _move(int index, int ms) {
    setState(() {
      final next = List<int>.of(_times);
      final landed = ms.clamp(0, kBotRoundMs).toInt();
      next[index] = landed;
      next.sort();
      _times = next;
      // Sorting may carry the dragged rep past its neighbours; follow it so
      // the next frame of the same drag keeps hold of the same dot.
      _selected = next.indexOf(landed);
    });
  }

  void _nudge(int deltaMs) {
    final at = _selected;
    if (at == null || at >= _times.length) return;
    setState(() {
      final next = List<int>.of(_times);
      final moved = (next[at] + deltaMs).clamp(0, kBotRoundMs).toInt();
      next[at] = moved;
      next.sort();
      _times = next;
      // Sorting may have carried the rep past its neighbours; find it again
      // so the next tap keeps working on the same one.
      _selected = next.indexOf(moved);
    });
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 88,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      final dir = await getApplicationDocumentsDirectory();
      final target = File(
        '${dir.path}/bot-${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await target.writeAsBytes(bytes);
      if (!mounted) return;
      setState(() => _photoPath = target.path);
    } on Object catch (error) {
      debugPrint('Could not use that picture: $error');
    }
  }

  void _choosePhoto() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from the gallery'),
              onTap: () {
                Navigator.of(sheet).pop();
                _pick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a picture'),
              onTap: () {
                Navigator.of(sheet).pop();
                _pick(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _start() async {
    final name = _name.text.trim();
    if (name.isEmpty || _times.isEmpty) return;
    final bot = BotOpponent(
      name: name,
      photoPath: _photoPath,
      repTimesMs: _times,
    );
    await saveBot(bot);
    if (!mounted) return;
    await startMatch(context, mode: MatchMode.bot, bot: bot);
  }

  @override
  Widget build(BuildContext context) {
    final canStart = _ready && _name.text.trim().isNotEmpty && _times.isNotEmpty;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        foregroundColor: context.colors.text,
        title: const Text('Demo opponent'),
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                Center(
                  child: GestureDetector(
                    key: const Key('botPhoto'),
                    onTap: _choosePhoto,
                    child: PlayerAvatar(
                      name: _name.text,
                      size: 104,
                      image: _photoPath != null
                          ? FileImage(File(_photoPath!))
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Tap the circle to set a face',
                    style: context.type.label.copyWith(
                      color: context.colors.muted,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _Label('Name'),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('botName'),
                  controller: _name,
                  autocorrect: false,
                  style: context.type.body.copyWith(color: context.colors.text),
                  cursorColor: context.colors.brand,
                  decoration: InputDecoration(
                    hintText: 'iron_mike',
                    hintStyle: context.type.body.copyWith(
                      color: context.colors.muted,
                    ),
                    filled: true,
                    fillColor: context.colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _Label('Push-ups in the minute')),
                    _StepperButton(
                      key: const Key('botRepsDown'),
                      icon: Icons.remove,
                      onTap: () => _setCount(_times.length - 1),
                    ),
                    SizedBox(
                      width: 56,
                      child: Text(
                        '${_times.length}',
                        key: const Key('botReps'),
                        textAlign: TextAlign.center,
                        style: context.type.heading.copyWith(
                          color: context.colors.text,
                        ),
                      ),
                    ),
                    _StepperButton(
                      key: const Key('botRepsUp'),
                      icon: Icons.add,
                      onTap: () => _setCount(_times.length + 1),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _Label('When each one lands')),
                    TextButton(
                      key: const Key('botSpread'),
                      onPressed: _spread,
                      child: const Text('Spread evenly'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _BotTimeline(
                  times: _times,
                  selected: _selected,
                  onSelect: (i) => setState(() => _selected = i),
                  onMove: _move,
                ),
                const SizedBox(height: 6),
                _readout(context),
                if (_selected != null) _nudgeBar(context),
                const SizedBox(height: 28),
                FilledButton(
                  key: const Key('botStart'),
                  onPressed: canStart ? _start : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: const Text('Start the match'),
                ),
                const SizedBox(height: 10),
                Text(
                  'A demo opponent only. Nothing here is on the ladder, and '
                  'only a build made with BOT_DEMO has this screen at all.',
                  textAlign: TextAlign.center,
                  style: context.type.micro.copyWith(
                    color: context.colors.faint,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _readout(BuildContext context) {
    final first = _times.isEmpty ? 0 : _times.first;
    final last = _times.isEmpty ? 0 : _times.last;
    return Center(
      child: Text(
        '${_times.length} reps · first ${(first / 1000).toStringAsFixed(1)}s · '
        'last ${(last / 1000).toStringAsFixed(1)}s · drag a dot to move it',
        textAlign: TextAlign.center,
        style: context.type.label.copyWith(color: context.colors.muted),
      ),
    );
  }

  Widget _nudgeBar(BuildContext context) {
    final at = _selected!;
    final ms = _times[at];
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NudgeButton(label: '−1s', onTap: () => _nudge(-1000)),
          _NudgeButton(label: '−0.1s', onTap: () => _nudge(-100)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'rep ${at + 1} · ${(ms / 1000).toStringAsFixed(1)}s',
              style: context.type.body.copyWith(color: context.colors.text),
            ),
          ),
          _NudgeButton(label: '+0.1s', onTap: () => _nudge(100)),
          _NudgeButton(label: '+1s', onTap: () => _nudge(1000)),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.type.label.copyWith(color: context.colors.muted),
  );
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surface,
    shape: CircleBorder(side: BorderSide(color: context.colors.border)),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Icon(icon, color: context.colors.text),
      ),
    ),
  );
}

class _NudgeButton extends StatelessWidget {
  const _NudgeButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(52, 40),
        padding: EdgeInsets.zero,
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    ),
  );
}

/// The minute, drawn a phone wide, with one draggable dot per rep.
///
/// The dots are the whole interface: where one sits is when that rep lands.
/// Dragging snaps to a tenth of a second, which is the finest a recording can
/// show and far coarser than the finger.
class _BotTimeline extends StatefulWidget {
  const _BotTimeline({
    required this.times,
    required this.selected,
    required this.onSelect,
    required this.onMove,
  });

  final List<int> times;
  final int? selected;
  final ValueChanged<int> onSelect;
  final void Function(int index, int ms) onMove;

  @override
  State<_BotTimeline> createState() => _BotTimelineState();
}

class _BotTimelineState extends State<_BotTimeline> {
  final _key = GlobalKey();

  /// Left and right gutters, so the first and last dots stay fully on screen
  /// and the track has somewhere to end.
  static const _gutter = 16.0;
  static const _dot = 26.0;

  int? _msAt(Offset global) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final usable = box.size.width - _gutter * 2;
    if (usable <= 0) return null;
    final local = box.globalToLocal(global);
    final share = ((local.dx - _gutter) / usable).clamp(0.0, 1.0);
    return ((share * kBotRoundMs) / 100).round() * 100;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final usable = box.maxWidth - _gutter * 2;
        double xFor(int ms) => _gutter + (ms / kBotRoundMs) * usable;

        return SizedBox(
          key: _key,
          height: 74,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: _gutter,
                right: _gutter,
                top: 30,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              for (final label in const [
                ('0s', 0),
                ('30s', 30000),
                ('60s', 60000),
              ])
                Positioned(
                  left: (xFor(label.$2) - 16)
                      .clamp(0.0, box.maxWidth - 32)
                      .toDouble(),
                  top: 54,
                  child: SizedBox(
                    width: 32,
                    child: Text(
                      label.$1,
                      textAlign: TextAlign.center,
                      style: context.type.micro.copyWith(
                        color: context.colors.faint,
                      ),
                    ),
                  ),
                ),
              for (final (i, ms) in widget.times.indexed)
                Positioned(
                  left: xFor(ms) - _dot / 2,
                  top: 8,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (_) => widget.onSelect(i),
                    onHorizontalDragStart: (_) => widget.onSelect(i),
                    onHorizontalDragUpdate: (d) {
                      // Not the index this dot had when the drag began: moving
                      // a rep re-sorts the list, so the dot under the finger
                      // can change place halfway through. The selection the
                      // parent hands back is the one that stays true.
                      final sel = widget.selected;
                      final moved = _msAt(d.globalPosition);
                      if (sel != null && moved != null) widget.onMove(sel, moved);
                    },
                    child: SizedBox(
                      width: _dot,
                      height: 46,
                      child: Column(
                        children: [
                          Container(
                            width: _dot,
                            height: _dot,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.selected == i
                                  ? context.colors.brand
                                  : context.colors.surface,
                              border: Border.all(
                                color: context.colors.brand,
                                width: 2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 2,
                              color: context.colors.brand.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
