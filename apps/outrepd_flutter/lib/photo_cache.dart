/// People's uploaded photos, downloaded once and kept: in memory for the
/// session and on the phone between launches.
///
/// A photo used to be downloaded again for every size it was drawn at — the
/// row on a board, the card a name opens, the full profile — because each is
/// decoded at its own size (player_avatar.dart's decodedAt) and Flutter's
/// NetworkImage keeps no bytes. Each time, the lifter stood in its place for
/// a few seconds (the user, 2026-11-05). The bytes are now kept by their
/// URL, which changes when the photo does (`?v=`), so every size after the
/// first is drawn from the phone.
library;

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

import 'photo_thumb.dart';

/// [url]'s photo as every screen should draw it: kept by the app on a
/// phone, by the browser on the web (which has no dart:io to fetch with).
/// [small] for a circle on a board or in a list: the photo's small copy
/// where there is one (photo_thumb.dart).
ImageProvider photoAt(String url, {bool small = false}) =>
    kIsWeb ? NetworkImage(url) : CachedPhoto(url, small: small);

/// [url]'s photo, from the phone when it has been seen before.
@immutable
class CachedPhoto extends ImageProvider<CachedPhoto> {
  const CachedPhoto(this.url, {this.small = false});

  final String url;

  /// The small copy rather than the photo, where there is one.
  final bool small;

  @override
  Future<CachedPhoto> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<CachedPhoto>(this);

  @override
  ImageStreamCompleter loadImage(CachedPhoto key, ImageDecoderCallback decode) =>
      MultiFrameImageStreamCompleter(
        codec: _codec(key, decode),
        scale: 1,
        debugLabel: key.url,
      );

  static Future<ui.Codec> _codec(CachedPhoto key, ImageDecoderCallback decode) async {
    final bytes = key.small
        ? await PhotoBytes.instance.getSmall(key.url)
        : await PhotoBytes.instance.get(key.url);
    return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  bool operator ==(Object other) =>
      other is CachedPhoto && other.url == url && other.small == small;

  @override
  int get hashCode => Object.hash(url, small);

  @override
  String toString() => 'CachedPhoto("$url"${small ? ', small' : ''})';
}

/// The bytes behind [CachedPhoto]: one download per photo, shared by every
/// size it is drawn at.
class PhotoBytes {
  PhotoBytes._();

  static final instance = PhotoBytes._();

  /// The most recently drawn photos' bytes. An uploaded photo is about
  /// 100 KB (800 px JPEG), so this is a few megabytes at most.
  static const _keepInMemory = 80;

  /// Photos kept on the phone. Past this, the oldest go.
  static const _keepOnPhone = 400;

  /// A kept photo older than this is still drawn at once, and read again
  /// behind it: the storage CDN can hand back the old picture for a while
  /// after a new one under a new ?v (it caches by path), and what was kept
  /// then would otherwise stay for good.
  static const _freshFor = Duration(hours: 6);

  /// In the order last drawn, oldest first (a map literal keeps its order).
  final _memory = <String, Uint8List>{};
  final _pending = <String, Future<Uint8List>>{};
  static final _client = HttpClient()..autoUncompress = false;
  Future<Directory?>? _folder;

  /// Whether [url]'s bytes are already in memory: the picture can be drawn
  /// in the same frame.
  bool has(String url) => _memory.containsKey(url);

  Future<Uint8List> get(String url) {
    final kept = _memory.remove(url);
    if (kept != null) {
      _memory[url] = kept;
      return SynchronousFuture<Uint8List>(kept);
    }
    return _pending[url] ??= _fetch(url).whenComplete(() => _pending.remove(url));
  }

  /// Small copies that could not be had: a photo put up before they were
  /// made, or whose copy did not go up. Asked for once a launch, then the
  /// photo itself is drawn.
  final _noSmall = <String>{};

  /// [url]'s small copy where there is one (photo_thumb.dart), or else the
  /// photo itself.
  Future<Uint8List> getSmall(String url) async {
    final small = thumbUrlFor(url);
    if (small == null || _noSmall.contains(small)) return get(url);
    try {
      return await get(small);
    } on Object catch (_) {
      _noSmall.add(small);
      return get(url);
    }
  }

  /// Starts the small copies of the first [first] of [urls] at once, so the
  /// board about to draw them has them, or nearly. Past those, a row asks as
  /// it scrolls in: a hundred pictures nobody scrolls to are not fetched.
  void warmSmall(Iterable<String?> urls, {int first = 24}) {
    for (final url in urls.whereType<String>().where((u) => u.isNotEmpty).take(first)) {
      unawaited(getSmall(url).then<void>((_) {}, onError: (Object _) {}));
    }
  }

  /// Starts [url]'s download early, so a screen about to show it has it.
  void warm(String? url) {
    if (url == null || url.isEmpty || has(url)) return;
    unawaited(get(url).then<void>((_) {}, onError: (Object _) {}));
  }

  Future<Uint8List> _fetch(String url) async {
    final file = await _fileFor(url);
    if (file != null) {
      try {
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          if (bytes.isNotEmpty) {
            _remember(url, bytes);
            final age = DateTime.now().difference(await file.lastModified());
            if (age > _freshFor) unawaited(_refresh(url, file));
            return bytes;
          }
        }
      } on Object catch (error) {
        debugPrint('Could not read a kept photo: $error');
      }
    }
    final bytes = await _download(url);
    _remember(url, bytes);
    if (file != null) unawaited(_write(file, bytes));
    return bytes;
  }

  /// Reads [url] again and keeps it in place of the old copy: the next
  /// screen to draw it has the new one.
  Future<void> _refresh(String url, File file) async {
    try {
      final bytes = await _download(url);
      _remember(url, bytes);
      await _write(file, bytes);
    } on Object catch (error) {
      debugPrint('Could not read a kept photo again: $error');
    }
  }

  void _remember(String url, Uint8List bytes) {
    _memory[url] = bytes;
    while (_memory.length > _keepInMemory) {
      _memory.remove(_memory.keys.first);
    }
  }

  /// A download that hangs on a bad connection held its place in [_pending]
  /// until the app was closed, and the lifter stood in for that photo on
  /// every screen. Given up on, the next time it is drawn asks again.
  static Future<Uint8List> _download(String url) =>
      _read(url).timeout(const Duration(seconds: 20));

  static Future<Uint8List> _read(String url) async {
    final request = await _client.getUrl(Uri.parse(url));
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      await response.drain<void>();
      throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse(url));
    }
    final bytes = await consolidateHttpClientResponseBytes(response);
    if (bytes.isEmpty) throw HttpException('Empty photo', uri: Uri.parse(url));
    return bytes;
  }

  Future<File?> _fileFor(String url) async {
    final folder = await (_folder ??= _openFolder());
    return folder == null ? null : File('${folder.path}/${_name(url)}');
  }

  /// The phone's cache folder for photos, trimmed to [_keepOnPhone] once a
  /// launch. Null where there is none (the tests, the web).
  static Future<Directory?> _openFolder() async {
    if (kIsWeb) return null;
    try {
      final folder = Directory('${(await getTemporaryDirectory()).path}/photos');
      if (!await folder.exists()) await folder.create(recursive: true);
      unawaited(_trim(folder));
      return folder;
    } on Object catch (error) {
      debugPrint('No folder to keep photos in: $error');
      return null;
    }
  }

  static Future<void> _trim(Directory folder) async {
    try {
      final files = await folder.list().where((e) => e is File).cast<File>().toList();
      if (files.length <= _keepOnPhone) return;
      final dated = [for (final f in files) (f, (await f.stat()).modified)]
        ..sort((a, b) => a.$2.compareTo(b.$2));
      for (final (file, _) in dated.take(files.length - _keepOnPhone)) {
        await file.delete();
      }
    } on Object catch (error) {
      debugPrint('Could not trim the kept photos: $error');
    }
  }

  static Future<void> _write(File file, Uint8List bytes) async {
    try {
      // Written beside, then moved: a photo half written when the app was
      // closed is never read back as a whole one.
      final part = File('${file.path}.part');
      await part.writeAsBytes(bytes, flush: true);
      await part.rename(file.path);
    } on Object catch (error) {
      debugPrint('Could not keep a photo: $error');
    }
  }

  /// A file name for [url]: two 32-bit hashes of it (FNV-1a and djb2), so
  /// the name is short and safe whatever the URL holds.
  static String _name(String url) {
    var fnv = 0x811c9dc5, djb = 5381;
    for (final unit in url.codeUnits) {
      fnv = ((fnv ^ unit) * 0x01000193) & 0xFFFFFFFF;
      djb = ((djb << 5) + djb + unit) & 0xFFFFFFFF;
    }
    return '${fnv.toRadixString(16)}${djb.toRadixString(16)}.img';
  }
}
