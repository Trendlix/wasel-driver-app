import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ticket_status_entity.dart';

class TicketStatusModel extends TicketStatusEntity {
  const TicketStatusModel({
    required super.ticketStatus,
    required super.ticketPriority,
    required super.subject,
    required super.category,
    required super.conversationId,
  });

  // Factory to create a Model from the "data" map in your JSON
  factory TicketStatusModel.fromJson(Map<String, dynamic> json) {
    return TicketStatusModel(
      ticketStatus: json['ticket_status'] ?? '',
      ticketPriority: json['ticket_priority'] ?? '',
      subject: json['subject'] ?? '',
      category: json['category'] ?? '',
      conversationId: json['conversation_id'] ?? 0,
    );
  }

  // Optional: Convert back to JSON if you need to send it to an API
  Map<String, dynamic> toJson() {
    return {
      'ticket_status': ticketStatus,
      'ticket_priority': ticketPriority,
      'subject': subject,
      'category': category,
      'conversation_id': conversationId,
    };
  }
}
