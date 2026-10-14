/// The history holds every duel, whether or not a screen on this phone
/// watched it end.
///
/// The screens write down what they watch happen. A ranked match with nobody
/// live and no saved set to race puts the set in the pool, and its result
/// comes when somebody races it — on their phone. A live result can land
/// after its screen was closed, and a settled result's answer can be lost on
/// the way back. Each of those moved the rank and reached no history; in
/// testing it looked as if matches were not counted at all. These tests hold
/// that they reach it now: once each, in their place by time, with the rank
/// the server says they moved, and with nothing counted twice.
library;

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/career.dart';
import 'package:outrepd/data.dart';

/// A server holding this account's duels.
class _Server extends NoBackend {
  _Server(this.duels, this.after);

  List<ServerDuel> duels;
  RemoteProfile after;
  bool fail = false;

  @override
  bool get available => true;

  @override
  RemoteProfile? get me => after;

  @override
  Future<List<ServerDuel>> myDuels() async {
    if (fail) throw Exception('offline');
    return duels;
  }

  @override
  Future<RemoteProfile?> refreshMe() async => after;
}

ServerDuel _duel(
  String id,
  DateTime at, {
  bool won = true,
  bool away = true,
}) => ServerDuel(
  duelId: id,
  at: at,
  opponentName: 'racer_$id',
  opponentTier: 2,
  won: won,
  yourReps: won ? 20 : 12,
  theirReps: 16,
  lpDelta: won ? 4 : -4,
  racedWhileAway: away,
);

RemoteProfile _profile({
  int placementsDone = 0,
  int wins = 0,
  int losses = 0,
  int totalReps = 0,
}) => RemoteProfile(
  id: 'me',
  username: demoProfile.username,
  tierIdx: 0,
  divIdx: 0,
  lp: 0,
  friendCode: '123456',
  placementsDone: placementsDone,
  wins: wins,
  losses: losses,
  totalReps: totalReps,
);

SettledDuel _settled(String id) => SettledDuel(
  duelId: id,
  won: true,
  lpDelta: 0,
  tierIdx: 0,
  divIdx: 0,
  lp: 0,
  wins: 1,
  losses: 0,
  winStreak: 1,
  bestStreak: 1,
  placementsDone: 1,
  placementWins: 1,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final career = Career.instance;
  final now = DateTime.now();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await career.startFresh();
  });
  tearDown(() => backend = const NoBackend());

  test('a set raced while away is in the history, in its place by time', () async {
    backend = _Server([
      _duel('b', now.subtract(const Duration(hours: 1))),
      _duel('a', now.subtract(const Duration(hours: 3)), won: false),
    ], _profile(placementsDone: 2, wins: 1, losses: 1));
    // A duel this phone watched end, just now.
    await career.recordSettledDuel(
      settled: _settled('here'),
      yourReps: 15,
      theirReps: 10,
      opponent: 'here',
      opponentTier: 1,
      ranked: true,
    );

    await career.syncHistory();

    expect(matchHistory.map((m) => m.opponent), ['here', 'racer_b', 'racer_a']);
    expect(matchHistory[1].won, isTrue);
    expect(matchHistory[1].userReps, 20);
    expect(matchHistory[1].opponentReps, 16);
    expect(matchHistory[1].lpChange, 4);
    expect(matchHistory[2].won, isFalse);
    // The placements those duels counted for, as the server holds them.
    expect(demoProfile.placementsDone, 2);
    expect(demoProfile.wins, 1);
    expect(demoProfile.losses, 1);
  });

  test('a result whose screen was closed comes in from the server', () async {
    // A live match left on "waiting for their count": nothing was written
    // down here, and the server settled it afterwards.
    backend = _Server([
      _duel('live', now, away: false),
    ], _profile(placementsDone: 1, wins: 1));
    await career.syncHistory();
    expect(matchHistory.map((m) => m.opponent), ['racer_live']);
    expect(demoProfile.placementsDone, 1);
  });

  test('each one once, even after the app is opened again', () async {
    backend = _Server([
      _duel('a', now.subtract(const Duration(minutes: 5))),
    ], _profile(placementsDone: 1, wins: 1));

    await career.syncHistory();
    await career.syncHistory();
    expect(matchHistory, hasLength(1));

    // Read back from storage, as a relaunch does, and asked again.
    await career.load();
    await career.syncHistory();
    expect(matchHistory, hasLength(1));

    // A second one since then is added; the first is not again.
    (backend as _Server).duels = [
      _duel('b', now),
      _duel('a', now.subtract(const Duration(minutes: 5))),
    ];
    await career.syncHistory();
    expect(matchHistory.map((m) => m.opponent), ['racer_b', 'racer_a']);
  });

  test('a duel this phone wrote down is not added again from the server',
      () async {
    final server = _Server([], _profile(placementsDone: 1, wins: 1));
    backend = server;
    await career.syncHistory();
    await career.recordSettledDuel(
      settled: _settled('mine'),
      yourReps: 15,
      theirReps: 10,
      opponent: 'opponent',
      opponentTier: 1,
      ranked: true,
    );
    server.duels = [_duel('mine', now, away: false)];
    await career.syncHistory();
    expect(matchHistory.map((m) => m.opponent), ['opponent']);
  });

  test('nor the other way round, when the server answered first', () async {
    backend = _Server([
      _duel('mine', now, away: false),
    ], _profile(placementsDone: 1, wins: 1));
    await career.syncHistory();
    await career.recordSettledDuel(
      settled: _settled('mine'),
      yourReps: 20,
      theirReps: 16,
      opponent: 'racer_mine',
      opponentTier: 2,
      ranked: true,
    );
    expect(matchHistory, hasLength(1));
  });

  test('a history kept before ids were takes only what it never had', () async {
    // An update over a history this phone wrote down itself: its own duels
    // are already in it, with no ids to tell them by.
    SharedPreferences.setMockInitialValues({
      'career.history': jsonEncode([
        MatchRecord(
          won: true,
          userReps: 15,
          opponentReps: 10,
          opponent: 'from before',
          lpChange: 0,
          at: now,
        ).toJson(),
      ]),
    });
    await career.load();
    backend = _Server([
      _duel('played here', now.subtract(const Duration(hours: 1)), away: false),
      _duel('raced away', now.subtract(const Duration(hours: 2))),
    ], _profile(placementsDone: 1));
    await career.syncHistory();
    expect(
      matchHistory.map((m) => m.opponent),
      ['from before', 'racer_raced away'],
    );
  });

  test('nothing but the history is counted again', () async {
    final reps = demoProfile.totalReps;
    final today = career.repsToday;
    backend = _Server(
      [_duel('a', now)],
      _profile(placementsDone: 1, totalReps: reps),
    );
    await career.syncHistory();
    // The set's reps were counted the day it was lifted, on this phone.
    expect(demoProfile.totalReps, reps);
    expect(career.repsToday, today);
  });

  test('a failed read changes nothing', () async {
    backend = _Server([_duel('a', now)], _profile(placementsDone: 1))
      ..fail = true;
    await career.syncHistory();
    expect(matchHistory, isEmpty);
    expect(demoProfile.placementsDone, 0);
  });

  test('with no server there is nothing to add', () async {
    await career.syncHistory();
    expect(matchHistory, isEmpty);
  });

  test('another account signed into gets its whole history', () async {
    backend = _Server([_duel('a', now)], _profile(placementsDone: 1, wins: 1));
    await career.syncHistory();
    expect(matchHistory, hasLength(1));

    await career.adoptServerProfile(_profile());
    expect(matchHistory, isEmpty);
    // Signing in on a phone: its duels, all of them, from the server.
    (backend as _Server).duels = [
      _duel('x', now, away: false),
      _duel('y', now.subtract(const Duration(days: 1))),
    ];
    await career.syncHistory();
    expect(matchHistory.map((m) => m.opponent), ['racer_x', 'racer_y']);
  });
}
