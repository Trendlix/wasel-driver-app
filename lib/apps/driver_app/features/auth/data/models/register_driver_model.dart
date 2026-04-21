import 'dart:io';

import 'package:dio/dio.dart';

class RegisterDriverModel {
  final String fullName;
  final DateTime nationalIdExpiry;
  final DateTime licenseExpiry;
  final num truckTypeId;
  final String truckModel;
  final num year;
  final String licensePlate;
  final bool acceptsAds;
  final File nationalIdFront;
  final bool hasCompany;
  final File nationalIdBack;
  final File licenseFront;
  final File licenseBack;
  final File? criminalRecord;
  final File? vehicleOwnershipDoc;
  final File profileImage;
  final File truckImage;

  RegisterDriverModel({
    required this.fullName,
    required this.nationalIdExpiry,
    required this.licenseExpiry,
    required this.truckTypeId,
    required this.truckModel,
    required this.year,
    required this.licensePlate,
    required this.acceptsAds,
    required this.nationalIdFront,
    required this.hasCompany,
    required this.nationalIdBack,
    required this.licenseFront,
    required this.licenseBack,
    this.criminalRecord,
    this.vehicleOwnershipDoc,
    required this.profileImage,
    required this.truckImage,
  });

  FormData toFormData() {
    final map = <String, dynamic>{
      'full_name': fullName,
      'national_id_expiry': nationalIdExpiry.toUtc().toIso8601String(),
      'license_expiry': licenseExpiry.toUtc().toIso8601String(),
      'truck_type_id': truckTypeId,
      'truck_model': truckModel,
      'year': year,
      'license_plate': licensePlate,
      'accepts_ads': acceptsAds,
      'has_company': hasCompany,
      'national_id_front': MultipartFile.fromFileSync(nationalIdFront.path),
      'national_id_back': MultipartFile.fromFileSync(nationalIdBack.path),
      'license_front': MultipartFile.fromFileSync(licenseFront.path),
      'license_back': MultipartFile.fromFileSync(licenseBack.path),
      'profile_image': MultipartFile.fromFileSync(profileImage.path),
      'truck_image': MultipartFile.fromFileSync(truckImage.path),
    };

    // Optional fields — only added if provided
    if (criminalRecord != null) {
      map['criminal_record'] = MultipartFile.fromFileSync(criminalRecord!.path);
    }
    if (vehicleOwnershipDoc != null) {
      map['vehicle_ownership_doc'] = MultipartFile.fromFileSync(
        vehicleOwnershipDoc!.path,
      );
    }

    return FormData.fromMap(map);
  }
}
