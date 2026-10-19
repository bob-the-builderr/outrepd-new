/// What sits inside the frame: a photo, or the drawn initial every screen
/// already falls back to. No third option — [PlayerAvatar]'s own rule is a
/// circle with the person's initial, never clip-art standing in for them, so
/// there is nothing here to render one.
library;

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart';

/// The player's picture. Either a file they chose, or nothing — the initial
/// carries it from there.
class Avatar extends ChangeNotifier {
  /// Path to a photo copied into the app's own storage. Null falls back to
  /// the photo on the server, and then to the drawn initial.
  String? photoPath;

  bool get hasPhoto => photoPath != null && File(photoPath!).existsSync();

  /// This account's own picture, wherever it is drawn — the profile, the
  /// match card, the result, its own row on a board. The photo on this phone
  /// first, so a new one shows the moment it is picked; then the one on the
  /// server, so a phone that never had it (a new install, a second phone)
  /// still shows it. One getter, so no screen can draw an older one.
  ImageProvider? get picture {
    if (hasPhoto) return FileImage(File(photoPath!));
    return pictureAt(backend.me?.avatarUrl);
  }

  /// Only the file's name is kept. iOS moves the app's folder on every
  /// update, so a whole path saved before an update points nowhere after it —
  /// which is how a photo used to vanish from the profile after each build.
  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    final saved = store.getString('avatarPhoto');
    photoPath = null;
    if (saved == null || saved.isEmpty) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      // Saved before only the name was kept: the name is the last part.
      final name = saved.split(RegExp(r'[\\/]')).last;
      final path = '${dir.path}/$name';
      if (File(path).existsSync()) photoPath = path;
    } on Object catch (error) {
      debugPrint('Could not find the saved photo: $error');
    }
  }

  Future<void> usePhoto(String path) async {
    photoPath = path;
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    await store.setString('avatarPhoto', path.split(RegExp(r'[\\/]')).last);
  }

  /// The server's copy changed — uploaded from here, or read fresh — and a
  /// screen showing it from there should draw it again.
  void serverPictureChanged() => notifyListeners();
}

final avatar = Avatar();

/// Somebody's uploaded picture, or null for the drawn initial.
ImageProvider? pictureAt(String? url) =>
    url == null || url.isEmpty ? null : NetworkImage(url);
