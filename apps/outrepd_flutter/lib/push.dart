/// Push notifications: word on the phone, with the app closed, when somebody
/// races your set, asks to be friends, accepts, or wants a rematch.
///
/// The server decides what is worth a push — every notice it stores is sent
/// (supabase/push.sql, functions/push) — and the switches under Settings →
/// Notifications stop it storing a kind at all, so they stop its push too.
/// This file only tells the server where this phone is, asks once whether it
/// may show notifications, and opens the notices when one is tapped.
library;

import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart';
import 'firebase.dart';
import 'l10n/app_localizations.dart';
import 'settings.dart';

class Push {
  Push._();

  static final instance = Push._();

  /// Bumped when a push is tapped. The app, once past the paywall, opens the
  /// notices for it — not before, so a push is never a way around it.
  final openNotices = ValueNotifier<int>(0);

  /// Bumped when a push arrives with the app open. Android does not draw it
  /// then, so the bell's dot is what has to catch up.
  final arrived = ValueNotifier<int>(0);

  String? _token;
  String? _registeredLanguage;
  StreamSubscription<String>? _tokenRefresh;
  bool _listening = false;

  bool get _ready => firebaseReady && backend.available;

  /// Tells the server where this phone is, for whoever is signed in. Called
  /// each time somebody gets into the app; does nothing in a build without
  /// Firebase, or with no server, or with nobody signed in.
  Future<void> start() async {
    if (!_ready || backend.me == null) return;
    try {
      final messaging = FirebaseMessaging.instance;
      _listen(messaging);
      final token = await messaging.getToken();
      if (token != null) await _register(token);
      _tokenRefresh ??= messaging.onTokenRefresh.listen(_register);
    } on Object catch (error) {
      debugPrint('Push is not available: $error');
    }
  }

  void _listen(FirebaseMessaging messaging) {
    if (_listening) return;
    _listening = true;
    FirebaseMessaging.onMessageOpenedApp.listen((_) => openNotices.value++);
    FirebaseMessaging.onMessage.listen((_) => arrived.value++);
    // The push that launched the app from closed, if one did.
    unawaited(
      messaging.getInitialMessage().then((message) {
        if (message != null) openNotices.value++;
      }),
    );
    // The server writes each push in this phone's language, so a change of
    // language has to reach it.
    settings.addListener(_languageMaybeChanged);
  }

  Future<void> _register(String token) async {
    _token = token;
    if (backend.me == null) return;
    final language = appLanguageCode();
    try {
      await backend.registerPushToken(
        token,
        platform: Platform.isIOS ? 'ios' : 'android',
        language: language,
      );
      _registeredLanguage = language;
    } on Object catch (error) {
      debugPrint('Could not register for push: $error');
    }
  }

  void _languageMaybeChanged() {
    final token = _token;
    if (token == null || appLanguageCode() == _registeredLanguage) return;
    unawaited(_register(token));
  }

  /// Before signing out or deleting the account: this phone stops getting
  /// the account's notices, and the next account on it gets a fresh address.
  Future<void> stop() async {
    final token = _token;
    _token = null;
    _registeredLanguage = null;
    if (token == null || !_ready) return;
    try {
      await backend.forgetPushToken(token);
    } on Object catch (error) {
      debugPrint('Could not forget the push token: $error');
    }
    try {
      await FirebaseMessaging.instance.deleteToken();
    } on Object catch (error) {
      debugPrint('Could not delete the push token: $error');
    }
  }
}

/// Where notifications can be shown at all: a phone, outside a test.
bool get notificationsPossible =>
    !kIsWeb &&
    !Platform.environment.containsKey('FLUTTER_TEST') &&
    (Platform.isAndroid || Platform.isIOS);

/// Asks, once per install, whether the app may show notifications — the
/// matches and friends pushes and the daily reminder alike. Android 13 and
/// later refuse to show any until this is answered.
Future<void> askForNotificationsOnce() async {
  if (!notificationsPossible) return;
  try {
    final store = await SharedPreferences.getInstance();
    if (store.getBool('askedNotifications') ?? false) return;
    await store.setBool('askedNotifications', true);

    if (Platform.isAndroid) {
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } else if (firebaseReady) {
      await FirebaseMessaging.instance.requestPermission();
    } else {
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  } on Object catch (error) {
    debugPrint('Could not ask about notifications: $error');
  }
}

/// Whether this phone lets the app show notifications. Null when it cannot
/// be told, which is never a reason to nag.
Future<bool?> notificationsAllowed() async {
  if (!notificationsPossible || !Platform.isAndroid) return null;
  try {
    return await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.areNotificationsEnabled();
  } on Object catch (_) {
    return null;
  }
}

/// The language notifications are written in: the one chosen in settings,
/// or the phone's own when the app follows the phone, or English when the
/// app has no translation for it.
String appLanguageCode() {
  final chosen =
      settings.language.locale?.languageCode ??
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  return L.supportedLocales.any((l) => l.languageCode == chosen)
      ? chosen
      : 'en';
}
