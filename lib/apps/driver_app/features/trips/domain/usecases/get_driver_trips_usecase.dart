import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/repositories/driver_trip_repository.dart';

class GetDriverTripsUsecase {
  final DriverTripRepository _driverTripRepository;

  GetDriverTripsUsecase(this._driverTripRepository);

  Future<Either<String, List<TripEntity>>> call() async {
    return await _driverTripRepository.getDriverTrips();
  }
}
