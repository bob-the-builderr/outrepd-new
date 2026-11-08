/// This account's own lifter: the one it made, kept on the phone and on the
/// account, and drawn as its picture wherever it has not chosen a photo.
///
/// Every account wears a lifter, never an initial (the user's rule,
/// 2026-11-01). One that has not made its own wears the one its name gives
/// ([lifterFor]), the same on every phone. One that has is drawn from here on
/// this phone, and everybody else sees the PNG of it uploaded as its photo,
/// so boards, older builds and the website need nothing new to show it.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../avatar.dart';
import '../backend/backend.dart';
import 'catalog.dart';
import 'lifter_view.dart';

/// In the parts the account keeps: false when a photo was chosen over the
/// lifter. The parts stay for the lifter to be worn again, and a phone that
/// took them for the picture drew the lifter over the photo for everybody
/// else (Looks.lifter). A key the parts never had, so nothing else minds it.
const kLifterWorn = 'worn';

class MyLifter extends ChangeNotifier {
  MyLifter._();
  static final instance = MyLifter._();

  static const _key = 'lifter';
  static const _pictureKey = 'lifterIsPicture';
  static const _askedKey = 'lifterAsked';
  static const _ownerKey = 'lifterOwner';

  Lifter? _built;
  bool _isPicture = false;
  bool _asked = false;

  /// The account the kept lifter was made on or taken from, or null for one
  /// kept before this was recorded.
  String? _owner;

  /// The lifter this account made, or null before it has made one.
  Lifter? get built => _built;

  /// Whether the made lifter is the account's picture: true from the moment
  /// it is saved until a photo is chosen over it.
  bool get isPicture => _built != null && _isPicture;

  /// Whether the maker has been offered at sign-up, made or skipped.
  bool get asked => _asked;

  /// What [name]'s account wears now: the one it made, or the one its name
  /// gives.
  Lifter current(String name) => _built ?? lifterFor(name);

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    _built = _parse(store.getString(_key));
    _isPicture = store.getBool(_pictureKey) ?? false;
    _asked = store.getBool(_askedKey) ?? false;
    _owner = store.getString(_ownerKey);
  }

  static Lifter? _parse(String? saved) {
    if (saved == null || saved.isEmpty) return null;
    try {
      return Lifter.fromJson(jsonDecode(saved) as Map<String, dynamic>);
    } on Object catch (error) {
      debugPrint('Could not read the saved lifter: $error');
      return null;
    }
  }

  /// The sign-up step was shown, and skipped: not offered again.
  Future<void> skip() async {
    _asked = true;
    final store = await SharedPreferences.getInstance();
    await store.setBool(_askedKey, true);
  }

  /// [lifter] becomes this account's, and its picture: here at once, then on
  /// the account and as the photo everybody else sees. A photo chosen
  /// before is put away, since the lifter is now what shows.
  Future<void> save(Lifter lifter) async {
    _built = lifter;
    _isPicture = true;
    _asked = true;
    _owner = backend.me?.id ?? _owner;
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    await store.setString(_key, jsonEncode(lifter.toJson()));
    if (_owner case final owner?) await store.setString(_ownerKey, owner);
    await store.setBool(_pictureKey, true);
    await store.setBool(_askedKey, true);
    if (avatar.hasPhoto) await avatar.clearPhoto();
    avatar.serverPictureChanged();
    await upload();
  }

  /// Sends the made lifter to the account: the parts, so another phone can
  /// edit it, and the PNG, so other people see it. Quietly does nothing it
  /// cannot do; the next save or sign-in tries again.
  Future<void> upload() async {
    final lifter = _built;
    if (lifter == null || !backend.available) return;
    await _sendParts();
    if (!_isPicture) return;
    try {
      await backend.uploadAvatar(await lifterPng(lifter), contentType: 'image/png');
      avatar.serverPictureChanged();
    } on Object catch (error) {
      debugPrint('Could not upload the lifter picture: $error');
    }
  }

  Future<void> _sendParts() async {
    final lifter = _built;
    if (lifter == null || !backend.available) return;
    try {
      await backend.saveLifter({
        ...lifter.toJson(),
        if (!_isPicture) kLifterWorn: false,
      });
    } on Object catch (error) {
      debugPrint('Could not save the lifter to the account: $error');
    }
  }

  /// A photo was chosen: it shows instead, and the lifter waits to be worn
  /// again.
  Future<void> photoChosen() async {
    if (!_isPicture) return;
    _isPicture = false;
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    await store.setBool(_pictureKey, false);
    unawaited(_sendParts());
  }

  /// The photo was taken down: the made lifter is the picture again, here
  /// and for everybody else. Without one, the name's lifter shows.
  Future<void> photoRemoved() async {
    if (_built == null) return;
    _isPicture = true;
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    await store.setBool(_pictureKey, true);
    await upload();
  }

  /// The account's lifter, as the server has it, for [accountId]: taken when
  /// this phone has none of that account's (a new install, a second phone),
  /// sent when only this phone has it.
  ///
  /// Only ever this account's own. A lifter kept for another account — a
  /// backup Android brought back on a reinstall, a sign-in without a sign-out
  /// — is dropped, never sent: a reinstall put a test account's lifter on the
  /// account signed into (the user, 2026-11-05). One kept before the owner
  /// was recorded is not sent either, and the server's, when it has one,
  /// wins over it.
  void adopt(Map<String, dynamic>? json, String accountId) {
    if (_built != null && _owner == accountId) {
      // This account's own, made on this phone: sent if the server lacks it,
      // or does not know a photo was chosen over it.
      if (json == null) {
        unawaited(upload());
      } else if (_isPicture && (backend.me?.avatarUrl ?? '').isEmpty) {
        // Worn, and its picture never went up — a dropped connection, the
        // one try there was — so the boards on older builds drew the name's
        // lifter in its place.
        unawaited(upload());
      } else if (json[kLifterWorn] != false && !_isPicture && avatar.hasPhoto) {
        unawaited(_sendParts());
      }
      return;
    }
    // Nothing of this account's here: the server's lifter, or none — and
    // then the account's picture on the server is what shows (Avatar).
    _built = json == null ? null : Lifter.fromJson(json);
    _isPicture = false;
    if (json != null) _asked = true;
    _owner = accountId;
    notifyListeners();
    unawaited(_persist());
  }

  Future<void> _persist() async {
    final store = await SharedPreferences.getInstance();
    final lifter = _built;
    if (_owner case final owner?) await store.setString(_ownerKey, owner);
    if (lifter == null) {
      await store.remove(_key);
      await store.setBool(_pictureKey, false);
      return;
    }
    await store.setString(_key, jsonEncode(lifter.toJson()));
    await store.setBool(_askedKey, true);
  }

  /// Signed out: the next account in does not wear this one.
  Future<void> forget() async {
    _built = null;
    _isPicture = false;
    _asked = false;
    _owner = null;
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    await store.remove(_key);
    await store.remove(_pictureKey);
    await store.remove(_askedKey);
    await store.remove(_ownerKey);
  }
}

/// A lifter as an image: what [Avatar.picture] hands every screen that shows
/// this account's own picture, so each draws the made lifter without
/// knowing it is one. [PlayerAvatar] draws it as vectors instead.
@immutable
class LifterPicture extends ImageProvider<LifterPicture> {
  const LifterPicture(this.lifter, {this.size = 512});

  final Lifter lifter;
  final int size;

  @override
  Future<LifterPicture> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(LifterPicture key, ImageDecoderCallback decode) =>
      OneFrameImageStreamCompleter(_load(key, decode));

  static Future<ImageInfo> _load(LifterPicture key, ImageDecoderCallback decode) async {
    final png = await lifterPng(key.lifter, size: key.size);
    final codec = await decode(await ui.ImmutableBuffer.fromUint8List(png));
    final frame = await codec.getNextFrame();
    return ImageInfo(image: frame.image);
  }

  @override
  bool operator ==(Object other) =>
      other is LifterPicture && other.lifter == lifter && other.size == size;

  @override
  int get hashCode => Object.hash(lifter, size);
}
