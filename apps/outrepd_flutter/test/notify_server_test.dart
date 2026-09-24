/// Being told what happened while you were away.
///
/// These are trigger-driven, which means nothing in Dart can check them: the
/// rows appear as a side effect of somebody *else's* call, in a database this
/// machine cannot run. The question each test asks is the same one — did the
/// person who was not there find out?
///
///   flutter test test/notify_server_test.dart \
///     --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
library;

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'server_harness.dart';

void main() {
  final tag = Random().nextInt(0xFFFFF).toRadixString(16);
  String name(String who) => 't_n$who$tag';

  test('the lifter who was raced finds out', () async {
    if (!serverConfigured) {
      // ignore: avoid_print
      print('no server configured — skipping');
      return;
    }

    final racer = await Lifter.signUp(name('a'));
    final away = await Lifter.signUp(name('b'));

    // The whole point of an async duel: `away` uploads a minute and goes.
    final theirSet = await away.uploadSet(reps: 12);
    final mySet = await racer.uploadSet(reps: 30);
    expect(await away.notices(), isEmpty);

    await racer.settle(mySet, theirSet);

    // The racer was there and watched it. Nothing to tell them.
    expect(
      await racer.notices(),
      isEmpty,
      reason: 'the challenger was notified about their own duel',
    );

    final told = await away.notices();
    expect(told, hasLength(1), reason: 'the defender was never told');

    final notice = told.first as Map;
    expect(notice['kind'], 'raced');
    expect(notice['actor_name'], racer.username);
    expect(notice['unread'], isTrue);

    // Both counts, the right way round. A result with no score is a rumour,
    // and a score with the numbers swapped is worse than one.
    expect(notice['you_won'], isFalse, reason: '12 does not beat 30');
    expect(notice['your_reps'], 12);
    expect(notice['their_reps'], 30);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('holding somebody off reads as a win', () async {
    if (!serverConfigured) return;

    final racer = await Lifter.signUp(name('c'));
    final away = await Lifter.signUp(name('d'));

    final theirSet = await away.uploadSet(reps: 28);
    final mySet = await racer.uploadSet(reps: 9);
    await racer.settle(mySet, theirSet);

    final notice = (await away.notices()).first as Map;
    expect(notice['you_won'], isTrue);
    expect(notice['your_reps'], 28);
    expect(notice['their_reps'], 9);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a rematch challenge tells the one it names', () async {
    if (!serverConfigured) return;

    final sender = await Lifter.signUp(name('m'));
    final target = await Lifter.signUp(name('n'));

    await sender.uploadSet(reps: 14, challengeTarget: target.id);

    // Sent it, was not told about their own action.
    expect(await sender.notices(), isEmpty);

    final told = await target.notices();
    expect(told, hasLength(1), reason: 'the target was never told');
    final notice = told.first as Map;
    expect(notice['kind'], 'challenged');
    expect(notice['actor'], sender.id);
    expect(notice['actor_name'], sender.username);
    expect(notice['unread'], isTrue);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('an ordinary set challenges nobody', () async {
    if (!serverConfigured) return;

    final a = await Lifter.signUp(name('o'));
    await a.uploadSet(reps: 9);
    expect(
      await a.notices(),
      isEmpty,
      reason: 'a set with no challenge_target still notified somebody',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a friend request and its answer both land', () async {
    if (!serverConfigured) return;

    final a = await Lifter.signUp(name('e'));
    final b = await Lifter.signUp(name('f'));

    await a.askFriend(b.username);

    final asked = await b.notices();
    expect(asked, hasLength(1));
    expect((asked.first as Map)['kind'], 'friend_request');
    expect((asked.first as Map)['actor_name'], a.username);
    // Asking tells them, not you.
    expect(await a.notices(), isEmpty);

    await b.answerFriend(a.id, accept: true);

    final accepted = await a.notices();
    expect(accepted, hasLength(1), reason: 'the asker was never told yes');
    expect((accepted.first as Map)['kind'], 'friend_accepted');
    expect((accepted.first as Map)['actor_name'], b.username);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('the count is what the dot shows, and reading clears it', () async {
    if (!serverConfigured) return;

    final a = await Lifter.signUp(name('g'));
    final b = await Lifter.signUp(name('h'));
    final c = await Lifter.signUp(name('i'));

    expect(await a.unreadNotices(), 0);

    await b.askFriend(a.username);
    await c.askFriend(a.username);
    expect(await a.unreadNotices(), 2);

    await a.readNotices();
    expect(await a.unreadNotices(), 0);

    // Read is not gone. The list still holds them, which is what makes it a
    // history rather than an inbox that empties itself.
    final after = await a.notices();
    expect(after, hasLength(2));
    expect(after.every((n) => (n as Map)['unread'] == false), isTrue);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('nobody reads anybody else', () async {
    if (!serverConfigured) return;

    final a = await Lifter.signUp(name('j'));
    final b = await Lifter.signUp(name('k'));
    final nosy = await Lifter.signUp(name('l'));

    await b.askFriend(a.username);
    expect(await a.notices(), hasLength(1));

    // The function is not `security definer`, so it answers as whoever
    // called it. If that were ever not true, this is where it shows.
    expect(await nosy.notices(), isEmpty);
    expect(await nosy.unreadNotices(), 0);

    // And clearing yours does not clear theirs.
    await nosy.readNotices();
    expect(await a.unreadNotices(), 1);
  }, timeout: const Timeout(Duration(minutes: 5)));
}
