import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/chat_messages_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/inbox_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/ticket_model.dart';

abstract class InboxApiService {
  Future<Either<String, List<OfferModel>>> getOffersInbox(InboxStatus status);
  Future<Either<String, List<UpdateModel>>> getUpdatesInbox(InboxStatus status);
  Future<Either<String, List<SupportModel>>> getSupportInbox(
    InboxStatus status,
  );

  Future<Either<String, TicketStatusModel>> initiateChat(
    int ticketId,
    int userId,
  );

  Future<Either<String, List<ChatMessagesModel>>> getChatMessages(
    int conversationId,
  );

  Future<Either<String, bool>> sendMessage(
    int conversationId,
    int senderId,
    String message,
    String senderType,
  );

  Future<Either<String, bool>> markInboxItem(
    String inboxItemId,
    bool isSupport,
  );
}
