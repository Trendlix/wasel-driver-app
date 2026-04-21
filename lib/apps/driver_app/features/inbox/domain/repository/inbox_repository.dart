import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/inbox_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/chat_messages_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ibox_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ticket_status_entity.dart';

abstract class InboxRepository {
  Future<Either<String, List<OfferEntity>>> getOffersInbox(InboxStatus status);
  Future<Either<String, List<UpdateEntity>>> getUpdatesInbox(
    InboxStatus status,
  );
  Future<Either<String, List<SupportEntity>>> getSupportInbox(
    InboxStatus status,
  );

  Future<Either<String, TicketStatusEntity>> initiateChat(
    int ticketId,
    int userId,
  );

  Future<Either<String, List<ChatMessagesEntity>>> getChatMessages(
    int conversationId,
  );

  Future<Either<String, bool>> sendMessage(
    int conversationId,
    int senderId,
    String message,
    String senderType,
  );
}
