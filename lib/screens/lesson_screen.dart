import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'quiz_screen.dart';
import 'game_screen.dart';

class LessonScreen extends StatefulWidget {
  final CourseModel course;
  final LessonModule module;

  const LessonScreen({super.key, required this.course, required this.module});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    int tabIndex;
    switch (widget.module.type) {
      case ModuleType.video:
        tabIndex = 0;
        break;
      case ModuleType.quiz:
        tabIndex = 1;
        break;
      case ModuleType.game:
        tabIndex = 2;
        break;
    }
    _tabController = TabController(length: 3, vsync: this, initialIndex: tabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final module = widget.module;

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
            Text(module.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(module.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: course.accentColor,
          unselectedLabelColor: AppTheme.muted,
          indicatorColor: course.accentColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Nunito'),
          tabs: const [
            Tab(text: '▶️  Video'),
            Tab(text: '📝  Quiz'),
            Tab(text: '🎮  Game'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _VideoTab(course: course, module: module),
          QuizTab(course: course),
          GameTab(course: course),
        ],
      ),
    );
  }
}

class _VideoTab extends StatelessWidget {
  final CourseModel course;
  final LessonModule module;

  const _VideoTab({required this.course, required this.module});

  @override
  Widget build(BuildContext context) {
    final videos = _getVideos(course.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoPlayer(context),
          const SizedBox(height: 20),
          const Text('Lessons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
          const SizedBox(height: 12),
          ...videos.map((v) => _VideoCard(video: v, accentColor: course.accentColor)),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: course.accentColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 12),
            Text(
              '${course.emoji}  ${course.title} — Intro Video',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text('Video placeholder — link your content here',
                style: TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getVideos(String courseId) {
    final data = {
      'coding': [
        {'title': 'What is Programming?', 'duration': '5:30', 'emoji': '🧑‍💻'},
        {'title': 'Your First Program', 'duration': '8:15', 'emoji': '👶'},
        {'title': 'Variables & Data Types', 'duration': '12:00', 'emoji': '📦'},
        {'title': 'Control Flow', 'duration': '10:45', 'emoji': '🔄'},
      ],
      'music': [
        {'title': 'Understanding Notes', 'duration': '6:20', 'emoji': '🎼'},
        {'title': 'Reading Sheet Music', 'duration': '9:10', 'emoji': '📖'},
        {'title': 'Basic Rhythms', 'duration': '7:30', 'emoji': '🥁'},
        {'title': 'Playing Melodies', 'duration': '11:00', 'emoji': '🎵'},
      ],
      'dance': [
        {'title': 'Warming Up', 'duration': '4:45', 'emoji': '🧘'},
        {'title': 'Basic Footwork', 'duration': '8:00', 'emoji': '👟'},
        {'title': 'Arms & Posture', 'duration': '6:30', 'emoji': '💪'},
        {'title': 'Your First Routine', 'duration': '14:20', 'emoji': '💃'},
      ],
      'finance': [
        {'title': 'What is Money?', 'duration': '5:00', 'emoji': '💵'},
        {'title': 'How Banks Work', 'duration': '9:30', 'emoji': '🏦'},
        {'title': 'Budgeting 101', 'duration': '11:15', 'emoji': '📋'},
        {'title': 'Investing Basics', 'duration': '13:00', 'emoji': '📈'},
      ],
      'literacy': [
        {'title': 'Reading Strategies', 'duration': '6:00', 'emoji': '👁️'},
        {'title': 'Understanding Context', 'duration': '8:45', 'emoji': '🧠'},
        {'title': 'Writing Clearly', 'duration': '10:00', 'emoji': '✏️'},
        {'title': 'Critical Thinking', 'duration': '12:30', 'emoji': '💡'},
      ],
    };
    return data[courseId] ?? [];
  }
}

class _VideoCard extends StatelessWidget {
  final Map<String, String> video;
  final Color accentColor;

  const _VideoCard({required this.video, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(video['emoji']!, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(video['title']!,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                Text(video['duration']!,
                    style: const TextStyle(fontSize: 12, color: AppTheme.muted, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}