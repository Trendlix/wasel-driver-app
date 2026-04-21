import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/faq_type_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/repository/settings_repository.dart';

class GetFaqsUsecases {
  final SettingsRepository _settingsRepository;

  GetFaqsUsecases(this._settingsRepository);

  Future<Either<String, List<FaqEntity>>> call() {
    return _settingsRepository.getFaqs();
  }
}
