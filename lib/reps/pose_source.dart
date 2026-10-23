/// Where poses come from. The camera on a phone, a canned animation in the
/// web preview — the counter and the UI cannot tell the difference, which is
/// what lets the whole screen be reviewed in a browser.
library;

import 'package:flutter/widgets.dart';

import 'pose.dart';
import 'pose_source_demo.dart'
    if (dart.library.io) 'pose_source_camera.dart' as impl;

/// The promo copy's camera: 1080p, or the most the lens gives (4K on a
/// recent iPhone) when the body has to be sharpest in the film. Set by the
/// setup before each take; more pixels ask more of the pose detection.
bool cameraIn4k = false;

abstract class PoseSource {
  Stream<BodyPose> get poses;

  /// Size of the picture the pose coordinates were measured in, already
  /// rotated the way it is shown. The overlay needs it to land on the body:
  /// a 4:3 frame shown on a 20:9 screen is cropped, and the skeleton has to be
  /// cropped by exactly the same amount or it drifts off the lifter.
  ///
  /// Null when there is no real picture behind it, as in the demo.
  Size? get sourceSize;

  /// What to paint behind the skeleton — a camera preview, or nothing.
  Widget? buildPreview(BuildContext context);

  /// Whether this source is watching a real person. False for the demo, which
  /// the UI says out loud rather than letting anyone think it is tracking them.
  bool get isLive;

  Future<void> start();
  Future<void> dispose();
}

/// Why the camera could not be opened.
///
/// The screen's answer is different for each: a refusal can be undone by the
/// person, a phone with no camera cannot, and everything else is a fault worth
/// showing verbatim so it can be reported.
enum PoseSourceFailure {
  /// Refused, and the OS will not ask again — only the settings app can.
  permissionDenied,

  /// This device has no camera to open.
  noCamera,

  /// Anything else the platform threw.
  unknown,
}

/// Reads the platform's error code for what it means.
///
/// The camera plugin reports refusal only as a string code, and the codes
/// differ by platform. Matching on them is unpleasant, but the alternative is
/// showing every camera fault as a permission problem and sending people to a
/// settings page where nothing is wrong.
///
/// It lives here rather than beside the camera so it can be tested on a host
/// with no camera plugin registered — which is every test host.
PoseSourceFailure poseFailureFor(String code) {
  const denied = {
    'CameraAccessDenied',
    'CameraAccessDeniedWithoutPrompt',
    'CameraAccessRestricted',
    'AudioAccessDenied',
    'cameraPermission',
  };
  if (denied.contains(code)) return PoseSourceFailure.permissionDenied;
  if (code == 'cameraNotFound') return PoseSourceFailure.noCamera;
  return PoseSourceFailure.unknown;
}

/// Fails with something the UI can act on rather than throwing on a phone with
/// no camera or a refused permission.
class PoseSourceError implements Exception {
  PoseSourceError(this.message, [this.kind = PoseSourceFailure.unknown]);

  final String message;
  final PoseSourceFailure kind;

  @override
  String toString() => message;
}

PoseSource createPoseSource() => impl.createPoseSource();
