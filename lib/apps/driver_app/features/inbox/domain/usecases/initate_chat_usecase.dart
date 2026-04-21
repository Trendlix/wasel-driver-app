import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ticket_status_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/repository/inbox_repository.dart';

class InitateChatUsecase {
  final InboxRepository _inboxRepository;
  InitateChatUsecase(this._inboxRepository);

  Future<Either<String, TicketStatusEntity>> call(int ticketId, int userId) {
    return _inboxRepository.initiateChat(ticketId, userId);
  }
}
