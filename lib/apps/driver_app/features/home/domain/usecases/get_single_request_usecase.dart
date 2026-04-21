import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/single_request_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/repositories/home_repository.dart';

class GetSingleRequestUsecase {
  final HomeRepository _homeRepository;

  GetSingleRequestUsecase({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  Future<Either<String, SingleRequestEntity>> call(
    int requestId,
    double lat,
    double long,
  ) async {
    return await _homeRepository.getSingleRequest(requestId, lat, long);
  }
}
