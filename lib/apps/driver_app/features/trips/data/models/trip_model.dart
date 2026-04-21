import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';

class TripModel extends TripEntity {
  TripModel({
    required super.id,
    required super.tripNumber,
    required super.price,
    required super.currency,
    required super.status,
    super.subStatus,
    required super.user,
    required super.pickup,
    required super.dropOff,
    required super.typeOfGoods,
    super.specialNotes,
    super.distanceBetween,
    required super.estimatedTime,
    super.rating,
    super.date,
    super.weight,
    super.totalWeight,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      tripNumber: json['trip_number'],
      // Using .toDouble() to handle both int and double from API
      price: (json['price'] as num).toDouble(),
      currency: json['currency'],
      status: json['status'],
      subStatus: json['sub_status'],
      user: UserModel.fromJson(json['user']),
      pickup: json['pickup'],
      dropOff: List<String>.from(json['drop_off']),
      typeOfGoods: json['type_of_goods'],
      specialNotes: json['special_notes'],
      distanceBetween: json['distance_between'],
      estimatedTime: json['estimated_time_in_minutes'],
      rating: json['rating'],
      weight: json['weight'],
      totalWeight: json['total_weight'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.avatar,
    required super.rating,
    required super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      avatar: json['avatar'],
      rating: json['rating'],
      phone: json['phone_number'],
    );
  }
}
