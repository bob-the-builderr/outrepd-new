/// Renaming yourself, against the real server.
///
/// `set_my_username` is the one function on this account a lifter calls by
/// hand rather than through a match, so it is the one place a validation
/// rule that only exists in the Dart layer would be a rule a direct RPC call
/// could simply skip. This asks the database itself.
///
///   flutter test test/account_server_test.dart \
///     --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
library;

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'server_harness.dart';

void main() {
  final configured = serverConfigured;
  final tag = Random().nextInt(0xFFFFF).toRadixString(16);

  test('a valid new name is taken, and cannot be spent twice', () async {
    if (!configured) {
      // ignore: avoid_print
      print('no server configured — skipping');
      return;
    }

    final a = await Lifter.signUp('t_ra$tag');
    expect(await a.usernameAvailable('brandnew$tag'), isTrue);

    expect(await a.renameUsername('brandnew$tag'), 'ok');
    expect((await a.profile())['username'], 'brandnew$tag');

    // The one every account gets was just spent.
    expect(
      await a.renameUsername('anothername$tag'),
      'already_changed',
      reason: 'a second rename was allowed through',
    );
    expect(
      (await a.profile())['username'],
      'brandnew$tag',
      reason: 'a refused rename still changed the name',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('under four characters is invalid', () async {
    if (!configured) return;
    final a = await Lifter.signUp('t_rb$tag');
    expect(await a.renameUsername('abc'), 'invalid');
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a symbol or space is invalid', () async {
    if (!configured) return;
    final a = await Lifter.signUp('t_rc$tag');
    expect(await a.renameUsername('bad name!'), 'invalid');
    expect(await a.renameUsername('bad_name'), 'invalid');
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('somebody else already has it', () async {
    if (!configured) return;
    final a = await Lifter.signUp('t_rd$tag');
    final b = await Lifter.signUp('t_re$tag');

    final theirName = 'taken$tag';
    expect(await b.renameUsername(theirName), 'ok');

    expect(await a.usernameAvailable(theirName), isFalse);
    // Case-insensitive: "Taken" and "taken" are the same account to this
    // system, whatever a client capitalised.
    expect(await a.usernameAvailable(theirName.toUpperCase()), isFalse);
    expect(
      await a.renameUsername(theirName.toUpperCase()),
      'taken',
      reason: 'a case-only difference was accepted as a new name',
    );

    // The rejected attempt did not cost the account its one rename.
    expect(await a.renameUsername('freename$tag'), 'ok');
  }, timeout: const Timeout(Duration(minutes: 5)));
}
