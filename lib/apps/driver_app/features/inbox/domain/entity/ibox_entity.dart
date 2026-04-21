import 'package:equatable/equatable.dart';

abstract class InboxEntity {
  final int id;
  final String title;
  final String description;
  final String type;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  InboxEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });
}

class OfferEntity {
  final int id;
  final String title;
  final String description;
  final String type;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final VoucherEntity? voucher;

  OfferEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.voucher,
  });
}

class VoucherEntity {
  final int id;
  final String code;
  final String description;
  final DateTime validFrom;
  final DateTime validTo;
  final String discountType;
  final String discountValue;

  VoucherEntity({
    required this.id,
    required this.code,
    required this.description,
    required this.validFrom,
    required this.validTo,
    required this.discountType,
    required this.discountValue,
  });
}

class SupportEntity extends InboxEntity {
  final String status;
  final TicketEntity? ticket;

  SupportEntity({
    required super.id,
    required super.title,
    required super.description,
    required super.type, // We can default this to 'support'
    required super.isRead,
    super.readAt,
    required super.createdAt,
    required this.status,
    this.ticket,
  });
}

class TicketEntity {
  final int id;
  final String subject;
  final String status;
  final String description;
  final DateTime createdAt;

  TicketEntity({
    required this.id,
    required this.subject,
    required this.status,
    required this.description,
    required this.createdAt,
  });
}
