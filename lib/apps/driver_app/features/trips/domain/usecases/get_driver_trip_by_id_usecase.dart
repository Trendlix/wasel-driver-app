import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/repositories/driver_trip_repository.dart';

class GetDriverTripByIdUsecase {
  final DriverTripRepository _driverTripRepository;

  GetDriverTripByIdUsecase(this._driverTripRepository);

  Future<Either<String, TripEntity>> call(int id) async {
    return await _driverTripRepository.getDriverTripById(id);
  }
}
