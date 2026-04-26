import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/request_categories_entity.dart';

class RequestCategoriesModel extends RequestCategoriesEntity {
  RequestCategoriesModel({
    required super.all,
    required super.urgent,
    required super.highPay,
    required super.nearby,
  });

  factory RequestCategoriesModel.fromJson(Map<String, dynamic> json) {
    return RequestCategoriesModel(
      all: json['all'] == null
          ? []
          : (json['all'] as List).map((i) => RequestModel.fromJson(i)).toList(),
      urgent: json['urgent'] == null
          ? []
          : (json['urgent'] as List)
                .map((i) => RequestModel.fromJson(i))
                .toList(),
      highPay: json['highPay'] == null
          ? []
          : (json['highPay'] as List)
                .map((i) => RequestModel.fromJson(i))
                .toList(),
      nearby: json['nearby'] == null
          ? []
          : (json['nearby'] as List)
                .map((i) => RequestModel.fromJson(i))
                .toList(),
    );
  }
}

class RequestModel extends RequestEntity {
  RequestModel({
    required super.id,
    required super.price,
    required super.currency,
    required super.user,
    required super.pickup,
    required super.dropOff,
    required super.typeOfGoods,
    required super.distanceBetween,
    required super.estimatedTime,
    required super.label,
    required super.dateOfRequest,
    required super.platformFees,
    required super.amountGoesToDriver,
    required super.amountGoesToDriverPercentage,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'],
      user: UserModel.fromJson(json['user']),
      pickup: json['pickup'],
      dropOff: List<String>.from(json['drop_off']),
      typeOfGoods: json['type_of_goods'],
      distanceBetween: (json['distance_between'] as num).toDouble(),
      estimatedTime: json['estimated_time_in_minutes'],
      label: json['label'],
      dateOfRequest: json['date_of_request'],
      platformFees: (json['platform_fees'] as num).toDouble(),
      amountGoesToDriver: (json['amount_goes_to_driver'] as num).toDouble(),
      amountGoesToDriverPercentage:
          (json['amount_goes_to_driver_percentage'] as num).toDouble(),
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
