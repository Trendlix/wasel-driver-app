import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_summary_entity.dart';

class TripSummaryModel extends TripSummaryEntity {
  TripSummaryModel({
    required super.tripId,
    required super.tripNumber,
    required super.totalKm,
    required super.earning,
    required super.rating,
  });

  factory TripSummaryModel.fromJson(Map<String, dynamic> json) {
    return TripSummaryModel(
      tripId: json['trip_id'],
      tripNumber: json['trip_number'],
      // Ensuring type safety for numeric values
      totalKm: (json['total_km'] as num).toDouble(),
      earning: (json['earning'] as num).toDouble(),
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'trip_number': tripNumber,
      'total_km': totalKm,
      'earning': earning,
      'rating': rating,
    };
  }
}
