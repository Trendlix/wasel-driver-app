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
  Future<Either<String, List<OfferEntity>>> getOffersInbox(
    InboxStatus status,
    int page,
    int limit,
  ) {
    return _inboxApiService.getOffersInbox(status, page, limit);
  }

  @override
  Future<Either<String, List<UpdateEntity>>> getUpdatesInbox(
    InboxStatus status,
    int page,
    int limit,
  ) {
    return _inboxApiService.getUpdatesInbox(status, page, limit);
  }

  @override
  Future<Either<String, List<SupportEntity>>> getSupportInbox(
    InboxStatus status,
    int page,
    int limit,
  ) {
    return _inboxApiService.getSupportInbox(status, page, limit);
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
  Future<Either<String, bool>> sendMessage(int ticketId, String message) {
    return _inboxApiService.sendMessage(ticketId, message);
  }

  @override
  Future<Either<String, bool>> markAllInboxAsRead(InboxStatus status) {
    return _inboxApiService.markAllInboxAsRead(status);
  }

  @override
  Future<Either<String, bool>> markInboxAsRead(int ticketId) {
    return _inboxApiService.markInboxAsRead(ticketId);
  }
}
