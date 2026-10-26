/// Choosing a country: the sheet, and the field that opens it.
///
/// The country decides which country board a lifter is on. The phone's own
/// region is offered first, because it is right for most people, but it is
/// wrong for plenty — a phone in Cairo set to United States is common — so
/// it is a suggestion, not the answer.
library;

import 'package:flutter/material.dart';

import '../country_names.dart';
import '../country_names.g.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

/// The chosen country's code, or null when the sheet was closed.
Future<String?> showCountryPicker(BuildContext context, {String? selected}) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CountrySheet(selected: selected),
    );

class _CountrySheet extends StatefulWidget {
  const _CountrySheet({this.selected});

  final String? selected;

  @override
  State<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends State<_CountrySheet> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final query = _search.text.trim().toLowerCase();
    final phone = deviceCountryCode();
    final named = [
      for (final code in kCountryCodes) (code, countryName(context, code)),
    ]..sort((a, b) => a.$2.compareTo(b.$2));
    final shown = query.isEmpty
        ? named
        : named
              .where(
                (c) =>
                    c.$2.toLowerCase().contains(query) ||
                    c.$1.toLowerCase() == query ||
                    // The English name too, for whoever types it that way.
                    (kCountryNames['en']![c.$1] ?? '').toLowerCase().contains(
                      query,
                    ),
              )
              .toList();

    Widget row((String, String) country) => _CountryRow(
      code: country.$1,
      name: country.$2,
      selected: country.$1 == widget.selected,
      onTap: () => Navigator.of(context).pop(country.$1),
    );

    Widget label(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: colors.muted, fontSize: 12, letterSpacing: 2),
      ),
    );

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          18,
          12,
          18,
          MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l.countryPickerTitle,
              style: TextStyle(
                color: colors.text,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('countrySearch'),
              controller: _search,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l.countrySearch,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (query.isEmpty && phone != null) ...[
                    label(l.countryFromPhone),
                    row((phone, countryName(context, phone))),
                    label(l.countryAll),
                  ],
                  for (final country in shown) row(country),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  const _CountryRow({
    required this.code,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      key: Key('country_$code'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          children: [
            Text(countryFlag(code), style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: TextStyle(color: colors.text, fontSize: 17),
              ),
            ),
            if (selected) Icon(Icons.check, color: colors.brand),
          ],
        ),
      ),
    );
  }
}

/// The country as a form field: flag, name, and Change. Opens the sheet.
class CountryField extends StatelessWidget {
  const CountryField({super.key, required this.code, required this.onChanged});

  /// Null when the phone did not say and nobody has picked yet.
  final String? code;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final code = this.code;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            key: const Key('countryField'),
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              final picked = await showCountryPicker(context, selected: code);
              if (picked != null) onChanged(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  if (code != null)
                    Text(
                      countryFlag(code),
                      style: const TextStyle(fontSize: 22),
                    )
                  else
                    Icon(Icons.public, color: colors.muted),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      code == null ? l.countryChoose : countryName(context, code),
                      style: TextStyle(
                        color: code == null ? colors.muted : colors.text,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Text(
                    l.countryChange,
                    style: TextStyle(color: colors.muted, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: Text(
            l.countryForBoard,
            style: TextStyle(color: colors.muted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
