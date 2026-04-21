import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/register_driver_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/truck_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/verify_otp_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/services/driver_auth_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/repositories/driver_auth_repository.dart';

class DriverAuthRepositoryImp implements DriverAuthRepository {
  final DriverAuthApiService authService;

  DriverAuthRepositoryImp(this.authService);

  @override
  Future<Either<String, String>> checkPhoneIsRegistered(
    String phone,
    AuthMode authMode,
  ) {
    return authService.checkPhoneIsRegistered(phone, authMode);
  }

  @override
  Future<Either<String, UserVerificationTypeModel>> verifyOtp(
    Map<String, dynamic> body,
  ) {
    return authService.verifyOtp(body);
  }

  @override
  Future<Either<String, String>> registerDriver(
    RegisterDriverModel registerDriverModel,
    String tempToken,
  ) {
    return authService.registerDriver(registerDriverModel, tempToken);
  }

  @override
  Future<Either<String, List<TruckTypeModel>>> getTruckTypes(String tempToken) {
    return authService.getTruckTypes(tempToken);
  }

  @override
  Future<Either<String, UserVerificationTypeModel>> getDriverAccountStatus() {
    return authService.getDriverAccountStatus();
  }
}
