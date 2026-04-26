import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<String, List<NotificationEntity>>> getNotifications({
    required int page,
    required int limit,
  });
  Future<Either<String, bool>> markAllNotificationsAsRead();
}
