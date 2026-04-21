import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/driver_profile_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/driver_summary_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/request_categories_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/single_reques_model.dart';

abstract class HomeApiService {
  Future<Either<String, DriverProfileModel>> getDriverProfile();
  Future<Either<String, DriverSummaryModel>> getDriverSummary();
  Future<Either<String, RequestCategoriesModel>> getDriverRequestCategories(
    double driverLat,
    double driverLong,
  );
  Future<Either<String, bool>> rejectRequest(String requestId);
  Future<Either<String, bool>> sendDriverOffer(
    int requestId,
    int pricebyDriver,
    double locationLat,
    double locationLong,
  );
  Future<Either<String, SingleRequestModel>> getSingleRequest(
    int requestId,
    double lat,
    double long,
  );
}
