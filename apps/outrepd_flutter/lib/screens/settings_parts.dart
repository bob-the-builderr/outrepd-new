/// The pieces every settings screen is built from.
///
/// One set of rows, shared, because the settings tree is now seven screens
/// deep and a row that looks slightly different on the privacy screen than
/// on the main one reads as two different apps.
library;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../widgets.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

/// Shared chrome for a settings row: icon, label, optional caption, and a
/// hairline unless it closes the section.
class RowFrame extends StatelessWidget {
  const RowFrame({
    super.key,
    required this.icon,
    required this.label,
    required this.trailing,
    this.caption,
    this.onTap,
    this.last = false,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final String? caption;
  final VoidCallback? onTap;
  final bool last;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final tint = danger ? AppColors.loss : context.colors.text;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: BorderSide(color: context.colors.surfaceRaised)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: danger ? AppColors.loss : context.colors.muted,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.type.body.copyWith(color: tint)),
                  if (caption != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      caption!,
                      style: context.type.label.copyWith(
                        color: context.colors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.caption,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? caption;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return RowFrame(
      icon: icon,
      label: label,
      caption: caption,
      last: last,
      onTap: () => onChanged(!value),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: context.colors.brand,
      ),
    );
  }
}

class NavRow extends StatelessWidget {
  const NavRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.caption,
    this.onTap,
    this.last = false,
    this.danger = false,
    this.chevron = true,
  });

  final IconData icon;
  final String label;
  final String? value;
  final String? caption;
  final VoidCallback? onTap;
  final bool last;
  final bool danger;
  final bool chevron;

  @override
  Widget build(BuildContext context) {
    return RowFrame(
      icon: icon,
      label: label,
      caption: caption,
      last: last,
      danger: danger,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            ConstrainedBox(
              // Long unit names would otherwise shove the label off the row.
              constraints: const BoxConstraints(maxWidth: 130),
              child: Text(
                value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
            ),
          if (chevron)
            Icon(Icons.chevron_right, size: 20, color: context.colors.muted),
        ],
      ),
    );
  }
}

/// One sheet for every either-or setting in the app.
Future<T?> pickOne<T>({
  required BuildContext context,
  required String title,
  required List<T> values,
  required T current,
  required String Function(T) label,
  required void Function(T) onPick,
  String Function(T)? caption,
  IconData Function(T)? icon,
}) async {
  final picked = await showModalBottomSheet<T>(
    context: context,
    backgroundColor: context.colors.surface,
    // The language list is fifteen entries long. Without this the sheet
    // stops at half the screen and the bottom half of the list is
    // unreachable — you cannot pick Japanese at all.
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
              child: Text(
                title,
                style: context.type.heading.copyWith(
                  color: context.colors.text,
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10),
                children: [
                  for (final v in values)
                    ListTile(
                      leading: icon == null
                          ? null
                          : Icon(
                              icon(v),
                              color: v == current
                                  ? context.colors.brand
                                  : context.colors.muted,
                            ),
                      title: Text(
                        label(v),
                        style: TextStyle(
                          color: context.colors.text,
                          fontWeight: v == current
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      subtitle: caption == null
                          ? null
                          : Text(
                              caption(v),
                              style: context.type.label.copyWith(
                                color: context.colors.muted,
                              ),
                            ),
                      trailing: v == current
                          ? Icon(
                              Icons.check_circle,
                              color: context.colors.brand,
                            )
                          : null,
                      onTap: () => Navigator.of(context).pop(v),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  if (picked != null) onPick(picked);
  return picked;
}

/// The two-button "are you sure" every destructive row goes through.
Future<void> confirm({
  required BuildContext context,
  required String title,
  required String body,
  required String action,
  required VoidCallback onConfirm,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: context.colors.surface,
      title: Text(title, style: TextStyle(color: context.colors.text)),
      content: Text(body, style: TextStyle(color: context.colors.muted)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            L.of(context).cancel,
            style: TextStyle(color: context.colors.muted),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            action,
            style: const TextStyle(
              color: AppColors.loss,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
  if (ok == true) onConfirm();
}
