import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/inbox_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ibox_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/repository/inbox_repository.dart';

class GetOffersInboxUsecase {
  final InboxRepository _inboxRepository;

  GetOffersInboxUsecase(this._inboxRepository);

  Future<Either<String, List<OfferEntity>>> call(
    InboxStatus status,
    int page,
    int limit,
  ) {
    return _inboxRepository.getOffersInbox(status, page, limit);
  }
}

class GetUpdatesInboxUsecase {
  final InboxRepository _inboxRepository;

  GetUpdatesInboxUsecase(this._inboxRepository);

  Future<Either<String, List<UpdateEntity>>> call(
    InboxStatus status,
    int page,
    int limit,
  ) {
    return _inboxRepository.getUpdatesInbox(status, page, limit);
  }
}

class GetSupportInboxUsecase {
  final InboxRepository _inboxRepository;

  GetSupportInboxUsecase(this._inboxRepository);

  Future<Either<String, List<SupportEntity>>> call(
    InboxStatus status,
    int page,
    int limit,
  ) {
    return _inboxRepository.getSupportInbox(status, page, limit);
  }
}
