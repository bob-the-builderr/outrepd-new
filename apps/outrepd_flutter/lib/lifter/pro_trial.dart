/// A Pro part worn for a day after a rewarded video (the user's pick,
/// 2026-11-09, C): which part, what it took the place of, and until when.
///
/// The server keeps the same record (rewarded.sql, start_pro_trial) and
/// takes the part off for everybody else once the day is over (pro_looks).
/// This one is the phone's: [UnlockState.owns] lets the part be worn while
/// the day lasts, and [endIfOver] puts back what it replaced once it has.
library;

import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/backend.dart';
import '../subscription.dart';
import 'catalog.dart';
import 'my_lifter.dart';

class ProTrial extends ChangeNotifier {
  ProTrial._();

  static final instance = ProTrial._();

  static const _prefsKey = 'proTrial';

  /// The lifter's own key for the part (Lifter.toJson: 'hair', 'gear' …).
  String? _key;
  String? _id;

  /// What [_key] held before, put back when the day is over; null for a key
  /// that was not there (no ready-made character).
  String? _was;
  DateTime? _until;

  /// When the day ends, or null with no part on trial.
  DateTime? get until => _until;

  /// Whether [part] is the one worn for a day, and the day is not over.
  bool covers(LifterPart part) {
    final until = _until;
    return part.pro &&
        part.id == _id &&
        until != null &&
        clock.now().isBefore(until);
  }

  Future<void> load() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(
        _prefsKey,
      );
      if (saved == null) return;
      final json = jsonDecode(saved) as Map<String, dynamic>;
      _key = json['key'] as String?;
      _id = json['id'] as String?;
      _was = json['was'] as String?;
      _until = DateTime.tryParse(json['until'] as String? ?? '');
    } on Object catch (error) {
      debugPrint('Could not read the Pro part on trial: $error');
    }
  }

  /// Starts the day for [part], the lifter's [key], in place of [was]: on
  /// the account first, so everybody sees it, then here. False when the
  /// account could not be reached; the part is not worn then.
  Future<bool> start({
    required String key,
    required LifterPart part,
    String? was,
  }) async {
    DateTime until;
    if (backend.available && backend.me != null) {
      try {
        until = (await backend.startProTrial(key, part.id, was)).toLocal();
      } on Object catch (error) {
        debugPrint('Could not start the day with a Pro part: $error');
        return false;
      }
    } else {
      until = clock.now().add(const Duration(days: 1));
    }
    _key = key;
    _id = part.id;
    _was = was;
    _until = until;
    notifyListeners();
    try {
      await (await SharedPreferences.getInstance()).setString(
        _prefsKey,
        jsonEncode({
          'key': key,
          'id': part.id,
          'was': was,
          'until': until.toIso8601String(),
        }),
      );
    } on Object catch (error) {
      debugPrint('Could not keep the Pro part on trial: $error');
    }
    return true;
  }

  /// [lifter] with the day's part taken off, once the day is over and the
  /// account has not gone Pro since.
  Lifter takeOff(Lifter lifter) {
    final key = _key;
    final until = _until;
    if (key == null || until == null || clock.now().isBefore(until)) {
      return lifter;
    }
    if (Subscription.instance.active) return lifter;
    final json = <String, dynamic>{...lifter.toJson()};
    if (json[key] != _id) return lifter;
    if (_was case final was?) {
      json[key] = was;
    } else {
      json.remove(key);
    }
    return Lifter.fromJson(json);
  }

  /// Past its day, the part comes off this account's lifter. Not while the
  /// store has yet to say whether the account is Pro: a subscriber keeps it.
  Future<void> endIfOver() async {
    final subscription = Subscription.instance;
    if (subscription.enabled && !subscription.known) return;
    final built = MyLifter.instance.built;
    if (built == null) return;
    final off = takeOff(built);
    if (off == built) return;
    await MyLifter.instance.replaceParts(off);
  }
}
