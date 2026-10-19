/// One take: the app's own live match screen against the planned opponent,
/// then the result. Rematch plays it again from the same plan.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../live.dart';
import '../reps/pose_source.dart';
import '../reps/pushup_counter.dart';
import '../screens/trainer.dart';
import '../widgets.dart';
import 'plan.dart';
import 'promo_backend.dart';
import 'result_screen.dart';

/// Where the round's poses come from: the camera, unless a test hands in a
/// script.
@visibleForTesting
PoseSource Function()? promoPoseSource;

/// A picture chosen in the setup, while it is still on the phone.
ImageProvider? photoOf(String? path) {
  if (path == null || !File(path).existsSync()) return null;
  return FileImage(File(path));
}

/// The round, then its result, for as long as Rematch is pressed.
Future<void> playPromoMatch(BuildContext context, PromoPlan plan) async {
  final navigator = Navigator.of(context);
  final l = L.of(context);
  while (true) {
    final promo = PromoBackend(plan);
    backend = promo;
    final session = LiveSession(
      LiveMatch(id: 'promo', ranked: true, opponent: promo.opponent),
    );

    final count = await navigator.push<PushupCount>(
      MaterialPageRoute(
        builder: (_) => TrainerScreen(
          autoStart: true,
          forMatch: true,
          limit: const Duration(seconds: 60),
          live: session,
          poseSource: promoPoseSource,
          duel: DuelContext(
            opponentName: plan.oppName,
            opponentReps: 0,
            opponentTierIdx: plan.oppTier,
            opponentDivIdx: plan.oppDiv,
            rankLabel: tierLabel(l, plan.oppTier, plan.oppDiv),
            opponentImage: photoOf(plan.oppPhoto),
            myName: plan.myName,
            myTierIdx: plan.myTier,
            myDivIdx: plan.myDiv,
            myImage: photoOf(plan.myPhoto),
          ),
        ),
      ),
    );

    final theirs = promo.finalReps(count);
    // Closed, not disposed: the camera screen is still on its way out and
    // lets go of the session itself.
    unawaited(session.close());
    backend = const NoBackend();
    // Back out of the camera, or nobody there: straight back to the setup.
    if (count == null) return;

    final again = await navigator.push<bool>(
      MaterialPageRoute(
        builder: (_) => PromoResultScreen(
          plan: plan,
          yours: count.reps,
          theirs: theirs,
          gaveUp: count.gaveUp,
        ),
      ),
    );
    if (again != true) return;
  }
}
