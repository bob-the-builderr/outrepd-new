import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../avatar.dart';
import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../data.dart';
import '../player_avatar.dart';
import '../theme.dart';

/// Choosing a picture: one from the phone, or one the app provides.
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
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 88,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
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
          await backend.uploadAvatar(bytes);
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

  @override
  Widget build(BuildContext context) {
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
                  image: avatar.hasPhoto
                      ? FileImage(File(avatar.photoPath!))
                      : null,
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
