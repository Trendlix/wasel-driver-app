import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/repositories/home_repository.dart';

class RejectDriverRequestUsecase {
  final HomeRepository _homeRepository;

  RejectDriverRequestUsecase({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  Future<Either<String, bool>> call(String requestId) async {
    return await _homeRepository.rejectRequest(requestId);
  }
}
