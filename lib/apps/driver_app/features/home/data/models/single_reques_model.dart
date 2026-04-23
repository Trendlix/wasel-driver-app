import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/single_request_entity.dart';

class SingleRequestModel extends SingleRequestEntity {
  SingleRequestModel({
    required super.id,
    required super.price,
    required super.currency,
    required super.user,
    required super.pickup,
    required super.dropOff,
    required super.typeOfGoods,
    required super.weight,
    required super.createdAt,
    required super.requestNumber,
    super.customerNote,
    required super.estimatedTimeInMinutes,
    required super.waselSuggestedPrice,
    required super.label,
    required super.distanceInkm,
    required super.platformFees,
    required super.amountGoesToDriver,
    required super.percentage,
  });

  factory SingleRequestModel.fromJson(Map<String, dynamic> json) {
    return SingleRequestModel(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'],
      user: UserModel.fromJson(json['user']),
      pickup: json['pickup'],
      dropOff: List<String>.from(json['drop_off']),
      typeOfGoods: json['type_of_goods'],
      weight: (json['weight'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      requestNumber: json['request_number'],
      customerNote: json['customer_note'],
      estimatedTimeInMinutes: json['estimated_time_in_minutes'],
      waselSuggestedPrice: json['wasel_suggested_price'] != null
          ? (json['wasel_suggested_price'] as num).toDouble()
          : null,
      label: json['label'],
      distanceInkm: (json['distance_in_km'] as num).toDouble(),
      platformFees: (json['platform_fees'] as num).toDouble(),
      amountGoesToDriver: (json['amount_goes_to_driver'] as num).toDouble(),
      percentage: json['amount_goes_to_driver_percentage'],
    );
  }
}

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.avatar,
    required super.rating,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      avatar: json['avatar'],
      rating: json['rating'],
    );
  }
}
