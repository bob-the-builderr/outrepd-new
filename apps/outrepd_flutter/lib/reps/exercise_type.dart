/// What movement a set, a round or a duel was. There is exactly one.
///
/// A single-member enum looks like a pointless indirection, and today it is.
/// It is here because the alternative — no type at all — is what makes an app
/// impossible to widen later: the movement stops being recorded, every stored
/// set silently means "whatever the app counted at the time", and the day a
/// second movement arrives none of the history can be read.
///
/// So the type is written down, stored and passed around. It just only ever
/// has one value, and nothing in the UI ever asks anybody to pick it.
library;

enum ExerciseType {
  pushUp;

  /// The name that goes into stored data. Fixed on purpose: renaming the enum
  /// must not silently rewrite what past sessions claim to be.
  String get wireName => 'pushUp';

  static ExerciseType fromWireName(String name) => ExerciseType.pushUp;
}
