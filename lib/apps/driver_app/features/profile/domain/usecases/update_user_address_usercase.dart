import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/address_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class UpdateUserAddressUsercase {
  final ProfileRepository _profileRepository;

  UpdateUserAddressUsercase(this._profileRepository);

  Future<Either<String, bool>> call(AddressEntity model) {
    return _profileRepository.updateAddress(model);
  }
}
