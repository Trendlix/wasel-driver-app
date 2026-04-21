import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/models/wallet_model.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/services/wallet_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/transaction_history_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletApiService _walletApiService;

  WalletRepositoryImpl(this._walletApiService);

  @override
  Future<Either<String, List<TransactionHistoryEntity>>>
  getTransactionsHistory() {
    return _walletApiService.getTransactionsHistory();
  }

  @override
  Future<Either<String, WalletModel>> getWallet() {
    return _walletApiService.getWallet();
  }
}
