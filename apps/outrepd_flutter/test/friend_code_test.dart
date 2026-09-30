/// Adding a friend by the code on their profile, typed however people type it.
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';

void main() {
  test('a code is a code with or without its # and spaces', () {
    // Only '#123456' used to count; '123456' was looked up as a username and
    // found nobody.
    expect(friendCodeIn('#123456'), '123456');
    expect(friendCodeIn('123456'), '123456');
    expect(friendCodeIn(' 123 456 '), '123456');
    expect(friendCodeIn('# 004211'), '004211');
  });

  test('a name is a name', () {
    expect(friendCodeIn('mokhtar'), isNull);
    expect(friendCodeIn('iron_mike99'), isNull);
    // Not six digits, so not a code the server hands out.
    expect(friendCodeIn('12345'), isNull);
    expect(friendCodeIn('#'), isNull);
  });
}
