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
import '../country_names.dart';
import '../data.dart';
import '../lifter/lifter_view.dart';
import '../lifter/my_lifter.dart';
import '../ranking.dart';
import '../rewards.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../tier_card_frame.dart';
import '../tier_frame.dart';
import '../type_scale.dart';
import '../widgets.dart';
import '../worn_title.dart';
import 'cover_parts.dart';
import 'pro_parts.dart';

/// Shares this account's friend code through the phone's own share sheet,
/// with a line that says what to do with it. If the sheet will not open, the
/// same message is copied instead, so the tap still gets somewhere.
Future<void> shareFriendCode(BuildContext context, String code) async {
  final l = L.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final text = l.friendCodeInvite('#$code');
  try {
    await SharePlus.instance.share(ShareParams(text: text));
  } on Object catch (error) {
    debugPrint('Could not share the friend code: $error');
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.codeCopied),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// The card's own type. A card is fixed artwork, drawn at one size and laid
/// out against these, so it keeps them when the app's own type goes up.
abstract final class _CardType {
  static TextStyle get label => kType.label.copyWith(fontSize: 13);
  static TextStyle get micro => kType.micro.copyWith(fontSize: 11);
}

/// Where a shared card points: the lifter's own page on the site, their rank
/// card with the stores under it — and, when the app is installed, their
/// card in the app (lib/deep_links.dart).
const kShareSite = 'outrepd.com';

String profilePath(String username) =>
    '$kShareSite/u/${Uri.encodeComponent(username)}';

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
    this.xp,
    this.title,
    this.pro = false,
    this.cover,
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

  /// Their level's XP and the title they wear, beside the name, where known.
  final int? xp;
  final EarnedTitle? title;

  /// A Pro's card wears their cover across its top and a holo edge.
  final bool pro;

  /// The cover: a scene's id or a photo's URL, or null for none.
  final String? cover;

  String get profileUrl => profilePath(username);
}

/// One finished duel, for the card shared from its result screen. The card
/// is about the match, not the account, but it still points at the account:
/// whoever sees it can challenge the person who posted it.
class MatchShareData {
  const MatchShareData({
    required this.username,
    required this.won,
    required this.yourReps,
    required this.theirReps,
    required this.opponent,
    required this.seconds,
    this.tierIdx,
    this.divIdx = 0,
    this.lpDelta,
    this.newBest = false,
    this.avatarUrl,
    this.opponentTierIdx,
    this.lp,
    this.pro = false,
    this.cover,
  });

  final String username;
  final bool won;
  final int yourReps;
  final int theirReps;
  final String opponent;

  /// How long the round was. The count is only a boast next to its clock.
  final int seconds;

  /// The rank this duel left the account on, or null while still in
  /// placements, when there is no rank to show yet.
  final int? tierIdx;
  final int divIdx;
  final int? lpDelta;
  final bool newBest;
  final String? avatarUrl;

  /// The opponent's tier, for the frame round their picture — or null when
  /// it is not known, and their picture goes bare.
  final int? opponentTierIdx;

  /// Where in the division the duel left the account, for the rating on
  /// the rank card; null shows the tier and what moved without it.
  final int? lp;

  /// A Pro's card, as on the profile's: their cover and a holo edge.
  final bool pro;
  final String? cover;

  String get profileUrl => profilePath(username);
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
    builder: (_) => _ShareCardSheet(
      username: data.username,
      profileUrl: data.profileUrl,
      story: _StoryCard(data: data),
      post: _PostCard(data: data),
    ),
  );
}

/// The same sheet, with the result of one duel on the card instead of the
/// account's standing.
Future<void> showMatchShareSheet(
  BuildContext context, {
  required MatchShareData data,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ShareCardSheet(
      username: data.username,
      profileUrl: data.profileUrl,
      story: _MatchStoryCard(data: data),
      post: _MatchPostCard(data: data),
      // A loss is still worth posting, and asking to be beaten is the line
      // that makes somebody try.
      invite: data.won ? null : (L l) => l.thinkYouCanBeatMe,
    ),
  );
}

enum _CardShape { story, post }

class _ShareCardSheet extends StatefulWidget {
  const _ShareCardSheet({
    required this.username,
    required this.profileUrl,
    required this.story,
    required this.post,
    this.invite,
  });

  final String username;
  final String profileUrl;
  final Widget story;
  final Widget post;

  /// The line sent with the image. Null is the usual "Duel me on outrepd".
  final String Function(L l)? invite;

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
    // At the width the platforms ask for: 1080 across, so a story comes out
    // 1080×1920 and a post 1080×1350, sharp on any phone that shows it.
    final image = await boundary.toImage(
      pixelRatio: _exportWidth / _cardWidth,
    );
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
              name: 'outrepd-${widget.username}.png',
              mimeType: 'image/png',
            ),
          ],
          text:
              '${widget.invite?.call(l) ?? l.duelMeOnOutrepd}\n'
              'https://${widget.profileUrl}',
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
    Clipboard.setData(ClipboardData(text: 'https://${widget.profileUrl}'));
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
            // entirely, which left `toImage()` capturing nothing. The clip
            // hides them from the screen without skipping that paint: each
            // RepaintBoundary still records its own layer for the capture.
            ClipRect(
              child: SizedBox(
                height: 0,
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minWidth: 0,
                  minHeight: 0,
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: Row(
                    children: [
                      RepaintBoundary(key: _storyKey, child: widget.story),
                      RepaintBoundary(key: _postKey, child: widget.post),
                    ],
                  ),
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
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: AspectRatio(
                        aspectRatio: _shape == _CardShape.story
                            ? _cardWidth / _storyHeight
                            : _cardWidth / _postHeight,
                        // Rounded on screen only: the card itself is drawn
                        // edge to edge, the way it is posted.
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: FittedBox(
                            child: _shape == _CardShape.story
                                ? widget.story
                                : widget.post,
                          ),
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
                          onTap: () => setState(() => _shape = _CardShape.post),
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
                              child: CircularProgressIndicator(strokeWidth: 2),
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
                              widget.profileUrl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _CardType.label.copyWith(
                                color: context.colors.muted,
                              ),
                            ),
                          ),
                          Text(
                            l.copyLink,
                            style: _CardType.label.copyWith(
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
          style: _CardType.label.copyWith(
            color: selected ? context.colors.background : context.colors.muted,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────── the cards ────────────────────────────────

/// A card's logical size: a phone's width, so it lays out the way a screen
/// does. It is captured at the size each platform asks for — a story at
/// 1080×1920 (9:16), a post at 1080×1350 (4:5) — and drawn edge to edge,
/// because a rounded corner comes out of the capture as a transparent one
/// that a story then fills with black.
const _cardWidth = 412.0;
const _storyHeight = 732.0;
const _postHeight = 515.0;
const _exportWidth = 1080.0;

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

/// The card's ground: the page colour, lit from behind its hero in the
/// colour of the tier — or of the result, on a loss — and again, fainter,
/// from below. A Pro's card wears their cover across its top and a holo
/// edge round it (the user's pick, 2026-11-03).
class _Backdrop extends StatelessWidget {
  const _Backdrop({
    required this.height,
    required this.glow,
    required this.centre,
    required this.padding,
    required this.child,
    this.pro = false,
    this.cover,
  });

  final double height;
  final Color glow;
  final Alignment centre;
  final EdgeInsets padding;
  final Widget child;
  final bool pro;

  /// A Pro's cover: a scene's id or a photo's URL. Ignored for anyone else.
  final String? cover;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _cardWidth,
      height: height,
      color: context.colors.background,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: centre,
                  radius: 1.1,
                  colors: [
                    glow.withValues(alpha: 0.3),
                    glow.withValues(alpha: 0),
                  ],
                  stops: const [0, 0.6],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 1.25),
                  radius: 0.9,
                  colors: [
                    glow.withValues(alpha: 0.12),
                    glow.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          if (pro && cover != null)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: height * 0.42,
              child: ProfileCover(cover: cover),
            ),
          Positioned.fill(child: Padding(padding: padding, child: child)),
          if (pro)
            const Positioned.fill(
              child: IgnorePointer(child: CustomPaint(painter: _HoloFrame())),
            ),
        ],
      ),
    );
  }
}

/// A Pro card's edge: the holo foil, a little in from the card's own edge so
/// a story's rounded corners on a phone do not cut it.
class _HoloFrame extends CustomPainter {
  const _HoloFrame();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(22)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..shader = kHoloGradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_HoloFrame old) => false;
}

class _Brand extends StatelessWidget {
  const _Brand({this.pro = false});

  /// A Pro's card says so beside the name of the app.
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final brand = Text(
      'OUTREPD',
      style: _CardType.label.copyWith(
        color: context.colors.brand.withValues(alpha: 0.85),
        letterSpacing: 6,
        fontWeight: FontWeight.w800,
      ),
    );
    if (!pro) return brand;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [brand, const SizedBox(width: 8), const ProChip(height: 17)],
    );
  }
}

/// A name as the card writes it: in the holo foil on a Pro's card.
class _Name extends StatelessWidget {
  const _Name({
    required this.name,
    required this.size,
    this.colour,
    this.pro = false,
  });

  final String name;
  final double size;
  final Color? colour;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final text = ShrinkText(
      name,
      maxLines: 1,
      style: TextStyle(
        color: pro ? Colors.white : colour ?? context.colors.text,
        fontSize: size,
        fontWeight: FontWeight.w800,
      ),
    );
    if (!pro) return text;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) => kHoloGradient.createShader(rect),
      child: text,
    );
  }
}

/// The rank as the app's rank card draws it, wearing its tier's frame: the
/// crest, the tier, the rating, and either what this duel moved it by or
/// what the next division needs.
class _ShareRank extends StatelessWidget {
  const _ShareRank({
    required this.tierIdx,
    required this.divIdx,
    this.lp,
    this.delta,
    this.showNext = false,
  });

  final int tierIdx;
  final int divIdx;

  /// Null where the rating is not known — then the tier alone.
  final int? lp;

  /// What the duel moved the rating by, on a match card.
  final int? delta;

  /// What the next division needs, and the bar towards it, on the profile's.
  final bool showNext;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final metal = tierMetal(tierIdx);
    final accent = tierIdx >= kTopTier ? metal.wing : metal.mid;
    final points = lp;
    final rating = points == null ? null : ratingOf(tierIdx, divIdx, points);
    final top = tierIdx >= kTopTier && divIdx >= kTopDivision;
    final change = delta;
    final note = change != null
        ? '${change >= 0 ? '+' : '−'}'
              '${l.ratingAmount(localNumber(context, change.abs()))}'
        : showNext && !top && points != null
        ? l.toNextTier(
            localNumber(
              context,
              (kRatingPerDivision - points).clamp(0, kRatingPerDivision),
            ),
            nextRankName(l, tierIdx, divIdx),
          )
        : null;

    return TierCardFrame(
      tierIdx: tierIdx,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 10, 14, 10),
        child: Row(
          children: [
            TierBadge(tierIndex: tierIdx, size: 54),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShrinkText(
                    tierLabel(l, tierIdx, divIdx).toUpperCase(),
                    maxLines: 1,
                    style: TextStyle(
                      color: metal.light,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  if (rating != null || note != null)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            if (rating != null)
                              TextSpan(
                                text: localNumber(context, rating),
                                style: TextStyle(
                                  color: context.colors.text,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            if (rating != null && note != null)
                              TextSpan(
                                text: '  ·  ',
                                style: TextStyle(color: context.colors.muted),
                              ),
                            if (note != null)
                              TextSpan(
                                text: note,
                                style: change != null
                                    ? TextStyle(
                                        color: change >= 0
                                            ? AppColors.gold
                                            : context.colors.rival,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      )
                                    : TextStyle(
                                        color: context.colors.muted,
                                        fontSize: 13,
                                      ),
                              ),
                          ],
                        ),
                        maxLines: 1,
                      ),
                    ),
                  if (showNext && points != null) ...[
                    const SizedBox(height: 7),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        height: 4,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ColoredBox(
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                            FractionallySizedBox(
                              alignment: AlignmentDirectional.centerStart,
                              widthFactor: top
                                  ? 1.0
                                  : (points / kRatingPerDivision).clamp(
                                      0.0,
                                      1.0,
                                    ),
                              child: ColoredBox(color: accent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The colour a tier's card glows in: its own metal.
Color _tierGlow(int? tierIdx) =>
    tierIdx == null ? AppColors.gold : crestOf(tierIdx).mid;

/// The account's standing (the user's pick, 2026-11-03): their picture large
/// in its tier's frame, their name and level, the title they wear, the rank
/// card in its frame, and four numbers.
class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.data});

  final ShareCardData data;

  @override
  Widget build(BuildContext context) {
    return _CardTheme(
      child: Builder(
        builder: (context) {
          final l = L.of(context);
          return _Backdrop(
            height: _storyHeight,
            glow: _tierGlow(data.tierIdx),
            centre: const Alignment(0, -0.6),
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
            pro: data.pro,
            cover: data.cover,
            child: Column(
              children: [
                _Brand(pro: data.pro),
                const SizedBox(height: 12),
                _Framed(
                  name: data.username,
                  avatarUrl: data.avatarUrl,
                  tierIdx: data.tierIdx,
                  size: 116,
                ),
                const SizedBox(height: 4),
                _Identity(data: data, nameSize: 30),
                const SizedBox(height: 4),
                _ShareRank(
                  tierIdx: data.tierIdx,
                  divIdx: data.divIdx,
                  lp: data.lp,
                  showNext: true,
                ),
                Row(
                  children: [
                    Expanded(child: _Tile(label: l.bestSet, value: localNumber(context, data.bestSet))),
                    const SizedBox(width: 8),
                    Expanded(child: _Tile(label: l.record, value: _record(context, data))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _Tile(label: l.streak, value: localNumber(context, data.winStreak))),
                    const SizedBox(width: 8),
                    Expanded(child: _Tile(label: l.global, value: _global(context, l, data))),
                  ],
                ),
                const Spacer(),
                _Cta(line: l.duelMeOnOutrepd, url: data.profileUrl),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// The same, for a feed: the picture beside the name, the rank card, and
/// three numbers in a row.
class _PostCard extends StatelessWidget {
  const _PostCard({required this.data});

  final ShareCardData data;

  @override
  Widget build(BuildContext context) {
    return _CardTheme(
      child: Builder(
        builder: (context) {
          final l = L.of(context);
          return _Backdrop(
            height: _postHeight,
            glow: _tierGlow(data.tierIdx),
            centre: const Alignment(-0.5, -0.4),
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            pro: data.pro,
            cover: data.cover,
            child: Column(
              children: [
                _Brand(pro: data.pro),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Framed(
                      name: data.username,
                      avatarUrl: data.avatarUrl,
                      tierIdx: data.tierIdx,
                      size: 72,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _Identity(data: data, nameSize: 25, start: true),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                _ShareRank(
                  tierIdx: data.tierIdx,
                  divIdx: data.divIdx,
                  lp: data.lp,
                  showNext: true,
                ),
                Row(
                  children: [
                    for (final (i, (label, value)) in [
                      (l.bestSet, localNumber(context, data.bestSet)),
                      (l.record, _record(context, data)),
                      (l.streak, localNumber(context, data.winStreak)),
                      (l.global, _global(context, l, data)),
                    ].indexed) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(child: _Tile(label: label, value: value, size: 21)),
                    ],
                  ],
                ),
                const Spacer(),
                _Cta(url: data.profileUrl),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Wins–losses, the way the profile writes a record.
String _record(BuildContext context, ShareCardData data) =>
    '${localNumber(context, data.wins)}–${localNumber(context, data.losses)}';

/// The world place, or a dash where there is none yet.
String _global(BuildContext context, L l, ShareCardData data) =>
    switch (data.globalPlace) {
      final g? => l.rankPosition(localNumber(context, g)),
      null => '—',
    };

/// The lifter's name — with their level where it is known, in the holo foil
/// on a Pro's card — the title they wear, and where they stand in their
/// country when that is known.
class _Identity extends StatelessWidget {
  const _Identity({
    required this.data,
    required this.nameSize,
    this.start = false,
  });

  final ShareCardData data;
  final double nameSize;

  /// Hung from the start rather than centred — beside the picture on a post.
  final bool start;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final place = switch ((data.countryPlace, data.country)) {
      (final c?, final code?) =>
        '${l.rankPosition(localNumber(context, c))} · ${countryName(context, code)}',
      _ => null,
    };
    final xp = data.xp;
    return Column(
      crossAxisAlignment: start
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: start ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Flexible(
              child: _Name(
                name: data.username,
                size: nameSize,
                pro: data.pro,
              ),
            ),
            if (xp != null) ...[
              const SizedBox(width: 6),
              LevelChip(xp: xp, fontSize: 12),
            ],
          ],
        ),
        if (data.title case final title?) WornTitle(title: title),
        if (place != null)
          ShrinkText(
            place,
            maxLines: 1,
            style: _CardType.label.copyWith(
              color: context.colors.muted,
              fontSize: 13.5,
            ),
          ),
      ],
    );
  }
}

/// A picture in its tier's frame, or bare for somebody with no tier to show.
class _Framed extends StatelessWidget {
  const _Framed({
    required this.name,
    required this.tierIdx,
    required this.size,
    this.avatarUrl,
    this.textColour,
  });

  final String name;
  final int? tierIdx;
  final double size;
  final String? avatarUrl;
  final Color? textColour;

  @override
  Widget build(BuildContext context) {
    return TierFrame(
      tierIdx: tierIdx,
      size: size,
      child: _Initial(
        name: name,
        avatarUrl: avatarUrl,
        size: size,
        textColour: textColour,
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value, this.size = 28});

  final String label;
  final String value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 9),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShrinkText(
            label.toUpperCase(),
            maxLines: 1,
            style: _CardType.micro.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 2),
          ShrinkText(
            value,
            maxLines: 1,
            style: TextStyle(
              color: context.colors.text,
              fontSize: size,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// The invitation at the foot of a card, and where it leads.
class _Cta extends StatelessWidget {
  const _Cta({required this.url, this.line});

  final String url;
  final String? line;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (line case final words?) ...[
          ShrinkText(
            words,
            maxLines: 1,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border),
          ),
          child: ShrinkText(
            url,
            maxLines: 1,
            style: _CardType.label.copyWith(
              color: context.colors.muted,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({
    required this.name,
    this.avatarUrl,
    this.size = 32,
    this.textColour,
  });
  final String name;
  final String? avatarUrl;
  final double size;

  /// Kept for the callers that set it; the lifter drawn when there is no
  /// photo has no letter to colour.
  final Color? textColour;

  @override
  Widget build(BuildContext context) {
    final fallback = LifterCircle(
      name: name,
      size: size,
      lifter: name == demoProfile.username ? MyLifter.instance.built : null,
    );

    if (avatarUrl == null) return fallback;
    return ClipOval(
      child: Image.network(
        avatarUrl!,
        width: size,
        height: size,
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

// ─────────────────────────────── the match card ────────────────────────────

/// The duel as a scoreboard: both lifters in their frames face to face, the
/// two counts in their own colours, and a bar split by who pushed more. It
/// reads as a duel at a glance in a feed — a count alone could be any set.
/// A loss keeps the same board and asks for a rematch instead of claiming a
/// win, glowing in the rival's colour rather than the tier's.
class _MatchStoryCard extends StatelessWidget {
  const _MatchStoryCard({required this.data});

  final MatchShareData data;

  @override
  Widget build(BuildContext context) {
    return _CardTheme(
      child: Builder(
        builder: (context) {
          final l = L.of(context);
          return _Backdrop(
            height: _storyHeight,
            glow: data.won ? _tierGlow(data.tierIdx) : context.colors.rival,
            centre: const Alignment(0, -0.45),
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
            pro: data.pro,
            cover: data.cover,
            child: Column(
              children: [
                _Brand(pro: data.pro),
                const SizedBox(height: 16),
                _Verdict(data: data, size: 58),
                const SizedBox(height: 4),
                _Faces(data: data, size: 70),
                const SizedBox(height: 2),
                _Score(data: data, size: 124),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: _SplitBar(yours: data.yourReps, theirs: data.theirReps),
                ),
                const SizedBox(height: 10),
                ShrinkText(
                  l.pushUpsInSeconds(localNumber(context, data.seconds)).toUpperCase(),
                  maxLines: 1,
                  style: _CardType.micro.copyWith(
                    color: context.colors.muted,
                    fontSize: 12,
                    letterSpacing: 2.4,
                  ),
                ),
                if (data.tierIdx case final tier?) ...[
                  const SizedBox(height: 6),
                  _ShareRank(
                    tierIdx: tier,
                    divIdx: data.divIdx,
                    lp: data.lp,
                    delta: data.lpDelta,
                  ),
                ] else
                  const SizedBox(height: 14),
                if (data.newBest) _BestChip(label: l.newPersonalBest),
                const Spacer(),
                _Cta(
                  line: data.won ? l.duelMeOnOutrepd : l.thinkYouCanBeatMe,
                  url: data.profileUrl,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MatchPostCard extends StatelessWidget {
  const _MatchPostCard({required this.data});

  final MatchShareData data;

  @override
  Widget build(BuildContext context) {
    return _CardTheme(
      child: Builder(
        builder: (context) {
          final l = L.of(context);
          return _Backdrop(
            height: _postHeight,
            glow: data.won ? _tierGlow(data.tierIdx) : context.colors.rival,
            centre: const Alignment(0, -0.35),
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            pro: data.pro,
            cover: data.cover,
            child: Column(
              children: [
                _Brand(pro: data.pro),
                const SizedBox(height: 8),
                _Verdict(data: data, size: 46),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(child: _Face(data: data, mine: true, size: 50)),
                    _Score(data: data, size: 62),
                    Expanded(child: _Face(data: data, mine: false, size: 50)),
                  ],
                ),
                const SizedBox(height: 10),
                _SplitBar(yours: data.yourReps, theirs: data.theirReps),
                if (data.tierIdx case final tier?) ...[
                  const SizedBox(height: 2),
                  _ShareRank(
                    tierIdx: tier,
                    divIdx: data.divIdx,
                    lp: data.lp,
                    delta: data.lpDelta,
                  ),
                ] else
                  const SizedBox(height: 14),
                if (data.newBest) _BestChip(label: l.newPersonalBest),
                const Spacer(),
                _Cta(url: data.profileUrl),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// VICTORY, in the gold of a medal, or the ask for a rematch after a loss.
class _Verdict extends StatelessWidget {
  const _Verdict({required this.data, required this.size});

  final MatchShareData data;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final words = ShrinkText(
      data.won ? l.shareVictory : l.shareRematch,
      maxLines: 1,
      style: TextStyle(
        color: data.won ? Colors.white : context.colors.rival,
        fontSize: size,
        fontWeight: FontWeight.w900,
        letterSpacing: size / 9,
      ),
    );
    if (!data.won) return words;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF0C2), Color(0xFFE0B145), Color(0xFFB8912F)],
        stops: [0, 0.6, 1],
      ).createShader(rect),
      child: words,
    );
  }
}

/// Both lifters, framed, either side of "vs".
class _Faces extends StatelessWidget {
  const _Faces({required this.data, required this.size});
  final MatchShareData data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Face(data: data, mine: true, size: size)),
        Text(
          L.of(context).vs.toUpperCase(),
          style: _CardType.label.copyWith(
            color: context.colors.muted,
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
        Expanded(child: _Face(data: data, mine: false, size: size)),
      ],
    );
  }
}

/// One lifter on the scoreboard: picture in its frame, name in their colour.
class _Face extends StatelessWidget {
  const _Face({required this.data, required this.mine, required this.size});
  final MatchShareData data;
  final bool mine;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colour = mine ? context.colors.text : context.colors.rival;
    final name = mine ? data.username : data.opponent;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Framed(
          name: name,
          avatarUrl: mine ? data.avatarUrl : null,
          tierIdx: mine ? data.tierIdx : data.opponentTierIdx,
          size: size,
          textColour: colour,
        ),
        ShrinkText(
          name,
          maxLines: 1,
          style: TextStyle(
            color: colour,
            fontSize: size >= 60 ? 17 : 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// The two counts: yours, a dash, theirs.
class _Score extends StatelessWidget {
  const _Score({required this.data, required this.size});
  final MatchShareData data;
  final double size;

  @override
  Widget build(BuildContext context) {
    TextStyle style(Color colour, {FontWeight weight = FontWeight.w900}) =>
        TextStyle(
          color: colour,
          fontSize: size,
          fontWeight: weight,
          height: 1,
          fontFeatures: const [FontFeature.tabularFigures()],
        );
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(localNumber(context, data.yourReps), style: style(context.colors.text)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size / 12),
            child: Text(
              '–',
              style: style(context.colors.faint, weight: FontWeight.w300),
            ),
          ),
          Text(localNumber(context, data.theirReps), style: style(context.colors.rival)),
        ],
      ),
    );
  }
}

/// The two counts as one bar, split by who did more — the same bar the duel
/// screen draws while the round is on.
class _SplitBar extends StatelessWidget {
  const _SplitBar({required this.yours, required this.theirs});

  final int yours;
  final int theirs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      width: double.infinity,
      child: yours <= 0 && theirs <= 0
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surfaceRaised,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (yours > 0)
                  Expanded(
                    flex: yours,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.text,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                if (yours > 0 && theirs > 0) const SizedBox(width: 4),
                if (theirs > 0)
                  Expanded(
                    flex: theirs,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.rival,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _BestChip extends StatelessWidget {
  const _BestChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drawn, not typed: a star character is a box in some fonts.
          const Icon(Icons.star_rounded, color: AppColors.gold, size: 17),
          const SizedBox(width: 6),
          Flexible(
            child: ShrinkText(
              label,
              maxLines: 1,
              style: _CardType.label.copyWith(
                color: context.colors.text,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
