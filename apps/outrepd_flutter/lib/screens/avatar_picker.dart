import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../avatar.dart';
import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../data.dart';
import '../lifter/my_lifter.dart';
import '../player_avatar.dart';
import '../theme.dart';
import 'lifter_maker.dart';

/// Choosing a picture: the lifter, made or changed here, or a photo from the
/// phone.
Future<void> showAvatarPicker(BuildContext context, int tierIdx) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => _AvatarSheet(tierIdx: tierIdx),
  );
}

class _AvatarSheet extends StatefulWidget {
  const _AvatarSheet({required this.tierIdx});
  final int tierIdx;

  @override
  State<_AvatarSheet> createState() => _AvatarSheetState();
}

class _AvatarSheetState extends State<_AvatarSheet> {
  String? _error;

  /// The picked file is copied into the app's own storage. What the picker
  /// hands back can be a cache entry the system clears later, and a picture
  /// that quietly vanishes is worse than one that was never set.
  Future<void> _pick(ImageSource source) async {
    try {
      // Bigger than the picture is kept at: the crop below may take a small
      // part of it, and that part should still fill the 800 it is saved at.
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 95,
      );
      if (picked == null) return;

      final bytes = await _crop(picked);
      // The crop screen was closed without choosing: nothing changes.
      if (bytes == null) return;

      final dir = await getApplicationDocumentsDirectory();
      final target = File(
        '${dir.path}/avatar-${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await target.writeAsBytes(bytes);
      await avatar.usePhoto(target.path);

      // Captured before the pop below, so a failed upload can still say so
      // on the screen underneath once the sheet carrying this context is
      // gone.
      final messenger = mounted ? ScaffoldMessenger.of(context) : null;
      final message = mounted ? L.of(context).couldNotSyncAvatar : null;
      if (mounted) Navigator.of(context).pop();

      // Best-effort and after the sheet has already closed: the picture
      // works locally either way, and a dropped connection should not hold
      // up a screen that has already done its job. Other people seeing it
      // is what this call is for, not whether the picker itself succeeded —
      // so a failure here is worth a quiet word, not a blocked flow.
      if (backend.available) {
        try {
          await avatar.sendPhoto();
        } on Object catch (error) {
          debugPrint('Could not upload the avatar: $error');
          if (messenger != null && message != null) {
            messenger.showSnackBar(
              SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
            );
          }
        }
      }
    } on Object catch (error) {
      debugPrint('Could not use that picture: $error');
      if (mounted) {
        setState(() => _error = L.of(context).couldNotUsePicture);
      }
    }
  }

  /// The phone's own crop screen, square: what goes in the circle is the
  /// lifter's call, not the middle of whatever they picked (the user's pick
  /// B, 2026-11-01). Null when it was closed without choosing. Where there
  /// is no crop screen to open — anywhere but a phone — the picture is used
  /// as picked, at the size it was always kept at.
  Future<Uint8List?> _crop(XFile picked) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return picked.readAsBytes();
    }
    final l = L.of(context);
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxWidth: 800,
      maxHeight: 800,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 88,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: l.cropPhoto,
          toolbarColor: const Color(0xFF1C1A18),
          toolbarWidgetColor: const Color(0xFFF5EFE4),
          backgroundColor: Colors.black,
          activeControlsWidgetColor: AppColors.gold,
          statusBarLight: false,
          navBarLight: false,
          showCropGrid: true,
          lockAspectRatio: true,
          initAspectRatio: CropAspectRatioPreset.square,
          aspectRatioPresets: const [CropAspectRatioPreset.square],
        ),
        IOSUiSettings(
          title: l.cropPhoto,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
          aspectRatioPresets: const [CropAspectRatioPreset.square],
        ),
      ],
    );
    return cropped?.readAsBytes();
  }

  bool _removing = false;

  /// Back to the lifter, everywhere: asked once, since the server's copy
  /// goes too. The phone's copy goes only once the server's has, so a
  /// failure leaves the picture as it was rather than half gone. A made
  /// lifter is then sent up as the picture again.
  Future<void> _remove() async {
    final l = L.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => _RemoveDialog(tierIdx: widget.tierIdx),
    );
    if (sure != true || !mounted) return;
    setState(() {
      _removing = true;
      _error = null;
    });
    try {
      if (backend.available) await backend.removeAvatar();
      await avatar.clearPhoto();
      await MyLifter.instance.photoRemoved();
      if (mounted) Navigator.of(context).pop();
    } on Object catch (error) {
      debugPrint('Could not remove the photo: $error');
      if (mounted) {
        setState(() {
          _removing = false;
          _error = l.couldNotRemovePhoto;
        });
      }
    }
  }

  /// The maker, over the screen the sheet was opened from.
  Future<void> _editLifter() async {
    final navigator = Navigator.of(context);
    navigator.pop();
    await navigator.push<bool>(
      MaterialPageRoute(builder: (_) => const LifterMakerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // A photo to take down: one on this phone, or one on the server that is
    // not the lifter's own picture.
    final onServer = backend.me?.avatarUrl;
    final hasPicture = avatar.hasPhoto ||
        (!MyLifter.instance.isPicture && onServer != null && onServer.isNotEmpty);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: PlayerAvatar(
                  name: demoProfile.username,
                  tierIdx: widget.tierIdx,
                  image: avatar.picture,
                  size: 110,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                L.of(context).yourPicture,
                style: context.type.heading.copyWith(color: context.colors.text),
              ),
              const SizedBox(height: 4),
              Text(
                L.of(context).yourPictureHint,
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: 18),
              // The lifter first: it is what every account wears.
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('editLifter'),
                  onPressed: _editLifter,
                  icon: const Icon(Icons.face_outlined, size: 20),
                  label: Text(L.of(context).editLifter),
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.brand,
                    foregroundColor: context.colors.background,
                    minimumSize: const Size.fromHeight(48),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pick(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined, size: 19),
                      label: Text(L.of(context).gallery),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pick(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined, size: 19),
                      label: Text(L.of(context).camera),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                      ),
                    ),
                  ),
                ],
              ),
              // Only with a picture to take down; set a little apart from the
              // two above so it is not hit on the way to one of them (pick R1).
              if (hasPicture) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    key: const Key('removePhoto'),
                    onPressed: _removing ? null : _remove,
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: Text(L.of(context).removePhoto),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.loss,
                      minimumSize: const Size.fromHeight(48),
                      textStyle: context.type.label.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: context.type.label.copyWith(color: AppColors.loss),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Asked before the picture goes: the lifter it leaves, in the frame it will
/// sit in, and what removing does.
class _RemoveDialog extends StatelessWidget {
  const _RemoveDialog({required this.tierIdx});
  final int tierIdx;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Dialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayerAvatar(
              name: demoProfile.username,
              tierIdx: tierIdx,
              image: switch (MyLifter.instance.built) {
                final made? => LifterPicture(made),
                null => null,
              },
              size: 64,
            ),
            const SizedBox(height: 12),
            Text(
              l.removePhotoTitle,
              textAlign: TextAlign.center,
              style: context.type.heading.copyWith(color: context.colors.text),
            ),
            const SizedBox(height: 6),
            Text(
              l.removePhotoBody,
              textAlign: TextAlign.center,
              style: context.type.label.copyWith(color: context.colors.muted),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                    ),
                    child: Text(l.cancel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    key: const Key('confirmRemovePhoto'),
                    onPressed: () => Navigator.of(context).pop(true),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      foregroundColor: AppColors.loss,
                      backgroundColor: AppColors.loss.withValues(alpha: 0.13),
                      side: BorderSide(
                        color: AppColors.loss.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      l.removePhotoConfirm,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
