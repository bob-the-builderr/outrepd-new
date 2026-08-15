import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

/// Emblems a crew can pick from. Kept to a fixed set so every crew badge sits
/// in the same visual family instead of becoming a free-for-all of uploads.
const kCrewIcons = <IconData>[
  Icons.shield,
  Icons.local_fire_department,
  Icons.bolt,
  Icons.pets,
  Icons.diamond,
  Icons.anchor,
  Icons.sports_mma,
  Icons.whatshot,
  Icons.military_tech,
  Icons.savings,
  Icons.rocket_launch,
  Icons.dark_mode,
];

const kCrewColors = <Color>[
  AppColors.brand,
  Color(0xFFFF4444),
  Color(0xFFFFD700),
  Color(0xFF22C55E),
  Color(0xFF9B59B6),
  Color(0xFFFF8C00),
  Color(0xFF00E5FF),
  Color(0xFFFF5FA2),
];

/// Crew tab: either the crew you belong to, or the ways into one.
class CrewScreen extends StatefulWidget {
  const CrewScreen({super.key});

  @override
  State<CrewScreen> createState() => _CrewScreenState();
}

class _CrewScreenState extends State<CrewScreen> {
  @override
  Widget build(BuildContext context) {
    final crew = myCrew;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Crew'),
      ),
      body: crew == null
          ? _NoCrewView(onChanged: () => setState(() {}))
          : _CrewHomeView(crew: crew, onChanged: () => setState(() {})),
    );
  }
}

class _NoCrewView extends StatelessWidget {
  const _NoCrewView({required this.onChanged});
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Panel(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Icon(Icons.groups_2, color: AppColors.brand, size: 46),
              const SizedBox(height: 14),
              const Text(
                'Start a crew',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Up to 20 lifters training under one name. Your combined '
                'volume puts the crew on the board.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    final created = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => const CreateCrewScreen(),
                      ),
                    );
                    if (created == true) onChanged();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create a crew'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showJoinSheet(context, onChanged),
                  icon: const Icon(Icons.login),
                  label: const Text('Join with a code'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Top crews'),
        for (final c in demoCrews)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _CrewRow(crew: c),
          ),
      ],
    );
  }
}

Future<void> _showJoinSheet(BuildContext context, VoidCallback onChanged) {
  final controller = TextEditingController();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Join a crew',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Paste the invite code a member sent you.',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                textCapitalization: TextCapitalization.characters,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 6,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: 'CREW CODE',
                  hintStyle: TextStyle(
                    color: AppColors.muted,
                    letterSpacing: 3,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final code = controller.text.trim().toUpperCase();
                    if (code.length != 6) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        const SnackBar(content: Text('Enter the 6-character code')),
                      );
                      return;
                    }
                    myCrew = _sampleCrewFor(code);
                    Navigator.of(sheetContext).pop();
                    onChanged();
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Join'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Until there is a server, joining any code drops you into a stocked crew so
/// the rest of the screen can be seen.
MyCrew _sampleCrewFor(String code) => MyCrew(
      name: 'Iron Temple',
      tag: 'IRN',
      country: 'Egypt',
      emblemIcon: 0,
      emblemColor: 0,
      inviteCode: code,
      members: const [
        CrewMember('iron_mike', 5, 1, 96200, isOwner: true),
        CrewMember('squat_queen', 4, 3, 88400),
        CrewMember('benchgod', 3, 1, 71300),
        CrewMember('demo_lifter', 3, 2, 64100),
        CrewMember('deadlift_dan', 3, 3, 52700),
      ],
    );

class _CrewHomeView extends StatelessWidget {
  const _CrewHomeView({required this.crew, required this.onChanged});

  final MyCrew crew;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final total =
        crew.members.fold<int>(0, (sum, m) => sum + m.weeklyVolume);
    final colour = kCrewColors[crew.emblemColor % kCrewColors.length];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Panel(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CrewEmblem(
                iconIdx: crew.emblemIcon,
                colorIdx: crew.emblemColor,
                size: 84,
              ),
              const SizedBox(height: 12),
              Text(
                crew.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '[${crew.tag}] · ${crew.country}',
                style: TextStyle(color: colour, fontSize: 12.5),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      label: 'Members',
                      value: '${crew.members.length}/${MyCrew.maxMembers}',
                    ),
                  ),
                  Expanded(
                    child: _Stat(
                      label: 'This week',
                      value: formatVolume(total),
                    ),
                  ),
                  const Expanded(
                    child: _Stat(label: 'Rank', value: '#4'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _InviteCard(crew: crew),
        const SizedBox(height: 20),
        SectionHeader(
          title: 'Members',
          trailing: Text(
            '${crew.members.length} of ${MyCrew.maxMembers}',
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
        for (final m in crew.members)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MemberRow(member: m),
          ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () {
            myCrew = null;
            onChanged();
          },
          icon: const Icon(Icons.logout, size: 18, color: AppColors.loss),
          label: const Text(
            'Leave crew',
            style: TextStyle(color: AppColors.loss),
          ),
        ),
      ],
    );
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard({required this.crew});
  final MyCrew crew;

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Invite lifters',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _CopyRow(
            label: 'Referral code',
            value: crew.inviteCode,
            mono: true,
          ),
          const SizedBox(height: 10),
          _CopyRow(label: 'Invite link', value: crew.inviteLink),
        ],
      ),
    );
  }
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.muted, fontSize: 10.5),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mono ? 17 : 12.5,
                    fontWeight: mono ? FontWeight.w800 : FontWeight.w500,
                    letterSpacing: mono ? 4 : 0,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: AppColors.brand, size: 19),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label copied')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member});
  final CrewMember member;

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          TierBadge(tierIdx: member.tierIdx, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                    if (member.isOwner) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.star, color: AppColors.gold, size: 14),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  tierLabel(member.tierIdx, member.divIdx),
                  style: const TextStyle(color: AppColors.muted, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Text(
            formatVolume(member.weeklyVolume),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _CrewRow extends StatelessWidget {
  const _CrewRow({required this.crew});
  final Crew crew;

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              crew.tag,
              style: const TextStyle(
                color: AppColors.brand,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crew.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${crew.members} members',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            formatVolume(crew.weeklyVolume),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// The crew's badge: a chosen icon on a chosen colour.
class CrewEmblem extends StatelessWidget {
  const CrewEmblem({
    super.key,
    required this.iconIdx,
    required this.colorIdx,
    this.size = 48,
  });

  final int iconIdx;
  final int colorIdx;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colour = kCrewColors[colorIdx % kCrewColors.length];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: colour, width: 2),
      ),
      child: Icon(
        kCrewIcons[iconIdx % kCrewIcons.length],
        color: colour,
        size: size * 0.5,
      ),
    );
  }
}

/// Name, tag, country and emblem — everything a crew needs before it exists.
class CreateCrewScreen extends StatefulWidget {
  const CreateCrewScreen({super.key});

  @override
  State<CreateCrewScreen> createState() => _CreateCrewScreenState();
}

class _CreateCrewScreenState extends State<CreateCrewScreen> {
  final _name = TextEditingController();
  final _tag = TextEditingController();
  String _country = kCountries.first;
  int _icon = 0;
  int _colour = 0;

  @override
  void dispose() {
    _name.dispose();
    _tag.dispose();
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
    final tag = _tag.text.trim().toUpperCase();

    if (name.length < 3) {
      _complain('Give the crew a name of at least 3 characters');
      return;
    }
    if (tag.length < 2) {
      _complain('The tag needs 2 to 4 characters');
      return;
    }

    myCrew = MyCrew(
      name: name,
      tag: tag,
      country: _country,
      emblemIcon: _icon,
      emblemColor: _colour,
      inviteCode: _newCode(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a crew')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Center(
            child: CrewEmblem(iconIdx: _icon, colorIdx: _colour, size: 92),
          ),
          const SizedBox(height: 22),
          const _FieldLabel('Crew name'),
          TextField(
            controller: _name,
            maxLength: 22,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              counterText: '',
              hintText: 'Iron Temple',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('Tag'),
          TextField(
            controller: _tag,
            maxLength: 4,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
            ),
            decoration: const InputDecoration(
              counterText: '',
              hintText: 'IRN',
              helperText: '2 to 4 letters, shown next to your crew name',
              helperStyle: TextStyle(color: AppColors.muted, fontSize: 11),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('Country'),
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _country,
                isExpanded: true,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                items: [
                  for (final c in kCountries)
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) => setState(() => _country = v ?? _country),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('Emblem'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < kCrewIcons.length; i++)
                GestureDetector(
                  onTap: () => setState(() => _icon = i),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: i == _icon
                            ? AppColors.brand
                            : AppColors.surfaceRaised,
                        width: i == _icon ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      kCrewIcons[i],
                      color: i == _icon ? AppColors.brand : AppColors.muted,
                      size: 22,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const _FieldLabel('Colour'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < kCrewColors.length; i++)
                GestureDetector(
                  onTap: () => setState(() => _colour = i),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kCrewColors[i],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: i == _colour
                            ? Colors.white
                            : Colors.transparent,
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
          const Text(
            'You will be the owner. Crews hold up to 20 lifters.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 11.5),
          ),
        ],
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
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
