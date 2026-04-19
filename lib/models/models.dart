import 'package:flutter/material.dart';

enum ModuleType { video, quiz, game }

class UserModel {
  final String name;
  final String phone;
  final int streak;
  final int points;
  final Map<String, double> courseProgress;
  final Map<String, int> coursePoints;

  UserModel({
    required this.name,
    required this.phone,
    this.streak = 0,
    this.points = 0,
    Map<String, double>? courseProgress,
    Map<String, int>? coursePoints,
  })  : courseProgress = courseProgress ?? {},
        coursePoints = coursePoints ?? {};
}

class CourseModel {
  final String id;
  final String title;
  final String emoji;
  final IconData icon;
  final String description;
  final Color accentColor;
  final List<LessonModule> modules;

  const CourseModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.icon,
    required this.description,
    required this.accentColor,
    required this.modules,
  });
}

class LessonModule {
  final String id;
  final String title;
  final String emoji;
  final ModuleType type;
  final bool isCompleted;
  final bool isLocked;

  const LessonModule({
    required this.id,
    required this.title,
    required this.emoji,
    required this.type,
    this.isCompleted = false,
    this.isLocked = false,
  });
}

class ExploreCourse {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String tag;

  const ExploreCourse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.tag,
  });
}

class LeaderboardEntry {
  final String name;
  final String emoji;
  final int points;
  final int streak;
  final int rank;

  const LeaderboardEntry({
    required this.name,
    required this.emoji,
    required this.points,
    required this.streak,
    required this.rank,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}