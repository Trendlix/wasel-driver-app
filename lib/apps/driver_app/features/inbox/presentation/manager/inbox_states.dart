import 'package:equatable/equatable.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/inbox_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/chat_messages_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ibox_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ticket_status_entity.dart';

class InboxStates extends Equatable {
  // inbox states
  final RequestStatus? getInboxRequestStatus;
  final RequestStatus? getMoreInboxRequestStatus;
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

  int get inboxNotReadLength {
    int count = 0;
    if (offers != null) {
      count += offers!.where((element) => !element.isRead).length;
    }
    if (updates != null) {
      count += updates!.where((element) => !element.isRead).length;
    }
    if (supports != null) {
      count += supports!.where((element) => !element.isRead).length;
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
  final int? loadingInboxId;
  final ChatAction? chatAction;

  // send message states
  final RequestStatus? sendMessageRequestStatus;
  final String? sendMessageErrorMessage;
  final String? lastSentMessage;

  // mark inbox item states
  final RequestStatus? markInboxItemRequestStatus;
  final String? markInboxItemErrorMessage;

  const InboxStates({
    this.getInboxRequestStatus,
    this.getMoreInboxRequestStatus,
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
    // initate chat states
    this.initiateChatRequestStatus,
    this.initiateChatErrorMessage,
    this.ticketStatusEntity,
    this.ticketId,
    this.loadingInboxId,
    this.chatAction,
    // chat messages states
    this.getChatMessagesRequestStatus,
    this.chatMessages,
    this.getChatMessagesErrorMessage,
    // send message states
    this.sendMessageRequestStatus,
    this.sendMessageErrorMessage,
    this.lastSentMessage,
    // mark inbox item states
    this.markInboxItemRequestStatus,
    this.markInboxItemErrorMessage,
  });

  InboxStates copyWith({
    RequestStatus? getInboxRequestStatus,
    RequestStatus? getMoreInboxRequestStatus,
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
    // initate chat states
    RequestStatus? initiateChatRequestStatus,
    String? initiateChatErrorMessage,
    TicketStatusEntity? ticketStatusEntity,
    int? ticketId,
    int? loadingInboxId,
    ChatAction? chatAction,
    // chat messages states
    RequestStatus? getChatMessagesRequestStatus,
    List<ChatMessagesEntity>? chatMessages,
    String? getChatMessagesErrorMessage,
    // send message states
    RequestStatus? sendMessageRequestStatus,
    String? sendMessageErrorMessage,
    String? lastSentMessage,
    // mark inbox item states
    RequestStatus? markInboxItemRequestStatus,
    String? markInboxItemErrorMessage,
  }) {
    return InboxStates(
      getInboxRequestStatus:
          getInboxRequestStatus ?? this.getInboxRequestStatus,
      getMoreInboxRequestStatus:
          getMoreInboxRequestStatus ?? this.getMoreInboxRequestStatus,
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
      initiateChatRequestStatus:
          initiateChatRequestStatus ?? this.initiateChatRequestStatus,
      initiateChatErrorMessage:
          initiateChatErrorMessage ?? this.initiateChatErrorMessage,
      ticketStatusEntity: ticketStatusEntity ?? this.ticketStatusEntity,
      ticketId: ticketId == -1 ? null : (ticketId ?? this.ticketId),
      loadingInboxId:
          loadingInboxId == -1 ? null : (loadingInboxId ?? this.loadingInboxId),
      chatAction: chatAction ?? this.chatAction,
      getChatMessagesRequestStatus:
          getChatMessagesRequestStatus ?? this.getChatMessagesRequestStatus,
      chatMessages: chatMessages ?? this.chatMessages,
      getChatMessagesErrorMessage:
          getChatMessagesErrorMessage ?? this.getChatMessagesErrorMessage,
      sendMessageRequestStatus:
          sendMessageRequestStatus ?? this.sendMessageRequestStatus,
      sendMessageErrorMessage:
          sendMessageErrorMessage ?? this.sendMessageErrorMessage,
      lastSentMessage: lastSentMessage ?? this.lastSentMessage,
      markInboxItemRequestStatus:
          markInboxItemRequestStatus ?? this.markInboxItemRequestStatus,
      markInboxItemErrorMessage:
          markInboxItemErrorMessage ?? this.markInboxItemErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    getInboxRequestStatus,
    getMoreInboxRequestStatus,
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
    // initate chat states
    initiateChatRequestStatus,
    initiateChatErrorMessage,
    ticketStatusEntity,
    ticketId,
    loadingInboxId,
    chatAction,
    // chat messages states
    getChatMessagesRequestStatus,
    chatMessages,
    getChatMessagesErrorMessage,
    // send message states
    sendMessageRequestStatus,
    sendMessageErrorMessage,
    lastSentMessage,
    // mark inbox item states
    markInboxItemRequestStatus,
    markInboxItemErrorMessage,
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
      getMoreInboxRequestStatus,
      getInboxErrorMessage,
      offers,
      updates,
      supports,
      'offersPage: $offersPage',
      'updatesPage: $updatesPage',
      'supportsPage: $supportsPage',
      'offersHasMore: $offersHasMore',
      'updatesHasMore: $updatesHasMore',
      'supportsHasMore: $supportsHasMore',
    ]);

    addIfNotNull('initiateChat', initiateChatRequestStatus, [
      initiateChatRequestStatus,
      initiateChatErrorMessage,
      ticketStatusEntity,
      ticketId,
      loadingInboxId,
      chatAction,
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

    addIfNotNull('markInboxItem', markInboxItemRequestStatus, [
      markInboxItemRequestStatus,
      markInboxItemErrorMessage,
    ]);

    return activeStates.isEmpty
        ? 'InboxStates(Idle)'
        : 'InboxStates(\n    ${activeStates.join(',\n    ')}\n  )';
  }
}
