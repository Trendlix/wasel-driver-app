import 'package:equatable/equatable.dart';

class ChatMessagesEntity extends Equatable {
  final int id;
  final int senderId;
  final String senderType;
  final String content;
  final List<String> attachments;
  final List<String> attachmentUrls;
  final DateTime createdAt;
  final bool? isRead;

  const ChatMessagesEntity({
    required this.id,
    required this.senderId,
    required this.senderType,
    required this.content,
    required this.attachments,
    required this.attachmentUrls,
    required this.createdAt,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [
    id,
    senderId,
    senderType,
    content,
    attachments,
    attachmentUrls,
    createdAt,
    isRead,
  ];
}
