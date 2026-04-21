import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/di/app_service_locator.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/di/driver_auth_service_locator.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/home/di/home_service_locator.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/request_categories_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/screens/active_trip_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/screens/confirm_delivery_otp_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/screens/confirm_delivery_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/screens/confirm_pickup_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/screens/delivery_complete_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/screens/request_details_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/screens/requests_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/di/inbox_service_locator.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ticket_status_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/manager/inbox_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/screens/chat_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/screens/inbox_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/di/notification_service_locator.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/presentation/manager/notification_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/presentation/screens/notification_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/di/profile_service_locator.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/screens/personal_info_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/di/settings_service_locator.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/screens/help_center_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/screens/help_support_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/screens/language_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/screens/submit_tcicket_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/screens/ticket_success_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/screens/vehicle_documents_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/screens/wasel_legel_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/di/driver_trip_service_locator.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_summary_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/screens/booking_contract_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/di/wallet_service_locator.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/transaction_history_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/presentation/screens/drawal_success_screen.dart';
import 'package:wasel_driver/apps/features/app_permissions/presentation/screens/app_permissions_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/driver_approved_account_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/driver_cancelled_account_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/login_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/register_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/request_submit_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/verify_login_otp_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/view_verification_status.dart';
import 'package:wasel_driver/apps/driver_app/features/bottom_nav_bar/presentation/screens/main_shell_screen.dart';
import 'package:wasel_driver/apps/features/onboarding/screens/join_app_screen.dart';
import 'package:wasel_driver/apps/features/onboarding/screens/onboarding_screen.dart';

import 'package:wasel_driver/apps/features/splash/splash_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/presentation/screens/all_transactions_screen.dart';

class AppNavigatorManager {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.splashScreen:
        return MaterialPageRoute(
          builder: (_) {
            DriverAuthServiceLocator().initServiceLocator();
            return BlocProvider<DriverAuthCubit>(
              create: (context) => serviceLocator<DriverAuthCubit>(),
              child: SplashScreen(),
            );
          },
        );

      case AppRouteNames.onboardingScreen:
        return MaterialPageRoute(
          builder: (_) {
            return OnboardingScreen();
          },
        );

      case AppRouteNames.joinScreen:
        return MaterialPageRoute(
          builder: (_) {
            return JoinScreen();
          },
        );

      case AppRouteNames.loginScreen:
        return MaterialPageRoute(
          builder: (_) {
            DriverAuthServiceLocator().initServiceLocator();
            return BlocProvider<DriverAuthCubit>(
              create: (context) => serviceLocator<DriverAuthCubit>(),
              child: LoginScreen(),
            );
          },
        );

      case AppRouteNames.verifyLoginOtpScreen:
        return MaterialPageRoute(
          builder: (_) {
            final phoneNumber = settings.arguments as String;
            DriverAuthServiceLocator().initServiceLocator();
            return BlocProvider<DriverAuthCubit>(
              create: (context) => serviceLocator<DriverAuthCubit>(),
              child: VerifyLoginOtpScreen(phoneNumber: phoneNumber),
            );
          },
        );

      case AppRouteNames.appPermissionsScreen:
        return MaterialPageRoute(
          builder: (_) {
            final callBack = settings.arguments as VoidCallback;
            return AppPermissionsScreen(onComplete: callBack);
          },
        );

      case AppRouteNames.registerScreen:
        return MaterialPageRoute(
          builder: (_) {
            final tempToken = settings.arguments as String;
            return BlocProvider<DriverAuthCubit>(
              create: (context) =>
                  serviceLocator<DriverAuthCubit>()..getDriverTrucks(tempToken),
              child: DriverRegistrationScreen(tempToken: tempToken),
            );
          },
        );

      case AppRouteNames.requestSubmitScreen:
        return MaterialPageRoute(
          builder: (_) {
            final reference = settings.arguments as String;
            return RequestSubmittedScreen(referenceId: reference);
          },
        );

      case AppRouteNames.pendingVerificationScreen:
        return MaterialPageRoute(
          builder: (_) {
            return PendingVerificationScreen();
          },
        );

      case AppRouteNames.driverApprovedScreen:
        return MaterialPageRoute(
          builder: (_) {
            return DriverApprovedScreen();
          },
        );

      case AppRouteNames.driverCancelledScreen:
        return MaterialPageRoute(
          builder: (_) {
            final reason = settings.arguments as String;
            return RequestNotApprovedScreen(reason: reason);
          },
        );

      case AppRouteNames.mainShellScreen:
        return MaterialPageRoute(
          builder: (_) {
            final initialIndex = settings.arguments as int? ?? 0;
            InboxServiceLocator().initServiceLocator();
            HomeServiceLocator().initServiceLocator();
            DriverTripServiceLocator().initServiceLocator();
            WalletServiceLocator().initServiceLocator();
            ProfileServiceLocator().initServiceLocator();
            NotificationServiceLocator().initServiceLocator();
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => serviceLocator<InboxCubit>()),
                BlocProvider(create: (context) => serviceLocator<HomeCubit>()),
                BlocProvider(
                  create: (context) => serviceLocator<DriverTripCubit>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<WalletCubit>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<ProfileCubit>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<NotificationCubit>(),
                ),
              ],
              child: MainShellScreen(initialIndex: initialIndex),
            );
          },
        );
      case AppRouteNames.allTransactionsScreen:
        return MaterialPageRoute(
          builder: (_) {
            final transactions = settings.arguments as List<TransactionEntity>;
            return AllTransactionsScreen(transactions: transactions);
          },
        );
      case AppRouteNames.newRequestsScreen:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>;
            final categories = args['categories'] as RequestCategoriesEntity;
            final latitude = args['latitude'] as double;
            final longitude = args['longitude'] as double;
            HomeServiceLocator().initServiceLocator();
            return BlocProvider(
              create: (context) => serviceLocator<HomeCubit>(),
              child: NewRequestsScreen(
                categories: categories,
                latitude: latitude,
                longitude: longitude,
              ),
            );
          },
        );
      case AppRouteNames.requestDetailsScreen:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>;
            final lat = args['lat'] as String;
            final long = args['long'] as String;
            final requestId = args['requestId'] as int;
            HomeServiceLocator().initServiceLocator();
            return BlocProvider(
              create: (context) => serviceLocator<HomeCubit>(),
              child: RequestDetailsScreen(
                requestId: requestId,
                lat: lat,
                long: long,
              ),
            );
          },
        );
      case AppRouteNames.tripDetail:
        return MaterialPageRoute(
          builder: (_) {
            final tripId = settings.arguments as int;
            DriverTripServiceLocator().initServiceLocator();
            return BlocProvider(
              create: (context) => serviceLocator<DriverTripCubit>(),
              child: TripDetailScreen(tripId: tripId),
            );
          },
        );
      case AppRouteNames.withdrawalSuccessScreen:
        return MaterialPageRoute(
          builder: (_) {
            return WithdrawalSuccessScreen();
          },
        );
      case AppRouteNames.navigateToPickupScreen:
        return MaterialPageRoute(
          builder: (_) {
            final trip = settings.arguments as TripEntity;
            DriverTripServiceLocator().initServiceLocator();
            return BlocProvider(
              create: (context) => serviceLocator<DriverTripCubit>(),
              child: ActiveTripScreen(trip: trip),
            );
          },
        );
      case AppRouteNames.confirmPickupScreen:
        return MaterialPageRoute(
          builder: (_) {
            final trip = settings.arguments as TripEntity;
            DriverTripServiceLocator().initServiceLocator();
            return BlocProvider(
              create: (context) => serviceLocator<DriverTripCubit>(),
              child: ConfirmPickupScreen(trip: trip),
            );
          },
        );
      case AppRouteNames.confirmDeliveryScreen:
        return MaterialPageRoute(
          builder: (_) {
            final trip = settings.arguments as TripEntity;
            return ConfirmDeliveryScreen(trip: trip);
          },
        );

      case AppRouteNames.confirmDeliveryOtpScreen:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>;
            final image = args['image'] as File;
            final trip = args['trip'] as TripEntity;
            DriverTripServiceLocator().initServiceLocator();
            return BlocProvider(
              create: (context) => serviceLocator<DriverTripCubit>(),
              child: ConfirmDeliveryOtpScreen(image: image, trip: trip),
            );
          },
        );

      case AppRouteNames.confirmDeliverySuccessScreen:
        return MaterialPageRoute(
          builder: (_) {
            final tripSummaries = settings.arguments as TripSummaryEntity;
            return DeliveryCompletedScreen(tripSummary: tripSummaries);
          },
        );
      case AppRouteNames.personalInfoScreen:
        return MaterialPageRoute(
          builder: (_) {
            return PersonalInfoScreen();
          },
        );
      case AppRouteNames.vehicleDocumentsScreen:
        return MaterialPageRoute(
          builder: (_) {
            return VehicleDocumentsScreen();
          },
        );
      case AppRouteNames.helpAndSupportScreen:
        return MaterialPageRoute(
          builder: (_) {
            SettingsServiceLocator().initServiceLocator();
            return BlocProvider(
              create: (context) => serviceLocator<SettingsCubit>(),
              child: HelpSupportScreen(),
            );
          },
        );
      case AppRouteNames.notificationScreen:
        NotificationServiceLocator().initServiceLocator();
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) => serviceLocator<NotificationCubit>(),
              child: NotificationScreen(),
            );
          },
        );
      case AppRouteNames.inboxScreen:
        InboxServiceLocator().initServiceLocator();
        return MaterialPageRoute(
          builder: (_) {
            final isFromProfile = settings.arguments as bool;
            return BlocProvider(
              create: (context) => serviceLocator<InboxCubit>(),
              child: InboxScreen(isFromProfile: isFromProfile),
            );
          },
        );
      case AppRouteNames.languageScreen:
        return MaterialPageRoute(
          builder: (_) {
            return LanguagePreferencesScreen();
          },
        );
      case AppRouteNames.settingsScreen:
        SettingsServiceLocator().initServiceLocator();
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) => serviceLocator<SettingsCubit>(),
              child: SettingsScreen(),
            );
          },
        );
      case AppRouteNames.helpCenterScreen:
        SettingsServiceLocator().initServiceLocator();
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) => serviceLocator<SettingsCubit>(),
              child: HelpCenterScreen(),
            );
          },
        );
      case AppRouteNames.submitTicketScreen:
        SettingsServiceLocator().initServiceLocator();
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) => serviceLocator<SettingsCubit>(),
              child: SubmitTicketScreen(),
            );
          },
        );
      case AppRouteNames.ticketSuccessScreen:
        return MaterialPageRoute(
          builder: (_) {
            final ticketNumber = settings.arguments as String?;
            return TicketSuccessScreen(ticketNumber: ticketNumber);
          },
        );
      case AppRouteNames.waselLegelScreen:
        SettingsServiceLocator().initServiceLocator();
        return MaterialPageRoute(
          builder: (_) {
            final isTerms = settings.arguments as bool;
            return BlocProvider(
              create: (context) => serviceLocator<SettingsCubit>(),
              child: WaselLegalScreen(isTerms: isTerms),
            );
          },
        );

      case AppRouteNames.chatScreen:
        InboxServiceLocator().initServiceLocator();
        return MaterialPageRoute(
          builder: (_) {
            final ticket = settings.arguments as Map<String, dynamic>;
            return BlocProvider(
              create: (context) => serviceLocator<InboxCubit>(),
              child: ChatScreen(
                ticket: ticket['ticket'] as TicketStatusEntity,
                ticketId: ticket['ticketId'] as String,
              ),
            );
          },
        );
      case AppRouteNames.bookingContractScreen:
        return MaterialPageRoute(
          builder: (_) {
            final trip = settings.arguments as TripEntity;
            return BookingContractScreen(trip: trip);
          },
        );
      default:
        return _unDefinedRoute();
    }
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}
