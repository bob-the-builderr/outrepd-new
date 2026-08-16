/// Where poses come from. The camera on a phone, a canned animation in the
/// web preview — the counter and the UI cannot tell the difference, which is
/// what lets the whole screen be reviewed in a browser.
library;

import 'package:flutter/widgets.dart';

import 'pose.dart';
import 'pose_source_demo.dart'
    if (dart.library.io) 'pose_source_camera.dart' as impl;

abstract class PoseSource {
  Stream<BodyPose> get poses;

  /// What to paint behind the skeleton — a camera preview, or nothing.
  Widget? buildPreview(BuildContext context);

  /// Whether this source is watching a real person. False for the demo, which
  /// the UI says out loud rather than letting anyone think it is tracking them.
  bool get isLive;

  Future<void> start();
  Future<void> dispose();
}

/// Fails with a message the UI can show rather than throwing on a phone with
/// no camera or a refused permission.
class PoseSourceError implements Exception {
  PoseSourceError(this.message);
  final String message;

  @override
  String toString() => message;
}

PoseSource createPoseSource() => impl.createPoseSource();
