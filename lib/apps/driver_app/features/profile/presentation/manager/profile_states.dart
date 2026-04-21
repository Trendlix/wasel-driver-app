import 'package:equatable/equatable.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/address_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/driver_document_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/driver_legel_info_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';

class ProfileStates extends Equatable {
  // logout states
  final RequestStatus? logoutStatus;
  final String? logoutErrorMessage;
  // get user profile states
  final RequestStatus? userProfileStatus;
  final String? userProfileErrorMessage;
  final ProfileEntity? profileModel;
  // update user profile
  final RequestStatus? updateUserProfileStatus;
  final String? updateUserProfileErrorMessage;
  final ProfileEntity? updateUserProfileModel;
  // get user addresses
  final RequestStatus? getUserAddressesStatus;
  final String? getUserAddressesErrorMessage;
  final List<AddressEntity>? userAddresses;
  // add address states
  final RequestStatus? addAddressStatus;
  final String? addAddressErrorMessage;
  // delete address states
  final RequestStatus? deleteAddressStatus;
  final String? deleteAddressErrorMessage;
  final int? deletedAddressId;
  // update address states
  final RequestStatus? updateAddressStatus;
  final String? updateAddressErrorMessage;
  // change user password states
  final RequestStatus? changeUserPasswordStatus;
  final String? changeUserPasswordErrorMessage;
  // get driver basic info states
  final RequestStatus? getDriverBasicInfoStatus;
  final String? getDriverBasicInfoErrorMessage;
  final DriverBasicInfoEntity? driverBasicInfoModel;
  // get driver legal info states
  final RequestStatus? getDriverLegalInfoStatus;
  final String? getDriverLegalInfoErrorMessage;
  final DriverLegalInfoEntity? driverLegalInfoModel;
  // update driver basic info states
  final RequestStatus? updateDriverBasicInfoStatus;
  final String? updateDriverBasicInfoErrorMessage;
  final DriverBasicInfoEntity? updateDriverBasicInfoModel;
  // get driver documents states
  final RequestStatus? getDriverDocumentsStatus;
  final String? getDriverDocumentsErrorMessage;
  final DriverDocumentsEntity? driverDocumentsModel;
  // upload driver documents states
  final RequestStatus? uploadDriverDocumentStatus;
  final String? uploadDriverDocumentErrorMessage;
  // renew driver documents states
  final RequestStatus? renewDriverDocumentStatus;
  final String? renewDriverDocumentErrorMessage;
  // delete driver account states
  final RequestStatus? deleteDriverAccountStatus;
  final String? deleteDriverAccountErrorMessage;

  const ProfileStates({
    // logout
    this.logoutStatus,
    this.logoutErrorMessage,
    // get user profile
    this.userProfileStatus,
    this.userProfileErrorMessage,
    this.profileModel,
    // update user profile
    this.updateUserProfileStatus,
    this.updateUserProfileErrorMessage,
    this.updateUserProfileModel,
    // get user addresses
    this.getUserAddressesStatus,
    this.getUserAddressesErrorMessage,
    this.userAddresses,
    // add address
    this.addAddressStatus,
    this.addAddressErrorMessage,
    // delete address
    this.deleteAddressStatus,
    this.deleteAddressErrorMessage,
    this.deletedAddressId,
    // update address
    this.updateAddressStatus,
    this.updateAddressErrorMessage,
    // change user password
    this.changeUserPasswordStatus,
    this.changeUserPasswordErrorMessage,
    // get driver basic info
    this.getDriverBasicInfoStatus,
    this.getDriverBasicInfoErrorMessage,
    this.driverBasicInfoModel,
    // get driver legal info
    this.getDriverLegalInfoStatus,
    this.getDriverLegalInfoErrorMessage,
    this.driverLegalInfoModel,
    // update driver basic info
    this.updateDriverBasicInfoStatus,
    this.updateDriverBasicInfoErrorMessage,
    this.updateDriverBasicInfoModel,
    // get driver documents
    this.getDriverDocumentsStatus,
    this.getDriverDocumentsErrorMessage,
    this.driverDocumentsModel,
    // upload driver documents
    this.uploadDriverDocumentStatus,
    this.uploadDriverDocumentErrorMessage,
    // renew driver documents
    this.renewDriverDocumentStatus,
    this.renewDriverDocumentErrorMessage,
    // delete driver account
    this.deleteDriverAccountStatus,
    this.deleteDriverAccountErrorMessage,
  });

  ProfileStates copywith({
    // logout
    RequestStatus? logoutStatus,
    String? logoutErrorMessage,
    // get user profile
    RequestStatus? userProfileStatus,
    String? userProfileErrorMessage,
    ProfileEntity? profileModel,
    // update user profile
    RequestStatus? updateUserProfileStatus,
    String? updateUserProfileErrorMessage,
    ProfileEntity? updateUserProfileModel,
    // get user addresses
    RequestStatus? getUserAddressesStatus,
    String? getUserAddressesErrorMessage,
    List<AddressEntity>? userAddresses,
    // add address
    RequestStatus? addAddressStatus,
    String? addAddressErrorMessage,
    // delete address
    RequestStatus? deleteAddressStatus,
    String? deleteAddressErrorMessage,
    int? deletedAddressId,
    // update address
    RequestStatus? updateAddressStatus,
    String? updateAddressErrorMessage,
    // change user password
    RequestStatus? changeUserPasswordStatus,
    String? changeUserPasswordErrorMessage,
    // get driver basic info
    RequestStatus? getDriverBasicInfoStatus,
    String? getDriverBasicInfoErrorMessage,
    DriverBasicInfoEntity? driverBasicInfoModel,
    // get driver legal info
    RequestStatus? getDriverLegalInfoStatus,
    String? getDriverLegalInfoErrorMessage,
    DriverLegalInfoEntity? driverLegalInfoModel,
    // update driver basic info
    RequestStatus? updateDriverBasicInfoStatus,
    String? updateDriverBasicInfoErrorMessage,
    DriverBasicInfoEntity? updateDriverBasicInfoModel,
    // get driver documents
    RequestStatus? getDriverDocumentsStatus,
    String? getDriverDocumentsErrorMessage,
    DriverDocumentsEntity? driverDocumentsModel,
    // upload driver documents
    RequestStatus? uploadDriverDocumentStatus,
    String? uploadDriverDocumentErrorMessage,
    // renew driver documents
    RequestStatus? renewDriverDocumentStatus,
    String? renewDriverDocumentErrorMessage,
    // delete driver account
    RequestStatus? deleteDriverAccountStatus,
    String? deleteDriverAccountErrorMessage,
  }) {
    return ProfileStates(
      // logout
      logoutStatus: logoutStatus ?? this.logoutStatus,
      logoutErrorMessage: logoutErrorMessage ?? this.logoutErrorMessage,
      // get user profile
      userProfileStatus: userProfileStatus ?? this.userProfileStatus,
      userProfileErrorMessage:
          userProfileErrorMessage ?? this.userProfileErrorMessage,
      profileModel: profileModel ?? this.profileModel,
      // update user profile
      updateUserProfileStatus:
          updateUserProfileStatus ?? this.updateUserProfileStatus,
      updateUserProfileErrorMessage:
          updateUserProfileErrorMessage ?? this.updateUserProfileErrorMessage,
      updateUserProfileModel:
          updateUserProfileModel ?? this.updateUserProfileModel,
      // get user addresses
      getUserAddressesStatus:
          getUserAddressesStatus ?? this.getUserAddressesStatus,
      getUserAddressesErrorMessage:
          getUserAddressesErrorMessage ?? this.getUserAddressesErrorMessage,
      userAddresses: userAddresses ?? this.userAddresses,
      // add address
      addAddressStatus: addAddressStatus ?? this.addAddressStatus,
      addAddressErrorMessage:
          addAddressErrorMessage ?? this.addAddressErrorMessage,
      // delete address
      deleteAddressStatus: deleteAddressStatus ?? this.deleteAddressStatus,
      deleteAddressErrorMessage:
          deleteAddressErrorMessage ?? this.deleteAddressErrorMessage,
      deletedAddressId: deletedAddressId ?? this.deletedAddressId,
      // update address
      updateAddressStatus: updateAddressStatus ?? this.updateAddressStatus,
      updateAddressErrorMessage:
          updateAddressErrorMessage ?? this.updateAddressErrorMessage,
      // change user password
      changeUserPasswordStatus:
          changeUserPasswordStatus ?? this.changeUserPasswordStatus,
      changeUserPasswordErrorMessage:
          changeUserPasswordErrorMessage ?? this.changeUserPasswordErrorMessage,
      // get driver basic info
      getDriverBasicInfoStatus:
          getDriverBasicInfoStatus ?? this.getDriverBasicInfoStatus,
      getDriverBasicInfoErrorMessage:
          getDriverBasicInfoErrorMessage ?? this.getDriverBasicInfoErrorMessage,
      driverBasicInfoModel: driverBasicInfoModel ?? this.driverBasicInfoModel,
      // get driver legal info
      getDriverLegalInfoStatus:
          getDriverLegalInfoStatus ?? this.getDriverLegalInfoStatus,
      getDriverLegalInfoErrorMessage:
          getDriverLegalInfoErrorMessage ?? this.getDriverLegalInfoErrorMessage,
      driverLegalInfoModel: driverLegalInfoModel ?? this.driverLegalInfoModel,
      // update driver basic info
      updateDriverBasicInfoStatus:
          updateDriverBasicInfoStatus ?? this.updateDriverBasicInfoStatus,
      updateDriverBasicInfoErrorMessage:
          updateDriverBasicInfoErrorMessage ??
          this.updateDriverBasicInfoErrorMessage,
      updateDriverBasicInfoModel:
          updateDriverBasicInfoModel ?? this.updateDriverBasicInfoModel,
      // get driver documents
      getDriverDocumentsStatus:
          getDriverDocumentsStatus ?? this.getDriverDocumentsStatus,
      getDriverDocumentsErrorMessage:
          getDriverDocumentsErrorMessage ?? this.getDriverDocumentsErrorMessage,
      driverDocumentsModel: driverDocumentsModel ?? this.driverDocumentsModel,
      // upload driver documents
      uploadDriverDocumentStatus:
          uploadDriverDocumentStatus ?? this.uploadDriverDocumentStatus,
      uploadDriverDocumentErrorMessage:
          uploadDriverDocumentErrorMessage ??
          this.uploadDriverDocumentErrorMessage,
      // renew driver documents
      renewDriverDocumentStatus:
          renewDriverDocumentStatus ?? this.renewDriverDocumentStatus,
      renewDriverDocumentErrorMessage:
          renewDriverDocumentErrorMessage ??
          this.renewDriverDocumentErrorMessage,
      // delete driver account
      deleteDriverAccountStatus:
          deleteDriverAccountStatus ?? this.deleteDriverAccountStatus,
      deleteDriverAccountErrorMessage:
          deleteDriverAccountErrorMessage ??
          this.deleteDriverAccountErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    // logout
    logoutStatus,
    logoutErrorMessage,
    // get user profile
    userProfileStatus,
    userProfileErrorMessage,
    profileModel,
    // update user profile
    updateUserProfileStatus,
    updateUserProfileErrorMessage,
    updateUserProfileModel,
    // get user addresses
    getUserAddressesStatus,
    getUserAddressesErrorMessage,
    userAddresses,
    // add address
    addAddressStatus,
    addAddressErrorMessage,
    // delete address
    deleteAddressStatus,
    deleteAddressErrorMessage,
    deletedAddressId,
    // update address
    updateAddressStatus,
    updateAddressErrorMessage,
    // change user password
    changeUserPasswordStatus,
    changeUserPasswordErrorMessage,
    // get driver basic info
    getDriverBasicInfoStatus,
    getDriverBasicInfoErrorMessage,
    driverBasicInfoModel,
    // get driver legal info
    getDriverLegalInfoStatus,
    getDriverLegalInfoErrorMessage,
    driverLegalInfoModel,
    // update driver basic info
    updateDriverBasicInfoStatus,
    updateDriverBasicInfoErrorMessage,
    updateDriverBasicInfoModel,
    // get driver documents
    getDriverDocumentsStatus,
    getDriverDocumentsErrorMessage,
    driverDocumentsModel,
    // upload driver documents
    uploadDriverDocumentStatus,
    uploadDriverDocumentErrorMessage,
    // renew driver documents
    renewDriverDocumentStatus,
    renewDriverDocumentErrorMessage,
    // delete driver account
    deleteDriverAccountStatus,
    deleteDriverAccountErrorMessage,
  ];

  @override
  String toString() {
    final activeStates = <String>[];

    // addIfNotNull function to add the state to the activeStates list if it is not null
    void addIfNotNull(String name, dynamic status, List<dynamic> details) {
      if (status != null) {
        activeStates.add('$name: $details');
      }
    }

    addIfNotNull('logout', logoutStatus, [logoutStatus, logoutErrorMessage]);
    addIfNotNull('getUser', userProfileStatus, [
      userProfileStatus,
      userProfileErrorMessage,
      profileModel,
    ]);
    addIfNotNull('updateUser', updateUserProfileStatus, [
      updateUserProfileStatus,
      updateUserProfileErrorMessage,
      updateUserProfileModel,
    ]);
    addIfNotNull('getUserAddresses', getUserAddressesStatus, [
      getUserAddressesStatus,
      getUserAddressesErrorMessage,
      userAddresses,
    ]);
    addIfNotNull('addAddress', addAddressStatus, [
      addAddressStatus,
      addAddressErrorMessage,
    ]);
    addIfNotNull('deleteAddress', deleteAddressStatus, [
      deleteAddressStatus,
      deleteAddressErrorMessage,
      deletedAddressId,
    ]);
    addIfNotNull('updateAddress', updateAddressStatus, [
      updateAddressStatus,
      updateAddressErrorMessage,
    ]);
    addIfNotNull('changePassword', changeUserPasswordStatus, [
      changeUserPasswordStatus,
      changeUserPasswordErrorMessage,
    ]);
    addIfNotNull('getDriverBasicInfo', getDriverBasicInfoStatus, [
      getDriverBasicInfoStatus,
      getDriverBasicInfoErrorMessage,
      driverBasicInfoModel,
    ]);
    addIfNotNull('getDriverLegalInfo', getDriverLegalInfoStatus, [
      getDriverLegalInfoStatus,
      getDriverLegalInfoErrorMessage,
      driverLegalInfoModel,
    ]);
    addIfNotNull('updateDriverBasicInfo', updateDriverBasicInfoStatus, [
      updateDriverBasicInfoStatus,
      updateDriverBasicInfoErrorMessage,
      updateDriverBasicInfoModel,
    ]);
    addIfNotNull('getDriverDocuments', getDriverDocumentsStatus, [
      getDriverDocumentsStatus,
      getDriverDocumentsErrorMessage,
      driverDocumentsModel,
    ]);
    addIfNotNull('uploadDriverDocument', uploadDriverDocumentStatus, [
      uploadDriverDocumentStatus,
      uploadDriverDocumentErrorMessage,
    ]);
    addIfNotNull('renewDriverDocument', renewDriverDocumentStatus, [
      renewDriverDocumentStatus,
      renewDriverDocumentErrorMessage,
    ]);

    addIfNotNull('deleteDriverAccount', deleteDriverAccountStatus, [
      deleteDriverAccountStatus,
      deleteDriverAccountErrorMessage,
    ]);

    // النتيجة النهائية
    return activeStates.isEmpty
        ? 'ProfileStates()'
        : 'ProfileStates(\n    ${activeStates.join(',\n    ')}\n  )';
  }
}
