import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/entities/notification_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/repository/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository _notificationRepository;

  GetNotificationsUsecase(this._notificationRepository);

  Future<Either<String, List<NotificationEntity>>> call({
    required int page,
    required int limit,
  }) {
    return _notificationRepository.getNotifications(page: page, limit: limit);
  }
}
