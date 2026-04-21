import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/address_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class GetUserAddressesUsecase {
  final ProfileRepository profileRepository;
  GetUserAddressesUsecase(this.profileRepository);

  Future<Either<String, List<AddressEntity>>> call() {
    return profileRepository.getAdrdesses();
  }
}
