/// What sits inside the frame: a photo from the phone, or one of the avatars
/// the app hands out.
///
/// Built-in avatars are drawn rather than shipped as images — an icon on a
/// colour, from the same sets the crew emblems use. That keeps the download
/// small and means adding one costs a line rather than an asset.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The avatars offered when someone would rather not use a photo. Chosen to
/// suit a lifting app rather than being generic faces.
const kAvatarIcons = <IconData>[
  Icons.fitness_center,
  Icons.sports_mma,
  Icons.local_fire_department,
  Icons.bolt,
  Icons.shield,
  Icons.military_tech,
  Icons.pets,
  Icons.rocket_launch,
  Icons.psychology,
  Icons.self_improvement,
  Icons.sports_martial_arts,
  Icons.whatshot,
  Icons.anchor,
  Icons.diamond,
  Icons.emoji_events,
  Icons.terrain,
];

const kAvatarColors = <Color>[
  Color(0xFF4BB8FA),
  Color(0xFF2E7DFF),
  Color(0xFF22C55E),
  Color(0xFFFFD700),
  Color(0xFFFF8C00),
  Color(0xFFFF4444),
  Color(0xFFFF5FA2),
  Color(0xFF9B59B6),
  Color(0xFF00E5FF),
  Color(0xFF6A0DAD),
  Color(0xFF8B5A2B),
  Color(0xFF2F4858),
];

/// The player's picture. Either a file they chose or a built-in pairing.
class Avatar extends ChangeNotifier {
  /// Path to a photo copied into the app's own storage. Null when a built-in
  /// avatar is in use.
  String? photoPath;

  int iconIdx = 0;
  int colorIdx = 0;

  bool get hasPhoto => photoPath != null && File(photoPath!).existsSync();

  IconData get icon => kAvatarIcons[iconIdx % kAvatarIcons.length];
  Color get colour => kAvatarColors[colorIdx % kAvatarColors.length];

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    photoPath = store.getString('avatarPhoto');
    iconIdx = store.getInt('avatarIcon') ?? 0;
    colorIdx = store.getInt('avatarColor') ?? 0;

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

  Future<void> useBuiltIn(int icon, int colour) async {
    photoPath = null;
    iconIdx = icon;
    colorIdx = colour;

    final store = await SharedPreferences.getInstance();
    await store.remove('avatarPhoto');
    await store.setInt('avatarIcon', icon);
    await store.setInt('avatarColor', colour);
    notifyListeners();
  }
}

final avatar = Avatar();
