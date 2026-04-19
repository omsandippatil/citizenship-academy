import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileData {
  final String name;
  final Color color;
  final IconData icon;
  final int streak;

  const _ProfileData({
    required this.name,
    required this.color,
    required this.icon,
    required this.streak,
  });
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen>
    with TickerProviderStateMixin {
  static const List<_ProfileData> _profiles = [
    _ProfileData(
      name: 'Manu',
      color: Color(0xFF20B2AA),
      icon: Icons.bolt_rounded,
      streak: 14,
    ),
    _ProfileData(
      name: 'Om',
      color: Color(0xFF3D9BE9),
      icon: Icons.auto_awesome_rounded,
      streak: 7,
    ),
    _ProfileData(
      name: 'Durva',
      color: Color(0xFFF2A541),
      icon: Icons.local_fire_department_rounded,
      streak: 21,
    ),
    _ProfileData(
      name: 'Nithun',
      color: Color(0xFF9B72CF),
      icon: Icons.school_rounded,
      streak: 3,
    ),
  ];

  int? _hoveredIndex;
  int? _selectedIndex;
  bool _navigating = false;

  late AnimationController _entryController;
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardScaleAnims;
  late List<Animation<double>> _cardFadeAnims;
  late List<Animation<Offset>> _cardSlideAnims;

  late AnimationController _titleController;
  late Animation<double> _titleFadeAnim;
  late Animation<Offset> _titleSlideAnim;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleFadeAnim = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    );
    _titleSlideAnim =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
        );

    _cardControllers = List.generate(
      _profiles.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _cardScaleAnims = _cardControllers
        .map(
          (c) => Tween<double>(begin: 0.75, end: 1.0).animate(
            CurvedAnimation(parent: c, curve: Curves.easeOutBack),
          ),
        )
        .toList();

    _cardFadeAnims = _cardControllers
        .map(
          (c) => CurvedAnimation(parent: c, curve: Curves.easeOut),
        )
        .toList();

    _cardSlideAnims = _cardControllers
        .map(
          (c) => Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: c, curve: Curves.easeOutCubic),
              ),
        )
        .toList();

    _animateIn();
  }

  void _animateIn() async {
    _titleController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    for (var i = 0; i < _cardControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (mounted) _cardControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _titleController.dispose();
    for (final c in _cardControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectProfile(int index) async {
    if (_navigating) return;
    setState(() {
      _selectedIndex = index;
      _navigating = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 700;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildTopBar(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 60 : 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitle(),
                      SizedBox(height: isWide ? 56 : 44),
                      _buildProfileGrid(isWide),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.shield_rounded,
                size: 17,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Citizenship Academy',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return SlideTransition(
      position: _titleSlideAnim,
      child: FadeTransition(
        opacity: _titleFadeAnim,
        child: Column(
          children: [
            const Text(
              'Who\'s learning?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
                letterSpacing: -0.8,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select your profile to continue',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.muted.withValues(alpha: 0.8),
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileGrid(bool isWide) {
    return Wrap(
      spacing: isWide ? 28 : 18,
      runSpacing: isWide ? 28 : 18,
      alignment: WrapAlignment.center,
      children: List.generate(_profiles.length, (i) {
        return ScaleTransition(
          scale: _cardScaleAnims[i],
          child: FadeTransition(
            opacity: _cardFadeAnims[i],
            child: SlideTransition(
              position: _cardSlideAnims[i],
              child: _buildProfileCard(i, isWide),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard(int index, bool isWide) {
    final profile = _profiles[index];
    final isHovered = _hoveredIndex == index;
    final isSelected = _selectedIndex == index;
    final double cardSize = isWide ? 160.0 : 140.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () => _selectProfile(index),
        child: AnimatedScale(
          scale: isSelected ? 0.92 : (isHovered ? 1.04 : 1.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: cardSize,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAvatar(profile, isHovered, isSelected, cardSize),
                const SizedBox(height: 14),
                _buildProfileName(profile, isHovered, isSelected),
                const SizedBox(height: 6),
                _buildStreakBadge(profile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(
    _ProfileData profile,
    bool isHovered,
    bool isSelected,
    double cardSize,
  ) {
    final double avatarSize = cardSize * 0.68;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSelected ? 20 : (isHovered ? 24 : 20)),
        color: isHovered || isSelected
            ? profile.color.withValues(alpha: 0.12)
            : AppTheme.cardBg,
        border: Border.all(
          color: isSelected
              ? profile.color
              : isHovered
              ? profile.color.withValues(alpha: 0.6)
              : AppTheme.border,
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: profile.color.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : isHovered
            ? [
                BoxShadow(
                  color: profile.color.withValues(alpha: 0.14),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : const [],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isHovered || isSelected ? 1.0 : 0.7,
            child: Icon(
              profile.icon,
              size: avatarSize * 0.46,
              color: isHovered || isSelected ? profile.color : AppTheme.muted,
            ),
          ),
          if (isSelected)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: profile.color,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileName(
    _ProfileData profile,
    bool isHovered,
    bool isSelected,
  ) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: isSelected
            ? profile.color
            : isHovered
            ? AppTheme.textDark
            : AppTheme.muted,
        letterSpacing: -0.2,
      ),
      child: Text(profile.name),
    );
  }

  Widget _buildStreakBadge(_ProfileData profile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            size: 11,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '${profile.streak} day streak',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.muted,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}