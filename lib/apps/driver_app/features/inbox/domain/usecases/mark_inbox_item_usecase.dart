import 'package:either_dart/either.dart';

import '../repository/inbox_repository.dart';

class MarkInboxItemUsecase {
  final InboxRepository _inboxRepository;

  MarkInboxItemUsecase(this._inboxRepository);

  Future<Either<String, bool>> call(String inboxItemId, bool isSupport) {
    return _inboxRepository.markInboxItem(inboxItemId, isSupport);
  }
}
