import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/driver_summary_entity.dart';

class DriverSummaryModel extends DriverSummaryEntity {
  DriverSummaryModel({
    required super.earnings,
    required super.trips,
    required super.timeInMinutes,
    required super.distanceInKm,
  });

  factory DriverSummaryModel.fromJson(Map<String, dynamic> json) {
    return DriverSummaryModel(
      // Using .toDouble() and .toInt() for strict type safety
      earnings: (json['earnings'] as num).toDouble(),
      trips: (json['trips'] as num).toInt(),
      timeInMinutes: (json['time_in_minutes'] as num).toInt(),
      distanceInKm: (json['distance_in_km'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'earnings': earnings,
      'trips': trips,
      'time_in_minutes': timeInMinutes,
      'distance_in_km': distanceInKm,
    };
  }
}
