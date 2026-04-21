import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/repository/notification_repository.dart';

class MarkAllNotificationUsecase {
  final NotificationRepository _notificationRepository;

  MarkAllNotificationUsecase(this._notificationRepository);

  Future<Either<String, bool>> call() {
    return _notificationRepository.markAllNotificationsAsRead();
  }
}
