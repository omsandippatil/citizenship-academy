import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class VaultItem {
  final String id;
  final String title;
  final String subtitle;
  final String assetPath;
  final bool isCollected;
  final Color accentColor;
  final String rarity;
  final IconData icon;

  const VaultItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.isCollected,
    required this.accentColor,
    required this.rarity,
    required this.icon,
  });
}

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardDealController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  bool _showCollectOverlay = false;
  VaultItem? _collectingItem;
  late AnimationController _collectController;
  late Animation<double> _collectScale;
  late Animation<double> _collectFade;
  late Animation<double> _collectGlow;
  late Animation<Offset> _collectFly;
  late Animation<double> _cardFlip;

  final List<VaultItem> _items = const [
    VaultItem(
      id: 'pioneer',
      title: 'First Step Pioneer',
      subtitle: 'Completed your very first lesson',
      assetPath: 'assets/vault/pioneer.jpg',
      isCollected: true,
      accentColor: Color(0xFF20B2AA),
      rarity: 'RARE',
      icon: Icons.emoji_events_rounded,
    ),
    VaultItem(
      id: 'streak',
      title: 'Flame Keeper',
      subtitle: 'Maintained a 7-day streak',
      assetPath: 'assets/vault/streak.jpg',
      isCollected: true,
      accentColor: Color(0xFFE07A5F),
      rarity: 'EPIC',
      icon: Icons.local_fire_department_rounded,
    ),
    VaultItem(
      id: 'scholar',
      title: 'Rising Scholar',
      subtitle: 'Score 100% on a quiz',
      assetPath: 'assets/vault/scholar.jpg',
      isCollected: false,
      accentColor: Color(0xFF3D9BE9),
      rarity: 'RARE',
      icon: Icons.school_rounded,
    ),
    VaultItem(
      id: 'champion',
      title: 'Civic Champion',
      subtitle: 'Reach top 10 on the leaderboard',
      assetPath: 'assets/vault/champion.jpg',
      isCollected: false,
      accentColor: Color(0xFFF2A541),
      rarity: 'LEGENDARY',
      icon: Icons.military_tech_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _cardDealController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _collectController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

    _headerFade = CurvedAnimation(parent: _headerController, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOut));

    _collectScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _collectController, curve: const Interval(0.0, 0.5, curve: Curves.elasticOut)));
    _collectFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _collectController, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)));
    _collectGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _collectController, curve: const Interval(0.3, 0.7, curve: Curves.easeInOut)));
    _collectFly = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.05)).animate(
        CurvedAnimation(parent: _collectController, curve: const Interval(0.5, 1.0, curve: Curves.easeInOut)));
    _cardFlip = Tween<double>(begin: math.pi, end: 0.0).animate(
        CurvedAnimation(parent: _collectController, curve: const Interval(0.1, 0.6, curve: Curves.easeOut)));

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardDealController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardDealController.dispose();
    _collectController.dispose();
    super.dispose();
  }

  void _onCardTap(VaultItem item) {
    if (item.isCollected) {
      _triggerCollectAnimation(item);
    } else {
      _showLockedSheet(item);
    }
  }

  void _triggerCollectAnimation(VaultItem item) {
    HapticFeedback.heavyImpact();
    setState(() {
      _showCollectOverlay = true;
      _collectingItem = item;
    });
    _collectController.forward(from: 0.0);
  }

  void _dismissCollect() {
    _collectController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showCollectOverlay = false;
          _collectingItem = null;
        });
      }
    });
  }

  void _showLockedSheet(VaultItem item) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LockedCardSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(),
                      const SizedBox(height: 8),
                      _buildSubtitle(),
                      const SizedBox(height: 28),
                      _buildProgressBar(),
                      const SizedBox(height: 28),
                      _buildSectionLabel('YOUR COLLECTION'),
                      const SizedBox(height: 16),
                      _buildGrid(),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          if (_showCollectOverlay && _collectingItem != null)
            _CollectOverlay(
              item: _collectingItem!,
              collectController: _collectController,
              collectScale: _collectScale,
              collectFade: _collectFade,
              collectGlow: _collectGlow,
              collectFly: _collectFly,
              cardFlip: _cardFlip,
              onDismiss: _dismissCollect,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final collected = _items.where((e) => e.isCollected).length;
    return SlideTransition(
      position: _headerSlide,
      child: FadeTransition(
        opacity: _headerFade,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'VAULT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
                letterSpacing: 4,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withValues(alpha: 0.15),
                    AppTheme.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 14, color: AppTheme.primary),
                  const SizedBox(width: 7),
                  Text(
                    '$collected / ${_items.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primary,
                      letterSpacing: 0.5,
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

  Widget _buildSubtitle() {
    return FadeTransition(
      opacity: _headerFade,
      child: const Text(
        'Collect achievement cards by conquering milestones.',
        style: TextStyle(
          fontSize: 13,
          color: AppTheme.muted,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final collected = _items.where((e) => e.isCollected).length;
    final progress = collected / _items.length;
    return FadeTransition(
      opacity: _headerFade,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'COLLECTION PROGRESS',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.muted, letterSpacing: 1.5),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primary, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(50),
            ),
            child: FractionallySizedBox(
              widthFactor: progress,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primary, Color(0xFF20B2AA)]),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return FadeTransition(
      opacity: _headerFade,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppTheme.muted,
          letterSpacing: 2.5,
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65,
      ),
      itemCount: _items.length,
      itemBuilder: (context, i) {
        return _VaultCard(
          item: _items[i],
          index: i,
          dealController: _cardDealController,
          onTap: () => _onCardTap(_items[i]),
        );
      },
    );
  }
}

class _CollectOverlay extends StatelessWidget {
  final VaultItem item;
  final AnimationController collectController;
  final Animation<double> collectScale;
  final Animation<double> collectFade;
  final Animation<double> collectGlow;
  final Animation<Offset> collectFly;
  final Animation<double> cardFlip;
  final VoidCallback onDismiss;

  const _CollectOverlay({
    required this.item,
    required this.collectController,
    required this.collectScale,
    required this.collectFade,
    required this.collectGlow,
    required this.collectFly,
    required this.cardFlip,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final color = item.accentColor;
    return GestureDetector(
      onTap: onDismiss,
      child: FadeTransition(
        opacity: collectFade,
        child: Container(
          color: Colors.black.withValues(alpha: 0.88),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: collectController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4 * collectGlow.value),
                                blurRadius: 80 * collectGlow.value,
                                spreadRadius: 20 * collectGlow.value,
                              ),
                            ],
                          ),
                        ),
                        SlideTransition(
                          position: collectFly,
                          child: ScaleTransition(
                            scale: collectScale,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(cardFlip.value),
                              child: _buildBigCard(color),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 36),
                ScaleTransition(
                  scale: collectScale,
                  child: FadeTransition(
                    opacity: collectFade,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
                          ),
                          child: Text(
                            '✦  ACHIEVEMENT UNLOCKED  ✦',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: color,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 36),
                        GestureDetector(
                          onTap: onDismiss,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Text(
                              'COLLECT',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tap anywhere to close',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.35),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBigCard(Color color) {
    return Container(
      width: 200,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.25),
            color.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                item.assetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(item.icon, size: 80, color: color.withValues(alpha: 0.6)),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.rarity,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Icon(Icons.auto_awesome_rounded, size: 14, color: color),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withValues(alpha: 0.85), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(14, 24, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
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
}

class _VaultCard extends StatefulWidget {
  final VaultItem item;
  final int index;
  final AnimationController dealController;
  final VoidCallback onTap;

  const _VaultCard({
    required this.item,
    required this.index,
    required this.dealController,
    required this.onTap,
  });

  @override
  State<_VaultCard> createState() => _VaultCardState();
}

class _VaultCardState extends State<_VaultCard> with SingleTickerProviderStateMixin {
  late Animation<double> _dealFade;
  late Animation<Offset> _dealSlide;
  late Animation<double> _dealScale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    final start = (widget.index * 0.15).clamp(0.0, 0.7);
    final end = (start + 0.4).clamp(0.0, 1.0);

    _dealFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: widget.dealController, curve: Interval(start, end, curve: Curves.easeOut)));
    _dealSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(parent: widget.dealController, curve: Interval(start, end, curve: Curves.easeOut)));
    _dealScale = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: widget.dealController, curve: Interval(start, end, curve: Curves.easeOut)));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final color = item.accentColor;

    return FadeTransition(
      opacity: _dealFade,
      child: SlideTransition(
        position: _dealSlide,
        child: ScaleTransition(
          scale: _dealScale,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) {
              setState(() => _pressed = false);
              widget.onTap();
            },
            onTapCancel: () => setState(() => _pressed = false),
            child: AnimatedScale(
              scale: _pressed ? 0.94 : 1.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: item.isCollected ? color.withValues(alpha: 0.4) : AppTheme.border,
                    width: 1.5,
                  ),
                  boxShadow: item.isCollected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.15),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildBackground(item, color),
                      _buildImageLayer(item, color),
                      _buildGradientOverlay(item),
                      _buildTopBadge(item, color),
                      _buildBottomInfo(item, color),
                      if (!item.isCollected) _buildLockedOverlay(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(VaultItem item, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: item.isCollected
              ? [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)]
              : [AppTheme.cardBg, AppTheme.softGreen],
        ),
      ),
    );
  }

  Widget _buildImageLayer(VaultItem item, Color color) {
    return Positioned.fill(
      child: Image.asset(
        item.assetPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Center(
          child: Icon(item.icon, size: 64, color: color.withValues(alpha: 0.5)),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay(VaultItem item) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 130,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBadge(VaultItem item, Color color) {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: item.isCollected ? color : AppTheme.border.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          item.rarity,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: item.isCollected ? Colors.white : AppTheme.muted,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInfo(VaultItem item, Color color) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: item.isCollected ? Colors.white : AppTheme.muted,
                letterSpacing: -0.2,
                shadows: item.isCollected
                    ? [const Shadow(color: Colors.black, blurRadius: 8)]
                    : [],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.isCollected) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.check_circle_rounded, size: 10, color: color),
                  const SizedBox(width: 4),
                  Text(
                    'COLLECTED',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: color,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLockedOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
            ),
            child: const Icon(Icons.lock_rounded, size: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _LockedCardSheet extends StatelessWidget {
  final VaultItem item;
  const _LockedCardSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.accentColor;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: AppTheme.border, width: 1.5),
      ),
      child: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
            ),
            child: Text(
              item.rarity,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.softGreen,
                      child: Center(
                        child: Icon(item.icon, size: 64, color: color.withValues(alpha: 0.4)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.6)],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                      ),
                      child: const Icon(Icons.lock_rounded, size: 32, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.rarity,
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Card Locked',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppTheme.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.softGreen,
                foregroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                elevation: 0,
                side: const BorderSide(color: AppTheme.border, width: 1.5),
              ),
              child: const Text(
                'Keep Playing',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}