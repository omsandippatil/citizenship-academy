import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'lesson_screen.dart';

class CourseRoadmapScreen extends StatelessWidget {
  final CourseModel course;

  const CourseRoadmapScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 700;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(course.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(course.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWide ? 580 : double.infinity),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 28),
                _buildRoadmap(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    int completed = course.modules.where((m) => m.isCompleted).length;
    double progress = completed / course.modules.length;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: course.accentColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(course.emoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text(course.description,
                        style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$completed / ${course.modules.length} lessons',
                  style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700)),
              Text('${(progress * 100).toInt()}%',
                  style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmap(BuildContext context) {
    return Column(
      children: List.generate(course.modules.length, (i) {
        final mod = course.modules[i];
        return _buildModuleNode(context, mod, i);
      }),
    );
  }

  Widget _buildModuleNode(BuildContext context, LessonModule mod, int index) {
    final isLeft = index % 2 == 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (!isLeft) const Spacer(),
            GestureDetector(
              onTap: mod.isLocked
                  ? () => _showLockedDialog(context)
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonScreen(
                            course: course,
                            module: mod,
                          ),
                        ),
                      ),
              child: _buildNodeCard(mod),
            ),
            if (isLeft) const Spacer(),
          ],
        ),
        if (index < course.modules.length - 1)
          Padding(
            padding: EdgeInsets.only(
              left: isLeft ? 80 : 0,
              right: isLeft ? 0 : 80,
            ),
            child: Container(
              width: 2,
              height: 32,
              color: mod.isCompleted ? course.accentColor : AppTheme.border,
            ),
          ),
      ],
    );
  }

  Widget _buildNodeCard(LessonModule mod) {
    Color cardBg;
    Color borderColor;
    if (mod.isCompleted) {
      cardBg = course.accentColor.withValues(alpha: 0.1);
      borderColor = course.accentColor;
    } else if (!mod.isLocked) {
      cardBg = AppTheme.cardBg;
      borderColor = course.accentColor;
    } else {
      cardBg = AppTheme.border.withValues(alpha: 0.3);
      borderColor = AppTheme.border;
    }

    String typeEmoji;
    switch (mod.type) {
      case ModuleType.video:
        typeEmoji = '▶️';
        break;
      case ModuleType.quiz:
        typeEmoji = '📝';
        break;
      case ModuleType.game:
        typeEmoji = '🎮';
        break;
    }

    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: mod.isLocked
            ? null
            : [BoxShadow(color: course.accentColor.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: mod.isLocked ? AppTheme.border.withValues(alpha: 0.5) : course.accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: mod.isLocked
                  ? const Icon(Icons.lock, size: 18, color: AppTheme.muted)
                  : Text(mod.emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mod.title,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: mod.isLocked ? AppTheme.muted : AppTheme.textDark),
                    maxLines: 2),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(typeEmoji, style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 4),
                    Text(
                      mod.type.name[0].toUpperCase() + mod.type.name.substring(1),
                      style: const TextStyle(fontSize: 11, color: AppTheme.muted, fontWeight: FontWeight.w600),
                    ),
                    if (mod.isCompleted) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle, size: 13, color: Color(0xFF4CAF50)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppTheme.cardBg,
        title: const Text('🔒 Locked', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'Complete the previous lessons to unlock this one!',
          style: TextStyle(color: AppTheme.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}