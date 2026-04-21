import 'package:equatable/equatable.dart';

class TicketStatusEntity extends Equatable {
  final String ticketStatus;
  final String ticketPriority;
  final String subject;
  final String category;
  final int conversationId;

  const TicketStatusEntity({
    required this.ticketStatus,
    required this.ticketPriority,
    required this.subject,
    required this.category,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [
    ticketStatus,
    ticketPriority,
    subject,
    category,
    conversationId,
  ];
}
