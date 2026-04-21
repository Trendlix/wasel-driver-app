// domain/entities/legal_response_entity.dart

class TermsConditionEntity {
  final String message;
  final int statusCode;
  final LegalDataEntity data;

  TermsConditionEntity({
    required this.message,
    required this.statusCode,
    required this.data,
  });
}

class LegalDataEntity {
  final LegalSectionEntity terms;
  final LegalSectionEntity privacyPolicy;

  LegalDataEntity({required this.terms, required this.privacyPolicy});
}

class LegalSectionEntity {
  final ContentPairEntity introduction;
  final List<PointEntity> points;

  LegalSectionEntity({required this.introduction, required this.points});
}

class ContentPairEntity {
  final String title;
  final String description;

  ContentPairEntity({required this.title, required this.description});
}

class PointEntity {
  final String title;
  final String description;
  final int sortOrder;

  PointEntity({
    required this.title,
    required this.description,
    required this.sortOrder,
  });
}
