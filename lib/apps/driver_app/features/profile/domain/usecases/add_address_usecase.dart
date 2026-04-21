import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/address_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class AddAddressUsecase {
  final ProfileRepository _profileRepository;
  AddAddressUsecase(this._profileRepository);
  Future<Either<String, bool>> call(AddressEntity addressModel) =>
      _profileRepository.addAddress(addressModel);
}
