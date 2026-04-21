import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';

class DioServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    GetIt.instance.registerLazySingleton<DioClient>(() => DioClient());
  }
}
