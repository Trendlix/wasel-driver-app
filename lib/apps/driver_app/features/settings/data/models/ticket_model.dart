import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket_entity.dart';

class TicketModel extends TicketEntity {
  const TicketModel({
    required super.subject,
    required super.category,
    required super.priority,
    required super.description,
    required super.files,
  });
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      subject: json['subject'],
      category: json['category'],
      priority: json['priority'],
      description: json['description'],
      files: json['files'],
    );
  }

  TicketEntity toEntity() {
    return TicketEntity(
      subject: subject,
      category: category,
      priority: priority,
      description: description,
      files: files,
    );
  }

  TicketModel copyWith({
    String? subject,
    String? category,
    String? priority,
    String? description,
    List<File>? files,
  }) {
    return TicketModel(
      subject: subject ?? this.subject,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      files: files ?? this.files,
    );
  }

  // from entity
  factory TicketModel.fromEntity(TicketEntity entity) {
    return TicketModel(
      subject: entity.subject,
      category: entity.category,
      priority: entity.priority,
      description: entity.description,
      files: entity.files,
    );
  }

  // Update your toJson to handle the files conversion
  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'category_id': category,
      'priority': priority,
      'description': description,
      'attachments': files,
    };
  }
}
