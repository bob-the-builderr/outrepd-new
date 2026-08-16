import 'dart:math';

import 'package:flutter/material.dart';

import '../crew_options.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'crew.dart';

/// Everything a crew needs before it exists: identity, home, and who gets in.
class CreateCrewScreen extends StatefulWidget {
  const CreateCrewScreen({super.key});

  @override
  State<CreateCrewScreen> createState() => _CreateCrewScreenState();
}

class _CreateCrewScreenState extends State<CreateCrewScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();

  String _country = 'Egypt';
  int _icon = 0;
  int _colour = 0;
  CrewPrivacy _privacy = CrewPrivacy.open;
  int _minTier = 0;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  String _newCode() {
    // Ambiguous characters are left out so a code read aloud cannot be mistyped.
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random();
    return List.generate(6, (_) => chars[r.nextInt(chars.length)]).join();
  }

  void _create() {
    final name = _name.text.trim();

    if (name.length < 3) {
      _complain('Give the crew a name of at least 3 characters');
      return;
    }
    myCrew = MyCrew(
      name: name,
      country: _country,
      emblemIcon: _icon,
      emblemColor: _colour,
      inviteCode: _newCode(),
      description: _description.text.trim(),
      privacy: _privacy.index,
      minTierIdx: _minTier,
      members: [
        CrewMember(
          demoProfile.username,
          demoProfile.tierIdx,
          demoProfile.divIdx,
          demoProfile.totalVolumeKg ~/ 8,
          isOwner: true,
        ),
      ],
    );
    Navigator.of(context).pop(true);
  }

  void _complain(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickCountry() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => const _CountryPicker(),
    );
    if (picked != null) setState(() => _country = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a crew')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Center(
            child: CrewEmblem(iconIdx: _icon, colorIdx: _colour, size: 96),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _name.text.trim().isEmpty ? 'Your crew' : _name.text.trim(),
              style: TextStyle(
                color: context.colors.text,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const _FieldLabel('Crew name'),
          TextField(
            controller: _name,
            maxLength: 22,
            style: TextStyle(color: context.colors.text),
            decoration: const InputDecoration(
              counterText: '',
              hintText: 'Iron Temple',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('Motto'),
          TextField(
            controller: _description,
            maxLength: 80,
            maxLines: 2,
            style: TextStyle(color: context.colors.text, fontSize: 14),
            decoration: const InputDecoration(
              counterText: '',
              hintText: 'What does this crew stand for?',
            ),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('Country'),
          Panel(
            onTap: _pickCountry,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Icon(Icons.public, color: context.colors.brand, size: 19),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _country,
                    style: TextStyle(color: context.colors.text, fontSize: 14),
                  ),
                ),
                Icon(Icons.chevron_right, color: context.colors.muted),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('Who can join'),
          for (final p in CrewPrivacy.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Panel(
                onTap: () => setState(() => _privacy = p),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      p.icon,
                      size: 19,
                      color: _privacy == p ? context.colors.brand : context.colors.muted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.label,
                            style: TextStyle(
                              color:
                                  _privacy == p ? context.colors.text : context.colors.muted,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.description,
                            style: TextStyle(
                              color: context.colors.muted,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_privacy == p)
                      Icon(Icons.check_circle,
                          color: context.colors.brand, size: 19),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 14),
          const _FieldLabel('Minimum rank'),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kTiers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = _minTier == i;
                return GestureDetector(
                  onTap: () => setState(() => _minTier = i),
                  child: Container(
                    width: 74,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            selected ? context.colors.brand : context.colors.surfaceRaised,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TierBadge(tierIdx: i, size: 32),
                        const SizedBox(height: 4),
                        Text(
                          i == 0 ? 'Anyone' : kTiers[i].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: selected ? context.colors.text : context.colors.muted,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          const _FieldLabel('Emblem'),
          for (final group in kCrewEmblemGroups) ...[
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                group.label,
                style: TextStyle(
                  color: context.colors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final icon in group.icons)
                  _EmblemTile(
                    icon: icon,
                    selected: kCrewIcons.indexOf(icon) == _icon,
                    onTap: () =>
                        setState(() => _icon = kCrewIcons.indexOf(icon)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
          const _FieldLabel('Colour'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < kCrewColors.length; i++)
                GestureDetector(
                  onTap: () => setState(() => _colour = i),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: kCrewColors[i],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: i == _colour ? context.colors.text : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _create,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Create crew'),
          ),
          const SizedBox(height: 10),
          Text(
            'You will be the owner. Crews hold up to 20 lifters.',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.muted, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

class _EmblemTile extends StatelessWidget {
  const _EmblemTile({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? context.colors.brand : context.colors.surfaceRaised,
            width: selected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          color: selected ? context.colors.brand : context.colors.muted,
          size: 22,
        ),
      ),
    );
  }
}

/// Searchable country list — scrolling 190 rows blind is no way to pick one.
class _CountryPicker extends StatefulWidget {
  const _CountryPicker();

  @override
  State<_CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<_CountryPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final matches = kCountries
        .where((c) => c.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: TextField(
                autofocus: true,
                style: TextStyle(color: context.colors.text),
                decoration: InputDecoration(
                  hintText: 'Search countries',
                  prefixIcon: Icon(Icons.search, color: context.colors.muted),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: matches.isEmpty
                  ? Center(
                      child: Text(
                        'No country matches that',
                        style: TextStyle(color: context.colors.muted),
                      ),
                    )
                  : ListView.builder(
                      itemCount: matches.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(
                          matches[i],
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 14.5,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pop(matches[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: context.colors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
