import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.id,
    required super.driverId,
    required super.balance,
    required super.currency,
    required super.createdAt,
    required super.updatedAt,
    required super.earened,
    required super.pedingAmount,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      driverId: json['driver_id'],
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      earened: (json['total_earned'] as num?)?.toDouble(),
      pedingAmount: (json['pending_amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'balance': balance,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
