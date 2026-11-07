/// The Pro looks: every cover scene paints, at any moment, and the scenes
/// are the ones the server accepts; the VS screen lays out on a small phone
/// and a large one; a Pro's head breaks out of its circle; how others look
/// comes from the server, this account's own from this phone.
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/lifter/catalog.dart';
import 'package:outrepd/lifter/covers.dart';
import 'package:outrepd/lifter/lifter_view.dart';
import 'package:outrepd/lifter/looks.dart';
import 'package:outrepd/photo_cache.dart';
import 'package:outrepd/screens/vs_screen.dart';
import 'package:outrepd/theme.dart';

class _Server extends NoBackend {
  @override
  bool get available => true;

  final asked = <List<String>>[];

  @override
  Future<Map<String, ProLook>> proLooks(List<String> ids) async {
    asked.add(ids);
    return {
      for (final id in ids)
        if (id == 'pro')
          id: const ProLook(id: 'pro', pro: true, lifter: {'skin': 'neon'}, cover: 'volcano')
        else if (id == 'pro-made-none')
          id: const ProLook(id: 'pro-made-none', pro: true)
        else if (id == 'wears-a-photo')
          id: const ProLook(id: 'wears-a-photo', pro: true, lifter: {'skin': 'neon', 'worn': false})
        else
          id: ProLook(id: id),
    };
  }
}

Widget _app(Widget child, Size size) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(body: Center(child: SizedBox.fromSize(size: size, child: child))),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => backend = const NoBackend());

  group('covers', () {
    test('every scene paints, at any moment', () {
      for (final id in kCovers) {
        for (final t in [0.0, 1.3, 7.9, 61.0]) {
          final recorder = ui.PictureRecorder();
          CoverPainter(id, ValueNotifier(t)).paint(Canvas(recorder), const Size(412, 280));
          recorder.endRecording().dispose();
        }
      }
    });

    test('the scenes are the ones the server accepts', () {
      final schema = File('supabase/schema.sql').readAsStringSync();
      for (final id in kCovers) {
        expect(schema, contains("'$id'"), reason: id);
      }
      expect(isScene('volcano'), isTrue);
      expect(isScene('https://x.supabase.co/a/cover.jpg'), isFalse);
      expect(isScene(null), isFalse);
    });
  });

  group('how people look', () {
    test('a Pro who never made a lifter still has one out over the ring', () async {
      backend = _Server();
      await Looks.instance.fetch(['pro-made-none', 'plain-made-none']);
      expect(Looks.instance.poppingOut('pro-made-none', 'gym_buddy', photo: false), isNotNull);
      // A photo stays a photo, and nobody but a Pro breaks out.
      expect(Looks.instance.poppingOut('pro-made-none', 'gym_buddy', photo: true), isNull);
      expect(Looks.instance.poppingOut('plain-made-none', 'gym_buddy', photo: false), isNull);
    });

    test('a photo chosen over the lifter is what they wear', () async {
      backend = _Server();
      await Looks.instance.fetch(['wears-a-photo']);
      expect(Looks.instance.pro('wears-a-photo'), isTrue);
      expect(Looks.instance.lifter('wears-a-photo'), isNull);
      expect(Looks.instance.poppingOut('wears-a-photo', 'x', photo: true), isNull);
    });

    test('others come from the server, once in a while', () async {
      final server = _Server();
      backend = server;
      await Looks.instance.fetch(['pro', 'plain']);
      expect(Looks.instance.pro('pro'), isTrue);
      expect(Looks.instance.cover('pro'), 'volcano');
      expect(kSkins[Looks.instance.lifter('pro')!.skin].id, 'neon');
      expect(Looks.instance.pro('plain'), isFalse);
      expect(Looks.instance.lifter('plain'), isNull);
      // Asked again a moment later: not sent again.
      await Looks.instance.fetch(['pro', 'plain']);
      expect(server.asked, hasLength(1));
    });
  });

  group('the VS screen', () {
    for (final size in const [Size(360, 640), Size(430, 932)]) {
      testWidgets('lays out on a ${size.width.toInt()} wide phone', (tester) async {
        tester.view.physicalSize = size * 3;
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(_app(
          const VsScreen(
            opponentId: '',
            opponentName: 'squat_queen',
            opponentTierIdx: 4,
            opponentDivIdx: 3,
            opponentXp: 4000,
          ),
          size,
        ));
        await tester.pump(const Duration(milliseconds: 500));
        expect(tester.takeException(), isNull);
        expect(find.text('VS'), findsWidgets);
        expect(find.text('squat_queen'), findsOneWidget);
        expect(find.text('LIVE · RANKED'), findsOneWidget);
        expect(find.text('Get into position'), findsOneWidget);
        await tester.pump(kVsTime);
      });
    }

    testWidgets('an opponent with a photo and no lifter shows the photo',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 2580);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(
        const VsScreen(
          opponentId: '',
          opponentName: 'photo_guy',
          opponentTierIdx: 2,
          opponentDivIdx: 1,
          opponentAvatarUrl: 'https://example.com/photo.jpg',
        ),
        const Size(400, 860),
      ));
      await tester.pump(const Duration(seconds: 1));
      final photos = tester
          .widgetList<Image>(find.byType(Image))
          .where((image) => image.image is CachedPhoto);
      expect(photos, hasLength(1));
      // This account has no photo: its side is a lifter.
      expect(find.byType(LifterImage), findsOneWidget);
      await tester.pump(kVsTime);
    });

    testWidgets('a friend match says so', (tester) async {
      tester.view.physicalSize = const Size(1200, 2580);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(
        const VsScreen(
          opponentId: '',
          opponentName: 'gym_buddy',
          opponentTierIdx: 1,
          opponentDivIdx: 0,
          ranked: false,
        ),
        const Size(400, 860),
      ));
      await tester.pump(kVsTime);
      expect(find.text('LIVE · FRIENDLY'), findsOneWidget);
    });
  });

  testWidgets('a Pro lifter breaks out of its circle', (tester) async {
    await tester.pumpWidget(_app(
      const Center(child: PopOutLifter(Lifter(), size: 40, alive: false)),
      const Size(200, 200),
    ));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(LifterImage), findsNWidgets(2));
  });
}
