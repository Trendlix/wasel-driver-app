import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/chat_messages_entity.dart';

class ChatMessagesModel extends ChatMessagesEntity {
  const ChatMessagesModel({
    required super.id,
    required super.senderId,
    required super.senderType,
    required super.content,
    required super.attachments,
    required super.attachmentUrls,
    required super.createdAt,
    required super.isRead,
  });

  factory ChatMessagesModel.fromJson(Map<String, dynamic> json) {
    return ChatMessagesModel(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      senderType: json['sender_type'] ?? 'user',
      content: json['content'] ?? '',
      // Handling potential nulls or empty lists in JSON
      attachments: List<String>.from(json['attachments'] ?? []),
      attachmentUrls: List<String>.from(json['attachments_urls'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['isRead'],
    );
  }
}
