import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? voucherCode;
  final String channel;
  final String type;
  final String status;
  final DateTime? readAt;
  final DateTime createdAt;
  final int driverId;
  final int? ticketId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.description,
    this.voucherCode,
    required this.channel,
    required this.type,
    required this.status,
    this.readAt,
    required this.createdAt,
    required this.driverId,
    this.ticketId,
  });

  @override
  List<Object?> get props => [id, status, readAt]; // Compare based on ID and state changes
}

class NotificationMetaEntity extends Equatable {
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  const NotificationMetaEntity({
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [total, currentPage, totalPages, hasNextPage];
}
