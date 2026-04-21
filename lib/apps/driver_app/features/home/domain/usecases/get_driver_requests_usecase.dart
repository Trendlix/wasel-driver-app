import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/request_categories_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/repositories/home_repository.dart';

class GetDriverRequestsUsecase {
  final HomeRepository? _homeRepository;

  GetDriverRequestsUsecase({required HomeRepository? homeRepository})
    : _homeRepository = homeRepository;

  Future<Either<String, RequestCategoriesEntity>> call(
    double driverLat,
    double driverLong,
  ) {
    return _homeRepository!.getDriverRequestCategories(driverLat, driverLong);
  }
}
