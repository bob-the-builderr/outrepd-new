/// Continue with Apple, continue with Google: an account in two taps, on the
/// sign-up and log-in screens alike, above the email way in.
///
/// The phone's own sheet asks the person; what it hands back — an identity
/// token — goes to [Backend.signInWithIdToken], which links it to this
/// phone's guest (keeping what it has earned) or signs in to the account
/// that already has it.
///
/// Apple only on iPhone, where the App Store asks for it alongside any other
/// sign-in. Google only once the build carries its client ids
/// (GOOGLE_WEB_CLIENT_ID, and GOOGLE_IOS_CLIENT_ID on iPhone): without them
/// the button would open a sheet that cannot finish.
library;

import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

const _googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
const _googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

bool get appleSignInOffered =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

bool get googleSignInOffered =>
    !kIsWeb &&
    _googleWebClientId.isNotEmpty &&
    (defaultTargetPlatform == TargetPlatform.android ||
        (defaultTargetPlatform == TargetPlatform.iOS &&
            _googleIosClientId.isNotEmpty));

bool get socialSignInOffered => appleSignInOffered || googleSignInOffered;

/// Asks the phone for the person's Apple or Google identity and signs in
/// with it. Null when they closed the sheet: nothing to say about that.
Future<SocialSignInResult?> signInWith(SocialProvider provider) async {
  try {
    return switch (provider) {
      SocialProvider.apple => await _apple(),
      SocialProvider.google => await _google(),
    };
  } on SignInWithAppleAuthorizationException catch (error) {
    if (error.code == AuthorizationErrorCode.canceled) return null;
    debugPrint('Apple sign-in: ${error.message}');
    return SocialSignInResult.failed;
  } on GoogleSignInException catch (error) {
    if (error.code == GoogleSignInExceptionCode.canceled) return null;
    debugPrint('Google sign-in: ${error.description}');
    return SocialSignInResult.failed;
  } on Object catch (error) {
    debugPrint('Sign-in with ${provider.name} failed: $error');
    return SocialSignInResult.failed;
  }
}

Future<SocialSignInResult> _apple() async {
  // Apple signs a hash of a one-off value into the token; the server checks
  // the token against the value itself, so a token cannot be replayed.
  final nonce = _nonce();
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [AppleIDAuthorizationScopes.email],
    nonce: sha256.convert(utf8.encode(nonce)).toString(),
  );
  final token = credential.identityToken;
  if (token == null) return SocialSignInResult.failed;
  return backend.signInWithIdToken(
    provider: SocialProvider.apple,
    idToken: token,
    nonce: nonce,
  );
}

Future<void>? _googleReady;

Future<SocialSignInResult> _google() async {
  final google = GoogleSignIn.instance;
  await (_googleReady ??= google.initialize(
    clientId: Platform.isIOS ? _googleIosClientId : null,
    serverClientId: _googleWebClientId,
  ));
  final account = await google.authenticate();
  final token = account.authentication.idToken;
  if (token == null) return SocialSignInResult.failed;
  // Asked for quietly: when it comes without a sheet the server checks the
  // token against it, and when it does not the token is enough.
  final access = await account.authorizationClient
      .authorizationForScopes(const ['email']);
  return backend.signInWithIdToken(
    provider: SocialProvider.google,
    idToken: token,
    accessToken: access?.accessToken,
  );
}

String _nonce([int length = 32]) {
  const chars =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = math.Random.secure();
  return List.generate(length, (_) => chars[random.nextInt(chars.length)])
      .join();
}

/// The two buttons, Apple first, each the full width of the screen. Shows
/// nothing where neither is offered.
class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({
    super.key,
    required this.onPressed,
    this.busy,
  });

  final ValueChanged<SocialProvider> onPressed;

  /// The one being signed in with, which shows that it is working; the
  /// other waits.
  final SocialProvider? busy;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (appleSignInOffered) ...[
          _Button(
            key: const Key('continueWithApple'),
            label: l.continueWithApple,
            icon: const Icon(Icons.apple, size: 24, color: Colors.black),
            background: Colors.white,
            foreground: Colors.black,
            busy: busy == SocialProvider.apple,
            onPressed: busy == null
                ? () => onPressed(SocialProvider.apple)
                : null,
          ),
          const SizedBox(height: 10),
        ],
        if (googleSignInOffered) ...[
          _Button(
            key: const Key('continueWithGoogle'),
            label: l.continueWithGoogle,
            icon: const SizedBox(
              width: 20,
              height: 20,
              child: CustomPaint(painter: _GoogleMark()),
            ),
            foreground: context.colors.text,
            border: context.colors.text.withValues(alpha: 0.25),
            busy: busy == SocialProvider.google,
            onPressed: busy == null
                ? () => onPressed(SocialProvider.google)
                : null,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    super.key,
    required this.label,
    required this.icon,
    required this.foreground,
    required this.busy,
    required this.onPressed,
    this.background,
    this.border,
  });

  final String label;
  final Widget icon;
  final Color foreground;
  final Color? background;
  final Color? border;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledForegroundColor: foreground.withValues(alpha: 0.6),
          disabledBackgroundColor: background?.withValues(alpha: 0.8),
          side: BorderSide(
            color: border ?? Colors.transparent,
            width: border == null ? 0 : 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: busy
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foreground,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Google's four-colour G, drawn rather than loaded.
class _GoogleMark extends CustomPainter {
  const _GoogleMark();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final stroke = s * 0.2;
    final rect = Rect.fromCircle(
      center: Offset(s / 2, s / 2),
      radius: (s - stroke) / 2,
    );
    Paint arc(int colour) => Paint()
      ..color = Color(colour)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    const deg = math.pi / 180;
    // Clockwise from the bar on the right: blue, green, yellow, red.
    canvas.drawArc(rect, -10 * deg, 55 * deg, false, arc(0xFF4285F4));
    canvas.drawArc(rect, 45 * deg, 90 * deg, false, arc(0xFF34A853));
    canvas.drawArc(rect, 135 * deg, 90 * deg, false, arc(0xFFFBBC05));
    canvas.drawArc(rect, 225 * deg, 85 * deg, false, arc(0xFFEA4335));
    canvas.drawRect(
      Rect.fromLTWH(s / 2, s / 2 - stroke / 2, s / 2 - stroke / 4, stroke),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
