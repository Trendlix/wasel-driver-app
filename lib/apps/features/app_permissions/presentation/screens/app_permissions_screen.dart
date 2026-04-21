import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/features/app_permissions/model/permision_item_model.dart';
import 'package:wasel_driver/apps/features/app_permissions/presentation/widgets/allow_access_btn_widget.dart';
import 'package:wasel_driver/apps/features/app_permissions/presentation/widgets/permission_denied_sheet_widget.dart';
import 'package:wasel_driver/apps/features/app_permissions/presentation/widgets/permission_icon_widget.dart';
import 'package:wasel_driver/apps/features/app_permissions/presentation/widgets/step_pogress_bar_widget.dart';
import 'package:wasel_driver/apps/features/app_permissions/service/app_permission_service.dart';

class AppPermissionsScreen extends StatefulWidget {
  /// Called when all required permissions are handled and flow is complete.
  final VoidCallback onComplete;

  const AppPermissionsScreen({super.key, required this.onComplete});

  @override
  State<AppPermissionsScreen> createState() => _AppPermissionsScreenState();
}

class _AppPermissionsScreenState extends State<AppPermissionsScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  bool _isLoading = false;

  late final PageController _pageController;

  final List<PermissionItem> _steps = AppPermissions.steps;

  /// Tracks which permissions were granted (for summary if needed)
  final Map<PermissionType, PermissionStatus> _results = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ─── Core Permission Logic ──────────────────────────────────────────────────

  /// Called when user taps "Allow Access"
  Future<void> _handleAllowAccess() async {
    final item = _steps[_currentStep];

    setState(() => _isLoading = true);

    // 🔑 Real OS permission request using permission_handler
    PermissionStatus result;
    switch (item.type) {
      case PermissionType.location:
        result = await PermissionService.requestLocation();
        break;
      case PermissionType.notification:
        result = await PermissionService.requestNotification();
        break;
      case PermissionType.camera:
        result = await PermissionService.requestCamera();
        break;
    }

    setState(() {
      _isLoading = false;
      _results[item.type] = result;
    });

    if (result.isGranted) {
      _advanceToNext();
    } else if (result.isPermanentlyDenied) {
      // Blocked — offer Settings redirect
      await PermissionDeniedSheet.show(
        context,
        permissionName: item.title,
        isPermanent: true,
      );
      if (!item.isRequired) {
        _advanceToNext();
      }
      // If required, stay on step — user must grant from Settings
    } else {
      // Denied
      if (item.isRequired) {
        // Required permission denied — show explanation sheet
        await PermissionDeniedSheet.show(
          context,
          permissionName: item.title,
          isPermanent: false,
        );
        // Stay on same step so user can try again
      } else {
        // Optional permission denied — just move on
        _advanceToNext();
      }
    }
  }

  /// Called when user taps "Skip for now" (optional permissions only)
  void _handleSkip() {
    _results[_steps[_currentStep].type] = PermissionStatus.denied;
    _advanceToNext();
  }

  /// Move to the next step or finish the flow
  void _advanceToNext() {
    if (_currentStep < _steps.length - 1) {
      log('next step');
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    } else {
      log('login screen');
      widget.onComplete();
    }
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          physics:
              const NeverScrollableScrollPhysics(), // Only programmatic nav
          itemCount: _steps.length,
          itemBuilder: (context, index) {
            return _PermissionStepPage(
              item: _steps[index],
              stepIndex: index,
              totalSteps: _steps.length,
              isLoading: _isLoading && _currentStep == index,
              onAllow: _handleAllowAccess,
              onSkip: _handleSkip,
            );
          },
        ),
      ),
    );
  }
}

// ─── Single Step Page ─────────────────────────────────────────────────────────

class _PermissionStepPage extends StatelessWidget {
  final PermissionItem item;
  final int stepIndex;
  final int totalSteps;
  final bool isLoading;
  final VoidCallback onAllow;
  final VoidCallback onSkip;

  const _PermissionStepPage({
    required this.item,
    required this.stepIndex,
    required this.totalSteps,
    required this.isLoading,
    required this.onAllow,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),

          // ── Header ──────────────────────────────────────────────────
          _buildHeader(),

          const SizedBox(height: AppSpacing.md),

          // ── Progress bar ────────────────────────────────────────────
          StepProgressBar(currentStep: stepIndex, totalSteps: totalSteps),

          const Spacer(flex: 2),

          // ── Icon ────────────────────────────────────────────────────
          Center(
            child: PermissionIconCircle(
              icon: item.icon,
              iconColor: item.iconColor,
              backgroundColor: item.iconBackgroundColor,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Title & description ─────────────────────────────────────
          Center(
            child: Column(
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.heading.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.description,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),

                // ── Required badge ───────────────────────────────────
                if (item.isRequired) _buildRequiredBadge(),
              ],
            ),
          ),

          const Spacer(flex: 3),

          // ── Action area ─────────────────────────────────────────────
          AllowAccessButton(onPressed: onAllow, isLoading: isLoading),

          if (!item.isRequired && item.skipLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            Center(
              child: GestureDetector(
                onTap: onSkip,
                child: Text(
                  item.skipLabel!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],

          if (item.isRequired) ...[
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                'This permission is required for the app to function properly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'App Permissions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.step,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildRequiredBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.requiredBadge,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.requiredBadgeText.withValues(alpha: 0.3),
        ),
      ),
      child: const Text(
        'Required Permission',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.requiredBadgeText,
        ),
      ),
    );
  }
}
