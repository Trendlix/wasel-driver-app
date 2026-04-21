import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/services/store_redirect_service.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_snackbar_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_states.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<ProfileCubit>().getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: BlocListener<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state.logoutStatus == RequestStatus.loading) {
            showLoadingSnackBar(context, 'Loading...');
          } else if (state.logoutStatus == RequestStatus.success) {
            hideLoadingSnackBar(context);
            showSuccess(context, 'Logout successfully');
            context.read<ProfileCubit>().reset();
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouteNames.loginScreen,
              (route) => false,
            );
          } else if (state.logoutStatus == RequestStatus.error) {
            showSnackError(context, 'Logout failed');
            hideLoadingSnackBar(context);
          }

          if (state.deleteDriverAccountStatus == RequestStatus.loading) {
            showLoadingSnackBar(context, 'Deleting account...');
          } else if (state.deleteDriverAccountStatus == RequestStatus.success) {
            hideLoadingSnackBar(context);
            showSuccess(context, 'Account deleted successfully');
            context.read<ProfileCubit>().reset();
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouteNames.loginScreen,
              (route) => false,
            );
          } else if (state.deleteDriverAccountStatus == RequestStatus.error) {
            showSnackError(
              context,
              state.deleteDriverAccountErrorMessage ??
                  'Failed to delete account',
            );
            hideLoadingSnackBar(context);
          }
        },
        child: Column(
          children: [
            // ── Blue Header ──────────────────────────────────────────
            _buildHeader(context),

            // ── Scrollable Body ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── ACCOUNT ─────────────────────────────────────
                    _buildSectionLabel('ACCOUNT'),
                    _buildMenuGroup([
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        iconColor: AppColors.primary,
                        iconBgColor: const Color(0xFFEEF2FB),
                        title: 'Personal Information',
                        subtitle: 'Update your details',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRouteNames.personalInfoScreen);
                        },
                      ),
                      _MenuItem(
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: const Color(0xFF22C55E),
                        iconBgColor: const Color(0xFFDCFCE7),
                        title: 'Wallet & Earnings',
                        subtitle: 'EGP 2,450.00',
                        badge: 'NEW',
                        badgeColor: const Color(0xFF22C55E),
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.description_outlined,
                        iconColor: const Color(0xFFE8A020),
                        iconBgColor: const Color(0xFFFFFBEB),
                        title: 'Vehicle Documents',
                        subtitle: 'Manage your documents',
                        dot: true,
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRouteNames.vehicleDocumentsScreen);
                        },
                      ),
                    ]),

                    // ── COMMUNICATION ────────────────────────────────
                    _buildSectionLabel('COMMUNICATION'),
                    _buildMenuGroup([
                      _MenuItem(
                        icon: Icons.inbox_outlined,
                        iconColor: AppColors.primary,
                        iconBgColor: const Color(0xFFEEF2FB),
                        title: 'Inbox',
                        subtitle: 'Messages & announcements',
                        count: 0,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouteNames.inboxScreen,
                            arguments: true,
                          );
                        },
                      ),
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        iconColor: const Color(0xFF8B5CF6),
                        iconBgColor: const Color(0xFFF5F3FF),
                        title: 'Notifications',
                        subtitle: 'Manage notification settings',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRouteNames.notificationScreen);
                        },
                      ),
                    ]),

                    // ── SUPPORT ──────────────────────────────────────
                    _buildSectionLabel('SUPPORT'),
                    _buildMenuGroup([
                      _MenuItem(
                        icon: Icons.help_outline_rounded,
                        iconColor: const Color(0xFF6B7280),
                        iconBgColor: const Color(0xFFF5F7FA),
                        title: 'Help & Support',
                        subtitle: 'FAQs & contact support',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRouteNames.helpAndSupportScreen);
                        },
                      ),
                      _MenuItem(
                        icon: Icons.star_outline_rounded,
                        iconColor: const Color(0xFFE8A020),
                        iconBgColor: const Color(0xFFFFFBEB),
                        title: 'Rate the App',
                        subtitle: 'Share your feedback',
                        onTap: () {
                          StoreRedirectService.redirectToStore();
                        },
                      ),
                    ]),

                    // ── SETTINGS ─────────────────────────────────────
                    _buildSectionLabel('SETTINGS'),
                    _buildMenuGroup([
                      _MenuItem(
                        icon: Icons.settings_outlined,
                        iconColor: const Color(0xFF6B7280),
                        iconBgColor: const Color(0xFFF5F7FA),
                        title: 'App Settings',
                        subtitle: 'Preferences & configurations',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRouteNames.settingsScreen);
                        },
                      ),
                      _MenuItem(
                        icon: Icons.language_outlined,
                        iconColor: const Color(0xFF3B82F6),
                        iconBgColor: const Color(0xFFEFF6FF),
                        title: 'Language',
                        subtitle: 'English',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRouteNames.languageScreen);
                        },
                      ),
                    ]),

                    // ── LEGAL ────────────────────────────────────────
                    _buildSectionLabel('LEGAL'),
                    _buildMenuGroup([
                      _MenuItem(
                        icon: Icons.article_outlined,
                        iconColor: const Color(0xFF6B7280),
                        iconBgColor: const Color(0xFFF5F7FA),
                        title: 'Terms & Conditions',
                        subtitle: 'Read our terms',
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouteNames.waselLegelScreen,
                            arguments: true,
                          );
                        },
                      ),
                      _MenuItem(
                        icon: Icons.shield_outlined,
                        iconColor: const Color(0xFF6B7280),
                        iconBgColor: const Color(0xFFF5F7FA),
                        title: 'Privacy Policy',
                        subtitle: 'How we protect your data',
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouteNames.waselLegelScreen,
                            arguments: false,
                          );
                        },
                      ),
                      _MenuItem(
                        icon: Icons.logout_rounded,
                        iconColor: const Color(0xFF6B7280),
                        iconBgColor: const Color(0xFFF5F7FA),
                        title: 'Sign Out',
                        subtitle: 'Log out of your account',
                        onTap: () {
                          context.read<ProfileCubit>().logout();
                        },
                      ),
                      _MenuItem(
                        icon: Icons.delete_outline_rounded,
                        iconColor: const Color(0xFFEF4444),
                        iconBgColor: const Color(0xFFFEE2E2),
                        title: 'Delete Account',
                        subtitle: 'Permanently remove your account',
                        titleColor: const Color(0xFFEF4444),
                        onTap: () {
                          context.read<ProfileCubit>().deleteDriverAccount();
                        },
                      ),
                    ]),

                    // ── Version ──────────────────────────────────────
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'Wasel Driver App v1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
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

  // ── Blue Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        final profile = state.profileModel;

        return Container(
          width: double.infinity,
          color: AppColors.primary,
          padding: EdgeInsets.only(
            top: topPadding + 16,
            left: 20,
            right: 20,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Profile card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: profile == null
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          // Avatar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: 52,
                              height: 52,
                              color: const Color(0xFF8B5CF6),
                              alignment: Alignment.center,
                              child: Text(
                                profile.name.trim().isNotEmpty
                                    ? profile.name
                                          .trim()
                                          .substring(
                                            0,
                                            profile.name.trim().length >= 2
                                                ? 2
                                                : profile.name.trim().length,
                                          )
                                          .toUpperCase()
                                    : '??',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  profile.phoneNumber,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: Color(0xFFE8A020),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${profile.rating.toStringAsFixed(1)} (${profile.totalTrips} trips)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Section Label ────────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF9CA3AF),
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ── Menu Group ───────────────────────────────────────────────────────────────
  Widget _buildMenuGroup(List<_MenuItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          return Column(
            children: [
              _buildMenuItem(item),
              if (!isLast)
                const Divider(height: 1, indent: 60, color: Color(0xFFF3F4F6)),
            ],
          );
        }),
      ),
    );
  }

  // ── Menu Item ────────────────────────────────────────────────────────────────
  Widget _buildMenuItem(_MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            // Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 18, color: item.iconColor),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: item.titleColor ?? const Color(0xFF1A1A2E),
                        ),
                      ),
                      if (item.badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: item.badgeColor ?? AppColors.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            item.badge!,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                      if (item.dot == true) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8A020),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      if (item.count != null && item.count! > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${item.count}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Menu Item Model ───────────────────────────────────────────────────────────

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final String? badge;
  final Color? badgeColor;
  final bool? dot;
  final int? count;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.badge,
    this.badgeColor,
    this.dot,
    this.count,
    this.onTap,
  });
}
