import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/repository/inbox_repository_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/services/inbox_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/services/inbox_api_service_imp.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/repository/inbox_repository.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/get_chat_messages_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/get_inbox_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/initate_chat_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/mark_inbox_item_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/usecases/send_message_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/manager/inbox_cubit.dart';

class InboxServiceLocator implements ServiceLocator {
  @override
  Future<void> initServiceLocator() async {
    final sl = GetIt.instance;

    // register api client
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(() => DioClient());
    }

    // register api service
    if (!sl.isRegistered<InboxApiService>()) {
      sl.registerLazySingleton<InboxApiService>(() => InboxApiServiceImp(sl()));
    }

    // register repository
    if (!sl.isRegistered<InboxRepository>()) {
      sl.registerLazySingleton<InboxRepository>(() => InboxRepositoryImp(sl()));
    }

    // register usecase
    if (!sl.isRegistered<GetOffersInboxUsecase>()) {
      sl.registerLazySingleton<GetOffersInboxUsecase>(
        () => GetOffersInboxUsecase(sl()),
      );
    }

    if (!sl.isRegistered<GetUpdatesInboxUsecase>()) {
      sl.registerLazySingleton<GetUpdatesInboxUsecase>(
        () => GetUpdatesInboxUsecase(sl()),
      );
    }

    if (!sl.isRegistered<GetSupportInboxUsecase>()) {
      sl.registerLazySingleton<GetSupportInboxUsecase>(
        () => GetSupportInboxUsecase(sl()),
      );
    }

    if (!sl.isRegistered<InitateChatUsecase>()) {
      sl.registerLazySingleton<InitateChatUsecase>(
        () => InitateChatUsecase(sl()),
      );
    }

    // register get chat messages usecase
    if (!sl.isRegistered<GetChatMessagesUsecase>()) {
      sl.registerLazySingleton<GetChatMessagesUsecase>(
        () => GetChatMessagesUsecase(sl()),
      );
    }

    // register send message usecase
    if (!sl.isRegistered<SendMessageUsecase>()) {
      sl.registerLazySingleton<SendMessageUsecase>(
        () => SendMessageUsecase(sl()),
      );
    }

    if (!sl.isRegistered<MarkInboxItemUsecase>()) {
      sl.registerLazySingleton<MarkInboxItemUsecase>(
        () => MarkInboxItemUsecase(sl()),
      );
    }

    // register cubit
    if (!sl.isRegistered<InboxCubit>()) {
      sl.registerFactory<InboxCubit>(
        () => InboxCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl()),
      );
    }
  }
}
