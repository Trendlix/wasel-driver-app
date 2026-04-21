import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/register_driver_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/truck_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/verify_otp_model.dart';

abstract class DriverAuthApiService {
  Future<Either<String, String>> checkPhoneIsRegistered(
    String phone,
    AuthMode authMode,
  );

  Future<Either<String, UserVerificationTypeModel>> verifyOtp(
    Map<String, dynamic> body,
  );

  Future<Either<String, String>> registerDriver(
    RegisterDriverModel registerDriverModel,
    String tempToken,
  );

  Future<Either<String, List<TruckTypeModel>>> getTruckTypes(String tempToken);

  Future<Either<String, UserVerificationTypeModel>> getDriverAccountStatus();
  Future<Either<String, (String acc, String ref)>> askToGetRefreshToken(
    String refreshToken,
  );
}
