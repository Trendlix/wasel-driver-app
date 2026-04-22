import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/user_preferences_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/get_faqs_usecases.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/get_terms_condition_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/get_ticket_category_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/get_user_preferences_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/submit_ticket_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/usecases/update_user_preferences_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_states.dart';

class SettingsCubit extends Cubit<SettingsStates> {
  final SubmitTicketUsecase _submitTicketUsecase;
  final GetUserPreferencesUsecase _getUserPreferencesUsecase;
  final UpdateUserPreferencesUsecase _updateUserPreferencesUsecase;
  final GetTicketCategoryUsecase _getTicketCategoryUsecase;
  final GetTermsConditionUsecase _getTermsConditionUsecase;
  final GetFaqsUsecases _getFaqsUsecase;

  SettingsCubit(
    this._submitTicketUsecase,
    this._getUserPreferencesUsecase,
    this._updateUserPreferencesUsecase,
    this._getTicketCategoryUsecase,
    this._getTermsConditionUsecase,
    this._getFaqsUsecase,
  ) : super(const SettingsStates());

  Future<void> submitTicket(TicketEntity ticket) async {
    emit(state.copyWith(submitTicketRequestStatus: RequestStatus.loading));
    final result = await _submitTicketUsecase.submitTicket(ticket);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          submitTicketRequestStatus: RequestStatus.error,
          submitTicketErrorMessage: error,
        ),
      ),
      (ticketNumber) => emit(
        state.copyWith(
          submitTicketRequestStatus: RequestStatus.success,
          ticketNumber: ticketNumber,
        ),
      ),
    );
  }

  Future<void> getUserPreferences() async {
    emit(
      state.copyWith(getUserPreferencesRequestStatus: RequestStatus.loading),
    );
    final result = await _getUserPreferencesUsecase.call();
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          getUserPreferencesRequestStatus: RequestStatus.error,
          getUserPreferencesErrorMessage: error,
        ),
      ),
      (success) => emit(
        state.copyWith(
          getUserPreferencesRequestStatus: RequestStatus.success,
          userPreferences: success,
        ),
      ),
    );
  }

  Future<void> updateUserPreferences(
    UserPreferencesEntity userPreferences,
  ) async {
    emit(
      state.copyWith(updateUserPreferencesRequestStatus: RequestStatus.loading),
    );
    final result = await _updateUserPreferencesUsecase.call(userPreferences);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          updateUserPreferencesRequestStatus: RequestStatus.error,
          updateUserPreferencesErrorMessage: error,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            updateUserPreferencesRequestStatus: RequestStatus.success,
          ),
        );
        getUserPreferences();
      },
    );
  }

  Future<void> getTicketCategories() async {
    emit(
      state.copyWith(getTicketCategoriesRequestStatus: RequestStatus.loading),
    );
    final result = await _getTicketCategoryUsecase.call();
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          getTicketCategoriesRequestStatus: RequestStatus.error,
          getTicketCategoriesErrorMessage: error,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          getTicketCategoriesRequestStatus: RequestStatus.success,
          ticketCategories: categories,
        ),
      ),
    );
  }

  Future<void> getTermsCondition() async {
    emit(state.copyWith(getTermsConditionRequestStatus: RequestStatus.loading));
    final result = await _getTermsConditionUsecase.call();
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          getTermsConditionRequestStatus: RequestStatus.error,
          getTermsConditionErrorMessage: error,
        ),
      ),
      (termsCondition) => emit(
        state.copyWith(
          getTermsConditionRequestStatus: RequestStatus.success,
          termsCondition: termsCondition,
        ),
      ),
    );
  }

  Future<void> getFaqs() async {
    emit(state.copyWith(getFaqsRequestStatus: RequestStatus.loading));
    final result = await _getFaqsUsecase.call();
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          getFaqsRequestStatus: RequestStatus.error,
          getFaqsErrorMessage: error,
        ),
      ),
      (faqs) => emit(
        state.copyWith(getFaqsRequestStatus: RequestStatus.success, faqs: faqs),
      ),
    );
  }
}
