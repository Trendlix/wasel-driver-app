import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/get_chat_messages_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/get_inbox_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/initate_chat_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/mark_inbox_item_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/send_message_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/manager/inbox_states.dart';

class InboxCubit extends Cubit<InboxStates> {
  final GetOffersInboxUsecase _getOffersInboxUsecase;
  final GetUpdatesInboxUsecase _getUpdatesInboxUsecase;
  final GetSupportInboxUsecase _getSupportInboxUsecase;
  final InitateChatUsecase _initateChatUsecase;
  final GetChatMessagesUsecase _getChatMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final MarkInboxItemUsecase _markInboxItemUsecase;
  InboxCubit(
    this._getOffersInboxUsecase,
    this._getUpdatesInboxUsecase,
    this._getSupportInboxUsecase,
    this._initateChatUsecase,
    this._getChatMessagesUsecase,
    this._sendMessageUsecase,
    this._markInboxItemUsecase,
  ) : super(const InboxStates());

  Future<void> getOffersInbox(InboxStatus status) async {
    emit(state.copyWith(getInboxRequestStatus: RequestStatus.loading));
    final result = await _getOffersInboxUsecase(status);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          getInboxRequestStatus: RequestStatus.error,
          getInboxErrorMessage: error,
        ),
      ),
      (offers) => emit(
        state.copyWith(
          getInboxRequestStatus: RequestStatus.success,
          offers: offers,
        ),
      ),
    );
  }

  Future<void> getUpdatesInbox(InboxStatus status) async {
    emit(state.copyWith(getInboxRequestStatus: RequestStatus.loading));
    final result = await _getUpdatesInboxUsecase(status);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          getInboxRequestStatus: RequestStatus.error,
          getInboxErrorMessage: error,
        ),
      ),
      (updates) => emit(
        state.copyWith(
          getInboxRequestStatus: RequestStatus.success,
          updates: updates,
        ),
      ),
    );
  }

  Future<void> getSupportInbox(InboxStatus status) async {
    emit(state.copyWith(getInboxRequestStatus: RequestStatus.loading));
    final result = await _getSupportInboxUsecase(status);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          getInboxRequestStatus: RequestStatus.error,
          getInboxErrorMessage: error,
        ),
      ),
      (supports) => emit(
        state.copyWith(
          getInboxRequestStatus: RequestStatus.success,
          supports: supports,
        ),
      ),
    );
  }

  Future<void> initiateChat(
    int ticketId,
    int userId,
    ChatAction action,
    int? inboxItemId,
  ) async {
    emit(
      state.copyWith(
        initiateChatRequestStatus: RequestStatus.loading,
        ticketId: ticketId,
        loadingInboxId: inboxItemId,
        chatAction: action,
      ),
    );
    final result = await _initateChatUsecase(ticketId, userId);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          initiateChatRequestStatus: RequestStatus.error,
          initiateChatErrorMessage: error,
          ticketId: -1,
          loadingInboxId: -1,
          chatAction: null,
        ),
      ),
      (ticketStatusEntity) => emit(
        state.copyWith(
          initiateChatRequestStatus: RequestStatus.success,
          ticketStatusEntity: ticketStatusEntity,
          ticketId: -1,
          loadingInboxId: -1,
          chatAction: null,
        ),
      ),
    );
  }

  Future<void> getChatMessages(int conversationId) async {
    emit(state.copyWith(getChatMessagesRequestStatus: RequestStatus.loading));
    final result = await _getChatMessagesUsecase(conversationId);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          getChatMessagesRequestStatus: RequestStatus.error,
          getChatMessagesErrorMessage: error,
        ),
      ),
      (chatMessages) => emit(
        state.copyWith(
          getChatMessagesRequestStatus: RequestStatus.success,
          chatMessages: chatMessages,
        ),
      ),
    );
  }

  Future<void> sendMessage(
    int conversationId,
    int senderId,
    String message,
    String senderType,
  ) async {
    emit(
      state.copyWith(
        sendMessageRequestStatus: RequestStatus.loading,
        lastSentMessage: message,
      ),
    );
    final result = await _sendMessageUsecase(
      conversationId,
      senderId,
      message,
      senderType,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          sendMessageRequestStatus: RequestStatus.error,
          sendMessageErrorMessage: error,
          lastSentMessage: error,
        ),
      ),
      (isSent) {
        emit(
          state.copyWith(
            sendMessageRequestStatus: RequestStatus.success,
            lastSentMessage: null,
          ),
        );
        // Refresh messages to get the real one from DB
        getChatMessages(conversationId);
      },
    );
  }

  Future<void> markInboxItem(String inboxItemId, bool isSupport) async {
    emit(state.copyWith(markInboxItemRequestStatus: RequestStatus.loading));
    final result = await _markInboxItemUsecase(inboxItemId, isSupport);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          markInboxItemRequestStatus: RequestStatus.error,
          markInboxItemErrorMessage: error,
        ),
      ),
      (isMarked) => emit(
        state.copyWith(
          markInboxItemRequestStatus: RequestStatus.success,
          markInboxItemErrorMessage: null,
        ),
      ),
    );
  }

  void resetMarkInboxItemStatus() {
    emit(state.copyWith(markInboxItemRequestStatus: RequestStatus.initial));
  }

  void resetInitiateChatStatus() {
    emit(state.copyWith(
      initiateChatRequestStatus: RequestStatus.initial,
      ticketId: -1,
      loadingInboxId: -1,
      chatAction: null,
    ));
  }
}
