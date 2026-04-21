class DriverLegalInfoEntity {
  final String? licenseNumber;
  final DateTime? licenseExpiry;
  final String? nationalIdNumber;
  final DateTime? nationalIdExpiry;

  DriverLegalInfoEntity({
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.nationalIdNumber,
    required this.nationalIdExpiry,
  });
}
