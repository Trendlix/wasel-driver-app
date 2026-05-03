import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/errors/handel_dio_errors.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/api_endpoints.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/driver_profile_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/driver_summary_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/request_categories_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/single_reques_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/services/home_api_service.dart';

class HomeApiServiceImp implements HomeApiService {
  final ApiClient? _apiClient;

  HomeApiServiceImp({required ApiClient? apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<String, DriverProfileModel>> getDriverProfile() async {
    try {
      final token = await GetIt.instance<LocalStorageService>().getToken();
      if (token == null) {
        return Left('No token found');
      }
      final res = await _apiClient!.get(
        ApiEndpoints.driverAccountStatusPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (res.isLeft) {
        return Left(res.left);
      } else {
        final response = res.right as Response;
        if (response.statusCode == 200) {
          return Right(DriverProfileModel.fromJson(response.data['data']));
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, DriverSummaryModel>> getDriverSummary() async {
    try {
      final token = await GetIt.instance<LocalStorageService>().getToken();
      if (token == null) {
        return Left('No token found');
      }
      final res = await _apiClient!.get(
        ApiEndpoints.driverSummaryPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (res.isLeft) {
        return Left(res.left);
      } else {
        final response = res.right as Response;
        if (response.statusCode == 200) {
          return Right(DriverSummaryModel.fromJson(response.data['data']));
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, RequestCategoriesModel>> getDriverRequestCategories(
    double driverLat,
    double driverLong,
  ) async {
    try {
      final token = await GetIt.instance<LocalStorageService>().getToken();
      if (token == null) {
        return Left('No token found');
      }
      final res = await _apiClient!.post(
        ApiEndpoints.driverRequestsPath,
        body: {'driver_lat': driverLat, 'driver_long': driverLong},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (res.isLeft) {
        return Left(res.left);
      } else {
        final response = res.right as Response;
        if (response.statusCode == 201) {
          return Right(RequestCategoriesModel.fromJson(response.data['data']));
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, bool>> rejectRequest(String requestId) async {
    try {
      final res = await _apiClient!.put(
        '${ApiEndpoints.driverRequestsPath}/$requestId/reject',
      );
      if (res.isLeft) {
        return Left(res.left);
      } else {
        final response = res.right as Response;
        if (response.statusCode == 200) {
          return Right(true);
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, bool>> sendDriverOffer(
    int requestId,
    int pricebyDriver,
    double locationLat,
    double locationLong,
  ) async {
    try {
      final res = await _apiClient!.post(
        ApiEndpoints.driverOfferPath,
        body: {
          'requestId': requestId,
          'price_by_driver': pricebyDriver,
          'driver_lat': locationLat,
          'driver_long': locationLong,
        },
      );
      if (res.isLeft) {
        return Left(res.left);
      } else {
        final response = res.right as Response;
        if (response.statusCode == 201) {
          return Right(true);
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, SingleRequestModel>> getSingleRequest(
    int requestId,
    double lat,
    double long,
  ) async {
    try {
      final token = await GetIt.instance<LocalStorageService>().getToken();
      if (token == null) {
        return Left('No token found');
      }
      final res = await _apiClient!.post(
        '${ApiEndpoints.driverRequestsPath}/$requestId',
        body: {'driver_lat': lat, 'driver_long': long},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (res.isLeft) {
        return Left(res.left);
      } else {
        final response = res.right as Response;
        if (response.statusCode == 201) {
          return Right(SingleRequestModel.fromJson(response.data['data']));
        } else {
          return Left(response.data['message']);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
