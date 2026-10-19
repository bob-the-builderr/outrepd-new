/// The account gate at the end of onboarding: entry, sign up, log in, and
/// the code that confirms a sign up.
///
/// One gate rather than the mid-flow prompt this used to be, because an
/// account is no longer optional — nobody reaches a duel without one. Four
/// screens, and each ends the same way: pop with an [AuthOutcome], the same
/// signal [Career.adoptServerProfile] or a fresh [applyServerProfile] read
/// off of, all the way back to whoever opened [AuthEntryScreen].
library;

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../subscription.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../username_rules.dart';
import 'legal_line.dart';
import 'social_sign_in.dart';

/// What this whole gate finished with, popped back to whoever opened
/// [AuthEntryScreen]. Signing up keeps going with whatever was next —
/// placements, the first match. Signing in swapped this device for a
/// different, already-complete account, which has no more use for any of
/// that.
enum AuthOutcome { signedUp, signedIn }

const _kCodeLength = 6;

// ──────────────────────────────── entry ────────────────────────────────────

class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key});

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen>
    with _SocialSignIn {
  Future<void> _openSignUp() async {
    final outcome = await Navigator.of(context).push<AuthOutcome>(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
    if (outcome != null && mounted) Navigator.of(context).pop(outcome);
  }

  Future<void> _openLogin() async {
    final outcome = await Navigator.of(
      context,
    ).push<AuthOutcome>(MaterialPageRoute(builder: (_) => const LoginScreen()));
    if (outcome != null && mounted) Navigator.of(context).pop(outcome);
  }

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
              // The rank is the hero: a badge with its own glow, and what
              // the app is in two lines. Scaled down as a whole on a short
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
                            const _HeroBadge(size: 200),
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
              // Apple and Google first, the quickest way in; the email way
              // under them.
              _socialButtons(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _openSignUp,
                  child: Text(l.signUpWithEmail),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _openLogin,
                child: Text.rich(
                  TextSpan(
                    text: '${l.alreadyHaveAccountQuestion} ',
                    style: TextStyle(color: context.colors.muted, fontSize: 15),
                    children: [
                      TextSpan(
                        text: l.logInAction,
                        style: TextStyle(
                          color: context.colors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
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

// ─────────────────────────────── sign up ───────────────────────────────────

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

/// The username field and its live checks — red the moment the name is
/// wrong, and whether it is free once typing pauses — shared by the sign-up
/// screen and the one a new Apple or Google account names itself on.
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

class _SignUpScreenState extends State<SignUpScreen> with _UsernameChecks {
  final _email = TextEditingController();

  /// A friend's code, optional. See supabase/invites.sql.
  final _invite = TextEditingController();
  bool _busy = false;
  String? _error;

  /// The code went through: the week is on its way.
  bool _inviteClaimed = false;

  /// The invite field, opened from its line.
  bool _showInvite = false;

  @override
  void _usernameEdited() => _error = null;

  @override
  void dispose() {
    _email.dispose();
    _invite.dispose();
    super.dispose();
  }

  /// What a code that did not go through should say, or null when it did
  /// (or there was none). Asked before the email code goes out, so a typo
  /// is fixed on this screen rather than discovered behind the paywall.
  Future<String?> _claimInvite(L l) async {
    final code = _invite.text.trim();
    if (code.isEmpty || _inviteClaimed) return null;
    final result = await backend.claimInvite(code);
    switch (result) {
      case InviteResult.claimed || InviteResult.already:
        _inviteClaimed = true;
        // The server asked RevenueCat for the week; the store hears of it in
        // a few seconds, by when the paywall would otherwise be showing.
        unawaited(Subscription.instance.expectGrant());
        return null;
      case InviteResult.unknownCode:
        return l.inviteUnknownCode;
      case InviteResult.notYearly:
        return l.inviteNotYearly;
      case InviteResult.ownCode:
        return l.inviteOwnCode;
      case InviteResult.tooLate:
        return l.inviteTooLate;
      case InviteResult.full:
        return l.inviteFull;
      case InviteResult.offline:
        return l.cantReachServer;
    }
  }

  bool get _canSubmit =>
      usernameValid(_username.text) &&
      _available != false &&
      _email.text.trim().isNotEmpty &&
      !_busy;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final l = L.of(context);
    final username = _username.text;
    final email = _email.text.trim();

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      // A phone whose session did not start at launch — offline then, or
      // turned away by the server's hourly limit on new guests — has no
      // account to name or to give an email to, and the server answered the
      // name as if it were wrong. One more try, and a failure is reported as
      // the connection it is, not as the name.
      if (backend.available && backend.me == null) {
        await backend.signIn(username: username);
        if (!mounted) return;
      }

      // Claimed first, so the code only goes out once the name is known to
      // be free. The account is still a guest here, and a guest may rename
      // as often as it likes: coming back to this screen to fix the name, or
      // because the email was taken, renames again. The name becomes final
      // when the code is confirmed (set_my_username, account.sql).
      final renamed = await backend.renameUsername(username);
      if (!mounted) return;
      switch (renamed) {
        case RenameResult.taken:
          setState(() {
            _busy = false;
            _available = false;
          });
          return;
        case RenameResult.invalid:
          setState(() {
            _busy = false;
            _error = l.usernameInvalidLength;
          });
          return;
        case RenameResult.notAllowed:
          setState(() {
            _busy = false;
            _error = l.usernameNotAllowed;
          });
          return;
        case RenameResult.ok:
          demoProfile.username = username;
        case RenameResult.alreadyChanged:
        // Only an account with a confirmed email gets this, and one with a
        // confirmed email is not signing up. Not an error: it keeps its name.
      }

      final inviteError = await _claimInvite(l);
      if (!mounted) return;
      if (inviteError != null) {
        setState(() {
          _busy = false;
          _error = inviteError;
        });
        return;
      }
      setState(() {});

      final result = await backend.startEmailSignUp(email: email);
      if (!mounted) return;
      switch (result) {
        case EmailSignUpResult.ok:
          final outcome = await Navigator.of(context).push<AuthOutcome>(
            MaterialPageRoute(builder: (_) => VerifyCodeScreen(email: email)),
          );
          if (outcome != null && mounted) Navigator.of(context).pop(outcome);
          if (mounted) setState(() => _busy = false);
        case EmailSignUpResult.taken:
          setState(() {
            _busy = false;
            _error = l.emailTakenSwitchToSignIn;
          });
        case EmailSignUpResult.invalid:
          setState(() {
            _busy = false;
            _error = l.emailSignUpInvalid;
          });
        case EmailSignUpResult.rateLimited:
          setState(() {
            _busy = false;
            _error = l.tooManyCodes;
          });
        case EmailSignUpResult.offline:
          setState(() {
            _busy = false;
            _error = l.cantReachServer;
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

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BackHeader(
                      title: l.createYourAccountTitle,
                      subtitle: l.createAccountPitch,
                    ),
                    const SizedBox(height: 26),
                    _usernameField(l),
                    const SizedBox(height: 12),
                    _Field(
                      controller: _email,
                      icon: Icons.mail_outline,
                      hint: l.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => setState(() => _error = null),
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 12),
                    // Most people have no code: a line to open, not a third
                    // empty field to wonder about.
                    if (_showInvite || _invite.text.isNotEmpty)
                      _Field(
                        key: const Key('inviteCode'),
                        controller: _invite,
                        icon: Icons.card_giftcard_outlined,
                        hint: l.inviteCodeLabel,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() => _error = null),
                        onSubmitted: (_) => _submit(),
                      )
                    else
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton.icon(
                          key: const Key('showInviteCode'),
                          onPressed: () => setState(() => _showInvite = true),
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(l.haveInviteCode),
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.brand,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        ),
                      ),
                    if (_inviteClaimed) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              l.inviteClaimed,
                              style: context.type.label.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: context.type.label.copyWith(
                          color: AppColors.loss,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // The way on stays under the thumb, whatever is above it.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: _canSubmit ? _submit : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l.createAccountAction),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.emailCodeNote,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  LegalLine(
                    style: TextStyle(color: context.colors.faint, fontSize: 13),
                    linkStyle: TextStyle(color: context.colors.muted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────── log in ───────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with _SocialSignIn {
  final _email = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  bool get _canSubmit => _email.text.trim().isNotEmpty && !_busy;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final l = L.of(context);
    final email = _email.text.trim();

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final result = await backend.requestLoginCode(email);
      if (!mounted) return;
      switch (result) {
        case EmailLoginCodeResult.ok:
          final outcome = await Navigator.of(context).push<AuthOutcome>(
            MaterialPageRoute(
              builder: (_) => VerifyCodeScreen(email: email, forSignIn: true),
            ),
          );
          if (outcome != null && mounted) Navigator.of(context).pop(outcome);
          if (mounted) setState(() => _busy = false);
        case EmailLoginCodeResult.notFound:
          setState(() {
            _busy = false;
            _error = l.noAccountForEmail;
          });
        case EmailLoginCodeResult.rateLimited:
          setState(() {
            _busy = false;
            _error = l.tooManyCodes;
          });
        case EmailLoginCodeResult.offline:
          setState(() {
            _busy = false;
            _error = l.cantReachServer;
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

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BackHeader(title: l.obWelcomeBack, subtitle: l.logInSubtitle),
              const SizedBox(height: 26),
              if (socialSignInOffered) ...[
                _socialButtons(),
                const SizedBox(height: 14),
              ],
              _Field(
                controller: _email,
                icon: Icons.mail_outline,
                hint: l.emailHint,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() => _error = null),
                onSubmitted: (_) => _submit(),
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
                onPressed: _canSubmit ? _submit : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l.sendCodeAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────── verify ───────────────────────────────────

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({
    super.key,
    required this.email,
    this.forSignIn = false,
  });

  final String email;

  /// True from [LoginScreen]'s code, confirming a different account than
  /// whatever this device held before. False from [SignUpScreen]'s,
  /// confirming an email on the account this device already has.
  final bool forSignIn;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  /// One field behind the six boxes, not six fields. With six, a phone's
  /// keyboard sends nothing when delete is pressed in an empty box, so
  /// deleting stopped at every box and the lifter had to tap back into the
  /// one before it. One field deletes, types and pastes straight through,
  /// and the boxes only show what is in it.
  final _field = TextEditingController();
  final _focus = FocusNode();

  bool _busy = false;
  bool _wrong = false;
  Timer? _timer;
  int _secondsLeft = 60;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  String get _code => _field.text;

  void _onChanged(String value) {
    // Digits only, and no more than the code has — a paste of a whole line
    // from the email still leaves just the code.
    final clean = value.replaceAll(RegExp(r'\D'), '');
    final code = clean.length > _kCodeLength
        ? clean.substring(0, _kCodeLength)
        : clean;
    if (code != value) {
      _field.value = TextEditingValue(
        text: code,
        selection: TextSelection.collapsed(offset: code.length),
      );
    }
    setState(() => _wrong = false);
    if (code.length == _kCodeLength) _submit();
  }

  Future<void> _submit() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _wrong = false;
    });

    final l = L.of(context);
    try {
      final ok = widget.forSignIn
          ? await backend.verifyLoginCode(email: widget.email, code: _code)
          : await backend.verifyEmailCode(email: widget.email, code: _code);
      if (!mounted) return;
      if (ok) {
        if (widget.forSignIn) {
          // A different account than whatever this device held before —
          // its own local history is not this account's to show.
          await Career.instance.adoptServerProfile(backend.me!);
          if (!mounted) return;
          Navigator.of(context).pop(AuthOutcome.signedIn);
        } else {
          Navigator.of(context).pop(AuthOutcome.signedUp);
        }
        return;
      }
      setState(() {
        _busy = false;
        _wrong = true;
      });
    } on Object catch (_) {
      if (!mounted) return;
      // The code was never checked, so it is not marked wrong.
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.cantReachServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _resend() async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (widget.forSignIn) {
        final result = await backend.requestLoginCode(widget.email);
        if (result == EmailLoginCodeResult.offline) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l.cantReachServer),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      } else {
        await backend.resendEmailCode(widget.email);
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.codeResent),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on Object catch (_) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.cantReachServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    if (!mounted) return;
    _field.clear();
    setState(() => _wrong = false);
    _focus.requestFocus();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final minutes = (_secondsLeft ~/ 60).toString();
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BackHeader(
                title: l.checkYourEmailTitle,
                subtitle: l.codeSentTo(widget.email),
              ),
              const SizedBox(height: 26),
              // The six boxes draw what is in the one field underneath them;
              // tapping anywhere on them is tapping the field.
              Stack(
                children: [
                  ListenableBuilder(
                    listenable: Listenable.merge([_field, _focus]),
                    builder: (context, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < _kCodeLength; i++)
                          _CodeBox(
                            digit: i < _code.length ? _code[i] : '',
                            // The box the next digit goes into.
                            active: _focus.hasFocus &&
                                i == _code.length.clamp(0, _kCodeLength - 1),
                            error: _wrong,
                          ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0,
                      child: TextField(
                        key: const Key('codeField'),
                        controller: _field,
                        focusNode: _focus,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        showCursor: false,
                        maxLength: _kCodeLength,
                        onChanged: _onChanged,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_wrong) ...[
                const SizedBox(height: 14),
                Text(
                  l.wrongCode,
                  textAlign: TextAlign.center,
                  style: context.type.label.copyWith(color: AppColors.loss),
                ),
              ],
              if (_busy) ...[
                const SizedBox(height: 18),
                const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              Center(
                child: TextButton(
                  onPressed: _secondsLeft > 0 ? null : _resend,
                  child: Text.rich(
                    TextSpan(
                      text: '${l.didntGetIt} ',
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: _secondsLeft > 0
                              ? l.resendInSeconds('$minutes:$seconds')
                              : l.resendCode,
                          style: TextStyle(
                            color: _secondsLeft > 0
                                ? context.colors.faint
                                : context.colors.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l.wrongEmailGoBack,
                    style: TextStyle(color: context.colors.faint, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One of the six boxes: what the field under them holds at this place, drawn
/// the way the six separate fields used to look — the next box to fill ringed
/// in the brand colour, every box in red when the code was wrong.
class _CodeBox extends StatelessWidget {
  const _CodeBox({
    required this.digit,
    required this.active,
    required this.error,
  });

  final String digit;
  final bool active;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final Color border;
    if (error) {
      border = AppColors.loss;
    } else if (active) {
      border = context.colors.brand;
    } else {
      border = context.colors.border;
    }
    return Container(
      width: 44,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: active || error ? 1.5 : 1),
      ),
      child: Text(
        digit,
        style: TextStyle(
          color: error ? AppColors.loss : context.colors.text,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─────────────────────────────── shared field ───────────────────────────────

class _Field extends StatelessWidget {
  const _Field({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
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

  /// Shown above the field and stays there — unlike a hint, it does not
  /// disappear the moment somebody starts typing, so what the field is for
  /// is still on screen once it is full.
  final String? label;

  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label case final label?) ...[
          Text(
            label,
            style: context.type.label.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: inputFormatters == null,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
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

/// The entry screen's hero: the Master badge — the top of the ladder — its
/// glow rising behind it in its own shape: blurred, tinted copies of the
/// badge rather than a circle.
class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.size});

  final double size;

  static final _tier = kTiers.length - 1;

  @override
  Widget build(BuildContext context) {
    final colour = kTiers[_tier].color;
    Widget glow(double blur, double opacity) => ImageFiltered(
      // Decal, not clamp: clamping drew a faint disc around the crest.
      imageFilter: ui.ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
        tileMode: ui.TileMode.decal,
      ),
      child: Opacity(
        opacity: opacity,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(colour, BlendMode.srcATop),
          child: TierBadge(tierIndex: _tier, size: size),
        ),
      ),
    );
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          glow(30, 0.6),
          glow(12, 0.75),
          TierBadge(tierIndex: _tier, size: size),
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
        say(l.socialSignInFailed);
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
          Navigator.of(context).pop();
        case RenameResult.alreadyChanged:
          // A name was already chosen on the sign-up screen before Apple or
          // Google was: that is the name it keeps.
          Navigator.of(context).pop();
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
