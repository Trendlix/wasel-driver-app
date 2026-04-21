import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/driver_profile_entity.dart';

class DriverProfileModel extends DriverProfileEntity {
  DriverProfileModel({
    required super.driverId,
    required super.isOnline,
    required super.driverName,
    required super.profileImg,
    super.activeTripId,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      driverId: json['driver_id'],
      isOnline: json['online'] ?? false,
      driverName: json['driver_name'],
      profileImg: json['profile_img'],
      activeTripId: json['active_trip_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'online': isOnline,
      'driver_name': driverName,
      'profile_img': profileImg,
      'active_trip_id': activeTripId,
    };
  }
}
