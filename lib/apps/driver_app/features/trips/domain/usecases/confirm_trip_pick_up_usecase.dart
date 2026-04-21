import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/booking_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/repositories/driver_trip_repository.dart';

class ConfirmTripPickUpUsecase {
  final DriverTripRepository _driverTripRepository;

  ConfirmTripPickUpUsecase(this._driverTripRepository);

  Future<Either<String, BookingEntity>> call(int tripId, String otp) async {
    return await _driverTripRepository.confirmPickup(tripId, otp);
  }
}
