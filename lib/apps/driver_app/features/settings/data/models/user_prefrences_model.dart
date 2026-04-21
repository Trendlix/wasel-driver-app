import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/user_preferences_entity.dart';

class UserPreferencesModel extends UserPreferencesEntity {
  const UserPreferencesModel({
    super.id,
    super.language,
    super.bookingUpdates,
    super.priceOffers,
    super.promotionsAndDeals,
    super.tripReminders,
    super.paymentConfirmations,
    super.userId,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    // We target the 'data' object from your JSON response
    final data = json['data'] ?? json;

    return UserPreferencesModel(
      id: data['id'] ?? 0,
      language: data['language'] ?? 'en',
      bookingUpdates: data['booking_updates'] ?? false,
      priceOffers: data['price_offers'] ?? false,
      promotionsAndDeals: data['promotions_and_deals'] ?? false,
      tripReminders: data['trip_reminders'] ?? false,
      paymentConfirmations: data['payment_confirmations'] ?? false,
      userId: data['user_id'] ?? 0,
    );
  }

  UserPreferencesModel copyWith({
    int? id,
    String? language,
    bool? bookingUpdates,
    bool? priceOffers,
    bool? promotionsAndDeals,
    bool? tripReminders,
    bool? paymentConfirmations,
    int? userId,
  }) {
    return UserPreferencesModel(
      id: id ?? this.id,
      language: language ?? this.language,
      bookingUpdates: bookingUpdates ?? this.bookingUpdates,
      priceOffers: priceOffers ?? this.priceOffers,
      promotionsAndDeals: promotionsAndDeals ?? this.promotionsAndDeals,
      tripReminders: tripReminders ?? this.tripReminders,
      paymentConfirmations: paymentConfirmations ?? this.paymentConfirmations,
      userId: userId ?? this.userId,
    );
  }

  // toEntity
  UserPreferencesEntity toEntity() {
    return UserPreferencesEntity(
      id: id,
      language: language,
      bookingUpdates: bookingUpdates,
      priceOffers: priceOffers,
      promotionsAndDeals: promotionsAndDeals,
      tripReminders: tripReminders,
      paymentConfirmations: paymentConfirmations,
      userId: userId,
    );
  }

  // create fromEntity
  factory UserPreferencesModel.fromEntity(UserPreferencesEntity entity) {
    return UserPreferencesModel(
      id: entity.id,
      language: entity.language,
      bookingUpdates: entity.bookingUpdates,
      priceOffers: entity.priceOffers,
      promotionsAndDeals: entity.promotionsAndDeals,
      tripReminders: entity.tripReminders,
      paymentConfirmations: entity.paymentConfirmations,
      userId: entity.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'booking_updates': bookingUpdates,
      'price_offers': priceOffers,
      'promotions_and_deals': promotionsAndDeals,
      'trip_reminders': tripReminders,
      'payment_confirmations': paymentConfirmations,
    };
  }
}
