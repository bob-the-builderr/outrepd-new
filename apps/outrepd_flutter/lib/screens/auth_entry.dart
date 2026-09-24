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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../type_scale.dart';
import 'shell.dart';

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

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  bool _busy = false;
  String? _error;
  StreamSubscription<void>? _sub;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _social(SocialProvider provider) async {
    if (_busy) return;
    final l = L.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });

    final done = Completer<bool>();
    await _sub?.cancel();
    _sub = backend.authStateChanges.listen((_) {
      if (backend.hasRealAccount && !done.isCompleted) done.complete(true);
    });

    try {
      final opened = await backend.linkSocial(provider);
      if (!opened) {
        if (mounted) {
          setState(() {
            _busy = false;
            _error = l.socialLinkFailed;
          });
        }
        return;
      }
      // [linkSocial]'s own return only confirms the browser opened — the
      // actual result comes later, off a deep link back into the app, which
      // is the only place [authStateChanges] has to report it from.
      final linked = await done.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () => false,
      );
      if (!mounted) return;
      if (linked) {
        Navigator.of(context).pop(AuthOutcome.signedUp);
      } else {
        setState(() {
          _busy = false;
          _error = l.socialLinkFailed;
        });
      }
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = l.socialLinkFailed;
      });
    } finally {
      await _sub?.cancel();
      _sub = null;
    }
  }

  Future<void> _openSignUp() async {
    final outcome = await Navigator.of(
      context,
    ).push<AuthOutcome>(MaterialPageRoute(builder: (_) => const SignUpScreen()));
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
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logo-wordmark.png',
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l.authEntryTagline,
                        textAlign: TextAlign.center,
                        style: context.type.heading.copyWith(
                          color: context.colors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_error != null) ...[
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: context.type.label.copyWith(color: AppColors.loss),
                ),
                const SizedBox(height: 12),
              ],
              _SocialButton(
                icon: Icons.apple,
                label: l.obContinueApple,
                filled: true,
                busy: _busy,
                onTap: () => _social(SocialProvider.apple),
              ),
              const SizedBox(height: 10),
              _SocialButton(
                icon: Icons.g_mobiledata,
                label: l.obContinueGoogle,
                busy: _busy,
                onTap: () => _social(SocialProvider.google),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: Divider(color: context.colors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      l.orDivider,
                      style: TextStyle(color: context.colors.faint, fontSize: 12),
                    ),
                  ),
                  Expanded(child: Divider(color: context.colors.border)),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _busy ? null : _openSignUp,
                  child: Text(l.signUpWithEmail),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _busy ? null : _openLogin,
                child: Text.rich(
                  TextSpan(
                    text: '${l.alreadyHaveAccountQuestion} ',
                    style: TextStyle(color: context.colors.muted, fontSize: 13),
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
              Text.rich(
                TextSpan(
                  style: TextStyle(color: context.colors.faint, fontSize: 11),
                  children: [
                    TextSpan(text: '${l.obTermsIntro} '),
                    TextSpan(
                      text: l.obTerms,
                      style: TextStyle(color: context.colors.muted),
                    ),
                    TextSpan(text: ' ${l.obAnd} '),
                    TextSpan(
                      text: l.obPrivacy,
                      style: TextStyle(color: context.colors.muted),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.busy,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final bool busy;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: busy ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: filled ? context.colors.brand : null,
          border: filled
              ? null
              : Border.all(color: context.colors.border, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: filled ? context.colors.background : context.colors.text,
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: filled
                      ? context.colors.background
                      : context.colors.text,
                  fontSize: 14,
                  fontWeight: filled ? FontWeight.w600 : null,
                ),
              ),
            ),
          ],
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

class _SignUpScreenState extends State<SignUpScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _username.text.trim().length >= 4 &&
      _email.text.trim().isNotEmpty &&
      _password.text.length >= 8 &&
      !_busy;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final l = L.of(context);
    final username = _username.text.trim();
    final email = _email.text.trim();
    final password = _password.text;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      // Claimed first: the account this session already has has never
      // renamed before, so this is that one free rename, spent on the name
      // just typed rather than left for later.
      final renamed = await backend.renameUsername(username);
      if (!mounted) return;
      switch (renamed) {
        case RenameResult.taken:
          setState(() {
            _busy = false;
            _error = l.usernameTaken;
          });
          return;
        case RenameResult.invalid:
          setState(() {
            _busy = false;
            _error = l.usernameInvalidLength;
          });
          return;
        case RenameResult.ok:
          demoProfile.username = username;
        case RenameResult.alreadyChanged:
        // Not an error here — the name is already whatever it was, and the
        // account is still this session's own.
      }

      final result = await backend.startEmailSignUp(
        email: email,
        password: password,
      );
      if (!mounted) return;
      switch (result) {
        case EmailSignUpResult.ok:
          final outcome = await Navigator.of(context).push<AuthOutcome>(
            MaterialPageRoute(
              builder: (_) => VerifyCodeScreen(email: email),
            ),
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
      }
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = l.needsServer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l.createYourAccountTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.createAccountSubtitle,
                style: context.type.body.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: 22),
              _Field(
                controller: _username,
                hint: l.usernameHint,
                onChanged: (_) => setState(() => _error = null),
              ),
              const SizedBox(height: 12),
              _Field(
                controller: _email,
                hint: l.emailHint,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() => _error = null),
              ),
              const SizedBox(height: 12),
              _Field(
                controller: _password,
                hint: l.passwordHint,
                obscure: _obscure,
                onToggleObscure: () => setState(() => _obscure = !_obscure),
                onChanged: (_) => setState(() => _error = null),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 7),
              Text(
                l.passwordMinLength,
                style: TextStyle(color: context.colors.faint, fontSize: 11),
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
                    : Text(l.createAccountAction),
              ),
              const SizedBox(height: 14),
              Text.rich(
                TextSpan(
                  style: TextStyle(color: context.colors.faint, fontSize: 11),
                  children: [
                    TextSpan(text: '${l.obTermsIntro} '),
                    TextSpan(
                      text: l.obTerms,
                      style: TextStyle(color: context.colors.muted),
                    ),
                    TextSpan(text: ' ${l.obAnd} '),
                    TextSpan(
                      text: l.obPrivacy,
                      style: TextStyle(color: context.colors.muted),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _error;
  String? _resetSentTo;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _email.text.trim().isNotEmpty && _password.text.isNotEmpty && !_busy;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final l = L.of(context);

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final result = await backend.signInWithEmail(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      switch (result) {
        case EmailSignInResult.ok:
          // A different account than whatever this device held before —
          // its own local history is not this account's to show.
          await Career.instance.adoptServerProfile(backend.me!);
          if (!mounted) return;
          Navigator.of(context).pop(AuthOutcome.signedIn);
        case EmailSignInResult.wrongCredentials:
          setState(() {
            _busy = false;
            _error = l.wrongEmailOrPassword;
          });
      }
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = l.needsServer;
      });
    }
  }

  Future<void> _forgotPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty) return;
    final l = L.of(context);
    try {
      await backend.requestPasswordReset(email);
    } on Object catch (_) {
      // Answered the same either way — see [resetSentTo]'s note below.
    }
    if (!mounted) return;
    setState(() => _resetSentTo = email);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.resetPasswordSent(email)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l.obWelcomeBack)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.logInSubtitle,
                style: context.type.body.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: 22),
              _Field(
                controller: _email,
                hint: l.emailHint,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {
                  _error = null;
                  _resetSentTo = null;
                }),
              ),
              const SizedBox(height: 12),
              _Field(
                controller: _password,
                hint: l.passwordHint,
                obscure: _obscure,
                onToggleObscure: () => setState(() => _obscure = !_obscure),
                onChanged: (_) => setState(() => _error = null),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: _email.text.trim().isEmpty ? null : _forgotPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    l.forgotPassword,
                    style: TextStyle(color: context.colors.muted, fontSize: 12),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 4),
                Text(
                  _error!,
                  style: context.type.label.copyWith(color: AppColors.loss),
                ),
              ],
              if (_resetSentTo != null) ...[
                const SizedBox(height: 4),
                Text(
                  l.resetPasswordSent(_resetSentTo!),
                  style: context.type.label.copyWith(color: context.colors.muted),
                ),
              ],
              const SizedBox(height: 18),
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
                    : Text(l.logInAction),
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
  const VerifyCodeScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _digits = List<String>.filled(_kCodeLength, '');
  final _controllers = List.generate(_kCodeLength, (_) => TextEditingController());
  final _nodes = List.generate(_kCodeLength, (_) => FocusNode());

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
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
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

  String get _code => _digits.join();

  void _onDigit(int index, String value) {
    // A paste can land the whole code in one field — spread it across the
    // rest rather than reject it as too long for a single box.
    final clean = value.replaceAll(RegExp(r'\D'), '');
    if (clean.length > 1) {
      for (var i = 0; i < clean.length && index + i < _kCodeLength; i++) {
        _digits[index + i] = clean[i];
        _controllers[index + i].text = clean[i];
      }
      final next = (index + clean.length).clamp(0, _kCodeLength - 1);
      _nodes[next].requestFocus();
      setState(() => _wrong = false);
      if (_code.length == _kCodeLength) _submit();
      return;
    }

    setState(() {
      _digits[index] = clean;
      _wrong = false;
    });
    if (clean.isNotEmpty && index < _kCodeLength - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (_code.length == _kCodeLength) _submit();
  }

  void _onBackspace(int index) {
    if (_digits[index].isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      setState(() => _digits[index - 1] = '');
    }
  }

  Future<void> _submit() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _wrong = false;
    });

    final l = L.of(context);
    try {
      final ok = await backend.verifyEmailCode(email: widget.email, code: _code);
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pop(AuthOutcome.signedUp);
        return;
      }
      setState(() {
        _busy = false;
        _wrong = true;
      });
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _wrong = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _resend() async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await backend.resendEmailCode(widget.email);
      messenger.showSnackBar(
        SnackBar(content: Text(l.codeResent), behavior: SnackBarBehavior.floating),
      );
    } on Object catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.needsServer), behavior: SnackBarBehavior.floating),
      );
    }
    if (!mounted) return;
    for (var i = 0; i < _kCodeLength; i++) {
      _controllers[i].clear();
      _digits[i] = '';
    }
    setState(() => _wrong = false);
    _nodes[0].requestFocus();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final minutes = (_secondsLeft ~/ 60).toString();
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l.checkYourEmailTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.codeSentTo(widget.email),
                style: context.type.body.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < _kCodeLength; i++)
                    _CodeBox(
                      controller: _controllers[i],
                      focusNode: _nodes[i],
                      error: _wrong,
                      onChanged: (v) => _onDigit(i, v),
                      onBackspace: () => _onBackspace(i),
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
                      style: TextStyle(color: context.colors.muted, fontSize: 13),
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
                    style: TextStyle(color: context.colors.faint, fontSize: 12),
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

class _CodeBox extends StatelessWidget {
  const _CodeBox({
    required this.controller,
    required this.focusNode,
    required this.error,
    required this.onChanged,
    required this.onBackspace,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool error;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final borderColor = error ? AppColors.loss : context.colors.border;
    return SizedBox(
      width: 44,
      height: 54,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true, canRequestFocus: false),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty) {
            onBackspace();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: _kCodeLength,
          onChanged: onChanged,
          style: TextStyle(
            color: error ? AppColors.loss : context.colors.text,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          cursorColor: context.colors.brand,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: context.colors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error ? AppColors.loss : context.colors.brand,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────── password recovery ─────────────────────────────

/// Where a password-reset email's link lands once the app exchanges it for
/// a session — pushed by the global listener in `main.dart` on
/// [Backend.passwordRecoveryRequested], not by anything on screen, since
/// the link can be tapped from anywhere the app happens to be.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  bool get _canSubmit => _password.text.length >= 8 && !_busy;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final l = L.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await backend.setNewPassword(_password.text);
      // The recovery link's own session may belong to a different account
      // than whatever this device held before — same as any other sign in.
      await Career.instance.adoptServerProfile(backend.me!);
      await markOnboarded();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AppShell()),
        (route) => false,
      );
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = l.needsServer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l.resetPasswordTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.resetPasswordBody,
                style: context.type.body.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: 22),
              _Field(
                controller: _password,
                hint: l.passwordHint,
                obscure: _obscure,
                onToggleObscure: () => setState(() => _obscure = !_obscure),
                onChanged: (_) => setState(() => _error = null),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 7),
              Text(
                l.passwordMinLength,
                style: TextStyle(color: context.colors.faint, fontSize: 11),
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
                    : Text(l.setPasswordAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────── shared field ───────────────────────────────

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      autocorrect: false,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: TextStyle(color: context.colors.text, fontSize: 16),
      cursorColor: context.colors.brand,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.colors.faint, fontSize: 16),
        filled: true,
        fillColor: context.colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: context.colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: context.colors.brand),
        ),
        suffixIcon: onToggleObscure == null
            ? null
            : TextButton(
                onPressed: onToggleObscure,
                child: Text(
                  obscure ? L.of(context).showLabel : L.of(context).hideLabel,
                  style: TextStyle(color: context.colors.muted, fontSize: 12),
                ),
              ),
      ),
    );
  }
}
