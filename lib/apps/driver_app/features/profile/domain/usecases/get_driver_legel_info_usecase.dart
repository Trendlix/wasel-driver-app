import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/driver_legel_info_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class GetDriverLegelInfoUsecase {
  final ProfileRepository _profileRepository;

  GetDriverLegelInfoUsecase(this._profileRepository);

  Future<Either<String, DriverLegalInfoEntity>> call() async {
    return await _profileRepository.getDriverLegalInfo();
  }
}
