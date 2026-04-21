import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/data/repository/notification_repository_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/data/service/notification_api_service_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/data/service/notification_api_serviice.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/repository/notification_repository.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/usecases/get_notifications_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/usecases/mark_all_notification_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/presentation/manager/notification_cubit.dart';

class NotificationServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;
    // register api client
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(() => DioClient());
    }

    // register api service
    if (!sl.isRegistered<NotificationApiServiice>()) {
      sl.registerLazySingleton<NotificationApiServiice>(
        () => NotificationApiServiceImp(sl()),
      );
    }
    // register repository
    if (!sl.isRegistered<NotificationRepository>()) {
      sl.registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImp(sl()),
      );
      // register get notifications usecase
      if (!sl.isRegistered<GetNotificationsUsecase>()) {
        sl.registerLazySingleton<GetNotificationsUsecase>(
          () => GetNotificationsUsecase(sl()),
        );
      }

      // register mark all notifications as read usecase
      if (!sl.isRegistered<MarkAllNotificationUsecase>()) {
        sl.registerLazySingleton<MarkAllNotificationUsecase>(
          () => MarkAllNotificationUsecase(sl()),
        );
      }
      // register notification cubit
      if (!sl.isRegistered<NotificationCubit>()) {
        sl.registerFactory<NotificationCubit>(
          () => NotificationCubit(sl(), sl()),
        );
      }
    }
  }
}
