import 'package:equatable/equatable.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/verify_otp_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/entities/truck_entity.dart';

class DriverAuthState extends Equatable {
  // check phone registered states
  final RequestStatus? checkPhoneIsRegisteredRequestStatus;
  final String? checkPhoneIsRegisteredErrorMessage;
  final String? phone;

  // verify otp states
  final RequestStatus? otpRequestStatus;
  final String? otpErrorMessage;
  final UserVerificationTypeModel? userVerificationTypeModel;

  // register driver states
  final RequestStatus? registerDriverRequestStatus;
  final String? registerDriverErrorMessage;
  final String? reference;

  // get driver trucks states
  final RequestStatus? getDriverTrucksRequestStatus;
  final String? getDriverTrucksErrorMessage;
  final List<TruckTypeEntity>? truckTypes;

  // get driver account status states
  final RequestStatus? getDriverAccountStatusRequestStatus;
  final String? getDriverAccountStatusErrorMessage;
  final UserVerificationTypeModel? driverAccountStatus;

  const DriverAuthState({
    // check phone registered states
    this.checkPhoneIsRegisteredRequestStatus,
    this.checkPhoneIsRegisteredErrorMessage,
    this.phone,
    // verify otp states
    this.otpRequestStatus,
    this.otpErrorMessage,
    this.userVerificationTypeModel,
    // register driver states
    this.registerDriverRequestStatus,
    this.registerDriverErrorMessage,
    this.reference,
    // get driver trucks states
    this.getDriverTrucksRequestStatus,
    this.getDriverTrucksErrorMessage,
    this.truckTypes,
    // get driver account status states
    this.getDriverAccountStatusRequestStatus,
    this.getDriverAccountStatusErrorMessage,
    this.driverAccountStatus,
  });

  DriverAuthState copyWith({
    // check phone registered states
    RequestStatus? checkPhoneIsRegisteredRequestStatus,
    String? checkPhoneIsRegisteredErrorMessage,
    String? phone,
    // verify otp states
    RequestStatus? otpRequestStatus,
    String? otpErrorMessage,
    UserVerificationTypeModel? userVerificationTypeModel,
    // register driver states
    RequestStatus? registerDriverRequestStatus,
    String? registerDriverErrorMessage,
    String? reference,
    // get driver trucks states
    RequestStatus? getDriverTrucksRequestStatus,
    String? getDriverTrucksErrorMessage,
    List<TruckTypeEntity>? truckTypes,
    // get driver account status states
    RequestStatus? getDriverAccountStatusRequestStatus,
    String? getDriverAccountStatusErrorMessage,
    UserVerificationTypeModel? driverAccountStatus,
  }) {
    return DriverAuthState(
      // check phone registered states
      checkPhoneIsRegisteredRequestStatus:
          checkPhoneIsRegisteredRequestStatus ??
          this.checkPhoneIsRegisteredRequestStatus,
      checkPhoneIsRegisteredErrorMessage:
          checkPhoneIsRegisteredErrorMessage ??
          this.checkPhoneIsRegisteredErrorMessage,
      phone: phone ?? this.phone,
      // verify otp states
      otpRequestStatus: otpRequestStatus ?? this.otpRequestStatus,
      otpErrorMessage: otpErrorMessage ?? this.otpErrorMessage,
      userVerificationTypeModel:
          userVerificationTypeModel ?? this.userVerificationTypeModel,
      // register driver states
      registerDriverRequestStatus:
          registerDriverRequestStatus ?? this.registerDriverRequestStatus,
      registerDriverErrorMessage:
          registerDriverErrorMessage ?? this.registerDriverErrorMessage,
      reference: reference ?? this.reference,
      // get driver trucks states
      getDriverTrucksRequestStatus:
          getDriverTrucksRequestStatus ?? this.getDriverTrucksRequestStatus,
      getDriverTrucksErrorMessage:
          getDriverTrucksErrorMessage ?? this.getDriverTrucksErrorMessage,
      truckTypes: truckTypes ?? this.truckTypes,
      // get driver account status states
      getDriverAccountStatusRequestStatus:
          getDriverAccountStatusRequestStatus ??
          this.getDriverAccountStatusRequestStatus,
      getDriverAccountStatusErrorMessage:
          getDriverAccountStatusErrorMessage ??
          this.getDriverAccountStatusErrorMessage,
      driverAccountStatus: driverAccountStatus ?? this.driverAccountStatus,
    );
  }

  @override
  List<Object?> get props => [
    // check phone registered states
    checkPhoneIsRegisteredRequestStatus,
    checkPhoneIsRegisteredErrorMessage,
    phone,
    // verify otp states
    otpRequestStatus,
    otpErrorMessage,
    userVerificationTypeModel,
    // register driver states
    registerDriverRequestStatus,
    registerDriverErrorMessage,
    reference,
    // get driver trucks states
    getDriverTrucksRequestStatus,
    getDriverTrucksErrorMessage,
    truckTypes,
    // get driver account status states
    getDriverAccountStatusRequestStatus,
    getDriverAccountStatusErrorMessage,
    driverAccountStatus,
  ];
}
