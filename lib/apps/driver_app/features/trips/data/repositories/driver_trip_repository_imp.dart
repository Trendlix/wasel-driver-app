import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/models/booking_model.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/models/trip_model.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/models/trip_summary_model.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/services/driver_trip_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/repositories/driver_trip_repository.dart';

class DriverTripRepositoryImp implements DriverTripRepository {
  final DriverTripApiService _driverTripApiService;

  DriverTripRepositoryImp(this._driverTripApiService);

  @override
  Future<Either<String, List<TripModel>>> getDriverTrips() async {
    return await _driverTripApiService.getDriverTrips();
  }

  @override
  Future<Either<String, TripModel>> getDriverTripById(int id) async {
    return await _driverTripApiService.getDriverTripById(id);
  }

  @override
  Future<Either<String, bool>> cancelDriverTrip(int id) async {
    return await _driverTripApiService.cancelDriverTrip(id);
  }

  @override
  Future<Either<String, BookingModel>> confirmPickup(
    int tripId,
    String otp,
  ) async {
    return await _driverTripApiService.confirmPickup(tripId, otp);
  }

  @override
  Future<Either<String, TripSummaryModel>> confirmDelivery(
    int tripId,
    String otp,
    String image,
  ) async {
    return await _driverTripApiService.confirmDelivery(tripId, otp, image);
  }
}
