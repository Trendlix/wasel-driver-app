import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.tripId,
    required super.bookingNumber,
    required super.nextDestination,
    required super.goods,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      tripId: json['trip_id'],
      bookingNumber: json['booking_number'],
      nextDestination: json['next_destination'],
      goods: json['goods'],
    );
  }

  // Optional: Helper to convert back to JSON if needed for POST requests
  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'booking_number': bookingNumber,
      'next_destination': nextDestination,
      'goods': goods,
    };
  }
}
