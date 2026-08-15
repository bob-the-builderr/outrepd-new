import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../crew_options.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'crew_create.dart';

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
                crew.country,
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
