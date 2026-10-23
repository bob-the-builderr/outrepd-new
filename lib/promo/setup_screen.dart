/// Before the take: who is on each side, and how the opponent's count moves.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/app_localizations.dart';
import '../player_avatar.dart';
import '../settings.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../widgets.dart';
import 'match_screen.dart';
import 'plan.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key, required this.plan});

  final PromoPlan plan;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  PromoPlan get plan => widget.plan;

  late final _myName = TextEditingController(text: plan.myName);
  late final _oppName = TextEditingController(text: plan.oppName);
  late final _finalCount = TextEditingController(text: '${plan.finalCount}');
  late final _seconds = TextEditingController(text: plan.customSeconds);

  @override
  void dispose() {
    _myName.dispose();
    _oppName.dispose();
    _finalCount.dispose();
    _seconds.dispose();
    super.dispose();
  }

  void _change(VoidCallback change) {
    setState(change);
    plan.save();
  }

  /// A picture from the library, copied into the app's own folder so it is
  /// still there next time.
  Future<void> _pickPhoto({required bool mine}) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 92,
    );
    if (picked == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final name =
        '${mine ? 'me' : 'opponent'}-${DateTime.now().millisecondsSinceEpoch}.jpg';
    final copy = await File(picked.path).copy('${dir.path}/$name');
    _change(() {
      if (mine) {
        plan.myPhoto = copy.path;
      } else {
        plan.oppPhoto = copy.path;
      }
    });
  }

  void _start() {
    FocusScope.of(context).unfocus();
    _change(() {
      plan.myName = _myName.text.trim().isEmpty ? 'You' : _myName.text.trim();
      plan.oppName =
          _oppName.text.trim().isEmpty ? 'rival' : _oppName.text.trim();
      plan.finalCount =
          (int.tryParse(_finalCount.text.trim()) ?? plan.finalCount).clamp(1, 120);
      plan.customSeconds = _seconds.text;
    });
    if (plan.mode == OpponentMode.custom && plan.repTimesMs().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Type at least one second, like 2, 4.5, 7'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    playPromoMatch(context, plan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Text(
              'OUTREPD Promo',
              style: TextStyle(
                color: context.colors.text,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Set the match up, then film it. Nothing here reaches the real app.',
              style: TextStyle(color: context.colors.muted, fontSize: 15),
            ),
            const SizedBox(height: 20),
            _PlayerCard(
              title: 'You',
              name: _myName,
              photo: plan.myPhoto,
              tierIdx: plan.myTier,
              divIdx: plan.myDiv,
              onPhoto: () => _pickPhoto(mine: true),
              onClearPhoto: () => _change(() => plan.myPhoto = null),
              onTier: (t) => _change(() => plan.myTier = t),
              onDiv: (d) => _change(() => plan.myDiv = d),
              lp: plan.myLp,
              onLp: (v) => _change(() => plan.myLp = v),
              level: plan.myLevel,
              onLevel: (v) => _change(() => plan.myLevel = v),
              levelUp: plan.levelUp,
              onLevelUp: (on) => _change(() => plan.levelUp = on),
            ),
            const SizedBox(height: 14),
            _PlayerCard(
              title: 'Opponent',
              name: _oppName,
              photo: plan.oppPhoto,
              tierIdx: plan.oppTier,
              divIdx: plan.oppDiv,
              onPhoto: () => _pickPhoto(mine: false),
              onClearPhoto: () => _change(() => plan.oppPhoto = null),
              onTier: (t) => _change(() => plan.oppTier = t),
              onDiv: (d) => _change(() => plan.oppDiv = d),
              level: plan.oppLevel,
              onLevel: (v) => _change(() => plan.oppLevel = v),
            ),
            const SizedBox(height: 14),
            _Box(
              title: "The opponent's count",
              children: [
                SegmentedButton<OpponentMode>(
                  segments: const [
                    ButtonSegment(
                      value: OpponentMode.behind,
                      label: Text('Behind me'),
                    ),
                    ButtonSegment(
                      value: OpponentMode.finalCount,
                      label: Text('Ends on'),
                    ),
                    ButtonSegment(
                      value: OpponentMode.custom,
                      label: Text('Each rep'),
                    ),
                  ],
                  selected: {plan.mode},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) => _change(() => plan.mode = s.first),
                ),
                const SizedBox(height: 14),
                ...switch (plan.mode) {
                  OpponentMode.behind => [
                    _Stepper(
                      label: 'Always this many behind you',
                      value: plan.behindBy,
                      min: 1,
                      max: 10,
                      onChanged: (v) => _change(() => plan.behindBy = v),
                    ),
                    _Hint(
                      'They follow your count, a moment after each of your '
                      'reps, and you win by ${plan.behindBy}.',
                    ),
                  ],
                  OpponentMode.finalCount => [
                    _NumberField(
                      controller: _finalCount,
                      label: 'Reps they end the minute on',
                    ),
                    const _Hint(
                      'Paced like a real set: quicker at the start, slower as '
                      'the minute wears on.',
                    ),
                  ],
                  OpponentMode.custom => [
                    TextField(
                      controller: _seconds,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      maxLines: 4,
                      minLines: 2,
                      style: TextStyle(color: context.colors.text),
                      onChanged: (_) => setState(() {}),
                      decoration: _field(
                        context,
                        'The second each rep lands on, like 2, 4.5, 7, 9',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final n in [10, 15, 20, 25, 30])
                          ActionChip(
                            label: Text('Fill $n reps'),
                            onPressed: () => setState(() {
                              _seconds.text = PromoPlan.paced(n)
                                  .map((ms) => (ms / 1000).toStringAsFixed(1))
                                  .join(', ');
                            }),
                          ),
                      ],
                    ),
                    _Hint(_customSummary()),
                  ],
                },
              ],
            ),
            const SizedBox(height: 14),
            _Box(
              title: 'Before the round',
              children: [
                _Stepper(
                  label: 'Seconds to get down',
                  value: plan.countdownSeconds,
                  min: 3,
                  max: 30,
                  onChanged: (v) => _change(() => plan.countdownSeconds = v),
                ),
                const _Hint(
                  'The app gives ten. More leaves time to set the phone '
                  'down and walk back into shot.',
                ),
                const SizedBox(height: 6),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Skeleton over the camera',
                    style: TextStyle(color: context.colors.text, fontSize: 16),
                  ),
                  value: settings.showSkeleton,
                  onChanged: (on) =>
                      setState(() => settings.update(() => settings.showSkeleton = on)),
                ),
                SwitchListTile(
                  key: const Key('camera4kSwitch'),
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Camera in 4K',
                    style: TextStyle(color: context.colors.text, fontSize: 16),
                  ),
                  value: plan.camera4k,
                  onChanged: (on) => _change(() => plan.camera4k = on),
                ),
                const _Hint(
                  'A sharper body in the film. The counter works harder at '
                  '4K: check the bar still keeps up with you.',
                ),
                SwitchListTile(
                  key: const Key('recordSwitch'),
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Film the take into Photos',
                    style: TextStyle(color: context.colors.text, fontSize: 16),
                  ),
                  value: plan.record,
                  onChanged: (on) => _change(() => plan.record = on),
                ),
                const _Hint(
                  "At the screen's full resolution, with the app's sound and "
                  'no status bar, from the countdown to the result. iOS asks '
                  'to allow it the first time.',
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Sounds',
                    style: TextStyle(color: context.colors.text, fontSize: 16),
                  ),
                  value: settings.sounds,
                  onChanged: (on) =>
                      setState(() => settings.update(() => settings.sounds = on)),
                ),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 56,
              child: FilledButton(
                key: const Key('startPromo'),
                onPressed: _start,
                child: const Text(
                  'Start the match',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _customSummary() {
    final times = PromoPlan.parseSeconds(_seconds.text);
    if (times.isEmpty) return 'No reps yet.';
    final last = (times.last / 1000).toStringAsFixed(1);
    return '${times.length} reps, the last at ${last}s.';
  }
}

InputDecoration _field(BuildContext context, String label) => InputDecoration(
  labelText: label,
  labelStyle: TextStyle(color: context.colors.muted),
  filled: true,
  fillColor: context.colors.surfaceRaised,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  ),
);

class _Box extends StatelessWidget {
  const _Box({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  // A Material rather than a coloured box: the switches inside draw their
  // ink on the nearest one.
  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(color: context.colors.surfaceRaised),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    ),
  );
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.title,
    required this.name,
    required this.photo,
    required this.tierIdx,
    required this.divIdx,
    required this.onPhoto,
    required this.onClearPhoto,
    required this.onTier,
    required this.onDiv,
    required this.level,
    required this.onLevel,
    this.lp,
    this.onLp,
    this.levelUp,
    this.onLevelUp,
  });

  final String title;
  final TextEditingController name;
  final String? photo;
  final int tierIdx;
  final int divIdx;
  final VoidCallback onPhoto;
  final VoidCallback onClearPhoto;
  final ValueChanged<int> onTier;
  final ValueChanged<int> onDiv;
  final int? lp;
  final ValueChanged<int>? onLp;
  final int level;
  final ValueChanged<int> onLevel;

  /// Yours only: whether the take ends on the level-up screen.
  final bool? levelUp;
  final ValueChanged<bool>? onLevelUp;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final photo = this.photo;
    return _Box(
      title: title,
      children: [
        Row(
          children: [
            // The initial follows the name as it is typed.
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: name,
              builder: (context, typed, _) => PlayerAvatar(
                name: typed.text.isEmpty ? '?' : typed.text,
                tierIdx: tierIdx,
                image: photo == null ? null : FileImage(File(photo)),
                size: 64,
                onTap: onPhoto,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: name,
                    style: TextStyle(color: context.colors.text),
                    decoration: _field(context, 'Name'),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    children: [
                      TextButton.icon(
                        onPressed: onPhoto,
                        icon: const Icon(Icons.photo_library_outlined, size: 18),
                        label: Text(photo == null ? 'Pick a photo' : 'Change photo'),
                      ),
                      if (photo != null)
                        TextButton(
                          onPressed: onClearPhoto,
                          child: const Text('Remove'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Every tier as its badge, the chosen one lit.
        SizedBox(
          height: 58,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var t = 0; t < kTiers.length; t++)
                GestureDetector(
                  onTap: () => onTier(t),
                  child: Container(
                    width: 64,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: t == tierIdx
                          ? context.colors.surfaceRaised
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: t == tierIdx
                            ? context.colors.brand
                            : context.colors.surfaceRaised,
                      ),
                    ),
                    child: Center(child: TierBadge(tierIndex: t, size: 40)),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SegmentedButton<int>(
          segments: [
            for (var d = 0; d < kDivisions.length; d++)
              ButtonSegment(value: d, label: Text(kDivisions[d])),
          ],
          selected: {divIdx},
          showSelectedIcon: false,
          onSelectionChanged: (s) => onDiv(s.first),
        ),
        const SizedBox(height: 8),
        Text(
          tierLabel(l, tierIdx, divIdx),
          style: TextStyle(color: context.colors.muted, fontSize: 14),
        ),
        if (lp case final lp?) ...[
          const SizedBox(height: 6),
          _Stepper(
            label: 'LP before the match',
            value: lp,
            min: 0,
            max: 99,
            step: 5,
            onChanged: onLp!,
          ),
        ],
        const SizedBox(height: 6),
        _Stepper(
          label: 'Level',
          value: level,
          min: 1,
          max: 99,
          onChanged: onLevel,
        ),
        if (levelUp case final up?)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Level up at the end',
              style: TextStyle(color: context.colors.text, fontSize: 16),
            ),
            value: up,
            onChanged: onLevelUp,
          ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(color: context.colors.text, fontSize: 16),
        ),
      ),
      IconButton(
        onPressed: value > min
            ? () => onChanged((value - step).clamp(min, max))
            : null,
        icon: const Icon(Icons.remove_circle_outline),
      ),
      SizedBox(
        width: 36,
        child: Text(
          '$value',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.colors.text,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      IconButton(
        onPressed: value < max
            ? () => onChanged((value + step).clamp(min, max))
            : null,
        icon: const Icon(Icons.add_circle_outline),
      ),
    ],
  );
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    style: TextStyle(color: context.colors.text, fontSize: 18),
    decoration: _field(context, label),
  );
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      text,
      style: TextStyle(color: context.colors.muted, fontSize: 14),
    ),
  );
}
