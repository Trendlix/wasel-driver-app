class WalletEntity {
  final int id;
  final int driverId;
  final double balance;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletEntity({
    required this.id,
    required this.driverId,
    required this.balance,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });
}
