import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/chat_messages_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/repository/inbox_repository.dart';

class GetChatMessagesUsecase {
  final InboxRepository inboxRepository;

  GetChatMessagesUsecase(this.inboxRepository);

  Future<Either<String, List<ChatMessagesEntity>>> call(int conversationId) {
    return inboxRepository.getChatMessages(conversationId);
  }
}
