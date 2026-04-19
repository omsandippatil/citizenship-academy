import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../data/app_data.dart';

class QuizTab extends StatefulWidget {
  final CourseModel course;

  const QuizTab({super.key, required this.course});

  @override
  State<QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> {
  int _currentQuestion = 0;
  int? _selectedOption;
  bool _answered = false;
  int _score = 0;
  bool _quizComplete = false;

  List<QuizQuestion> get questions => AppData.quizData[widget.course.id] ?? [];

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == questions[_currentQuestion].correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (_currentQuestion < questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      setState(() => _quizComplete = true);
    }
  }

  void _restart() {
    setState(() {
      _currentQuestion = 0;
      _selectedOption = null;
      _answered = false;
      _score = 0;
      _quizComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const Center(child: Text('No quiz available'));
    if (_quizComplete) return _buildResult();

    final question = questions[_currentQuestion];
    final color = widget.course.accentColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgress(),
          const SizedBox(height: 24),
          _buildQuestionCard(question, color),
          const SizedBox(height: 20),
          ...List.generate(question.options.length, (i) => _buildOption(i, question, color)),
          if (_answered) ...[
            const SizedBox(height: 16),
            _buildExplanation(question),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  _currentQuestion < questions.length - 1 ? 'Next Question →' : 'See Results 🎉',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      children: [
        Text(
          'Question ${_currentQuestion + 1} of ${questions.length}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.muted),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentQuestion + 1) / questions.length,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation(widget.course.accentColor),
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(QuizQuestion question, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.course.emoji} ${widget.course.title}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 10),
          Text(question.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textDark, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildOption(int index, QuizQuestion question, Color color) {
    Color bg = AppTheme.cardBg;
    Color border = AppTheme.border;
    Widget? trailing;

    if (_answered) {
      if (index == question.correctIndex) {
        bg = const Color(0xFFE8F5E9);
        border = const Color(0xFF4CAF50);
        trailing = const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20);
      } else if (index == _selectedOption) {
        bg = const Color(0xFFFFEBEE);
        border = const Color(0xFFF44336);
        trailing = const Icon(Icons.cancel, color: Color(0xFFF44336), size: 20);
      }
    } else if (index == _selectedOption) {
      bg = color.withValues(alpha: 0.1);
      border = color;
    }

    return GestureDetector(
      onTap: () => _selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _answered && index == question.correctIndex
                    ? const Color(0xFF4CAF50)
                    : AppTheme.border.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _answered && index == question.correctIndex ? Colors.white : AppTheme.muted,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(question.options[index],
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildExplanation(QuizQuestion question) {
    final isCorrect = _selectedOption == question.correctIndex;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isCorrect ? '🎉' : '💡', style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Correct!' : 'Not quite!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                  ),
                ),
                const SizedBox(height: 4),
                Text(question.explanation,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textDark, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final total = questions.length;
    final percent = _score / total;
    String badge;
    String message;
    if (percent >= 0.8) {
      badge = '🏆';
      message = 'Excellent work!';
    } else if (percent >= 0.6) {
      badge = '⭐';
      message = 'Good job!';
    } else {
      badge = '💪';
      message = 'Keep practicing!';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(badge, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text(message,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
            const SizedBox(height: 8),
            Text('You scored $_score out of $total',
                style: const TextStyle(fontSize: 16, color: AppTheme.muted, fontWeight: FontWeight.w600)),
            const SizedBox(height: 32),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: widget.course.accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: widget.course.accentColor, width: 3),
              ),
              child: Center(
                child: Text(
                  '${(percent * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: widget.course.accentColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _restart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.course.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Try Again 🔁', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}