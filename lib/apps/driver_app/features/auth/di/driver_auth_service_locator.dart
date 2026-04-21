import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/repositories/driver_auth_repository_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/services/driver_auth_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/services/driver_auth_api_service_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/repositories/driver_auth_repository.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/check_driver_phone_registered_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/get_driver_account_status_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/get_driver_trucks_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/register_driver_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/verify_driver_otp_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_cubit.dart';

class DriverAuthServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;

    // register api client
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(() => DioClient());
    }
    // register auth service
    if (!sl.isRegistered<DriverAuthApiService>()) {
      sl.registerLazySingleton<DriverAuthApiService>(
        () => DriverAuthApiServiceImp(apiClient: sl()),
      );
    }

    // register auth repo
    if (!sl.isRegistered<DriverAuthRepository>()) {
      sl.registerLazySingleton<DriverAuthRepository>(
        () => DriverAuthRepositoryImp(sl()),
      );
    }
    // register  sign up usecase
    if (!sl.isRegistered<CheckDriverPhoneRegisteredUsecase>()) {
      sl.registerLazySingleton<CheckDriverPhoneRegisteredUsecase>(
        () => CheckDriverPhoneRegisteredUsecase(sl()),
      );
    }

    // register verify otp usecase
    if (!sl.isRegistered<VerifyDriverOtpUsecase>()) {
      sl.registerLazySingleton<VerifyDriverOtpUsecase>(
        () => VerifyDriverOtpUsecase(sl()),
      );
    }

    // register register driver usecase
    if (!sl.isRegistered<RegisterDriverUsecase>()) {
      sl.registerLazySingleton<RegisterDriverUsecase>(
        () => RegisterDriverUsecase(sl()),
      );
    }
    // register get driver trucks usecase
    if (!sl.isRegistered<GetDriverTrucksUsecase>()) {
      sl.registerLazySingleton<GetDriverTrucksUsecase>(
        () => GetDriverTrucksUsecase(sl()),
      );
    }

    // register get driver account status usecase
    if (!sl.isRegistered<GetDriverAccountStatusUsecase>()) {
      sl.registerLazySingleton<GetDriverAccountStatusUsecase>(
        () => GetDriverAccountStatusUsecase(sl()),
      );
    }
    // register auth cubit
    if (!sl.isRegistered<DriverAuthCubit>()) {
      sl.registerFactory<DriverAuthCubit>(
        () => DriverAuthCubit(sl(), sl(), sl(), sl(), sl()),
      );
    }
  }
}
