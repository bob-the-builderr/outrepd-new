/// The cover over a profile, and where a player picks theirs: one of the
/// thirteen moving scenes, a photo of their own cropped to the cover's shape, or
/// none (the user's picks, 2026-11-01). Covers are Pro: a free player can
/// open the picker and watch any scene move, with a quiet way to Pro, but
/// keeps none of them.
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../lifter/covers.dart';
import '../lifter/looks.dart';
import '../photo_cache.dart';
import '../subscription.dart';
import '../theme.dart';
import '../type_scale.dart';
import 'paywall.dart';
import 'pro_parts.dart';

/// [cover] behind the top of a profile, fading into the page by its foot.
/// Nothing for no cover.
class ProfileCover extends StatelessWidget {
  const ProfileCover({super.key, required this.cover});

  /// A scene's id, a photo's URL, or null.
  final String? cover;

  @override
  Widget build(BuildContext context) {
    final c = cover;
    if (c == null) return const SizedBox.shrink();
    return IgnorePointer(
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, Colors.transparent],
          stops: [0, 0.55, 1],
        ).createShader(rect),
        child: _CoverArt(cover: c),
      ),
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({required this.cover, this.moving = true});

  final String cover;
  final bool moving;

  @override
  Widget build(BuildContext context) => isScene(cover)
      ? CoverScene(cover, moving: moving)
      : Image(
          // Kept on the phone after its first download (lib/photo_cache.dart)
          // and decoded at the screen's width: a photo cover was fetched
          // again on every launch, the profile opening bare until it came.
          image: ResizeImage.resizeIfNeeded(
            (MediaQuery.sizeOf(context).width * MediaQuery.devicePixelRatioOf(context)).ceil(),
            null,
            photoAt(cover),
          ),
          gaplessPlayback: true,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stack) => const SizedBox.shrink(),
        );
}

/// The name of the scene [id], in the reader's language.
String coverName(L l, String id) => switch (id) {
  'neon_city' => l.coverNeonCity,
  'iron_gym' => l.coverIronGym,
  'rooftop_sunset' => l.coverRooftopSunset,
  'stadium_lights' => l.coverStadiumLights,
  'silver_peaks' => l.coverSilverPeaks,
  'bronze_dunes' => l.coverBronzeDunes,
  'volcano' => l.coverVolcano,
  'palm_beach' => l.coverPalmBeach,
  'fireworks' => l.coverFireworks,
  'fight_night' => l.coverFightNight,
  'orbit' => l.coverOrbit,
  'champion_podium' => l.coverChampionPodium,
  'winter_city' => l.coverWinterCity,
  _ => l.coverWinterCity,
};

/// Opens the cover picker.
Future<void> showCoverPicker(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: context.colors.surface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
  ),
  builder: (_) => const _CoverSheet(),
);

class _CoverSheet extends StatefulWidget {
  const _CoverSheet();

  @override
  State<_CoverSheet> createState() => _CoverSheetState();
}

class _CoverSheetState extends State<_CoverSheet> {
  /// The scene in the preview: the one worn, or the first.
  late String _shown = MyCover.instance.cover ?? kCovers.first;
  bool _busy = false;
  String? _error;

  bool get _pro => Subscription.instance.active;

  Future<void> _use() async {
    await MyCover.instance.choose(_shown);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _none() async {
    await MyCover.instance.choose(null);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _unlock() async {
    await openPro(context);
    if (mounted) setState(() {});
  }

  /// A photo from the phone, cropped to the cover's shape on the phone's own
  /// crop screen, the way a profile picture is.
  Future<void> _photo() async {
    if (!_pro) return _unlock();
    final l = L.of(context);
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 2400,
        maxHeight: 2400,
        imageQuality: 95,
      );
      if (picked == null) return;
      Uint8List? bytes;
      if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
        bytes = await picked.readAsBytes();
      } else {
        final cropped = await ImageCropper().cropImage(
          sourcePath: picked.path,
          aspectRatio: const CropAspectRatio(
            ratioX: CoverPainter.width,
            ratioY: CoverPainter.height,
          ),
          maxWidth: 1236,
          maxHeight: 840,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 85,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: l.coverTitle,
              toolbarColor: const Color(0xFF1C1A18),
              toolbarWidgetColor: const Color(0xFFF5EFE4),
              backgroundColor: Colors.black,
              activeControlsWidgetColor: AppColors.gold,
              statusBarLight: false,
              navBarLight: false,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: l.coverTitle,
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
              aspectRatioPickerButtonHidden: true,
            ),
          ],
        );
        bytes = await cropped?.readAsBytes();
      }
      if (bytes == null || !mounted) return;
      setState(() {
        _busy = true;
        _error = null;
      });
      await MyCover.instance.usePhoto(bytes);
      if (mounted) Navigator.of(context).pop();
    } on Object catch (error) {
      debugPrint('Could not use that cover: $error');
      if (mounted) {
        setState(() {
          _busy = false;
          _error = l.coverCouldNotUpload;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final pro = _pro;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(l.coverTitle, style: kType.heading.copyWith(color: colors.text)),
                const SizedBox(width: 8),
                const ProChip(height: 18),
              ],
            ),
            const SizedBox(height: 12),
            // The one being looked at, moving, the size of a profile's top.
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: CoverPainter.width / CoverPainter.height,
                child: CoverScene(_shown, key: ValueKey(_shown)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              coverName(l, _shown),
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.muted, fontSize: 13),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: CoverPainter.width / CoverPainter.height,
              children: [
                for (final id in kCovers)
                  GestureDetector(
                    key: Key('cover_$id'),
                    onTap: () => setState(() => _shown = id),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: id == _shown ? colors.brand : colors.border,
                          width: id == _shown ? 2.5 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        // Still in the grid; the preview is the one that moves.
                        child: _CoverArt(cover: id, moving: false),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('coverPhoto'),
                    onPressed: _busy ? null : _photo,
                    icon: const Icon(Icons.photo_library_outlined, size: 19),
                    label: Text(l.coverPhoto),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(46)),
                  ),
                ),
                if (pro && MyCover.instance.cover != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      key: const Key('coverNone'),
                      onPressed: _busy ? null : _none,
                      style: TextButton.styleFrom(minimumSize: const Size.fromHeight(46)),
                      child: Text(l.coverNone, style: TextStyle(color: colors.muted)),
                    ),
                  ),
                ],
              ],
            ),
            if (_error case final error?) ...[
              const SizedBox(height: 8),
              Text(error, style: const TextStyle(color: AppColors.loss, fontSize: 13)),
            ],
            const SizedBox(height: 12),
            if (!pro) ...[
              Text(
                l.coverProLine,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.muted, fontSize: 13.5, height: 1.4),
              ),
              const SizedBox(height: 10),
            ],
            SizedBox(
              height: 54,
              child: FilledButton(
                key: const Key('coverUse'),
                onPressed: _busy ? null : (pro ? _use : _unlock),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.brand,
                  foregroundColor: colors.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  pro ? l.coverUse : l.lifterUnlockPro,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
