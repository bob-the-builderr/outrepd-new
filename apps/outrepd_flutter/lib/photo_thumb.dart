/// A photo's small copy, for the circles on the boards and in the lists: a
/// few kilobytes where the photo itself is about a hundred (an 800 px JPEG),
/// for a circle drawn 40 to 58 points across. Uploaded beside the photo as
/// `<id>/thumb.jpg`, under the same `?v=` (Backend.uploadAvatar); a phone that
/// finds none draws the photo itself (photo_cache.dart, PhotoBytes.getSmall).
library;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// The copy's side, in pixels: a podium step, 58 points on a phone at 3x, is
/// 174.
const kThumbSide = 192;

/// [bytes] (a JPEG or a PNG) cut square from the middle and made [kThumbSide]
/// across, with its content type: a PNG stays a PNG — a lifter's flat colours
/// are small that way, and clear corners stay clear — and a photo is a JPEG.
/// Null when [bytes] is not a picture. Worked out away from the screen.
Future<(Uint8List, String)?> makeThumb(Uint8List bytes, {required bool png}) =>
    compute(thumbOf, (bytes, png));

/// [makeThumb]'s work, on whichever isolate calls it.
(Uint8List, String)? thumbOf((Uint8List, bool) job) {
  final (bytes, png) = job;
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  final side = decoded.width < decoded.height ? decoded.width : decoded.height;
  final square = img.copyCrop(
    decoded,
    x: (decoded.width - side) ~/ 2,
    y: (decoded.height - side) ~/ 2,
    width: side,
    height: side,
  );
  final small = img.copyResize(
    square,
    width: kThumbSide,
    height: kThumbSide,
    interpolation: img.Interpolation.average,
  );
  return png
      ? (img.encodePng(small), 'image/png')
      : (img.encodeJpg(small, quality: 80), 'image/jpeg');
}

/// Where [url]'s small copy is: beside the photo, under the same `?v=`. Null
/// for anything that is not an account's uploaded photo.
String? thumbUrlFor(String url) {
  const name = '/photo.jpg';
  final at = url.indexOf(name);
  if (at < 0 || !url.contains('/avatars/')) return null;
  return url.replaceRange(at, at + name.length, '/thumb.jpg');
}
