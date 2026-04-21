import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/repository/settings_repository.dart';

class UpdateUserPreferencesUsecase {
  final SettingsRepository _settingsRepository;

  UpdateUserPreferencesUsecase(this._settingsRepository);

  Future<Either<String, bool>> call(UserPreferencesEntity userPreferences) {
    return _settingsRepository.updateUserPreferences(userPreferences);
  }
}
