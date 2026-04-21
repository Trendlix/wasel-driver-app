import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class GetProfileUsercase {
  final ProfileRepository _profileRepository;

  GetProfileUsercase(this._profileRepository);

  Future<Either<String, ProfileEntity>> call() {
    return _profileRepository.getProfile();
  }
}

class GetDriverBasicInfoUsercase {
  final ProfileRepository _profileRepository;

  GetDriverBasicInfoUsercase(this._profileRepository);

  Future<Either<String, DriverBasicInfoEntity>> call() {
    return _profileRepository.getDriverBasicInfo();
  }
}
