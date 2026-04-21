class UserPreferencesEntity {
  final int? id;
  final String? language;
  final bool? bookingUpdates;
  final bool? priceOffers;
  final bool? promotionsAndDeals;
  final bool? tripReminders;
  final bool? paymentConfirmations;
  final int? userId;

  const UserPreferencesEntity({
    this.id,
    this.language,
    this.bookingUpdates,
    this.priceOffers,
    this.promotionsAndDeals,
    this.tripReminders,
    this.paymentConfirmations,
    this.userId,
  });
}
