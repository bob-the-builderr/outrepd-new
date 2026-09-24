/// The Supabase implementation of [Backend].
///
/// Thin on purpose. Everything that decides an outcome — who won, what it
/// pays, where it leaves both ranks — happens in `supabase/duel.sql`, because
/// this file runs on a phone in somebody else's hands. What is left here is
/// carrying rows there and back.
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'backend.dart';

/// Supplied at build time, never committed:
///
///   flutter build apk --release \
///     --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
const kSupabaseUrl = String.fromEnvironment('SUPABASE_URL');
const kSupabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

/// Where Supabase sends the browser back to once an Apple or Google
/// identity-link, or a password-reset email's link, finishes. Registered
/// three places at once, or the hand-off never completes: this app's own
/// manifest (the OS has to know to reopen the app on it), Supabase's
/// dashboard (it refuses to redirect anywhere unlisted), and the identity
/// provider's own console for the OAuth case specifically (the redirect it
/// is told to send the browser to is Supabase's callback, not this one, but
/// the provider still has to be told which app it is signing into).
const kAuthCallback = 'outrepd://login-callback';

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
    );
    backend = SupabaseBackend(Supabase.instance.client);
  } on Object catch (error) {
    debugPrint('Could not reach the server: $error');
  }
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
    // not yet been given a reason to hand over an email. Supabase can link
    // this account to Apple or Google later without losing what it earned.
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

    return _me = _profileFrom(row);
  }

  /// Where this phone says it is, as a two-letter code.
  ///
  /// Read off the device rather than asked for. Nobody installs a push-up app
  /// to fill in a country field, and a board that quietly works is worth more
  /// than one more question during sign-up.
  static String? get _country {
    final locale = PlatformDispatcher.instance.locale;
    final code = locale.countryCode;
    return (code == null || code.isEmpty) ? null : code.toUpperCase();
  }

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
          'duration_ms': set.durationMs,
          'gave_up': set.gaveUp,
          'rep_times': set.repTimes,
          'challenge_target': set.challengeTarget,
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
    );

    // What came back is the rank now. The app recomputes the same numbers to
    // show them, and where the two ever disagree the server is right — it is
    // the one holding the row.
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
    return settled;
  }

  @override
  Future<List<BoardRow>> leaderboard({int limit = 100, String? country}) async {
    // Through the function rather than the table. It is the one place that
    // knows who asked to be left off a board, and a filter the client adds
    // is a filter the client can drop.
    final rows = await _db.rpc<List<dynamic>>(
      'leaderboard',
      params: {'in_country': country, 'limit_to': limit},
    );

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
  Future<AskResult> askFriend(String username) async {
    final answer = await _db.rpc<String>(
      'request_friend',
      params: {'their_name': username},
    );
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
              DateTime.tryParse(
                row['muted_at'] as String? ?? '',
              )?.toLocal() ??
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
  Future<RenameResult> renameUsername(String name) async {
    final result = await _db.rpc<String>(
      'set_my_username',
      params: {'new_name': name},
    );
    if (result != 'ok') {
      return switch (result) {
        'taken' => RenameResult.taken,
        'already_changed' => RenameResult.alreadyChanged,
        _ => RenameResult.invalid,
      };
    }

    final was = _me;
    if (was != null) {
      _me = was.copyWith(username: name.trim(), usernameChangedAt: DateTime.now());
    }
    return RenameResult.ok;
  }

  @override
  Future<String> uploadAvatar(Uint8List bytes) async {
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
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
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
  Future<EmailSignUpResult> startEmailSignUp({
    required String email,
    required String password,
  }) async {
    try {
      // Updates the session already signed in, anonymous or not — never a
      // fresh account. Doing this as a second `signUp` would leave the
      // reps already counted on the account nobody is looking at any more.
      await _db.auth.updateUser(
        UserAttributes(email: email, password: password),
      );
      return EmailSignUpResult.ok;
    } on AuthException catch (error) {
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
    } on AuthException catch (_) {
      return false;
    }
  }

  @override
  Future<void> resendEmailCode(String email) async {
    await _db.auth.resend(type: OtpType.emailChange, email: email);
  }

  @override
  Future<EmailSignInResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _db.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) return EmailSignInResult.wrongCredentials;

      // A real account always passed through anonymous sign-in first, so
      // the row already exists — this is a lookup, never an insert.
      final row = await _db
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      _me = _profileFrom(row);
      return EmailSignInResult.ok;
    } on AuthException catch (_) {
      return EmailSignInResult.wrongCredentials;
    }
  }

  @override
  Future<bool> linkSocial(SocialProvider provider) {
    final oauth = switch (provider) {
      SocialProvider.apple => OAuthProvider.apple,
      SocialProvider.google => OAuthProvider.google,
    };
    return _db.auth.linkIdentity(oauth, redirectTo: kAuthCallback);
  }

  @override
  Stream<void> get authStateChanges => _db.auth.onAuthStateChange;

  @override
  Future<void> requestPasswordReset(String email) =>
      _db.auth.resetPasswordForEmail(email, redirectTo: kAuthCallback);

  @override
  Stream<void> get passwordRecoveryRequested => _db.auth.onAuthStateChange
      .where((state) => state.event == AuthChangeEvent.passwordRecovery);

  @override
  Future<void> setNewPassword(String password) =>
      _db.auth.updateUser(UserAttributes(password: password));

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
  Future<void> deleteAccount() async {
    await _db.rpc<void>('delete_my_account');
    await _db.auth.signOut();
    _me = null;
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
    country: row['country'] as String?,
    prefs: _prefsFrom(row),
    avatarUrl: row['avatar_url'] as String?,
    usernameChangedAt: DateTime.tryParse(
      row['username_changed_at'] as String? ?? '',
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
