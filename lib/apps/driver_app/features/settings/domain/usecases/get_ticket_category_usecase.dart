import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket-category_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/repository/settings_repository.dart';

class GetTicketCategoryUsecase {
  final SettingsRepository _settingsRepository;

  GetTicketCategoryUsecase(this._settingsRepository);

  Future<Either<String, List<TicketCategoryEntity>>> call() async {
    return await _settingsRepository.getTicketCategories();
  }
}
