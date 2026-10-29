/// Experience, and the level it adds up to.
///
/// One XP for every rep of every set — practice and Adventure too — and twenty
/// more for every match won; a match lost pays nothing, its reps included.
/// The server keeps the total (profiles.xp: the
/// sets trigger in schema.sql, xp_for_duel in live.sql); this file only reads
/// a level off it. A level never comes down, because experience never does.
library;

/// What a match won pays on top of its reps.
const kXpPerMatch = 20;

/// What it takes to go from [level] to the next: 100 for the first, and 50
/// more for each one after — the early levels come in a session or two, the
/// later ones are worth showing.
int xpToLevelUp(int level) => 100 + 50 * (level - 1);

/// Where a total of experience stands: the level, and how far into it.
class XpLevel {
  const XpLevel({required this.level, required this.into, required this.span});

  /// From 1.
  final int level;

  /// Experience earned since this level was reached.
  final int into;

  /// What this level takes in all, [xpToLevelUp] of it.
  final int span;

  int get toNext => span - into;
  double get progress => span == 0 ? 0 : into / span;
}

XpLevel xpLevel(int xp) {
  var level = 1;
  var left = xp < 0 ? 0 : xp;
  while (left >= xpToLevelUp(level)) {
    left -= xpToLevelUp(level);
    level++;
  }
  return XpLevel(level: level, into: left, span: xpToLevelUp(level));
}

int levelOf(int xp) => xpLevel(xp).level;

/// What one session paid: the reps, and the match if it was one.
class XpGain {
  const XpGain({required this.before, required this.after, required this.reps});

  final int before;
  final int after;

  /// The reps this session counted. Whatever else it paid was the match.
  final int reps;

  int get total => after - before;
  int get forMatch => total - reps < 0 ? 0 : total - reps;
  bool get leveledUp => levelOf(after) > levelOf(before);
}
