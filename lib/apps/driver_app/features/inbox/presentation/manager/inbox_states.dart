import 'package:equatable/equatable.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/inbox_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/chat_messages_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ibox_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ticket_status_entity.dart';

class InboxStates extends Equatable {
  // inbox states
  final RequestStatus? getInboxRequestStatus;
  final List<OfferEntity>? offers;
  final List<UpdateEntity>? updates;
  final List<SupportEntity>? supports;
  final String? getInboxErrorMessage;
  final int offersPage;
  final int updatesPage;
  final int supportsPage;
  final bool offersHasMore;
  final bool updatesHasMore;
  final bool supportsHasMore;
  final bool isLoadingMore;

  int get inboxNotReadLength {
    int count = 0;
    if (offers != null) {
      count += offers!.where((element) => !element.isRead!).length;
    }
    if (updates != null) {
      count += updates!.where((element) => !element.isRead!).length;
    }
    if (supports != null) {
      count += supports!.where((element) => !element.isRead!).length;
    }
    return count;
  }

  // chat messages states
  final RequestStatus? getChatMessagesRequestStatus;
  final List<ChatMessagesEntity>? chatMessages;
  final String? getChatMessagesErrorMessage;

  // chat states
  final RequestStatus? initiateChatRequestStatus;
  final String? initiateChatErrorMessage;
  final TicketStatusEntity? ticketStatusEntity;
  final int? ticketId;
  final String? initiateChatActionId;

  // send message states
  final RequestStatus? sendMessageRequestStatus;
  final String? sendMessageErrorMessage;
  final String? lastSentMessage;

  // mark all inboxes
  final RequestStatus? markAllInboxesRequestStatus;
  final String? markAllInboxesErrorMessage;

  // mark inbox as read
  final RequestStatus? markInboxAsReadRequestStatus;
  final String? markInboxAsReadErrorMessage;

  const InboxStates({
    this.getInboxRequestStatus,
    this.offers,
    this.updates,
    this.supports,
    this.getInboxErrorMessage,
    this.offersPage = 1,
    this.updatesPage = 1,
    this.supportsPage = 1,
    this.offersHasMore = true,
    this.updatesHasMore = true,
    this.supportsHasMore = true,
    this.isLoadingMore = false,
    // initate chat states
    this.initiateChatRequestStatus,
    this.initiateChatErrorMessage,
    this.ticketStatusEntity,
    this.ticketId,
    this.initiateChatActionId,
    // chat messages states
    this.getChatMessagesRequestStatus,
    this.chatMessages,
    this.getChatMessagesErrorMessage,
    // send message states
    this.sendMessageRequestStatus,
    this.sendMessageErrorMessage,
    this.lastSentMessage,
    // mark all inboxes states
    this.markAllInboxesRequestStatus,
    this.markAllInboxesErrorMessage,
    // mark inbox as read states
    this.markInboxAsReadRequestStatus,
    this.markInboxAsReadErrorMessage,
  });

  InboxStates copyWith({
    RequestStatus? getInboxRequestStatus,
    List<OfferEntity>? offers,
    List<UpdateEntity>? updates,
    List<SupportEntity>? supports,
    String? getInboxErrorMessage,
    int? offersPage,
    int? updatesPage,
    int? supportsPage,
    bool? offersHasMore,
    bool? updatesHasMore,
    bool? supportsHasMore,
    bool? isLoadingMore,
    // initate chat states
    RequestStatus? initiateChatRequestStatus,
    String? initiateChatErrorMessage,
    TicketStatusEntity? ticketStatusEntity,
    int? ticketId,
    String? initiateChatActionId,
    // chat messages states
    RequestStatus? getChatMessagesRequestStatus,
    List<ChatMessagesEntity>? chatMessages,
    String? getChatMessagesErrorMessage,
    // send message states
    RequestStatus? sendMessageRequestStatus,
    String? sendMessageErrorMessage,
    String? lastSentMessage,
    // mark all inboxes states
    RequestStatus? markAllInboxesRequestStatus,
    String? markAllInboxesErrorMessage,
    // mark inbox as read states
    RequestStatus? markInboxAsReadRequestStatus,
    String? markInboxAsReadErrorMessage,
  }) {
    return InboxStates(
      getInboxRequestStatus:
          getInboxRequestStatus ?? this.getInboxRequestStatus,
      offers: offers ?? this.offers,
      updates: updates ?? this.updates,
      supports: supports ?? this.supports,
      getInboxErrorMessage: getInboxErrorMessage ?? this.getInboxErrorMessage,
      offersPage: offersPage ?? this.offersPage,
      updatesPage: updatesPage ?? this.updatesPage,
      supportsPage: supportsPage ?? this.supportsPage,
      offersHasMore: offersHasMore ?? this.offersHasMore,
      updatesHasMore: updatesHasMore ?? this.updatesHasMore,
      supportsHasMore: supportsHasMore ?? this.supportsHasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      // initate chat states
      initiateChatRequestStatus:
          initiateChatRequestStatus ?? this.initiateChatRequestStatus,
      initiateChatErrorMessage:
          initiateChatErrorMessage ?? this.initiateChatErrorMessage,
      ticketStatusEntity: ticketStatusEntity ?? this.ticketStatusEntity,
      ticketId: ticketId ?? this.ticketId,
      initiateChatActionId: initiateChatActionId ?? this.initiateChatActionId,
      // chat messages states
      getChatMessagesRequestStatus:
          getChatMessagesRequestStatus ?? this.getChatMessagesRequestStatus,
      chatMessages: chatMessages ?? this.chatMessages,
      getChatMessagesErrorMessage:
          getChatMessagesErrorMessage ?? this.getChatMessagesErrorMessage,
      // send message states
      sendMessageRequestStatus:
          sendMessageRequestStatus ?? this.sendMessageRequestStatus,
      sendMessageErrorMessage:
          sendMessageErrorMessage ?? this.sendMessageErrorMessage,
      lastSentMessage: lastSentMessage ?? this.lastSentMessage,
      // mark all inboxes states
      markAllInboxesRequestStatus:
          markAllInboxesRequestStatus ?? this.markAllInboxesRequestStatus,
      markAllInboxesErrorMessage:
          markAllInboxesErrorMessage ?? this.markAllInboxesErrorMessage,
      // mark inbox as read states
      markInboxAsReadRequestStatus:
          markInboxAsReadRequestStatus ?? this.markInboxAsReadRequestStatus,
      markInboxAsReadErrorMessage:
          markInboxAsReadErrorMessage ?? this.markInboxAsReadErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    getInboxRequestStatus,
    offers,
    updates,
    supports,
    getInboxErrorMessage,
    offersPage,
    updatesPage,
    supportsPage,
    offersHasMore,
    updatesHasMore,
    supportsHasMore,
    isLoadingMore,
    // initate chat states
    initiateChatRequestStatus,
    initiateChatErrorMessage,
    ticketStatusEntity,
    ticketId,
    initiateChatActionId,
    // chat messages states
    getChatMessagesRequestStatus,
    chatMessages,
    getChatMessagesErrorMessage,
    // send message states
    sendMessageRequestStatus,
    sendMessageErrorMessage,
    lastSentMessage,
    // mark all inboxes states
    markAllInboxesRequestStatus,
    markAllInboxesErrorMessage,
    // mark inbox as read states
    markInboxAsReadRequestStatus,
    markInboxAsReadErrorMessage,
  ];

  @override
  String toString() {
    final activeStates = <String>[];

    void addIfNotNull(String name, dynamic status, List<dynamic> details) {
      if (status != null) {
        activeStates.add('$name: $details');
      }
    }

    addIfNotNull('getInbox', getInboxRequestStatus, [
      getInboxRequestStatus,
      getInboxErrorMessage,
      offers,
      updates,
      supports,
      offersPage,
      updatesPage,
      supportsPage,
      offersHasMore,
      updatesHasMore,
      supportsHasMore,
      isLoadingMore,
    ]);

    addIfNotNull('initiateChat', initiateChatRequestStatus, [
      initiateChatRequestStatus,
      initiateChatErrorMessage,
      ticketStatusEntity,
      ticketId,
      initiateChatActionId,
    ]);

    addIfNotNull('getChatMessages', getChatMessagesRequestStatus, [
      getChatMessagesRequestStatus,
      getChatMessagesErrorMessage,
      chatMessages,
    ]);

    addIfNotNull('sendMessage', sendMessageRequestStatus, [
      sendMessageRequestStatus,
      sendMessageErrorMessage,
      lastSentMessage,
    ]);

    addIfNotNull('markAllInboxes', markAllInboxesRequestStatus, [
      markAllInboxesRequestStatus,
      markAllInboxesErrorMessage,
    ]);

    addIfNotNull('markInboxAsRead', markInboxAsReadRequestStatus, [
      markInboxAsReadRequestStatus,
      markInboxAsReadErrorMessage,
    ]);

    return activeStates.isEmpty
        ? 'InboxStates(Idle)'
        : 'InboxStates(\n    ${activeStates.join(',\n    ')}\n  )';
  }
}
