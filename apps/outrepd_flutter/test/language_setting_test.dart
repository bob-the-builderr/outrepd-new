/// The saved language survives Arabic being taken out of the list.
///
/// It used to be saved as its position in [AppLanguage]. Arabic sat third;
/// removing it moved every language after it up one, so read naively an old
/// "Spanish" would come back as French. It is saved by name now, and an old
/// position is read against the list as it was.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/settings.dart';

Future<AppLanguage> _loaded(Map<String, Object> saved) async {
  SharedPreferences.setMockInitialValues({
    // As a phone that has already had English made its default once.
    'languageDefaultEnglish': true,
    ...saved,
  });
  final settings = AppSettings();
  await settings.load();
  return settings.language;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('an old saved position still means the language it meant', () async {
    expect(await _loaded({'language': 0}), AppLanguage.system);
    expect(await _loaded({'language': 1}), AppLanguage.english);
    expect(await _loaded({'language': 3}), AppLanguage.spanish);
    expect(await _loaded({'language': 5}), AppLanguage.german);
    expect(await _loaded({'language': 14}), AppLanguage.chinese);
  });

  test('somebody who had chosen Arabic follows the device', () async {
    expect(await _loaded({'language': 2}), AppLanguage.system);
  });

  test('a saved name wins over an old position', () async {
    expect(
      await _loaded({'language': 3, 'languageName': 'japanese'}),
      AppLanguage.japanese,
    );
  });

  test('nothing saved, or nonsense saved, is English', () async {
    expect(await _loaded({}), AppLanguage.english);
    expect(await _loaded({'language': 99}), AppLanguage.english);
    expect(await _loaded({'languageName': 'klingon'}), AppLanguage.english);
  });

  test('a fresh install is English, whatever the phone speaks', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = AppSettings();
    await settings.load();
    expect(settings.language, AppLanguage.english);
    expect(settings.language.locale, const Locale('en'));
  });

  test('the old default, saved, becomes English once', () async {
    SharedPreferences.setMockInitialValues({'languageName': 'system'});
    final first = AppSettings();
    await first.load();
    expect(first.language, AppLanguage.english);

    // Chosen again afterwards, following the device is kept.
    SharedPreferences.setMockInitialValues({
      'languageName': 'system',
      'languageDefaultEnglish': true,
    });
    final later = AppSettings();
    await later.load();
    expect(later.language, AppLanguage.system);
  });

  test('a language somebody chose is left alone', () async {
    SharedPreferences.setMockInitialValues({'languageName': 'german'});
    final settings = AppSettings();
    await settings.load();
    expect(settings.language, AppLanguage.german);
  });

  test('a choice is saved by name', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = AppSettings();
    await settings.load();
    settings.update(() => settings.language = AppLanguage.korean);
    final stored = await SharedPreferences.getInstance();
    expect(stored.getString('languageName'), 'korean');
    expect(await _loaded({'languageName': 'korean'}), AppLanguage.korean);
  });
}
