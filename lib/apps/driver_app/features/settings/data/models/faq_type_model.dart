import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/faq_type_entity.dart';

class FaqModel extends FaqEntity {
  const FaqModel({
    required super.id,
    required super.question,
    required super.answer,
    required super.targetType,
    required super.createdAt,
    required super.faqType,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      targetType: json['target_type'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      faqType: json['type'] != null
          ? FaqTypeModel.fromJson(json['type'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'target_type': targetType,
      'created_at': createdAt?.toIso8601String(),
      'type': (faqType as FaqTypeModel).toJson(),
    };
  }
}

class FaqTypeModel extends FaqTypeEntity {
  const FaqTypeModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory FaqTypeModel.fromJson(Map<String, dynamic> json) {
    return FaqTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
