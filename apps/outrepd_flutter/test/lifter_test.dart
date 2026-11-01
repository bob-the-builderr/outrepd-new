// The lifter: every part draws, a saved one reads back the same, the one a
// name gives is the same everywhere, and the unlock rules hold.

import 'package:flutter_test/flutter_test.dart';
import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/lifter/catalog.dart';
import 'package:outrepd/lifter/lifter_art.dart';
import 'package:outrepd/lifter/lifter_view.dart';
import 'package:outrepd/lifter/unlocks.dart';

/// Every lifter that differs from the plain one in a single part.
Iterable<Lifter> _eachPart() sync* {
  const base = Lifter();
  for (var i = 0; i < kSkins.length; i++) {
    yield base.copyWith(skin: i);
  }
  for (var i = 0; i < kHair.length; i++) {
    yield base.copyWith(hair: i);
  }
  for (var i = 0; i < kEyes.length; i++) {
    yield base.copyWith(eyes: i);
  }
  for (var i = 0; i < kBrows.length; i++) {
    yield base.copyWith(brows: i);
  }
  for (var i = 0; i < kMouths.length; i++) {
    yield base.copyWith(mouth: i);
  }
  for (var i = 0; i < kBeards.length; i++) {
    yield base.copyWith(beard: i);
  }
  for (var i = 0; i < kMarks.length; i++) {
    yield base.copyWith(marks: i);
  }
  for (var i = 0; i < kTops.length; i++) {
    yield base.copyWith(top: i);
  }
  for (var i = 0; i < kGear.length; i++) {
    yield base.copyWith(gear: i);
  }
  for (var i = 0; i < kPatterns.length; i++) {
    yield base.copyWith(pattern: i);
  }
}

void main() {
  group('the drawing', () {
    test('every part draws, in every view', () {
      for (final lifter in _eachPart()) {
        for (final view in LifterView.values) {
          final svg = lifterSvg(lifter, view: view);
          expect(svg, startsWith('<svg '));
          expect(svg, endsWith('</svg>'));
          expect(svg, isNot(contains('NaN')));
        }
      }
    });

    test('no id is used twice in one lifter', () {
      // A clip or gradient named twice draws the wrong shape.
      for (var seed = 0; seed < 300; seed++) {
        final svg = lifterSvg(Lifter.random(seed));
        final ids = RegExp(r' id="([^"]+)"').allMatches(svg).map((m) => m[1]).toList();
        expect(ids.toSet().length, ids.length, reason: 'seed $seed');
      }
      for (final lifter in _eachPart()) {
        final svg = lifterSvg(lifter);
        final ids = RegExp(r' id="([^"]+)"').allMatches(svg).map((m) => m[1]).toList();
        expect(ids.toSet().length, ids.length);
      }
    });

    test('a face mask hides the mouth and beard; a hat hides the hair', () {
      final masked = const Lifter(beard: 6).copyWith(
        gear: kGear.indexWhere((p) => p.id == 'face_mask'),
      );
      expect(lifterSvg(masked), isNot(contains('M92 130 L96 150')));
      final capped = const Lifter(hair: 2).copyWith(
        gear: kGear.indexWhere((p) => p.id == 'cap'),
      );
      expect(lifterSvg(capped).contains('chf'), isFalse);
    });
  });

  group('saving', () {
    test('a lifter reads back the same', () {
      for (var seed = 0; seed < 50; seed++) {
        final lifter = Lifter.random(seed).copyWith(skin: seed % kSkins.length);
        expect(Lifter.fromJson(lifter.toJson()), lifter);
      }
    });

    test('parts this build does not know fall back to the first', () {
      final read = Lifter.fromJson({'skin': 'plasma', 'hair': 'mullet', 'topColor': '#123456'});
      expect(read.skin, 0);
      expect(read.hair, 0);
      expect(read.topColor, 0);
    });
  });

  group('the lifter a name gives', () {
    test('is the same for the same name, whatever its case', () {
      expect(lifterFor('Mokhtar_'), lifterFor('mokhtar_'));
      expect(lifterFor('iron_mike'), isNot(lifterFor('squat_queen')));
    });

    test('wears free parts only', () {
      for (var seed = 0; seed < 500; seed++) {
        for (final part in Lifter.random(seed).parts) {
          expect(part.pro, isFalse, reason: part.id);
          expect(part.earned, isFalse, reason: part.id);
        }
      }
    });
  });

  group('unlocks', () {
    LifterPart part(List<LifterPart> list, String id) => list.firstWhere((p) => p.id == id);

    test('free parts are always worn, Pro parts only with Pro', () {
      const free = UnlockState();
      expect(free.owns(part(kSkins, 'tan')), isTrue);
      expect(free.owns(part(kSkins, 'neon')), isFalse);
      expect(const UnlockState(pro: true).owns(part(kSkins, 'neon')), isTrue);
      // Pro never unlocks an earned part.
      expect(const UnlockState(pro: true).owns(part(kSkins, 'stone')), isFalse);
    });

    test('earned parts follow what the account has done', () {
      expect(const UnlockState(worldsCleared: {1}).owns(part(kSkins, 'stone')), isTrue);
      expect(const UnlockState(worldsCleared: {1}).owns(part(kSkins, 'bronze')), isFalse);
      expect(const UnlockState(peakTier: 3).owns(part(kGear, 'gold_chain')), isTrue);
      expect(const UnlockState(peakTier: 2).owns(part(kGear, 'gold_chain')), isFalse);
      expect(const UnlockState(wins: 10).owns(part(kMouths, 'gold_tooth')), isTrue);
      expect(const UnlockState(bestDayStreak: 6).owns(part(kEyes, 'fire')), isFalse);
      expect(const UnlockState(level: 50).owns(part(kGear, 'halo')), isTrue);
    });

    test('a month award counts for the lesser ones too', () {
      const champion = UnlockState(awards: {SeasonAwardKind.champion});
      expect(champion.owns(part(kTops, 'champion_robe')), isTrue);
      expect(champion.owns(part(kGear, 'medal')), isTrue);
      expect(champion.owns(part(kSkins, 'shadow')), isTrue);
      const regular = UnlockState(awards: {SeasonAwardKind.regular});
      expect(regular.owns(part(kSkins, 'shadow')), isFalse);
    });

    test('what is saved keeps only what the account has', () {
      const was = Lifter(skin: 2, top: 3);
      final tried = was.copyWith(
        skin: kSkins.indexWhere((p) => p.id == 'neon'),
        top: kTops.indexWhere((p) => p.id == 'satin_bomber'),
        hair: 7,
      );
      final kept = const UnlockState().keepOwned(tried, was);
      expect(kept.skin, 2);
      expect(kept.top, 3);
      expect(kept.hair, 7);
      expect(const UnlockState(pro: true).keepOwned(tried, was), tried);
    });
  });
}
