import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/repository/settings_repository.dart';

class GetUserPreferencesUsecase {
  final SettingsRepository _settingsRepository;

  GetUserPreferencesUsecase(this._settingsRepository);

  Future<Either<String, UserPreferencesEntity>> call() async {
    return await _settingsRepository.getUserPreferences();
  }
}
