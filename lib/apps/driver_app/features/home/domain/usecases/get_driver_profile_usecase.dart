import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/driver_profile_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/repositories/home_repository.dart';

class GetDriverProfileUsecase {
  final HomeRepository? _homeRepository;

  GetDriverProfileUsecase({required HomeRepository? homeRepository})
    : _homeRepository = homeRepository;

  Future<Either<String, DriverProfileModel>> call() async {
    return await _homeRepository!.getDriverProfile();
  }
}
