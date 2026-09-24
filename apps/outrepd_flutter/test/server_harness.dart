/// Talking to the real server from a test.
///
/// Shared by every `*_server_test.dart`, because the alternative is a second
/// copy of the HTTP plumbing that drifts from the first — and a test harness
/// that lies is worse than no test.
///
/// **Run the server suites one at a time.** `flutter test` runs suites in
/// parallel, and two of these at once create accounts faster than Supabase
/// allows, which comes back as a wall of 429s that look like failures:
///
///   flutter test --concurrency=1 \
///     test/duel_server_test.dart test/social_server_test.dart \
///     --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
///
/// Every account it creates is named `t_…` so the rows it leaves behind are
/// easy to find and clear out:
///
///   delete from auth.users
///   where id in (select id from public.profiles
///                 where username like 't\_%' escape '\');
library;

import 'dart:convert';
import 'dart:io';

const serverUrl = String.fromEnvironment('SUPABASE_URL');
const serverKey = String.fromEnvironment('SUPABASE_ANON_KEY');

/// True when keys were supplied. Without them a server test has nothing to
/// talk to and says so rather than failing.
bool get serverConfigured => serverUrl.isNotEmpty && serverKey.isNotEmpty;

/// One signed-in account, and everything it can do.
class Lifter {
  Lifter(this.token, this.id, this.username);

  final String token;
  final String id;
  final String username;

  static Future<Lifter> signUp(String username) async {
    final session = await post('/auth/v1/signup', {}, null);
    final token = session['access_token'] as String;
    final id = (session['user'] as Map<String, dynamic>)['id'] as String;

    // No `Prefer: return=representation`, so PostgREST answers 201 with an
    // empty body. There is nothing to read back — the row is the id we just
    // sent.
    await send('POST', '/rest/v1/profiles', {
      'id': id,
      'username': username,
    }, token);
    return Lifter(token, id, username);
  }

  Future<String> uploadSet({
    required int reps,
    int? camera,
    double depth = 0.9,
    bool confident = true,
    bool gaveUp = false,
    List<int> repTimes = const [],
    String? challengeTarget,
  }) async {
    final row = await post(
      '/rest/v1/sets',
      {
        'profile_id': id,
        'reps': reps,
        'reps_camera': camera ?? reps,
        'depth': depth,
        'confident': confident,
        'duration_ms': 60000,
        'gave_up': gaveUp,
        'rep_times': repTimes,
        'challenge_target': challengeTarget,
      },
      token,
      prefer: 'return=representation',
    );
    return row['id'] as String;
  }

  Future<Map<String, dynamic>?> findOpponent() async {
    final rows = await postList('/rest/v1/rpc/find_opponent_set', {}, token);
    return rows.isEmpty ? null : rows.first as Map<String, dynamic>;
  }

  /// The set [them] reserved for this account with a rematch challenge, or
  /// null if there is not one.
  Future<Map<String, dynamic>?> findTargetedOpponent(String them) async {
    final rows = await postList('/rest/v1/rpc/find_targeted_set', {
      'from_id': them,
    }, token);
    return rows.isEmpty ? null : rows.first as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> settle(
    String mySet,
    String theirSet, {
    bool ranked = true,
  }) async {
    final rows = await postList('/rest/v1/rpc/settle_duel', {
      'my_set': mySet,
      'their_set': theirSet,
      'ranked': ranked,
    }, token);
    return rows.first as Map<String, dynamic>;
  }

  Future<bool> usernameAvailable(String name) async {
    final answer = await send('POST', '/rest/v1/rpc/username_available', {
      'name': name,
    }, token);
    return answer as bool;
  }

  Future<String> renameUsername(String name) async {
    final answer = await send('POST', '/rest/v1/rpc/set_my_username', {
      'new_name': name,
    }, token);
    return answer is String ? answer : answer.toString();
  }

  Future<Map<String, dynamic>> profile() async {
    final rows = await getList('/rest/v1/profiles?id=eq.$id&select=*', token);
    return rows.first as Map<String, dynamic>;
  }

  /// Plays a whole ranked duel against [them] and returns who won, so a test
  /// that only needs a finished duel does not have to spell one out.
  Future<bool> duel(
    Lifter them, {
    required int mine,
    required int theirs,
  }) async {
    final theirSet = await them.uploadSet(reps: theirs);
    final mySet = await uploadSet(reps: mine);
    final settled = await settle(mySet, theirSet);
    return settled['won'] as bool;
  }

  // ─────────────────────────────── friends ──────────────────────────────

  Future<String> askFriend(String theirName) async {
    final answer = await send('POST', '/rest/v1/rpc/request_friend', {
      'their_name': theirName,
    }, token);
    return answer is String ? answer : answer.toString();
  }

  Future<String> answerFriend(String theirId, {required bool accept}) async {
    final answer = await send('POST', '/rest/v1/rpc/answer_friend', {
      'their_id': theirId,
      'accept': accept,
    }, token);
    return answer is String ? answer : answer.toString();
  }

  Future<List<dynamic>> friends() =>
      postList('/rest/v1/rpc/my_friends', {}, token);

  Future<List<dynamic>> requests() =>
      postList('/rest/v1/rpc/friend_requests', {}, token);

  Future<List<dynamic>> findLifters(String query) =>
      postList('/rest/v1/rpc/find_lifters', {'query': query}, token);

  /// Every friendship row this account can see at all, straight off the
  /// table rather than through a function — which is what a client poking
  /// around would do.
  Future<List<dynamic>> rawFriendships() =>
      getList('/rest/v1/friendships?select=*', token);

  Future<List<dynamic>> notices() =>
      postList('/rest/v1/rpc/my_notifications', {}, token);

  Future<int> unreadNotices() async {
    final answer = await send(
      'POST',
      '/rest/v1/rpc/unread_notifications',
      {},
      token,
    );
    return (answer as num).toInt();
  }

  Future<void> readNotices() =>
      send('POST', '/rest/v1/rpc/read_notifications', {}, token);

  /// The board, exactly as the app asks for it.
  Future<List<dynamic>> board({String? country, int limit = 500}) => postList(
    '/rest/v1/rpc/leaderboard',
    {'in_country': country, 'limit_to': limit},
    token,
  );

  /// Where this account stands on it, or null when it is not on one.
  Future<int?> boardPosition({String? country}) async {
    final answer = await send(
      'POST',
      '/rest/v1/rpc/my_board_place',
      {'in_country': country},
      token,
    );
    return answer == null ? null : (answer as num).toInt();
  }

  // ─────────────────────────── blocks and reports ────────────────────────

  Future<String> block(String theirId) async {
    final answer = await send(
      'POST',
      '/rest/v1/rpc/block_lifter',
      {'their_id': theirId},
      token,
    );
    return answer is String ? answer : answer.toString();
  }

  Future<String> unblock(String theirId) async {
    final answer = await send(
      'POST',
      '/rest/v1/rpc/unblock_lifter',
      {'their_id': theirId},
      token,
    );
    return answer is String ? answer : answer.toString();
  }

  Future<List<dynamic>> blocks() =>
      postList('/rest/v1/rpc/my_blocks', {}, token);

  /// Straight at the table, which is what a client poking around would do.
  Future<List<dynamic>> rawBlocks() =>
      getList('/rest/v1/blocks?select=*', token);

  Future<void> setPreference(Map<String, Object?> fields) =>
      send('PATCH', '/rest/v1/profiles?id=eq.$id', fields, token);

  Future<void> report(String? theirId, String reason, {String details = ''}) =>
      send('POST', '/rest/v1/reports', {
        'reporter': id,
        'reported': theirId,
        'reason': reason,
        'details': details,
      }, token);

  Future<Map<String, dynamic>> myData() async {
    final answer = await send('POST', '/rest/v1/rpc/my_data', {}, token);
    return answer as Map<String, dynamic>;
  }
}

Future<Map<String, dynamic>> post(
  String path,
  Map<String, Object?> body,
  String? token, {
  String? prefer,
}) async {
  final rows = await send('POST', path, body, token, prefer: prefer);
  if (rows is List) return rows.first as Map<String, dynamic>;
  return rows as Map<String, dynamic>;
}

Future<List<dynamic>> postList(
  String path,
  Map<String, Object?> body,
  String? token,
) async {
  final decoded = await send('POST', path, body, token);
  return decoded is List ? decoded : [decoded];
}

Future<List<dynamic>> getList(String path, String? token) async {
  final decoded = await send('GET', path, null, token);
  return decoded is List ? decoded : [decoded];
}

/// How many times a rate-limited call is retried before giving up.
///
/// Supabase caps anonymous sign-ups, and these tests make an account every
/// few lines. Two suites running at once go through that cap in seconds, and
/// the 429 that comes back says nothing about the code under test — it used
/// to surface as eight unrelated red tests. Backing off and saying plainly
/// what happened is the difference between a signal and noise.
const _rateLimitTries = 4;

Future<dynamic> send(
  String method,
  String path,
  Map<String, Object?>? body,
  String? token, {
  String? prefer,
}) async {
  for (var attempt = 1; ; attempt++) {
    final result = await _sendOnce(method, path, body, token, prefer: prefer);
    if (result is! _RateLimited) return result;

    if (attempt >= _rateLimitTries) {
      throw StateError(
        'The server is rate limiting sign-ups ($method $path). This is the '
        'account quota, not a failure of what the test checks — run the '
        'server suites one at a time:\n'
        '  flutter test --concurrency=1 test/…_server_test.dart …\n'
        'and give it a few minutes if it persists.',
      );
    }
    await Future<void>.delayed(Duration(seconds: 2 << attempt));
  }
}

/// Marks a 429 so [send] can tell "too fast" from a real error.
class _RateLimited {
  const _RateLimited();
}

Future<dynamic> _sendOnce(
  String method,
  String path,
  Map<String, Object?>? body,
  String? token, {
  String? prefer,
}) async {
  final client = HttpClient();
  try {
    final request = await client.openUrl(method, Uri.parse('$serverUrl$path'));
    request.headers
      ..set('apikey', serverKey)
      ..set('Authorization', 'Bearer ${token ?? serverKey}')
      ..set('Content-Type', 'application/json');
    if (prefer != null) request.headers.set('Prefer', prefer);
    if (body != null) request.write(jsonEncode(body));

    final response = await request.close();
    final text = await response.transform(utf8.decoder).join();
    if (response.statusCode == 429) return const _RateLimited();
    if (response.statusCode >= 300) {
      throw HttpException('$method $path → ${response.statusCode} $text');
    }
    return text.isEmpty ? const <dynamic>[] : jsonDecode(text);
  } finally {
    client.close();
  }
}
