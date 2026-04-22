import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/usecases/get_driver_wallet_info_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/usecases/get_transactions_history_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/presentation/cubit/wallet_states.dart';

class WalletCubit extends Cubit<WalletStates> {
  final GetTransactionsHistoryUsecase _getTransactionsHistoryUsecase;
  final GetDriverWalletInfoUsecase _getDriverWalletInfoUsecase;

  WalletCubit(
    this._getTransactionsHistoryUsecase,
    this._getDriverWalletInfoUsecase,
  ) : super(const WalletStates());

  Future<void> getTransactionsHistory() async {
    emit(state.copyWith(walletTransactionsStatus: RequestStatus.loading));
    final result = await _getTransactionsHistoryUsecase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          walletTransactionsStatus: RequestStatus.error,
          walletTransactionsErrorMessage: failure,
        ),
      ),
      (transactions) => emit(
        state.copyWith(
          walletTransactionsStatus: RequestStatus.success,
          transactions: transactions,
        ),
      ),
    );
  }

  Future<void> getWalletInfo() async {
    emit(state.copyWith(walletInfoStatus: RequestStatus.loading));
    final result = await _getDriverWalletInfoUsecase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          walletInfoStatus: RequestStatus.error,
          walletInfoErrorMessage: failure,
        ),
      ),
      (walletInfo) => emit(
        state.copyWith(
          walletInfoStatus: RequestStatus.success,
          walletInfo: walletInfo,
        ),
      ),
    );
  }
}
