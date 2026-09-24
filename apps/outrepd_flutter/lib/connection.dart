/// Whether the app can reach anything.
///
/// A match needs an opponent and an opponent needs a network, and every
/// screen that offers one has to be able to say so and offer the thing that
/// still works offline — the camera, counting your own reps.
///
/// Backed by the OS's own view of the network (Wi-Fi/mobile up or down), not
/// a ping to our server — a phone that reports a link but sits behind a
/// captive portal will still read as online. That is the tradeoff for
/// costing nothing on every screen that just wants to know "is there a
/// network at all," which is the question these screens actually ask.
library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class Connection extends ChangeNotifier {
  Connection._();

  static final instance = Connection._();

  bool _online = true;

  bool get online => _online;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Set from wherever the truth ends up living. Kept as a plain setter so a
  /// failed request can report what it learned without this file having to
  /// know how the request was made, and so tests can drive it directly
  /// without a real network to flip.
  void setOnline(bool value) {
    if (_online == value) return;
    _online = value;
    notifyListeners();
  }

  /// Starts watching the OS's own connectivity, once at app startup.
  ///
  /// A platform that cannot answer this (or a test harness with no
  /// connectivity plugin registered) leaves the app assuming it is online,
  /// same as before this watch existed — it must not turn "we could not ask"
  /// into "you are offline."
  Future<void> start() async {
    try {
      await refresh();
      await _subscription?.cancel();
      _subscription = Connectivity().onConnectivityChanged.listen(
        (results) => setOnline(_hasSignal(results)),
        onError: (Object error) =>
            debugPrint('Connectivity watch reported an error: $error'),
      );
    } on Object catch (error) {
      debugPrint('Could not start connectivity watch: $error');
    }
  }

  /// Asks the OS again right now. The change stream only fires on a change,
  /// so the retry button needs this rather than `setOnline(true)` — a link
  /// that never actually recovered must not be told it did.
  ///
  /// A platform that cannot even answer the question fails open: this must
  /// not turn "we could not ask" into "you are offline," so it assumes
  /// online rather than leaving the lifter stuck behind a network screen a
  /// real network problem never put there.
  Future<void> refresh() async {
    try {
      final results = await Connectivity().checkConnectivity();
      setOnline(_hasSignal(results));
    } on Object catch (error) {
      debugPrint('Could not check connectivity: $error');
      setOnline(true);
    }
  }

  bool _hasSignal(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
