class ProfileEntity {
  final int id;
  final String name;
  final double rating;
  final String phoneNumber;
  final double totalEarning;
  final int totalTrips;
  final String language;
  final int unreadMessages;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.rating,
    required this.phoneNumber,
    required this.totalEarning,
    required this.totalTrips,
    required this.language,
    required this.unreadMessages,
  });
}

class DriverBasicInfoEntity {
  final int id;
  final String name;
  final String email;
  final String phone;

  DriverBasicInfoEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
}
