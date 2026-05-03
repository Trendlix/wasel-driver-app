class TripEntity {
  final int id;
  final String tripNumber;
  final double price;
  final String currency;
  final String status;
  final String? subStatus;
  final UserEntity user;
  final String pickup;
  final List<String> dropOff;
  final String typeOfGoods;
  final String? specialNotes;
  final dynamic distanceBetween;
  final int estimatedTime;
  final dynamic rating;
  final DateTime? date;
  final dynamic weight;
  final dynamic totalWeight;
  final dynamic platformFees;
  final dynamic amountGoesToDriver;
  final String? pickedUpAt;
  final String? completedAt;
  final String? startedAt;

  TripEntity({
    required this.id,
    required this.tripNumber,
    required this.price,
    required this.currency,
    required this.status,
    this.subStatus,
    required this.user,
    required this.pickup,
    required this.dropOff,
    required this.typeOfGoods,
    this.specialNotes,
    this.distanceBetween,
    required this.estimatedTime,
    this.rating,
    this.date,
    this.weight,
    this.totalWeight,
    this.platformFees,
    this.amountGoesToDriver,
    this.pickedUpAt,
    this.completedAt,
    this.startedAt,
  });
}

class UserEntity {
  final String? name;
  final String? avatar;
  final int? rating;
  final String? phone;

  UserEntity({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.phone,
  });
}
