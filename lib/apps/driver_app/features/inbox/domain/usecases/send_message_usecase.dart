import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/repository/inbox_repository.dart';

class SendMessageUsecase {
  final InboxRepository _inboxRepository;

  SendMessageUsecase(this._inboxRepository);

  Future<Either<String, bool>> call(
    int conversationId,
    int senderId,
    String message,
    String senderType,
  ) {
    return _inboxRepository.sendMessage(
      conversationId,
      senderId,
      message,
      senderType,
    );
  }
}
