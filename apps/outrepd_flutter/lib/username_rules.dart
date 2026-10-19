/// How a username is typed — on the sign-up screen and in the rename sheet
/// alike. The server's own rule (set_my_username, supabase/account.sql),
/// checked as each letter lands, so a wrong name is red before anything is
/// sent rather than refused after.
library;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';

const kUsernameMin = 4;
const kUsernameMax = 20;

/// How long a chosen name is kept before it can change again. The server
/// holds the same fourteen days.
const kUsernameKeptFor = Duration(days: 14);

/// Spaces become underscores as they are typed — "iron mike" is iron_mike,
/// the way a handle is written, without anybody having to know to type it —
/// and the field stops at the longest name the server takes.
final List<TextInputFormatter> usernameFormatters = [
  const _SpacesToUnderscores(),
  LengthLimitingTextInputFormatter(kUsernameMax),
];

class _SpacesToUnderscores extends TextInputFormatter {
  const _SpacesToUnderscores();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.text.contains(' ')) return newValue;
    // Same length either way, so the cursor stays where it was.
    return newValue.copyWith(text: newValue.text.replaceAll(' ', '_'));
  }
}

final _allowed = RegExp(r'^[A-Za-z0-9_]+$');
final _letterOrNumber = RegExp(r'[A-Za-z0-9]');

/// What is wrong with [name] as it stands, in words for the lifter, or null
/// when nothing is. An empty field is not wrong yet: nobody has typed.
String? usernameProblem(L l, String name) {
  if (name.isEmpty) return null;
  if (!_allowed.hasMatch(name)) return l.usernameBadCharacters;
  if (name.length < kUsernameMin) return l.usernameTooShort;
  if (!_letterOrNumber.hasMatch(name)) return l.usernameNeedsLetter;
  return null;
}

/// Whether the server will take [name] as written.
bool usernameValid(String name) =>
    _allowed.hasMatch(name) &&
    name.length >= kUsernameMin &&
    name.length <= kUsernameMax &&
    _letterOrNumber.hasMatch(name);

/// When a name chosen at [changedAt] may change again, or null when it may
/// now.
DateTime? usernameNextChange(DateTime? changedAt, {DateTime? now}) {
  if (changedAt == null) return null;
  final next = changedAt.add(kUsernameKeptFor);
  return next.isAfter(now ?? DateTime.now()) ? next : null;
}

/// "You can change it again on 2 Nov 2026", in the lifter's language.
String usernameChangeAgainText(L l, DateTime next) =>
    l.usernameChangeAgainOn(DateFormat.yMMMd(l.localeName).format(next.toLocal()));
