import 'package:equatable/equatable.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/transaction_history_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/wallet_entity.dart';

class WalletStates extends Equatable {
  final RequestStatus? walletTransactionsStatus;
  final List<TransactionHistoryEntity>? transactions;
  final String? walletTransactionsErrorMessage;
  // wallet info
  final RequestStatus? walletInfoStatus;
  final WalletEntity? walletInfo;
  final String? walletInfoErrorMessage;

  const WalletStates({
    this.walletTransactionsStatus,
    this.transactions,
    this.walletTransactionsErrorMessage,
    this.walletInfoStatus,
    this.walletInfo,
    this.walletInfoErrorMessage,
  });

  WalletStates copyWith({
    RequestStatus? walletTransactionsStatus,
    List<TransactionHistoryEntity>? transactions,
    String? walletTransactionsErrorMessage,
    // wallet info
    RequestStatus? walletInfoStatus,
    WalletEntity? walletInfo,
    String? walletInfoErrorMessage,
  }) {
    return WalletStates(
      walletTransactionsStatus:
          walletTransactionsStatus ?? this.walletTransactionsStatus,
      transactions: transactions ?? this.transactions,
      walletTransactionsErrorMessage:
          walletTransactionsErrorMessage ?? this.walletTransactionsErrorMessage,
      walletInfoStatus: walletInfoStatus ?? this.walletInfoStatus,
      walletInfo: walletInfo ?? this.walletInfo,
      walletInfoErrorMessage:
          walletInfoErrorMessage ?? this.walletInfoErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    walletTransactionsStatus,
    transactions,
    walletTransactionsErrorMessage,
    // wallet info
    walletInfoStatus,
    walletInfo,
    walletInfoErrorMessage,
  ];
}
