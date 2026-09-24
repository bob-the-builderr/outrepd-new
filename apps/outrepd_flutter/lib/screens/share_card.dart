/// The card people share to say where they stand.
///
/// Two shapes of the same data — Story, tall enough for a phone's lock
/// screen, and Post, wide enough for a feed — and one sheet that renders
/// whichever is picked to an image and hands it to the OS's own share
/// sheet. Always dark, regardless of the app's own theme: a card is a fixed
/// thing to look at, not a page that should change under a reader who has
/// never opened outrepd.
library;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../widgets.dart';

/// Where the card's own footer points. One place to change if the domain
/// ever does.
const kProfileUrlBase = 'outrepd.com/u/';

/// Everything a share card needs, whether it is drawing your own or
/// somebody else's — both read the same shape.
class ShareCardData {
  const ShareCardData({
    required this.username,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    required this.wins,
    required this.losses,
    required this.bestSet,
    required this.winStreak,
    this.globalPlace,
    this.country,
    this.countryPlace,
    this.avatarUrl,
  });

  final String username;
  final int tierIdx;
  final int divIdx;
  final int lp;
  final int wins;
  final int losses;
  final int bestSet;
  final int winStreak;
  final int? globalPlace;
  final String? country;
  final int? countryPlace;
  final String? avatarUrl;

  String get profileUrl => '$kProfileUrlBase$username';
}

/// Opens the share sheet: a preview of the card, Story/Post to pick the
/// shape, and one Share button that renders whichever is showing and hands
/// it to the OS.
Future<void> showShareCardSheet(
  BuildContext context, {
  required ShareCardData data,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ShareCardSheet(data: data),
  );
}

enum _CardShape { story, post }

class _ShareCardSheet extends StatefulWidget {
  const _ShareCardSheet({required this.data});

  final ShareCardData data;

  @override
  State<_ShareCardSheet> createState() => _ShareCardSheetState();
}

class _ShareCardSheetState extends State<_ShareCardSheet> {
  _CardShape _shape = _CardShape.story;
  final _storyKey = GlobalKey();
  final _postKey = GlobalKey();
  bool _busy = false;

  Future<Uint8List?> _renderCurrentCard() async {
    final key = _shape == _CardShape.story ? _storyKey : _postKey;
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    // Twice the logical size: a card shared to a phone-filling story or a
    // feed post is looked at closely, and a 1x capture reads soft next to
    // the crisp UI it was cropped out of.
    final image = await boundary.toImage(pixelRatio: 2.5);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes?.buffer.asUint8List();
  }

  Future<void> _share() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await _renderCurrentCard();
      if (bytes == null) throw StateError('card not ready');
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              name: 'outrepd-${widget.data.username}.png',
              mimeType: 'image/png',
            ),
          ],
          text: '${l.duelMeOnOutrepd}\n${widget.data.profileUrl}',
        ),
      );
    } on Object catch (error) {
      debugPrint('Could not share the card: $error');
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.couldNotShareCard),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: widget.data.profileUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L.of(context).linkCopied),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rendered at full size so there is something for the
            // RepaintBoundary to capture, but occupying no layout space —
            // `Offstage` was tried here first and skips the paint pass
            // entirely, which left `toImage()` capturing nothing.
            SizedBox(
              height: 0,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                minWidth: 0,
                minHeight: 0,
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: Row(
                  children: [
                    RepaintBoundary(
                      key: _storyKey,
                      child: _StoryCard(data: widget.data),
                    ),
                    RepaintBoundary(
                      key: _postKey,
                      child: _PostCard(data: widget.data),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceRaised,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: AspectRatio(
                        aspectRatio: _shape == _CardShape.story
                            ? 272 / 560
                            : 400 / 260,
                        child: FittedBox(
                          child: _shape == _CardShape.story
                              ? _StoryCard(data: widget.data)
                              : _PostCard(data: widget.data),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ShapeTab(
                          label: l.shareStory,
                          selected: _shape == _CardShape.story,
                          onTap: () =>
                              setState(() => _shape = _CardShape.story),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _ShapeTab(
                          label: l.sharePost,
                          selected: _shape == _CardShape.post,
                          onTap: () =>
                              setState(() => _shape = _CardShape.post),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _busy ? null : _share,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l.share),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _copyLink,
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceRaised,
                        border: Border.all(
                          color: context.colors.border,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.profileUrl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.type.label.copyWith(
                                color: context.colors.muted,
                              ),
                            ),
                          ),
                          Text(
                            l.copyLink,
                            style: context.type.label.copyWith(
                              color: context.colors.brand,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShapeTab extends StatelessWidget {
  const _ShapeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? context.colors.brand : null,
          border: selected
              ? null
              : Border.all(color: context.colors.border, width: 0.5),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.type.label.copyWith(
            color: selected ? context.colors.background : context.colors.muted,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────── the cards ────────────────────────────────

/// Both card shapes are built inside this, so a colour only ever has to be
/// picked once and both always agree with the badge beside them.
class _CardTheme extends StatelessWidget {
  const _CardTheme({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // The card is captured as a picture, not read as a page — its own
      // type is fixed the moment it is drawn, so it must not grow or
      // overflow because the sharer turned their own text size up.
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Theme(
        data: buildTheme(Brightness.dark),
        child: Builder(builder: (context) => child),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.data});
  final ShareCardData data;

  @override
  Widget build(BuildContext context) {
    return _CardTheme(
      child: Builder(
        builder: (context) {
          final l = L.of(context);
          final tierColour = kTiers[data.tierIdx.clamp(0, kTiers.length - 1)].color;

          return Container(
            width: 272,
            height: 560,
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: context.colors.border, width: 0.5),
            ),
            child: Column(
              children: [
                Text(
                  'outrepd',
                  style: context.type.label.copyWith(
                    color: context.colors.muted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l.currentRankLabel.toUpperCase(),
                  style: context.type.micro.copyWith(color: context.colors.faint),
                ),
                const SizedBox(height: 8),
                TierBadge(tierIndex: data.tierIdx, size: 116),
                const SizedBox(height: 6),
                ShrinkText(
                  tierLabel(l, data.tierIdx, data.divIdx),
                  maxLines: 1,
                  style: context.type.heading.copyWith(color: context.colors.text),
                ),
                const SizedBox(height: 2),
                Text(
                  l.lpAmount(localNumber(context, data.lp)),
                  style: context.type.label.copyWith(color: tierColour),
                ),
                const SizedBox(height: 16),
                Container(height: 0.5, color: context.colors.border),
                const SizedBox(height: 14),
                _IdentityRow(data: data),
                const SizedBox(height: 14),
                _StatRow(data: data),
                const Spacer(),
                ShrinkText(
                  l.duelMeOnOutrepd,
                  maxLines: 1,
                  style: context.type.body.copyWith(color: context.colors.text),
                ),
                const SizedBox(height: 2),
                ShrinkText(
                  data.profileUrl,
                  maxLines: 1,
                  style: context.type.micro.copyWith(color: context.colors.muted),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.data});
  final ShareCardData data;

  @override
  Widget build(BuildContext context) {
    return _CardTheme(
      child: Builder(
        builder: (context) {
          final l = L.of(context);
          final tierColour = kTiers[data.tierIdx.clamp(0, kTiers.length - 1)].color;

          return Container(
            width: 400,
            height: 260,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: context.colors.border, width: 0.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TierBadge(tierIndex: data.tierIdx, size: 90),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _Initial(name: data.username, avatarUrl: data.avatarUrl),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShrinkText(
                                  data.username,
                                  maxLines: 1,
                                  style: context.type.body.copyWith(
                                    color: context.colors.text,
                                  ),
                                ),
                                Text(
                                  '${tierLabel(l, data.tierIdx, data.divIdx)} · '
                                  '${l.lpAmount(localNumber(context, data.lp))}',
                                  style: context.type.micro.copyWith(
                                    color: tierColour,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(height: 0.5, color: context.colors.border),
                      const SizedBox(height: 14),
                      _StatRow(data: data, compact: true),
                      const SizedBox(height: 12),
                      Text(
                        kProfileUrlBase.replaceAll('/u/', ''),
                        style: context.type.micro.copyWith(
                          color: context.colors.faint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({required this.data});
  final ShareCardData data;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final places = <String>[
      if (data.globalPlace case final g?)
        '${l.global} ${l.rankPosition(localNumber(context, g))}',
      if (data.countryPlace case final c?)
        if (data.country case final code?)
          '$code ${l.rankPosition(localNumber(context, c))}',
    ].join(' · ');

    return Row(
      children: [
        _Initial(name: data.username, avatarUrl: data.avatarUrl),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShrinkText(
                data.username,
                maxLines: 1,
                style: context.type.body.copyWith(color: context.colors.text),
              ),
              if (places.isNotEmpty)
                Text(
                  places,
                  style: context.type.micro.copyWith(color: context.colors.muted),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.name, this.avatarUrl});
  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.surfaceRaised,
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Text(
        name.isEmpty ? '?' : name.characters.first.toUpperCase(),
        style: context.type.body.copyWith(color: context.colors.text),
      ),
    );

    if (avatarUrl == null) return fallback;
    return ClipOval(
      child: Image.network(
        avatarUrl!,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        // The card is captured moments after this loads, so this is not
        // hypothetical the way it is on a screen somebody keeps open — a
        // fallback that never resolves in time draws itself into the image.
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : fallback,
        errorBuilder: (context, error, stack) => fallback,
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.data, this.compact = false});
  final ShareCardData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final tiles = [
      (l.record, '${localNumber(context, data.wins)}–${localNumber(context, data.losses)}'),
      (l.bestSet, localNumber(context, data.bestSet)),
      (l.streak, localNumber(context, data.winStreak)),
    ];

    if (compact) {
      return Row(
        children: [
          for (final (label, value) in tiles) ...[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShrinkText(
                    value,
                    maxLines: 1,
                    style: context.type.body.copyWith(color: context.colors.text),
                  ),
                  ShrinkText(
                    label,
                    maxLines: 1,
                    style: context.type.micro.copyWith(color: context.colors.muted),
                  ),
                ],
              ),
            ),
            if (label != tiles.last.$1) const SizedBox(width: 10),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (final (label, value) in tiles)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: context.colors.surfaceRaised,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Column(
                children: [
                  Text(
                    value,
                    style: context.type.body.copyWith(color: context.colors.text),
                  ),
                  Text(
                    label,
                    style: context.type.micro.copyWith(color: context.colors.muted),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
