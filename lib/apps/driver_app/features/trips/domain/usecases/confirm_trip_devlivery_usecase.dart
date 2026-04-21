import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_summary_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/repositories/driver_trip_repository.dart';

class ConfirmTripDevliveryUsecase {
  final DriverTripRepository _driverTripRepository;

  ConfirmTripDevliveryUsecase(this._driverTripRepository);

  Future<Either<String, TripSummaryEntity>> call(
    int tripId,
    String otp,
    String image,
  ) async {
    return await _driverTripRepository.confirmDelivery(tripId, otp, image);
  }
}
