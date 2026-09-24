/// Does the server compute the same LP the app just showed somebody?
///
/// The app works out a duel's LP to *display* it — before the round on the VS
/// card, after it on the breakdown — and the server works it out to *apply*
/// it. Two implementations of one rule drift, and a running system would never
/// notice: the lifter is shown one number, given another, and has no way to
/// tell which was wrong.
///
/// So this replays every generated case through the real project and compares.
/// It needs nothing but the anon key, which is the same key the app ships
/// with, and it skips rather than fails when there is no server to ask —
/// otherwise the suite would go red on a train.
///
///   flutter test test/ladder_server_test.dart \
///     --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _url = String.fromEnvironment('SUPABASE_URL');
const _key = String.fromEnvironment('SUPABASE_ANON_KEY');

const _vectors = 'supabase/ladder_vectors.json';

void main() {
  late Map<String, dynamic> vectors;

  setUpAll(() {
    final file = File(_vectors);
    if (file.existsSync()) {
      vectors = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    } else {
      vectors = const {};
    }
  });

  /// Calls a Postgres function through PostgREST.
  Future<List<dynamic>?> rpc(String name, Map<String, Object?> args) async {
    final client = HttpClient();
    try {
      final request =
          await client.postUrl(Uri.parse('$_url/rest/v1/rpc/$name'));
      request.headers
        ..set('apikey', _key)
        ..set('Authorization', 'Bearer $_key')
        ..set('Content-Type', 'application/json');
      request.write(jsonEncode(args));

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        // A missing function means the SQL has not been applied yet, which is
        // a state worth reporting clearly rather than failing on.
        // ignore: avoid_print
        print('$name → ${response.statusCode} $body');
        return null;
      }
      final decoded = jsonDecode(body);
      return decoded is List ? decoded : [decoded];
    } on Object catch (error) {
      // ignore: avoid_print
      print('could not reach the server: $error');
      return null;
    } finally {
      client.close();
    }
  }

  test('the server pays what the app promised', () async {
    if (_url.isEmpty || _key.isEmpty) {
      // ignore: avoid_print
      print('no server configured — pass --dart-define=SUPABASE_URL and '
          'SUPABASE_ANON_KEY to check the ladder against it');
      return;
    }

    final cases = (vectors['lp_for'] as List?) ?? const [];
    expect(cases, isNotEmpty,
        reason: 'run test/ladder_vectors_test.dart first');

    // One probe before the whole grid: if the functions are not installed,
    // say so once rather than four hundred times.
    final probe = await rpc('lp_for', {
      'won': true,
      'your_tier': 0,
      'their_tier': 0,
      'your_reps': 0,
      'their_reps': 0,
      'clean': false,
    });
    if (probe == null) {
      // ignore: avoid_print
      print('the ladder functions are not installed on this project yet — '
          'paste supabase/install.sql into the SQL editor and re-run');
      return;
    }

    final disagreements = <String>[];
    for (final row in cases.cast<Map<String, dynamic>>()) {
      final got = await rpc('lp_for', {
        'won': row['won'],
        'your_tier': row['your_tier'],
        'their_tier': row['their_tier'],
        'your_reps': row['your_reps'],
        'their_reps': row['their_reps'],
        'clean': row['clean'],
        'surrendered': row['surrendered'],
      });
      if (got == null || got.isEmpty) {
        disagreements.add('$row → no answer');
        continue;
      }
      final r = got.first as Map<String, dynamic>;
      for (final field in ['result', 'tier_gap', 'margin', 'form', 'total']) {
        if (r[field] != row[field]) {
          disagreements.add(
              '$field: app ${row[field]} server ${r[field]} for $row');
        }
      }
      if (disagreements.length > 8) break;
    }

    expect(disagreements, isEmpty,
        reason: 'the server and the app disagree:\n'
            '${disagreements.join('\n')}');
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('the server moves a rank the way the app says it will', () async {
    if (_url.isEmpty || _key.isEmpty) return;

    final cases = (vectors['apply_lp'] as List?) ?? const [];
    if (cases.isEmpty) return;

    final probe = await rpc('apply_lp', {
      'from_tier': 0,
      'from_div': 0,
      'from_lp': 0,
      'delta': 0,
      'floor_tier': 0,
    });
    if (probe == null) return;

    final disagreements = <String>[];
    for (final row in cases.cast<Map<String, dynamic>>()) {
      final got = await rpc('apply_lp', {
        'from_tier': row['from_tier'],
        'from_div': row['from_div'],
        'from_lp': row['from_lp'],
        'delta': row['delta'],
        'floor_tier': row['floor_tier'],
      });
      if (got == null || got.isEmpty) {
        disagreements.add('$row → no answer');
        continue;
      }
      final r = got.first as Map<String, dynamic>;
      for (final field in ['tier_idx', 'div_idx', 'lp']) {
        if (r[field] != row[field]) {
          disagreements.add(
              '$field: app ${row[field]} server ${r[field]} for $row');
        }
      }
      if (disagreements.length > 8) break;
    }

    expect(disagreements, isEmpty,
        reason: 'the server and the app disagree:\n'
            '${disagreements.join('\n')}');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
