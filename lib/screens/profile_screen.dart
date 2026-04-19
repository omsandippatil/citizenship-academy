import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  static const Color _teal = Color(0xFF20B2AA);
  static const Color _coral = Color(0xFFE07A5F);
  static const Color _blue = Color(0xFF3D9BE9);
  static const Color _amber = Color(0xFFF2A541);
  static const Color _sage = Color(0xFF6BAE75);
  static const Color _violet = Color(0xFF9B72CF);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _progressAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser;
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 700;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeroHeader(user, w),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? w * 0.1 : 20,
                  vertical: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildPowerStats(user),
                    const SizedBox(height: 28),
                    _buildCourseProgress(user),
                    const SizedBox(height: 28),
                    _buildAchievements(),
                    const SizedBox(height: 28),
                    _buildSettingsCard(),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(UserModel user, double w) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 230,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D8B85), _teal, Color(0xFF26C5BC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: 30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), width: 1),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_rounded, size: 13, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'LEVEL 4 CITIZEN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _amber.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _amber.withValues(alpha: 0.5), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, size: 13, color: _amber),
                  const SizedBox(width: 5),
                  Text(
                    '${user.points} XP',
                    style: const TextStyle(
                      color: _amber,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (context, child) => _buildXpRing(user),
                ),
                const SizedBox(height: 10),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_rounded, size: 12, color: AppTheme.muted),
                    SizedBox(width: 3),
                    Text(
                      'Delhi Public School · Grade 10',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpRing(UserModel user) {
    const double size = 96;
    const double stroke = 5.0;
    final xpFraction = (user.points % 500) / 500.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: stroke,
              valueColor:
                  AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.15)),
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: AnimatedBuilder(
              animation: _progressAnim,
              builder: (_, __) => CircularProgressIndicator(
                value: xpFraction * _progressAnim.value,
                strokeWidth: stroke,
                strokeCap: StrokeCap.round,
                valueColor: const AlwaysStoppedAnimation(_amber),
              ),
            ),
          ),
          Container(
            width: size - stroke * 4,
            height: size - stroke * 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.cardBg,
              border: Border.all(color: AppTheme.border, width: 2),
              boxShadow: [
                BoxShadow(
                  color: _teal.withValues(alpha: 0.18),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.person_rounded, size: 38, color: _teal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerStats(UserModel user) {
    int completed = 0;
    for (final c in AppData.courses) {
      completed += c.modules.where((m) => m.isCompleted).length;
    }

    final stats = [
      _PowerStat('STREAK', '${user.streak} days',
          user.streak / 30.0, Icons.local_fire_department_rounded, _coral),
      _PowerStat('XP POINTS', '${user.points} pts',
          (user.points % 500) / 500.0, Icons.bolt_rounded, _amber),
      _PowerStat('LESSONS', '$completed done',
          completed / 20.0, Icons.check_circle_rounded, _sage),
      const _PowerStat('RANK', '#4 Global', 0.85, Icons.emoji_events_rounded, _violet),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('POWER STATS'),
        const SizedBox(height: 14),
        ...stats.map((s) => _powerStatRow(s)),
      ],
    );
  }

  Widget _powerStatRow(_PowerStat stat) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: stat.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(stat.icon, size: 18, color: stat.color),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stat.label,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.muted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        stat.value,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: stat.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: stat.color.withValues(alpha: 0.1),
                    ),
                    child: AnimatedBuilder(
                      animation: _progressAnim,
                      builder: (_, __) => FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor:
                            (stat.fraction * _progressAnim.value).clamp(0, 1),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              colors: [
                                stat.color.withValues(alpha: 0.7),
                                stat.color,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseProgress(UserModel user) {
    final colors = [_teal, _coral, _blue, _amber, _sage, _violet];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('COURSE PROGRESS'),
        const SizedBox(height: 14),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: AppData.courses.length,
            itemBuilder: (context, i) {
              final course = AppData.courses[i];
              final progress = user.courseProgress[course.id] ?? 0.0;
              final color = colors[i % colors.length];
              final pct = (progress * 100).toInt();

              return Container(
                width: 110,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: color.withValues(alpha: 0.25), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Center(
                        child: Icon(course.icon, size: 16, color: color),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: AnimatedBuilder(
                        animation: _progressAnim,
                        builder: (_, __) => LinearProgressIndicator(
                          value: progress * _progressAnim.value,
                          backgroundColor: color.withValues(alpha: 0.12),
                          valueColor: AlwaysStoppedAnimation(color),
                          minHeight: 5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$pct%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    const badges = [
      _BadgeData(Icons.star_rounded, 'First Lesson', _amber, true),
      _BadgeData(Icons.local_fire_department_rounded, '7 Day Streak', _coral, true),
      _BadgeData(Icons.account_balance_wallet_rounded, 'Finance Pro', _teal, true),
      _BadgeData(Icons.emoji_events_rounded, 'Top 5', _violet, false),
      _BadgeData(Icons.code_rounded, 'Code Master', _blue, false),
      _BadgeData(Icons.music_note_rounded, 'Music Star', _sage, false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('ACHIEVEMENTS'),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.88,
          ),
          itemCount: badges.length,
          itemBuilder: (_, i) {
            final badge = badges[i];
            return AnimatedBuilder(
              animation: _progressAnim,
              builder: (_, __) => Opacity(
                opacity: badge.earned
                    ? (_progressAnim.value).clamp(0.0, 1.0)
                    : 0.45,
                child: Container(
                  decoration: BoxDecoration(
                    color: badge.earned
                        ? badge.color.withValues(alpha: 0.08)
                        : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: badge.earned
                          ? badge.color.withValues(alpha: 0.35)
                          : AppTheme.border,
                      width: badge.earned ? 2 : 1.5,
                    ),
                    boxShadow: badge.earned
                        ? [
                            BoxShadow(
                              color: badge.color.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: badge.earned
                              ? badge.color.withValues(alpha: 0.15)
                              : AppTheme.border.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            badge.icon,
                            size: 26,
                            color: badge.earned ? badge.color : AppTheme.muted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: badge.earned ? AppTheme.textDark : AppTheme.muted,
                          letterSpacing: 0.1,
                        ),
                      ),
                      if (badge.earned) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: badge.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'EARNED',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: badge.color,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    const items = [
      _SettingData(Icons.notifications_rounded, 'Notifications',
          'Manage alerts & reminders', _teal),
      _SettingData(Icons.dark_mode_rounded, 'Appearance',
          'Theme & display settings', _violet),
      _SettingData(Icons.lock_rounded, 'Privacy', 'Data & security options', _blue),
      _SettingData(Icons.help_rounded, 'Help & Support', 'FAQs, contact us', _sage),
      _SettingData(Icons.logout_rounded, 'Log Out', 'Sign out of your account', _coral),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('SETTINGS'),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppTheme.border, width: 1.5),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isLast = i == items.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(item.icon, size: 20, color: item.color),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isLast ? _coral : AppTheme.textDark,
                                  letterSpacing: -0.1,
                                ),
                              ),
                              Text(
                                item.subtitle,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.muted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isLast
                                ? _coral.withValues(alpha: 0.1)
                                : AppTheme.border.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: isLast ? _coral : AppTheme.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 16,
                      color: AppTheme.border.withValues(alpha: 0.7),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppTheme.muted,
        letterSpacing: 1.8,
      ),
    );
  }
}

class _PowerStat {
  final String label;
  final String value;
  final double fraction;
  final IconData icon;
  final Color color;
  const _PowerStat(this.label, this.value, this.fraction, this.icon, this.color);
}

class _BadgeData {
  final IconData icon;
  final String label;
  final Color color;
  final bool earned;
  const _BadgeData(this.icon, this.label, this.color, this.earned);
}

class _SettingData {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  const _SettingData(this.icon, this.label, this.subtitle, this.color);
}