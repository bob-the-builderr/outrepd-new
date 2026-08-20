import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../avatar.dart';
import '../profile_avatar.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';

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

      final dir = await getApplicationDocumentsDirectory();
      final target = File(
        '${dir.path}/avatar-${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await target.writeAsBytes(await picked.readAsBytes());
      await avatar.usePhoto(target.path);

      if (mounted) Navigator.of(context).pop();
    } on Object catch (error) {
      if (mounted) setState(() => _error = 'Could not use that picture: $error');
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
                child: ProfileAvatar(tierIdx: widget.tierIdx, size: 110),
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
              const SizedBox(height: 22),
              SectionHeader(title: L.of(context).orPickOurs),
              _BuiltInGrid(
                onPicked: (icon, colour) async {
                  await avatar.useBuiltIn(icon, colour);
                  if (context.mounted) setState(() {});
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icons first, then the colour they sit on — two short lists rather than one
/// enormous grid of every pairing.
class _BuiltInGrid extends StatelessWidget {
  const _BuiltInGrid({required this.onPicked});
  final void Function(int icon, int colour) onPicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < kAvatarIcons.length; i++)
              GestureDetector(
                onTap: () => onPicked(i, avatar.colorIdx),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: !avatar.hasPhoto && avatar.iconIdx == i
                          ? context.colors.brand
                          : context.colors.surfaceRaised,
                      width: !avatar.hasPhoto && avatar.iconIdx == i ? 2 : 1,
                    ),
                  ),
                  child: Icon(
                    kAvatarIcons[i],
                    color: !avatar.hasPhoto && avatar.iconIdx == i
                        ? context.colors.brand
                        : context.colors.muted,
                    size: 22,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < kAvatarColors.length; i++)
              GestureDetector(
                onTap: () => onPicked(avatar.iconIdx, i),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kAvatarColors[i],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: !avatar.hasPhoto && avatar.colorIdx == i
                          ? context.colors.text
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
