import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/repository/settings_repository_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/services/settings_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/services/settings_api_service_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/repository/settings_repository.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/get_faqs_usecases.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/get_terms_condition_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/get_ticket_category_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/get_user_preferences_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/submit_ticket_usecase.dart'
    show SubmitTicketUsecase;
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/update_user_preferences_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_cubit.dart';

class SettingsServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;
    // register dio client
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(() => DioClient());
    }

    // register settings api service
    if (!sl.isRegistered<SettingsApiService>()) {
      sl.registerLazySingleton<SettingsApiService>(
        () => SettingsApiServiceImpl(sl()),
      );
    }

    // register ticket repository
    if (!sl.isRegistered<SettingsRepository>()) {
      sl.registerLazySingleton<SettingsRepository>(
        () => SettingsRepositoryImp(sl()),
      );
    }

    // register submit ticket usecase
    if (!sl.isRegistered<SubmitTicketUsecase>()) {
      sl.registerLazySingleton<SubmitTicketUsecase>(
        () => SubmitTicketUsecase(sl()),
      );
    }

    // register get user preferences usecase
    if (!sl.isRegistered<GetUserPreferencesUsecase>()) {
      sl.registerLazySingleton<GetUserPreferencesUsecase>(
        () => GetUserPreferencesUsecase(sl()),
      );
    }

    // register update user preferences usecase
    if (!sl.isRegistered<UpdateUserPreferencesUsecase>()) {
      sl.registerLazySingleton<UpdateUserPreferencesUsecase>(
        () => UpdateUserPreferencesUsecase(sl()),
      );
    }

    // register get ticket categories usecase
    if (!sl.isRegistered<GetTicketCategoryUsecase>()) {
      sl.registerLazySingleton<GetTicketCategoryUsecase>(
        () => GetTicketCategoryUsecase(sl()),
      );
    }

    // register get terms condition usecase
    if (!sl.isRegistered<GetTermsConditionUsecase>()) {
      sl.registerLazySingleton<GetTermsConditionUsecase>(
        () => GetTermsConditionUsecase(sl()),
      );
    }

    // register get faqs usecase
    if (!sl.isRegistered<GetFaqsUsecases>()) {
      sl.registerLazySingleton<GetFaqsUsecases>(() => GetFaqsUsecases(sl()));
    }

    // register settings cubit
    if (!sl.isRegistered<SettingsCubit>()) {
      sl.registerFactory<SettingsCubit>(
        () => SettingsCubit(sl(), sl(), sl(), sl(), sl(), sl()),
      );
    }
  }
}
