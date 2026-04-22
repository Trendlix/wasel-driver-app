class TransactionHistoryEntity {
  final List<TransactionEntity> transactions;
  // final MetaEntity meta;

  TransactionHistoryEntity({required this.transactions});
}

class TransactionEntity {
  final int? id;
  final int? walletId;
  final int? amount;
  final String? type;
  final String? reference;
  final String? description;
  final DateTime? createdAt;

  TransactionEntity({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    this.reference,
    required this.description,
    required this.createdAt,
  });
}

class MetaEntity {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  MetaEntity({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}
