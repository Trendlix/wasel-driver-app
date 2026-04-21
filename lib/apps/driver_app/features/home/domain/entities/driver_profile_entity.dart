class DriverProfileEntity {
  final int? driverId;
  final bool? isOnline;
  final String? driverName;
  final String? profileImg;
  final int? activeTripId;

  DriverProfileEntity({
    required this.driverId,
    required this.isOnline,
    required this.driverName,
    required this.profileImg,
    this.activeTripId,
  });
}
