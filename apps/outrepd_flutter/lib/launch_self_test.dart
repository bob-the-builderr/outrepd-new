/// A check CI runs on the release APK, the one R8 has shrunk and renamed
/// (.github/scripts/launch_check.sh): opened with the intent extra
/// `outrepd.selftest`, the app runs ML Kit's pose detector once, set up as a
/// match sets it up, on a photo it already carries, and logs the answer. A
/// class R8 wrongly took out of ML Kit then fails the run instead of a
/// lifter's first match. On a normal launch MainActivity answers false and
/// nothing happens.
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    as mlkit;
import 'package:path_provider/path_provider.dart';

const _channel = MethodChannel('outrepd/launch');

/// The photo: somebody in a push-up, already in the app for onboarding.
const _photo = 'assets/images/onboarding_live.jpg';

Future<void> runLaunchSelfTest() async {
  if (kIsWeb || !Platform.isAndroid) return;
  if (!await _asked()) return;
  try {
    final data = await rootBundle.load(_photo);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/launch_self_test.jpg');
    await file.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
    final detector = mlkit.PoseDetector(
      options: mlkit.PoseDetectorOptions(mode: mlkit.PoseDetectionMode.stream),
    );
    final poses = await detector.processImage(
      mlkit.InputImage.fromFilePath(file.path),
    );
    await detector.close();
    final landmarks = poses.isEmpty ? 0 : poses.first.landmarks.length;
    debugPrint(
      'OUTREPD-SELFTEST pose ok poses=${poses.length} landmarks=$landmarks',
    );
  } on Object catch (error, stack) {
    debugPrint('OUTREPD-SELFTEST pose failed: $error\n$stack');
  }
}

/// Whether this launch was asked for the check; false wherever the channel
/// is not there to answer.
Future<bool> _asked() async {
  try {
    return await _channel.invokeMethod<bool>('selfTest') ?? false;
  } on Object {
    return false;
  }
}
