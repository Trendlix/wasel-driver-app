import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/address_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/add_address_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/chage_user_password_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/delete_driver_account_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/delete_user_address_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/get_driver_documents_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/get_driver_legel_info_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/get_profile_usercase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/get_user_addresses_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/renew_driver_document_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/update_driver_basic_info_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/update_user_address_usercase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/update_user_info_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/usecases/upload_driver_document_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final LogoutUsecase _logoutUsecase;
  final GetProfileUsercase _getProfileUsercase;
  final UpdateUserInfoUsecase _updateUserInfoUsecase;
  final GetUserAddressesUsecase _getUserAddressesUsecase;
  final AddAddressUsecase _addAddressUsecase;
  final DeleteUserAddressUsecase _deleteUserAddressUsecase;
  final UpdateUserAddressUsercase _updateUserAddressUsercase;
  final ChageUserPasswordUsecase _changeUserPasswordUsecase;
  final GetDriverBasicInfoUsercase _getDriverBasicInfoUsercase;
  final GetDriverLegelInfoUsecase _getDriverLegelInfoUsecase;
  final UpdateDriverBasicInfoUsecase _updateDriverBasicInfoUsecase;
  final GetDriverDocumentsUsecase _getDriverDocumentsUsecase;
  final UploadDriverDocumentUsecase _uploadDriverDocumentUsecase;
  final RenewDriverDocumentUsecase _renewDriverDocumentUsecase;
  final DeleteDriverAccountUsecase _deleteDriverAccountUsecase;

  ProfileCubit(
    this._logoutUsecase,
    this._getProfileUsercase,
    this._updateUserInfoUsecase,
    this._getUserAddressesUsecase,
    this._addAddressUsecase,
    this._deleteUserAddressUsecase,
    this._updateUserAddressUsercase,
    this._changeUserPasswordUsecase,
    this._getDriverBasicInfoUsercase,
    this._getDriverLegelInfoUsecase,
    this._updateDriverBasicInfoUsecase,
    this._getDriverDocumentsUsecase,
    this._uploadDriverDocumentUsecase,
    this._renewDriverDocumentUsecase,
    this._deleteDriverAccountUsecase,
  ) : super(const ProfileStates());

  Future<void> logout() async {
    emit(state.copywith(logoutStatus: RequestStatus.loading));
    final result = await _logoutUsecase.call();
    result.fold(
      (l) => emit(
        state.copywith(
          logoutStatus: RequestStatus.error,
          logoutErrorMessage: l,
        ),
      ),
      (r) => emit(state.copywith(logoutStatus: RequestStatus.success)),
    );
  }

  Future<void> getProfile() async {
    emit(state.copywith(userProfileStatus: RequestStatus.loading));
    final result = await _getProfileUsercase.call();
    result.fold(
      (l) => emit(
        state.copywith(
          userProfileStatus: RequestStatus.error,
          userProfileErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copywith(
          userProfileStatus: RequestStatus.success,
          profileModel: r,
        ),
      ),
    );
  }

  Future<void> updateUserProfile(ProfileEntity profileModel) async {
    emit(state.copywith(updateUserProfileStatus: RequestStatus.loading));
    final result = await _updateUserInfoUsecase.call(profileModel);
    result.fold(
      (l) => emit(
        state.copywith(
          updateUserProfileStatus: RequestStatus.error,
          updateUserProfileErrorMessage: l,
        ),
      ),
      (model) {
        emit(
          state.copywith(
            updateUserProfileStatus: RequestStatus.success,
            updateUserProfileModel: model,
          ),
        );
        getProfile();
      },
    );
  }

  Future<void> getUserAddresses() async {
    emit(state.copywith(getUserAddressesStatus: RequestStatus.loading));
    final result = await _getUserAddressesUsecase.call();
    result.fold(
      (l) => emit(
        state.copywith(
          getUserAddressesStatus: RequestStatus.error,
          getUserAddressesErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copywith(
          getUserAddressesStatus: RequestStatus.success,
          userAddresses: r,
        ),
      ),
    );
  }

  Future<void> addAddress(AddressEntity address) async {
    emit(state.copywith(addAddressStatus: RequestStatus.loading));
    final result = await _addAddressUsecase.call(address);
    result.fold(
      (l) => emit(
        state.copywith(
          addAddressStatus: RequestStatus.error,
          addAddressErrorMessage: l,
        ),
      ),
      (r) => emit(state.copywith(addAddressStatus: RequestStatus.success)),
    );
    getUserAddresses();
  }

  Future<void> deleteAddress(String addressId) async {
    emit(
      state.copywith(
        deleteAddressStatus: RequestStatus.loading,
        deletedAddressId: int.parse(addressId),
      ),
    );
    final result = await _deleteUserAddressUsecase.call(addressId);
    result.fold(
      (l) => emit(
        state.copywith(
          deleteAddressStatus: RequestStatus.error,
          deleteAddressErrorMessage: l,
          deletedAddressId: null,
        ),
      ),
      (r) => emit(
        state.copywith(
          deleteAddressStatus: RequestStatus.success,
          deletedAddressId: null,
        ),
      ),
    );
    getUserAddresses();
  }

  Future<void> updateAddress(AddressEntity address) async {
    emit(state.copywith(updateAddressStatus: RequestStatus.loading));
    final result = await _updateUserAddressUsercase.call(address);
    result.fold(
      (l) => emit(
        state.copywith(
          updateAddressStatus: RequestStatus.error,
          updateAddressErrorMessage: l,
        ),
      ),
      (r) => emit(state.copywith(updateAddressStatus: RequestStatus.success)),
    );
    getUserAddresses();
  }

  Future<void> changeUserPassword(
    String oldPassword,
    String newPassword,
  ) async {
    emit(state.copywith(changeUserPasswordStatus: RequestStatus.loading));
    final result = await _changeUserPasswordUsecase.call(
      oldPassword,
      newPassword,
    );
    result.fold(
      (l) => emit(
        state.copywith(
          changeUserPasswordStatus: RequestStatus.error,
          changeUserPasswordErrorMessage: l,
        ),
      ),
      (r) =>
          emit(state.copywith(changeUserPasswordStatus: RequestStatus.success)),
    );
  }

  Future<void> getDriverBasicInfo() async {
    emit(state.copywith(getDriverBasicInfoStatus: RequestStatus.loading));
    final result = await _getDriverBasicInfoUsercase.call();
    result.fold(
      (l) => emit(
        state.copywith(
          getDriverBasicInfoStatus: RequestStatus.error,
          getDriverBasicInfoErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copywith(
          getDriverBasicInfoStatus: RequestStatus.success,
          driverBasicInfoModel: r,
        ),
      ),
    );
  }

  Future<void> getDriverLegalInfo() async {
    emit(state.copywith(getDriverLegalInfoStatus: RequestStatus.loading));
    final result = await _getDriverLegelInfoUsecase.call();
    result.fold(
      (l) => emit(
        state.copywith(
          getDriverLegalInfoStatus: RequestStatus.error,
          getDriverLegalInfoErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copywith(
          getDriverLegalInfoStatus: RequestStatus.success,
          driverLegalInfoModel: r,
        ),
      ),
    );
  }

  Future<void> updateDriverBasicInfo(DriverBasicInfoEntity model) async {
    emit(state.copywith(updateDriverBasicInfoStatus: RequestStatus.loading));
    final result = await _updateDriverBasicInfoUsecase.call(model);
    result.fold(
      (l) => emit(
        state.copywith(
          updateDriverBasicInfoStatus: RequestStatus.error,
          updateDriverBasicInfoErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copywith(
          updateDriverBasicInfoStatus: RequestStatus.success,
          updateDriverBasicInfoModel: r,
        ),
      ),
    );
    getDriverBasicInfo();
    getProfile();
  }

  Future<void> getDriverDocuments() async {
    emit(state.copywith(getDriverDocumentsStatus: RequestStatus.loading));
    final result = await _getDriverDocumentsUsecase.call();
    result.fold(
      (l) => emit(
        state.copywith(
          getDriverDocumentsStatus: RequestStatus.error,
          getDriverDocumentsErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copywith(
          getDriverDocumentsStatus: RequestStatus.success,
          driverDocumentsModel: r,
        ),
      ),
    );
  }

  Future<void> uploadDriverDocument({
    required String file,
    required String type,
    required String expiryDate,
  }) async {
    emit(state.copywith(uploadDriverDocumentStatus: RequestStatus.loading));
    final result = await _uploadDriverDocumentUsecase.call(
      file: file,
      type: type,
      expiryDate: expiryDate,
    );
    result.fold(
      (l) => emit(
        state.copywith(
          uploadDriverDocumentStatus: RequestStatus.error,
          uploadDriverDocumentErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copywith(uploadDriverDocumentStatus: RequestStatus.success),
      ),
    );
    getDriverDocuments();
  }

  Future<void> renewDriverDocument({
    required String documentId,
    required String file,
    required String expiryDate,
  }) async {
    emit(state.copywith(renewDriverDocumentStatus: RequestStatus.loading));
    final result = await _renewDriverDocumentUsecase.call(
      documentId,
      file,
      expiryDate,
    );
    result.fold(
      (l) => emit(
        state.copywith(
          renewDriverDocumentStatus: RequestStatus.error,
          renewDriverDocumentErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copywith(renewDriverDocumentStatus: RequestStatus.success),
      ),
    );
    getDriverDocuments();
  }

  Future<void> deleteDriverAccount() async {
    emit(state.copywith(deleteDriverAccountStatus: RequestStatus.loading));
    final result = await _deleteDriverAccountUsecase.call();
    result.fold(
      (l) => emit(
        state.copywith(
          deleteDriverAccountStatus: RequestStatus.error,
          deleteDriverAccountErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copywith(deleteDriverAccountStatus: RequestStatus.success),
      ),
    );
  }

  void reset() {
    emit(const ProfileStates());
  }

  void resetUpdateStatus() {
    emit(state.copywith(updateDriverBasicInfoStatus: RequestStatus.initial));
  }
}
