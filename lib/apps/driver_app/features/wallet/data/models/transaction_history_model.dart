import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/transaction_history_entity.dart';

class TransactionHistoryModel extends TransactionHistoryEntity {
  TransactionHistoryModel({required super.transactions});

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryModel(
      transactions: json['data'] == null
          ? []
          : (json['data'] as List)
                .map((i) => TransactionModel.fromJson(i))
                .toList(),
      // meta: MetaModel.fromJson(json['meta']),
    );
  }
}

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.walletId,
    required super.amount,
    required super.type,
    super.reference,
    required super.description,
    required super.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      walletId: json['wallet_id'],
      amount: json['amount'],
      type: json['type'],
      reference: json['reference'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class MetaModel extends MetaEntity {
  MetaModel({
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['total_pages'],
    );
  }
}
