import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.name,
    required super.rating,
    required super.phoneNumber,
    required super.totalEarning,
    required super.totalTrips,
    required super.language,
    required super.unreadMessages,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      // Standardizing numeric values
      rating: (json['rating'] as num).toDouble(),
      phoneNumber: json['phone_number'],
      totalEarning: (json['total_earning'] as num).toDouble(),
      totalTrips: (json['total_trips'] as num).toInt(),
      language: json['language'],
      unreadMessages: (json['unread_messages'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'phone_number': phoneNumber,
      'total_earning': totalEarning,
      'total_trips': totalTrips,
      'language': language,
      'unread_messages': unreadMessages,
    };
  }
}

class DriverBasicInfoModel extends DriverBasicInfoEntity {
  DriverBasicInfoModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.isOnline,
  });

  factory DriverBasicInfoModel.fromJson(Map<String, dynamic> json) {
    return DriverBasicInfoModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      isOnline: json['onine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (phone != null) 'phone': phone,
      if (isOnline != null) 'online': isOnline,
    };
  }

  // from entity
  factory DriverBasicInfoModel.fromEntity(DriverBasicInfoEntity entity) {
    return DriverBasicInfoModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      isOnline: entity.isOnline,
    );
  }
}
