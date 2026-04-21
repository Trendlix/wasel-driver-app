import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/repositories/wallet_repository.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/services/wallet_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/data/services/wallet_api_service_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/usecases/get_driver_wallet_info_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/usecases/get_transactions_history_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/presentation/cubit/wallet_cubit.dart';

class WalletServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;

    // register dio client
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(() => DioClient());
    }

    // register wallet api service
    if (!sl.isRegistered<WalletApiService>()) {
      sl.registerLazySingleton<WalletApiService>(
        () => WalletApiServiceImpl(sl()),
      );
    }
    // register repository
    if (!sl.isRegistered<WalletRepository>()) {
      sl.registerLazySingleton<WalletRepository>(
        () => WalletRepositoryImpl(sl()),
      );
    }
    // register usecases
    if (!sl.isRegistered<GetTransactionsHistoryUsecase>()) {
      sl.registerLazySingleton<GetTransactionsHistoryUsecase>(
        () => GetTransactionsHistoryUsecase(sl()),
      );
    }
    if (!sl.isRegistered<GetDriverWalletInfoUsecase>()) {
      sl.registerLazySingleton<GetDriverWalletInfoUsecase>(
        () => GetDriverWalletInfoUsecase(sl()),
      );
    }
    // register cubit
    if (!sl.isRegistered<WalletCubit>()) {
      sl.registerLazySingleton<WalletCubit>(() => WalletCubit(sl(), sl()));
    }
  }
}
