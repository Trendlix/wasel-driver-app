import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/repositories/driver_auth_repository.dart';

class CheckDriverPhoneRegisteredUsecase {
  final DriverAuthRepository authRepository;
  CheckDriverPhoneRegisteredUsecase(this.authRepository);

  Future<Either<String, String>> call(String phone, AuthMode authMode) {
    return authRepository.checkPhoneIsRegistered(phone, authMode);
  }
}
