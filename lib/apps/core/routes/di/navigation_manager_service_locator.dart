import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/routes/navigation_manager.dart';
import 'package:get_it/get_it.dart';

class NavigationManagerServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;

    if (!sl.isRegistered<NavigationManager>()) {
      sl.registerLazySingleton<NavigationManager>(() => NavigationManager());
    }
  }
}
