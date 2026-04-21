import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ibox_entity.dart';

class UpdateEntity extends InboxEntity {
  final String tag;

  UpdateEntity({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.isRead,
    super.readAt,
    required super.createdAt,
    required this.tag,
  });
}

class UpdateModel extends UpdateEntity {
  UpdateModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.isRead,
    super.readAt,
    required super.createdAt,
    required super.tag,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      tag: json['tag'] ?? 'general',
    );
  }
}

class OfferModel extends OfferEntity {
  OfferModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.isRead,
    super.readAt,
    required super.createdAt,
    super.voucher,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      voucher: json['voucher'] != null
          ? VoucherModel.fromJson(json['voucher'])
          : null,
    );
  }
}

class VoucherModel extends VoucherEntity {
  VoucherModel({
    required super.id,
    required super.code,
    required super.description,
    required super.validFrom,
    required super.validTo,
    required super.discountType,
    required super.discountValue,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      validFrom: DateTime.parse(json['valid_from']),
      validTo: DateTime.parse(json['valid_to']),
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
    );
  }
}

class SupportModel extends SupportEntity {
  SupportModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.isRead,
    super.readAt,
    required super.createdAt,
    required super.status,
    super.ticket,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      // The JSON doesn't provide "type", so we hardcode it for internal logic
      type: json['type'] ?? 'support',
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'],
      ticket: json['ticket'] != null
          ? TicketModel.fromJson(json['ticket'])
          : null,
    );
  }
}

class TicketModel extends TicketEntity {
  TicketModel({
    required super.id,
    required super.subject,
    required super.status,
    required super.description,
    required super.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      subject: json['subject'],
      status: json['status'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
