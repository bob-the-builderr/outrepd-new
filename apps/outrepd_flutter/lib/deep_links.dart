/// Links into the app: `outrepd.com/u/<name>`, the page an invite or a shared
/// card points at, opens that lifter's card in the app when it is installed
/// rather than the web page.
///
/// Flutter's own deep linking is off (AndroidManifest.xml, Info.plist): it
/// would push the link's path as a route name, and the app has no route
/// called `/u/<name>`. The phone hands the link here instead.
library;

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'backend/backend.dart';
import 'screens/other_profile.dart';

/// The lifter a link names, or null for a link that is not to a lifter.
String? lifterNameFromLink(Uri uri) {
  final host = uri.host.toLowerCase();
  if (host != 'outrepd.com' && host != 'www.outrepd.com') return null;
  final parts = uri.pathSegments.where((p) => p.isNotEmpty).toList();
  if (parts.length != 2 || parts.first != 'u') return null;
  final name = parts.last.trim();
  return name.isEmpty ? null : name;
}

/// Whether this run takes links from the phone: set by main() on a phone,
/// and left off in widget tests and the web preview, which have no platform
/// side for the link channel to talk to.
var deepLinksEnabled = false;

/// Listens for links while the app is open past the paywall, including the
/// one it was opened with. Null when links are off; cancel it to stop.
StreamSubscription<Uri>? listenForLinks(BuildContext Function() context) {
  if (!deepLinksEnabled) return null;
  return AppLinks().uriLinkStream.listen(
    (uri) => _open(context, uri),
    onError: (Object error) => debugPrint('Could not read a link: $error'),
  );
}

Future<void> _open(BuildContext Function() context, Uri uri) async {
  final name = lifterNameFromLink(uri);
  if (name == null || !backend.available) return;
  try {
    final found = await backend.findLifters(name);
    final lifter = found
        .where((f) => f.username.toLowerCase() == name.toLowerCase())
        .firstOrNull;
    // Not found, blocked, or this account's own name: nothing to open.
    if (lifter == null || lifter.id == backend.me?.id) return;
    final at = context();
    if (!at.mounted) return;
    await showLifterPeek(at, id: lifter.id, username: lifter.username);
  } on Object catch (error) {
    debugPrint('Could not open the link: $error');
  }
}
