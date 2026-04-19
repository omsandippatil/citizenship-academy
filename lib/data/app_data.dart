import 'package:flutter/material.dart';
import '../models/models.dart';

class AppData {
  static UserModel currentUser = UserModel(
    name: 'Manu Agarwal',
    phone: '0000000000',
    streak: 7,
    points: 420,
    courseProgress: {
      'coding': 0.45,
      'music': 0.28,
      'dance': 0.20,
      'finance': 0.62,
      'literacy': 0.38,
    },
    coursePoints: {
      'coding': 180,
      'music': 60,
      'dance': 40,
      'finance': 120,
      'literacy': 80,
    },
  );

  static final List<CourseModel> courses = [
    const CourseModel(
      id: 'coding',
      title: 'Coding',
      emoji: '💻',
      icon: Icons.code_rounded,
      description: 'Learn programming from scratch',
      accentColor: Color(0xFF20B2AA),
      modules: [
        LessonModule(id: 'c1', title: 'Intro to Code', emoji: '🚀', type: ModuleType.video, isCompleted: true),
        LessonModule(id: 'c2', title: 'Variables', emoji: '📦', type: ModuleType.quiz, isCompleted: true),
        LessonModule(id: 'c3', title: 'Loops & Logic', emoji: '🔄', type: ModuleType.video, isCompleted: true),
        LessonModule(id: 'c4', title: 'Code Quiz', emoji: '🧠', type: ModuleType.quiz, isCompleted: false),
        LessonModule(id: 'c5', title: 'Code Game', emoji: '🎮', type: ModuleType.game, isCompleted: false),
        LessonModule(id: 'c6', title: 'Functions', emoji: '⚙️', type: ModuleType.video, isLocked: true),
        LessonModule(id: 'c7', title: 'Arrays', emoji: '📊', type: ModuleType.quiz, isLocked: true),
        LessonModule(id: 'c8', title: 'Final Project', emoji: '🏆', type: ModuleType.game, isLocked: true),
      ],
    ),
    const CourseModel(
      id: 'music',
      title: 'Music',
      emoji: '🎵',
      icon: Icons.music_note_rounded,
      description: 'Discover rhythm and melody',
      accentColor: Color(0xFF9C27B0),
      modules: [
        LessonModule(id: 'm1', title: 'Notes & Scales', emoji: '🎼', type: ModuleType.video, isCompleted: true),
        LessonModule(id: 'm2', title: 'Rhythm Basics', emoji: '🥁', type: ModuleType.quiz, isCompleted: false),
        LessonModule(id: 'm3', title: 'Beat Game', emoji: '🎮', type: ModuleType.game, isCompleted: false),
        LessonModule(id: 'm4', title: 'Chords', emoji: '🎸', type: ModuleType.video, isLocked: true),
        LessonModule(id: 'm5', title: 'Melody Quiz', emoji: '🎹', type: ModuleType.quiz, isLocked: true),
        LessonModule(id: 'm6', title: 'Compose', emoji: '✍️', type: ModuleType.game, isLocked: true),
      ],
    ),
    const CourseModel(
      id: 'dance',
      title: 'Dance',
      emoji: '💃',
      icon: Icons.self_improvement_rounded,
      description: 'Move your body to the beat',
      accentColor: Color(0xFFE91E63),
      modules: [
        LessonModule(id: 'd1', title: 'Body Movement', emoji: '🕺', type: ModuleType.video, isCompleted: true),
        LessonModule(id: 'd2', title: 'Basic Steps', emoji: '👟', type: ModuleType.quiz, isCompleted: false),
        LessonModule(id: 'd3', title: 'Dance Game', emoji: '🎮', type: ModuleType.game, isCompleted: false),
        LessonModule(id: 'd4', title: 'Choreography', emoji: '🎭', type: ModuleType.video, isLocked: true),
        LessonModule(id: 'd5', title: 'Style Quiz', emoji: '✨', type: ModuleType.quiz, isLocked: true),
        LessonModule(id: 'd6', title: 'Performance', emoji: '🎪', type: ModuleType.game, isLocked: true),
      ],
    ),
    const CourseModel(
      id: 'finance',
      title: 'Finance',
      emoji: '💰',
      icon: Icons.trending_up_rounded,
      description: 'Master money management',
      accentColor: Color(0xFF4CAF50),
      modules: [
        LessonModule(id: 'f1', title: 'Money Basics', emoji: '💵', type: ModuleType.video, isCompleted: true),
        LessonModule(id: 'f2', title: 'Saving Tips', emoji: '🏦', type: ModuleType.video, isCompleted: true),
        LessonModule(id: 'f3', title: 'Budget Quiz', emoji: '📋', type: ModuleType.quiz, isCompleted: true),
        LessonModule(id: 'f4', title: 'Invest Basics', emoji: '📈', type: ModuleType.video, isCompleted: false),
        LessonModule(id: 'f5', title: 'Finance Game', emoji: '🎮', type: ModuleType.game, isCompleted: false),
        LessonModule(id: 'f6', title: 'Tax Basics', emoji: '📝', type: ModuleType.video, isLocked: true),
        LessonModule(id: 'f7', title: 'Portfolio Quiz', emoji: '💼', type: ModuleType.quiz, isLocked: true),
        LessonModule(id: 'f8', title: 'Final Exam', emoji: '🏆', type: ModuleType.game, isLocked: true),
      ],
    ),
    const CourseModel(
      id: 'literacy',
      title: 'Literacy',
      emoji: '📚',
      icon: Icons.menu_book_rounded,
      description: 'Read, write, and express',
      accentColor: Color(0xFFFF9800),
      modules: [
        LessonModule(id: 'l1', title: 'Reading Skills', emoji: '👁️', type: ModuleType.video, isCompleted: true),
        LessonModule(id: 'l2', title: 'Comprehension', emoji: '🧩', type: ModuleType.quiz, isCompleted: true),
        LessonModule(id: 'l3', title: 'Word Game', emoji: '🎮', type: ModuleType.game, isCompleted: false),
        LessonModule(id: 'l4', title: 'Writing Basics', emoji: '✏️', type: ModuleType.video, isCompleted: false),
        LessonModule(id: 'l5', title: 'Grammar Quiz', emoji: '📖', type: ModuleType.quiz, isLocked: true),
        LessonModule(id: 'l6', title: 'Story Builder', emoji: '🗺️', type: ModuleType.game, isLocked: true),
      ],
    ),
  ];

  static const List<ExploreCourse> exploreCourses = [
    ExploreCourse(
      id: 'science',
      title: 'Science',
      subtitle: 'Explore the universe around you',
      icon: Icons.science_rounded,
      color: Color(0xFF00BCD4),
      tag: 'POPULAR',
    ),
    ExploreCourse(
      id: 'art',
      title: 'Visual Art',
      subtitle: 'Draw, paint and create freely',
      icon: Icons.palette_rounded,
      color: Color(0xFFFF5722),
      tag: 'NEW',
    ),
    ExploreCourse(
      id: 'chess',
      title: 'Chess',
      subtitle: 'Think ahead and outsmart',
      icon: Icons.games_rounded,
      color: Color(0xFF607D8B),
      tag: 'NEW',
    ),
    ExploreCourse(
      id: 'language',
      title: 'Language',
      subtitle: 'Speak a new language fluently',
      icon: Icons.translate_rounded,
      color: Color(0xFF3F51B5),
      tag: 'HOT',
    ),
    ExploreCourse(
      id: 'photography',
      title: 'Photography',
      subtitle: 'Capture moments beautifully',
      icon: Icons.camera_alt_rounded,
      color: Color(0xFF795548),
      tag: 'TRENDING',
    ),
    ExploreCourse(
      id: 'mindfulness',
      title: 'Mindfulness',
      subtitle: 'Focus, breathe, and reset',
      icon: Icons.spa_rounded,
      color: Color(0xFF8BC34A),
      tag: 'NEW',
    ),
    ExploreCourse(
      id: 'math',
      title: 'Mathematics',
      subtitle: 'Numbers, patterns and logic',
      icon: Icons.functions_rounded,
      color: Color(0xFFE91E63),
      tag: 'POPULAR',
    ),
    ExploreCourse(
      id: 'cooking',
      title: 'Cooking',
      subtitle: 'Recipes and kitchen mastery',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFFF9800),
      tag: 'HOT',
    ),
  ];

  static const List<LeaderboardEntry> leaderboard = [
    LeaderboardEntry(name: 'Om', emoji: '🦁', points: 980, streak: 21, rank: 1),
    LeaderboardEntry(name: 'Durva', emoji: '🌸', points: 850, streak: 14, rank: 2),
    LeaderboardEntry(name: 'Nithun', emoji: '⚡', points: 760, streak: 18, rank: 3),
    LeaderboardEntry(name: 'Manu Agarwal', emoji: '🌊', points: 420, streak: 7, rank: 4),
    LeaderboardEntry(name: 'Aryan', emoji: '🔥', points: 390, streak: 5, rank: 5),
    LeaderboardEntry(name: 'Priya', emoji: '🌺', points: 320, streak: 3, rank: 6),
    LeaderboardEntry(name: 'Karan', emoji: '🎯', points: 210, streak: 2, rank: 7),
  ];

  static const Map<String, List<QuizQuestion>> quizData = {
    'coding': [
      QuizQuestion(
        question: 'What does a variable store?',
        options: ['A color', 'A value', 'A picture', 'A sound'],
        correctIndex: 1,
        explanation: 'Variables store values like numbers, text, or booleans.',
      ),
      QuizQuestion(
        question: 'Which symbol is used for assignment in most languages?',
        options: ['==', '!=', '=', '>='],
        correctIndex: 2,
        explanation: 'Single = is used for assignment, == is for comparison.',
      ),
      QuizQuestion(
        question: 'What does a loop do?',
        options: ['Stops the program', 'Repeats code', 'Deletes data', 'Creates a file'],
        correctIndex: 1,
        explanation: 'Loops repeat a block of code multiple times.',
      ),
    ],
    'music': [
      QuizQuestion(
        question: 'How many notes are in a standard musical scale?',
        options: ['5', '6', '7', '8'],
        correctIndex: 2,
        explanation: 'A standard major/minor scale has 7 distinct notes.',
      ),
      QuizQuestion(
        question: 'What is a beat in music?',
        options: ['A type of note', 'The basic unit of rhythm', 'A chord', 'A melody'],
        correctIndex: 1,
        explanation: 'A beat is the basic rhythmic unit that drives music forward.',
      ),
      QuizQuestion(
        question: 'Which instrument has black and white keys?',
        options: ['Guitar', 'Violin', 'Piano', 'Flute'],
        correctIndex: 2,
        explanation: 'The piano keyboard has alternating black and white keys.',
      ),
    ],
    'dance': [
      QuizQuestion(
        question: 'What is the most important element of dance?',
        options: ['Speed', 'Rhythm', 'Height', 'Color'],
        correctIndex: 1,
        explanation: 'Rhythm connects movement to music and is fundamental to dance.',
      ),
      QuizQuestion(
        question: 'What is a "pirouette"?',
        options: ['A jump', 'A spin on one leg', 'A floor move', 'A hand gesture'],
        correctIndex: 1,
        explanation: 'A pirouette is a full rotation balanced on one leg.',
      ),
      QuizQuestion(
        question: 'Which dance style originated in Cuba?',
        options: ['Waltz', 'Salsa', 'Ballet', 'Hip Hop'],
        correctIndex: 1,
        explanation: 'Salsa has roots in Cuban musical traditions.',
      ),
    ],
    'finance': [
      QuizQuestion(
        question: 'What is compound interest?',
        options: ['Simple interest doubled', 'Interest on interest', 'Bank fee', 'A type of loan'],
        correctIndex: 1,
        explanation: 'Compound interest means you earn interest on your interest over time.',
      ),
      QuizQuestion(
        question: 'What is a budget?',
        options: ['A type of bank', 'A plan for spending', 'A loan agreement', 'An investment'],
        correctIndex: 1,
        explanation: 'A budget is a financial plan that allocates future income.',
      ),
      QuizQuestion(
        question: 'What does ROI stand for?',
        options: ['Rate of Interest', 'Return on Investment', 'Risk of Income', 'Revenue of Index'],
        correctIndex: 1,
        explanation: 'ROI (Return on Investment) measures the efficiency of an investment.',
      ),
    ],
    'literacy': [
      QuizQuestion(
        question: 'What is a synonym?',
        options: ['Opposite word', 'Same meaning word', 'Rhyming word', 'Misspelled word'],
        correctIndex: 1,
        explanation: 'Synonyms are words with the same or similar meanings.',
      ),
      QuizQuestion(
        question: 'What is a paragraph?',
        options: ['A single word', 'A type of poem', 'A group of related sentences', 'A chapter'],
        correctIndex: 2,
        explanation: 'A paragraph is a group of sentences about one main idea.',
      ),
      QuizQuestion(
        question: 'What is the main idea of a text?',
        options: ['The last sentence', 'The title only', 'The central point of the text', 'The author\'s name'],
        correctIndex: 2,
        explanation: 'The main idea is the central message the author wants to convey.',
      ),
    ],
  };
}