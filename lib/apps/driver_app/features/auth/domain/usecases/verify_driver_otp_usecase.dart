import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/verify_otp_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/repositories/driver_auth_repository.dart';

class VerifyDriverOtpUsecase {
  final DriverAuthRepository _repository;
  VerifyDriverOtpUsecase(this._repository);

  Future<Either<String, UserVerificationTypeModel>> call(
    Map<String, dynamic> body,
  ) {
    return _repository.verifyOtp(body);
  }
}
