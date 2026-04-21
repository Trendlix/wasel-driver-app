import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/repositories/home_repository_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/services/home_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/services/home_api_service_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/repositories/home_repository.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/get_driver_profile_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/get_driver_requests_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/get_driver_summary_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/get_single_request_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/reject_driver_request_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/send_driver_offer_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_cubit.dart';

class HomeServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;

    // register api client
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(() => DioClient());
    }

    // register home api service
    if (!sl.isRegistered<HomeApiService>()) {
      sl.registerLazySingleton<HomeApiService>(
        () => HomeApiServiceImp(apiClient: sl()),
      );
    }

    // register home repository
    if (!sl.isRegistered<HomeRepository>()) {
      sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImp(homeApiService: sl()),
      );
    }

    // register get driver summary usecase
    if (!sl.isRegistered<GetDriverSummaryUsecase>()) {
      sl.registerLazySingleton<GetDriverSummaryUsecase>(
        () => GetDriverSummaryUsecase(homeRepository: sl()),
      );
    }

    // register get driver profile usecase
    if (!sl.isRegistered<GetDriverProfileUsecase>()) {
      sl.registerLazySingleton<GetDriverProfileUsecase>(
        () => GetDriverProfileUsecase(homeRepository: sl()),
      );

      // register get driver requests usecase
      if (!sl.isRegistered<GetDriverRequestsUsecase>()) {
        sl.registerLazySingleton<GetDriverRequestsUsecase>(
          () => GetDriverRequestsUsecase(homeRepository: sl()),
        );
      }

      // register reject driver request usecase
      if (!sl.isRegistered<RejectDriverRequestUsecase>()) {
        sl.registerLazySingleton<RejectDriverRequestUsecase>(
          () => RejectDriverRequestUsecase(homeRepository: sl()),
        );
      }

      if (!sl.isRegistered<SendDriverOfferUsecase>()) {
        sl.registerLazySingleton<SendDriverOfferUsecase>(
          () => SendDriverOfferUsecase(homeRepository: sl()),
        );
      }

      if (!sl.isRegistered<GetSingleRequestUsecase>()) {
        sl.registerLazySingleton<GetSingleRequestUsecase>(
          () => GetSingleRequestUsecase(homeRepository: sl()),
        );
      }

      sl.registerFactory<HomeCubit>(
        () => HomeCubit(
          getDriverProfileUsecase: sl(),
          getDriverSummaryUsecase: sl(),
          getDriverRequestsUsecase: sl(),
          rejectDriverRequestUsecase: sl(),
          sendDriverOfferUsecase: sl(),
          getSingleRequestUsecase: sl(),
        ),
      );
    }
  }
}
