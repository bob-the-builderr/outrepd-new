/// What somebody looks like, decided in one place for every screen that draws
/// a person — every board, the friends list and its ranks, a profile, the VS
/// screen, a match, its result, an invite, a shared card — so nobody looks one
/// way on the week's board and another on the month's, or on their profile
/// (the user, 2026-11-08).
///
/// In order: the lifter they made and wear, drawn from its parts, which come
/// with how people look (Looks) and need nothing downloaded; else their photo
/// — the small copy for a small circle — with the lifter their name gives
/// standing in while it comes down; else the lifter their name gives. A Pro
/// who wears a lifter has it alive, and on a board out over the ring. This
/// account's own picture is this phone's (Avatar.picture).
library;

import 'package:flutter/material.dart';

import 'avatar.dart';
import 'lifter/catalog.dart';
import 'lifter/lifter_view.dart';
import 'lifter/looks.dart';
import 'lifter/my_lifter.dart';
import 'player_avatar.dart';
import 'subscription.dart';

class Face {
  const Face({required this.lifter, this.photo, this.pro = false});

  /// Drawn when there is no [photo], and in its place while it comes down.
  final Lifter lifter;

  /// Their photo, or null when the lifter is the picture.
  final ImageProvider? photo;

  final bool pro;
}

/// [name]'s face. [id] is what Looks knows them by; empty for a sample, who
/// has only a name and perhaps a picture. [small] for a circle of a board's
/// or a list's size.
Face faceOf({
  required String id,
  required String name,
  String? avatarUrl,
  bool mine = false,
  bool small = false,
}) {
  if (mine) {
    final own = avatar.picture;
    final pro = Subscription.instance.active;
    if (own is LifterPicture) return Face(lifter: own.lifter, pro: pro);
    return Face(lifter: MyLifter.instance.current(name), photo: own, pro: pro);
  }
  final looks = Looks.instance..want(id);
  final pro = looks.pro(id);
  // Null when they chose a photo over it (kLifterWorn), or never made one.
  final made = looks.lifter(id);
  if (made != null) return Face(lifter: made, pro: pro);
  return Face(
    lifter: lifterFor(name),
    photo: pictureAt(avatarUrl, small: small),
    pro: pro,
  );
}

/// A person in their tier's frame, as [faceOf] decides: what every screen
/// that shows somebody draws, drawn again when how they look arrives.
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    super.key,
    required this.id,
    required this.name,
    this.avatarUrl,
    this.tierIdx,
    this.size = 48,
    this.mine = false,
    this.textColour,
    this.onTap,
    this.onBadgeTap,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final int? tierIdx;
  final double size;
  final bool mine;
  final Color? textColour;
  final VoidCallback? onTap;
  final VoidCallback? onBadgeTap;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: mine
        ? Listenable.merge([avatar, MyLifter.instance, Subscription.instance])
        : Looks.instance,
    builder: (context, _) {
      final face = faceOf(
        id: id,
        name: name,
        avatarUrl: avatarUrl,
        mine: mine,
        small: size <= 64,
      );
      return PlayerAvatar(
        name: name,
        tierIdx: tierIdx,
        image: face.photo,
        lifter: face.lifter,
        alive: face.pro && face.photo == null,
        size: size,
        textColour: textColour,
        onTap: onTap,
        onBadgeTap: onBadgeTap,
      );
    },
  );
}

/// [face] as one image, for a screen that takes a picture rather than a
/// person: the photo, or the lifter as a picture (drawn in vectors where it
/// is shown).
ImageProvider imageOf(Face face) => face.photo ?? LifterPicture(face.lifter);
