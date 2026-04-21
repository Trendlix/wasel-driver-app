import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/address_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/driver_documents_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/driver_legel_info_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/profile_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/services/profile_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/address_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImp implements ProfileRepository {
  final ProfileApiService _profileService;
  ProfileRepositoryImp({required ProfileApiService profileService})
    : _profileService = profileService;
  @override
  Future<Either<String, bool>> logout() async {
    return await _profileService.logout();
  }

  @override
  Future<Either<String, ProfileEntity>> getProfile() async {
    return await _profileService.getProfile();
  }

  @override
  Future<Either<String, ProfileEntity>> updaetUserProfile(
    ProfileEntity profileEntity,
  ) {
    return _profileService.updaetUserProfile(profileEntity as ProfileModel);
  }

  @override
  Future<Either<String, List<AddressModel>>> getAdrdesses() {
    return _profileService.getAddresses();
  }

  @override
  Future<Either<String, bool>> addAddress(AddressEntity addressModel) {
    return _profileService.addAddress(AddressModel.fromEntity(addressModel));
  }

  @override
  Future<Either<String, bool>> deleteAddress(String id) {
    return _profileService.deleteAddress(id);
  }

  @override
  Future<Either<String, bool>> updateAddress(AddressEntity model) {
    return _profileService.updateAddress(AddressModel.fromEntity(model));
  }

  @override
  Future<Either<String, bool>> changeUserPassword(
    String oldPassword,
    String newPassword,
  ) {
    return _profileService.changeUserPassword(oldPassword, newPassword);
  }

  @override
  Future<Either<String, DriverBasicInfoModel>> getDriverBasicInfo() {
    return _profileService.getDriverBasicInfo();
  }

  @override
  Future<Either<String, DriverLegalInfoModel>> getDriverLegalInfo() {
    return _profileService.getDriverLegalInfo();
  }

  @override
  Future<Either<String, DriverBasicInfoEntity>> updateDriverBasicInfo(
    DriverBasicInfoEntity model,
  ) {
    return _profileService.updateDriverBasicInfo(
      DriverBasicInfoModel.fromEntity(model),
    );
  }

  @override
  Future<Either<String, DriverDocumentsModel>> getDriverDocuments() {
    return _profileService.getDriverDocuments();
  }

  @override
  Future<Either<String, bool>> uploadDriverDocument(
    String file,
    String type,
    String expiryDate,
  ) {
    return _profileService.uploadDriverDocument(file, type, expiryDate);
  }

  @override
  Future<Either<String, bool>> renewDriverDocument(
    String documentId,
    String file,
    String expiryDate,
  ) {
    return _profileService.renewDriverDocument(documentId, file, expiryDate);
  }

  @override
  Future<Either<String, bool>> deleteDriverAccount() {
    return _profileService.deleteDriverAccount();
  }
}
