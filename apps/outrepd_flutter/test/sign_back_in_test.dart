/// Signing out and back in (the user, 2026-11-10): the account's lifter comes
/// back worn, as it was, unless the account chose a photo over it.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/lifter/catalog.dart';
import 'package:outrepd/lifter/my_lifter.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('signing back in wears the lifter the account wears', () async {
    await MyLifter.instance.forget();
    MyLifter.instance.adopt(const Lifter(skin: 3, hair: 2).toJson(), 'me');
    await pumpEventQueue();

    expect(MyLifter.instance.built, isNotNull);
    expect(MyLifter.instance.isPicture, isTrue);
  });

  test('and not one the account chose a photo over', () async {
    await MyLifter.instance.forget();
    MyLifter.instance.adopt({...const Lifter(skin: 3, hair: 2).toJson(), kLifterWorn: false}, 'me');
    await pumpEventQueue();

    expect(MyLifter.instance.built, isNotNull);
    expect(MyLifter.instance.isPicture, isFalse);
  });
}
