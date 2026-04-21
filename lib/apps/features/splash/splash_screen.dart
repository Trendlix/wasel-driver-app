import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        // TODO: replace with actual home screen route when ready
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouteNames.mainShellScreen,
          (route) => false,
        );
        break;
      case 'rejected':
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouteNames.driverCancelledScreen,
          (route) => false,
          arguments: state.driverAccountStatus?.rejectionReason ?? '',
        );
        break;
      default:
        // Fallback: unknown status → go to login
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRouteNames.loginScreen, (route) => false);
    }
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
