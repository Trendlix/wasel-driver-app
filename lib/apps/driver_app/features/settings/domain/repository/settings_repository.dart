import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/faq_type_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/terms_condition_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket-category_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/user_preferences_entity.dart';

abstract class SettingsRepository {
  Future<Either<String, String>> submitTicket(TicketEntity ticket);
  Future<Either<String, UserPreferencesEntity>> getUserPreferences();
  Future<Either<String, bool>> updateUserPreferences(
    UserPreferencesEntity userPreferences,
  );
  Future<Either<String, List<TicketCategoryEntity>>> getTicketCategories();
  Future<Either<String, TermsConditionEntity>> getTermsCondition();
  Future<Either<String, List<FaqEntity>>> getFaqs();
}
