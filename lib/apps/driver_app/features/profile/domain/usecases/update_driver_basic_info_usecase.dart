import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class UpdateDriverBasicInfoUsecase {
  final ProfileRepository _profileRepository;
  UpdateDriverBasicInfoUsecase({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;
  Future<Either<String, DriverBasicInfoEntity>> call(
    DriverBasicInfoEntity model,
  ) async {
    return await _profileRepository.updateDriverBasicInfo(model);
  }
}
