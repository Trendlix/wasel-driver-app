import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/data/models/notification_model.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/data/service/notification_api_serviice.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/repository/notification_repository.dart';

class NotificationRepositoryImp implements NotificationRepository {
  final NotificationApiServiice _notificationApiServiice;

  NotificationRepositoryImp(this._notificationApiServiice);

  @override
  Future<Either<String, List<NotificationModel>>> getNotifications() {
    return _notificationApiServiice.getNotifications();
  }

  @override
  Future<Either<String, bool>> markAllNotificationsAsRead() {
    return _notificationApiServiice.markAllNotificationsAsRead();
  }
}
