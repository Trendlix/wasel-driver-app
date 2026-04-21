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
  final double? rating;
  final DateTime? date;
  final dynamic weight;
  final dynamic totalWeight;

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
