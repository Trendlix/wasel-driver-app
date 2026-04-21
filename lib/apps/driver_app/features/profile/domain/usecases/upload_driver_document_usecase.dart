import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class UploadDriverDocumentUsecase {
  final ProfileRepository _profileRepository;
  UploadDriverDocumentUsecase(this._profileRepository);

  Future<Either<String, bool>> call({
    required String file,
    required String type,
    required String expiryDate,
  }) async {
    return await _profileRepository.uploadDriverDocument(
      file,
      type,
      expiryDate,
    );
  }
}
