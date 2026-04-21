import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/verify_otp_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/repositories/driver_auth_repository.dart';

class GetDriverAccountStatusUsecase {
  final DriverAuthRepository authRepository;

  GetDriverAccountStatusUsecase(this.authRepository);

  Future<Either<String, UserVerificationTypeModel>> call() {
    return authRepository.getDriverAccountStatus();
  }
}
