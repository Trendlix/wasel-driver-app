import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/driver_profile_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/driver_summary_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/request_categories_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/single_reques_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/services/home_api_service.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImp implements HomeRepository {
  final HomeApiService? _homeApiService;

  HomeRepositoryImp({required HomeApiService? homeApiService})
    : _homeApiService = homeApiService;
  @override
  Future<Either<String, DriverProfileModel>> getDriverProfile() {
    return _homeApiService!.getDriverProfile();
  }

  @override
  Future<Either<String, DriverSummaryModel>> getDriverSummary() {
    return _homeApiService!.getDriverSummary();
  }

  @override
  Future<Either<String, RequestCategoriesModel>> getDriverRequestCategories(
    double driverLat,
    double driverLong,
  ) {
    return _homeApiService!.getDriverRequestCategories(driverLat, driverLong);
  }

  @override
  Future<Either<String, bool>> rejectRequest(String requestId) {
    return _homeApiService!.rejectRequest(requestId);
  }

  @override
  Future<Either<String, bool>> sendDriverOffer(
    int requestId,
    int pricebyDriver,
    double locationLat,
    double locationLong,
  ) {
    return _homeApiService!.sendDriverOffer(
      requestId,
      pricebyDriver,
      locationLat,
      locationLong,
    );
  }

  @override
  Future<Either<String, SingleRequestModel>> getSingleRequest(
    int requestId,
    double lat,
    double long,
  ) {
    return _homeApiService!.getSingleRequest(requestId, lat, long);
  }
}
