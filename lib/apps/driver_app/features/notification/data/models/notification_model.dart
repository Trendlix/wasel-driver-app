import 'package:wasel_driver/apps/driver_app/features/notification/doamin/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.description,
    super.voucherCode,
    required super.channel,
    required super.type,
    required super.status,
    super.readAt,
    required super.createdAt,
    required super.driverId,
    super.ticketId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      voucherCode: json['voucher_code'],
      channel: json['channel'],
      type: json['type'],
      status: json['status'],
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      driverId: json['driver_id'],
      ticketId: json['ticket_id'],
    );
  }
}

class NotificationMetaModel extends NotificationMetaEntity {
  const NotificationMetaModel({
    required super.total,
    required super.currentPage,
    required super.totalPages,
    required super.hasNextPage,
  });

  factory NotificationMetaModel.fromJson(Map<String, dynamic> json) {
    return NotificationMetaModel(
      total: json['total'],
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      hasNextPage: json['has_next_page'],
    );
  }
}
