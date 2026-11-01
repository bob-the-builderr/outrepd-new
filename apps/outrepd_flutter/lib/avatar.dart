/// What sits inside the frame: a photo, or the lifter. An account with no
/// photo wears the lifter it made (lib/lifter/my_lifter.dart), or until it
/// makes one, the one its name gives — never an initial (2026-11-01).
library;

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart';
import 'lifter/my_lifter.dart';

/// The player's picture: a file they chose, or their lifter.
class Avatar extends ChangeNotifier {
  /// Path to a photo copied into the app's own storage. Null falls back to
  /// the made lifter or the picture on the server, and then to the lifter the
  /// name gives.
  String? photoPath;

  bool get hasPhoto => photoPath != null && File(photoPath!).existsSync();

  /// This account's own picture, wherever it is drawn — the profile, the
  /// match card, the result, its own row on a board. The photo on this phone
  /// first, so a new one shows the moment it is picked; then the one on the
  /// server, so a phone that never had it (a new install, a second phone)
  /// still shows it. One getter, so no screen can draw an older one.
  ///
  /// The made lifter is drawn from this phone while it is the picture, and
  /// also while the server has no picture at all (its upload has not gone
  /// through yet), so it never falls back to the name's lifter.
  ImageProvider? get picture {
    if (hasPhoto) return FileImage(File(photoPath!));
    final mine = MyLifter.instance;
    final made = mine.built;
    final onServer = backend.me?.avatarUrl;
    if (made != null && (mine.isPicture || onServer == null || onServer.isEmpty)) {
      return LifterPicture(made);
    }
    return pictureAt(onServer);
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
    await MyLifter.instance.photoChosen();
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    await store.setString('avatarPhoto', path.split(RegExp(r'[\\/]')).last);
  }

  /// Back to the lifter on this phone: the photo and the note of it go. The server's copy is the caller's to take down first
  /// (Backend.removeAvatar), or [picture] would fall back to it.
  Future<void> clearPhoto() async {
    final path = photoPath;
    photoPath = null;
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    await store.remove('avatarPhoto');
    if (path == null) return;
    try {
      await File(path).delete();
    } on Object catch (error) {
      debugPrint('Could not delete the old photo: $error');
    }
  }

  /// The server's copy changed — uploaded from here, or read fresh — and a
  /// screen showing it from there should draw it again.
  void serverPictureChanged() => notifyListeners();
}

final avatar = Avatar();

/// Somebody's uploaded picture, or null for the lifter their name gives.
ImageProvider? pictureAt(String? url) =>
    url == null || url.isEmpty ? null : NetworkImage(url);
