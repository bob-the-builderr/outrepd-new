/// Asks for a rating in the App Store or Google Play, at a good moment.
///
/// A good moment is a win or a new level, once the lifter has played a few
/// matches and knows what they are rating. Never more than once in sixty
/// days from here, and never twice in one session; the system decides
/// whether to show it at all (Apple caps it at three a year). Straight to
/// the system's own prompt: no "do you like the app?" first — gating the
/// rating on a happy answer is against Apple's guideline 5.6.1.
///
/// Ratings are what an app with none is missing most: search ranks an app
/// with no ratings below the others whatever its keywords say.
library;

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class ReviewPrompt {
  static const _lastAskedKey = 'review.lastAsked';

  /// Matches played before the first ask: enough to know the app.
  static const minMatches = 3;

  /// The least time between two asks from here.
  static const gap = Duration(days: 60);

  static bool _askedThisSession = false;

  /// What asking does. A test puts something it can count here.
  @visibleForTesting
  static Future<bool> Function() ask = _askTheStore;

  @visibleForTesting
  static void resetSession() => _askedThisSession = false;

  static Future<bool> _askTheStore() async {
    final review = InAppReview.instance;
    if (!await review.isAvailable()) return false;
    await review.requestReview();
    return true;
  }

  /// Asks when it is a good moment and it has not asked lately. True when
  /// the store's prompt was requested.
  static Future<bool> maybeAsk({
    required bool goodMoment,
    required int matchesPlayed,
  }) async {
    if (!goodMoment || _askedThisSession || matchesPlayed < minMatches) {
      return false;
    }
    try {
      final store = await SharedPreferences.getInstance();
      final last = store.getInt(_lastAskedKey);
      final now = clock.now().millisecondsSinceEpoch;
      if (last != null && now - last < gap.inMilliseconds) return false;
      _askedThisSession = true;
      final asked = await ask();
      if (asked) await store.setInt(_lastAskedKey, now);
      return asked;
    } on Object catch (error) {
      // No store to ask on this platform, or it said no: nothing to do.
      debugPrint('No rating prompt: $error');
      return false;
    }
  }
}
