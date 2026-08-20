import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../crew_options.dart';
import '../data.dart';
import '../profile_avatar.dart';
import '../motion.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';
import 'crew_create.dart';

/// Crew tab: either the crew you belong to, or the ways into one.
class CrewScreen extends StatefulWidget {
  const CrewScreen({super.key, this.initialTab = 0});

  /// Which tab to open on. Only the web preview passes it — tapping a tab
  /// through the canvas there is unreliable.
  final int initialTab;

  @override
  State<CrewScreen> createState() => _CrewScreenState();
}

class _CrewScreenState extends State<CrewScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(
    length: 2,
    vsync: this,
    initialIndex: widget.initialTab.clamp(0, 1),
  );

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _changed() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final crew = myCrew;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(L.of(context).crew),
        // The tabs only mean anything once there is a crew to switch away
        // from, so someone with none sees a single, undivided screen.
        bottom: crew == null
            ? null
            : TabBar(
                controller: _tabs,
                indicatorColor: context.colors.brand,
                labelColor: context.colors.text,
                unselectedLabelColor: context.colors.muted,
                labelStyle: context.type.body,
                tabs: [
                  Tab(text: L.of(context).myCrew),
                  Tab(text: L.of(context).rankings),
                ],
              ),
      ),
      body: crew == null
          ? _NoCrewView(onChanged: _changed)
          : TabBarView(
              controller: _tabs,
              children: [
                _CrewTab(crew: crew, onChanged: _changed),
                _RankingsTab(crew: crew),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------- no crew

class _NoCrewView extends StatelessWidget {
  const _NoCrewView({required this.onChanged});
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Panel(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              Icon(Icons.groups_2, color: context.colors.brand, size: 46),
              const SizedBox(height: 14),
              Text(
                L.of(context).trainWithCrew,
                style: context.type.heading.copyWith(color: context.colors.text),
              ),
              const SizedBox(height: 6),
              Text(
                L.of(context).trainWithCrewHint,
                textAlign: TextAlign.center,
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: 22),
              _WayIn(
                icon: Icons.add_circle_outline,
                title: L.of(context).createCrew,
                subtitle: L.of(context).createCrewHint,
                primary: true,
                onTap: () async {
                  final created = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => const CreateCrewScreen(),
                    ),
                  );
                  if (created == true) onChanged();
                },
              ),
              const SizedBox(height: 10),
              _WayIn(
                icon: Icons.public,
                title: L.of(context).joinOpenCrew,
                subtitle: L.of(context).joinOpenCrewHint,
                onTap: () => _showOpenCrewsSheet(context, onChanged),
              ),
              const SizedBox(height: 10),
              _WayIn(
                icon: Icons.mail_outline,
                title: L.of(context).yourInvites,
                subtitle: L.of(context).yourInvitesHint,
                badge: demoInvites.length,
                onTap: () => _showInvitesSheet(context, onChanged),
              ),
              const SizedBox(height: 10),
              _WayIn(
                icon: Icons.tag,
                title: L.of(context).joinWithCode,
                subtitle: L.of(context).joinWithCodeHint,
                onTap: () => _showJoinSheet(context, onChanged),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader(title: L.of(context).topCrewsThisWeek),
        for (final ranked in rankedCrews(null).take(5))
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RankRow(entry: ranked),
          ),
      ],
    );
  }
}

/// One route into a crew. The first is filled in because creating one is the
/// choice most people arrive wanting.
class _WayIn extends StatelessWidget {
  const _WayIn({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.primary = false,
    this.badge = 0,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool primary;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final brand = context.colors.brand;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: primary ? brand : context.colors.background,
            borderRadius: BorderRadius.circular(14),
            border: primary
                ? null
                : Border.all(color: context.colors.surfaceRaised),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: primary ? Colors.white : brand, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.type.body.copyWith(color: primary ? Colors.white : context.colors.text),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: context.type.label.copyWith(color: primary
                            ? Colors.white.withValues(alpha: 0.85)
                            : context.colors.muted),
                    ),
                  ],
                ),
              ),
              if (badge > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.loss,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    localNumber(context, badge),
                    style: context.type.label.copyWith(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------- my crew tab

class _CrewTab extends StatelessWidget {
  const _CrewTab({required this.crew, required this.onChanged});

  final MyCrew crew;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final colour = kCrewColors[crew.emblemColor % kCrewColors.length];
    final place = rankedCrews(crew).indexWhere((e) => e.isMine) + 1;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                style: context.type.title.copyWith(color: context.colors.text),
              ),
              const SizedBox(height: 4),
              Text(crew.country, style: context.type.label.copyWith(color: colour)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      label: L.of(context).members,
                      value: '${crew.members.length}/${MyCrew.maxMembers}',
                    ),
                  ),
                  Expanded(
                    child: _Stat(
                      label: L.of(context).repsEach,
                      value: localNumber(context, crew.repsPerMember),
                    ),
                  ),
                  Expanded(
                    child: _Stat(label: L.of(context).rank, value: '#$place'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _WeeklyGoalCard(crew: crew),
        const SizedBox(height: 20),
        _CrewWarCard(crew: crew),
        const SizedBox(height: 22),
        SectionHeader(
          title: L.of(context).whoIsPulling,
          trailing: Text(
            L.of(context).thisWeek,
            style: context.type.label.copyWith(color: context.colors.muted),
          ),
        ),
        _Contributions(crew: crew),
        const SizedBox(height: 22),
        // The whole roster, not only the ones putting numbers up. Somebody
        // joining wants to see who they have joined.
        SectionHeader(
          title: L.of(context).members,
          trailing: Text(
            L.of(context).xOfY(localNumber(context, crew.members.length),
                localNumber(context, MyCrew.maxMembers)),
            style: context.type.label.copyWith(color: context.colors.muted),
          ),
        ),
        Panel(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              for (var i = 0; i < crew.members.length; i++)
                _MemberRow(
                  member: crew.members[i],
                  last: i == crew.members.length - 1,
                ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _InviteCard(crew: crew),
        const SizedBox(height: 14),
        TextButton.icon(
          onPressed: () {
            myCrew = null;
            onChanged();
          },
          icon: const Icon(Icons.logout, size: 18, color: AppColors.loss),
          label: Text(
            L.of(context).leaveCrew,
            style: const TextStyle(color: AppColors.loss),
          ),
        ),
      ],
    );
  }
}

/// The shared target. Without one a crew is a list of names — this is the bit
/// that makes anyone chase up the member who has not trained since Monday.
class _WeeklyGoalCard extends StatelessWidget {
  const _WeeklyGoalCard({required this.crew});
  final MyCrew crew;

  @override
  Widget build(BuildContext context) {
    final progress = crew.goalProgress;
    final left = (crew.weeklyGoal - crew.weeklyReps).clamp(0, 1 << 30);
    final done = left == 0;

    return Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                done ? Icons.emoji_events : Icons.flag_outlined,
                color: done ? AppColors.gold : context.colors.brand,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  done ? L.of(context).weeklyGoalDone : L.of(context).weeklyGoal,
                  style: context.type.body.copyWith(color: context.colors.text),
                ),
              ),
              Text(
                L.of(context).xOfY(localNumber(context, crew.weeklyReps),
                    localNumber(context, crew.weeklyGoal)),
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GrowingBar(
            value: progress,
            height: 10,
            colour: done ? AppColors.gold : context.colors.brand,
            background: context.colors.surfaceRaised,
          ),
          const SizedBox(height: 10),
          Text(
            done
                ? L.of(context).goalDoneHint
                : L.of(context).goalRemaining(localNumber(context, left),
                    localNumber(context, daysLeftInWeek())),
            style: context.type.label.copyWith(color: context.colors.muted),
          ),
        ],
      ),
    );
  }
}

/// Crew against crew. The whole reason a crew has a combined number.
class _CrewWarCard extends StatelessWidget {
  const _CrewWarCard({required this.crew});
  final MyCrew crew;

  @override
  Widget build(BuildContext context) {
    return Panel(
      onTap: () => _showWarSheet(context, crew),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.loss.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_fire_department,
                color: AppColors.loss, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L.of(context).startCrewWar,
                  style: context.type.body.copyWith(color: context.colors.text),
                ),
                const SizedBox(height: 2),
                Text(
                  L.of(context).startCrewWarHint,
                  style: context.type.label.copyWith(color: context.colors.muted),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: context.colors.muted),
        ],
      ),
    );
  }
}

/// Every member against the hardest worker, so the quiet ones are visible
/// without anybody having to say it.
class _Contributions extends StatelessWidget {
  const _Contributions({required this.crew});
  final MyCrew crew;

  @override
  Widget build(BuildContext context) {
    final sorted = List.of(crew.members)
      ..sort((a, b) => b.weeklyReps.compareTo(a.weeklyReps));
    final best = sorted.isEmpty ? 1 : sorted.first.weeklyReps.clamp(1, 1 << 30);

    return Panel(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Column(
        children: [
          for (final member in sorted)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  ProfileAvatar(
                    tierIdx: member.tierIdx,
                    username: member.username,
                    size: 44,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // The name takes all the room that is left, so the
                            // number lands on the row's right edge whatever the
                            // name's length. A Flexible name beside a Spacer
                            // shares the free space with it instead, which put
                            // every number in a different place.
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      member.username,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.type.label.copyWith(color: context.colors.text),
                                    ),
                                  ),
                                  if (member.isOwner) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.star,
                                        color: AppColors.gold, size: 13),
                                  ],
                                ],
                              ),
                            ),
                            // Fixed column, and digits that all take the same
                            // width. Proportional figures make 1480 and 940
                            // start in different places, which reads as a
                            // scattered column however neatly it is aligned.
                            SizedBox(
                              width: 46,
                              child: Text(
                                localNumber(context, member.weeklyReps),
                                textAlign: TextAlign.right,
                                style: context.type.label.copyWith(color: context.colors.text, fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        GrowingBar(
                          value: member.weeklyReps / best,
                          height: 6,
                          radius: 6,
                          colour: member.weeklyReps == 0
                              ? AppColors.loss
                              : context.colors.brand,
                          background: context.colors.surfaceRaised,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// One name on the roster: their picture, their rank, and whether they run it.
class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member, required this.last});

  final CrewMember member;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: context.colors.surfaceRaised)),
      ),
      child: Row(
        children: [
          ProfileAvatar(
            tierIdx: member.tierIdx,
            username: member.username,
            size: 46,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.type.body.copyWith(color: context.colors.text),
                ),
                const SizedBox(height: 2),
                Text(
                  tierLabel(L.of(context), member.tierIdx, member.divIdx),
                  style: context.type.label.copyWith(color: context.colors.muted),
                ),
              ],
            ),
          ),
          if (member.isOwner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                L.of(context).owner,
                style: context.type.label.copyWith(color: AppColors.gold),
              ),
            ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------ rankings tab

class _RankingsTab extends StatelessWidget {
  const _RankingsTab({required this.crew});
  final MyCrew crew;

  @override
  Widget build(BuildContext context) {
    final table = rankedCrews(crew);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Panel(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.calendar_month, color: context.colors.brand, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L.of(context).season(seasonName()),
                      style: context.type.body.copyWith(color: context.colors.text),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // Without a reset the first crew to the top stays there
                      // and nobody new has a reason to try.
                      L.of(context)
                          .seasonResets(localNumber(context, daysLeftInSeason())),
                      style:
                          context.type.label.copyWith(color: context.colors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionHeader(
          title: L.of(context).crewTable,
          trailing: Text(
            L.of(context).repsPerMember,
            style: context.type.label.copyWith(color: context.colors.muted),
          ),
        ),
        for (final entry in table)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RankRow(entry: entry),
          ),
        const SizedBox(height: 8),
        Text(
          L.of(context).rankingExplained,
          style: context.type.label.copyWith(color: context.colors.muted),
        ),
      ],
    );
  }
}

/// One line of the crew table.
class RankedCrew {
  const RankedCrew({
    required this.place,
    required this.name,
    required this.tag,
    required this.members,
    required this.repsPerMember,
    required this.isMine,
  });

  final int place;
  final String name;
  final String tag;
  final int members;
  final int repsPerMember;
  final bool isMine;
}

/// The table, with the player's own crew slotted in where it belongs.
List<RankedCrew> rankedCrews(MyCrew? mine) {
  final rows = <RankedCrew>[
    for (final c in demoCrews)
      RankedCrew(
        place: 0,
        name: c.name,
        tag: c.tag,
        members: c.members,
        repsPerMember: c.repsPerMember,
        isMine: false,
      ),
  ];

  if (mine != null) {
    rows.add(
      RankedCrew(
        place: 0,
        name: mine.name,
        tag: mine.name.length >= 3
            ? mine.name.substring(0, 3).toUpperCase()
            : mine.name.toUpperCase(),
        members: mine.members.length,
        repsPerMember: mine.repsPerMember,
        isMine: true,
      ),
    );
  }

  rows.sort((a, b) => b.repsPerMember.compareTo(a.repsPerMember));

  return [
    for (var i = 0; i < rows.length; i++)
      RankedCrew(
        place: i + 1,
        name: rows[i].name,
        tag: rows[i].tag,
        members: rows[i].members,
        repsPerMember: rows[i].repsPerMember,
        isMine: rows[i].isMine,
      ),
  ];
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.entry});
  final RankedCrew entry;

  @override
  Widget build(BuildContext context) {
    final brand = context.colors.brand;
    final medal = switch (entry.place) {
      1 => AppColors.gold,
      2 => const Color(0xFFC0C0C0),
      3 => const Color(0xFFCD7F32),
      _ => null,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: entry.isMine
            ? brand.withValues(alpha: 0.12)
            : context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: entry.isMine ? brand : context.colors.surfaceRaised,
          width: entry.isMine ? 1.6 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text(
              localNumber(context, entry.place),
              style: context.type.body.copyWith(color: medal ?? context.colors.muted),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: brand.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              entry.tag,
              style: context.type.label.copyWith(color: brand),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.type.body.copyWith(color: context.colors.text),
                ),
                const SizedBox(height: 2),
                Text(
                  L.of(context).membersCount(localNumber(context, entry.members)),
                  style: context.type.label.copyWith(color: context.colors.muted),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              localNumber(context, entry.repsPerMember),
              textAlign: TextAlign.right,
              style: context.type.body.copyWith(color: context.colors.text, fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ sheets

Future<void> _showOpenCrewsSheet(BuildContext context, VoidCallback onChanged) {
  return _sheet(
    context,
    title: L.of(context).openCrews,
    subtitle: L.of(context).openCrewsHint,
    child: Column(
      children: [
        for (final c in demoCrews.take(4))
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Panel(
              onTap: () {
                myCrew = _sampleCrewFor('OPEN01', named: c.name);
                Navigator.of(context).pop();
                onChanged();
              },
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      c.name,
                      style: context.type.body.copyWith(color: context.colors.text),
                    ),
                  ),
                  Text(
                    L.of(context).membersCount(localNumber(context, c.members)),
                    style:
                        context.type.label.copyWith(color: context.colors.muted),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: context.colors.muted),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

Future<void> _showInvitesSheet(BuildContext context, VoidCallback onChanged) {
  return _sheet(
    context,
    title: L.of(context).yourInvites,
    subtitle: L.of(context).yourInvitesSubtitle,
    child: Column(
      children: [
        for (final invite in demoInvites)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Panel(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invite.crewName,
                          style: context.type.body.copyWith(color: context.colors.text),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'from ${invite.fromUser}',
                          style: context.type.label.copyWith(color: context.colors.muted),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      myCrew =
                          _sampleCrewFor('INVITE', named: invite.crewName);
                      Navigator.of(context).pop();
                      onChanged();
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(78, 36),
                      padding: EdgeInsets.zero,
                      textStyle: context.type.label,
                    ),
                    child: Text(L.of(context).accept),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

Future<void> _showWarSheet(BuildContext context, MyCrew crew) {
  return _sheet(
    context,
    title: L.of(context).pickOpponent,
    subtitle: L.of(context).startCrewWarHint,
    child: Column(
      children: [
        for (final c in demoCrews.take(4))
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Panel(
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(L.of(context).challengeSent(c.name))),
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      c.name,
                      style: context.type.body.copyWith(color: context.colors.text),
                    ),
                  ),
                  Text(
                    L.of(context).eachCount(
                        localNumber(context, c.repsPerMember)),
                    style:
                        context.type.label.copyWith(color: context.colors.muted),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: context.colors.muted),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

Future<void> _showJoinSheet(BuildContext context, VoidCallback onChanged) {
  final controller = TextEditingController();

  return _sheet(
    context,
    title: L.of(context).joinWithCode,
    subtitle: L.of(context).joinWithCodePaste,
    child: StatefulBuilder(
      builder: (sheetContext, _) => Column(
        children: [
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: context.type.title.copyWith(color: context.colors.text),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'CREW CODE',
              hintStyle: context.type.body.copyWith(color: context.colors.muted),
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
                    SnackBar(
                      content: Text(L.of(context).enterTheCode),
                    ),
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
              child: Text(L.of(context).join),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Shared chrome for the four sheets, so they open the same way every time.
Future<void> _sheet(
  BuildContext context, {
  required String title,
  required String subtitle,
  required Widget child,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (sheetContext) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.type.heading.copyWith(color: context.colors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: context.type.label.copyWith(color: context.colors.muted),
                ),
                const SizedBox(height: 18),
                child,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Until there is a server, joining anything drops you into a stocked crew so
/// the rest of the screen can be seen.
MyCrew _sampleCrewFor(String code, {String named = 'Iron Temple'}) => MyCrew(
      name: named,
      country: 'Egypt',
      emblemIcon: 0,
      emblemColor: 0,
      inviteCode: code,
      members: const [
        CrewMember('iron_mike', 5, 1, 96200, isOwner: true, weeklyReps: 1480),
        CrewMember('squat_queen', 4, 3, 88400, weeklyReps: 1310),
        CrewMember('benchgod', 3, 1, 71300, weeklyReps: 1055),
        CrewMember('demo_lifter', 3, 2, 64100, weeklyReps: 940),
        CrewMember('deadlift_dan', 3, 3, 52700, weeklyReps: 620),
      ],
    );

// ------------------------------------------------------------------ pieces

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
          Text(
            L.of(context).inviteLifters,
            style: context.type.body.copyWith(color: context.colors.text),
          ),
          const SizedBox(height: 12),
          _CopyRow(
              label: L.of(context).referralCode,
              value: crew.inviteCode,
              mono: true),
          const SizedBox(height: 10),
          _CopyRow(label: L.of(context).inviteLink, value: crew.inviteLink),
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
        color: context.colors.background,
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
                  style: context.type.label.copyWith(color: context.colors.muted),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: mono ? 17 : 12.5,
                    fontWeight: mono ? FontWeight.w800 : FontWeight.w500,
                    letterSpacing: mono ? 4 : 0,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: context.colors.brand, size: 19),
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
          style: context.type.heading.copyWith(color: context.colors.text),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: context.type.label.copyWith(color: context.colors.muted),
        ),
      ],
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
