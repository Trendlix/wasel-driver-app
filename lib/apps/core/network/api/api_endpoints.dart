class ApiEndpoints {
  static const String baseUrl = 'http://16.171.45.88:3000/';

  // api pathes
  static const String registerPath = 'auth/signup';
  static const String otpPath = 'auth/verify-otp';
  static const String loginPath = 'auth/locale-login';
  static const String loginWithPhonePath = 'auth/phone-login-with-otp';
  static const String checkPhoneIsLoginPath = 'auth/ask-for-otp/';
  static const String resetPasswordPath = 'auth/reset-password';
  static const String askForRefreshTokenPath = 'auth/ask-for-new-access-token';
  static const String getUserProfilePath = 'driver/profile';
  static const String getAddressesPath = 'address';
  static const String getAddressesType = 'addres/types';
  static const String addVoucherPath = 'vouchers/add';
  static const String getUserWalletPath = 'wallet/my-wallet';
  static const String getInboxPath = 'driver/inbox/full-structured';
  static const String submitTicketPath = 'driver/ticket/request';
  static const String userPreferencesPath = 'driver/prefernces';
  static const String getUserPaymentCardsPath = 'card';
  static const String changeUserPasswordPath = 'auth/change-password';
  static const String getTicketCategoriesPath = 'ticket-category';
  static const String termsAndConditionsPath = 'driver/terms-conditions';
  static const String frequentlyAskedQuestionsPath = 'faqs';
  static const String notificationsPath = 'driver/inbox';
  static const String markAllNotificationsAsReadPath =
      'driver/inbox/mark-all-as-read';
  static const String chatInitiatPath = 'driver/chat/initiate';
  static const String conversationPath = 'driver/chat/conversation';
  static const String goodsTypesPath = 'goods-types';
  static const String trucksByGoodsTypePath = 'truck-types/goods/';
  static const String suggestPricePath = 'truck-requests/suggested-price';
  static const String submitBookingPath = 'truck-requests';
  static const String getTrucRequestOffersPath = 'truck-offer/request/';
  static const String acceptOfferPath = 'truck-offer';
  static const String rejectOfferPath = 'truck-offer';
  static const String getDriverProfilePath = 'driver';
  static const String driverReviewRequestPath = 'driver-review';

  // shipments paths
  static const String getShipmentsPath = 'trip/my-trips';
  static const String getShipmentDetailsPath = 'trip/';
  static const String getNoReviewDriverPath = 'trip/no-review';

  /// driver paths
  static const String driverRegisterPath = 'driver/apply';
  static const String driverTrucksPath = 'truck';
  static const String driverAccountStatusPath = 'driver';

  /// driver trips paths
  static const String getDriverTripsPath = 'trip/driver-trips';
  static const String getDriverTripByIdPath = 'trip/driver/';
  static const String cancelDriverTripPath = 'trip';
  static const String confirmPickupPath = 'trip/confirm-pickup';
  static const String confirmDeliveryPath = 'trip/confirm-delivery';

  /// driver summary path
  static const String driverSummaryPath = 'driver/summary';
  static const String driverRequestsPath = 'truck-requests/driver';

  /// driver wallet path
  static const String driverWalletPath = 'driver/wallet/my-wallet';
  static const String driverWalletTransactionsPath =
      'driver/wallet/my-wallet-transactions';

  /// driver logout path
  static const String driverLogoutPath = 'driver/signout';
  static const String driverBasicInfoPath = 'driver/basic-info';
  static const String driverLegelInfoPath = 'driver/legal-info';
  static const String getDriverDocumentsPath = 'driver/documents';
  static const String deleteDriverAccountPath = 'driver/account';
  static const String driverOfferPath = 'truck-offer';
  static const String markInboxItem = 'driver/inbox/mark-as-read';
}
