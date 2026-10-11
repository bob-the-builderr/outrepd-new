/// Which links name a lifter, and which do not.
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/deep_links.dart';

void main() {
  test('a profile link names its lifter, with or without www', () {
    expect(lifterNameFromLink(Uri.parse('https://www.outrepd.com/u/karimfit')), 'karimfit');
    expect(lifterNameFromLink(Uri.parse('https://outrepd.com/u/karimfit/')), 'karimfit');
    expect(
      lifterNameFromLink(Uri.parse('https://www.outrepd.com/u/karimfit?code=482913')),
      'karimfit',
    );
  });

  test('anything else names nobody', () {
    expect(lifterNameFromLink(Uri.parse('https://www.outrepd.com/')), isNull);
    expect(lifterNameFromLink(Uri.parse('https://www.outrepd.com/privacy')), isNull);
    expect(lifterNameFromLink(Uri.parse('https://www.outrepd.com/u/')), isNull);
    expect(lifterNameFromLink(Uri.parse('https://www.outrepd.com/u/a/b')), isNull);
    expect(lifterNameFromLink(Uri.parse('https://evil.example/u/karimfit')), isNull);
  });
}
