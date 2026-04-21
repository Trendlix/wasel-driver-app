import 'package:equatable/equatable.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/faq_type_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/terms_condition_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket-category_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/user_preferences_entity.dart';

class SettingsStates extends Equatable {
  // submit ticket states
  final RequestStatus? submitTicketRequestStatus;
  final String? submitTicketErrorMessage;
  final String? ticketNumber;
  // get user prefences states
  final RequestStatus? getUserPreferencesRequestStatus;
  final String? getUserPreferencesErrorMessage;
  final UserPreferencesEntity? userPreferences;
  // update user prefences states
  final RequestStatus? updateUserPreferencesRequestStatus;
  final String? updateUserPreferencesErrorMessage;
  // get ticket categories states
  final RequestStatus? getTicketCategoriesRequestStatus;
  final String? getTicketCategoriesErrorMessage;
  final List<TicketCategoryEntity>? ticketCategories;
  // get terms condition states
  final RequestStatus? getTermsConditionRequestStatus;
  final String? getTermsConditionErrorMessage;
  final TermsConditionEntity? termsCondition;
  // get faqs states
  final RequestStatus? getFaqsRequestStatus;
  final String? getFaqsErrorMessage;
  final List<FaqEntity>? faqs;

  const SettingsStates({
    // submit ticket states
    this.submitTicketRequestStatus,
    this.submitTicketErrorMessage,
    this.ticketNumber,
    // get user prefences states
    this.getUserPreferencesRequestStatus,
    this.getUserPreferencesErrorMessage,
    this.userPreferences,
    // update user prefences states
    this.updateUserPreferencesRequestStatus,
    this.updateUserPreferencesErrorMessage,
    // get ticket categories states
    this.getTicketCategoriesRequestStatus,
    this.getTicketCategoriesErrorMessage,
    this.ticketCategories,
    // get terms condition states
    this.getTermsConditionRequestStatus,
    this.getTermsConditionErrorMessage,
    this.termsCondition,
    // faqs states
    this.getFaqsRequestStatus,
    this.getFaqsErrorMessage,
    this.faqs,
  });

  SettingsStates copyWith({
    // submit ticket states
    RequestStatus? submitTicketRequestStatus,
    String? submitTicketErrorMessage,
    String? ticketNumber,
    // get user prefences states
    RequestStatus? getUserPreferencesRequestStatus,
    String? getUserPreferencesErrorMessage,
    UserPreferencesEntity? userPreferences,
    // update user prefences states
    RequestStatus? updateUserPreferencesRequestStatus,
    String? updateUserPreferencesErrorMessage,
    // get ticket categories states
    RequestStatus? getTicketCategoriesRequestStatus,
    String? getTicketCategoriesErrorMessage,
    List<TicketCategoryEntity>? ticketCategories,
    // get terms condition states
    RequestStatus? getTermsConditionRequestStatus,
    String? getTermsConditionErrorMessage,
    TermsConditionEntity? termsCondition,
    // faqs states
    RequestStatus? getFaqsRequestStatus,
    String? getFaqsErrorMessage,
    List<FaqEntity>? faqs,
  }) {
    return SettingsStates(
      // submit ticket states
      submitTicketRequestStatus:
          submitTicketRequestStatus ?? this.submitTicketRequestStatus,
      submitTicketErrorMessage:
          submitTicketErrorMessage ?? this.submitTicketErrorMessage,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      // get user prefences states
      getUserPreferencesRequestStatus:
          getUserPreferencesRequestStatus ??
          this.getUserPreferencesRequestStatus,
      getUserPreferencesErrorMessage:
          getUserPreferencesErrorMessage ?? this.getUserPreferencesErrorMessage,
      userPreferences: userPreferences ?? this.userPreferences,
      // update user prefences states
      updateUserPreferencesRequestStatus:
          updateUserPreferencesRequestStatus ??
          this.updateUserPreferencesRequestStatus,
      updateUserPreferencesErrorMessage:
          updateUserPreferencesErrorMessage ??
          this.updateUserPreferencesErrorMessage,
      // get ticket categories states
      getTicketCategoriesRequestStatus:
          getTicketCategoriesRequestStatus ??
          this.getTicketCategoriesRequestStatus,
      getTicketCategoriesErrorMessage:
          getTicketCategoriesErrorMessage ??
          this.getTicketCategoriesErrorMessage,
      ticketCategories: ticketCategories ?? this.ticketCategories,
      // get terms condition states
      getTermsConditionRequestStatus:
          getTermsConditionRequestStatus ?? this.getTermsConditionRequestStatus,
      getTermsConditionErrorMessage:
          getTermsConditionErrorMessage ?? this.getTermsConditionErrorMessage,
      termsCondition: termsCondition ?? this.termsCondition,
      // faqs states
      getFaqsRequestStatus: getFaqsRequestStatus ?? this.getFaqsRequestStatus,
      getFaqsErrorMessage: getFaqsErrorMessage ?? this.getFaqsErrorMessage,
      faqs: faqs ?? this.faqs,
    );
  }

  @override
  List<Object?> get props => [
    // submit ticket states
    submitTicketRequestStatus,
    submitTicketErrorMessage,
    ticketNumber,
    // get user prefences states
    getUserPreferencesRequestStatus,
    getUserPreferencesErrorMessage,
    userPreferences,
    updateUserPreferencesRequestStatus,
    updateUserPreferencesErrorMessage,
    // get ticket categories states
    getTicketCategoriesRequestStatus,
    getTicketCategoriesErrorMessage,
    ticketCategories,
    // get terms condition states
    getTermsConditionRequestStatus,
    getTermsConditionErrorMessage,
    termsCondition,
    // faqs states
    getFaqsRequestStatus,
    getFaqsErrorMessage,
    faqs,
  ];

  @override
  String toString() {
    final activeStates = <String>[];

    void addIfNotNull(String name, dynamic status, List<dynamic> details) {
      if (status != null) {
        activeStates.add('$name: $details');
      }
    }

    addIfNotNull('submitTicket', submitTicketRequestStatus, [
      submitTicketRequestStatus,
      submitTicketErrorMessage,
      ticketNumber,
    ]);

    addIfNotNull('getUserPreferences', getUserPreferencesRequestStatus, [
      getUserPreferencesRequestStatus,
      getUserPreferencesErrorMessage,
      userPreferences,
    ]);

    addIfNotNull('updateUserPreferences', updateUserPreferencesRequestStatus, [
      updateUserPreferencesRequestStatus,
      updateUserPreferencesErrorMessage,
    ]);

    addIfNotNull('getTicketCategories', getTicketCategoriesRequestStatus, [
      getTicketCategoriesRequestStatus,
      getTicketCategoriesErrorMessage,
      ticketCategories,
    ]);
    addIfNotNull('getTermsCondition', getTermsConditionRequestStatus, [
      getTermsConditionRequestStatus,
      getTermsConditionErrorMessage,
      termsCondition,
    ]);
    addIfNotNull('getFaqs', getFaqsRequestStatus, [
      getFaqsRequestStatus,
      getFaqsErrorMessage,
      faqs,
    ]);

    return activeStates.isEmpty
        ? 'TicketStates(Idle)'
        : 'TicketStates(\n    ${activeStates.join(',\n    ')}\n  )';
  }
}
