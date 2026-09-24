/// What sits inside the frame: a photo from the phone, or the drawn initial
/// every screen already falls back to. No third option — [PlayerAvatar]'s own
/// rule is a circle with the person's initial, never clip-art standing in for
/// them, so there is nothing here to render one.
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The player's picture. Either a file they chose, or nothing — the initial
/// carries it from there.
class Avatar extends ChangeNotifier {
  /// Path to a photo copied into the app's own storage. Null falls back to
  /// the drawn initial.
  String? photoPath;

  bool get hasPhoto => photoPath != null && File(photoPath!).existsSync();

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    photoPath = store.getString('avatarPhoto');

    // A path that no longer resolves — the file was cleared, or the app was
    // reinstalled — must fall back rather than leave a broken picture.
    if (photoPath != null && !File(photoPath!).existsSync()) photoPath = null;
  }

  Future<void> usePhoto(String path) async {
    photoPath = path;
    final store = await SharedPreferences.getInstance();
    await store.setString('avatarPhoto', path);
    notifyListeners();
  }
}

final avatar = Avatar();
