import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class UpdateUserInfoUsecase {
  final ProfileRepository profileRepository;
  UpdateUserInfoUsecase(this.profileRepository);

  Future<Either<String, ProfileEntity>> call(ProfileEntity profileModel) {
    return profileRepository.updaetUserProfile(profileModel);
  }
}
