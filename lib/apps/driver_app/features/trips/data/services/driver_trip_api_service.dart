import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/models/booking_model.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/models/trip_model.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/models/trip_summary_model.dart';

abstract class DriverTripApiService {
  Future<Either<String, List<TripModel>>> getDriverTrips();
  Future<Either<String, TripModel>> getDriverTripById(int id);
  Future<Either<String, bool>> cancelDriverTrip(int id);
  Future<Either<String, BookingModel>> confirmPickup(int tripId, String otp);
  Future<Either<String, TripSummaryModel>> confirmDelivery(
    int tripId,
    String otp,
    String image,
  );
}
