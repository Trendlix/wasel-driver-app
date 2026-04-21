import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_images.dart';
import 'package:wasel_driver/apps/driver_app/features/bottom_nav_bar/presentation/manager/bottom_nav_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/bottom_nav_bar/presentation/manager/bottom_nav_state.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/screens/home_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/screens/inbox_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/screens/trips_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/presentation/screens/wallet_screen.dart';

class MainShellScreen extends StatelessWidget {
  final int initialIndex;
  const MainShellScreen({super.key, this.initialIndex = 0});

  static const List<Widget> _screens = [
    HomeScreen(),
    TripsScreen(),
    WalletScreen(),
    InboxScreen(),
    ProfileScreen(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: AppImages.homeNavIcon,
      activeIcon: AppImages.homeNavIcon,
      label: 'Home',
    ),
    _NavItem(
      icon: AppImages.tripsNavIcon,
      activeIcon: AppImages.tripsNavIcon,
      label: 'Trips',
    ),
    _NavItem(
      icon: AppImages.walletNavIcon,
      activeIcon: AppImages.walletNavIcon,
      label: 'Wallet',
    ),
    _NavItem(
      icon: AppImages.inboxNavIcon,
      activeIcon: AppImages.inboxNavIcon,
      label: 'Inbox',
    ),
    _NavItem(
      icon: AppImages.profileNavIcon,
      activeIcon: AppImages.profileNavIcon,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit()..navigateTo(initialIndex),
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            // ── Current screen body ──────────────────────────────────
            body: IndexedStack(index: state.currentIndex, children: _screens),

            // ── Bottom Navigation Bar ────────────────────────────────
            bottomNavigationBar: _buildBottomNavBar(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, BottomNavState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isActive = state.currentIndex == index;

              return _NavBarItem(
                item: item,
                isActive: isActive,
                onTap: () => context.read<BottomNavCubit>().navigateTo(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Nav Item Data ─────────────────────────────────────────────────────────────

class _NavItem {
  final String icon;
  final String activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ── Nav Bar Item Widget ───────────────────────────────────────────────────────

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ────────────────────────────────────────────────
            Image.asset(
              isActive ? item.activeIcon : item.icon,
              width: 24,
              height: 24,
              color: isActive ? AppColors.primary : const Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 4),

            // ── Label ────────────────────────────────────────────────
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: isActive ? AppColors.primary : const Color(0xFF9CA3AF),
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
