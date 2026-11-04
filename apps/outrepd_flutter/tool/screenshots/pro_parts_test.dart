/// The Pro parts the user picked (2026-11-04), drawn by the app itself — the
/// glows as soft strokes, since its SVG renderer draws no filters — to set
/// beside the mockups they were picked from. And the free afro, redrawn.
/// See shots.dart for how these are run and published.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/lifter/catalog.dart';
import 'package:outrepd/lifter/lifter_art.dart' show LifterView;
import 'package:outrepd/lifter/lifter_view.dart';

int _at(List<LifterPart> list, String id) => list.indexWhere((p) => p.id == id);

void main() {
  testWidgets('the Pro parts, drawn by the app', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 1100 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    const base = Lifter(skin: 5, hair: 2, beard: 0, mouth: 0, eyes: 0, background: 3);
    final faces = <Lifter>[
      for (final id in ['inferno', 'galaxy_afro', 'bolt_fade', 'neon_dreads', 'afro'])
        base.copyWith(hair: _at(kHair, id)),
      base.copyWith(hair: _at(kHair, 'afro'), hairColor: 2, skin: 1),
      base.copyWith(hair: _at(kHair, 'afro'), hairColor: 4, skin: 8),
      for (final id in ['flame_beard', 'gold_braids', 'frost_beard', 'galaxy_beard'])
        base.copyWith(beard: _at(kBeards, id), mouth: 2),
      for (final id in ['bubble_gum', 'fangs', 'fire_breath', 'shark_grin'])
        base.copyWith(mouth: _at(kMouths, id)),
      for (final id in ['lightning_bolt', 'face_gems', 'gold_flakes'])
        base.copyWith(marks: _at(kMarks, id)),
      for (final id in ['hypno', 'diamond_eyes', 'snake_eyes', 'electric', 'gold_eyes'])
        base.copyWith(eyes: _at(kEyes, id)),
      // The Pro hair colours, on the crew cut and on the afro.
      for (final hex in kProHairColors.keys) base.copyWith(hairColor: kHairColors.indexOf(hex)),
      for (final hex in kProHairColors.keys) base.copyWith(hair: _at(kHair, 'afro'), hairColor: kHairColors.indexOf(hex)),
    ];

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF121110),
          body: Padding(
            padding: const EdgeInsets.all(6),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final l in faces) LifterImage(l, size: 96, view: LifterView.head),
              ],
            ),
          ),
        ),
      ),
    );
    // The pictures are SVG, drawn a frame or two after they are asked for.
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/pro_parts_1.png'),
    );
  });

  testWidgets('the Pro clothes, gear and backgrounds, drawn by the app', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 900 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    const base = Lifter(skin: 5, hair: 2, beard: 0, mouth: 0, eyes: 0, background: 3);
    final bodies = <Lifter>[
      for (final id in ['hero_cape', 'chrome_armor', 'galaxy_hoodie', 'flame_jersey'])
        base.copyWith(top: _at(kTops, id)),
      for (final id in ['shutter_shades', 'flame_headband', 'pet_dragon', 'neon_wings', 'bat_wings'])
        base.copyWith(gear: _at(kGear, id)),
      for (final id in ['synthwave', 'sakura', 'deep_sea', 'confetti'])
        base.copyWith(pattern: _at(kPatterns, id)),
    ];

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF121110),
          body: Padding(
            padding: const EdgeInsets.all(6),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final l in bodies) LifterImage(l, size: 128)],
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/pro_parts_2.png'),
    );
  });

  testWidgets('the creature skins and the characters, drawn by the app', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 900 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    const base = Lifter(skin: 5, hair: 0, beard: 0, mouth: 0, eyes: 0, background: 3);
    final all = <(Lifter, LifterView)>[
      for (final id in ['robot', 'zombie', 'alien', 'skeleton', 'werewolf', 'reptile'])
        (base.copyWith(skin: _at(kSkins, id)), LifterView.head),
      // A creature wears what it is given: the werewolf, a cap and a hoodie.
      (base.copyWith(skin: _at(kSkins, 'werewolf'), gear: _at(kGear, 'cap'), top: _at(kTops, 'hoodie')), LifterView.full),
      for (final id in ['samurai', 'viking', 'ninja', 'astronaut', 'masked_wrestler', 'pharaoh'])
        (base.copyWith(character: _at(kCharacters, id)), LifterView.full),
      // Worn as it is: a cap under a character does not show.
      (base.copyWith(character: _at(kCharacters, 'samurai'), gear: _at(kGear, 'cap'), pattern: _at(kPatterns, 'sakura')), LifterView.full),
    ];

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF121110),
          body: Padding(
            padding: const EdgeInsets.all(6),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final (l, view) in all) LifterImage(l, size: 128, view: view)],
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/pro_parts_3.png'),
    );
  });
}
