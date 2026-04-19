import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  final List<_ScopeTab> _tabs = const [
    _ScopeTab(label: 'School', icon: Icons.school_rounded),
    _ScopeTab(label: 'District', icon: Icons.location_city_rounded),
    _ScopeTab(label: 'State', icon: Icons.map_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 700;
    const entries = AppData.leaderboard;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? w * 0.12 : 20,
                vertical: 24,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildScopeTabBar(),
                  const SizedBox(height: 28),
                  _buildPodium(entries.take(3).toList()),
                  const SizedBox(height: 28),
                  _buildRankingsHeader(),
                  const SizedBox(height: 12),
                  ...entries.skip(3).toList().asMap().entries.map(
                        (e) => _buildRankRow(e.value, e.key + 4),
                      ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppTheme.textDark,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Compete. Climb. Conquer.',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildScopeTabBar() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border, width: 1.5),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final tab = _tabs[i];
          final isSelected = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                _tabController.animateTo(i);
                setState(() => _selectedTab = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF20B2AA)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab.icon,
                      size: 15,
                      color: isSelected ? Colors.white : AppTheme.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppTheme.muted,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPodium(List<LeaderboardEntry> top) {
    if (top.length < 3) return const SizedBox();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF20B2AA), Color(0xFF0D8B85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _podiumSlot(top[1], 2),
          _podiumSlot(top[0], 1),
          _podiumSlot(top[2], 3),
        ],
      ),
    );
  }

  Widget _podiumSlot(LeaderboardEntry entry, int rank) {
    final podiumHeights = {1: 96.0, 2: 72.0, 3: 56.0};
    final avatarSizes = {1: 66.0, 2: 54.0, 3: 50.0};
    final iconSizes = {1: 30.0, 2: 24.0, 3: 22.0};
    final nameSizes = {1: 14.0, 2: 12.0, 3: 12.0};

    final h = podiumHeights[rank]!;
    final avatarSize = avatarSizes[rank]!;
    final iconSize = iconSizes[rank]!;
    final nameSize = nameSizes[rank]!;
    final isFirst = rank == 1;

    final medalColors = {
      1: const Color(0xFFFACC15),
      2: const Color(0xFFCBD5E1),
      3: const Color(0xFFD97706),
    };

    final medalIcons = {
      1: Icons.workspace_premium_rounded,
      2: Icons.military_tech_rounded,
      3: Icons.shield_rounded,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          medalIcons[rank]!,
          color: medalColors[rank]!,
          size: isFirst ? 28 : 22,
        ),
        const SizedBox(height: 6),
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(
              color: medalColors[rank]!.withValues(alpha: 0.85),
              width: isFirst ? 2.5 : 2,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: iconSize,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry.name.split(' ').first,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: nameSize,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              size: 11,
              color: Colors.white.withValues(alpha: 0.75),
            ),
            const SizedBox(width: 3),
            Text(
              '${entry.points} pts',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: isFirst ? 64 : 52,
          height: h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isFirst ? 0.32 : 0.18),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: isFirst ? 22 : 17,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingsHeader() {
    return Row(
      children: [
        const Icon(Icons.leaderboard_rounded, size: 16, color: AppTheme.muted),
        const SizedBox(width: 7),
        const Text(
          'ALL RANKINGS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppTheme.muted,
            letterSpacing: 1.6,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF20B2AA).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              const Icon(Icons.filter_list_rounded,
                  size: 12, color: Color(0xFF20B2AA)),
              const SizedBox(width: 4),
              Text(
                _tabs[_selectedTab].label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF20B2AA),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankRow(LeaderboardEntry entry, int displayRank) {
    final isMe = entry.name == 'Manu Agarwal';

    final rankColor = displayRank <= 5
        ? const Color(0xFF20B2AA)
        : displayRank <= 10
            ? const Color(0xFF3D9BE9)
            : AppTheme.muted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xFF20B2AA).withValues(alpha: 0.07)
            : AppTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isMe
              ? const Color(0xFF20B2AA).withValues(alpha: 0.5)
              : AppTheme.border,
          width: isMe ? 2 : 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isMe
                  ? const Color(0xFF20B2AA)
                  : rankColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$displayRank',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isMe ? Colors.white : rankColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isMe
                  ? const Color(0xFF20B2AA).withValues(alpha: 0.12)
                  : AppTheme.border.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.person_rounded,
                size: 20,
                color: isMe ? const Color(0xFF20B2AA) : AppTheme.muted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF20B2AA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'YOU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        size: 12, color: Color(0xFFE07A5F)),
                    const SizedBox(width: 3),
                    Text(
                      '${entry.streak}d streak',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.bolt_rounded,
                        size: 12, color: Color(0xFFF2A541)),
                    const SizedBox(width: 3),
                    Text(
                      '${(entry.points / 100).floor()} lvl',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.points}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color:
                      isMe ? const Color(0xFF20B2AA) : AppTheme.textDark,
                  letterSpacing: -0.5,
                ),
              ),
              const Text(
                'pts',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScopeTab {
  final String label;
  final IconData icon;
  const _ScopeTab({required this.label, required this.icon});
}