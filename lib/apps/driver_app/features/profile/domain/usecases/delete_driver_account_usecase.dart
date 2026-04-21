import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class DeleteDriverAccountUsecase {
  final ProfileRepository _profileRepository;

  DeleteDriverAccountUsecase(ProfileRepository profileRepository)
    : _profileRepository = profileRepository;

  Future<Either<String, bool>> call() async {
    return await _profileRepository.deleteDriverAccount();
  }
}
