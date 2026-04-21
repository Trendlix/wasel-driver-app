class DriverDocumentsEntity {
  final List<DocumentItemEntity> documents;

  DriverDocumentsEntity({required this.documents});
}

class DocumentItemEntity {
  final int id;
  final String name;
  final String fileName;
  final String type;
  final String status;
  final DateTime? expiryDate;
  final int daysRemaining;
  final String link;
  final DateTime uploadedAt;

  DocumentItemEntity({
    required this.id,
    required this.name,
    required this.fileName,
    required this.type,
    required this.status,
    this.expiryDate,
    required this.daysRemaining,
    required this.link,
    required this.uploadedAt,
  });
}
