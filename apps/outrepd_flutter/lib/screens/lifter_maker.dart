/// Where a player makes their lifter: the lifter big at the top, a row of
/// tabs (skin, hair, face, beard, top, gear, background), and under them
/// every choice drawn on the lifter itself.
///
/// Earned parts are shown locked, with what earns them. Pro parts are shown
/// too, with a PRO chip, and a free player can put one on to see it — the
/// lifter wears it here, a quiet line offers Pro, and Done keeps only what
/// the player has (the user's rule, 2026-11-01: Pro tempts from afar, never
/// a pop-up). Shown at sign-up after the name, with Skip, and from the
/// picture's sheet any time after.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n/app_localizations.dart';
import '../lifter/catalog.dart';
import '../lifter/lifter_art.dart';
import '../lifter/lifter_view.dart';
import '../lifter/my_lifter.dart';
import '../lifter/unlocks.dart';
import '../subscription.dart';
import '../theme.dart';
import '../type_scale.dart';
import 'paywall.dart';
import 'pro_parts.dart';

/// Opens the maker; true once a lifter was saved.
Future<bool> openLifterMaker(BuildContext context, {bool firstTime = false}) async {
  final saved = await Navigator.of(context).push<bool>(
    MaterialPageRoute(builder: (_) => LifterMakerScreen(firstTime: firstTime)),
  );
  return saved ?? false;
}

enum _Tab { skin, hair, face, beard, top, gear, background }

/// One choice of one part: which list it is from and how it is set.
class _Slot {
  const _Slot(this.parts, this.read, this.write, {this.view = LifterView.head});

  final List<LifterPart> parts;
  final int Function(Lifter) read;
  final Lifter Function(Lifter, int) write;
  final LifterView view;
}

final _skin = _Slot(kSkins, (l) => l.skin, (l, i) => l.copyWith(skin: i));
final _hair = _Slot(kHair, (l) => l.hair, (l, i) => l.copyWith(hair: i));
final _eyes = _Slot(kEyes, (l) => l.eyes, (l, i) => l.copyWith(eyes: i));
final _brows = _Slot(kBrows, (l) => l.brows, (l, i) => l.copyWith(brows: i));
final _mouth = _Slot(kMouths, (l) => l.mouth, (l, i) => l.copyWith(mouth: i));
final _marks = _Slot(kMarks, (l) => l.marks, (l, i) => l.copyWith(marks: i));
final _beard = _Slot(kBeards, (l) => l.beard, (l, i) => l.copyWith(beard: i));
final _top = _Slot(kTops, (l) => l.top, (l, i) => l.copyWith(top: i), view: LifterView.full);
final _gear = _Slot(kGear, (l) => l.gear, (l, i) => l.copyWith(gear: i), view: LifterView.full);
final _pattern = _Slot(
  kPatterns,
  (l) => l.pattern,
  (l, i) => l.copyWith(pattern: i),
  view: LifterView.backgroundOnly,
);

class LifterMakerScreen extends StatefulWidget {
  const LifterMakerScreen({super.key, this.firstTime = false});

  /// The sign-up step: Skip instead of the close button.
  final bool firstTime;

  @override
  State<LifterMakerScreen> createState() => _LifterMakerScreenState();
}

class _LifterMakerScreenState extends State<LifterMakerScreen> {
  /// What the lifter wears on screen, tried-on parts included.
  late Lifter _shown;

  /// The same, with only parts this account has: what Done saves.
  late Lifter _owned;

  UnlockState _unlocks = UnlockState(pro: Subscription.instance.active);
  _Tab _tab = _Tab.skin;

  /// The part last put on that this account does not have, for the line
  /// under the lifter.
  LifterPart? _trying;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _shown = _owned = MyLifter.instance.current(demoProfile.username);
    _readUnlocks();
  }

  Future<void> _readUnlocks() async {
    final unlocks = await UnlockState.read();
    if (!mounted) return;
    setState(() {
      _unlocks = unlocks;
      _owned = unlocks.keepOwned(_shown, _owned);
      if (_trying case final part? when unlocks.owns(part)) _trying = null;
    });
  }

  void _choose(_Slot slot, int i) {
    final part = slot.parts[i];
    setState(() {
      _shown = slot.write(_shown, i);
      if (_unlocks.owns(part)) {
        _owned = slot.write(_owned, i);
        _trying = null;
      } else {
        _trying = part;
      }
    });
  }

  void _colour(Lifter Function(Lifter) change) => setState(() {
    _shown = change(_shown);
    _owned = change(_owned);
  });

  void _dice() {
    final lifter = Lifter.random(math.Random().nextInt(1000000));
    setState(() {
      _shown = _owned = lifter;
      _trying = null;
    });
  }

  Future<void> _unlockPro() async {
    await openPro(context);
    if (mounted) await _readUnlocks();
  }

  Future<void> _done() async {
    if (_saving) return;
    setState(() => _saving = true);
    final keep = _unlocks.keepOwned(_shown, _owned);
    await MyLifter.instance.save(keep);
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _skip() async {
    await MyLifter.instance.skip();
    if (mounted) Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final preview = math.min(MediaQuery.sizeOf(context).width * 0.5, 220.0);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Row(
                children: [
                  if (widget.firstTime)
                    const SizedBox(width: 56)
                  else
                    IconButton(
                      key: const Key('makerClose'),
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                      icon: Icon(Icons.close, color: colors.muted),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  Expanded(
                    child: Text(
                      widget.firstTime ? l.lifterMakerFirst : l.lifterMakerTitle,
                      textAlign: TextAlign.center,
                      style: kType.heading.copyWith(color: colors.text, fontSize: 19),
                    ),
                  ),
                  if (widget.firstTime)
                    TextButton(
                      key: const Key('makerSkip'),
                      onPressed: _skip,
                      child: Text(l.skip, style: TextStyle(color: colors.muted, fontSize: 16)),
                    )
                  else
                    const SizedBox(width: 56),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: LifterImage(_shown, size: preview, key: const Key('makerPreview')),
                ),
                PositionedDirectional(
                  end: -14,
                  bottom: -10,
                  child: Material(
                    color: colors.surfaceRaised,
                    shape: CircleBorder(side: BorderSide(color: colors.border)),
                    child: IconButton(
                      key: const Key('makerDice'),
                      tooltip: l.lifterRandom,
                      icon: Icon(Icons.casino_outlined, color: colors.text),
                      onPressed: _dice,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 56, child: Center(child: _status(context, l))),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final tab in _Tab.values)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        key: Key('makerTab_${tab.name}'),
                        label: Text(_tabName(l, tab)),
                        selected: _tab == tab,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _tab = tab),
                        selectedColor: colors.brand,
                        backgroundColor: colors.surface,
                        side: BorderSide(color: _tab == tab ? colors.brand : colors.border),
                        labelStyle: TextStyle(
                          color: _tab == tab ? colors.background : colors.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _choices(context, l)),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  key: const Key('makerDone'),
                  onPressed: _saving ? null : _done,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.brand,
                    foregroundColor: colors.background,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    l.doneAction,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The line under the lifter: what earns a locked part, or for a Pro one
  /// the quiet way to keep it. At sign-up, before either, what this is for.
  Widget _status(BuildContext context, L l) {
    final colors = context.colors;
    final part = _trying;
    if (part == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          widget.firstTime ? l.lifterMakerFirstBody : '',
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.muted, fontSize: 14),
        ),
      );
    }
    if (part.pro) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ProChip(height: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l.lifterTryingPro,
              style: TextStyle(color: colors.muted, fontSize: 14),
            ),
          ),
          TextButton(
            key: const Key('makerUnlockPro'),
            onPressed: _unlockPro,
            child: Text(
              l.lifterUnlockPro,
              style: const TextStyle(color: Color(0xFFC9A8FF), fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.lock_outline, size: 18, color: colors.muted),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            unlockText(l, part.unlock!),
            key: const Key('makerNeeds'),
            style: TextStyle(color: colors.text, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _choices(BuildContext context, L l) {
    final List<(String?, _Slot)> sections = switch (_tab) {
      _Tab.skin => [(null, _skin)],
      _Tab.hair => [(null, _hair)],
      _Tab.face => [(l.lifterEyes, _eyes), (l.lifterBrows, _brows), (l.lifterMouth, _mouth), (l.lifterMarks, _marks)],
      _Tab.beard => [(null, _beard)],
      _Tab.top => [(null, _top)],
      _Tab.gear => [(null, _gear)],
      _Tab.background => [(null, _pattern)],
    };
    final swatches = switch (_tab) {
      _Tab.hair || _Tab.beard => _Swatches(
        colours: kHairColors,
        chosen: _shown.hairColor,
        onPick: (i) => _colour((l) => l.copyWith(hairColor: i)),
      ),
      _Tab.top => _Swatches(
        colours: kTopColors,
        chosen: _shown.topColor,
        onPick: (i) => _colour((l) => l.copyWith(topColor: i)),
      ),
      _Tab.background => _Swatches(
        colours: kBackgroundColors,
        chosen: _shown.background,
        onPick: (i) => _colour((l) => l.copyWith(background: i)),
      ),
      _ => null,
    };
    return CustomScrollView(
      key: PageStorageKey(_tab),
      slivers: [
        if (swatches != null) SliverToBoxAdapter(child: swatches),
        for (final (title, slot) in sections) ...[
          if (title != null)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
              sliver: SliverToBoxAdapter(
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            sliver: SliverGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                for (var i = 0; i < slot.parts.length; i++)
                  _PartTile(
                    key: Key('part_${slot.parts[i].id}'),
                    lifter: slot.write(_shown, i),
                    view: slot.view,
                    part: slot.parts[i],
                    chosen: slot.read(_shown) == i,
                    owned: _unlocks.owns(slot.parts[i]),
                    onTap: () => _choose(slot, i),
                  ),
              ],
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
      ],
    );
  }

  String _tabName(L l, _Tab tab) => switch (tab) {
    _Tab.skin => l.lifterTabSkin,
    _Tab.hair => l.lifterTabHair,
    _Tab.face => l.lifterTabFace,
    _Tab.beard => l.lifterTabBeard,
    _Tab.top => l.lifterTabTop,
    _Tab.gear => l.lifterTabGear,
    _Tab.background => l.lifterTabBackground,
  };
}

/// One choice, drawn on the lifter: chosen with a cream edge, a locked one
/// dimmed with a lock, a Pro one with its chip and not dimmed — it is there
/// to be tried on.
class _PartTile extends StatelessWidget {
  const _PartTile({
    super.key,
    required this.lifter,
    required this.view,
    required this.part,
    required this.chosen,
    required this.owned,
    required this.onTap,
  });

  final Lifter lifter;
  final LifterView view;
  final LifterPart part;
  final bool chosen;
  final bool owned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locked = !owned && !part.pro;
    return Semantics(
      button: true,
      selected: chosen,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: chosen ? colors.brand : colors.border,
                  width: chosen ? 2.5 : 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(chosen ? 2.5 : 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Opacity(
                    opacity: locked ? 0.4 : 1,
                    child: LifterImage(lifter, view: view),
                  ),
                ),
              ),
            ),
            if (part.pro)
              const PositionedDirectional(top: 4, end: 4, child: ProChip(height: 15)),
            if (locked)
              PositionedDirectional(
                top: 4,
                end: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: colors.background, shape: BoxShape.circle),
                  child: Icon(Icons.lock, size: 12, color: colors.text),
                ),
              ),
            if (part.rarity != Rarity.common)
              PositionedDirectional(
                start: 6,
                top: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _rarityColour(part.rarity),
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.background, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Color _rarityColour(Rarity rarity) => switch (rarity) {
  Rarity.common => Colors.transparent,
  Rarity.rare => const Color(0xFF4FA3FF),
  Rarity.epic => const Color(0xFFB26BFF),
  Rarity.legendary => const Color(0xFFF2C14E),
};

/// A row of colours to pick from.
class _Swatches extends StatelessWidget {
  const _Swatches({required this.colours, required this.chosen, required this.onPick});

  final List<String> colours;
  final int chosen;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: colours.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) => GestureDetector(
          key: Key('swatch_$i'),
          onTap: () => onPick(i),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(int.parse('FF${colours[i].substring(1)}', radix: 16)),
              shape: BoxShape.circle,
              border: Border.all(
                color: i == chosen ? colors.brand : colors.border,
                width: i == chosen ? 3 : 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
