/// Taking a profile picture down from the sheet that sets one: offered only
/// when there is a picture, asked once, and the server's copy goes before
/// the phone's.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/avatar.dart';
import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/avatar_picker.dart';
import 'package:outrepd/theme.dart';

class _Photo extends NoBackend {
  _Photo({String? url, this.fails = false})
    : _me = RemoteProfile(
        id: 'me',
        username: 'mokhtar_',
        tierIdx: 3,
        divIdx: 2,
        lp: 64,
        friendCode: '482910',
        avatarUrl: url,
      );

  final bool fails;
  RemoteProfile _me;
  int removed = 0;

  @override
  bool get available => true;

  @override
  RemoteProfile? get me => _me;

  @override
  Future<void> removeAvatar() async {
    if (fails) throw StateError('offline');
    removed++;
    _me = _me.copyWith(clearAvatar: true);
  }
}

const _url =
    'https://example.supabase.co/storage/v1/object/public/avatars/me/photo.jpg';

Widget _app() => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(
    body: Builder(
      builder: (context) => Center(
        child: TextButton(
          onPressed: () => showAvatarPicker(context, 3),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    avatar.photoPath = null;
  });
  tearDown(() => backend = const NoBackend());

  Future<void> open(WidgetTester tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('with no picture there is nothing to remove', (tester) async {
    backend = _Photo();
    await open(tester);
    expect(find.text('Your picture'), findsOneWidget);
    expect(find.byKey(const Key('removePhoto')), findsNothing);
  });

  testWidgets('a picture is taken down after asking once', (tester) async {
    final server = _Photo(url: _url);
    backend = server;
    await open(tester);

    await tester.tap(find.byKey(const Key('removePhoto')));
    await tester.pumpAndSettle();
    expect(find.text('Remove your photo?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirmRemovePhoto')));
    await tester.pumpAndSettle();
    expect(server.removed, 1);
    expect(server.me!.avatarUrl, isNull);
    expect(avatar.picture, isNull);
    // The sheet has done its job.
    expect(find.text('Your picture'), findsNothing);
  });

  testWidgets('cancelling keeps the picture', (tester) async {
    final server = _Photo(url: _url);
    backend = server;
    await open(tester);

    await tester.tap(find.byKey(const Key('removePhoto')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(server.removed, 0);
    expect(avatar.picture, isNotNull);
    expect(find.text('Your picture'), findsOneWidget);
  });

  testWidgets('a removal that fails says so and keeps the picture',
      (tester) async {
    backend = _Photo(url: _url, fails: true);
    await open(tester);

    await tester.tap(find.byKey(const Key('removePhoto')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmRemovePhoto')));
    await tester.pumpAndSettle();
    expect(find.text('Could not remove your photo. Try again.'), findsOneWidget);
    expect(avatar.picture, isNotNull);
  });
}
