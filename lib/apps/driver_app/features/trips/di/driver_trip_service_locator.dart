import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/repositories/driver_trip_repository_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/services/driver_trip_api_imp_service.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/services/driver_trip_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/repositories/driver_trip_repository.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/cancel_driver_trip_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/confirm_trip_devlivery_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/confirm_trip_pick_up_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/get_driver_trip_by_id_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/get_driver_trips_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_cubit.dart';

class DriverTripServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;

    // register api client
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(() => DioClient());
    }

    // register api service
    if (!sl.isRegistered<DriverTripApiService>()) {
      sl.registerLazySingleton<DriverTripApiService>(
        () => DriverTripApiImpService(sl()),
      );
    }

    // register repository
    if (!sl.isRegistered<DriverTripRepository>()) {
      sl.registerLazySingleton<DriverTripRepository>(
        () => DriverTripRepositoryImp(sl()),
      );
    }
    // register get driver trips useCase
    if (!sl.isRegistered<GetDriverTripsUsecase>()) {
      sl.registerLazySingleton<GetDriverTripsUsecase>(
        () => GetDriverTripsUsecase(sl()),
      );
    }

    // register get driver trip by id useCase
    if (!sl.isRegistered<GetDriverTripByIdUsecase>()) {
      sl.registerLazySingleton<GetDriverTripByIdUsecase>(
        () => GetDriverTripByIdUsecase(sl()),
      );
    }

    // register cancel driver trip useCase
    if (!sl.isRegistered<CancelDriverTripUsecase>()) {
      sl.registerLazySingleton<CancelDriverTripUsecase>(
        () => CancelDriverTripUsecase(sl()),
      );
    }

    // register confirm pickup useCase
    if (!sl.isRegistered<ConfirmTripPickUpUsecase>()) {
      sl.registerLazySingleton<ConfirmTripPickUpUsecase>(
        () => ConfirmTripPickUpUsecase(sl()),
      );
    }

    // register confirm delivery useCase
    if (!sl.isRegistered<ConfirmTripDevliveryUsecase>()) {
      sl.registerLazySingleton<ConfirmTripDevliveryUsecase>(
        () => ConfirmTripDevliveryUsecase(sl()),
      );
    }

    // register cubit
    if (!sl.isRegistered<DriverTripCubit>()) {
      sl.registerFactory<DriverTripCubit>(
        () => DriverTripCubit(sl(), sl(), sl(), sl(), sl()),
      );
    }
  }
}
