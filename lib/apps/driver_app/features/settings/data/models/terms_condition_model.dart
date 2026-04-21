// data/models/legal_response_model.dart

import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/terms_condition_entity.dart';

class TermsConditionModel extends TermsConditionEntity {
  TermsConditionModel({
    required super.message,
    required super.statusCode,
    required LegalDataModel super.data,
  });

  factory TermsConditionModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionModel(
      message: json['message'],
      statusCode: json['statusCode'],
      data: LegalDataModel.fromJson(json['data']),
    );
  }
}

class LegalDataModel extends LegalDataEntity {
  LegalDataModel({
    required LegalSectionModel super.terms,
    required LegalSectionModel super.privacyPolicy,
  });

  factory LegalDataModel.fromJson(Map<String, dynamic> json) {
    return LegalDataModel(
      terms: LegalSectionModel.fromJson(json['terms']),
      privacyPolicy: LegalSectionModel.fromJson(json['privacy_and_policy']),
    );
  }
}

class LegalSectionModel extends LegalSectionEntity {
  LegalSectionModel({
    required ContentPairModel super.introduction,
    required List<PointModel> super.points,
  });

  factory LegalSectionModel.fromJson(Map<String, dynamic> json) {
    return LegalSectionModel(
      introduction: ContentPairModel.fromJson(json['introduction']),
      points: (json['points'] as List)
          .map((i) => PointModel.fromJson(i))
          .toList(),
    );
  }
}

class ContentPairModel extends ContentPairEntity {
  ContentPairModel({required super.title, required super.description});

  factory ContentPairModel.fromJson(Map<String, dynamic> json) {
    return ContentPairModel(
      title: json['title'],
      description: json['description'],
    );
  }
}

class PointModel extends PointEntity {
  PointModel({
    required super.title,
    required super.description,
    required super.sortOrder,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      title: json['title'],
      description: json['description'],
      sortOrder: json['sort_order'],
    );
  }
}
