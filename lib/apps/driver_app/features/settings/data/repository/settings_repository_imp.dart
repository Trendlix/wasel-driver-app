import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/ticket_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/user_prefrences_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/services/settings_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/faq_type_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/terms_condition_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket-category_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/repository/settings_repository.dart';

class SettingsRepositoryImp implements SettingsRepository {
  final SettingsApiService _settingsApiService;

  SettingsRepositoryImp(this._settingsApiService);

  @override
  Future<Either<String, String>> submitTicket(TicketEntity ticket) {
    return _settingsApiService.submitTicket(TicketModel.fromEntity(ticket));
  }

  @override
  Future<Either<String, UserPreferencesModel>> getUserPreferences() {
    return _settingsApiService.getUserPreferences();
  }

  @override
  Future<Either<String, bool>> updateUserPreferences(
    UserPreferencesEntity userPreferences,
  ) {
    return _settingsApiService.updateUserPreferences(
      UserPreferencesModel.fromEntity(userPreferences),
    );
  }

  @override
  Future<Either<String, List<TicketCategoryEntity>>> getTicketCategories() {
    return _settingsApiService.getTicketCategories();
  }

  @override
  Future<Either<String, TermsConditionEntity>> getTermsCondition() {
    return _settingsApiService.getTermsCondition();
  }

  @override
  Future<Either<String, List<FaqEntity>>> getFaqs() {
    return _settingsApiService.getFaqs();
  }
}
