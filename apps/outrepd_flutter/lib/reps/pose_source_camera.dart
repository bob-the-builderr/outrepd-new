/// The real thing: the front camera feeding ML Kit's pose detector.
///
/// Detection runs on the device — no upload, no account, and it keeps working
/// with the phone in aeroplane mode. Frames are dropped rather than queued
/// when detection cannot keep up, so the overlay stays in step with the body
/// instead of drifting further behind it.
library;

import 'dart:async';
import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    as mlkit;

import 'pose.dart';
import 'pose_source.dart';

/// ML Kit tracks 33 landmarks; these are the ones the exercise definitions
/// can name.
const _wanted = <mlkit.PoseLandmarkType, Joint>{
  mlkit.PoseLandmarkType.nose: Joint.nose,
  mlkit.PoseLandmarkType.leftShoulder: Joint.leftShoulder,
  mlkit.PoseLandmarkType.rightShoulder: Joint.rightShoulder,
  mlkit.PoseLandmarkType.leftElbow: Joint.leftElbow,
  mlkit.PoseLandmarkType.rightElbow: Joint.rightElbow,
  mlkit.PoseLandmarkType.leftWrist: Joint.leftWrist,
  mlkit.PoseLandmarkType.rightWrist: Joint.rightWrist,
  mlkit.PoseLandmarkType.leftHip: Joint.leftHip,
  mlkit.PoseLandmarkType.rightHip: Joint.rightHip,
  mlkit.PoseLandmarkType.leftKnee: Joint.leftKnee,
  mlkit.PoseLandmarkType.rightKnee: Joint.rightKnee,
  mlkit.PoseLandmarkType.leftAnkle: Joint.leftAnkle,
  mlkit.PoseLandmarkType.rightAnkle: Joint.rightAnkle,
};

class CameraPoseSource implements PoseSource {
  final _controller = StreamController<BodyPose>.broadcast();
  final _detector = mlkit.PoseDetector(
    options: mlkit.PoseDetectorOptions(mode: mlkit.PoseDetectionMode.stream),
  );

  CameraController? _camera;
  bool _busy = false;
  bool _stopped = false;

  @override
  Stream<BodyPose> get poses => _controller.stream;

  @override
  bool get isLive => true;

  @override
  Widget? buildPreview(BuildContext context) {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return null;
    return CameraPreview(camera);
  }

  @override
  Future<void> start() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw PoseSourceError('No camera on this device');
    }

    // Front facing, so the lifter can see the overlay while they work.
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    final controller = CameraController(
      camera,
      // Detection accuracy plateaus well below full resolution, and a smaller
      // frame is the difference between 30fps and a slideshow on a mid phone.
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup:
          Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await controller.initialize();
    if (_stopped) {
      await controller.dispose();
      return;
    }
    _camera = controller;

    await controller.startImageStream(_onFrame);
  }

  void _onFrame(CameraImage image) {
    // Skip rather than queue: a backlog would show the overlay where the body
    // was a second ago.
    if (_busy || _stopped) return;
    _busy = true;
    _detect(image).whenComplete(() => _busy = false);
  }

  Future<void> _detect(CameraImage image) async {
    final input = _toInputImage(image);
    if (input == null) return;

    try {
      final found = await _detector.processImage(input);
      if (found.isEmpty || _stopped) return;
      _controller.add(_convert(found.first, image));
    } on Exception {
      // A frame the detector cannot read is not worth interrupting a set for.
    }
  }

  mlkit.InputImage? _toInputImage(CameraImage image) {
    final camera = _camera;
    if (camera == null) return null;

    final rotation = mlkit.InputImageRotationValue.fromRawValue(
      camera.description.sensorOrientation,
    );
    final format =
        mlkit.InputImageFormatValue.fromRawValue(image.format.raw as int);
    if (rotation == null || format == null || image.planes.isEmpty) return null;

    return mlkit.InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: mlkit.InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  /// ML Kit reports pixels in the frame's own coordinates; the rest of the app
  /// works in 0..1 so nothing downstream cares about resolution.
  BodyPose _convert(mlkit.Pose pose, CameraImage image) {
    final w = image.width.toDouble();
    final h = image.height.toDouble();

    final points = <Joint, PosePoint>{};
    for (final entry in _wanted.entries) {
      final landmark = pose.landmarks[entry.key];
      if (landmark == null) continue;
      points[entry.value] = PosePoint(
        (landmark.x / w).clamp(0.0, 1.0),
        (landmark.y / h).clamp(0.0, 1.0),
        landmark.likelihood,
        // Depth comes in the same units as x, so it scales the same way. Not
        // clamped: it is measured from the hips and runs either side of zero.
        landmark.z / w,
      );
    }
    return BodyPose(points);
  }

  @override
  Future<void> dispose() async {
    _stopped = true;
    final camera = _camera;
    _camera = null;
    if (camera != null) {
      if (camera.value.isStreamingImages) await camera.stopImageStream();
      await camera.dispose();
    }
    await _detector.close();
    await _controller.close();
  }
}

PoseSource createPoseSource() => CameraPoseSource();
