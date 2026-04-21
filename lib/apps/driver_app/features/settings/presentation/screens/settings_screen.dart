import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/services/store_redirect_service.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_dialog_widget.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_states.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_states.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/widgets/settings_shimmer_card_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Color primaryBlue = AppColors.primary;
  final Color scaffoldBg = const Color(0xFFF9FAFB);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsCubit>().getUserPreferences();
    });
  }

  void _onPreferenceChanged(
    SettingsStates state, {
    bool? bookingUpdates,
    bool? priceOffers,
    bool? promotions,
    bool? tripReminders,
    bool? paymentConfirmations,
  }) {
    if (state.userPreferences == null) return;

    final updatedPreferences = UserPreferencesEntity(
      bookingUpdates: bookingUpdates ?? state.userPreferences!.bookingUpdates,
      priceOffers: priceOffers ?? state.userPreferences!.priceOffers,
      promotionsAndDeals:
          promotions ?? state.userPreferences!.promotionsAndDeals,
      tripReminders: tripReminders ?? state.userPreferences!.tripReminders,
      paymentConfirmations:
          paymentConfirmations ?? state.userPreferences!.paymentConfirmations,
      language: state.userPreferences!.language ?? 'en',
    );

    context.read<SettingsCubit>().updateUserPreferences(updatedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        toolbarHeight: 80,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      // BlocListener handles the "Success" or "Error" popups
      body: BlocListener<SettingsCubit, SettingsStates>(
        listenWhen: (prev, current) =>
            prev.updateUserPreferencesRequestStatus !=
            current.updateUserPreferencesRequestStatus,
        listener: (context, state) {
          if (state.updateUserPreferencesRequestStatus ==
              RequestStatus.success) {
            showSuccess(context, 'Preferences updated successfully!');
          } else if (state.updateUserPreferencesRequestStatus ==
              RequestStatus.error) {
            showError(
              context,
              state.updateUserPreferencesErrorMessage ?? "Failed to update",
            );
          }
        },
        child: BlocBuilder<SettingsCubit, SettingsStates>(
          builder: (context, state) {
            return Stack(
              children: [
                _buildMainContent(state),
                // Show a global loader overlay when updating
                if (state.updateUserPreferencesRequestStatus ==
                    RequestStatus.loading)
                  Container(
                    color: Colors.black12,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(SettingsStates state) {
    if (state.getUserPreferencesRequestStatus == RequestStatus.loading &&
        state.userPreferences == null) {
      return const SwitchTileShimmerList();
    }

    if (state.getUserPreferencesRequestStatus == RequestStatus.error) {
      return Center(
        child: ErrorRetryWidget(
          message:
              state.getUserPreferencesErrorMessage ?? 'Something went wrong',
          onRetry: () => context.read<SettingsCubit>().getUserPreferences(),
        ),
      );
    }

    if (state.userPreferences != null) {
      final prefs = state.userPreferences!;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Notification Preferences"),
            _buildGroupCard([
              _buildSwitchTile(
                "Booking Updates",
                "Get notified about your bookings",
                prefs.bookingUpdates ?? false,
                (val) => _onPreferenceChanged(state, bookingUpdates: val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                "Price Offers",
                "Receive driver price offers",
                prefs.priceOffers ?? false,
                (val) => _onPreferenceChanged(state, priceOffers: val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                "Promotions & Deals",
                "Special offers and discounts",
                prefs.promotionsAndDeals ?? false,
                (val) => _onPreferenceChanged(state, promotions: val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                "Trip Reminders",
                "Upcoming trip notifications",
                prefs.tripReminders ?? false,
                (val) => _onPreferenceChanged(state, tripReminders: val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                "Payment Confirmations",
                "Transaction notifications",
                prefs.paymentConfirmations ?? false,
                (val) => _onPreferenceChanged(state, paymentConfirmations: val),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle("General"),
            _buildGroupCard([
              _buildMenuTile(
                Icons.language,
                "Language",
                "English",
                true,
                () {},
              ),
              _buildDivider(),
              _buildMenuTile(
                Icons.star_outline,
                "Rate Wasel",
                "Share your feedback",
                true,
                () {
                  StoreRedirectService.redirectToStore();
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle("Account"),
            // _buildActionTile(Icons.logout, "Sign Out", Colors.redAccent, false),
            _buildLogoutSection(),
            const SizedBox(height: 12),
            _buildActionTile(
              Icons.delete_outline,
              "Delete Account",
              Colors.red,
              true,
              subtitle: "This action cannot be undone",
            ),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLogoutSection() {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: state.logoutStatus == RequestStatus.loading
                ? null
                : () => context.read<ProfileCubit>().logout(),
            title: Center(
              child: state.logoutStatus == RequestStatus.loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.logout, color: Colors.redAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  // --- Helper Components ---

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            "Wasel v2.0.1",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "© 2026 Wasel. All rights reserved.",
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() =>
      Divider(height: 1, color: Colors.grey[100], indent: 16, endIndent: 16);

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.black54, fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: primaryBlue,
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title,
    String subtitle,
    bool showArrow,
    Function()? onTap,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF3F4F6),
        child: Icon(icon, color: primaryBlue, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
      trailing: showArrow
          ? Icon(Icons.chevron_right, color: Colors.grey[400])
          : null,
      onTap: onTap,
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    Color color,
    bool isOutline, {
    String? subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isOutline ? const Color(0xFFFEF2F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isOutline
            ? Border.all(color: Colors.red.withOpacity(0.3))
            : null,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOutline ? Colors.red : const Color(0xFFFEF2F2),
          child: Icon(
            icon,
            color: isOutline ? Colors.white : Colors.redAccent,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(color: Colors.redAccent, fontSize: 11),
              )
            : null,
        onTap: () {},
      ),
    );
  }
}
