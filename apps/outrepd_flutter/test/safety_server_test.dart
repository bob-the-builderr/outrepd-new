/// Blocking, reporting, and the preferences that are supposed to be settings
/// rather than decoration.
///
/// Every one of these is a promise the settings screen makes on the server's
/// behalf. A toggle that the database ignores is worse than no toggle: the
/// person believes they are hidden, or unreachable, or left alone, and they
/// are not.
///
///   flutter test test/safety_server_test.dart \
///     --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
library;

import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'server_harness.dart';

void main() {
  final tag = Random().nextInt(0xFFFFF).toRadixString(16);
  String name(String who) => 't_b$who$tag';

  test(
    'a block hides them both ways, and tells them nothing',
    () async {
      if (!serverConfigured) {
        // ignore: avoid_print
        print('no server configured — skipping');
        return;
      }

      final me = await Lifter.signUp(name('a'));
      final them = await Lifter.signUp(name('b'));

      // Findable to begin with, both ways.
      expect(
        (await me.findLifters(
          them.username,
        )).map((r) => (r as Map)['username']),
        contains(them.username),
      );

      expect(await me.block(them.id), 'blocked');

      // Gone from my search, and I am gone from theirs — a block that only
      // works from one side is not a block.
      expect(await me.findLifters(them.username), isEmpty);
      expect(await them.findLifters(me.username), isEmpty);

      // And the same answer as a name that never existed. Saying "you are
      // blocked" is the one thing this must not do.
      expect(await them.askFriend(me.username), 'no such lifter');

      // They cannot see the row either. Only the blocker's list holds it.
      expect(await me.rawBlocks(), hasLength(1));
      expect(await them.rawBlocks(), isEmpty);

      final mine = await me.blocks();
      expect(mine, hasLength(1));
      expect((mine.first as Map)['username'], them.username);

      // Undone by the person who did it.
      expect(await me.unblock(them.id), 'unblocked');
      expect(
        (await me.findLifters(
          them.username,
        )).map((r) => (r as Map)['username']),
        contains(them.username),
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test('blocking ends the friendship', () async {
    if (!serverConfigured) return;

    final me = await Lifter.signUp(name('c'));
    final them = await Lifter.signUp(name('d'));

    await me.askFriend(them.username);
    await them.answerFriend(me.id, accept: true);
    expect(await me.friends(), hasLength(1));
    expect(await them.friends(), hasLength(1));

    await me.block(them.id);

    // Both lists, not just mine. Leaving them holding a friendship with
    // somebody who has blocked them is a state nothing could draw honestly.
    expect(await me.friends(), isEmpty);
    expect(await them.friends(), isEmpty);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test(
    'a blocked account is never handed over as an opponent',
    () async {
      if (!serverConfigured) return;

      final me = await Lifter.signUp(name('e'));
      final them = await Lifter.signUp(name('f'));

      await them.uploadSet(reps: 14);
      await me.uploadSet(reps: 20);

      // Whether the matchmaker handed over *this* account's set. The pool
      // holds unclaimed sets left by every other test in the run, so "was
      // anything offered" answers a different question than this one.
      Future<bool> offered(Lifter to, Lifter about) async =>
          (await to.findOpponent())?['username'] == about.username;

      await me.block(them.id);

      expect(
        await offered(me, them),
        isFalse,
        reason: 'the matchmaker handed over a blocked account',
      );

      // And from their side too: a block has to hold whichever of the two is
      // holding the phone. This is the half that was broken in `find_lifters`
      // until the function was allowed to see the row it enforces.
      expect(
        await offered(them, me),
        isFalse,
        reason: 'the block only held for the person who made it',
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    '"who can challenge me" decides who gets the set',
    () async {
      if (!serverConfigured) return;

      final quiet = await Lifter.signUp(name('g'));
      final stranger = await Lifter.signUp(name('h'));
      final mate = await Lifter.signUp(name('i'));

      await quiet.uploadSet(reps: 16);

      // Whether *this* account's set was the one handed over. Not "was
      // anything handed over": `find_opponent_set` returns the single oldest
      // unclaimed set, and the pool holds leftovers from every other test in
      // the run, so somebody else's turning up proves nothing either way.
      //
      // That also means only the refusals can be asserted here. The other
      // direction — a set that *is* offered when it should be — is what every
      // matchmaking test in duel_server_test.dart already does, on a pair with
      // no preferences set.
      Future<bool> offeredTo(Lifter who) async =>
          (await who.findOpponent())?['username'] == quiet.username;

      // Nobody: the set exists and is handed to no one.
      await quiet.setPreference({'challengeable': 'nobody'});
      expect(
        await offeredTo(stranger),
        isFalse,
        reason: '"nobody" still handed the set out',
      );
      expect(await offeredTo(mate), isFalse);

      // Friends only: a stranger is still refused, friend or not.
      await quiet.setPreference({'challengeable': 'friends'});
      await quiet.askFriend(mate.username);
      await mate.answerFriend(quiet.id, accept: true);

      expect(
        await offeredTo(stranger),
        isFalse,
        reason: 'friends-only handed the set to a stranger',
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'asking to be off the board takes you off it',
    () async {
      if (!serverConfigured) return;

      final shy = await Lifter.signUp(name('j'));
      final other = await Lifter.signUp(name('k'));

      for (var i = 0; i < 5; i++) {
        await shy.duel(other, mine: 22, theirs: 8);
      }
      expect((await shy.profile())['placements_done'], 5);

      expect(
        (await other.board()).map((r) => (r as Map)['username']),
        contains(shy.username),
      );
      expect(await shy.boardPosition(), isNotNull);

      await shy.setPreference({'show_on_board': false});

      // Off the list everybody else sees, and with no position of their own —
      // the two have to agree, or the profile claims a place on a board the
      // person is not on.
      expect(
        (await other.board()).map((r) => (r as Map)['username']),
        isNot(contains(shy.username)),
        reason: 'somebody who asked to be hidden was still on the board',
      );
      expect(await shy.boardPosition(), isNull);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'a notification nobody wants is never written',
    () async {
      if (!serverConfigured) return;

      final quiet = await Lifter.signUp(name('l'));
      final asker = await Lifter.signUp(name('m'));

      await quiet.setPreference({'notify_friend_request': false});
      await asker.askFriend(quiet.username);

      // Not hidden — never stored. "Off" that still writes the row is a
      // promise kept on the screen and broken in the database.
      expect(await quiet.notices(), isEmpty);
      expect(await quiet.unreadNotices(), 0);

      // The request itself still arrived; only the telling was declined.
      expect(await quiet.requests(), hasLength(1));
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test('a report is write-only', () async {
    if (!serverConfigured) return;

    final me = await Lifter.signUp(name('n'));
    final them = await Lifter.signUp(name('o'));

    await me.report(them.id, 'cheating', details: 'counted reps that were not');

    // Filing one does not entitle anybody to read the pile, including their
    // own row.
    await expectLater(
      getList('/rest/v1/reports?select=*', me.token),
      completion(isEmpty),
    );

    // And a reason outside the list is refused rather than stored as junk.
    await expectLater(
      me.report(them.id, 'whatever'),
      throwsA(isA<HttpException>()),
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  test(
    'my data is mine, and holds no pose landmarks',
    () async {
      if (!serverConfigured) return;

      final me = await Lifter.signUp(name('p'));
      final them = await Lifter.signUp(name('q'));
      await me.uploadSet(reps: 19, repTimes: [1000, 2500, 4000]);
      await me.askFriend(them.username);

      final data = await me.myData();
      expect(data['profile'], isNotNull);
      expect((data['sets'] as List), hasLength(1));
      expect(((data['sets'] as List).first as Map)['reps'], 19);
      expect(data['exported_at'], isNotNull);

      // The claim the screen makes in writing: pose landmarks never reach the
      // server, so there is nothing of them to hand back.
      expect(
        data.toString().toLowerCase().contains('landmark'),
        isFalse,
        reason:
            'the export mentions landmarks, which are meant never to leave '
            'the phone',
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
