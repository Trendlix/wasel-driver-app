import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class RegistrationState {
  final int currentStep;
  final int totalSteps;
  final List<bool> completedSteps;

  // temp token
  final String tempToken;

  // Step 1 - Personal Info
  final String fullName;
  final String? driverType; // 'individual' | 'company'

  // Step 2 - Documents
  final String? nationalIdFront;
  final String? nationalIdBack;
  final String? nationalIdExpiry;
  final String? driverLicenseFront;
  final String? driverLicenseBack;
  final String? licenseExpiry;
  final String? vehicleOwnershipDoc;
  final String? criminalRecord;

  // Step 3 - Vehicle Info
  final String truckType;
  final String truckTypeId;
  final String weightCapacity;
  final String truckModel;
  final String year;
  final String plateNumber;
  final bool agreeToAds;

  // Step 4 - Photos
  final String? profilePhoto;
  final String? truckPhoto;

  // general error var
  final bool showErrors;

  const RegistrationState({
    this.currentStep = 0,
    this.totalSteps = 5,
    this.completedSteps = const [false, false, false, false, false],
    this.fullName = '',
    this.driverType,
    this.nationalIdFront,
    this.nationalIdBack,
    this.nationalIdExpiry,
    this.driverLicenseFront,
    this.driverLicenseBack,
    this.licenseExpiry,
    this.vehicleOwnershipDoc,
    this.criminalRecord,
    this.truckType = '',
    this.truckTypeId = '',
    this.weightCapacity = '',
    this.truckModel = '',
    this.year = '',
    this.plateNumber = '',
    this.agreeToAds = false,
    this.profilePhoto,
    this.truckPhoto,
    this.tempToken = '',
    this.showErrors = false,
  });

  RegistrationState copyWith({
    int? currentStep,
    List<bool>? completedSteps,
    String? fullName,
    String? driverType,
    String? nationalIdFront,
    String? nationalIdBack,
    String? nationalIdExpiry,
    String? driverLicenseFront,
    String? driverLicenseBack,
    String? licenseExpiry,
    String? vehicleOwnershipDoc,
    String? criminalRecord,
    String? truckType,
    String? truckTypeId,
    String? weightCapacity,
    String? truckModel,
    String? year,
    String? plateNumber,
    bool? agreeToAds,
    String? profilePhoto,
    String? truckPhoto,
    String? tempToken,
    bool? showErrors,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps,
      completedSteps: completedSteps ?? this.completedSteps,
      fullName: fullName ?? this.fullName,
      driverType: driverType ?? this.driverType,
      nationalIdFront: nationalIdFront ?? this.nationalIdFront,
      nationalIdBack: nationalIdBack ?? this.nationalIdBack,
      nationalIdExpiry: nationalIdExpiry ?? this.nationalIdExpiry,
      driverLicenseFront: driverLicenseFront ?? this.driverLicenseFront,
      driverLicenseBack: driverLicenseBack ?? this.driverLicenseBack,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      vehicleOwnershipDoc: vehicleOwnershipDoc ?? this.vehicleOwnershipDoc,
      criminalRecord: criminalRecord ?? this.criminalRecord,
      truckType: truckType ?? this.truckType,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      weightCapacity: weightCapacity ?? this.weightCapacity,
      truckModel: truckModel ?? this.truckModel,
      year: year ?? this.year,
      plateNumber: plateNumber ?? this.plateNumber,
      agreeToAds: agreeToAds ?? this.agreeToAds,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      truckPhoto: truckPhoto ?? this.truckPhoto,
      tempToken: tempToken ?? this.tempToken,
      showErrors: showErrors ?? this.showErrors,
    );
  }
}
