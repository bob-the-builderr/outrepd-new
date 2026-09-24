/// Friends and the board, against the real server.
///
/// `social.sql` was written without a Postgres to try it on, like everything
/// else in `supabase/`. These are the questions only the live database can
/// answer: does a request actually reach the person it was sent to, can they
/// answer it, and — the one that matters most — can anybody see a friendship
/// they are not part of?
///
///   flutter test test/social_server_test.dart \
///     --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
library;

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'server_harness.dart';

void main() {
  final tag = Random().nextInt(0xFFFFF).toRadixString(16);

  /// The names in one test, kept apart from every other test's.
  String name(String who) => 't_s$who$tag';

  test(
    'a request is sent, seen, and accepted',
    () async {
      if (!serverConfigured) {
        // ignore: avoid_print
        print('no server configured — skipping');
        return;
      }

      final a = await Lifter.signUp(name('a'));
      final b = await Lifter.signUp(name('b'));

      expect(await a.askFriend(b.username), 'asked');

      // It is waiting on B, and on nobody else. A asking does not put a
      // request in A's own list.
      expect(await a.requests(), isEmpty);
      final waiting = await b.requests();
      expect(waiting, hasLength(1));
      expect((waiting.first as Map)['username'], a.username);
      expect((waiting.first as Map)['id'], a.id);

      // Not friends until it is answered.
      expect(await a.friends(), isEmpty);
      expect(await b.friends(), isEmpty);

      expect(await b.answerFriend(a.id, accept: true), 'friends');

      // And now both ends see it, which is the whole reason a friendship is
      // one row read from both sides rather than two rows kept in step.
      final aFriends = await a.friends();
      final bFriends = await b.friends();
      expect(aFriends, hasLength(1));
      expect(bFriends, hasLength(1));
      expect((aFriends.first as Map)['username'], b.username);
      expect((bFriends.first as Map)['username'], a.username);
      expect(await b.requests(), isEmpty);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'asking back is the same as saying yes',
    () async {
      if (!serverConfigured) return;

      final a = await Lifter.signUp(name('c'));
      final b = await Lifter.signUp(name('d'));

      expect(await a.askFriend(b.username), 'asked');
      // B never opens the requests screen — they just ask A the same thing.
      // Making them go and agree to what they have already asked for would be
      // the app being pedantic at somebody.
      expect(await b.askFriend(a.username), 'friends');

      expect(await a.friends(), hasLength(1));
      expect(await b.friends(), hasLength(1));
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'declining forgets it, so they can ask again',
    () async {
      if (!serverConfigured) return;

      final a = await Lifter.signUp(name('e'));
      final b = await Lifter.signUp(name('f'));

      await a.askFriend(b.username);
      expect(await b.answerFriend(a.id, accept: false), 'declined');
      expect(await b.requests(), isEmpty);
      expect(await a.friends(), isEmpty);

      // A declined request that lingered would be a small rejection kept on a
      // server forever, and it would also stop them ever asking again.
      expect(await a.askFriend(b.username), 'asked');
      expect(await b.requests(), hasLength(1));
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'nobody can read a friendship they are not in',
    () async {
      if (!serverConfigured) return;

      final a = await Lifter.signUp(name('g'));
      final b = await Lifter.signUp(name('h'));
      final nosy = await Lifter.signUp(name('i'));

      await a.askFriend(b.username);
      await b.answerFriend(a.id, accept: true);

      // Both ends of the row see exactly one. A stranger sees none — a friends
      // list is not public, and who asked whom is less so.
      expect(await a.rawFriendships(), hasLength(1));
      expect(await b.rawFriendships(), hasLength(1));
      expect(await nosy.rawFriendships(), isEmpty);
      expect(await nosy.friends(), isEmpty);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'a friend row carries the head-to-head',
    () async {
      if (!serverConfigured) return;

      final a = await Lifter.signUp(name('j'));
      final b = await Lifter.signUp(name('k'));

      await a.askFriend(b.username);
      await b.answerFriend(a.id, accept: true);

      // Two duels, decided by the reps: A takes the first, B the second.
      expect(await a.duel(b, mine: 30, theirs: 10), isTrue);
      expect(await a.duel(b, mine: 5, theirs: 25), isFalse);

      final fromA = (await a.friends()).first as Map;
      final fromB = (await b.friends()).first as Map;

      // The same two duels, read from both ends, have to mirror — the row is
      // the reason anybody taps it, and it would be worse than useless if the
      // two people disagreed about what happened between them.
      expect(fromA['wins_vs_you'], 1, reason: 'B beat A once');
      expect(fromA['losses_vs_you'], 1, reason: 'A beat B once');
      expect(fromB['wins_vs_you'], fromA['losses_vs_you']);
      expect(fromB['losses_vs_you'], fromA['wins_vs_you']);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'a search needs something to go on',
    () async {
      if (!serverConfigured) return;

      final a = await Lifter.signUp(name('l'));
      final b = await Lifter.signUp(name('m'));

      // Found by the start of the name.
      final found = await a.findLifters(b.username);
      expect(found.map((r) => (r as Map)['username']), contains(b.username));

      // One character is not a search, it is a request for the userbase.
      expect(await a.findLifters('t'), isEmpty);
      expect(await a.findLifters(''), isEmpty);

      // And it never hands back the caller themselves, who is not somebody
      // they can add.
      final self = await a.findLifters(a.username);
      expect(
        self.map((r) => (r as Map)['username']),
        isNot(contains(a.username)),
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'asking for somebody who is not there says so',
    () async {
      if (!serverConfigured) return;

      final a = await Lifter.signUp(name('n'));
      expect(await a.askFriend('nobody_$tag'), 'no such lifter');
      expect(await a.askFriend(a.username), 'that is you');
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'the board shows placed accounts and hides the rest',
    () async {
      if (!serverConfigured) return;

      final a = await Lifter.signUp(name('o'));
      final b = await Lifter.signUp(name('p'));

      Future<List<dynamic>> board() => a.board();

      final before = await board();
      expect(
        before.map((r) => (r as Map)['username']),
        isNot(contains(a.username)),
        reason: 'an account still in placements was on the board',
      );

      // Five duels puts A on the ladder for real.
      for (var i = 0; i < 5; i++) {
        await a.duel(b, mine: 20, theirs: 10);
      }
      expect((await a.profile())['placements_done'], 5);

      final after = await board();
      expect(
        after.map((r) => (r as Map)['username']),
        contains(a.username),
        reason: 'a placed account was missing from the board',
      );

      // Best first, which is what makes it a board rather than a list.
      final rungs = [
        for (final row in after)
          (row as Map)['tier_idx'] * 5 +
              (row['div_idx'] as int) * 1 +
              (row['lp'] as int) / 100,
      ];
      final sorted = [...rungs]..sort((x, y) => (y as num).compareTo(x as num));
      expect(rungs, sorted, reason: 'the board came back out of order');
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'a board position is the row somebody is actually standing on',
    () async {
      if (!serverConfigured) return;

      final a = await Lifter.signUp(name('q'));
      final b = await Lifter.signUp(name('r'));

      // Not on the board, so there is no place on it. The profile screen
      // shows a dash here rather than a number it made up.
      expect((await a.profile())['placements_done'], 0);

      // Five wins for A, which is also five losses for B, so both are placed
      // and A is above B.
      for (var i = 0; i < 5; i++) {
        expect(await a.duel(b, mine: 25, theirs: 6), isTrue);
      }

      final placedA = await a.profile();
      final placedB = await b.profile();
      expect(placedA['placements_done'], 5);
      expect(placedB['placements_done'], 5);

      final placeA = await a.boardPosition();
      final placeB = await b.boardPosition();
      expect(placeA, isNotNull);
      expect(placeB, isNotNull);

      // The filter's whole job: "above me" has to mean the same thing as the
      // order the board is drawn in. A beat B five times out of five, so A
      // cannot be below B on it.
      expect(placeA!, lessThan(placeB!), reason: 'the winner ranked lower');
      expect(placeA, greaterThanOrEqualTo(1));

      // And it has to agree with the board itself. Counting the rows above
      // somebody is only a shortcut for finding them in the list — if the two
      // ever disagree, the number on the profile is not the row on the board.
      final board = await a.board();
      final byList = board.indexWhere((r) => (r as Map)['id'] == a.id) + 1;
      expect(
        placeA,
        byList,
        reason: 'the counted position and the drawn board disagree',
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
