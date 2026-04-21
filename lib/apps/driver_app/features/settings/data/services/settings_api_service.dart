import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/faq_type_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/terms_condition_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/ticket_category_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/ticket_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/user_prefrences_model.dart';

abstract class SettingsApiService {
  Future<Either<String, String>> submitTicket(TicketModel ticket);
  Future<Either<String, UserPreferencesModel>> getUserPreferences();
  Future<Either<String, bool>> updateUserPreferences(
    UserPreferencesModel userPreferences,
  );
  Future<Either<String, List<TicketCategoryModel>>> getTicketCategories();
  Future<Either<String, TermsConditionModel>> getTermsCondition();
  Future<Either<String, List<FaqModel>>> getFaqs();
}
