import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wasel_driver/apps/core/di/app_service_locator.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_images.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_states.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _startMoving = false;
  bool _showSlogan = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _checkAuthAndNavigate();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _startMoving = true);
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    setState(() => _showSlogan = true);
  }

  Future<void> _checkAuthAndNavigate() async {
    // // Wait for splash animation to complete before navigating
    // await Future.delayed(const Duration(seconds: 6));
    // if (!mounted) return;

    // final token = await serviceLocator<LocalStorageService>().getToken();
    // if (!mounted) return;

    // if (token == null) {
    //   // No token → not logged in, go to onboarding
    //   Navigator.of(context).pushNamedAndRemoveUntil(
    //     AppRouteNames.onboardingScreen,
    //     (route) => false,
    //   );
    //   return;
    // }

    // Token exists → check driver account status
    await context.read<DriverAuthCubit>().getDriverAccountStatus();
  }

  void _handleStatusNavigation(DriverAuthState state) {
    if (state.getDriverAccountStatusRequestStatus != RequestStatus.success) {
      return;
    }

    final status = state.driverAccountStatus?.status;
    final pref = state.driverAccountStatus?.referenceId;

    switch (status) {
      case 'pending':
        if (pref != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouteNames.pendingVerificationScreen,
            (route) => false,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouteNames.loginScreen,
            (route) => false,
          );
        }
        break;
      case 'approved':
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouteNames.mainShellScreen,
          (route) => false,
        );
        break;
      default:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRouteNames.loginScreen, (route) => false);
    }
  }

  void _showAccountStatusDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFE8A020)),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouteNames.loginScreen,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final Uri uri = Uri.parse("https://wa.me/201021118492");
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Support',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    const double truckWidth = 280.0;
    const double logoInitialSize = 80.0;
    const double logoFinalSize = 200.0;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return BlocListener<DriverAuthCubit, DriverAuthState>(
      listenWhen: (previous, current) =>
          previous.getDriverAccountStatusRequestStatus !=
          current.getDriverAccountStatusRequestStatus,
      listener: (context, state) async {
        if (state.getDriverAccountStatusRequestStatus ==
            RequestStatus.success) {
          _handleStatusNavigation(state);
        } else if (state.getDriverAccountStatusRequestStatus ==
            RequestStatus.error) {
          // On error fallback to login
          final isFirstTime = await serviceLocator<LocalStorageService>()
              .getIsFirstTime();
          if (isFirstTime == null) {
            if (!context.mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouteNames.onboardingScreen,
              (route) => false,
            );
          } else if (state.getDriverAccountStatusErrorMessage != null &&
              (state.getDriverAccountStatusErrorMessage!.contains(
                    'suspended',
                  ) ||
                  state.getDriverAccountStatusErrorMessage!.contains(
                    'blocked',
                  ) ||
                  state.getDriverAccountStatusErrorMessage!.contains(
                    'denied',
                  ) ||
                  state.getDriverAccountStatusErrorMessage!.contains(
                    'rejected',
                  ) ||
                  state.getDriverAccountStatusErrorMessage!.contains(
                    'reject',
                  ) ||
                  state.getDriverAccountStatusErrorMessage!.contains(
                    'deleted',
                  ))) {
            _showAccountStatusDialog(
              'ACCOUNT WARNING',
              state.getDriverAccountStatusErrorMessage ?? '',
            );
          } else {
            if (!context.mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouteNames.loginScreen,
              (route) => false,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.easeInOutQuart,
              left: _startMoving
                  ? screenWidth
                  : (screenWidth / 2) - (truckWidth / 2),
              top: (screenHeight / 2) - (truckWidth / 4),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: _startMoving ? 0.0 : 1.0,
                child: Image.asset(AppImages.truck, width: truckWidth),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeOutBack,
              left: _startMoving
                  ? (screenWidth / 2) - (logoFinalSize / 2)
                  : (screenWidth / 2) - (truckWidth / 2) + 30,
              top: _startMoving
                  ? (screenHeight / 2) - (logoFinalSize / 2)
                  : (screenHeight / 2) - 55,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeOutBack,
                width: _startMoving ? logoFinalSize : logoInitialSize,
                child: Image.asset(AppImages.waselLogo),
              ),
            ),
            Positioned(
              top: (screenHeight / 2) + -20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _showSlogan ? 1.0 : 0.0,
                child: const Text(
                  "Your Logistics Partner",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
