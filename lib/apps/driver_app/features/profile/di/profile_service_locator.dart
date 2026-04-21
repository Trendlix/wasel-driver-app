import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/repository/profile_repository_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/services/profile_api_service_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/services/profile_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/add_address_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/chage_user_password_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/delete_driver_account_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/delete_user_address_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/get_driver_documents_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/get_driver_legel_info_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/get_profile_usercase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/get_user_addresses_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/renew_driver_document_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/update_driver_basic_info_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/update_user_address_usercase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/update_user_info_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/upload_driver_document_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';

class ProfileServiceLocator extends ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;
    // register api client
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(() => DioClient());
    }

    // register profile service
    if (!sl.isRegistered<ProfileApiService>()) {
      sl.registerLazySingleton<ProfileApiService>(
        () => ProfileApiServiceImp(apiClient: sl()),
      );
    }

    // register profile repo
    if (!sl.isRegistered<ProfileRepository>()) {
      sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImp(profileService: sl()),
      );
    }

    // register logout usecase
    if (!sl.isRegistered<LogoutUsecase>()) {
      sl.registerLazySingleton<LogoutUsecase>(() => LogoutUsecase(sl()));
    }

    // register get user profile usecase
    if (!sl.isRegistered<GetProfileUsercase>()) {
      sl.registerLazySingleton<GetProfileUsercase>(
        () => GetProfileUsercase(sl()),
      );
    }

    // register update user info usecase
    if (!sl.isRegistered<UpdateUserInfoUsecase>()) {
      sl.registerLazySingleton<UpdateUserInfoUsecase>(
        () => UpdateUserInfoUsecase(sl()),
      );
    }

    // register get user addresses usecase
    if (!sl.isRegistered<GetUserAddressesUsecase>()) {
      sl.registerLazySingleton<GetUserAddressesUsecase>(
        () => GetUserAddressesUsecase(sl()),
      );
    }

    // register add address usecase
    if (!sl.isRegistered<AddAddressUsecase>()) {
      sl.registerLazySingleton<AddAddressUsecase>(
        () => AddAddressUsecase(sl()),
      );
    }

    // register delete address usecase
    if (!sl.isRegistered<DeleteUserAddressUsecase>()) {
      sl.registerLazySingleton<DeleteUserAddressUsecase>(
        () => DeleteUserAddressUsecase(sl()),
      );
    }

    // register update address usecase
    if (!sl.isRegistered<UpdateUserAddressUsercase>()) {
      sl.registerLazySingleton<UpdateUserAddressUsercase>(
        () => UpdateUserAddressUsercase(sl()),
      );
    }

    // register change user password usecase
    if (!sl.isRegistered<ChageUserPasswordUsecase>()) {
      sl.registerLazySingleton<ChageUserPasswordUsecase>(
        () => ChageUserPasswordUsecase(profileRepository: sl()),
      );
    }

    // register get driver basic info usecase
    if (!sl.isRegistered<GetDriverBasicInfoUsercase>()) {
      sl.registerLazySingleton<GetDriverBasicInfoUsercase>(
        () => GetDriverBasicInfoUsercase(sl()),
      );
    }

    // register get driver legal info usecase
    if (!sl.isRegistered<GetDriverLegelInfoUsecase>()) {
      sl.registerLazySingleton<GetDriverLegelInfoUsecase>(
        () => GetDriverLegelInfoUsecase(sl()),
      );
    }

    // register update driver basic info usecase
    if (!sl.isRegistered<UpdateDriverBasicInfoUsecase>()) {
      sl.registerLazySingleton<UpdateDriverBasicInfoUsecase>(
        () => UpdateDriverBasicInfoUsecase(profileRepository: sl()),
      );
    }

    // register get driver documents usecase
    if (!sl.isRegistered<GetDriverDocumentsUsecase>()) {
      sl.registerLazySingleton<GetDriverDocumentsUsecase>(
        () => GetDriverDocumentsUsecase(sl()),
      );
    }

    // register upload driver documents usecase
    if (!sl.isRegistered<UploadDriverDocumentUsecase>()) {
      sl.registerLazySingleton<UploadDriverDocumentUsecase>(
        () => UploadDriverDocumentUsecase(sl()),
      );
    }

    // register renew driver documents usecase
    if (!sl.isRegistered<RenewDriverDocumentUsecase>()) {
      sl.registerLazySingleton<RenewDriverDocumentUsecase>(
        () => RenewDriverDocumentUsecase(sl()),
      );
    }

    // register delete driver account usecase
    if (!sl.isRegistered<DeleteDriverAccountUsecase>()) {
      sl.registerLazySingleton<DeleteDriverAccountUsecase>(
        () => DeleteDriverAccountUsecase(sl()),
      );
    }

    // register profile cubit
    if (!sl.isRegistered<ProfileCubit>()) {
      sl.registerLazySingleton<ProfileCubit>(
        () => ProfileCubit(
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
          sl(),
        ),
      );
    }
  }
}
