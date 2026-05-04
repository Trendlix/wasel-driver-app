import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/repository/inbox_repository.dart';

class MarkAllInboxesUsecase {
  final InboxRepository _inboxRepository;

  MarkAllInboxesUsecase(this._inboxRepository);

  Future<Either<String, bool>> call(InboxStatus status) {
    return _inboxRepository.markAllInboxAsRead(status);
  }
}

class MarkInboxAsReadUsecase {
  final InboxRepository _inboxRepository;

  MarkInboxAsReadUsecase(this._inboxRepository);

  Future<Either<String, bool>> call(int ticketId) {
    return _inboxRepository.markInboxAsRead(ticketId);
  }
}
