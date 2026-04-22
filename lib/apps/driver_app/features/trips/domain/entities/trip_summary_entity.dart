class TripSummaryEntity {
  final int? tripId;
  final String? tripNumber;
  final double? totalKm;
  final double? earning;
  final int? rating;

  TripSummaryEntity({
    required this.tripId,
    required this.tripNumber,
    required this.totalKm,
    required this.earning,
    required this.rating,
  });
}
