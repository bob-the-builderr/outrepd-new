/// The Supabase implementation of [Backend].
///
/// Thin on purpose. Everything that decides an outcome — who won, what it
/// pays, where it leaves both ranks — happens in `supabase/duel.sql`, because
/// this file runs on a phone in somebody else's hands. What is left here is
/// carrying rows there and back.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../country_names.dart';
import 'backend.dart';

/// Supplied at build time, never committed:
///
///   flutter build apk --release \
///     --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
const kSupabaseUrl = String.fromEnvironment('SUPABASE_URL');
const kSupabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

/// Starts the backend if keys were supplied, and leaves the app on
/// [NoBackend] if they were not.
///
/// Never throws. A build with a typo in a key, or a phone with no network at
/// launch, must still open the app — the screens that need a server say so on
/// their own.
Future<void> startBackend() async {
  if (kSupabaseUrl.isEmpty || kSupabaseAnonKey.isEmpty) return;
  try {
    // `publishableKey` is the SDK's current name for it. The older `anonKey`
    // takes the same value and is on its way out.
    await Supabase.initialize(
      url: kSupabaseUrl,
      publishableKey: kSupabaseAnonKey,
      httpClient: GiveUpClient(http.Client()),
    );
    backend = SupabaseBackend(Supabase.instance.client);
  } on Object catch (error) {
    debugPrint('Could not reach the server: $error');
  }
}

/// How long a request to the server may go unanswered before the app gives
/// up on it, seconds.
///
/// Without one, a request sent as the phone's connection drops can sit
/// unanswered for minutes — the operating system's own limit — and the screen
/// waiting on it shows its spinner the whole time. Every screen already says
/// when a request fails; this makes a dead connection one of those.
/// A normal answer takes well under a second, and a slow network's a few.
const kRequestTimeoutSeconds = 20;

/// Sends every request through [inner], giving up after
/// [kRequestTimeoutSeconds] — except uploads and server functions, which can
/// rightly take longer on a slow connection: a picture going up over a weak
/// signal, or the function that gathers a lifter's data to email them.
class GiveUpClient extends http.BaseClient {
  GiveUpClient(this.inner);

  final http.Client inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final path = request.url.path;
    if (path.startsWith('/storage/') || path.startsWith('/functions/')) {
      return inner.send(request);
    }
    return inner
        .send(request)
        .timeout(const Duration(seconds: kRequestTimeoutSeconds));
  }

  @override
  void close() => inner.close();
}

class SupabaseBackend implements Backend {
  SupabaseBackend(this._db);

  final SupabaseClient _db;
  RemoteProfile? _me;

  @override
  bool get available => true;

  @override
  RemoteProfile? get me => _me;

  @override
  Future<RemoteProfile> signIn({required String username}) async {
    // Anonymous to begin with: a lifter who has just done three push-ups has
    // not yet been given a reason to hand over an email. Supabase can attach
    // one later, on the same account, without losing what it earned.
    var user = _db.auth.currentUser;
    user ??= (await _db.auth.signInAnonymously()).user;
    if (user == null) throw StateError('sign-in returned no user');

    // The row may already exist — this is the second launch, or the first was
    // interrupted after auth and before the insert.
    final existing = await _db
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    final row =
        existing ??
        await _db
            .from('profiles')
            .insert({
              'id': user.id,
              'username': _unique(username, user.id),
              'country': _country,
            })
            .select()
            .single();

    // An account made before the country was recorded, or on a phone that
    // could not say. Filled in rather than left null, because the country
    // board is the only board most people can realistically move, and an
    // empty one is indistinguishable from a broken one.
    if (row['country'] == null && _country != null) {
      await _db
          .from('profiles')
          .update({'country': _country})
          .eq('id', user.id);
      row['country'] = _country;
    }

    return _me = _keep(row);
  }

  /// Where the last row read is kept, with the account it belongs to.
  static const _kKeptRow = 'backend.me.v1';

  /// [row] as the profile, and kept for the next launch ([cachedMe]).
  RemoteProfile _keep(Map<String, dynamic> row) {
    unawaited(() async {
      try {
        final store = await SharedPreferences.getInstance();
        await store.setString(_kKeptRow, jsonEncode(row));
      } on Object catch (error) {
        debugPrint('Could not keep the profile: $error');
      }
    }());
    return _profileFrom(row);
  }

  Future<void> _forgetKept() async {
    try {
      final store = await SharedPreferences.getInstance();
      await store.remove(_kKeptRow);
    } on Object catch (error) {
      debugPrint('Could not forget the profile: $error');
    }
  }

  @override
  Future<RemoteProfile?> cachedMe() async {
    final user = _db.auth.currentUser;
    if (user == null) return null;
    try {
      final store = await SharedPreferences.getInstance();
      final raw = store.getString(_kKeptRow);
      if (raw == null) return null;
      final row = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      // Kept for another account: a phone signed out and into a new one.
      if (row['id'] != user.id) return null;
      // A fresh read that already landed wins over what was kept.
      return _me ??= _profileFrom(row);
    } on Object catch (error) {
      debugPrint('Could not read the kept profile: $error');
      return null;
    }
  }

  @override
  Future<RemoteProfile?> refreshMe() async {
    final user = _db.auth.currentUser;
    if (user == null) return null;
    final row = await _db
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    if (row == null) return null;
    return _me = _keep(row);
  }

  /// Where this phone says it is: the country a new account starts with,
  /// until its lifter picks another (set_my_country).
  static String? get _country => deviceCountryCode();

  @override
  Future<String> uploadSet(SetUpload set) async {
    final user = _db.auth.currentUser;
    if (user == null) throw StateError('not signed in');

    final row = await _db
        .from('sets')
        .insert({
          'profile_id': user.id,
          'reps': set.reps,
          'reps_camera': set.repsCamera,
          'depth': set.depth,
          'confident': set.confident,
          // At least a millisecond: a round given up before it started
          // never ran its clock, and a zero is refused (duration_ms > 0) —
          // which would leave the forfeit off the server entirely.
          'duration_ms': set.durationMs < 1 ? 1 : set.durationMs,
          'gave_up': set.gaveUp,
          'rep_times': set.repTimes,
          'challenge_target': set.challengeTarget,
          // Only when it is one: a server from before practice was stored
          // has no such column, and refuses a row naming it.
          if (set.practice) 'practice': true,
        })
        .select('id')
        .single();

    return row['id'] as String;
  }

  @override
  Future<OpponentSet?> findOpponent() async {
    final rows = await _db.rpc<List<dynamic>>('find_opponent_set');
    return _opponentFromRows(rows);
  }

  @override
  Future<OpponentSet?> findTargetedOpponent(String theirId) async {
    final rows = await _db.rpc<List<dynamic>>(
      'find_targeted_set',
      params: {'from_id': theirId},
    );
    return _opponentFromRows(rows);
  }

  OpponentSet? _opponentFromRows(List<dynamic> rows) {
    if (rows.isEmpty) return null;
    final row = rows.first as Map<String, dynamic>;
    return OpponentSet(
      setId: row['set_id'] as String,
      profileId: row['profile_id'] as String,
      username: row['username'] as String,
      tierIdx: row['tier_idx'] as int,
      divIdx: row['div_idx'] as int,
      reps: row['reps'] as int,
      repTimes: [
        for (final t in (row['rep_times'] as List? ?? const []))
          (t as num).toInt(),
      ],
      avatarUrl: row['avatar_url'] as String?,
      xp: (row['xp'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<SettledDuel> settle({
    required String mySetId,
    required String theirSetId,
    bool ranked = true,
  }) async {
    final rows = await _db.rpc<List<dynamic>>(
      'settle_duel',
      params: {'my_set': mySetId, 'their_set': theirSetId, 'ranked': ranked},
    );
    if (rows.isEmpty) throw StateError('the duel settled to nothing');

    final row = rows.first as Map<String, dynamic>;
    final settled = SettledDuel(
      duelId: row['duel_id'] as String,
      won: row['won'] as bool,
      lpDelta: row['lp_delta'] as int,
      tierIdx: row['tier_idx'] as int,
      divIdx: row['div_idx'] as int,
      lp: row['lp'] as int,
      wins: row['wins'] as int,
      losses: row['losses'] as int,
      winStreak: row['win_streak'] as int,
      bestStreak: row['best_streak'] as int,
      placementsDone: row['placements_done'] as int,
      placementWins: row['placement_wins'] as int,
      // Missing from a server older than the column: what was asked for.
      ranked: row['was_ranked'] as bool? ?? ranked,
    );

    _remember(settled);
    return settled;
  }

  /// What came back is the rank now. The app recomputes the same numbers to
  /// show them, and where the two ever disagree the server is right — it is
  /// the one holding the row.
  void _remember(SettledDuel settled) {
    final was = _me;
    if (was != null) {
      _me = was.copyWith(
        tierIdx: settled.tierIdx,
        divIdx: settled.divIdx,
        lp: settled.lp,
        // The floor a stale value would have kept can't drift behind a tier
        // the server just gave this account.
        peakTierIdx: settled.tierIdx > was.peakTierIdx
            ? settled.tierIdx
            : was.peakTierIdx,
        wins: settled.wins,
        losses: settled.losses,
        winStreak: settled.winStreak,
        bestStreak: settled.bestStreak,
        placementsDone: settled.placementsDone,
        placementWins: settled.placementWins,
      );
    }
  }

  @override
  Future<List<BoardRow>> leaderboard({
    int limit = 100,
    String? country,
    int? tierIdx,
    int? divIdx,
  }) async {
    // Through the function rather than the table. It is the one place that
    // knows who asked to be left off a board, and a filter the client adds
    // is a filter the client can drop.
    final rows = await _db.rpc<List<dynamic>>(
      'leaderboard',
      params: {
        'in_country': country,
        'limit_to': limit,
        'in_tier_idx': tierIdx,
        'in_div_idx': divIdx,
      },
    );
    return _boardRows(rows);
  }

  @override
  Future<List<BoardRow>> friendsLeaderboard() async =>
      _boardRows(await _db.rpc<List<dynamic>>('friends_leaderboard'));

  List<BoardRow> _boardRows(List<dynamic> rows) {
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        BoardRow(
          id: row['id'] as String,
          username: row['username'] as String,
          tierIdx: (row['tier_idx'] as num?)?.toInt() ?? 0,
          divIdx: (row['div_idx'] as num?)?.toInt() ?? 0,
          lp: (row['lp'] as num?)?.toInt() ?? 0,
          wins: (row['wins'] as num?)?.toInt() ?? 0,
          losses: (row['losses'] as num?)?.toInt() ?? 0,
          avatarUrl: row['avatar_url'] as String?,
          xp: (row['xp'] as num?)?.toInt() ?? 0,
        ),
    ];
  }

  @override
  Future<int?> boardPosition({String? country}) async {
    // Counted by the same function that draws the board, so the number on
    // the profile and the row on the list can never disagree about who is
    // on it. Null when there is no place to show: still in placements, or
    // asked to be left off.
    return _db.rpc<int?>('my_board_place', params: {'in_country': country});
  }

  @override
  Future<List<MonthRow>> monthBoard({int limit = 100, String? country}) =>
      _seasonBoard('month_board', limit, country);

  @override
  Future<List<MonthRow>> weekBoard({int limit = 100, String? country}) =>
      _seasonBoard('week_board', limit, country);

  @override
  Future<MonthPlace?> myWeekPlace({String? country}) async {
    if (_db.auth.currentUser == null) return null;
    final rows = await _db.rpc<List<dynamic>>(
      'my_week_place',
      params: {'in_country': country},
    );
    if (rows.isEmpty) return null;
    final row = rows.first as Map<String, dynamic>;
    return MonthPlace(
      season: _seasonDate(row['week'] as String),
      endsAt: DateTime.parse(row['ends_at'] as String),
      place: (row['place'] as num?)?.toInt(),
      ofTotal: (row['of_total'] as num?)?.toInt() ?? 0,
      points: (row['points'] as num?)?.toInt() ?? 0,
      wins: (row['wins'] as num?)?.toInt() ?? 0,
      played: (row['played'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<List<MonthRow>> friendsBoard({bool month = false}) async =>
      _monthRows(
        await _db.rpc<List<dynamic>>(
          'friends_board',
          params: {'in_month': month},
        ),
      );

  Future<List<MonthRow>> _seasonBoard(
    String function,
    int limit,
    String? country,
  ) async => _monthRows(
    await _db.rpc<List<dynamic>>(
      function,
      params: {'in_country': country, 'limit_to': limit},
    ),
  );

  List<MonthRow> _monthRows(List<dynamic> rows) {
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        MonthRow(
          place: (row['place'] as num).toInt(),
          id: row['id'] as String,
          username: row['username'] as String,
          tierIdx: (row['tier_idx'] as num?)?.toInt() ?? 0,
          divIdx: (row['div_idx'] as num?)?.toInt() ?? 0,
          points: (row['points'] as num?)?.toInt() ?? 0,
          wins: (row['wins'] as num?)?.toInt() ?? 0,
          played: (row['played'] as num?)?.toInt() ?? 0,
          avatarUrl: row['avatar_url'] as String?,
          xp: (row['xp'] as num?)?.toInt() ?? 0,
        ),
    ];
  }

  @override
  Future<MonthPlace?> myMonthPlace({String? country}) async {
    if (_db.auth.currentUser == null) return null;
    final rows = await _db.rpc<List<dynamic>>(
      'my_month_place',
      params: {'in_country': country},
    );
    if (rows.isEmpty) return null;
    final row = rows.first as Map<String, dynamic>;
    return MonthPlace(
      season: _seasonDate(row['season'] as String),
      endsAt: DateTime.parse(row['ends_at'] as String),
      place: (row['place'] as num?)?.toInt(),
      ofTotal: (row['of_total'] as num?)?.toInt() ?? 0,
      points: (row['points'] as num?)?.toInt() ?? 0,
      wins: (row['wins'] as num?)?.toInt() ?? 0,
      played: (row['played'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<Map<String, ProLook>> proLooks(List<String> ids) async {
    if (ids.isEmpty || _db.auth.currentUser == null) return const {};
    final rows = await _db.rpc<List<dynamic>>(
      'pro_looks',
      params: {'ids': ids.take(200).toList()},
    );
    return {
      for (final row in rows.cast<Map<String, dynamic>>())
        row['id'] as String: ProLook(
          id: row['id'] as String,
          pro: row['pro'] as bool? ?? false,
          lifter: row['lifter'] is Map
              ? Map<String, dynamic>.from(row['lifter'] as Map)
              : null,
          cover: row['cover'] as String?,
        ),
    };
  }

  @override
  Future<void> saveCover(String? cover) async {
    final user = _db.auth.currentUser;
    if (user == null) throw StateError('not signed in');
    await _db.from('profiles').update({'cover': cover}).eq('id', user.id);
  }

  @override
  Future<String> uploadCover(Uint8List bytes) async {
    final user = _db.auth.currentUser;
    if (user == null) throw StateError('not signed in');
    // The one path the server takes for a cover, beside the photo; the
    // version makes every phone fetch the new one.
    final path = '${user.id}/cover.jpg';
    await _db.storage
        .from('avatars')
        .uploadBinary(
          path,
          bytes,
          // A minute at the storage CDN, not the hour it keeps by default: it
          // caches by path and ignores ?v, so a new cover showed the old one
          // to everybody for up to an hour (2026-11-05).
          fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg', cacheControl: '60'),
        );
    final url =
        '${_db.storage.from('avatars').getPublicUrl(path)}'
        '?v=${DateTime.now().millisecondsSinceEpoch}';
    await saveCover(url);
    return url;
  }

  @override
  Future<MonthWinners?> lastMonthWinners() async {
    if (_db.auth.currentUser == null) return null;
    final rows = (await _db.rpc<List<dynamic>>(
      'last_month_winners',
    )).cast<Map<String, dynamic>>();
    if (rows.isEmpty) return null;
    return MonthWinners(
      season: _seasonDate(rows.first['season'] as String),
      rows: [
        for (final row in rows)
          MonthRow(
            place: (row['place'] as num).toInt(),
            id: row['id'] as String,
            username: row['username'] as String,
            tierIdx: (row['tier_idx'] as num?)?.toInt() ?? 0,
            divIdx: (row['div_idx'] as num?)?.toInt() ?? 0,
            points: (row['points'] as num?)?.toInt() ?? 0,
            wins: 0,
            played: (row['played'] as num?)?.toInt() ?? 0,
            avatarUrl: row['avatar_url'] as String?,
            xp: (row['xp'] as num?)?.toInt() ?? 0,
          ),
      ],
    );
  }

  @override
  Future<List<SeasonAward>> mySeasonAwards() async {
    if (_db.auth.currentUser == null) return const [];
    final rows = await _db.rpc<List<dynamic>>('my_season_awards');
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        if (_awardKind(row['award'] as String?) case final kind?)
          SeasonAward(
            season: _seasonDate(row['season'] as String),
            kind: kind,
            place: (row['place'] as num?)?.toInt(),
            points: (row['points'] as num?)?.toInt() ?? 0,
            played: (row['played'] as num?)?.toInt() ?? 0,
            seen: row['seen'] as bool? ?? true,
          ),
    ];
  }

  @override
  Future<void> markSeasonAwardsSeen() async {
    if (_db.auth.currentUser == null) return;
    await _db.rpc<void>('mark_season_awards_seen');
  }

  @override
  Future<List<SeasonAward>> lifterSeasonAwards(String theirId) async {
    final rows = await _db.rpc<List<dynamic>>(
      'lifter_season_awards',
      params: {'their_id': theirId},
    );
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        if (_awardKind(row['award'] as String?) case final kind?)
          SeasonAward(
            season: _seasonDate(row['season'] as String),
            kind: kind,
            place: (row['place'] as num?)?.toInt(),
          ),
    ];
  }

  /// A `date` column, which comes as `2026-10-01`, at midnight UTC — the
  /// months are UTC months on the server, and read as local midnight one
  /// could land in the month before.
  static DateTime _seasonDate(String date) => DateTime.parse('${date}T00:00:00Z');

  /// Unknown kinds are skipped: an award a newer server gives out is not one
  /// this build can draw.
  static SeasonAwardKind? _awardKind(String? name) =>
      SeasonAwardKind.values.where((k) => k.name == name).firstOrNull;

  @override
  Future<LifterProfile?> lifterProfile(String theirId) async {
    final rows = await _db.rpc<List<dynamic>>(
      'lifter_profile',
      params: {'their_id': theirId},
    );
    if (rows.isEmpty) return null;
    final row = rows.first as Map<String, dynamic>;

    DateTime? parseLocal(String? value) =>
        value == null ? null : DateTime.tryParse(value)?.toLocal();

    return LifterProfile(
      id: row['id'] as String,
      username: row['username'] as String,
      tierIdx: (row['tier_idx'] as num?)?.toInt() ?? 0,
      divIdx: (row['div_idx'] as num?)?.toInt() ?? 0,
      lp: (row['lp'] as num?)?.toInt() ?? 0,
      placementsDone: (row['placements_done'] as num?)?.toInt() ?? 0,
      totalReps: (row['total_reps'] as num?)?.toInt() ?? 0,
      bestSet: (row['best_set'] as num?)?.toInt() ?? 0,
      wins: (row['wins'] as num?)?.toInt() ?? 0,
      losses: (row['losses'] as num?)?.toInt() ?? 0,
      winStreak: (row['win_streak'] as num?)?.toInt() ?? 0,
      globalPlace: (row['global_place'] as num?)?.toInt(),
      country: row['country'] as String?,
      countryPlace: (row['country_place'] as num?)?.toInt(),
      isFriend: row['is_friend'] as bool? ?? false,
      winsVsYou: (row['wins_vs_you'] as num?)?.toInt() ?? 0,
      lossesVsYou: (row['losses_vs_you'] as num?)?.toInt() ?? 0,
      yourBestVsThem: (row['your_best_vs_them'] as num?)?.toInt(),
      lastDuelAt: parseLocal(row['last_duel_at'] as String?),
      lastYourReps: (row['last_your_reps'] as num?)?.toInt(),
      lastTheirReps: (row['last_their_reps'] as num?)?.toInt(),
      avatarUrl: row['avatar_url'] as String?,
      title: row['title'] as String?,
      xp: (row['xp'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<List<RemoteFriend>> friends() async {
    final rows = await _db.rpc<List<dynamic>>('my_friends');
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        RemoteFriend(
          id: row['id'] as String,
          username: row['username'] as String,
          tierIdx: (row['tier_idx'] as num?)?.toInt() ?? 0,
          divIdx: (row['div_idx'] as num?)?.toInt() ?? 0,
          lp: (row['lp'] as num?)?.toInt() ?? 0,
          placementsDone: (row['placements_done'] as num?)?.toInt() ?? 0,
          // Parsed as UTC and handed back local, so "five minutes ago" means
          // five minutes ago on a phone in any timezone.
          lastSeen:
              DateTime.tryParse(row['last_seen'] as String? ?? '')?.toLocal() ??
              DateTime.fromMillisecondsSinceEpoch(0),
          winsVsYou: (row['wins_vs_you'] as num?)?.toInt() ?? 0,
          lossesVsYou: (row['losses_vs_you'] as num?)?.toInt() ?? 0,
          avatarUrl: row['avatar_url'] as String?,
          xp: (row['xp'] as num?)?.toInt() ?? 0,
        ),
    ];
  }

  @override
  Future<List<FriendRequest>> friendRequests() async {
    final rows = await _db.rpc<List<dynamic>>('friend_requests');
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        FriendRequest(
          id: row['id'] as String,
          username: row['username'] as String,
          tierIdx: (row['tier_idx'] as num?)?.toInt() ?? 0,
          divIdx: (row['div_idx'] as num?)?.toInt() ?? 0,
          askedAt: DateTime.tryParse(
            row['asked_at'] as String? ?? '',
          )?.toLocal(),
          placementsDone: (row['placements_done'] as num?)?.toInt() ?? 0,
          bestSet: (row['best_set'] as num?)?.toInt() ?? 0,
          wins: (row['wins'] as num?)?.toInt() ?? 0,
          losses: (row['losses'] as num?)?.toInt() ?? 0,
          avatarUrl: row['avatar_url'] as String?,
        ),
    ];
  }

  @override
  Future<List<FoundLifter>> findLifters(String query) async {
    final rows = await _db.rpc<List<dynamic>>(
      'find_lifters',
      params: {'query': query},
    );
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        FoundLifter(
          id: row['id'] as String,
          username: row['username'] as String,
          tierIdx: (row['tier_idx'] as num?)?.toInt() ?? 0,
          divIdx: (row['div_idx'] as num?)?.toInt() ?? 0,
          placementsDone: (row['placements_done'] as num?)?.toInt() ?? 0,
          avatarUrl: row['avatar_url'] as String?,
        ),
    ];
  }

  @override
  Future<AskResult> askFriend(String identifier) async {
    final trimmed = identifier.trim();
    Future<String> byName() => _db.rpc<String>(
      'request_friend',
      params: {'their_name': trimmed},
    );
    final code = friendCodeIn(trimmed);
    var answer = code == null
        ? await byName()
        : await _db.rpc<String>(
            'request_friend_by_code',
            params: {'code': code},
          );
    // Six digits with no '#' could still be somebody's name.
    if (answer == 'no such lifter' && code != null && !trimmed.startsWith('#')) {
      answer = await byName();
    }
    return switch (answer) {
      'friends' => AskResult.friends,
      'no such lifter' => AskResult.noSuchLifter,
      'that is you' => AskResult.thatIsYou,
      _ => AskResult.asked,
    };
  }

  @override
  Future<void> answerFriend(String theirId, {required bool accept}) async {
    await _db.rpc<String>(
      'answer_friend',
      params: {'their_id': theirId, 'accept': accept},
    );
  }

  @override
  Future<List<Notice>> notices() async {
    final rows = await _db.rpc<List<dynamic>>('my_notifications');
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        Notice(
          id: row['id'] as String,
          kind: switch (row['kind'] as String) {
            'friend_request' => NoticeKind.friendRequest,
            'friend_accepted' => NoticeKind.friendAccepted,
            'challenged' => NoticeKind.challenged,
            'live_invite' => NoticeKind.liveInvite,
            _ => NoticeKind.raced,
          },
          at:
              DateTime.tryParse(
                row['created_at'] as String? ?? '',
              )?.toLocal() ??
              DateTime.now(),
          unread: row['unread'] as bool? ?? false,
          actorName: row['actor_name'] as String? ?? '',
          actorId: row['actor'] as String?,
          youWon: row['you_won'] as bool?,
          yourReps: (row['your_reps'] as num?)?.toInt(),
          theirReps: (row['their_reps'] as num?)?.toInt(),
          lpDelta: (row['lp_delta'] as num?)?.toInt(),
        ),
    ];
  }

  @override
  Future<Map<String, int>> myDays({int lastDays = 31}) async {
    final rows = await _db.rpc<List<dynamic>>(
      'my_days',
      params: {
        // This phone's days, not the server's: a set at 1 a.m. here is
        // today's, whatever the date is in UTC.
        'tz_minutes': DateTime.now().timeZoneOffset.inMinutes,
        'last_days': lastDays,
      },
    );
    return {
      for (final row in rows.cast<Map<String, dynamic>>())
        row['day'] as String: (row['reps'] as num).toInt(),
    };
  }

  @override
  Future<List<ServerDuel>> myDuels() async {
    final rows = await _db.rpc<List<dynamic>>('my_duels');
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        ServerDuel(
          duelId: row['duel_id'] as String,
          at:
              DateTime.tryParse(
                row['played_at'] as String? ?? '',
              )?.toLocal() ??
              DateTime.now(),
          opponentName: row['opponent_name'] as String? ?? '',
          opponentTier: (row['opponent_tier'] as num?)?.toInt() ?? 0,
          won: row['you_won'] as bool? ?? false,
          yourReps: (row['your_reps'] as num?)?.toInt() ?? 0,
          theirReps: (row['their_reps'] as num?)?.toInt() ?? 0,
          lpDelta: (row['lp_delta'] as num?)?.toInt() ?? 0,
          racedWhileAway: row['raced_while_away'] as bool? ?? false,
        ),
    ];
  }

  @override
  Future<int> unreadNotices() async =>
      (await _db.rpc<int>('unread_notifications'));

  @override
  Future<void> readNotices() async {
    await _db.rpc<int>('read_notifications');
  }

  @override
  Future<void> setTitle(String? id) async {
    final user = _db.auth.currentUser;
    if (user == null) return;
    await _db.from('profiles').update({'title': id}).eq('id', user.id);
  }

  @override
  Future<void> touch() async {
    final user = _db.auth.currentUser;
    if (user == null) return;
    await _db
        .from('profiles')
        .update({'last_seen': DateTime.now().toUtc().toIso8601String()})
        .eq('id', user.id);
  }

  @override
  Future<RemotePrefs> savePrefs(RemotePrefs prefs) async {
    final user = _db.auth.currentUser;
    if (user == null) throw StateError('not signed in');

    // Straight at the row: these are the columns the guard trigger leaves
    // alone, because they are the ones a lifter legitimately owns. The
    // ladder columns beside them still refuse.
    final row = await _db
        .from('profiles')
        .update({
          'challengeable': prefs.challengeable.name,
          'show_on_board': prefs.showOnBoard,
          'show_country': prefs.showCountry,
          'notify_raced': prefs.notifyRaced,
          'notify_challenged': prefs.notifyChallenged,
          'notify_live_invite': prefs.notifyLiveInvite,
          'notify_friend_request': prefs.notifyFriendRequest,
          'notify_friend_ok': prefs.notifyFriendOk,
        })
        .eq('id', user.id)
        .select()
        .single();

    final was = _me;
    final now = _prefsFrom(row);
    if (was != null) _me = _withPrefs(was, now);
    return now;
  }

  @override
  Future<void> removeFriend(String theirId) async {
    await _db.rpc<String>('remove_friend', params: {'their_id': theirId});
  }

  @override
  Future<void> block(String theirId) async {
    await _db.rpc<String>('block_lifter', params: {'their_id': theirId});
  }

  @override
  Future<void> unblock(String theirId) async {
    await _db.rpc<String>('unblock_lifter', params: {'their_id': theirId});
  }

  @override
  Future<List<BlockedLifter>> blocked() async {
    final rows = await _db.rpc<List<dynamic>>('my_blocks');
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        BlockedLifter(
          id: row['id'] as String,
          username: row['username'] as String,
          at:
              DateTime.tryParse(
                row['blocked_at'] as String? ?? '',
              )?.toLocal() ??
              DateTime.now(),
        ),
    ];
  }

  @override
  Future<void> mute(String theirId) async {
    await _db.rpc<String>('mute_lifter', params: {'their_id': theirId});
  }

  @override
  Future<void> unmute(String theirId) async {
    await _db.rpc<String>('unmute_lifter', params: {'their_id': theirId});
  }

  @override
  Future<List<MutedLifter>> muted() async {
    final rows = await _db.rpc<List<dynamic>>('my_mutes');
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        MutedLifter(
          id: row['id'] as String,
          username: row['username'] as String,
          at:
              DateTime.tryParse(row['muted_at'] as String? ?? '')?.toLocal() ??
              DateTime.now(),
        ),
    ];
  }

  @override
  Future<void> report({
    String? aboutId,
    required ReportReason reason,
    String details = '',
  }) async {
    final user = _db.auth.currentUser;
    if (user == null) throw StateError('not signed in');

    await _db.from('reports').insert({
      'reporter': user.id,
      'reported': aboutId,
      'reason': reason.name,
      'details': details,
    });
  }

  @override
  Future<bool> usernameAvailable(String name) async {
    return _db.rpc<bool>('username_available', params: {'name': name});
  }

  @override
  Future<SocialSignInResult> signInWithIdToken({
    required SocialProvider provider,
    required String idToken,
    String? accessToken,
    String? nonce,
  }) async {
    final oauth = switch (provider) {
      SocialProvider.apple => OAuthProvider.apple,
      SocialProvider.google => OAuthProvider.google,
    };
    try {
      // This phone's guest takes the identity on: the same account, its
      // placements and its row, now with a way back in.
      final current = _db.auth.currentUser;
      if (current != null && current.isAnonymous) {
        try {
          await _db.auth.linkIdentityWithIdToken(
            provider: oauth,
            idToken: idToken,
            accessToken: accessToken,
            nonce: nonce,
          );
          await refreshMe();
          return SocialSignInResult.newAccount;
        } on AuthRetryableFetchException {
          rethrow;
        } on AuthException catch (error) {
          // Not this guest's to take: the identity, or its email, already
          // belongs to an account. That account is signed in to below.
          debugPrint('Could not link ${provider.name}: ${error.code} ${error.message}');
        }
      }

      final response = await _db.auth.signInWithIdToken(
        provider: oauth,
        idToken: idToken,
        accessToken: accessToken,
        nonce: nonce,
      );
      final user = response.user;
      if (user == null) return SocialSignInResult.failed;
      // A row made here when the account is new, as a first launch would.
      final existing = await _db
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      final row =
          existing ??
          await _db
              .from('profiles')
              .insert({
                'id': user.id,
                'username': _unique('lifter', user.id),
                'country': _country,
              })
              .select()
              .single();
      _me = _keep(row);
      return existing == null
          ? SocialSignInResult.newAccount
          : SocialSignInResult.existingAccount;
    } on AuthRetryableFetchException catch (_) {
      return SocialSignInResult.offline;
    } on AuthException catch (error) {
      debugPrint('Could not sign in with ${provider.name}: ${error.message}');
      lastSocialSignInError = error.message;
      return SocialSignInResult.failed;
    }
  }

  @override
  Future<List<int>> myAdventure() async =>
      _stars(await _db.rpc<dynamic>('my_adventure'));

  @override
  Future<List<int>> saveAdventure(List<int> stars) async => _stars(
    await _db.rpc<dynamic>('save_adventure', params: {'new_stars': stars}),
  );

  @override
  Future<Map<String, dynamic>> myRewards() async =>
      _rewards(await _db.rpc<dynamic>('my_rewards'));

  @override
  Future<Map<String, dynamic>> saveRewards(Map<String, dynamic> state) async =>
      _rewards(
        await _db.rpc<dynamic>('save_rewards', params: {'new_state': state}),
      );

  static Map<String, dynamic> _rewards(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : const {};

  /// A smallint[] as the client hands it over: a list of numbers, or null
  /// for an account that has never saved one.
  static List<int> _stars(dynamic raw) => [
    if (raw is List)
      for (final s in raw) (s is num ? s.toInt() : 0).clamp(0, 3),
  ];

  @override
  Future<CountryResult> setMyCountry(String code) async {
    final result = await _db.rpc<String>(
      'set_my_country',
      params: {'new_country': code},
    );
    switch (result) {
      case 'ok':
        // Read back rather than guessed: whether the fourteen days started
        // depends on whether the server counts this account as confirmed.
        await refreshMe();
        return CountryResult.ok;
      case 'too_soon':
        return CountryResult.tooSoon;
      default:
        return CountryResult.invalid;
    }
  }

  @override
  Future<RenameResult> renameUsername(String name) async {
    final result = await _db.rpc<String>(
      'set_my_username',
      params: {'new_name': name},
    );
    if (result != 'ok') {
      return switch (result) {
        'taken' => RenameResult.taken,
        'already_changed' => RenameResult.alreadyChanged,
        'not_allowed' => RenameResult.notAllowed,
        _ => RenameResult.invalid,
      };
    }

    final was = _me;
    if (was != null) {
      _me = was.copyWith(
        username: name.trim(),
        usernameChangedAt: DateTime.now(),
      );
    }
    return RenameResult.ok;
  }

  @override
  Future<String> uploadAvatar(
    Uint8List bytes, {
    String contentType = 'image/jpeg',
  }) async {
    final user = _db.auth.currentUser;
    if (user == null) throw StateError('not signed in');

    // Always the same path: an upload replaces the last one rather than
    // piling up, and the id-scoped folder is what the storage policies
    // check to keep anybody from overwriting somebody else's.
    final path = '${user.id}/photo.jpg';
    await _db.storage
        .from('avatars')
        .uploadBinary(
          path,
          bytes,
          // The name stays photo.jpg whatever is in it — the server only
          // takes that one path — and the content type says what it is.
          // A minute at the storage CDN, not its default hour: it caches by
          // path and ignores ?v, so a new picture showed the old one on the
          // boards for up to an hour (the user's lifter, 2026-11-05).
          fileOptions: FileOptions(upsert: true, contentType: contentType, cacheControl: '60'),
        );

    // The path never changes, so neither would the public URL — cache-busted
    // here, or every phone that already saw the old photo, including this
    // one, keeps it until the cache header expires regardless of what was
    // just uploaded.
    final url =
        '${_db.storage.from('avatars').getPublicUrl(path)}'
        '?v=${DateTime.now().millisecondsSinceEpoch}';

    await _db.from('profiles').update({'avatar_url': url}).eq('id', user.id);

    final was = _me;
    if (was != null) {
      _me = was.copyWith(avatarUrl: url);
    }
    return url;
  }

  @override
  Future<void> saveLifter(Map<String, Object> lifter) async {
    final user = _db.auth.currentUser;
    if (user == null) throw StateError('not signed in');
    await _db.from('profiles').update({'lifter': lifter}).eq('id', user.id);
    final was = _me;
    if (was != null) _me = was.copyWith(lifter: lifter);
  }

  @override
  Future<void> removeAvatar() async {
    final user = _db.auth.currentUser;
    if (user == null) throw StateError('not signed in');

    // The link first: once it is gone every screen draws the lifter, and a
    // file left behind by a lost connection is one nobody is shown — the
    // next upload overwrites it anyway.
    await _db.from('profiles').update({'avatar_url': null}).eq('id', user.id);
    final was = _me;
    if (was != null) _me = was.copyWith(clearAvatar: true);

    try {
      await _db.storage.from('avatars').remove(['${user.id}/photo.jpg']);
    } on Object catch (error) {
      debugPrint('Could not delete the photo file: $error');
    }
  }

  // An anonymous session's own email reads as "", not null — Supabase's
  // shape for "there is no email", not this getter's. Checked for content,
  // not just presence, or every anonymous account would read as real.
  @override
  bool get hasRealAccount => (_db.auth.currentUser?.email ?? '').isNotEmpty;

  @override
  String? get accountEmail {
    final email = _db.auth.currentUser?.email;
    return (email == null || email.isEmpty) ? null : email;
  }

  @override
  Future<EmailSignUpResult> startEmailSignUp({required String email}) async {
    try {
      // Updates the session already signed in, anonymous or not — never a
      // fresh account. Doing this as a second `signUp` would leave the
      // reps already counted on the account nobody is looking at any more.
      await _db.auth.updateUser(UserAttributes(email: email));
      return EmailSignUpResult.ok;
    } on AuthRetryableFetchException catch (_) {
      return EmailSignUpResult.offline;
    } on AuthException catch (error) {
      debugPrint(
        'startEmailSignUp failed: code=${error.code} status=${error.statusCode} '
        'message=${error.message}',
      );
      if (error.code == 'email_exists' || error.code == 'user_already_exists') {
        return EmailSignUpResult.taken;
      }
      if (error.code == 'over_email_send_rate_limit') {
        return EmailSignUpResult.rateLimited;
      }
      return EmailSignUpResult.invalid;
    }
  }

  @override
  Future<bool> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      // Always an email change to GoTrue, even for a first email — the
      // session already exists (anonymous or not) before [startEmailSignUp]
      // ever runs, so this was never the unauthenticated signup flow.
      await _db.auth.verifyOTP(
        type: OtpType.emailChange,
        email: email,
        token: code,
      );
      return true;
    } on AuthRetryableFetchException {
      // Not a wrong code: the screen says the server could not be reached.
      rethrow;
    } on AuthException catch (_) {
      return false;
    }
  }

  @override
  Future<void> resendEmailCode(String email) async {
    await _db.auth.resend(type: OtpType.emailChange, email: email);
  }

  /// Whether [email] is App Review's account. Its inbox is nobody's, so it is
  /// never sent a code: the code typed for it is the account's password —
  /// six digits, set on the account in the Supabase dashboard and given to
  /// Apple with the submission. Every other account signs in only with a
  /// code from its own inbox.
  bool _isReviewAccount(String email) =>
      email.trim().toLowerCase() == kReviewEmail;

  @override
  Future<EmailLoginCodeResult> requestLoginCode(String email) async {
    if (_isReviewAccount(email)) return EmailLoginCodeResult.ok;
    try {
      // Never creates an account — signing in needs one to already exist,
      // unlike [startEmailSignUp].
      await _db.auth.signInWithOtp(email: email, shouldCreateUser: false);
      return EmailLoginCodeResult.ok;
    } on AuthRetryableFetchException catch (_) {
      return EmailLoginCodeResult.offline;
    } on AuthException catch (error) {
      if (error.code == 'over_email_send_rate_limit') {
        return EmailLoginCodeResult.rateLimited;
      }
      return EmailLoginCodeResult.notFound;
    }
  }

  @override
  Future<bool> verifyLoginCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = _isReviewAccount(email)
          ? await _db.auth.signInWithPassword(
              email: kReviewEmail,
              password: code,
            )
          : await _db.auth.verifyOTP(
              type: OtpType.email,
              email: email,
              token: code,
            );
      final user = response.user;
      if (user == null) return false;

      // A different account than whatever this device held before, if
      // any — a fresh session, not one this row was already read for.
      //
      // Made here if it is missing: an account added in the dashboard, like
      // App Review's, has never been through the app's first launch, which
      // is where every other account's row is made.
      final row =
          await _db
              .from('profiles')
              .select()
              .eq('id', user.id)
              .maybeSingle() ??
          await _db
              .from('profiles')
              .insert({
                'id': user.id,
                'username': _unique(
                  _isReviewAccount(email) ? 'reviewer' : 'lifter',
                  user.id,
                ),
                'country': _country,
              })
              .select()
              .single();
      _me = _keep(row);
      return true;
    } on AuthRetryableFetchException {
      // Not a wrong code: the screen says the server could not be reached.
      rethrow;
    } on AuthException catch (_) {
      return false;
    }
  }

  @override
  Future<AccountSummary?> accountSummary() async {
    final rows = await _db.rpc<List<dynamic>>('my_account_summary');
    if (rows.isEmpty) return null;
    final row = rows.first as Map<String, dynamic>;
    return AccountSummary(
      tierIdx: (row['tier_idx'] as num?)?.toInt() ?? 0,
      divIdx: (row['div_idx'] as num?)?.toInt() ?? 0,
      lp: (row['lp'] as num?)?.toInt() ?? 0,
      placementsDone: (row['placements_done'] as num?)?.toInt() ?? 0,
      totalReps: (row['total_reps'] as num?)?.toInt() ?? 0,
      bestSet: (row['best_set'] as num?)?.toInt() ?? 0,
      friends: (row['friends'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<Map<String, dynamic>> myData() async =>
      await _db.rpc<Map<String, dynamic>>('my_data');

  @override
  Future<void> emailMyData(String address) async {
    // An edge function, because sending it needs a key that must never be
    // on a phone. The app hands over an address and nothing else.
    await _db.functions.invoke('email-my-data', body: {'to': address});
  }

  @override
  Future<void> signOut() async {
    await _db.auth.signOut();
    _me = null;
    await _forgetKept();
  }

  @override
  Future<void> syncSubscription() async {
    // The function reads whose subscription it is from this session's
    // token, never from anything sent with it — so there is nothing to
    // send, and nobody to send it for without a session.
    if (_db.auth.currentSession == null) return;
    await _db.functions.invoke('revenuecat-webhook');
  }

  @override
  Future<void> registerPushToken(
    String token, {
    required String platform,
    required String language,
  }) async {
    await _db.rpc<void>(
      'register_push_token',
      params: {
        'push_token': token,
        'push_platform': platform,
        'push_language': language,
      },
    );
  }

  @override
  Future<void> forgetPushToken(String token) async {
    await _db.rpc<void>('forget_push_token', params: {'push_token': token});
  }

  // ── Live matches ──

  static LiveOpponent _opponentFrom(Map<String, dynamic> row, String prefix) =>
      LiveOpponent(
        id: row['${prefix}_id'] as String,
        username: row['${prefix}_name'] as String? ?? '',
        tierIdx: (row['${prefix}_tier'] as num?)?.toInt() ?? 0,
        divIdx: (row['${prefix}_div'] as num?)?.toInt() ?? 0,
        avatarUrl: row['${prefix}_avatar'] as String?,
        xp: (row['${prefix}_xp'] as num?)?.toInt() ?? 0,
      );

  static Duration? _ms(Object? value) =>
      value is num ? Duration(milliseconds: value.toInt()) : null;

  @override
  Future<LiveMatch?> findLiveOpponent() async {
    final rows = await _db.rpc<List<dynamic>>('find_live_opponent');
    if (rows.isEmpty) return null;
    final row = rows.first as Map<String, dynamic>;
    return LiveMatch(
      id: row['match_id'] as String,
      ranked: true,
      opponent: _opponentFrom(row, 'opponent'),
    );
  }

  @override
  Future<void> leaveLiveQueue() async {
    await _db.rpc<void>('leave_live_queue');
  }

  @override
  Future<LiveOnline?> liveOnline() async {
    final rows = await _db.rpc<List<dynamic>>('live_online');
    if (rows.isEmpty) return null;
    final row = rows.first as Map<String, dynamic>;
    return LiveOnline(
      searching: (row['searching'] as num?)?.toInt() ?? 0,
      online: (row['online'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<String> inviteLive(String friendId) async =>
      await _db.rpc<String>('invite_live', params: {'friend_id': friendId});

  @override
  Future<List<LiveInvite>> liveInvites() async {
    final rows = await _db.rpc<List<dynamic>>('my_live_invites');
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        LiveInvite(
          matchId: row['match_id'] as String,
          from: _opponentFrom(row, 'from'),
          expiresIn: _ms(row['expires_in_ms']) ?? Duration.zero,
          ranked: row['ranked'] as bool? ?? false,
        ),
    ];
  }

  @override
  Future<LiveStatus> answerLiveInvite(
    String matchId, {
    required bool accept,
  }) async => LiveStatus.parse(
    await _db.rpc<String>(
      'answer_live_invite',
      params: {'invite': matchId, 'accept': accept},
    ),
  );

  @override
  Future<void> cancelLiveInvite(String matchId) async {
    await _db.rpc<void>('cancel_live_invite', params: {'invite': matchId});
  }

  @override
  Future<LiveRematch> rematchLive(String afterMatchId) async {
    final rows = await _db.rpc<List<dynamic>>(
      'rematch_live',
      params: {'after': afterMatchId},
    );
    if (rows.isEmpty) throw StateError('the rematch came back empty');
    final row = rows.first as Map<String, dynamic>;
    return LiveRematch(
      matchId: row['match_id'] as String,
      status: LiveStatus.parse(row['match_status'] as String?),
      ranked: row['is_ranked'] as bool? ?? false,
    );
  }

  @override
  Future<RematchPresence> liveResultPresence(
    String afterMatchId, {
    bool leaving = false,
  }) async {
    final where = await _db.rpc<String>(
      'live_result_presence',
      params: {'after': afterMatchId, 'leaving': leaving},
    );
    return switch (where) {
      'left' => RematchPresence.left,
      'waiting' => RematchPresence.waiting,
      _ => RematchPresence.here,
    };
  }

  @override
  Future<LiveState> liveState(String matchId) async {
    final rows = await _db.rpc<List<dynamic>>(
      'live_match_state',
      params: {'live': matchId},
    );
    if (rows.isEmpty) throw StateError('no such live match');
    final row = rows.first as Map<String, dynamic>;
    return LiveState(
      status: LiveStatus.parse(row['match_status'] as String?),
      ranked: row['is_ranked'] as bool? ?? false,
      opponent: _opponentFrom(row, 'opponent'),
      theyAreReady: row['they_are_ready'] as bool? ?? false,
      theirReps: (row['their_reps'] as num?)?.toInt() ?? 0,
      startsIn: _ms(row['starts_in_ms']),
      expiresIn: _ms(row['expires_in_ms']),
    );
  }

  @override
  Future<Duration?> liveReady(String matchId) async =>
      _ms(await _db.rpc<dynamic>('live_ready', params: {'live': matchId}));

  @override
  Future<void> reportLiveCount(String matchId, int reps) async {
    await _db.rpc<void>(
      'report_live_count',
      params: {'live': matchId, 'reps_now': reps},
    );
  }

  LiveFinish _finishFrom(List<dynamic> rows) {
    if (rows.isEmpty) return const LiveFinish();
    final row = rows.first as Map<String, dynamic>;
    if (row['is_settled'] != true) return const LiveFinish();
    int n(String key) => (row[key] as num?)?.toInt() ?? 0;
    final settled = SettledDuel(
      duelId: row['result_duel'] as String,
      won: row['result_won'] as bool? ?? false,
      lpDelta: n('result_lp_delta'),
      tierIdx: n('result_tier'),
      divIdx: n('result_div'),
      lp: n('result_lp'),
      wins: n('result_wins'),
      losses: n('result_losses'),
      winStreak: n('result_win_streak'),
      bestStreak: n('result_best_streak'),
      placementsDone: n('result_placements_done'),
      placementWins: n('result_placement_wins'),
      ranked: row['result_ranked'] as bool? ?? true,
    );
    _remember(settled);
    return LiveFinish(
      settled: settled,
      theirReps: (row['result_their_reps'] as num?)?.toInt(),
    );
  }

  @override
  Future<LiveFinish> finishLive(String matchId, SetUpload set) async =>
      _finishFrom(
        await _db.rpc<List<dynamic>>(
          'finish_live_match',
          params: {
            'live': matchId,
            'set_reps': set.reps,
            'set_reps_camera': set.repsCamera,
            'set_depth': set.depth,
            'set_confident': set.confident,
            'set_duration_ms': set.durationMs < 1 ? 1 : set.durationMs,
            'set_gave_up': set.gaveUp,
            'set_rep_times': set.repTimes,
          },
        ),
      );

  @override
  Future<LiveFinish> liveResult(String matchId) async => _finishFrom(
    await _db.rpc<List<dynamic>>(
      'live_match_result',
      params: {'live': matchId},
    ),
  );

  @override
  LiveLink openLiveLink(String matchId) => _RealtimeLiveLink(_db, matchId);

  @override
  Future<bool> signedInWithApple() async {
    final user = (await _db.auth.getUser()).user ?? _db.auth.currentUser;
    final providers = user?.appMetadata['providers'];
    return (user?.identities?.any((i) => i.provider == 'apple') ?? false) ||
        (providers is List && providers.contains('apple'));
  }

  @override
  Future<void> revokeAppleSignIn(String authorizationCode) async {
    final response = await _db.functions.invoke(
      'revoke-apple',
      body: {'code': authorizationCode},
    );
    if (response.status != 200) {
      throw StateError('Apple sign-in not revoked: ${response.data}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    // The photo first, while this session can still prove it owns the file.
    // Deleting the account does not reach storage, and the bucket is public,
    // so a photo left behind stays readable by anyone with its URL. Storage
    // refuses deletes from SQL, which is why this is not in the function.
    final id = _db.auth.currentUser?.id;
    if (id != null) {
      try {
        await _db.storage.from('avatars').remove(['$id/photo.jpg']);
      } on Object catch (error) {
        // No photo to remove is the usual case, not a reason to keep an
        // account its owner asked to delete.
        debugPrint('Could not remove avatar: $error');
      }
    }
    await _db.rpc<void>('delete_my_account');
    await _db.auth.signOut();
    _me = null;
    await _forgetKept();
  }

  RemotePrefs _prefsFrom(Map<String, dynamic> row) => RemotePrefs(
    challengeable: switch (row['challengeable'] as String?) {
      'friends' => Challengeable.friends,
      'nobody' => Challengeable.nobody,
      _ => Challengeable.everyone,
    },
    showOnBoard: row['show_on_board'] as bool? ?? true,
    showCountry: row['show_country'] as bool? ?? true,
    notifyRaced: row['notify_raced'] as bool? ?? true,
    notifyChallenged: row['notify_challenged'] as bool? ?? true,
    notifyLiveInvite: row['notify_live_invite'] as bool? ?? true,
    notifyFriendRequest: row['notify_friend_request'] as bool? ?? true,
    notifyFriendOk: row['notify_friend_ok'] as bool? ?? true,
  );

  RemoteProfile _withPrefs(RemoteProfile was, RemotePrefs prefs) =>
      was.copyWith(prefs: prefs);

  RemoteProfile _profileFrom(Map<String, dynamic> row) => RemoteProfile(
    id: row['id'] as String,
    username: row['username'] as String,
    tierIdx: (row['tier_idx'] as num?)?.toInt() ?? 0,
    divIdx: (row['div_idx'] as num?)?.toInt() ?? 0,
    lp: (row['lp'] as num?)?.toInt() ?? 0,
    friendCode: row['friend_code'] as String,
    country: row['country'] as String?,
    prefs: _prefsFrom(row),
    avatarUrl: row['avatar_url'] as String?,
    // Absent until the server has the column (outrepd-update-1.1.6.sql):
    // select() is every column there is, so an older server reads as none.
    lifter: row['lifter'] is Map
        ? Map<String, dynamic>.from(row['lifter'] as Map)
        : null,
    xp: (row['xp'] as num?)?.toInt() ?? 0,
    usernameChangedAt: DateTime.tryParse(
      row['username_changed_at'] as String? ?? '',
    ),
    countryChangedAt: DateTime.tryParse(
      row['country_changed_at'] as String? ?? '',
    ),
    peakTierIdx: (row['peak_tier_idx'] as num?)?.toInt() ?? 0,
    wins: (row['wins'] as num?)?.toInt() ?? 0,
    losses: (row['losses'] as num?)?.toInt() ?? 0,
    winStreak: (row['win_streak'] as num?)?.toInt() ?? 0,
    bestStreak: (row['best_streak'] as num?)?.toInt() ?? 0,
    placementsDone: (row['placements_done'] as num?)?.toInt() ?? 0,
    placementWins: (row['placement_wins'] as num?)?.toInt() ?? 0,
    totalReps: (row['total_reps'] as num?)?.toInt() ?? 0,
    bestSet: (row['best_set'] as num?)?.toInt() ?? 0,
  );

  /// Usernames are unique on the server, and the app lets people pick one
  /// before it has ever spoken to it. A collision must not cost somebody their
  /// account on first launch, so the name gets a short tail and the lifter can
  /// change it afterwards.
  String _unique(String username, String id) {
    final trimmed = username.trim();
    final base = trimmed.isEmpty ? 'lifter' : trimmed;
    return base.length > 14
        ? '${base.substring(0, 14)}${id.substring(0, 4)}'
        : '$base${id.substring(0, 4)}';
  }
}

/// The two phones' line, over a Supabase Realtime broadcast channel named
/// after the match. Nothing is stored: a message missed is simply replaced by
/// the next one, which carries the whole count rather than a change to it.
class _RealtimeLiveLink implements LiveLink {
  _RealtimeLiveLink(this._db, String matchId)
    : _channel = _db.channel(
        'live:$matchId',
        opts: const RealtimeChannelConfig(self: false),
      ) {
    _channel
        .onBroadcast(
          event: 'count',
          callback: (raw) {
            // The callback has been handed both the whole envelope and just
            // the payload across versions of the client; read either.
            final inner = raw['payload'];
            final json = inner is Map
                ? Map<String, dynamic>.from(inner)
                : Map<String, dynamic>.from(raw);
            final message = LiveMessage.fromJson(json);
            if (message != null && !_messages.isClosed) {
              _messages.add(message);
            }
          },
        )
        .subscribe();
  }

  final SupabaseClient _db;
  final RealtimeChannel _channel;
  final _messages = StreamController<LiveMessage>.broadcast();

  @override
  Stream<LiveMessage> get messages => _messages.stream;

  @override
  Future<void> send(LiveMessage message) async {
    await _channel.sendBroadcastMessage(
      event: 'count',
      payload: message.toJson(),
    );
  }

  @override
  Future<void> close() async {
    await _messages.close();
    await _db.removeChannel(_channel);
  }
}
