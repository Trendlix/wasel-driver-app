import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/entities/truck_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/repositories/driver_auth_repository.dart';

class GetDriverTrucksUsecase {
  final DriverAuthRepository authRepository;

  GetDriverTrucksUsecase(this.authRepository);

  Future<Either<String, List<TruckTypeEntity>>> call(String tempToken) {
    return authRepository.getTruckTypes(tempToken);
  }
}
