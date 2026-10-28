/// The account gate at the end of onboarding: Apple or Google, and the name a
/// new account picks after them.
///
/// One gate rather than the mid-flow prompt this used to be, because an
/// account is no longer optional — nobody reaches a duel without one. It ends
/// one way: pop with an [AuthOutcome], the same signal
/// [Career.adoptServerProfile] or a fresh [applyServerProfile] read off of,
/// all the way back to whoever opened [AuthEntryScreen].
///
/// There was an email way in as well — a form, a log-in page, a six-digit
/// code — until the user took it out (2026-10-27): every code it sent was an
/// email paid for, and Apple and Google make an account without one. The same
/// two buttons sign a returning lifter back in.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../backend/backend.dart';
import '../career.dart';
import '../country_names.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../username_rules.dart';
import 'country_picker.dart';
import 'legal_line.dart';
import 'social_sign_in.dart';

/// What this whole gate finished with, popped back to whoever opened
/// [AuthEntryScreen]. Signing up keeps going with whatever was next —
/// placements, the first match. Signing in swapped this device for a
/// different, already-complete account, which has no more use for any of
/// that.
enum AuthOutcome { signedUp, signedIn }

// ──────────────────────────────── entry ────────────────────────────────────

class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key});

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen>
    with _SocialSignIn {
  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
          child: Column(
            children: [
              // The ranks are the hero — every crest on the ladder, the top
              // one over them — and what the app is in two lines. Scaled down as a whole on a short
              // phone rather than pushing the buttons off the screen.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) => Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: box.maxWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _HeroCrests(),
                            const SizedBox(height: 14),
                            Text(
                              l.authHeroTitle,
                              key: const Key('authHeroTitle'),
                              textAlign: TextAlign.center,
                              style: context.type.title.copyWith(
                                color: context.colors.text,
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l.authHeroSubtitle,
                              textAlign: TextAlign.center,
                              style: context.type.body.copyWith(
                                color: context.colors.text.withValues(
                                  alpha: 0.78,
                                ),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Apple and Google, the only ways in: a new account and a
              // returning one take the same button.
              _socialButtons(),
              const SizedBox(height: 10),
              LegalLine(
                style: TextStyle(color: context.colors.faint, fontSize: 13),
                linkStyle: TextStyle(color: context.colors.muted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── the username ────────────────────────────────

/// The username field and its live checks — red the moment the name is
/// wrong, and whether it is free once typing pauses — on the screen every
/// new account names itself on, after Apple or Google.
mixin _UsernameChecks<T extends StatefulWidget> on State<T> {
  final _username = TextEditingController();

  /// Whether the name typed is free, once a pause in typing has asked; null
  /// before that, and whenever the field has changed since.
  bool? _available;
  bool _checking = false;
  Timer? _debounce;

  /// The name was edited: anything said about the last one no longer holds.
  void _usernameEdited() {}

  @override
  void dispose() {
    _debounce?.cancel();
    _username.dispose();
    super.dispose();
  }

  Widget _usernameField(L l) => _Field(
    key: const Key('signUpUsername'),
    controller: _username,
    icon: Icons.alternate_email,
    hint: l.usernameLabel,
    inputFormatters: usernameFormatters,
    errorText: _usernameError(l),
    helperText: _available == true
        ? '${l.obAvailable} · ${l.usernameSpacesHint}'
        : l.usernameSpacesHint,
    suffix: _checking
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.colors.muted,
            ),
          )
        : _available == true && _usernameError(l) == null
        ? const Icon(Icons.check, size: 20, color: AppColors.win)
        : _available == false
        ? const Icon(Icons.close, size: 20, color: AppColors.loss)
        : null,
    onChanged: _usernameChanged,
  );

  void _usernameChanged(String value) {
    setState(() {
      _usernameEdited();
      _available = null;
      _checking = false;
    });
    _debounce?.cancel();
    if (!usernameValid(value) || !backend.available || backend.me == null) {
      return;
    }
    // A pause in typing, not every letter.
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) return;
      setState(() => _checking = true);
      try {
        final free = await backend.usernameAvailable(value);
        if (mounted && _username.text == value) {
          setState(() {
            _available = free;
            _checking = false;
          });
        }
      } on Object catch (error) {
        // Not knowing is not a reason to stop anybody: the server checks
        // again when the account is made.
        debugPrint('Could not check the username: $error');
        if (mounted) setState(() => _checking = false);
      }
    });
  }

  /// What is wrong with the name, as it is typed, or null.
  String? _usernameError(L l) =>
      usernameProblem(l, _username.text) ??
      (_available == false ? l.usernameTaken : null);
}

// ─────────────────────────────── shared field ───────────────────────────────

class _Field extends StatelessWidget {
  const _Field({
    super.key,
    required this.controller,
    this.hint,
    this.onChanged,
    this.inputFormatters,
    this.errorText,
    this.suffix,
    this.icon,
    this.helperText,
  });

  /// At the start of the field: what it is for, in place of a label above.
  final IconData? icon;

  /// Said quietly under the field while nothing is wrong.
  final String? helperText;

  final List<TextInputFormatter>? inputFormatters;

  /// Said in red under the field, with a red edge, as soon as it is true.
  final String? errorText;

  /// At the end of the field: whether the name is free.
  final Widget? suffix;

  final TextEditingController controller;
  final String? hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: inputFormatters == null,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          style: TextStyle(color: context.colors.text, fontSize: 18),
          cursorColor: context.colors.brand,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: context.colors.faint, fontSize: 18),
            suffixIcon: suffix == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: suffix,
                  ),
            suffixIconConstraints: const BoxConstraints(minWidth: 24),
            prefixIcon: icon == null
                ? null
                : Icon(icon, size: 21, color: context.colors.muted),
            helperText: helperText,
            helperStyle: context.type.label.copyWith(
              color: context.colors.muted,
            ),
            errorText: errorText,
            errorStyle: context.type.label.copyWith(color: AppColors.loss),
            errorMaxLines: 2,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: AppColors.loss),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: AppColors.loss, width: 1.5),
            ),
            filled: true,
            fillColor: context.colors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: context.colors.border),
            ),
            // A hairline at rest; the brand colour only on the field in use.
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: context.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: context.colors.brand),
            ),
          ),
        ),
      ],
    );
  }
}

/// The entry screen's hero: every crest on the ladder, scattered and tilted
/// as if tossed on a table, and the Master crest — the top of it — large in
/// the middle over them. No glow, not even the crests' own: drawn this
/// large it reads as a soft edge, and the crests are sharpest as they are.
class _HeroCrests extends StatelessWidget {
  const _HeroCrests();

  static const _width = 340.0;
  static const _height = 290.0;

  /// Where each crest below the top lies, by tier: its centre in the box,
  /// its size and its tilt in degrees. Fixed, so the scatter is the same on
  /// every phone and every launch.
  static const _scatter = <(int, double, double, double, double)>[
    (0, 64, 66, 74, -14),
    (1, 278, 58, 80, 12),
    (2, 54, 184, 84, 9),
    (3, 288, 190, 88, -10),
    (4, 120, 250, 72, -5),
    (5, 224, 252, 78, 7),
  ];

  @override
  Widget build(BuildContext context) {
    final top = kTiers.length - 1;
    const master = 196.0;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final (tier, x, y, size, tilt) in _scatter)
            Positioned(
              left: x - size / 2,
              top: y - size / 2,
              child: Transform.rotate(
                angle: tilt * math.pi / 180,
                child: TierBadge(tierIndex: tier, size: size, glow: false),
              ),
            ),
          Positioned(
            left: (_width - master) / 2,
            top: (_height - master) / 2,
            child: TierBadge(tierIndex: top, size: master, glow: false),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────── Apple and Google ─────────────────────────────

/// Continue with Apple or Google, from the entry screen or the log-in one.
/// A new account names itself next and carries on as a sign-up; one that
/// already existed is this phone's from now on, as a log-in.
mixin _SocialSignIn<T extends StatefulWidget> on State<T> {
  SocialProvider? _socialBusy;

  Future<void> _continueWith(SocialProvider provider) async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _socialBusy = provider);
    final result = await signInWith(provider);
    if (!mounted) return;
    setState(() => _socialBusy = null);

    void say(String message) => messenger.showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );

    switch (result) {
      case null:
        // The sheet was closed: nothing happened, nothing to say.
        return;
      case SocialSignInResult.newAccount:
        await Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (_) => const ChooseUsernameScreen()),
        );
        if (mounted) Navigator.of(context).pop(AuthOutcome.signedUp);
      case SocialSignInResult.existingAccount:
        await Career.instance.adoptServerProfile(backend.me!);
        if (mounted) Navigator.of(context).pop(AuthOutcome.signedIn);
      case SocialSignInResult.failed:
        // With the reason, short: a failure only setup can fix says which.
        final why = lastSocialSignInError;
        say(
          why == null || why.isEmpty
              ? l.socialSignInFailed
              : '${l.socialSignInFailed} (${why.length > 120 ? why.substring(0, 120) : why})',
        );
      case SocialSignInResult.offline:
        say(l.cantReachServer);
    }
  }

  Widget _socialButtons() =>
      SocialSignInButtons(onPressed: _continueWith, busy: _socialBusy);
}

/// A new Apple or Google account's name, chosen before anything else. The
/// account already exists by now, so there is no going back from here —
/// only on, with a name.
class ChooseUsernameScreen extends StatefulWidget {
  const ChooseUsernameScreen({super.key});

  @override
  State<ChooseUsernameScreen> createState() => _ChooseUsernameScreenState();
}

class _ChooseUsernameScreenState extends State<ChooseUsernameScreen>
    with _UsernameChecks {
  bool _busy = false;
  String? _error;

  /// The country board this account goes on: the phone's own region to
  /// begin with, which the lifter can change here.
  String? _country = backend.me?.country ?? deviceCountryCode();

  @override
  void _usernameEdited() => _error = null;

  bool get _canSave =>
      usernameValid(_username.text) && _available != false && !_busy;

  Future<void> _save() async {
    if (!_canSave) return;
    final l = L.of(context);
    final name = _username.text;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await backend.renameUsername(name);
      if (!mounted) return;
      switch (result) {
        case RenameResult.ok:
          demoProfile.username = name;
          await _saveCountry();
          if (mounted) Navigator.of(context).pop();
        case RenameResult.alreadyChanged:
          // A name was already chosen before the account was: that is the
          // name it keeps. The country is still this screen's to set.
          await _saveCountry();
          if (mounted) Navigator.of(context).pop();
        case RenameResult.taken:
          setState(() {
            _busy = false;
            _available = false;
          });
        case RenameResult.notAllowed:
          setState(() {
            _busy = false;
            _error = l.usernameNotAllowed;
          });
        case RenameResult.invalid:
          setState(() {
            _busy = false;
            _error = l.usernameInvalidLength;
          });
      }
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = l.cantReachServer;
      });
    }
  }

  /// The country, when it is not the one the account already has. A new
  /// account cannot be refused this, so a failure only leaves the phone's.
  Future<void> _saveCountry() async {
    final country = _country;
    if (country == null || country == backend.me?.country) return;
    try {
      if (await backend.setMyCountry(country) == CountryResult.ok) {
        demoProfile.country = country;
      }
    } on Object catch (error) {
      debugPrint('Could not save the country: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BackHeader(
                  title: l.chooseUsernameTitle,
                  subtitle: l.chooseUsernameSubtitle,
                  showBack: false,
                ),
                const SizedBox(height: 26),
                _usernameField(l),
                const SizedBox(height: 14),
                CountryField(
                  code: _country,
                  onChanged: (code) => setState(() => _country = code),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    style: context.type.label.copyWith(color: AppColors.loss),
                  ),
                ],
                const SizedBox(height: 22),
                FilledButton(
                  key: const Key('chooseUsernameContinue'),
                  onPressed: _canSave ? _save : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l.continueAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────── shared header ──────────────────────────────

/// The back button, the screen's own name, and what it is for — replacing an
/// [AppBar] so the name reads as the page's own heading rather than a small
/// title stamped into a bar above it.
class _BackHeader extends StatelessWidget {
  const _BackHeader({
    required this.title,
    required this.subtitle,
    this.showBack = true,
  });

  final String title;
  final String subtitle;

  /// False where there is nowhere to go back to.
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBack) InkWell(
          onTap: () => Navigator.of(context).pop(),
          customBorder: const CircleBorder(),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.surfaceRaised,
            ),
            child: Icon(Icons.arrow_back, size: 18, color: context.colors.text),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          title,
          style: context.type.title.copyWith(
            color: context.colors.text,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: context.type.body.copyWith(
            color: context.colors.text.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}
