/// The duels raced against this account's stored sets while it was away.
///
/// A ranked match with nobody live and no saved set to race puts the set in
/// the pool, and its result comes when somebody races it — on their phone.
/// The history used to be only what this phone watched happen, so those duels
/// reached the bell and the rank and never the history. These tests hold that
/// they reach it now: once each, in their place by time, with the rank the
/// server says they moved, and with nothing counted twice.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/career.dart';
import 'package:outrepd/data.dart';

/// A server with sets raced while this account was away.
class _Away extends NoBackend {
  _Away(this.raced, this.after);

  List<RacedSet> raced;
  RemoteProfile after;
  bool fail = false;

  @override
  bool get available => true;

  @override
  RemoteProfile? get me => after;

  @override
  Future<List<RacedSet>> racedSets() async {
    if (fail) throw Exception('offline');
    return raced;
  }

  @override
  Future<RemoteProfile> signIn({required String username}) async => after;
}

RacedSet _raced(String id, DateTime at, {bool won = true}) => RacedSet(
  duelId: id,
  at: at,
  opponentName: 'racer_$id',
  opponentTier: 2,
  won: won,
  yourReps: won ? 20 : 12,
  theirReps: 16,
  lpDelta: won ? 4 : -4,
);

RemoteProfile _server({int placementsDone = 0, int wins = 0, int losses = 0}) =>
    RemoteProfile(
      id: 'me',
      username: demoProfile.username,
      tierIdx: 0,
      divIdx: 0,
      lp: 0,
      friendCode: '123456',
      placementsDone: placementsDone,
      wins: wins,
      losses: losses,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final career = Career.instance;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await career.startFresh();
  });
  tearDown(() => backend = const NoBackend());

  test('a set raced while away is in the history, in its place by time', () async {
    final now = DateTime.now();
    // A duel this phone played itself, just now.
    await career.recordDuel(
      yourReps: 15,
      theirReps: 10,
      opponent: 'here',
      opponentTier: 1,
      ranked: false,
    );
    backend = _Away([
      _raced('b', now.subtract(const Duration(hours: 1))),
      _raced('a', now.subtract(const Duration(hours: 3)), won: false),
    ], _server(placementsDone: 2, wins: 1, losses: 1));

    await career.syncRacedSets();

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

  test('each one once, even after the app is opened again', () async {
    final now = DateTime.now();
    backend = _Away([
      _raced('a', now.subtract(const Duration(minutes: 5))),
    ], _server(placementsDone: 1, wins: 1));

    await career.syncRacedSets();
    await career.syncRacedSets();
    expect(matchHistory, hasLength(1));

    // Read back from storage, as a relaunch does, and asked again.
    await career.load();
    await career.syncRacedSets();
    expect(matchHistory, hasLength(1));

    // A second one raced since then is added; the first is not again.
    (backend as _Away).raced = [
      _raced('b', now),
      _raced('a', now.subtract(const Duration(minutes: 5))),
    ];
    await career.syncRacedSets();
    expect(matchHistory.map((m) => m.opponent), ['racer_b', 'racer_a']);
  });

  test('nothing but the history is counted again', () async {
    final reps = demoProfile.totalReps;
    final today = career.repsToday;
    backend = _Away([_raced('a', DateTime.now())], _server(placementsDone: 1))
      ..after = RemoteProfile(
        id: 'me',
        username: demoProfile.username,
        tierIdx: 0,
        divIdx: 0,
        lp: 0,
        friendCode: '123456',
        placementsDone: 1,
        totalReps: reps,
      );
    await career.syncRacedSets();
    // The set's reps were counted the day it was lifted, on this phone.
    expect(demoProfile.totalReps, reps);
    expect(career.repsToday, today);
  });

  test('a failed read changes nothing', () async {
    backend = _Away([_raced('a', DateTime.now())], _server(placementsDone: 1))
      ..fail = true;
    await career.syncRacedSets();
    expect(matchHistory, isEmpty);
    expect(demoProfile.placementsDone, 0);
  });

  test('with no server there is nothing to add', () async {
    await career.syncRacedSets();
    expect(matchHistory, isEmpty);
  });

  test('another account signed into starts its own list', () async {
    final now = DateTime.now();
    backend = _Away([_raced('a', now)], _server(placementsDone: 1, wins: 1));
    await career.syncRacedSets();
    expect(matchHistory, hasLength(1));

    await career.adoptServerProfile(_server());
    expect(matchHistory, isEmpty);
    // The same duel, if this account had it too, is theirs to see.
    await career.syncRacedSets();
    expect(matchHistory, hasLength(1));
  });
}
