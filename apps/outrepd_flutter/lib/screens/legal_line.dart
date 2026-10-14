/// "By continuing you agree to the Terms and the Privacy Policy", with the
/// two documents it names opening when they are tapped.
///
/// The line was written out three times — the first onboarding screen, and
/// signing in and signing up — as plain text with the two names coloured
/// like links. The colour said "tap me" and nothing answered.
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import 'paywall.dart' show kPrivacyUrl, kTermsUrl;

class LegalLine extends StatefulWidget {
  const LegalLine({
    super.key,
    required this.style,
    required this.linkStyle,
    this.textAlign,
  });

  /// The sentence around the two names.
  final TextStyle style;

  /// The two names.
  final TextStyle linkStyle;

  final TextAlign? textAlign;

  @override
  State<LegalLine> createState() => _LegalLineState();
}

class _LegalLineState extends State<LegalLine> {
  late final _terms = TapGestureRecognizer()
    ..onTap = () => openLegalLink(context, kTermsUrl);
  late final _privacy = TapGestureRecognizer()
    ..onTap = () => openLegalLink(context, kPrivacyUrl);

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Text.rich(
      TextSpan(
        style: widget.style,
        children: [
          TextSpan(text: '${l.obTermsIntro} '),
          TextSpan(
            text: l.obTerms,
            style: widget.linkStyle,
            recognizer: _terms,
          ),
          TextSpan(text: ' ${l.obAnd} '),
          TextSpan(
            text: l.obPrivacy,
            style: widget.linkStyle,
            recognizer: _privacy,
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: widget.textAlign,
    );
  }
}

/// The page in the phone's browser, the way Settings and the paywall open
/// the same two; a short note if it could not be opened.
Future<void> openLegalLink(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final l = L.of(context);
  try {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened) throw StateError('launchUrl returned false');
  } on Object catch (error) {
    debugPrint('Could not open $url: $error');
    messenger?.showSnackBar(
      SnackBar(
        content: Text(l.couldNotOpenLink),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
