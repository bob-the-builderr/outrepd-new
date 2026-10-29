/// What leaving an account does to this phone, whichever way it is left.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../rewards.dart';
import '../subscription.dart';
import 'onboarding.dart';

/// Leaves the phone as a fresh install leaves it, once the account is gone
/// from it — signed out, or deleted: the store forgets the account, the
/// career it kept goes, the phone opens on the welcome screen again, and a
/// new session is behind it so signing up works as it did the first time.
///
/// One function for both, because they had drifted: deleting an account
/// used to clear the career and go back to the home screen with no account
/// behind it at all, still marked as set up — and the next launch made a
/// guest session and opened the app's paywall to it, before any email.
Future<void> leaveForWelcome(NavigatorState navigator) async {
  await Subscription.instance.forget();
  // What this phone kept of the account — its rank and totals — is the
  // server's copy, and comes back with the next sign-in.
  await Career.instance.startFresh();
  // The titles and streak too: the account has them (sent before signing
  // out), and the next one in should not wear these.
  await rewards.forget();
  await markNotOnboarded();
  try {
    await backend.signIn(username: 'lifter');
  } on Object catch (error) {
    // Offline: the welcome screen still opens, and signing in or up asks the
    // server again when it is used.
    debugPrint('Could not start a new session: $error');
  }
  navigator.pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    (_) => false,
  );
}
