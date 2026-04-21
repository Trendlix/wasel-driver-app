import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/booking_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_summary_entity.dart';

abstract class DriverTripRepository {
  Future<Either<String, List<TripEntity>>> getDriverTrips();
  Future<Either<String, TripEntity>> getDriverTripById(int id);
  Future<Either<String, bool>> cancelDriverTrip(int id);
  Future<Either<String, BookingEntity>> confirmPickup(int tripId, String otp);
  Future<Either<String, TripSummaryEntity>> confirmDelivery(
    int tripId,
    String otp,
    String image,
  );
}
