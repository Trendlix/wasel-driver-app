import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/repositories/driver_trip_repository.dart';

class CancelDriverTripUsecase {
  final DriverTripRepository _driverTripRepository;

  CancelDriverTripUsecase(this._driverTripRepository);

  Future<Either<String, bool>> call(int id) async {
    return await _driverTripRepository.cancelDriverTrip(id);
  }
}
