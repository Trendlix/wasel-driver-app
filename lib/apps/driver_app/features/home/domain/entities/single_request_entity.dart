class SingleRequestEntity {
  final int? id;
  final double? price;
  final String? currency;
  final UserEntity? user;
  final String? pickup;
  final List<String>? dropOff;
  final String? typeOfGoods;
  final double? weight;
  final DateTime? createdAt;
  final String? requestNumber;
  final String? customerNote;
  final int? estimatedTimeInMinutes;
  final double? waselSuggestedPrice;
  final String? label;

  SingleRequestEntity({
    required this.id,
    required this.price,
    required this.currency,
    required this.user,
    required this.pickup,
    required this.dropOff,
    required this.typeOfGoods,
    required this.weight,
    required this.createdAt,
    required this.requestNumber,
    this.customerNote,
    required this.estimatedTimeInMinutes,
    required this.waselSuggestedPrice,
    required this.label,
  });
}

class UserEntity {
  final String? name;
  final String? avatar;
  final int? rating;

  UserEntity({required this.name, required this.avatar, required this.rating});
}
