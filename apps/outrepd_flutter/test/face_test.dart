/// One face for each person, decided in one place (face.dart) for every
/// screen: the lifter they wear, else their photo, else their name's lifter.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/face.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/lifter/catalog.dart';
import 'package:outrepd/lifter/lifter_view.dart';
import 'package:outrepd/lifter/looks.dart';
import 'package:outrepd/player_avatar.dart';
import 'package:outrepd/theme.dart';

const _parts = {'skin': 'neon', 'hair': 'buzz'};
const _url = 'https://x.supabase.co/storage/v1/object/public/avatars/a/photo.jpg?v=1';

class _Server extends NoBackend {
  @override
  bool get available => true;

  @override
  Future<Map<String, ProLook>> proLooks(List<String> ids) async => {
    for (final id in ids)
      id: switch (id) {
        'face-lifter' => const ProLook(id: 'face-lifter', lifter: _parts),
        'face-photo' => const ProLook(id: 'face-photo', lifter: {..._parts, 'worn': false}),
        'face-pro' => const ProLook(id: 'face-pro', pro: true, lifter: _parts),
        _ => ProLook(id: id),
      },
  };
}

Widget _app(Widget child) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  setUpAll(() async {
    backend = _Server();
    await Looks.instance.fetch(
      ['face-lifter', 'face-photo', 'face-pro', 'face-plain', 'face-none'],
    );
  });
  tearDownAll(() => backend = const NoBackend());

  final made = Lifter.fromJson(_parts);

  test('the lifter they wear, drawn from its parts, over the picture of it', () {
    final face = faceOf(id: 'face-lifter', name: 'lifts', avatarUrl: _url);
    expect(face.photo, isNull);
    expect(face.lifter, made);
  });

  test('a photo chosen over the lifter is what shows', () {
    final face = faceOf(id: 'face-photo', name: 'snaps', avatarUrl: _url);
    expect(face.photo, isNotNull);
  });

  test('a photo and no lifter: the photo, the name\'s lifter while it comes', () {
    final face = faceOf(id: 'face-plain', name: 'plain', avatarUrl: _url);
    expect(face.photo, isNotNull);
    expect(face.lifter, lifterFor('plain'));
  });

  test('nothing at all: the lifter the name gives', () {
    final face = faceOf(id: 'face-none', name: 'nobody');
    expect(face.photo, isNull);
    expect(face.lifter, lifterFor('nobody'));
  });

  test('a Pro wearing a lifter is a Pro', () {
    final face = faceOf(id: 'face-pro', name: 'pro', avatarUrl: _url);
    expect(face.pro, isTrue);
    expect(face.photo, isNull);
  });

  testWidgets('every screen\'s avatar draws that same face', (tester) async {
    await tester.pumpWidget(
      _app(
        const Column(
          children: [
            PersonAvatar(id: 'face-lifter', name: 'lifts', avatarUrl: _url, size: 40),
            PersonAvatar(id: 'face-plain', name: 'plain', avatarUrl: _url, size: 40),
          ],
        ),
      ),
    );
    await tester.pump();
    // The lifter wearer: drawn, no photo to wait for. The photo: one.
    expect(find.byType(PhotoOrLifter), findsOneWidget);
    expect(find.byType(LifterImage), findsWidgets);
    // No download left waiting when the test ends.
    await tester.pump(const Duration(seconds: 30));
  });
}
