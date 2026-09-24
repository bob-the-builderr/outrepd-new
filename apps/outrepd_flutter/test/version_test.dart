/// The version on screen is the version that was built.
///
/// `kAppVersion` is written by hand, so the only thing stopping it drifting
/// from `pubspec.yaml` is this. It is the first string anybody quotes in a
/// bug report, and one that lags a release points every report at the wrong
/// build.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/data.dart';

void main() {
  test('kAppVersion matches pubspec', () {
    final line = File(
      'pubspec.yaml',
    ).readAsLinesSync().firstWhere((l) => l.startsWith('version:'));
    final inPubspec = line.split(':').last.trim();

    expect(
      kAppVersion,
      inPubspec,
      reason: 'settings would show $kAppVersion for a $inPubspec build',
    );
  });
}
