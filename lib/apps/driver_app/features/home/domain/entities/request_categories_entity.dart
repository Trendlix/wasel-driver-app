class RequestCategoriesEntity {
  final List<RequestEntity> all;
  final List<RequestEntity> urgent;
  final List<RequestEntity> highPay;
  final List<RequestEntity> nearby;

  RequestCategoriesEntity({
    required this.all,
    required this.urgent,
    required this.highPay,
    required this.nearby,
  });
}

class RequestEntity {
  final int? id;
  final double? price;
  final String? currency;
  final UserEntity? user;
  final String? pickup;
  final List<String>? dropOff;
  final String? typeOfGoods;
  final double? distanceBetween;
  final int? estimatedTime;
  final String? label;
  final String? dateOfRequest;
  final double? platformFees;
  final double? amountGoesToDriver;
  final double? amountGoesToDriverPercentage;

  RequestEntity({
    required this.id,
    required this.price,
    required this.currency,
    required this.user,
    required this.pickup,
    required this.dropOff,
    required this.typeOfGoods,
    required this.distanceBetween,
    required this.estimatedTime,
    required this.label,
    required this.dateOfRequest,
    required this.platformFees,
    required this.amountGoesToDriver,
    required this.amountGoesToDriverPercentage,
  });
}

class UserEntity {
  final String? name;
  final String? avatar;
  final int? rating;

  UserEntity({required this.name, required this.avatar, required this.rating});
}
