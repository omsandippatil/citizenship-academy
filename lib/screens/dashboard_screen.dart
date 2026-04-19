import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import 'course_roadmap_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCourseIndex = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const List<Color> _palette = [
    Color(0xFF20B2AA),
    Color(0xFFE07A5F),
    Color(0xFF3D9BE9),
    Color(0xFFF2A541),
    Color(0xFF6BAE75),
    Color(0xFF9B72CF),
  ];

  Color _colorFor(int index) => _palette[index % _palette.length];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Scaffold(
          backgroundColor: AppTheme.bg,
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? w * 0.05 : 22,
                    vertical: 24,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildSectionLabel('YOUR COURSES'),
                      const SizedBox(height: 14),
                      _buildCourseCarousel(),
                      const SizedBox(height: 24),
                      _buildActiveCourseCard(),
                      const SizedBox(height: 36),
                      _buildSectionLabel('EXPLORE MORE'),
                      const SizedBox(height: 16),
                      _buildExploreGrid(isWide),
                      const SizedBox(height: 32),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = AppData.currentUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey, ${user.name.split(' ').first}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Ready to level up today?',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.muted,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.local_fire_department_rounded,
                size: 18, color: AppTheme.primary),
            const SizedBox(width: 4),
            Text(
              '${user.streak}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 14),
            const Icon(Icons.star_rounded, size: 18, color: AppTheme.gold),
            const SizedBox(width: 4),
            Text(
              '${user.points}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
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

  Widget _buildCourseCarousel() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: AppData.courses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final course = AppData.courses[i];
          final isSelected = _selectedCourseIndex == i;
          final progress =
              AppData.currentUser.courseProgress[course.id] ?? 0.0;
          final color = _colorFor(i);

          return GestureDetector(
            onTap: () => setState(() => _selectedCourseIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              width: 72,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircularCourseIcon(course, isSelected, progress, color),
                  const SizedBox(height: 6),
                  Text(
                    course.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? color : AppTheme.muted,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircularCourseIcon(
      CourseModel course, bool isSelected, double progress, Color color) {
    const double size = 52;
    const double strokeWidth = 3.0;

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
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation(
                AppTheme.border.withValues(alpha: 0.6),
              ),
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation(
                isSelected ? color : color.withValues(alpha: 0.55),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: size - strokeWidth * 4,
            height: size - strokeWidth * 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? color.withValues(alpha: 0.1)
                  : AppTheme.cardBg,
              border: Border.all(
                color: isSelected
                    ? color.withValues(alpha: 0.3)
                    : AppTheme.border,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                course.icon,
                size: 20,
                color: isSelected ? color : AppTheme.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCourseCard() {
    final course = AppData.courses[_selectedCourseIndex];
    final color = _colorFor(_selectedCourseIndex);
    final progress = AppData.currentUser.courseProgress[course.id] ?? 0.0;
    final points = AppData.currentUser.coursePoints[course.id] ?? 0;
    final pct = (progress * 100).toInt();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: Container(
        key: ValueKey(course.id),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.border, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.1),
                    border: Border.all(
                        color: color.withValues(alpha: 0.2), width: 1.5),
                  ),
                  child: Center(
                    child: Icon(course.icon, size: 24, color: color),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        course.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 16, color: AppTheme.gold),
                    const SizedBox(width: 4),
                    Text(
                      '$points',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.muted,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '$pct%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildProgressBar(progress, color),
            const SizedBox(height: 22),
            _buildRoadmapPreview(course, color),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseRoadmapScreen(course: course),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue Learning',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, Color color) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color.withValues(alpha: 0.1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: constraints.maxWidth * progress,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoadmapPreview(CourseModel course, Color color) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: course.modules.length,
        itemBuilder: (context, i) {
          final mod = course.modules[i];
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _roadmapNode(mod, color),
              if (i < course.modules.length - 1)
                Container(
                  width: 18,
                  height: 1.5,
                  color: mod.isCompleted
                      ? color.withValues(alpha: 0.4)
                      : AppTheme.border,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _roadmapNode(LessonModule mod, Color color) {
    final Color bg;
    final Color border;
    final Color iconColor;

    if (mod.isCompleted) {
      bg = color;
      border = color;
      iconColor = Colors.white;
    } else if (!mod.isLocked) {
      bg = color.withValues(alpha: 0.08);
      border = color;
      iconColor = color;
    } else {
      bg = AppTheme.softGreen;
      border = AppTheme.border;
      iconColor = AppTheme.muted;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 1.5),
      ),
      child: Center(
        child: mod.isLocked
            ? Icon(Icons.lock_rounded, size: 14, color: iconColor)
            : Icon(_moduleIcon(mod.type), size: 16, color: iconColor),
      ),
    );
  }

  IconData _moduleIcon(ModuleType type) {
    switch (type) {
      case ModuleType.video:
        return Icons.play_arrow_rounded;
      case ModuleType.quiz:
        return Icons.quiz_rounded;
      case ModuleType.game:
        return Icons.sports_esports_rounded;
    }
  }

  Widget _buildExploreGrid(bool isWide) {
    const exploreCourses = AppData.exploreCourses;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 2 : 1,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: isWide ? 2.8 : 3.2,
      ),
      itemCount: exploreCourses.length,
      itemBuilder: (context, i) =>
          _buildExploreTile(exploreCourses[i], _colorFor(i)),
    );
  }

  Widget _buildExploreTile(ExploreCourse course, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              border: Border.all(
                  color: color.withValues(alpha: 0.2), width: 1.5),
            ),
            child: Center(
              child: Icon(course.icon, size: 22, color: color),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.softGreen,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        course.tag,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.muted,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  course.subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.softGreen,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppTheme.border, width: 1.5),
              ),
              child: const Text(
                'Enroll',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}