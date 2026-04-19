import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'vault_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    LeaderboardScreen(),
    VaultScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            _buildSideNav(),
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        border: Border(top: BorderSide(color: AppTheme.border, width: 1.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              _navItem(0, Icons.home_rounded, 'Home'),
              _navItem(1, Icons.emoji_events_rounded, 'Ranks'),
              _navItem(2, Icons.lock_rounded, 'Vault'),
              _navItem(3, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.softGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? AppTheme.primary : AppTheme.muted,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppTheme.primary : AppTheme.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideNav() {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        border: Border(right: BorderSide(color: AppTheme.border, width: 1.5)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.softGreen,
                border: Border.all(color: AppTheme.border, width: 1.5),
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 28,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Citizenship\nAcademy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'The Apprentice Project',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.muted,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 32),
            _sideNavItem(0, Icons.home_rounded, 'Home'),
            _sideNavItem(1, Icons.emoji_events_rounded, 'Leaderboard'),
            _sideNavItem(2, Icons.lock_rounded, 'Vault'),
            _sideNavItem(3, Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _sideNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.softGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: isSelected
              ? const Border.fromBorderSide(
                  BorderSide(color: AppTheme.border, width: 1.5),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppTheme.primary : AppTheme.muted,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.primary : AppTheme.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}