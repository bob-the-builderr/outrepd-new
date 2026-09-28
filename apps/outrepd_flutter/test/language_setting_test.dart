/// The saved language survives Arabic being taken out of the list.
///
/// It used to be saved as its position in [AppLanguage]. Arabic sat third;
/// removing it moved every language after it up one, so read naively an old
/// "Spanish" would come back as French. It is saved by name now, and an old
/// position is read against the list as it was.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/settings.dart';

Future<AppLanguage> _loaded(Map<String, Object> saved) async {
  SharedPreferences.setMockInitialValues(saved);
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

  test('nothing saved, or nonsense saved, is the default', () async {
    expect(await _loaded({}), AppLanguage.system);
    expect(await _loaded({'language': 99}), AppLanguage.system);
    expect(await _loaded({'languageName': 'klingon'}), AppLanguage.system);
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
