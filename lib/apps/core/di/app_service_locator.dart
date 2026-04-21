import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/app_interceptor.dart';
import 'package:wasel_driver/apps/core/network/di/dio_service_locator.dart';
import 'package:wasel_driver/apps/core/network/di/local_storage_service_locator.dart';
import 'package:wasel_driver/apps/core/routes/di/navigation_manager_service_locator.dart';

class AppServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    await DioServiceLocator().initServiceLocator();
    await LocalStorageServiceLocator().initServiceLocator();
    await NavigationManagerServiceLocator().initServiceLocator();
    serviceLocator.registerLazySingleton<AppInterceptor>(
      () => AppInterceptor(),
    );
  }
}

final serviceLocator = GetIt.instance;
