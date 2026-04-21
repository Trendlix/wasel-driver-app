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

  // send message states
  final RequestStatus? sendMessageRequestStatus;
  final String? sendMessageErrorMessage;
  final String? lastSentMessage;

  const InboxStates({
    this.getInboxRequestStatus,
    this.offers,
    this.updates,
    this.supports,
    this.getInboxErrorMessage,
    // initate chat states
    this.initiateChatRequestStatus,
    this.initiateChatErrorMessage,
    this.ticketStatusEntity,
    this.ticketId,
    // chat messages states
    this.getChatMessagesRequestStatus,
    this.chatMessages,
    this.getChatMessagesErrorMessage,
    // send message states
    this.sendMessageRequestStatus,
    this.sendMessageErrorMessage,
    this.lastSentMessage,
  });

  InboxStates copyWith({
    RequestStatus? getInboxRequestStatus,
    List<OfferEntity>? offers,
    List<UpdateEntity>? updates,
    List<SupportEntity>? supports,
    String? getInboxErrorMessage,
    // initate chat states
    RequestStatus? initiateChatRequestStatus,
    String? initiateChatErrorMessage,
    TicketStatusEntity? ticketStatusEntity,
    int? ticketId,
    // chat messages states
    RequestStatus? getChatMessagesRequestStatus,
    List<ChatMessagesEntity>? chatMessages,
    String? getChatMessagesErrorMessage,
    // send message states
    RequestStatus? sendMessageRequestStatus,
    String? sendMessageErrorMessage,
    String? lastSentMessage,
  }) {
    return InboxStates(
      getInboxRequestStatus:
          getInboxRequestStatus ?? this.getInboxRequestStatus,
      offers: offers ?? this.offers,
      updates: updates ?? this.updates,
      supports: supports ?? this.supports,
      getInboxErrorMessage: getInboxErrorMessage ?? this.getInboxErrorMessage,
      // initate chat states
      initiateChatRequestStatus:
          initiateChatRequestStatus ?? this.initiateChatRequestStatus,
      initiateChatErrorMessage:
          initiateChatErrorMessage ?? this.initiateChatErrorMessage,
      ticketStatusEntity: ticketStatusEntity ?? this.ticketStatusEntity,
      ticketId: ticketId ?? this.ticketId,
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
    );
  }

  @override
  List<Object?> get props => [
    getInboxRequestStatus,
    offers,
    updates,
    supports,
    getInboxErrorMessage,
    // initate chat states
    initiateChatRequestStatus,
    initiateChatErrorMessage,
    ticketStatusEntity,
    ticketId,
    // chat messages states
    getChatMessagesRequestStatus,
    chatMessages,
    getChatMessagesErrorMessage,
    // send message states
    sendMessageRequestStatus,
    sendMessageErrorMessage,
    lastSentMessage,
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
    ]);

    addIfNotNull('initiateChat', initiateChatRequestStatus, [
      initiateChatRequestStatus,
      initiateChatErrorMessage,
      ticketStatusEntity,
      ticketId,
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

    return activeStates.isEmpty
        ? 'InboxStates(Idle)'
        : 'InboxStates(\n    ${activeStates.join(',\n    ')}\n  )';
  }
}
