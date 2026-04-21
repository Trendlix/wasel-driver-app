import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/driver_legel_info_entity.dart';

class DriverLegalInfoModel extends DriverLegalInfoEntity {
  DriverLegalInfoModel({
    required super.licenseNumber,
    required super.licenseExpiry,
    required super.nationalIdNumber,
    required super.nationalIdExpiry,
  });

  factory DriverLegalInfoModel.fromJson(Map<String, dynamic> json) {
    return DriverLegalInfoModel(
      licenseNumber: json['license_number'],
      licenseExpiry: DateTime.parse(json['license_expiry']),
      nationalIdNumber: json['national_id_number'],
      nationalIdExpiry: DateTime.parse(json['national_id_expiry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'license_number': licenseNumber,
      'license_expiry': licenseExpiry?.toIso8601String(),
      'national_id_number': nationalIdNumber,
      'national_id_expiry': nationalIdExpiry?.toIso8601String(),
    };
  }
}
