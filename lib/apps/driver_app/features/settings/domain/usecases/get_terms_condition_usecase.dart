import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/terms_condition_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/repository/settings_repository.dart';

class GetTermsConditionUsecase {
  final SettingsRepository _settingsRepository;

  GetTermsConditionUsecase(this._settingsRepository);

  Future<Either<String, TermsConditionEntity>> call() {
    return _settingsRepository.getTermsCondition();
  }
}
