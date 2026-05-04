import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/chat_messages_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/get_chat_messages_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/get_inbox_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/initate_chat_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/mark_inboxes_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/send_message_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/manager/inbox_states.dart';

class InboxCubit extends Cubit<InboxStates> {
  final GetOffersInboxUsecase _getOffersInboxUsecase;
  final GetUpdatesInboxUsecase _getUpdatesInboxUsecase;
  final GetSupportInboxUsecase _getSupportInboxUsecase;
  final InitateChatUsecase _initateChatUsecase;
  final GetChatMessagesUsecase _getChatMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final MarkAllInboxesUsecase _markAllInboxesUsecase;
  final MarkInboxAsReadUsecase _markInboxAsReadUsecase;
  InboxCubit(
    this._getOffersInboxUsecase,
    this._getUpdatesInboxUsecase,
    this._getSupportInboxUsecase,
    this._initateChatUsecase,
    this._getChatMessagesUsecase,
    this._sendMessageUsecase,
    this._markAllInboxesUsecase,
    this._markInboxAsReadUsecase,
  ) : super(const InboxStates());

  Future<void> getOffersInbox(
    InboxStatus status, {
    int limit = 10,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (state.isLoadingMore || !state.offersHasMore) return;
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(
        state.copyWith(
          getInboxRequestStatus: RequestStatus.loading,
          offersPage: 1,
          offersHasMore: true,
        ),
      );
    }

    final nextPage = isLoadMore ? state.offersPage + 1 : 1;
    final result = await _getOffersInboxUsecase(status, nextPage, limit);
    result.fold(
      (error) {
        if (isLoadMore) {
          emit(state.copyWith(isLoadingMore: false));
        } else {
          emit(
            state.copyWith(
              getInboxRequestStatus: RequestStatus.error,
              getInboxErrorMessage: error,
              isLoadingMore: false,
            ),
          );
        }
      },
      (offers) {
        final mergedOffers = isLoadMore
            ? [...?state.offers, ...offers]
            : offers;
        emit(
          state.copyWith(
            getInboxRequestStatus: RequestStatus.success,
            offers: mergedOffers,
            offersPage: nextPage,
            offersHasMore: offers.length == limit,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> getUpdatesInbox(
    InboxStatus status, {
    int limit = 10,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (state.isLoadingMore || !state.updatesHasMore) return;
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(
        state.copyWith(
          getInboxRequestStatus: RequestStatus.loading,
          updatesPage: 1,
          updatesHasMore: true,
        ),
      );
    }

    final nextPage = isLoadMore ? state.updatesPage + 1 : 1;
    final result = await _getUpdatesInboxUsecase(status, nextPage, limit);
    result.fold(
      (error) {
        if (isLoadMore) {
          emit(state.copyWith(isLoadingMore: false));
        } else {
          emit(
            state.copyWith(
              getInboxRequestStatus: RequestStatus.error,
              getInboxErrorMessage: error,
              isLoadingMore: false,
            ),
          );
        }
      },
      (updates) {
        final mergedUpdates = isLoadMore
            ? [...?state.updates, ...updates]
            : updates;
        emit(
          state.copyWith(
            getInboxRequestStatus: RequestStatus.success,
            updates: mergedUpdates,
            updatesPage: nextPage,
            updatesHasMore: updates.length == limit,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> getSupportInbox(
    InboxStatus status, {
    int limit = 10,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (state.isLoadingMore || !state.supportsHasMore) return;
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(
        state.copyWith(
          getInboxRequestStatus: RequestStatus.loading,
          supportsPage: 1,
          supportsHasMore: true,
        ),
      );
    }

    final nextPage = isLoadMore ? state.supportsPage + 1 : 1;
    final result = await _getSupportInboxUsecase(status, nextPage, limit);
    result.fold(
      (error) {
        if (isLoadMore) {
          emit(state.copyWith(isLoadingMore: false));
        } else {
          emit(
            state.copyWith(
              getInboxRequestStatus: RequestStatus.error,
              getInboxErrorMessage: error,
              isLoadingMore: false,
            ),
          );
        }
      },
      (supports) {
        final mergedSupports = isLoadMore
            ? [...?state.supports, ...supports]
            : supports;
        emit(
          state.copyWith(
            getInboxRequestStatus: RequestStatus.success,
            supports: mergedSupports,
            supportsPage: nextPage,
            supportsHasMore: supports.length == limit,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> initiateChat(
    int ticketId,
    int userId, {
    String? actionId,
  }) async {
    emit(
      state.copyWith(
        initiateChatRequestStatus: RequestStatus.loading,
        ticketId: ticketId,
        initiateChatActionId: actionId,
      ),
    );
    final result = await _initateChatUsecase(ticketId, userId);
    result.fold(
      (error) => emit(
        state.copyWith(
          initiateChatRequestStatus: RequestStatus.error,
          initiateChatErrorMessage: error,
          ticketId: null,
        ),
      ),
      (ticketStatusEntity) => emit(
        state.copyWith(
          initiateChatRequestStatus: RequestStatus.success,
          ticketStatusEntity: ticketStatusEntity,
          ticketId: null,
        ),
      ),
    );
  }

  Future<void> getChatMessages(int conversationId) async {
    emit(state.copyWith(getChatMessagesRequestStatus: RequestStatus.loading));
    final result = await _getChatMessagesUsecase(conversationId);
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

  Future<void> sendMessage(int ticketId, String message) async {
    // Add message optimistically to the list
    final currentMessages = state.chatMessages ?? [];
    final optimisticMessage = ChatMessagesEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      senderId: 0,
      senderType: 'driver',
      content: message,
      attachments: [],
      attachmentUrls: [],
      createdAt: DateTime.now(),
      isRead: false,
    );
    final updatedMessages = [...currentMessages, optimisticMessage];

    emit(
      state.copyWith(
        sendMessageRequestStatus: RequestStatus.loading,
        lastSentMessage: message,
        chatMessages: updatedMessages,
      ),
    );

    final result = await _sendMessageUsecase(ticketId, message);
    result.fold(
      (error) {
        // Remove optimistic message on error
        final messagesWithoutOptimistic = currentMessages;
        emit(
          state.copyWith(
            sendMessageRequestStatus: RequestStatus.error,
            sendMessageErrorMessage: error,
            lastSentMessage: message,
            chatMessages: messagesWithoutOptimistic,
          ),
        );
      },
      (isSent) {
        emit(
          state.copyWith(
            sendMessageRequestStatus: RequestStatus.success,
            lastSentMessage: null,
          ),
        );
        // Keep the optimistic message - no refresh needed like WhatsApp
      },
    );
  }

  Future<void> markAllInboxes(InboxStatus status) async {
    emit(state.copyWith(markAllInboxesRequestStatus: RequestStatus.loading));
    final result = await _markAllInboxesUsecase(status);
    result.fold(
      (error) => emit(
        state.copyWith(
          markAllInboxesRequestStatus: RequestStatus.error,
          markAllInboxesErrorMessage: error,
        ),
      ),
      (isMarked) => emit(
        state.copyWith(markAllInboxesRequestStatus: RequestStatus.success),
      ),
    );
  }

  Future<void> markInboxAsRead(int ticketId) async {
    emit(state.copyWith(markInboxAsReadRequestStatus: RequestStatus.loading));
    final result = await _markInboxAsReadUsecase(ticketId);
    result.fold(
      (error) => emit(
        state.copyWith(
          markInboxAsReadRequestStatus: RequestStatus.error,
          markInboxAsReadErrorMessage: error,
        ),
      ),
      (isMarked) => emit(
        state.copyWith(markInboxAsReadRequestStatus: RequestStatus.success),
      ),
    );
  }

  void resetInitiateChatStatus() {
    emit(state.copyWith(initiateChatRequestStatus: RequestStatus.initial));
  }

  void resetMarkAllInboxesStatus() {
    emit(state.copyWith(markAllInboxesRequestStatus: RequestStatus.initial));
  }

  void resetMarkInboxAsReadStatus() {
    emit(state.copyWith(markInboxAsReadRequestStatus: RequestStatus.initial));
  }
}
