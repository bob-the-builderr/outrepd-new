/// Is this body actually in a push-up position?
///
/// Every rule here was measured on video shot with the phone exactly where it
/// sits during a set — propped on the floor, a metre in front, front camera —
/// rather than on footage off the internet. That mattered more than anything
/// else in this file: the internet clips are filmed side-on from a tripod, and
/// the app is used head-on from the floor, which projects a body completely
/// differently.
///
/// What the wrong assumptions cost, in order:
///
///   * "The body is in a straight line" — a standing person passes it
///     perfectly, so the skeleton went green and the walk down to the floor
///     was scored as a rep.
///   * "The arm crosses the body at the shoulder" — true side-on, and useless
///     here. Measured through ten real push-ups on the lifter's own camera it
///     reads **3–6°**, because the body points away from the lens and arm and
///     torso project onto nearly the same line. It was rejecting every real
///     rep and accepting somebody standing with their arms out at 94°.
///
/// What is left is two things that hold in that projection, each measured with
/// an order of magnitude of margin:
///
///   1. **The hands stay put.** A push-up is the one movement where the hands
///      are planted and the body travels to them. Measured over the reps: the
///      hands move 0.01–0.11 shoulder widths in half a second. Standing,
///      bobbing, walking up to the phone and lowering onto the floor: 0.25 to
///      1.6.
///   2. **The body is not stood up.** Head-on, a push-up foreshortens the
///      torso against the shoulders — 0.16–0.53 through the reps, against
///      0.68–0.91 while standing. Side-on it does not foreshorten at all, so a
///      torso lying across the frame counts too, and that is the only part of
///      this file still resting on footage rather than on the lifter's camera.
library;

import 'dart:math' as math;

import 'pose.dart';

/// How far the hands may drift, in shoulder widths, over [kPlantWindow]
/// frames.
///
/// The reps measured 0.11 at their worst — the moment of planting — and 0.01
/// to 0.03 once settled. Standing never came under 0.25. The line sits between
/// them, closer to the noise than to the movement.
const kPlantedHands = 0.15;

/// Frames the hands are asked to stay put over. Around half a second on the
/// phone; longer if it runs slower, which only makes the test stricter, and
/// the hands of somebody doing push-ups do not drift no matter how long you
/// watch them.
const kPlantWindow = 15;

/// Torso length over shoulder width, above which the body is stood up facing
/// the camera rather than pointing away from it.
const kUprightTorso = 0.6;

/// How vertical a torso may be in the image and still be lying down: a body
/// filmed from the side runs across the frame, so its shoulders and hips sit
/// at nearly the same height.
const kFlatTorso = 0.5;

/// The distance between the shoulders in the image, or null when they are not
/// both visible.
///
/// The yardstick for everything here. The torso is not: measured through these
/// reps it changes by a factor of two and a half between the top and the
/// bottom, because the body tilts relative to the lens — normalising by it
/// makes every reading swing with the rep.
double? shoulderWidth(BodyPose pose) {
  final left = pose.confident(Joint.leftShoulder);
  final right = pose.confident(Joint.rightShoulder);
  if (left == null || right == null) return null;
  final width = math.sqrt(math.pow(left.x - right.x, 2) + math.pow(left.y - right.y, 2));
  return width < 0.02 ? null : width;
}

/// Whether the body is down rather than stood up in front of the camera.
///
/// Two ways to be down, because there are two ways people set a phone up.
/// Head-on — what the app asks for — the torso foreshortens against the
/// shoulders. Side-on it does not, but then it lies across the frame instead.
bool _bodyIsDown(BodyPose pose) {
  final shoulder = midpoint(pose, Joint.leftShoulder, Joint.rightShoulder);
  final hip = midpoint(pose, Joint.leftHip, Joint.rightHip);
  final width = shoulderWidth(pose);
  if (shoulder == null || hip == null || width == null) return false;

  final dx = hip.$1 - shoulder.$1;
  final dy = hip.$2 - shoulder.$2;
  final torso = math.sqrt(dx * dx + dy * dy);
  if (torso < 0.01) return false;

  if (torso / width <= kUprightTorso) return true;
  return (dy.abs() / torso) <= kFlatTorso;
}

/// What a single frame can say. The hands-planted test needs frames either
/// side of it and lives in [inPushUpPosition].
///
/// Weaker than the full check by exactly that test, so it is used only where
/// there is no sequence to look at.
bool isPushUpPosition(BodyPose pose) => _bodyIsDown(pose);

/// Frame by frame, whether somebody is down in a push-up position with their
/// hands staying where they put them.
List<bool> inPushUpPosition(List<BodyPose> frames) {
  final wrists = [
    for (final f in frames) midpoint(f, Joint.leftWrist, Joint.rightWrist),
  ];
  final widths = [for (final f in frames) shoulderWidth(f)];

  return [
    for (var i = 0; i < frames.length; i++)
      _bodyIsDown(frames[i]) && handsPlanted(wrists, widths, i),
  ];
}

/// Whether the hands have stayed put over the window ending at [i].
bool handsPlanted(
  List<(double, double)?> wrists,
  List<double?> widths,
  int i,
) =>
    (handTravel(wrists, widths, i) ?? double.infinity) <= kPlantedHands;

/// How far the hands moved over the window ending at [i], in shoulder widths,
/// or null when it cannot be measured.
///
/// The furthest point reached anywhere in the window, not the distance from
/// where they were at the start of it: hands that go away and come back have
/// still moved.
double? handTravel(
  List<(double, double)?> wrists,
  List<double?> widths,
  int i,
) {
  final now = wrists[i];
  final width = widths[i];
  if (now == null || width == null) return null;

  var furthest = 0.0;
  for (var j = math.max(0, i - kPlantWindow); j < i; j++) {
    final then = wrists[j];
    if (then == null) continue;
    final dx = now.$1 - then.$1;
    final dy = now.$2 - then.$2;
    final moved = math.sqrt(dx * dx + dy * dy) / width;
    if (moved > furthest) furthest = moved;
  }
  return furthest;
}

/// The point between two joints, or whichever one of them can be seen.
///
/// Midpoints rather than single landmarks throughout: a body turned slightly
/// away from the lens hides one side, and a measurement that depends on the
/// hidden one disappears with it.
(double, double)? midpoint(BodyPose pose, Joint a, Joint b) {
  final pa = pose.confident(a);
  final pb = pose.confident(b);
  if (pa != null && pb != null) {
    return ((pa.x + pb.x) / 2, (pa.y + pb.y) / 2);
  }
  final one = pa ?? pb;
  return one == null ? null : (one.x, one.y);
}
