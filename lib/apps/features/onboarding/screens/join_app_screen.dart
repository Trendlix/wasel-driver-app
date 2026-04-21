import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_images.dart';
import 'package:wasel_driver/apps/features/onboarding/widgets/account_type_card_widget.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      //appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(AppImages.waselLogo2, height: 40),
              const SizedBox(height: AppSpacing.xxl),
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),
              _buildCards(context),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  // PreferredSizeWidget _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: AppColors.background,
  //     elevation: 0,
  //     title: const Text(
  //       'Join Wasel',
  //       style: TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w500,
  //         color: AppColors.textSecondary,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildHeader() {
    return Column(
      children: [
        Text('Join Wasel', style: AppTextStyles.heading),
        const SizedBox(height: AppSpacing.xs),
        Text('Select your account type', style: AppTextStyles.subtitle),
      ],
    );
  }

  Widget _buildCards(BuildContext context) {
    return Column(
      children: [
        AccountTypeCard(
          backgroundColor: AppColors.primary,
          icon: Icons.local_shipping_outlined,
          title: "I'm a Driver",
          subtitle: 'Accept trips & earn money',
          onTap: () => _onDriverTap(context),
        ),
        const SizedBox(height: AppSpacing.md),
        AccountTypeCard(
          backgroundColor: AppColors.storageCard,
          icon: Icons.warehouse_outlined,
          title: 'Storage Owner',
          subtitle: 'List facilities & earn money',
          onTap: () => _onStorageTap(context),
        ),
      ],
    );
  }

  void _onDriverTap(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRouteNames.appPermissionsScreen,
      arguments: () {
        Navigator.of(context).pushNamed(AppRouteNames.loginScreen);
      },
    );
  }

  void _onStorageTap(BuildContext context) {
    // TODO: Navigate to storage owner registration
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Storage owner registration coming soon!')),
    );
  }
}
