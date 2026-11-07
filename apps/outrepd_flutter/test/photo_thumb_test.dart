/// The small copy of a photo: square, [kThumbSide] across, and a small part
/// of the photo's bytes. The sizes are printed, so the run's log carries the
/// measurement.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:outrepd/photo_thumb.dart';

void main() {
  test('a photo as it is uploaded, and its small copy', () {
    // A real photo from the app's own assets, made what the crop screen
    // uploads: 800 px square, JPEG at quality 88 (avatar_picker.dart).
    final source = img.decodeImage(
      File('assets/images/onboarding_live.jpg').readAsBytesSync(),
    )!;
    final side = source.width < source.height ? source.width : source.height;
    final upload = img.encodeJpg(
      img.copyResize(
        img.copyCrop(
          source,
          x: (source.width - side) ~/ 2,
          y: (source.height - side) ~/ 2,
          width: side,
          height: side,
        ),
        width: 800,
        height: 800,
      ),
      quality: 88,
    );

    final (thumb, type) = thumbOf((upload, false))!;
    final drawn = img.decodeImage(thumb)!;
    // ignore: avoid_print
    print('photo ${upload.length} B, small copy ${thumb.length} B '
        '(${(thumb.length * 100 / upload.length).toStringAsFixed(1)}%)');

    expect(type, 'image/jpeg');
    expect(drawn.width, kThumbSide);
    expect(drawn.height, kThumbSide);
    expect(thumb.length, lessThan(upload.length ~/ 5));
  });

  test('a lifter\'s PNG stays a PNG', () {
    final picture = img.Image(width: 512, height: 512, numChannels: 4)
      ..clear(img.ColorRgba8(40, 120, 200, 255));
    final (thumb, type) = thumbOf((img.encodePng(picture), true))!;
    expect(type, 'image/png');
    expect(img.decodePng(thumb)!.width, kThumbSide);
  });

  test('the copy sits beside the photo, under the same version', () {
    expect(
      thumbUrlFor('https://x.supabase.co/storage/v1/object/public/avatars/abc/photo.jpg?v=12'),
      'https://x.supabase.co/storage/v1/object/public/avatars/abc/thumb.jpg?v=12',
    );
    expect(thumbUrlFor('https://example.test/something/else.jpg'), isNull);
  });
}
