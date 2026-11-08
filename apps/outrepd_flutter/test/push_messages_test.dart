/// The words a push is sent in are the app's own, and up to date.
///
/// The push function runs on the server and cannot read the app's
/// translations, so it carries a copy (supabase/functions/push/messages.ts).
/// A copy drifts: fix a German string in the app, and the push still says the
/// old thing. This fails until the copy is written again.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/build_push_messages.dart';

void main() {
  test('the push function has the current translations', () {
    final file = File('supabase/functions/push/messages.ts');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    final json = text.substring(text.indexOf('= {') + 2, text.lastIndexOf(';'));
    final copied = (jsonDecode(json) as Map<String, dynamic>).map(
      (language, words) => MapEntry(
        language,
        (words as Map<String, dynamic>).cast<String, String>(),
      ),
    );

    expect(
      copied,
      pushMessages(),
      reason: 'run: dart run tool/build_push_messages.dart',
    );
  });

  test('every push can name who it is about', () {
    // A push that says "somebody raced your set" is a push nobody opens.
    for (final MapEntry(key: language, value: words) in pushMessages().entries) {
      for (final key in ['nRacedHeld', 'nRacedBeaten', 'nFriendBody',
          'nFriendOkBody', 'nChallengedBody', 'nLiveBody', 'nPassedBody']) {
        expect(words[key], contains('{name}'), reason: '$language $key');
      }
    }
  });
}
