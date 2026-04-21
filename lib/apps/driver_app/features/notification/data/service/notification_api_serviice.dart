import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/data/models/notification_model.dart';

abstract class NotificationApiServiice {
  Future<Either<String, List<NotificationModel>>> getNotifications();
  Future<Either<String, bool>> markAllNotificationsAsRead();
}
