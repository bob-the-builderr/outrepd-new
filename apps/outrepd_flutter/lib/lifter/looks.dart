/// How other people look on this phone's screens: whether they are Pro,
/// the lifter they made, and their cover (account.sql, pro_looks). Asked
/// once for the ids a screen shows, kept for a few minutes, and shared by
/// every screen — a board, the VS screen, a profile.
///
/// This account's own look never comes from here: it is this phone's
/// (MyLifter, MyCover, Subscription), so a change shows at once.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/backend.dart';
import '../subscription.dart';
import 'catalog.dart';
import 'my_lifter.dart';

class Looks extends ChangeNotifier {
  Looks._();
  static final instance = Looks._();

  final Map<String, ProLook> _known = {};
  final Map<String, DateTime> _asked = {};

  /// Asks for whichever of [ids] were not asked in the last five minutes.
  /// Quiet on failure: a board without its holo rows is still a board.
  Future<void> fetch(Iterable<String> ids) async {
    if (!backend.available) return;
    final now = DateTime.now();
    final me = backend.me?.id;
    final wanted = {
      for (final id in ids)
        if (id.isNotEmpty &&
            id != me &&
            now.difference(_asked[id] ?? DateTime(2000)) > const Duration(minutes: 5))
          id,
    }.toList();
    if (wanted.isEmpty) return;
    for (final id in wanted) {
      _asked[id] = now;
    }
    try {
      _known.addAll(await backend.proLooks(wanted));
      notifyListeners();
    } on Object catch (error) {
      debugPrint('Could not read how people look: $error');
      for (final id in wanted) {
        _asked.remove(id);
      }
    }
  }

  bool _isMe(String id) => id.isNotEmpty && id == backend.me?.id;

  /// Whether [id] is Pro.
  bool pro(String id) =>
      _isMe(id) ? Subscription.instance.active : _known[id]?.pro ?? false;

  /// The lifter [id] wears as their picture, or null when they have not made
  /// one (or it is not known yet), or chose a photo over it: then their photo
  /// is what shows, as it does on their own phone.
  Lifter? lifter(String id) {
    if (_isMe(id)) {
      final mine = MyLifter.instance;
      return mine.isPicture ? mine.built : null;
    }
    final json = _known[id]?.lifter;
    return json == null || json[kLifterWorn] == false
        ? null
        : Lifter.fromJson(json);
  }

  /// [id]'s cover: a scene's id or a photo's URL, only ever for a Pro.
  String? cover(String id) {
    if (_isMe(id)) {
      return Subscription.instance.active ? MyCover.instance.cover : null;
    }
    return _known[id]?.cover;
  }
}

/// This account's own cover: kept on the phone so it shows at once, and on
/// the account so it shows to others. Only drawn while the account is Pro.
class MyCover extends ChangeNotifier {
  MyCover._();
  static final instance = MyCover._();

  static const _key = 'cover';
  String? _cover;

  /// A scene's id, a photo's URL, or null for none.
  String? get cover => _cover;

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    _cover = store.getString(_key);
  }

  /// Takes the account's cover from the server when this phone has none.
  Future<void> adopt() async {
    final me = backend.me?.id;
    if (_cover != null || me == null || !backend.available) return;
    try {
      final look = (await backend.proLooks([me]))[me];
      if (look?.cover case final cover?) await _keep(cover);
    } on Object catch (error) {
      debugPrint('Could not read the cover: $error');
    }
  }

  Future<void> _keep(String? cover) async {
    _cover = cover;
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    if (cover == null) {
      await store.remove(_key);
    } else {
      await store.setString(_key, cover);
    }
  }

  /// A scene by id, or null for none: here at once, then on the account.
  Future<void> choose(String? cover) async {
    await _keep(cover);
    if (!backend.available) return;
    try {
      await backend.saveCover(cover);
    } on Object catch (error) {
      debugPrint('Could not save the cover: $error');
    }
  }

  /// [bytes], already cropped, as the cover. Throws when the upload fails,
  /// so the picker can say so; the cover stays what it was.
  Future<void> usePhoto(Uint8List bytes) async {
    final url = await backend.uploadCover(bytes);
    await _keep(url);
  }

  /// Signed out: the next account in does not wear this one.
  Future<void> forget() => _keep(null);
}
