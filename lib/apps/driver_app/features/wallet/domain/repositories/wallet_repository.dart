import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/transaction_history_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<Either<String, List<TransactionHistoryEntity>>>
  getTransactionsHistory();

  Future<Either<String, WalletEntity>> getWallet();
}
