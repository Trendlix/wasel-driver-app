import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/address_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/driver_document_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/driver_legel_info_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<String, bool>> logout();
  Future<Either<String, ProfileEntity>> getProfile();
  Future<Either<String, ProfileEntity>> updaetUserProfile(
    ProfileEntity profileModel,
  );
  Future<Either<String, List<AddressEntity>>> getAdrdesses();
  Future<Either<String, bool>> addAddress(AddressEntity addressModel);
  Future<Either<String, bool>> deleteAddress(String id);
  Future<Either<String, bool>> updateAddress(AddressEntity model);
  Future<Either<String, bool>> changeUserPassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<String, DriverBasicInfoEntity>> getDriverBasicInfo();
  Future<Either<String, DriverBasicInfoEntity>> updateDriverBasicInfo(
    DriverBasicInfoEntity model,
  );
  Future<Either<String, DriverLegalInfoEntity>> getDriverLegalInfo();
  Future<Either<String, DriverDocumentsEntity>> getDriverDocuments();
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
