import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/driver_document_entity.dart';

class DriverDocumentsModel extends DriverDocumentsEntity {
  DriverDocumentsModel({required super.documents});

  factory DriverDocumentsModel.fromJson(Map<String, dynamic> json) {
    return DriverDocumentsModel(
      documents: json['data'] == null
          ? []
          : (json['data'] as List)
                .map((i) => DocumentItemModel.fromJson(i))
                .toList(),
    );
  }
}

class DocumentItemModel extends DocumentItemEntity {
  DocumentItemModel({
    required super.id,
    required super.name,
    required super.fileName,
    required super.type,
    required super.status,
    super.expiryDate,
    required super.daysRemaining,
    required super.link,
    required super.uploadedAt,
  });

  factory DocumentItemModel.fromJson(Map<String, dynamic> json) {
    return DocumentItemModel(
      id: json['id'],
      name: json['name'],
      fileName: json['file_name'],
      type: json['type'],
      status: json['status'],
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      daysRemaining: (json['days_remaining'] as num).toInt(),
      link: json['link'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'file_name': fileName,
      'type': type,
      'status': status,
      'expiry_date': expiryDate?.toIso8601String(),
      'days_remaining': daysRemaining,
      'link': link,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }
}
