import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/repositories/wallet_repository.dart';

class GetDriverWalletInfoUsecase {
  final WalletRepository _walletRepository;

  GetDriverWalletInfoUsecase(this._walletRepository);

  Future<Either<String, WalletEntity>> call() {
    return _walletRepository.getWallet();
  }
}
