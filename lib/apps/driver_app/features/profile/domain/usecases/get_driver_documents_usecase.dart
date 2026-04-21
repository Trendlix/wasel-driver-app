import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/driver_document_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/repository/profile_repository.dart';

class GetDriverDocumentsUsecase {
  final ProfileRepository _profileRepository;

  GetDriverDocumentsUsecase(this._profileRepository);

  Future<Either<String, DriverDocumentsEntity>> call() async {
    return await _profileRepository.getDriverDocuments();
  }
}
