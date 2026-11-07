/// A photo chosen on this phone reaches everybody else: it is sent again when
/// the first try failed, it never reaches another account, and a lifter made
/// earlier does not stand in front of it.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/avatar.dart';
import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/lifter/lifter_view.dart';
import 'package:outrepd/lifter/my_lifter.dart';

class _Server extends NoBackend {
  bool fail = false;
  int uploads = 0;
  Map<String, Object>? parts;

  @override
  bool get available => true;

  @override
  Future<String> uploadAvatar(
    Uint8List bytes, {
    String contentType = 'image/jpeg',
  }) async {
    if (fail) throw StateError('no connection');
    uploads++;
    return 'https://example.test/photo.jpg';
  }

  @override
  Future<void> saveLifter(Map<String, Object> lifter) async => parts = lifter;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory folder;
  late File photo;
  late _Server server;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    folder = Directory.systemTemp.createTempSync('photo');
    photo = File('${folder.path}/avatar.jpg')..writeAsBytesSync([1, 2, 3]);
    avatar.photoPath = null;
    server = _Server();
    backend = server;
  });

  tearDown(() {
    avatar.photoPath = null;
    backend = const NoBackend();
    folder.deleteSync(recursive: true);
  });

  test('a photo that could not be sent goes the next time, and once', () async {
    await avatar.usePhoto(photo.path);
    server.fail = true;
    await expectLater(avatar.sendPhoto(), throwsStateError);
    expect(server.uploads, 0);

    server.fail = false;
    await avatar.sendWaiting('me');
    expect(server.uploads, 1);

    await avatar.sendWaiting('me');
    expect(server.uploads, 1);
  });

  test('one sent the first time is not sent again', () async {
    await avatar.usePhoto(photo.path);
    await avatar.sendPhoto();
    await avatar.sendWaiting('me');
    expect(server.uploads, 1);
  });

  test('a photo chosen on another account never goes to this one', () async {
    SharedPreferences.setMockInitialValues({
      'avatarPhotoWaiting': true,
      'avatarPhotoFor': 'somebody-else',
    });
    avatar.photoPath = photo.path;
    await avatar.sendWaiting('me');
    expect(server.uploads, 0);
  });

  test('a photo from before this was kept is left alone: nothing says whose', () async {
    avatar.photoPath = photo.path;
    await avatar.sendWaiting('me');
    expect(server.uploads, 0);
  });

  group('with a lifter made first', () {
    Future<void> madeOnThisAccount({required bool worn}) async {
      SharedPreferences.setMockInitialValues({
        'lifter': jsonEncode(lifterFor('me').toJson()),
        'lifterIsPicture': worn,
        'lifterOwner': 'me',
      });
      await MyLifter.instance.load();
    }

    tearDown(() => MyLifter.instance.forget());

    test('choosing a photo tells the account the lifter is not worn', () async {
      await madeOnThisAccount(worn: true);
      await avatar.usePhoto(photo.path);
      await pumpEventQueue();

      expect(MyLifter.instance.isPicture, isFalse);
      expect(server.parts?[kLifterWorn], isFalse);
    });

    test('a photo chosen before the account kept that is told at sign-in', () async {
      await madeOnThisAccount(worn: false);
      avatar.photoPath = photo.path;

      MyLifter.instance.adopt(lifterFor('me').toJson(), 'me');
      await pumpEventQueue();

      expect(server.parts?[kLifterWorn], isFalse);
    });

    test('the account told already is not told again', () async {
      await madeOnThisAccount(worn: false);
      avatar.photoPath = photo.path;

      MyLifter.instance.adopt({...lifterFor('me').toJson(), kLifterWorn: false}, 'me');
      await pumpEventQueue();

      expect(server.parts, isNull);
    });
  });
}
