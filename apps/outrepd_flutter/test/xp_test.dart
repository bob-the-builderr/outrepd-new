/// The level read off experience: what each one costs, and what a session
/// is said to have paid.
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/xp.dart';

void main() {
  test('each level costs fifty more than the one before', () {
    expect(xpToLevelUp(1), 100);
    expect(xpToLevelUp(2), 150);
    expect(xpToLevelUp(12), 650);
  });

  test('a level is reached exactly at its total, not a rep before', () {
    expect(xpLevel(0).level, 1);
    expect(xpLevel(99).level, 1);
    expect(xpLevel(100).level, 2);
    expect(xpLevel(249).level, 2);
    expect(xpLevel(250).level, 3);
  });

  test('how far into a level, and what is left of it', () {
    // Level 12 starts at 3,850: 100 + 150 + … + 600.
    final at = xpLevel(4240);
    expect(at.level, 12);
    expect(at.into, 390);
    expect(at.span, 650);
    expect(at.toNext, 260);
    expect(at.progress, closeTo(0.6, 0.001));
  });

  test('nothing below zero', () {
    expect(xpLevel(-40).level, 1);
    expect(xpLevel(-40).into, 0);
  });

  test('a match pays its reps and twenty', () {
    const gain = XpGain(before: 90, after: 133, reps: 23);
    expect(gain.total, 43);
    expect(gain.forMatch, kXpPerMatch);
    expect(gain.leveledUp, isTrue);
  });

  test('practice pays its reps and nothing for a match', () {
    const gain = XpGain(before: 10, after: 33, reps: 23);
    expect(gain.forMatch, 0);
    expect(gain.leveledUp, isFalse);
  });
}
