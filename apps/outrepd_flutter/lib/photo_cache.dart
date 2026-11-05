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

/// [url]'s photo as every screen should draw it: kept by the app on a
/// phone, by the browser on the web (which has no dart:io to fetch with).
ImageProvider photoAt(String url) => kIsWeb ? NetworkImage(url) : CachedPhoto(url);

/// [url]'s photo, from the phone when it has been seen before.
@immutable
class CachedPhoto extends ImageProvider<CachedPhoto> {
  const CachedPhoto(this.url);

  final String url;

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
    final bytes = await PhotoBytes.instance.get(key.url);
    return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  bool operator ==(Object other) => other is CachedPhoto && other.url == url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => 'CachedPhoto("$url")';
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

  void _remember(String url, Uint8List bytes) {
    _memory[url] = bytes;
    while (_memory.length > _keepInMemory) {
      _memory.remove(_memory.keys.first);
    }
  }

  static Future<Uint8List> _download(String url) async {
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
