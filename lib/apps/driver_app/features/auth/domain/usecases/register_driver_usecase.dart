import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/register_driver_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/repositories/driver_auth_repository.dart';

class RegisterDriverUsecase {
  final DriverAuthRepository authRepository;

  RegisterDriverUsecase(this.authRepository);

  Future<Either<String, String>> call(
    RegisterDriverModel registerDriverModel,
    String tempToken,
  ) {
    return authRepository.registerDriver(registerDriverModel, tempToken);
  }
}
