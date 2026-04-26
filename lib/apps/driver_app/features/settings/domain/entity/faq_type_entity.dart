import 'package:equatable/equatable.dart';

class FaqEntity extends Equatable {
  final int? id;
  final String? question;
  final String? answer;
  final String? targetType;
  final DateTime? createdAt;
  final FaqTypeEntity? faqType;

  const FaqEntity({
    required this.id,
    required this.question,
    required this.answer,
    required this.targetType,
    required this.createdAt,
    required this.faqType,
  });

  @override
  List<Object?> get props => [id, question, answer, faqType];
}

class FaqTypeEntity extends Equatable {
  final int? id;
  final String? name;
  final String? description;

  const FaqTypeEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}
