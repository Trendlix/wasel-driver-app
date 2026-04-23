import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/chat_messages_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/inbox_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/ticket_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/services/inbox_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ibox_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/repository/inbox_repository.dart';

class InboxRepositoryImp implements InboxRepository {
  final InboxApiService _inboxApiService;
  InboxRepositoryImp(this._inboxApiService);

  @override
  Future<Either<String, List<OfferEntity>>> getOffersInbox(InboxStatus status) {
    return _inboxApiService.getOffersInbox(status);
  }

  @override
  Future<Either<String, List<UpdateEntity>>> getUpdatesInbox(
    InboxStatus status,
  ) {
    return _inboxApiService.getUpdatesInbox(status);
  }

  @override
  Future<Either<String, List<SupportEntity>>> getSupportInbox(
    InboxStatus status,
  ) {
    return _inboxApiService.getSupportInbox(status);
  }

  @override
  Future<Either<String, TicketStatusModel>> initiateChat(
    int ticketId,
    int userId,
  ) {
    return _inboxApiService.initiateChat(ticketId, userId);
  }

  @override
  Future<Either<String, List<ChatMessagesModel>>> getChatMessages(
    int conversationId,
  ) {
    return _inboxApiService.getChatMessages(conversationId);
  }

  @override
  Future<Either<String, bool>> sendMessage(
    int conversationId,
    int senderId,
    String message,
    String senderType,
  ) {
    return _inboxApiService.sendMessage(
      conversationId,
      senderId,
      message,
      senderType,
    );
  }

  @override
  Future<Either<String, bool>> markInboxItem(
    String inboxItemId,
    bool isSupport,
  ) {
    return _inboxApiService.markInboxItem(inboxItemId, isSupport);
  }
}
