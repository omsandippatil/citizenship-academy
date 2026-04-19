import 'package:flutter/material.dart';
import '../models/models.dart';

class GameTab extends StatelessWidget {
  final CourseModel course;

  const GameTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildGameFrame(context)),
        _GameBoyControls(accentColor: course.accentColor),
      ],
    );
  }

  Widget _buildGameFrame(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: course.accentColor.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(color: course.accentColor.withValues(alpha: 0.15), blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            _buildGamePlaceholder(),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(course.emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      '${course.title} Game',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(course.emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text(
            'Game Loading...',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          const Text(
            'Link your index.html file here',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'WebView placeholder',
              style: TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameBoyControls extends StatelessWidget {
  final Color accentColor;

  const _GameBoyControls({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
        border: Border(top: BorderSide(color: accentColor.withValues(alpha: 0.3), width: 1.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _DPad(accentColor: accentColor),
            _buildCenterControls(accentColor),
            _ActionButtons(accentColor: accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterControls(Color accent) {
    return Column(
      children: [
        Row(
          children: [
            _SmallBtn(label: 'SEL', color: accent),
            const SizedBox(width: 12),
            _SmallBtn(label: 'STR', color: accent),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: 0.3), width: 1.5),
          ),
          child: const Center(
            child: Text('🎮', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}

class _DPad extends StatelessWidget {
  final Color accentColor;

  const _DPad({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _dpadBtn(Alignment.topCenter, Icons.arrow_drop_up, accentColor),
          _dpadBtn(Alignment.bottomCenter, Icons.arrow_drop_down, accentColor),
          _dpadBtn(Alignment.centerLeft, Icons.arrow_left, accentColor),
          _dpadBtn(Alignment.centerRight, Icons.arrow_right, accentColor),
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF2A2A3E),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dpadBtn(Alignment alignment, IconData icon, Color accent) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A3E),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Color accentColor;

  const _ActionButtons({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _ActionBtn(label: 'X', color: accentColor),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: _ActionBtn(label: 'B', color: Colors.redAccent),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: _ActionBtn(label: 'Y', color: Color(0xFFFFD700)),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: _ActionBtn(label: 'A', color: Color(0xFF4CAF50)),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;

  const _ActionBtn({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final String label;
  final Color color;

  const _SmallBtn({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
      ),
    );
  }
}