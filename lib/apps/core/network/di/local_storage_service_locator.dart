import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:get_it/get_it.dart';

class LocalStorageServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;

    if (!sl.isRegistered<LocalStorageService>()) {
      sl.registerLazySingleton<LocalStorageService>(
        () => LocalStorageService(),
      );
    }
  }
}
