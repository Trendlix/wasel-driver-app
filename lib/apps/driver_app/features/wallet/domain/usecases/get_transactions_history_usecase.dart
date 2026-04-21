import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/transaction_history_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/repositories/wallet_repository.dart';

class GetTransactionsHistoryUsecase {
  final WalletRepository _walletRepository;

  GetTransactionsHistoryUsecase(this._walletRepository);

  Future<Either<String, List<TransactionHistoryEntity>>> call() async {
    return await _walletRepository.getTransactionsHistory();
  }
}
