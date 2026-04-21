import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/driver_profile_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/driver_summary_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/request_categories_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/single_request_entity.dart';

abstract class HomeRepository {
  Future<Either<String, DriverProfileModel>> getDriverProfile();
  Future<Either<String, DriverSummaryEntity>> getDriverSummary();
  Future<Either<String, RequestCategoriesEntity>> getDriverRequestCategories(
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
  Future<Either<String, SingleRequestEntity>> getSingleRequest(
    int requestId,
    double lat,
    double long,
  );
}
