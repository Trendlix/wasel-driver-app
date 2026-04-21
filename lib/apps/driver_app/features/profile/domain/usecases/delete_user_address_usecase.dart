import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class DeleteUserAddressUsecase {
  final ProfileRepository _profileRepository;

  DeleteUserAddressUsecase(this._profileRepository);

  Future<Either<String, bool>> call(String id) {
    return _profileRepository.deleteAddress(id);
  }
}
