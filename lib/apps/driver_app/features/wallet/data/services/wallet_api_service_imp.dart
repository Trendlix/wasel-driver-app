import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/errors/handel_dio_errors.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/api_endpoints.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/models/transaction_history_model.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/models/wallet_model.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/services/wallet_api_service.dart';

class WalletApiServiceImpl implements WalletApiService {
  final ApiClient _apiClient;

  WalletApiServiceImpl(this._apiClient);

  @override
  Future<Either<String, List<TransactionHistoryModel>>>
  getTransactionsHistory() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.driverWalletTransactionsPath,
        queryParameters: {'sort': 'created_at', 'sort_order': 'desc'},
      );
      if (response.isLeft) {
        return Left(response.left);
      } else {
        final res = response.right as Response;
        if (res.statusCode == 200) {
          return Right([TransactionHistoryModel.fromJson(res.data)]);
        } else {
          return Left(res.data['message']);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, WalletModel>> getWallet() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.driverWalletPath);
      if (response.isLeft) {
        return Left(response.left);
      } else {
        final res = response.right as Response;
        if (res.statusCode == 200) {
          if (res.data['data'] == null) {
            return Left('No wallet found');
          }
          return Right(WalletModel.fromJson(res.data['data']));
        } else {
          return Left(res.data['message']);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
