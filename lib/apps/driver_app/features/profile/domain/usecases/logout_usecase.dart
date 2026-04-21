import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class LogoutUsecase {
  final ProfileRepository _repository;

  LogoutUsecase(this._repository);

  Future<Either<String, bool>> call() => _repository.logout();
}
