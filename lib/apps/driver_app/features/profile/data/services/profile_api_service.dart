import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/address_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/driver_documents_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/driver_legel_info_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/profile_model.dart';

abstract class ProfileApiService {
  Future<Either<String, bool>> logout();
  Future<Either<String, ProfileModel>> getProfile();
  Future<Either<String, ProfileModel>> updaetUserProfile(
    ProfileModel profileModel,
  );

  Future<Either<String, List<AddressModel>>> getAddresses();
  Future<Either<String, bool>> addAddress(AddressModel addressModel);
  Future<Either<String, bool>> deleteAddress(String id);
  Future<Either<String, bool>> updateAddress(AddressModel model);
  Future<Either<String, bool>> changeUserPassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<String, DriverBasicInfoModel>> getDriverBasicInfo();
  Future<Either<String, DriverBasicInfoModel>> updateDriverBasicInfo(
    DriverBasicInfoModel model,
  );
  Future<Either<String, DriverLegalInfoModel>> getDriverLegalInfo();
  Future<Either<String, DriverDocumentsModel>> getDriverDocuments();
  Future<Either<String, bool>> uploadDriverDocument(
    String file,
    String type,
    String expiryDate,
  );
  Future<Either<String, bool>> renewDriverDocument(
    String documentId,
    String file,
    String expiryDate,
  );

  Future<Either<String, bool>> deleteDriverAccount();
}
