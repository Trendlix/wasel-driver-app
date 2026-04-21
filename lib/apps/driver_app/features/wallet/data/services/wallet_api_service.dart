import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/models/transaction_history_model.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/models/wallet_model.dart';

abstract class WalletApiService {
  Future<Either<String, List<TransactionHistoryModel>>>
  getTransactionsHistory();

  Future<Either<String, WalletModel>> getWallet();
}
