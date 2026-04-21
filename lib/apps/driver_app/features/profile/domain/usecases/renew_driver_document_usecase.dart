import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class RenewDriverDocumentUsecase {
  final ProfileRepository _profileRepository;
  RenewDriverDocumentUsecase(ProfileRepository profileRepository)
    : _profileRepository = profileRepository;

  Future<Either<String, bool>> call(
    String documentId,
    String file,
    String expiryDate,
  ) async {
    return await _profileRepository.renewDriverDocument(
      documentId,
      file,
      expiryDate,
    );
  }
}
