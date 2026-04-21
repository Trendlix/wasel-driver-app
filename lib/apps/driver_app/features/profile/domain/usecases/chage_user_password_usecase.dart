import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class ChageUserPasswordUsecase {
  final ProfileRepository profileRepository;
  ChageUserPasswordUsecase({required this.profileRepository});

  Future<Either<String, bool>> call(String oldPassword, String newPassword) {
    return profileRepository.changeUserPassword(oldPassword, newPassword);
  }
}
